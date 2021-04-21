codeunit 51513002 "Insurance management_life"
{
    // version AES-INS 1.0


    trigger OnRun();
    begin
    end;

    var
        BlankPos: Integer;
        LastLineNo: Integer;
        InsuranceSetup: Record "Insurance setup";
        CreditMemo: Record "Insure Header";
        IntegrationSetup: Record "Insurance Accounting Mappings";
        Cust: Record Customer;
        Contact: Record Contact;
        Text000: Label 'XXX';
        Text001: Label 'yyy';
        DEbetNote: Record "Insure Debit Note";
        EndorsementType: Record "Endorsement Types";
        InstalmentRatioRec: Record "Instalment Ratio";
        InsuranceDocs: Record "Insurance Documents";
        SMTP: Codeunit "SMTP Mail";
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[100];
        Subject: Text[100];
        Body: Text;
        InStreamTemplate: InStream;
        InSReadChar: Text[1];
        CharNo: Text[4];
        I: Integer;
        FromUser: Text[100];
        MailCreated: Boolean;
        Text040: Label 'You must import an Approval Template in Notification Template';

    procedure StandardizeNames(var OldName: Text[250]) NewName: Text[250];
    var
        NamePart1: Text[250];
        NamePart2: Text[250];
        NamePart3: Text[250];
        "1stLetterNamepart1": Text[30];
        restofletters: Text[30];
        "1stLetterNamwpart2": Text[30];
        restofletterspart2: Text[30];
        Blankpos2: Integer;
        "1stLetterNamwpart3": Text[30];
        restofletterspart3: Text[30];
    begin
        NewName := '';
        NamePart2 := '';
        NamePart1 := '';
        NamePart3 := '';

        BlankPos := STRPOS(OldName, ' ');
        IF BlankPos <> 0 THEN BEGIN
            NamePart1 := COPYSTR(OldName, 1, BlankPos);
            NamePart2 := COPYSTR(OldName, BlankPos + 1);
            Blankpos2 := STRPOS(NamePart2, ' ');

            IF Blankpos2 <> 0 THEN BEGIN
                //NamePart2:=COPYSTR(NamePart2,BlankPos+1,Blankpos2-BlankPos);
                NamePart3 := COPYSTR(NamePart2, Blankpos2 + 1);
            END;
        END
        ELSE BEGIN
            NamePart1 := COPYSTR(OldName, 1);
        END;

        "1stLetterNamepart1" := COPYSTR(NamePart1, 1, 1);
        restofletters := COPYSTR(NamePart1, 2);
        "1stLetterNamepart1" := UPPERCASE("1stLetterNamepart1");
        restofletters := LOWERCASE(restofletters);



        IF NamePart2 <> '' THEN BEGIN
            "1stLetterNamwpart2" := COPYSTR(NamePart2, 1, 1);
            restofletterspart2 := COPYSTR(NamePart2, 2);
            "1stLetterNamwpart2" := UPPERCASE("1stLetterNamwpart2");
            restofletterspart2 := LOWERCASE(restofletterspart2);

        END;


        IF NamePart3 <> '' THEN BEGIN
            "1stLetterNamwpart3" := COPYSTR(NamePart3, 1, 1);
            restofletterspart3 := COPYSTR(NamePart3, 2);
            "1stLetterNamwpart3" := UPPERCASE("1stLetterNamwpart3");
            restofletterspart3 := LOWERCASE(restofletterspart3);

        END;



        NewName := "1stLetterNamepart1" + restofletters + "1stLetterNamwpart2" + restofletterspart2 + "1stLetterNamwpart3" + restofletterspart3;
        EXIT(NewName);
    end;

    procedure InsertTaxesReinsurance(var InsureHeader: Record "Insure Header");
    var
        InsureLoadingsDisc: Record "Insure Header Loading_Discount";
        insureLines: Record "Insure Lines";
        LastLineNo: Integer;
        LoadingDisc: Record "Loading and Discounts Setup";
        IntegrationMapp: Record "Insurance Accounting Mappings";
        PartnerLines: Record "Coinsurance Reinsurance Lines";
        CommissionAmt: Decimal;
        WitholdingTax: Decimal;
        PolicyTypeRec: Record "Policy Type";
        AgentBrokerRec: Record Customer;
        VATSetup: Record "VAT Posting Setup";
        Paymentschedule: Record "Instalment Payment Plan";
    begin
        CheckValidity(InsureHeader);
        InsureHeader.TESTFIELD(InsureHeader."Policy Type");
        InsureHeader.TESTFIELD(InsureHeader."From Date");
        InsureHeader.TESTFIELD(InsureHeader."To Date");
        InsureHeader.TESTFIELD(InsureHeader."Cover Start Date");
        InsureHeader.TESTFIELD(InsureHeader."Cover End Date");
        InsureHeader.TESTFIELD(InsureHeader."No. Of Instalments");
        InsureHeader.TESTFIELD(InsureHeader."Agent/Broker");
        IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN
            IF EndorsementType."Requires Cancellation Reason" THEN
                IF InsureHeader."Cancellation Reason" = '' THEN
                    ERROR('Please select a cancellation/Endorsment reason');

        InsuranceDocs.RESET;
        InsuranceDocs.SETRANGE(InsuranceDocs."Document Type", InsureHeader."Document Type");
        InsuranceDocs.SETRANGE(InsuranceDocs."Document No", InsureHeader."No.");
        IF InsuranceDocs.FINDFIRST THEN
            REPEAT
                //MESSAGE('%1 and %2',InsuranceDocs."Document Type",InsuranceDocs."Document No");
                IF ((InsuranceDocs.Required = TRUE) AND (InsuranceDocs.Received = FALSE)) THEN
                    ERROR('Document %1 is required and has not been indicated as received please check if the document is available before proceeding', InsuranceDocs."Document Name");

            UNTIL InsuranceDocs.NEXT = 0;
        // Bkk -removed to facilitate direct Business InsureHeader.TESTFIELD(InsureHeader."Agent/Broker");

        insureLines.SETRANGE(insureLines."Document Type", InsureHeader."Document Type");
        insureLines.SETRANGE(insureLines."Document No.", InsureHeader."No.");
        insureLines.SETRANGE(insureLines."Description Type", insureLines."Description Type"::"Schedule of Insured");
        //insureLines.SETFILTER(insureLines."Risk ID",'<>%1',' ');
        IF insureLines.FINDFIRST THEN
            REPEAT
                // MESSAGE('Reg No %1 Gross Premium=%2',insureLines."Risk ID",insureLines."Gross Premium");
                IntegrationMapp.RESET;
                IntegrationMapp.SETRANGE(IntegrationMapp."Class Code", insureLines."Policy Type");
                IF IntegrationMapp.FINDFIRST THEN BEGIN
                    insureLines."Account Type" := insureLines."Account Type";
                    insureLines."Account No." := IntegrationMapp."Gross Premium Account";
                END;
                insureLines.VALIDATE(insureLines."Account No.");
                //MESSAGE('Account type %1 and Account no=%2',insureLines."Account Type",IntegrationMapp."Gross Premium Account");
                IF insureLines."No. Of Instalments" <> 0 THEN BEGIN
                    insureLines.VALIDATE(insureLines."Seating Capacity");
                    insureLines.MODIFY;
                END;


                insureLines.Description := InsureHeader."Insured Name" + ' ' + FORMAT(InsureHeader."Quote Type");
                insureLines.CALCFIELDS(insureLines."Extra Premium");
                /*IF InsureHeader."No. Of Months"=0 THEN
                insureLines.Amount:=insureLines."Gross Premium"+insureLines."Extra Premium"+insureLines."TPO Premium"
                ELSE
                insureLines.Amount:=(insureLines."Gross Premium"*(InsureHeader."Short term Cover Percent"/100))+insureLines."Extra Premium"+
                (insureLines."TPO Premium"*InsureHeader."No. Of Months");*/
                IF InsureHeader."Premium Calculation Basis" = InsureHeader."Premium Calculation Basis"::"Full Premium" THEN
                    insureLines.Amount := insureLines."Gross Premium" + insureLines."Extra Premium" + insureLines."TPO Premium" + insureLines.PLL + insureLines.Medical;

                IF InsureHeader."Premium Calculation Basis" = InsureHeader."Premium Calculation Basis"::"Pro-rata" THEN
                    insureLines.Amount := (insureLines."Gross Premium" + insureLines."Extra Premium" + insureLines."TPO Premium" + insureLines.PLL + insureLines.Medical) * InsureHeader."Mid Term Adjustment Factor";

                IF InsureHeader."Premium Calculation Basis" = InsureHeader."Premium Calculation Basis"::"Short term" THEN
                    insureLines.Amount := (insureLines."Gross Premium" + insureLines."Extra Premium" + insureLines."TPO Premium" + insureLines.PLL + insureLines.Medical) *
                    (InsureHeader."Short term Cover Percent" / 100);


                IF InsureHeader."Action Type" = InsureHeader."Action Type"::"Yellow Card" THEN
                    insureLines.Amount := (insureLines."Gross Premium" + insureLines."Extra Premium" + insureLines."TPO Premium" + insureLines.PLL) * (InsureHeader."Short term Cover Percent" / 100)
                     + insureLines.Medical;

                // MESSAGE('Comp. premium =%1 and TPO=%2',insureLines."Gross Premium"*(InsureHeader."Short term Cover Percent"/100),(insureLines."TPO Premium"*InsureHeader."No. Of Months"));
                /*IF insureLines.Status=insureLines.Status::Live THEN
                insureLines.Amount:=-insureLines.Amount;*/

                //Draw paymemt schedule


                IF PolicyTypeRec.GET(InsureHeader."Policy Type") THEN
                    IF PolicyTypeRec.Comprehensive THEN
                        DrawPaymentScheduleComp(InsureHeader)
                    ELSE
                        DrawPaymentSchedule(InsureHeader);


                //Apply Instalment ratio if it exists on the setup for the policy in question


                /*InstalmentRatioRec.RESET;
                InstalmentRatioRec.SETRANGE(InstalmentRatioRec."Policy Type",insureLines."Policy Type");
                InstalmentRatioRec.SETRANGE(InstalmentRatioRec."Instalment No",InsureHeader."Instalment No.");
                InstalmentRatioRec.SETRANGE(InstalmentRatioRec."No. Of Instalments",InsureHeader."No. Of Instalments");
                IF InstalmentRatioRec.FINDLAST THEN
                BEGIN
                //MESSAGE('Instalment Ratio set');
                IF InstalmentRatioRec.Percentage=0 THEN
                ERROR('Please specify the percentage ratio for %1 instalment plan',insureLines."Policy Type");
                insureLines.Amount:=(insureLines."Gross Premium"+insureLines."Extra Premium"+insureLines."TPO Premium"+insureLines.PLL)*
                 (InstalmentRatioRec.Percentage/100);
                END;*/
                Paymentschedule.RESET;
                Paymentschedule.SETRANGE(Paymentschedule."Document Type", InsureHeader."Document Type");
                Paymentschedule.SETRANGE(Paymentschedule."Document No.", InsureHeader."No.");
                Paymentschedule.SETRANGE(Paymentschedule."Payment No", InsureHeader."Instalment No.");
                IF Paymentschedule.FINDLAST THEN BEGIN
                    //MESSAGE('Instalment Ratio set');
                    IF PolicyTypeRec.Comprehensive THEN BEGIN
                        IF Paymentschedule."Instalment Percentage" = 0 THEN
                            ERROR('Please specify the percentage ratio for %1 instalment plan', InsureHeader."No.");
                        insureLines.Amount := (insureLines."Gross Premium" + insureLines."Extra Premium" + insureLines."TPO Premium" + insureLines.PLL) *
                         (Paymentschedule."Instalment Percentage" / 100);
                    END;
                END;

                IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN
                    IF EndorsementType."Premium Calculation basis" = EndorsementType."Premium Calculation basis"::" " THEN
                        insureLines.Amount := 0;

                insureLines.VALIDATE(Amount);

                insureLines."Endorsement Type" := InsureHeader."Endorsement Type";
                insureLines."Action Type" := InsureHeader."Action Type";
                insureLines."Insured No." := InsureHeader."Insured No.";
                insureLines."Insured Name" := InsureHeader."Insured Name";

                insureLines.MODIFY;
            UNTIL insureLines.NEXT = 0;







        InsureHeader.CALCFIELDS(InsureHeader."Total Premium Amount", InsureHeader."Total Sum Insured");
        //MESSAGE('%1',InsureHeader."Total Premium Amount");
        insureLines.RESET;
        insureLines.SETRANGE(insureLines."Document Type", InsureHeader."Document Type");
        insureLines.SETRANGE(insureLines."Document No.", InsureHeader."No.");
        insureLines.SETRANGE(insureLines."Description Type", insureLines."Description Type"::Tax);
        insureLines.DELETEALL;

        insureLines.RESET;
        insureLines.SETRANGE(insureLines."Document Type", InsureHeader."Document Type");
        insureLines.SETRANGE(insureLines."Document No.", InsureHeader."No.");
        IF insureLines.FINDLAST THEN
            LastLineNo := insureLines."Line No.";





        InsureLoadingsDisc.RESET;
        InsureLoadingsDisc.SETRANGE(InsureLoadingsDisc."Document Type", InsureHeader."Document Type");
        InsureLoadingsDisc.SETRANGE(InsureLoadingsDisc."No.", InsureHeader."No.");
        IF InsureLoadingsDisc.FINDFIRST THEN
            REPEAT
                IF InsureLoadingsDisc."Loading %" <> 0 THEN
                    InsureLoadingsDisc.Amount := (InsureLoadingsDisc."Loading %" / 100) * InsureHeader."Total Premium Amount";

                IF InsureLoadingsDisc."Loading Amount" <> 0 THEN BEGIN
                    IF InstalmentRatioRec.Percentage <> 0 THEN
                        InsureLoadingsDisc.Amount := InsureLoadingsDisc."Loading Amount" * (InstalmentRatioRec.Percentage / 100)
                    ELSE
                        InsureLoadingsDisc.Amount := InsureLoadingsDisc."Loading Amount";
                END;
                IF InsureLoadingsDisc."Discount %" <> 0 THEN
                    InsureLoadingsDisc.Amount := -(InsureLoadingsDisc."Discount %" / 100) * InsureHeader."Total Premium Amount";

                IF InsureLoadingsDisc."Discount Amount" <> 0 THEN
                    InsureLoadingsDisc.Amount := -InsureLoadingsDisc."Discount Amount";

                insureLines.INIT;
                insureLines."Document Type" := InsureHeader."Document Type";
                insureLines."Document No." := InsureHeader."No.";
                LastLineNo := LastLineNo + 10000;
                insureLines."Line No." := LastLineNo;
                insureLines.Description := InsureLoadingsDisc.Description;
                insureLines.Amount := InsureLoadingsDisc.Amount;
                insureLines."Description Type" := insureLines."Description Type"::Tax;
                IF LoadingDisc.GET(InsureLoadingsDisc.Code) THEN BEGIN
                    insureLines."Account Type" := LoadingDisc."Account Type";
                    insureLines."Account No." := LoadingDisc."Account No.";
                    insureLines.VALIDATE(insureLines."Account No.");


                END;
                insureLines.Tax := TRUE;
                insureLines.VALIDATE(Amount);
                IF insureLines.Amount <> 0 THEN
                    insureLines.INSERT;

            UNTIL InsureLoadingsDisc.NEXT = 0;




        InsuranceSetup.GET;
        IF InsureHeader."Agent/Broker" <> '' THEN BEGIN
            CommissionAmt := ROUND(InsureHeader."Total Premium Amount" * (InsureHeader."Commission Due" / 100), 1);
            IF InsureHeader."Total Premium Amount" <> 0 THEN BEGIN
                IF CommissionAmt = 0 THEN
                    ERROR('Please Check on Commission Percentage definition');
            END;
            IF AgentBrokerRec.GET(InsureHeader."Agent/Broker") THEN
                IF VATSetup.GET(AgentBrokerRec."VAT Bus. Posting Group", InsuranceSetup."Default WHT Code") THEN
                    WitholdingTax := ROUND(((VATSetup."VAT %" / 100) * CommissionAmt), 1);
            PartnerLines.RESET;
            PartnerLines.SETRANGE(PartnerLines."Document Type", InsureHeader."Document Type");
            PartnerLines.SETRANGE(PartnerLines."No.", InsureHeader."No.");
            PartnerLines.DELETEALL;

            PartnerLines.INIT;
            PartnerLines."Document Type" := InsureHeader."Document Type";
            PartnerLines."No." := InsureHeader."No.";
            PartnerLines."Transaction Type" := PartnerLines."Transaction Type"::"Broker ";
            PartnerLines."Account Type" := PartnerLines."Account Type"::"G/L Account";
            PartnerLines."Partner No." := InsureHeader."Agent/Broker";
            //PartnerLines."Account No.":=InsuranceSetup."Withholding Tax Account";
            //MESSAGE('%1',InsureHeader."Agent/Broker");
            PartnerLines.VALIDATE(PartnerLines."Partner No.");
            PartnerLines."Broker Commission" := CommissionAmt;
            PartnerLines."WHT Amount" := WitholdingTax;

            PartnerLines.INSERT;
        END;
        GetTreatyPremiumNew(InsureHeader);

    end;

    procedure InsertTaxation(var SalesHeadr: Record "Insure Header");
    var
        SalesLineRec: Record "Insure Lines";
        TotalGrossPremium: Decimal;
        InsuranceTaxes: Record "Loading and Discounts Setup";
        InsureHeaderLoadingDisc: Record "Insure Header Loading_Discount";
    begin
        ValidationOnFirmOrder(SalesHeadr);
        TotalGrossPremium := 0;



        SalesHeadr.CALCFIELDS(SalesHeadr."Total Premium Amount", SalesHeadr."Total  Discount Amount");
        TotalGrossPremium := SalesHeadr."Total Premium Amount" - SalesHeadr."Total  Discount Amount";

        /*SalesLineRec.RESET;
        SalesLineRec.SETRANGE(SalesLineRec."Document Type",SalesHeadr."Document Type");
        SalesLineRec.SETRANGE(SalesLineRec."Document No.",SalesHeadr."No.");
        //SalesLineRec.SETFILTER(SalesLineRec.Quantity,'<>%1',0);
        SalesLineRec.SETFILTER(SalesLineRec."Description Type",'<>%1',SalesLineRec."Description Type"::"Schedule of Insured");
        SalesLineRec.DELETEALL; */

        SalesLineRec.RESET;
        SalesLineRec.SETRANGE(SalesLineRec."Document Type", SalesHeadr."Document Type");
        SalesLineRec.SETRANGE(SalesLineRec."Document No.", SalesHeadr."No.");
        IF SalesLineRec.FIND('+') THEN
            LastLineNo := SalesLineRec."Line No.";


        InsuranceTaxes.RESET;
        InsuranceTaxes.SETRANGE(InsuranceTaxes.Tax, TRUE);
        IF SalesHeadr."Quote Type" = SalesHeadr."Quote Type"::New THEN BEGIN
            InsuranceTaxes.SETFILTER(InsuranceTaxes."Applicable to", '<>%1', InsuranceTaxes."Applicable to"::Renewals);

        END;

        IF SalesHeadr."Quote Type" = SalesHeadr."Quote Type"::Renewal THEN BEGIN
            InsuranceTaxes.SETFILTER(InsuranceTaxes."Applicable to", '<>%1', InsuranceTaxes."Applicable to"::New);

        END;

        IF InsuranceTaxes.FIND('-') THEN
            REPEAT

                SalesLineRec.INIT;
                SalesLineRec."Document Type" := SalesHeadr."Document Type";
                SalesLineRec."Document No." := SalesHeadr."No.";
                LastLineNo := LastLineNo + 10000;
                SalesLineRec."Line No." := LastLineNo + 10000;
                //SalesLineRec."Sell-to Customer No.":=SalesHeadr."Sell-to Customer No.";
                IF InsuranceTaxes."Account Type" = InsuranceTaxes."Account Type"::Vendor THEN BEGIN
                    SalesLineRec."Account No." := SalesHeadr."Agent/Broker";
                    SalesLineRec."Account Type" := InsuranceTaxes."Account Type";
                END
                ELSE BEGIN
                    SalesLineRec."Account Type" := InsuranceTaxes."Account Type";

                    SalesLineRec."Account No." := InsuranceTaxes."Account No.";
                END;


                IF InsuranceTaxes."Calculation Method" = InsuranceTaxes."Calculation Method"::"% of Gross Premium" THEN
                    SalesLineRec.Amount := ROUND((InsuranceTaxes."Loading Percentage" / 100) * TotalGrossPremium, 1);
                IF InsuranceTaxes."Calculation Method" = InsuranceTaxes."Calculation Method"::"Flat Amount" THEN
                    SalesLineRec.Amount := InsuranceTaxes."Loading Amount";
                SalesLineRec.Description := InsuranceTaxes.Description;
                SalesLineRec.Tax := InsuranceTaxes.Tax;
                SalesLineRec."Description Type" := SalesLineRec."Description Type"::Tax;
                IF SalesLineRec.Amount <> 0 THEN
                    SalesLineRec.INSERT;

            UNTIL InsuranceTaxes.NEXT = 0;
        GetTreatyPremium(SalesHeadr);

    end;

    procedure CommissionCalculation(var SalesHeader: Record "Insure Header");
    var
        GenJnline: Record "Gen. Journal Line";
        InsuranceSetup: Record "Insurance setup";
        WitholdingTax: Decimal;
        CommissionAmt: Decimal;
        GenJnlineCopy: Record "Gen. Journal Line";
        LineNo: Integer;
        PostGnjnline: Codeunit "Gen. Jnl.-Post Line";
        TotalPremium: Decimal;
        PolicyRec: Record "Insurance setup";
    begin
        /*InsuranceSetup.GET;
        
        IF SalesHeader."Document Type"=SalesHeader."Document Type"::Order THEN
        BEGIN
        
        SalesHeader.CALCFIELDS(SalesHeader."Total Premium Amount");
        
        CommissionAmt:=ROUND(SalesHeader."Total Premium Amount"*(SalesHeader."Commission Due"/100),1);
        
        IF CommissionAmt=0 THEN
        ERROR('Please Check on Commission Percentage definition');
        
        WitholdingTax:=ROUND(((InsuranceSetup."Witholding Tax % age"/100)*CommissionAmt),1);
        
              //Create Commissions Cr-Commissios Received account
            //Dr-Underwriter
            InsuranceSetup.GET;
             GenJnline.INIT;
             GenJnline."Journal Template Name":='GENERAL';
             GenJnline."Journal Batch Name":='COMMISS';
             GenJnlineCopy.RESET;
             GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Template Name",GenJnline."Journal Template Name");
             GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Batch Name",GenJnline."Journal Batch Name");
             IF GenJnlineCopy.FIND('+') THEN
             LineNo:=GenJnlineCopy."Line No.";
        
        
             GenJnline."Line No.":=LineNo+10000;
             GenJnline."Account Type":=GenJnline."Account Type"::Vendor;
             GenJnline."Account No.":=SalesHeader.Underwriter;
             GenJnline."Transaction Type":= GenJnline."Transaction Type"::Commission;
             GenJnline."Posting Date":=SalesHeader."Posting Date";
             GenJnline."Currency Factor":=SalesHeader."Currency Factor";
             MESSAGE('C Factor = %1',SalesHeader."Currency Factor");
        
             GenJnline."Document No.":=PolicyRec."Posting No.";
             GenJnline.Description:='Commission';
             GenJnline.Amount:=CommissionAmt;
             GenJnline."Bal. Account Type":=GenJnline."Bal. Account Type"::"G/L Account";
             GenJnline."Bal. Account No.":=InsuranceSetup."Commission Received";
             GenJnline.INSERT;
             PostGnjnline.RUN(GenJnline);
        
             GenJnline.INIT;
             GenJnline."Journal Template Name":='GENERAL';
             GenJnline."Journal Batch Name":='WITH-TAX';
             GenJnlineCopy.RESET;
             GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Template Name",GenJnline."Journal Template Name");
             GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Batch Name",GenJnline."Journal Batch Name");
             IF GenJnlineCopy.FIND('+') THEN
             LineNo:=GenJnlineCopy."Line No.";
        
        
             GenJnline."Line No.":=LineNo+10000;
             GenJnline."Account Type":=GenJnline."Account Type"::Vendor;
             GenJnline."Account No.":=SalesHeader.Underwriter;
             GenJnline."Posting Date":=SalesHeader."Posting Date";
             GenJnline."Currency Factor":=SalesHeader."Currency Factor";
             MESSAGE('C1 Factor = %1',SalesHeader."Currency Factor");
             GenJnline."Transaction Type":= GenJnline."Transaction Type"::Commission;
             GenJnline."Document No.":=PolicyRec."Posting No.";
             GenJnline.Description:='Witholding Tax';
             GenJnline.Amount:=-WitholdingTax;
             GenJnline."Bal. Account Type":=GenJnline."Bal. Account Type"::"G/L Account";
             GenJnline."Bal. Account No.":=InsuranceSetup."Withholding Tax Account";
             GenJnline.INSERT;
        
             PostGnjnline.RUN(GenJnline);
        
        
            END;
        
        
         // Reverse-recall commissions on Credit Notes
        
        IF SalesHeader."Document Type"=SalesHeader."Document Type"::"Credit Memo" THEN
        BEGIN
        SalesHeader.CALCFIELDS(SalesHeader."Total Premium Amount");
        MESSAGE('Processing credit note %1',SalesHeader."Total Premium Amount");
        
        CommissionAmt:=-ROUND(SalesHeader."Total Premium Amount"*(SalesHeader."Commission Due"/100),1);
        
        IF CommissionAmt=0 THEN
        ERROR('Please Check on Commission Percentage definition');
        WitholdingTax:=ROUND(((InsuranceSetup."Witholding Tax % age"/100)*CommissionAmt),1);
        
              //Create Commissions Cr-Commissios Received account
            //Dr-Underwriter
            InsuranceSetup.GET;
             GenJnline.INIT;
             GenJnline."Journal Template Name":='GENERAL';
             GenJnline."Journal Batch Name":='COMMISS';
             GenJnlineCopy.RESET;
             GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Template Name",GenJnline."Journal Template Name");
             GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Batch Name",GenJnline."Journal Batch Name");
             IF GenJnlineCopy.FIND('+') THEN
             LineNo:=GenJnlineCopy."Line No.";
        
        
             GenJnline."Line No.":=LineNo+10000;
             GenJnline."Account Type":=GenJnline."Account Type"::Vendor;
             GenJnline."Account No.":=SalesHeader.Underwriter;
             GenJnline."Transaction Type":= GenJnline."Transaction Type"::Commission;
             GenJnline."Posting Date":=SalesHeader."Posting Date";
             GenJnline."Currency Factor":=SalesHeader."Currency Factor";
             MESSAGE('C2 Factor = %1',SalesHeader."Currency Factor");
             GenJnline."Document No.":=PolicyRec."Posting No.";
             GenJnline.Description:='Commission';
             GenJnline.Amount:=CommissionAmt;
             GenJnline."Bal. Account Type":=GenJnline."Bal. Account Type"::"G/L Account";
             GenJnline."Bal. Account No.":=InsuranceSetup."Commission Received";
             GenJnline.INSERT;
             PostGnjnline.RUN(GenJnline);
        
             GenJnline.INIT;
             GenJnline."Journal Template Name":='GENERAL';
             GenJnline."Journal Batch Name":='WITH-TAX';
             GenJnlineCopy.RESET;
             GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Template Name",GenJnline."Journal Template Name");
             GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Batch Name",GenJnline."Journal Batch Name");
             IF GenJnlineCopy.FIND('+') THEN
             LineNo:=GenJnlineCopy."Line No.";
        
        
             GenJnline."Line No.":=LineNo+10000;
             GenJnline."Account Type":=GenJnline."Account Type"::Vendor;
             GenJnline."Account No.":=SalesHeader.Underwriter;
             GenJnline."Posting Date":=SalesHeader."Posting Date";
             GenJnline."Currency Factor":=SalesHeader."Currency Factor";
             MESSAGE('C3 Factor = %1',SalesHeader."Currency Factor");
             GenJnline."Transaction Type":= GenJnline."Transaction Type"::Commission;
             GenJnline."Document No.":=PolicyRec."Posting No.";
             GenJnline.Description:='Witholding Tax';
             GenJnline.Amount:=-WitholdingTax;
             GenJnline."Bal. Account Type":=GenJnline."Bal. Account Type"::"G/L Account";
             GenJnline."Bal. Account No.":=InsuranceSetup."Withholding Tax Account";
             GenJnline.INSERT;
        
             PostGnjnline.RUN(GenJnline);
        
        
            END;  */

    end;

    procedure CalculateMidTermFactor(var InsHeader: Record "Insure Header") midTermfactor: Decimal;
    var
        InSetup: Record "Insurance setup";
        NoOfINstalmentRec: Record "No. of Instalments";
        NoOfDaysInPeriod: Integer;
    begin

        InSetup.GET;

        NoOfDaysInPeriod := (InsHeader."Cover End Date" - InsHeader."Original Cover Start Date") + 1;

        IF NoOfDaysInPeriod <> 0 THEN
            midTermfactor := ((InsHeader."Cover End Date" - InsHeader."Document Date") + 1) / NoOfDaysInPeriod;

        EXIT(midTermfactor);

    end;

    procedure ValidationOnFirmOrder(var SalesHeader: Record "Insure Header");
    var
        SaleslineRec: Record "Insure Lines";
        InsIntergrationMapping: Record "Insurance Accounting Mappings";
    begin
        /*InsIntergrationMapping.GET;
        SaleslineRec.RESET;
        SaleslineRec.SETRANGE(SaleslineRec."Document Type",SalesHeader."Document Type");
        SaleslineRec.SETRANGE(SaleslineRec."Document No.",SalesHeader."No.");
        SaleslineRec.SETRANGE(SaleslineRec."Description Type",SaleslineRec."Description Type"::"Schedule of Insured");
        IF SaleslineRec.FIND('-') THEN
        REPEAT
           IF SaleslineRec."Gross Premium"<>0 THEN
           BEGIN
           InsuranceSetup.GET;
        
           SaleslineRec.Type:=SaleslineRec.Type::"G/L Account";
           SaleslineRec."No.":=InsIntergrationMapping."Premium G/L Account";
           SaleslineRec."Gen. Bus. Posting Group":=InsuranceSetup."Default Bus. Posting Group";
           SaleslineRec."Gen. Prod. Posting Group":=InsuranceSetup."Default Prod. Posting Group";
           SaleslineRec."VAT Bus. Posting Group":=InsuranceSetup."Default VAT Bus. Posting Group";
           SaleslineRec."VAT Prod. Posting Group":=InsuranceSetup."Default VAT Pro. Posting Group";
           SaleslineRec.VALIDATE(SaleslineRec."Rate %age");
           SaleslineRec.MODIFY;
           //MESSAGE('Rate=%1 and Gross Premium=%2',SaleslineRec."Rate %age",SaleslineRec."Gross Premium");
           END;
        
        UNTIL SaleslineRec.NEXT=0; */

    end;

    procedure CalculateMidTermFactorMIC(var ToDate: Date; var AdjustmentDate: Date) midTermfactor: Decimal;
    var
        PolicyHeader: Record "Insure Header";
        InSetup: Record "Insurance setup";
    begin

        InSetup.GET;

        IF InSetup."No. of Days in a Year" <> 0 THEN
            midTermfactor := ((ToDate - AdjustmentDate) + 1) / InSetup."No. of Days in a Year";
        //MESSAGE('TESTING %1',midTermfactor);
        EXIT(midTermfactor);
    end;

    procedure PostClaims(var Claim: Record Claim);
    var
        Isetup: Record "Insurance setup";
        ClaimsLines: Record "Claim Lines";
        GenJnLine: Record "Gen. Journal Line";
        LineNo: Integer;
        PolicyHeader: Record "Sales Header";
        GLEntry: Record "G/L Entry";
        Batch: Record "Gen. Journal Batch";
    begin

        IF CONFIRM('Are you sure u want post Claim no ' + Claim."Claim No" + ' ?', FALSE) = TRUE THEN BEGIN
            //IF Claim.Status<>Claim.Status::Released THEN
            //   ERROR('The Claim no '+Rec.ClaimNumber+' has not been fully approved\Check that the status is released');
            Claim.CALCFIELDS(Claim."Reserve Amount");
            //IF Claim.GrossAmount=0 THEN
            //  ERROR('Amount cannot be zero');
            //Claim.TESTFIELD(Claim.Policy);
            Isetup.GET;

            //Delete any lines available on the Journal Lines
            GenJnLine.RESET;
            GenJnLine.SETRANGE(GenJnLine."Journal Template Name", Isetup."Insurance Template");
            GenJnLine.SETRANGE(GenJnLine."Journal Batch Name", Claim."Claim No");
            GenJnLine.DELETEALL;

            Batch.INIT;
            Batch."Journal Template Name" := Isetup."Insurance Template";
            Batch.Name := Claim."Claim No";
            IF NOT Batch.GET(Batch."Journal Template Name", Batch.Name) THEN
                Batch.INSERT;
            // Get Treaty Details
            //GetTreaty(Rec);
            //*********//
            IntegrationSetup.RESET;
            IF IntegrationSetup.FINDFIRST THEN BEGIN



                LineNo := LineNo + 10000;
                GenJnLine.INIT;
                GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                GenJnLine."Journal Batch Name" := Claim."Claim No";
                GenJnLine."Line No." := LineNo;
                GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                GenJnLine."Account No." := IntegrationSetup."Claim Reserve";
                GenJnLine.VALIDATE(GenJnLine."Account No.");
                GenJnLine."Posting Date" := TODAY;
                GenJnLine."Document No." := Claim."Claim No";
                GenJnLine.Description := 'Claims for ' + FORMAT(Claim."Policy No");

                GenJnLine."Bal. Account No." := IntegrationSetup."Claims Reserves OS";
                GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                GenJnLine.Amount := Claim."Reserve Amount";
                GenJnLine.VALIDATE(GenJnLine.Amount);
                GenJnLine."External Document No." := Claim."Policy No";
                IF GenJnLine.Amount <> 0 THEN
                    GenJnLine.INSERT;

                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnLine);

                GLEntry.RESET;
                GLEntry.SETRANGE(GLEntry."Document No.", Claim."Claim No");
                GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
                IF GLEntry.FINDFIRST THEN BEGIN

                    Claim.MODIFY(TRUE);
                END;
            END;
        END;
    end;

    procedure GetTreaty(var Claim: Record Claim);
    var
        ClaimsLines: Record "Claim Lines";
        Treaty: Record Treaty;
        PolicyRec: Record "Insure Header";
        TreatyReinsuranceShare: Record "Treaty Reinsurance Share";
        LineNo: Integer;
    begin
        Claim.CALCFIELDS(Claim."Premium Balance", Claim."Excess Amount");
        //Get Line Numbers
        ClaimsLines.RESET();
        ClaimsLines.SETRANGE(ClaimsLines."Claim No", Claim."Claim No");
        ClaimsLines.SETFILTER(ClaimsLines."Claim Amount", '<>%1', 0);
        IF ClaimsLines.FINDLAST THEN
            LineNo := ClaimsLines."Line No";

        IF Treaty.GET(Claim.TreatyNumber, Claim."Addendum Code") THEN
            TreatyReinsuranceShare.SETRANGE(TreatyReinsuranceShare."Treaty Code", Treaty."Treaty Code");
        TreatyReinsuranceShare.SETRANGE(TreatyReinsuranceShare."Addendum Code", Treaty."Addendum Code");
        IF TreatyReinsuranceShare.FINDFIRST THEN BEGIN
            REPEAT
                IF Treaty."Apportionment Type" = Treaty."Apportionment Type"::"Non-proportional" THEN BEGIN
                    IF Treaty."Exess of loss" THEN
                        IF TreatyReinsuranceShare."Excess of loss" THEN
                            IF PolicyRec.GET(PolicyRec."Document Type"::Policy, Claim."Policy No") THEN
                                IF PolicyRec."Total Sum Insured" > Treaty."Limit Of Indemnity" THEN BEGIN
                                    IF Claim."Premium Balance" > Treaty."Limit Of Indemnity" THEN BEGIN
                                        //Apportion the firm's claims
                                        ClaimsLines.RESET();
                                        ClaimsLines.SETRANGE(ClaimsLines."Claim No", Claim."Claim No");
                                        ClaimsLines.SETFILTER(ClaimsLines."Claim Amount", '<>%1', 0);
                                        IF ClaimsLines.FINDFIRST THEN BEGIN
                                            REPEAT
                                                //Modify the firm's claim
                                                ClaimsLines."Claim Amount" := Treaty."Limit Of Indemnity";
                                                ClaimsLines.VALIDATE("Claim Amount");
                                                ClaimsLines.MODIFY(TRUE);

                                                //Insert Reinsurer Claim Lines
                                                LineNo := LineNo + 1000;
                                                ClaimsLines.INIT;
                                                ClaimsLines."Claim No" := Claim."Claim No";
                                                ClaimsLines."Line No" := LineNo;
                                                ClaimsLines.Type := ClaimsLines.Type::Vendor;
                                                ClaimsLines.No := TreatyReinsuranceShare."Re-insurer code";
                                                ClaimsLines.VALIDATE(No);
                                                ClaimsLines.Description := 'CLAIM PAYMENT';
                                                ClaimsLines."Claim Amount" := Claim."Premium Balance" - Treaty."Limit Of Indemnity";
                                                ClaimsLines.VALIDATE(ClaimsLines."Claim Amount");
                                                IF NOT ClaimsLines.GET(Claim."Claim No", ClaimsLines."Line No") THEN
                                                    ClaimsLines.INSERT(TRUE);

                                            UNTIL
                                            ClaimsLines.NEXT = 0;
                                        END;
                                    END;
                                END;
                END ELSE
                    IF Treaty."Apportionment Type" = Treaty."Apportionment Type"::Proportional THEN BEGIN
                        IF Treaty."Quota Share" THEN
                            IF TreatyReinsuranceShare."Quota Share" THEN BEGIN
                                IF Claim."Premium Balance" <= Treaty."Quota share Retention" THEN BEGIN
                                    //Apportion the firm's claims
                                    ClaimsLines.RESET();
                                    ClaimsLines.SETRANGE(ClaimsLines."Claim No", Claim."Claim No");
                                    ClaimsLines.SETFILTER(ClaimsLines."Claim Amount", '<>%1', 0);
                                    IF ClaimsLines.FINDFIRST THEN BEGIN
                                        REPEAT
                                            //Modify the firm's claim
                                            ClaimsLines."Claim Amount" := ClaimsLines."Claim Amount" * Treaty."Insurer quota percentage" / 100;
                                            ClaimsLines.VALIDATE("Claim Amount");
                                            IF (Treaty."Insurer quota percentage" / 100) = (ClaimsLines."Claim Amount" / Claim."Premium Balance") THEN
                                                ClaimsLines.MODIFY(TRUE);

                                            //Insert Reinsurer Claim Lines
                                            LineNo := LineNo + 1000;
                                            ClaimsLines.INIT;
                                            ClaimsLines."Claim No" := Claim."Claim No";
                                            ClaimsLines."Line No" := LineNo;
                                            ClaimsLines.Type := ClaimsLines.Type::Vendor;
                                            ClaimsLines.No := TreatyReinsuranceShare."Re-insurer code";
                                            ClaimsLines.VALIDATE(No);
                                            ClaimsLines.Description := 'CLAIM PAYMENT';
                                            ClaimsLines."Claim Amount" := Claim."Premium Balance" * TreatyReinsuranceShare."Percentage %" / 100;
                                            ClaimsLines.VALIDATE(ClaimsLines."Claim Amount");
                                            ClaimsLines.INSERT(TRUE);

                                        UNTIL
                                        ClaimsLines.NEXT = 0;
                                    END;
                                END ELSE
                                    IF Claim."Premium Balance" > Treaty."Quota share Retention" THEN BEGIN
                                        //Apportion the firm's claims
                                        ClaimsLines.RESET();
                                        ClaimsLines.SETRANGE(ClaimsLines."Claim No", Claim."Claim No");
                                        ClaimsLines.SETFILTER(ClaimsLines."Claim Amount", '<>%1', 0);
                                        IF ClaimsLines.FINDFIRST THEN BEGIN
                                            REPEAT
                                                //Modify the firm's claim
                                                ClaimsLines."Claim Amount" := Treaty."Quota share Retention" * Treaty."Insurer quota percentage" / 100;
                                                ClaimsLines.VALIDATE("Claim Amount");
                                                IF (Treaty."Insurer quota percentage" / 100) = (ClaimsLines."Claim Amount" / Treaty."Quota share Retention") THEN
                                                    ClaimsLines.MODIFY(TRUE);

                                                //Insert Reinsurer Claim Lines
                                                LineNo := LineNo + 1000;
                                                ClaimsLines.INIT;
                                                ClaimsLines."Claim No" := Claim."Claim No";
                                                ClaimsLines."Line No" := LineNo;
                                                ClaimsLines.Type := ClaimsLines.Type::Vendor;
                                                ClaimsLines.No := TreatyReinsuranceShare."Re-insurer code";
                                                ClaimsLines.VALIDATE(No);
                                                ClaimsLines.Description := 'CLAIM PAYMENT';
                                                ClaimsLines."Claim Amount" := Treaty."Quota share Retention" * TreatyReinsuranceShare."Percentage %" / 100;
                                                ClaimsLines.VALIDATE(ClaimsLines."Claim Amount");
                                                ClaimsLines.INSERT(TRUE);

                                            UNTIL
                                             ClaimsLines.NEXT = 0;
                                        END;
                                    END;
                            END;
                        IF Claim."Premium Balance" > Treaty."Quota share Retention" THEN
                            IF Treaty.Surplus THEN
                                IF TreatyReinsuranceShare.Surplus THEN BEGIN
                                    ClaimsLines.RESET();
                                    ClaimsLines.SETRANGE(ClaimsLines."Claim No", Claim."Claim No");
                                    ClaimsLines.SETFILTER(ClaimsLines."Claim Amount", '<>%1', 0);
                                    IF ClaimsLines.FINDFIRST THEN BEGIN
                                        REPEAT
                                            //Insert Reinsurer Claim Lines
                                            LineNo := LineNo + 1000;
                                            ClaimsLines.INIT;
                                            ClaimsLines."Claim No" := Claim."Claim No";
                                            ClaimsLines."Line No" := LineNo;
                                            ClaimsLines.Type := ClaimsLines.Type::Vendor;
                                            ClaimsLines.No := TreatyReinsuranceShare."Re-insurer code";
                                            ClaimsLines.VALIDATE(No);
                                            ClaimsLines.Description := 'CLAIM PAYMENT';
                                            ClaimsLines."Claim Amount" := (Claim."Premium Balance" - Treaty."Quota share Retention")
                                            * TreatyReinsuranceShare."Percentage %";
                                            ClaimsLines.VALIDATE(ClaimsLines."Claim Amount");
                                            ClaimsLines.INSERT(TRUE);

                                        UNTIL
                                       ClaimsLines.NEXT = 0;
                                    END;
                                END;
                        IF Claim."Premium Balance" > Treaty."Surplus Retention" THEN
                            IF Treaty.Facultative THEN
                                IF TreatyReinsuranceShare.Facultative THEN BEGIN
                                    ClaimsLines.RESET();
                                    ClaimsLines.SETRANGE(ClaimsLines."Claim No", Claim."Claim No");
                                    ClaimsLines.SETFILTER(ClaimsLines."Claim Amount", '<>%1', 0);
                                    IF ClaimsLines.FINDFIRST THEN BEGIN
                                        REPEAT
                                            //Insert Reinsurer Claim Lines
                                            LineNo := LineNo + 1000;
                                            ClaimsLines.INIT;
                                            ClaimsLines."Claim No" := Claim."Claim No";
                                            ClaimsLines."Line No" := LineNo;
                                            ClaimsLines.Type := ClaimsLines.Type::Vendor;
                                            ClaimsLines.No := TreatyReinsuranceShare."Re-insurer code";
                                            ClaimsLines.VALIDATE(No);
                                            ClaimsLines.Description := 'CLAIM PAYMENT';
                                            ClaimsLines."Claim Amount" := (Claim."Premium Balance" - Treaty."Surplus Retention")
                                            * TreatyReinsuranceShare."Percentage %";
                                            ClaimsLines.VALIDATE(ClaimsLines."Claim Amount");
                                            ClaimsLines.INSERT(TRUE);

                                        UNTIL
                                       ClaimsLines.NEXT = 0;
                                    END;
                                END;
                    END;
            UNTIL TreatyReinsuranceShare.NEXT = 0;
        END;
    end;

    procedure GeneratePolicyNos(var InsureHeader: Record "Insure Header") PolicyNo: Code[30];
    var
        PolicyRec: Record "Insure Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        InsuranceSetup: Record "Insurance setup";
        Month: Integer;
        MonthText: Text;
        PolicyType: Record "Policy Type";
        DimValRec: Record "Dimension Value";
        GeneralLedgersetup: Record "General Ledger Setup";
    begin



        InsuranceSetup.GET;
        GeneralLedgersetup.GET;
        Month := DATE2DMY(InsureHeader."From Date", 2);
        IF Month < 10 THEN
            MonthText := '0' + FORMAT(Month)
        ELSE
            MonthText := FORMAT(Month);

        IF PolicyType.GET(InsureHeader."Policy Type") THEN BEGIN

            IF InsureHeader."Action Type" = InsureHeader."Action Type"::New THEN BEGIN

                IF DimValRec.GET(GeneralLedgersetup."Shortcut Dimension 3 Code", PolicyType.Class) THEN BEGIN

                    IF DimValRec."Last Policy No." = '' THEN
                        ERROR('Please setup Last Policy No. for class %1', PolicyType.Class);
                    PolicyNo := InsureHeader."Shortcut Dimension 1 Code" + '/' + PolicyType.Class + '/' + InsureHeader."Endorsement Type" + '/' + INCSTR(DimValRec."Last Policy No.") + '/' + FORMAT(DATE2DMY(InsureHeader."From Date", 3)) + '/' +
                    MonthText;

                    DimValRec."Last Policy No." := INCSTR(DimValRec."Last Policy No.");
                    DimValRec.MODIFY;
                END;
            END
            ELSE BEGIN
                IF DimValRec.GET(GeneralLedgersetup."Shortcut Dimension 3 Code", PolicyType.Class) THEN BEGIN
                    IF DimValRec."Last Endorsement No." = '' THEN
                        ERROR('Please setup Last Endorsement No. for class %1', PolicyType.Class);
                    PolicyNo := InsureHeader."Shortcut Dimension 1 Code" + '/' + PolicyType.Class + '/' + InsureHeader."Endorsement Type" + '/' + INCSTR(DimValRec."Last Endorsement No.") + '/' + FORMAT(DATE2DMY(InsureHeader."From Date", 3)) + '/' +
                    MonthText;

                    DimValRec."Last Endorsement No." := INCSTR(DimValRec."Last Endorsement No.");
                    DimValRec.MODIFY;
                END;
            END;

        END;


    end;

    procedure GetTreatyPremium(var Rec: Record "Insure Header");
    var
        Treaty: Record Treaty;
        Class: Record "Insurance Class";
        PolicyType: Record "Policy Type";
        TreatyReinsuranceShare: Record "Treaty Reinsurance Share";
        InsLines: Record "Insure Lines";
        LineNo: Integer;
        InsuranceSetup: Record "Insurance setup";
        ReinsLines: Record "Coinsurance Reinsurance Lines";
        GenJnlLine: Record "Gen. Journal Line";
        CedingCommission: Decimal;
        Whtx: Decimal;
    begin
        Rec.CALCFIELDS("Total Premium Amount", "Total Net Premium", "Total Sum Insured");
        //Check if Total Premium Exceeds The Treaty Limits
        //Get the treaty details
        IF PolicyType.GET(Rec."Policy Type") THEN
            IF Class.GET(PolicyType.Class) THEN
                IF Treaty.GET(Class."Treaty Code", Class."Addendum Code") THEN BEGIN   //Treaty
                                                                                       //Confirm Effective date
                    IF (Rec."From Date" <= Treaty."Expiry Date") AND (Rec."From Date" >= Treaty."Effective date") THEN BEGIN   //treaty range
                        TreatyReinsuranceShare.SETRANGE(TreatyReinsuranceShare."Treaty Code", Treaty."Treaty Code");
                        TreatyReinsuranceShare.SETRANGE(TreatyReinsuranceShare."Addendum Code", Treaty."Addendum Code");
                        IF TreatyReinsuranceShare.FINDFIRST THEN BEGIN     //lines
                            REPEAT
                                CedingCommission := 0;
                                //Check whether proportional or non proportional
                                IF Treaty."Apportionment Type" = Treaty."Apportionment Type"::"Non-proportional"
                                THEN BEGIN


                                    IF Rec."Total Sum Insured" > Treaty."Surplus Retention" THEN BEGIN
                                        InsLines.RESET;
                                        InsLines.SETRANGE(InsLines."Document Type", Rec."Document Type");
                                        InsLines.SETRANGE(InsLines."Document No.", Rec."No.");
                                        IF InsLines.FINDLAST THEN BEGIN
                                            LineNo := InsLines."Line No.";
                                        END;

                                        InsLines.RESET;
                                        InsLines.SETRANGE(InsLines."Document Type", Rec."Document Type");
                                        InsLines.SETRANGE(InsLines."Document No.", Rec."No.");
                                        InsLines.SETRANGE(InsLines."Description Type", InsLines."Description Type"::"Schedule of Insured");
                                        InsLines.SETFILTER(InsLines."Gross Premium", '<>%1', 0);
                                        IF InsLines.FINDFIRST THEN BEGIN
                                            // REPEAT
                                            //Modify gross premium for insurance firm
                                            /* IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                             InsLines."Gross Premium":=(Treaty."Limit Of Indemnity"*InsLines."Rate %age"/100)
                                             ELSE
                                             InsLines."Gross Premium":=(Treaty."Limit Of Indemnity"*InsLines."Rate %age"/1000);
                                             InsLines.VALIDATE("Gross Premium");
                                             InsLines.MODIFY(TRUE);*/
                                            //MESSAGE('Non proportional treaty Sum Insured=%1 and Retention=%2 Premium=%3',Rec."Total Sum Insured", Treaty."Surplus Retention",Rec."Total Premium Amount");
                                            //Insert entries for reinsurance firms
                                            LineNo := LineNo + 1000;
                                            ReinsLines.INIT;
                                            ReinsLines."Document Type" := Rec."Document Type";
                                            ReinsLines."No." := Rec."No.";
                                            //ReinsLines."Line No.":=LineNo;
                                            //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                            // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                            ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                            ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                                            ReinsLines."Partner No." := TreatyReinsuranceShare."Re-insurer code";
                                            ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                            //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";

                                            ReinsLines.Premium := (((Rec."Total Sum Insured" - Treaty."Surplus Retention") / Rec."Total Sum Insured") * Rec."Total Premium Amount"
                                                               * (TreatyReinsuranceShare."Percentage %" / 100));


                                            CedingCommission := ReinsLines.Premium * (Treaty."Broker Commision" / 100);
                                            ReinsLines."Cedant Commission" := CedingCommission;
                                            //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                            //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                            //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                            //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                            IF ReinsLines.Premium <> 0 THEN
                                                ReinsLines.INSERT(TRUE);

                                        END;
                                    END;
                                END ELSE BEGIN
                                    // MESSAGE(' proportional treaty');
                                    IF TreatyReinsuranceShare."Quota Share" THEN
                                        IF Rec."Total Sum Insured" <= Treaty."Quota share Retention" THEN BEGIN
                                            InsLines.RESET;
                                            InsLines.SETRANGE(InsLines."Document Type", Rec."Document Type");
                                            InsLines.SETRANGE(InsLines."Document No.", Rec."No.");
                                            InsLines.SETRANGE(InsLines."Description Type", InsLines."Description Type"::"Schedule of Insured");
                                            InsLines.SETFILTER(InsLines."Gross Premium", '<>%1', 0);
                                            IF InsLines.FINDFIRST THEN BEGIN
                                                //REPEAT
                                                /*//Modify gross premium for insurance firm
                                                InsLines."Gross Premium":=(InsLines."Gross Premium"*Treaty."Cedant quota percentage"/100);
                                                InsLines.VALIDATE("Gross Premium");
                                                IF Treaty."Cedant quota percentage"/100=(InsLines."Gross Premium"/Rec."Total Premium Amount")THEN
                                                InsLines.MODIFY(TRUE);*/

                                                //Insert entries for reinsurance firms
                                                LineNo := LineNo + 1000;
                                                ReinsLines.INIT;
                                                ReinsLines."Document Type" := Rec."Document Type";
                                                ReinsLines."No." := Rec."No.";
                                                //ReinsLines."Line No.":=LineNo;
                                                //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                                //ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                                ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                                                ReinsLines."Partner No." := TreatyReinsuranceShare."Re-insurer code";
                                                ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                                //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                                ReinsLines.Premium := (Rec."Total Premium Amount" * (TreatyReinsuranceShare."Percentage %" / 100));
                                                //ReinsLines.VALIDATE(ReinsLines.Amount);
                                                CedingCommission := ReinsLines.Premium * (Treaty."Broker Commision" / 100);
                                                ReinsLines."Cedant Commission" := CedingCommission;
                                                //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                                //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                                //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                                //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                                IF ReinsLines.Premium <> 0 THEN
                                                    ReinsLines.INSERT(TRUE);
                                            END;
                                        END




                                        ELSE
                                            IF Rec."Total Sum Insured" > Treaty."Quota share Retention" THEN BEGIN
                                                InsLines.RESET;
                                                InsLines.SETRANGE(InsLines."Document Type", Rec."Document Type");
                                                InsLines.SETRANGE(InsLines."Document No.", Rec."No.");
                                                InsLines.SETRANGE(InsLines."Description Type", InsLines."Description Type"::"Schedule of Insured");
                                                InsLines.SETFILTER(InsLines."Gross Premium", '<>%1', 0);
                                                IF InsLines.FINDFIRST THEN BEGIN
                                                    // REPEAT
                                                    /* //Modify gross premium for insurance firm
                                                     IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                                     InsLines."Gross Premium":=((Treaty."Quota share Retention"*InsLines."Rate %age"/100)
                                                     *Treaty."Cedant quota percentage"/100)
                                                     ELSE
                                                     InsLines."Gross Premium":=((Treaty."Quota share Retention"*InsLines."Rate %age"/1000)
                                                     *Treaty."Cedant quota percentage"/100);
                                                     InsLines.VALIDATE("Gross Premium");
                                                     InsLines.MODIFY(TRUE);*/
                                                    //Insert entries for reinsurance firms
                                                    LineNo := LineNo + 1000;
                                                    ReinsLines.INIT;
                                                    ReinsLines."Document Type" := Rec."Document Type";
                                                    ReinsLines."No." := Rec."No.";
                                                    //ReinsLines."Line No.":=LineNo;
                                                    //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                                    // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                                    ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                                                    ReinsLines."Partner No." := TreatyReinsuranceShare."Re-insurer code";
                                                    ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                                    //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                                    IF InsLines."Rate Type" = InsLines."Rate Type"::"Per Cent" THEN
                                                        ReinsLines.Premium := ((Treaty."Quota share Retention" * InsLines."Rate %age" / 100)
                                                        * (TreatyReinsuranceShare."Percentage %" / 100))
                                                    ELSE
                                                        ReinsLines.Premium := ((Treaty."Quota share Retention" * InsLines."Rate %age" / 1000)
                                                        * (TreatyReinsuranceShare."Percentage %" / 100));

                                                    CedingCommission := ReinsLines.Premium * (Treaty."Broker Commision" / 100);
                                                    //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                                    //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                                    //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                                    //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                                    IF ReinsLines.Amount <> 0 THEN
                                                        ReinsLines.INSERT(TRUE);
                                                END;

                                                IF Treaty.Surplus THEN BEGIN
                                                    //Insert entries for reinsurance firms
                                                    LineNo := LineNo + 1000;
                                                    ReinsLines.INIT;
                                                    ReinsLines."Document Type" := Rec."Document Type";
                                                    ReinsLines."No." := Rec."No.";
                                                    //ReinsLines."Line No.":=LineNo;
                                                    //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                                    ReinsLines."Account Type" := ReinsLines."Account Type"::Vendor;
                                                    ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                                                    ReinsLines."Partner No." := TreatyReinsuranceShare."Re-insurer code";
                                                    ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                                    // ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";


                                                    IF InsLines."Rate Type" = InsLines."Rate Type"::"Per Cent" THEN
                                                        ReinsLines.Premium := (((Rec."Total Sum Insured" -
                                                        Treaty."Quota share Retention") * InsLines."Rate %age" / 100)
                                                        * (TreatyReinsuranceShare."Percentage %" / 100))
                                                    ELSE
                                                        ReinsLines.Premium := (((Rec."Total Sum Insured" -
                                                        Treaty."Quota share Retention") * InsLines."Rate %age" / 100)
                                                        * (TreatyReinsuranceShare."Percentage %" / 100));
                                                    ReinsLines.VALIDATE(ReinsLines.Amount);
                                                    CedingCommission := ReinsLines.Premium * (Treaty."Broker Commision" / 100);
                                                    ReinsLines."Cedant Commission" := CedingCommission;
                                                    //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                                    //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                                    //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                                    //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                                    IF ReinsLines.Premium <> 0 THEN
                                                        ReinsLines.INSERT(TRUE);
                                                END;
                                                IF Rec."Total Sum Insured" > Treaty."Surplus Retention" THEN
                                                    IF Treaty.Facultative THEN BEGIN
                                                        //Insert entries for reinsurance firms
                                                        LineNo := LineNo + 1000;
                                                        ReinsLines.INIT;
                                                        ReinsLines."Document Type" := Rec."Document Type";
                                                        ReinsLines."No." := Rec."No.";
                                                        // ReinsLines."Line No.":=LineNo;
                                                        //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                                        ReinsLines."Account Type" := ReinsLines."Account Type"::Vendor;
                                                        ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                                                        ReinsLines."Partner No." := TreatyReinsuranceShare."Re-insurer code";
                                                        ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                                        //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                                        IF InsLines."Rate Type" = InsLines."Rate Type"::"Per Cent" THEN
                                                            ReinsLines.Premium := (((Rec."Total Sum Insured" -
                                                            Treaty."Surplus Retention") * InsLines."Rate %age" / 100)
                                                            * (TreatyReinsuranceShare."Percentage %" / 100))
                                                        ELSE
                                                            ReinsLines.Premium := (((Rec."Total Sum Insured" -
                                                            Treaty."Surplus Retention") * InsLines."Rate %age" / 100)
                                                            * (TreatyReinsuranceShare."Percentage %" / 100));

                                                        CedingCommission := ReinsLines.Premium * (Treaty."Broker Commision" / 100);
                                                        ReinsLines."Cedant Commission" := CedingCommission;
                                                        //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                                        //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                                        //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                                        //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                                        IF ReinsLines.Premium <> 0 THEN
                                                            ReinsLines.INSERT(TRUE);
                                                    END;












                                            END;
                                END;
                            UNTIL
                                         TreatyReinsuranceShare.NEXT = 0;

                        END;
                    END;
                END;

    end;

    local procedure PostDebitNote(var InsureHeader: Record "Insure Header");
    begin
    end;

    procedure DrawPaymentSchedule(var PolicyHeader: Record "Insure Header");
    var
        PaymentSchedule: Record "Instalment Payment Plan";
        TotalPremium: Decimal;
        PolicyLines: Record "Insure Lines";
        StartDate: Date;
        i: Integer;
        PaymentTerms: Record "No. of Instalments";
    begin
        //MESSAGE('Running TPO Schedule');

        PaymentSchedule.RESET;
        PaymentSchedule.SETRANGE(PaymentSchedule."Document Type", PolicyHeader."Document Type");
        PaymentSchedule.SETRANGE(PaymentSchedule."Document No.", PolicyHeader."No.");
        PaymentSchedule.DELETEALL;

        IF PolicyHeader."No." <> '' THEN BEGIN
            IF PaymentTerms.GET(PolicyHeader."No. Of Instalments") THEN BEGIN
                IF PaymentTerms."No. Of Instalments" > 1 THEN BEGIN

                    StartDate := PolicyHeader."From Date";
                    IF PolicyHeader."From Date" = 0D THEN
                        ERROR('Please key in the policy start date');

                    FOR i := 1 TO PaymentTerms."No. Of Instalments" DO BEGIN
                        PaymentSchedule.INIT;
                        PaymentSchedule."Document Type" := PolicyHeader."Document Type";
                        PaymentSchedule."Document No." := PolicyHeader."No.";
                        PaymentSchedule."Payment No" := i;

                        // PaymentSchedule."Amount Due":=TotalPremium/PaymentTerms."No. of Payments";
                        PolicyHeader.CALCFIELDS(PolicyHeader."Total Premium Amount");
                        PaymentSchedule."Amount Due" := PolicyHeader."Total Premium Amount";
                        IF i = 1 THEN BEGIN
                            PaymentSchedule."Due Date" := StartDate;
                            PaymentSchedule."Cover Start Date" := StartDate;
                            PaymentSchedule."Cover End Date" := CALCDATE(PaymentTerms."Period Length", PaymentSchedule."Cover Start Date") - 1
                        END
                        ELSE BEGIN

                            StartDate := CALCDATE(PaymentTerms."Period Length", StartDate);
                            PaymentSchedule."Due Date" := StartDate;

                            PaymentSchedule."Cover Start Date" := StartDate;
                            IF FORMAT(PaymentTerms."Last Instalment Period Length") <> '' THEN BEGIN
                                IF i <> PaymentTerms."No. Of Instalments" THEN
                                    PaymentSchedule."Cover End Date" := CALCDATE(PaymentTerms."Period Length", PaymentSchedule."Cover Start Date") - 1
                                ELSE
                                    PaymentSchedule."Cover End Date" := CALCDATE(PaymentTerms."Last Instalment Period Length", PaymentSchedule."Cover Start Date") - 1
                            END
                            ELSE
                                PaymentSchedule."Cover End Date" := CALCDATE(PaymentTerms."Period Length", PaymentSchedule."Cover Start Date") - 1;
                        END;


                        IF PaymentSchedule.GET(PaymentSchedule."Document Type", PaymentSchedule."Document No.", PaymentSchedule."Payment No") THEN
                            PaymentSchedule.MODIFY
                        ELSE
                            PaymentSchedule.INSERT;

                    END;

                END;
            END;
        END;
    end;

    procedure GetTreatyPremiumOld(var Rec: Record "Insure Header");
    var
        Treaty: Record Treaty;
        Class: Record "Insurance Class";
        PolicyType: Record "Policy Type";
        TreatyReinsuranceShare: Record "Treaty Reinsurance Share";
        InsLines: Record "Insure Lines";
        LineNo: Integer;
        InsuranceSetup: Record "Insurance setup";
        ReinsLines: Record "Coinsurance Reinsurance Lines";
        GenJnlLine: Record "Gen. Journal Line";
        CedingCommission: Decimal;
        Whtx: Decimal;
    begin
        /*Rec.CALCFIELDS("Total Premium Amount","Total Net Premium","Total Sum Insured");
        //Check if Total Premium Exceeds The Treaty Limits
        //Get the treaty details
        IF PolicyType.GET(Rec."Policy Type") THEN
           IF Class.GET(PolicyType.Class) THEN
             IF Treaty.GET(Class."Treaty Code",Class."Addendum Code") THEN BEGIN
                //Confirm Effective date
                IF (Rec."From Date"<=Treaty."Expiry Date" ) AND  (Rec."From Date">=Treaty."Effective date") THEN BEGIN
                    TreatyReinsuranceShare.SETRANGE(TreatyReinsuranceShare."Treaty Code",Treaty."Treaty Code");
                    TreatyReinsuranceShare.SETRANGE(TreatyReinsuranceShare."Addendum Code",Treaty."Addendum Code");
                     IF TreatyReinsuranceShare.FINDFIRST THEN BEGIN
                         REPEAT
                         CedingCommission:=0;
                     //Check whether proportional or non proportional
                      IF Treaty."Apportionment Type"=Treaty."Apportionment Type"::"Non-proportional"
                      THEN BEGIN
                         IF Rec."Total Sum Insured">Treaty."Limit Of Indemnity" THEN BEGIN
                          InsLines.RESET;
                          InsLines.SETRANGE(InsLines."Document Type",Rec."Document Type");
                          InsLines.SETRANGE(InsLines."Document No.",Rec."No.");
                           IF InsLines.FINDLAST THEN BEGIN
                              LineNo:=InsLines."Line No.";
                           END;
        
                          InsLines.RESET;
                          InsLines.SETRANGE(InsLines."Document Type",Rec."Document Type");
                          InsLines.SETRANGE(InsLines."Document No.",Rec."No.");
                          InsLines.SETRANGE(InsLines."Description Type",InsLines."Description Type"::"Schedule of Insured");
                          InsLines.SETFILTER(InsLines."Gross Premium",'<>%1',0);
                          IF InsLines.FINDFIRST THEN BEGIN
                             REPEAT
                             //Modify gross premium for insurance firm
                            { IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                             InsLines."Gross Premium":=(Treaty."Limit Of Indemnity"*InsLines."Rate %age"/100)
                             ELSE
                             InsLines."Gross Premium":=(Treaty."Limit Of Indemnity"*InsLines."Rate %age"/1000);
                             InsLines.VALIDATE("Gross Premium");
                             InsLines.MODIFY(TRUE);}
        
                             //Insert entries for reinsurance firms
                             LineNo:=LineNo+1000;
                             ReinsLines.INIT;
                             ReinsLines."Document Type":=Rec."Document Type";
                             ReinsLines."No.":=Rec."No.";
                             //ReinsLines."Line No.":=LineNo;
                             //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                            // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                             ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                             ReinsLines."Partner No.":=TreatyReinsuranceShare."Re-insurer code";
                             ReinsLines.VALIDATE(ReinsLines."Partner No.");
                             //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                             IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                             ReinsLines.Premium:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/100)
                             *(TreatyReinsuranceShare."Percentage %"/100))
                             ELSE
                             ReinsLines.Premium:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/1000)
                             *(TreatyReinsuranceShare."Percentage %"/100));
        
        
                             CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
        
                             //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                             //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                             //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                             //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                             IF ReinsLines.Premium<>0 THEN
                             ReinsLines.INSERT(TRUE);
        
                             //====Insert Opposite entry
                             //Insert entries for reinsurance firms
                             LineNo:=LineNo+1000;
                             ReinsLines.INIT;
                             ReinsLines."Document Type":=Rec."Document Type";
                             ReinsLines."No.":=Rec."No.";
                             //ReinsLines."Line No.":=LineNo;
                             //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                             IntegrationSetup.GET;
                             ReinsLines."Account Type":=ReinsLines."Account Type"::"G/L Account";
                             ReinsLines."Account No.":=IntegrationSetup."Quota Share-Premium Account";
                             ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                             IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                             ReinsLines.Amount:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/100)
                             *(TreatyReinsuranceShare."Percentage %"/100))
                             ELSE
                             ReinsLines.Amount:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/1000)
                             *(TreatyReinsuranceShare."Percentage %"/100));
                             ReinsLines.Amount:=-ReinsLines.Amount;
                             ReinsLines.VALIDATE(ReinsLines.Amount);
        
                             //CedingCommission:=CedingCommission+ReinsLines."Unit Price"*(Treaty."Broker Commision"/100);
        
                             //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                             //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                             //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                             //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                             IF ReinsLines.Amount<>0 THEN
                             ReinsLines.INSERT(TRUE);
        
                             UNTIL
                             InsLines.NEXT=0;
                             END;
                             END;
                             END ELSE BEGIN
                             IF TreatyReinsuranceShare."Quota Share" THEN
                               IF Rec."Total Sum Insured"<= Treaty."Quota share Retention" THEN BEGIN
                                InsLines.RESET;
                                InsLines.SETRANGE(InsLines."Document Type",Rec."Document Type");
                                InsLines.SETRANGE(InsLines."Document No.",Rec."No.");
                                InsLines.SETRANGE(InsLines."Description Type",InsLines."Description Type"::"Schedule of Insured");
                                InsLines.SETFILTER(InsLines."Gross Premium",'<>%1',0);
                                IF InsLines.FINDFIRST THEN BEGIN
                                   REPEAT
                                   {//Modify gross premium for insurance firm
                                   InsLines."Gross Premium":=(InsLines."Gross Premium"*Treaty."Cedant quota percentage"/100);
                                   InsLines.VALIDATE("Gross Premium");
                                   IF Treaty."Cedant quota percentage"/100=(InsLines."Gross Premium"/Rec."Total Premium Amount")THEN
                                   InsLines.MODIFY(TRUE);}
        
                                    //Insert entries for reinsurance firms
                                    LineNo:=LineNo+1000;
                                    ReinsLines.INIT;
                                    ReinsLines."Document Type":=Rec."Document Type";
                                    ReinsLines."Document No.":=Rec."No.";
                                    ReinsLines."Line No.":=LineNo;
                                    //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                    ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                    ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                                    ReinsLines.VALIDATE(ReinsLines."Account No.");
                                    ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                    ReinsLines.Amount:=(Rec."Total Premium Amount"*(TreatyReinsuranceShare."Percentage %"/100));
                                    ReinsLines.VALIDATE(ReinsLines.Amount);
                                    CedingCommission:=CedingCommission+ReinsLines.Amount*(Treaty."Broker Commision"/100);
                                    //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                    //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                    //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                    //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                    IF ReinsLines.Amount<>0 THEN
                                       ReinsLines.INSERT(TRUE);
        
                             //====Insert Opposite entry
                             //Insert entries for reinsurance firms
                             LineNo:=LineNo+1000;
                             ReinsLines.INIT;
                             ReinsLines."Document Type":=Rec."Document Type";
                             ReinsLines."Document No.":=Rec."No.";
                             ReinsLines."Line No.":=LineNo;
                             //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                             IntegrationSetup.GET;
                             ReinsLines."Account Type":=ReinsLines."Account Type"::"G/L Account";
                             ReinsLines."Account No.":=IntegrationSetup."Mandatory Share -Premium Acc.";
                             ReinsLines.VALIDATE(ReinsLines."Account No.");
                             ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                             IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                             ReinsLines.Amount:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/100)
                             *(TreatyReinsuranceShare."Percentage %"/100))
                             ELSE
                             ReinsLines.Amount:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/1000)
                             *(TreatyReinsuranceShare."Percentage %"/100));
                             ReinsLines.Amount:=-ReinsLines.Amount;
        
        
                             //CedingCommission:=CedingCommission+ReinsLines."Unit Price"*(Treaty."Broker Commision"/100);
        
                             //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                             //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                             //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                             //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                             IF ReinsLines.Amount<>0 THEN
                             ReinsLines.INSERT(TRUE);
        
        
        
                                         UNTIL
                                          InsLines.NEXT=0;
                                        END;
                                    END
                                    ELSE IF Rec."Total Sum Insured">Treaty."Quota share Retention" THEN
                                    BEGIN
                                    InsLines.RESET;
                                    InsLines.SETRANGE(InsLines."Document Type",Rec."Document Type");
                                    InsLines.SETRANGE(InsLines."Document No.",Rec."No.");
                                    InsLines.SETRANGE(InsLines."Description Type",InsLines."Description Type"::"Schedule of Insured");
                                    InsLines.SETFILTER(InsLines."Gross Premium",'<>%1',0);
                                    IF InsLines.FINDFIRST THEN BEGIN
                                       REPEAT
                                      { //Modify gross premium for insurance firm
                                       IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                       InsLines."Gross Premium":=((Treaty."Quota share Retention"*InsLines."Rate %age"/100)
                                       *Treaty."Cedant quota percentage"/100)
                                       ELSE
                                       InsLines."Gross Premium":=((Treaty."Quota share Retention"*InsLines."Rate %age"/1000)
                                       *Treaty."Cedant quota percentage"/100);
                                       InsLines.VALIDATE("Gross Premium");
                                       InsLines.MODIFY(TRUE);}
                                      //Insert entries for reinsurance firms
                                      LineNo:=LineNo+1000;
                                      ReinsLines.INIT;
                                      ReinsLines."Document Type":=Rec."Document Type";
                                      ReinsLines."Document No.":=Rec."No.";
                                      ReinsLines."Line No.":=LineNo;
                                      //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                      ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                      ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
        
                                      ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                      IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                      ReinsLines.Amount:=((Treaty."Quota share Retention"*InsLines."Rate %age"/100)
                                      *(TreatyReinsuranceShare."Percentage %"/100))
                                      ELSE
                                      ReinsLines.Amount:=((Treaty."Quota share Retention"*InsLines."Rate %age"/1000)
                                      *(TreatyReinsuranceShare."Percentage %"/100));
        
                                      CedingCommission:=CedingCommission+ReinsLines.Amount*(Treaty."Broker Commision"/100);
                                      //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                      //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                      //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                      //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                      IF ReinsLines.Amount<>0 THEN
                                      ReinsLines.INSERT(TRUE);
        
                                //====Insert Opposite entry
                                //Insert entries for reinsurance firms
                                LineNo:=LineNo+1000;
                                ReinsLines.INIT;
                                ReinsLines."Document Type":=Rec."Document Type";
                                ReinsLines."Document No.":=Rec."No.";
                                ReinsLines."Line No.":=LineNo;
                                //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                IntegrationSetup.GET;
                                ReinsLines."Account Type":=ReinsLines."Account Type"::"G/L Account";
                                ReinsLines."Account No.":=IntegrationSetup."Mandatory Share -Premium Acc.";
        
                                ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                ReinsLines.Amount:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/100)
                                *(TreatyReinsuranceShare."Percentage %"/100))
                                ELSE
                                ReinsLines.Amount:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/1000)
                                *(TreatyReinsuranceShare."Percentage %"/100));
                                ReinsLines.Amount:=-ReinsLines.Amount;
        
        
                                //CedingCommission:=CedingCommission+ReinsLines."Unit Price"*(Treaty."Broker Commision"/100);
        
                                //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                IF ReinsLines.Amount<>0 THEN
                                ReinsLines.INSERT(TRUE);
        
                                      IF Treaty.Surplus THEN BEGIN
                                      //Insert entries for reinsurance firms
                                      LineNo:=LineNo+1000;
                                      ReinsLines.INIT;
                                      ReinsLines."Document Type":=Rec."Document Type";
                                      ReinsLines."Document No.":=Rec."No.";
                                      ReinsLines."Line No.":=LineNo;
                                      //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                      ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                      ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                                      ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
        
        
                                      IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                      ReinsLines.Amount:=(((Rec."Total Sum Insured"-
                                      Treaty."Quota share Retention")*InsLines."Rate %age"/100)
                                      *(TreatyReinsuranceShare."Percentage %"/100))
                                      ELSE
                                      ReinsLines.Amount:=(((Rec."Total Sum Insured"-
                                      Treaty."Quota share Retention")*InsLines."Rate %age"/100)
                                      *(TreatyReinsuranceShare."Percentage %"/100));
                                      ReinsLines.VALIDATE(ReinsLines.Amount);
                                      CedingCommission:=CedingCommission+ReinsLines.Amount*(Treaty."Broker Commision"/100);
                                      //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                      //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                      //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                      //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                      IF ReinsLines.Amount<>0 THEN
                                      ReinsLines.INSERT(TRUE);
                             //====Insert Opposite entry
                             //Insert entries for reinsurance firms
                             LineNo:=LineNo+1000;
                             ReinsLines.INIT;
                             ReinsLines."Document Type":=Rec."Document Type";
                             ReinsLines."Document No.":=Rec."No.";
                             ReinsLines."Line No.":=LineNo;
                             //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                             IntegrationSetup.GET;
                             ReinsLines."Account Type":=ReinsLines."Account Type"::"G/L Account";
                             ReinsLines."Account No.":=IntegrationSetup."Mandatory Share -Premium Acc.";
                             ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                             IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                             ReinsLines.Amount:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/100)
                             *(TreatyReinsuranceShare."Percentage %"/100))
                             ELSE
                             ReinsLines.Amount:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/1000)
                             *(TreatyReinsuranceShare."Percentage %"/100));
                            ReinsLines.Amount:=-ReinsLines.Amount;
                             ReinsLines.VALIDATE(ReinsLines.Amount);
        
                             //CedingCommission:=CedingCommission+ReinsLines."Unit Price"*(Treaty."Broker Commision"/100);
        
                             //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                             //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                             //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                             //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                             IF ReinsLines.Amount<>0 THEN
                             ReinsLines.INSERT(TRUE);
        
        
                                       END;
                                            UNTIL
                                            InsLines.NEXT=0;
                                          END;
                                      END;
                                      IF Rec."Total Sum Insured">Treaty."Surplus Retention" THEN
                                         IF Treaty.Facultative THEN BEGIN
                                      //Insert entries for reinsurance firms
                                      LineNo:=LineNo+1000;
                                      ReinsLines.INIT;
                                      ReinsLines."Document Type":=Rec."Document Type";
                                      ReinsLines."Document No.":=Rec."No.";
                                      ReinsLines."Line No.":=LineNo;
                                      //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                      ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                      ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                                      ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                      IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                      ReinsLines.Amount:=(((Rec."Total Sum Insured"-
                                      Treaty."Surplus Retention")*InsLines."Rate %age"/100)
                                      *(TreatyReinsuranceShare."Percentage %"/100))
                                      ELSE
                                      ReinsLines.Amount:=(((Rec."Total Sum Insured"-
                                      Treaty."Surplus Retention")*InsLines."Rate %age"/100)
                                      *(TreatyReinsuranceShare."Percentage %"/100));
        
                                      CedingCommission:=CedingCommission+ReinsLines.Amount*(Treaty."Broker Commision"/100);
                                      //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                      //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                      //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                      //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                      IF ReinsLines.Amount<>0 THEN
                                      ReinsLines.INSERT(TRUE);
                             //====Insert Opposite entry
                             //Insert entries for reinsurance firms
                             LineNo:=LineNo+1000;
                             ReinsLines.INIT;
                             ReinsLines."Document Type":=Rec."Document Type";
                             ReinsLines."Document No.":=Rec."No.";
                             ReinsLines."Line No.":=LineNo;
                             //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                             IntegrationSetup.GET;
                             ReinsLines."Account Type":=ReinsLines."Account Type"::"G/L Account";
                            ReinsLines."Account No.":=IntegrationSetup."Mandatory Share -Premium Acc.";
        
                             ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                             IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                             ReinsLines.Amount:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/100)
                             *(TreatyReinsuranceShare."Percentage %"/100))
                             ELSE
                             ReinsLines.Amount:=(((Rec."Total Sum Insured"-Treaty."Limit Of Indemnity")*InsLines."Rate %age"/1000)
                             *(TreatyReinsuranceShare."Percentage %"/100));
                             ReinsLines.Amount:=-ReinsLines.Amount;
                             ReinsLines.VALIDATE(ReinsLines.Amount);
        
                             //CedingCommission:=CedingCommission+ReinsLines."Unit Price"*(Treaty."Broker Commision"/100);
        
                             //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                             //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                             //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                             //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                             IF ReinsLines.Amount<>0 THEN
                             ReinsLines.INSERT(TRUE);
        
                                       END;
                                      END;
        
                                        InsLines.RESET;
                                        InsLines.SETRANGE(InsLines."Document Type",Rec."Document Type");
                                        InsLines.SETRANGE(InsLines."Document No.",Rec."No.");
                                         IF InsLines.FINDLAST THEN BEGIN
                                            LineNo:=InsLines."Line No.";
                                         END;
        
                                        LineNo:=LineNo+1000;
                                        ReinsLines.INIT;
                                        ReinsLines."Document Type":=Rec."Document Type";
                                        ReinsLines."Document No.":=Rec."No.";
                                        ReinsLines."Line No.":=LineNo;
                                      //  ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                        ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                        ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                                        //ReinsLines.VALIDATE("No.");
                                        ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                        //ReinsLines.Quantity:=1;
                                       // ReinsLines.VALIDATE(Quantity);
                                        ReinsLines.Amount:=-CedingCommission;
        
                                        IF ReinsLines.Amount<>0 THEN
                                        ReinsLines.INSERT(TRUE);
        
                                        LineNo:=LineNo+1000;
                                        ReinsLines.INIT;
                                        ReinsLines."Document Type":=Rec."Document Type";
                                        ReinsLines."Document No.":=Rec."No.";
                                        ReinsLines."Line No.":=LineNo;
                                        //ReinsLines."VAT Prod. Posting Group":='NO VAT';
                                       // ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                        IntegrationSetup.GET;
                                        ReinsLines."Account Type":=ReinsLines."Account Type"::"G/L Account";
                                        ReinsLines."Account No.":=IntegrationSetup."Mandatory Share -Comm.Acc.";
                                        //ReinsLines.VALIDATE("No.");
                                        ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                        //ReinsLines.Quantity:=1;
                                        //ReinsLines."VAT Prod. Posting Group":='NO VAT';
                                        //ReinsLines.VALIDATE(Quantity);
                                        ReinsLines.Amount:=CedingCommission;
                                        ReinsLines.VALIDATE(ReinsLines.Amount);
                                        IF ReinsLines.Amount<>0 THEN
                                        ReinsLines.INSERT(TRUE);
        
        
        
        
        
                                     {
                                 GenJnlLine.INIT;
                                 GenJnlLine."Journal Template Name":='GENERAL';
                                 GenJnlLine."Journal Batch Name":='COMM';
                                 GenJnlLine."Line No.":=GenJnlLine."Line No."+10000;
                                 GenJnlLine."Account Type":=GenJnlLine."Account Type"::Vendor;
                                 GenJnlLine."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                                 GenJnlLine."Posting Date":=SalesOrderHeader."Posting Date";
                                 GenJnlLine."Document No.":=SalesOrderHeader."No.";
                                 GenJnlLine.Description:=SalesOrderHeader."Sell-to Customer Name"+' -Ceding commission';
                                 GenJnlLine.Amount:=CedingCommission;
                                 GenJnlLine."Posting Group":='COMMREC';
                                 IntegrationSetup.GET;
                                 GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                                 GenJnlLine."Bal. Account No.":=IntegrationSetup."Treaty Commission G/L Acc";
                                 IF GenJnlLine.Amount<>0 THEN
                                 GenJnlLine.INSERT;}
        
                                      UNTIL
                                      TreatyReinsuranceShare.NEXT=0;
                                  END;
                                 END;
                                END;   */

    end;

    procedure ConvertQuote2DebitNote(var InsureHeader: Record "Insure Header");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
    begin

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::"Debit Note";
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy2.RESET;
        InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Document Type", InsureHeaderCopy2."Document Type"::Policy);
        InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Quotation No.", InsureHeader."No.");
        IF InsureHeaderCopy2.FINDFIRST THEN
            InsureHeaderCopy."Policy No" := InsureHeaderCopy2."No.";
        //MESSAGE('Policy no=%1',InsureHeaderCopy."Policy No");
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;

                InsureLinesCopy.TRANSFERFIELDS(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Start Date" := InsureHeaderCopy."Cover Start Date";
                InsureLinesCopy."End Date" := InsureHeaderCopy."Cover End Date";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT

                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.TRANSFERFIELDS(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;

            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.TRANSFERFIELDS(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;

            UNTIL InsureHeaderLoading_Discount.NEXT = 0;


        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.TRANSFERFIELDS(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;

                InstalmentLinesCopy.TRANSFERFIELDS(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        //Post Debit Note
        PostInsureHeader(InsureHeaderCopy);
    end;

    procedure ConvertQuote2Policy(var InsureHeader: Record "Insure Header");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
    begin
        //MESSAGE('Creating policy');

        InsureHeaderCopy.COPY(InsureHeader);
        IF InsureHeaderCopy.Status <> InsureHeaderCopy.Status::Released THEN
            ERROR('%1 %2 must be fully approved before being converted to a policy', InsureHeaderCopy."Document Type", InsureHeaderCopy."No.");

        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Policy;
        InsureHeaderCopy."No." := GeneratePolicyNos(InsureHeaderCopy);
        //MESSAGE('Policy No=%1',GeneratePolicyNos(InsureHeaderCopy));
        InsureHeaderCopy."Quotation No." := InsureHeader."No.";
        InsureHeaderCopy."Policy Status" := InsureHeaderCopy."Policy Status"::Live;
        InsureHeaderCopy.INSERT;


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;

                InsureLinesCopy.TRANSFERFIELDS(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Start Date" := InsureHeaderCopy."Cover Start Date";
                InsureLinesCopy."End Date" := InsureHeaderCopy."Cover End Date";
                IF InsureLinesCopy."Policy No" = '' THEN
                    InsureLinesCopy."Policy No" := InsureHeaderCopy."No.";

                IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::"Create New" THEN
                    InsureLinesCopy.Status := InsureLinesCopy.Status::Live;

                IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::Cancel THEN
                    InsureLinesCopy.Status := InsureLinesCopy.Status::Cancelled;
                IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::Suspend THEN
                    InsureLinesCopy.Status := InsureLinesCopy.Status::Suspended;
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.TRANSFERFIELDS(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT

                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.TRANSFERFIELDS(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.TRANSFERFIELDS(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;
            //MESSAGE('Inserting Coinsurance Partner %1 for Policy %2',Reinslines."Partner No.",InsureHeaderCopy."No.");
            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.TRANSFERFIELDS(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            //MESSAGE('Inserting Instalment No %1 for Policy %2',InstalmentLines."Payment No",InsureHeaderCopy."No.");
            UNTIL InstalmentLines.NEXT = 0;
    end;

    procedure ConvertQuote2CreditNote(var InsureHeader: Record "Insure Header");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        LoadingDiscSetup: Record "Loading and Discounts Setup";
    begin
        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::"Credit Note";
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLines."Start Date" := InsureHeaderCopy."Cover Start Date";
                InsureLines."End Date" := InsureHeaderCopy."Cover End Date";
                InsureLinesCopy.COPY(InsureLines);
                InsureLinesCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", InsureLinesCopy."Risk ID", InsureLinesCopy."Line No.");
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT

                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
            UNTIL AdditionalBenefits.NEXT = 0;





        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        //Eliminate Certificate Charge from Credit Notes
        LoadingDiscSetup.RESET;
        LoadingDiscSetup.SETRANGE(LoadingDiscSetup."Applicable to", LoadingDiscSetup."Applicable to"::"Certificate Charge");
        IF LoadingDiscSetup.FINDFIRST THEN
            InsureHeaderLoading_Discount.SETFILTER(InsureHeaderLoading_Discount.Code, '<>%1', LoadingDiscSetup.Code);
        //Eliminate Certificate
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT

                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", InsureHeaderLoading_DiscountCopy.Code);


            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT

                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy.RENAME(InsureHeader."Document Type", InsureHeader."No.", InstalmentLinesCopy."Payment No");
            UNTIL InstalmentLines.NEXT = 0;
    end;

    procedure PostInsureHeader(var InsureHeader: Record "Insure Header");
    var
        GenJnlLine: Record "Gen. Journal Line";
        AccountsMapping: Record "Insurance Accounting Mappings";
        Isetup: Record "Insurance setup";
        GenBatch: Record "Gen. Journal Batch";
        InsureLines: Record "Insure Lines";
        CoInsureReinsureBrokerLines: Record "Coinsurance Reinsurance Lines";
        TotalInvoice: Decimal;
        GLEntry: Record "G/L Entry";
        PostedDrHeader: Record "Insure Debit Note";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        PostedCrHeader: Record "Insure Credit Note";
        PostedDrLines: Record "Insure Debit Note Lines";
        PostedCrLines: Record "Insure Credit Note Lines";
        InsureHeaderOrder: Record "Insure Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CertificateforPrint: Record "Certificate Printing";
        UserDetails: Record "User Setup Details";
        PolicyType: Record "Policy Type";
        PolicyHeader: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        DimensionSetEntryRec: Record "Dimension Set Entry";
        DimensionSetEntryRecCopy: Record "Dimension Set Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        InsureLineRecCharges: Record "Insure Lines";
        LoadingDisc: Record "Loading and Discounts Setup";
        ChargesAmt: Decimal;
    begin
        IF InsureHeader.Posted THEN
            ERROR('This document is already posted');
        //MESSAGE('Posting No. Series=%1',InsureHeader."Posting No. Series");
        InsureHeader."Posting No." := NoSeriesMgt.GetNextNo(InsureHeader."Posting No. Series", InsureHeader."Posting Date", TRUE);
        //MESSAGE('Document No =%1 and Document Type=%2 and Policy No=%3',InsureHeader."No.",InsureHeader."Document Type",InsureHeader."Policy No");

        InsureHeader.TESTFIELD(InsureHeader."Policy No");
        TotalInvoice := 0;
        Isetup.GET;
        Isetup.TESTFIELD(Isetup."Insurance Template");
        GenBatch.INIT;
        GenBatch."Journal Template Name" := Isetup."Insurance Template";
        GenBatch.Name := InsureHeader."No.";
        IF NOT GenBatch.GET(GenBatch."Journal Template Name", GenBatch.Name) THEN
            GenBatch.INSERT;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", Isetup."Insurance Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", InsureHeader."No.");
        GenJnlLine.DELETEALL;

        AccountsMapping.RESET;
        AccountsMapping.SETRANGE(AccountsMapping."Class Code", InsureHeader."Policy Type");
        IF AccountsMapping.FINDFIRST THEN BEGIN
            //Premium
            InsureHeader.CALCFIELDS(InsureHeader."Total Premium Amount");
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
            GenJnlLine."Journal Batch Name" := InsureHeader."No.";
            GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
            GenJnlLine."Posting Date" := InsureHeader."Posting Date";
            GenJnlLine."Document No." := InsureHeader."Posting No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := AccountsMapping."Gross Premium Account";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");

            //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
            GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                GenJnlLine.Amount := -InsureHeader."Total Premium Amount";
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                GenJnlLine.Amount := InsureHeader."Total Premium Amount";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            TotalInvoice := TotalInvoice + GenJnlLine.Amount;

            GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
            GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
            GenJnlLine."Insured ID" := InsureHeader."Insured No.";
            GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Premium;
            GenJnlLine."Policy No" := InsureHeader."Policy No";
            IF InsureHeader."Endorsement Policy No." = '' THEN
                GenJnlLine."Endorsement No." := InsureHeader."Policy No"
            ELSE
                GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";

            GenJnlLine."Policy Type" := InsureHeader."Policy Type";
            GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
            GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
            GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
            GenJnlLine."Action Type" := InsureHeader."Action Type";
            GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
            GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
            GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
            GenJnlLine."Action Type" := InsureHeader."Action Type";
            IF GenJnlLine.Amount <> 0 THEN
                GenJnlLine.INSERT;
            //Tax
            DimensionSetEntryRec.RESET;
            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
            IF DimensionSetEntryRec.FINDFIRST THEN
                REPEAT

                    DimensionSetEntryRecCopy.INIT;
                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                        DimensionSetEntryRecCopy.INSERT;
                UNTIL DimensionSetEntryRec.NEXT = 0;

            InsureLines.RESET;
            InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
            InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
            InsureLines.SETRANGE(InsureLines."Description Type", InsureLines."Description Type"::Tax);
            IF InsureLines.FINDFIRST THEN
                REPEAT
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                    GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                    GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                    GenJnlLine."Document No." := InsureHeader."Posting No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := InsureLines."Account No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                        GenJnlLine.Amount := -InsureLines.Amount;
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                        GenJnlLine.Amount := InsureLines.Amount;
                    GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                    GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                    IF InsureHeader."Endorsement Policy No." = '' THEN
                        GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                    ELSE
                        GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                    TotalInvoice := TotalInvoice + GenJnlLine.Amount;
                    /*GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");

                    GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Tax;
                    GenJnlLine."Policy No" := InsureHeader."Policy No";
                    GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                    GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                    GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                    GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                    GenJnlLine."Action Type" := InsureHeader."Action Type";
                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;

                UNTIL InsureLines.NEXT = 0;





            IF InsureHeader."Premium Finance %" = 0 THEN BEGIN



                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                GenJnlLine."Document No." := InsureHeader."Posting No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                IF InsureHeader."Bill To Customer No." <> '' THEN
                    GenJnlLine."Account No." := InsureHeader."Bill To Customer No."
                ELSE
                    GenJnlLine."Account No." := InsureHeader."Insured No.";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);

                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                    GenJnlLine.Amount := -TotalInvoice;
                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                    GenJnlLine.Amount := -TotalInvoice;
                IF InsureHeader."Applies-to Doc. No." <> '' THEN BEGIN
                    GenJnlLine."Applies-to Doc. No." := InsureHeader."Applies-to Doc. No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                /* GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                 GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                //GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
                GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Net Premium";
                GenJnlLine."Policy No" := InsureHeader."Policy No";
                IF InsureHeader."Endorsement Policy No." = '' THEN
                    GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                ELSE
                    GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                GenJnlLine."Action Type" := InsureHeader."Action Type";
                DimensionSetEntryRec.RESET;
                DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                IF DimensionSetEntryRec.FINDFIRST THEN
                    REPEAT

                        DimensionSetEntryRecCopy.INIT;
                        DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                        DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                        DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                        DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                        DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                        DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                        IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                            DimensionSetEntryRecCopy.INSERT;
                    UNTIL DimensionSetEntryRec.NEXT = 0;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
            END
            ELSE BEGIN
                LoadingDisc.RESET;
                IF LoadingDisc.FINDFIRST THEN BEGIN
                    ChargesAmt := 0;
                    REPEAT
                        InsureLineRecCharges.RESET;
                        InsureLineRecCharges.SETRANGE(InsureLineRecCharges."Document Type", InsureHeader."Document Type");
                        InsureLineRecCharges.SETRANGE(InsureLineRecCharges."Document No.", InsureHeader."No.");
                        InsureLineRecCharges.SETFILTER(InsureLineRecCharges.Amount, '<>%1', 0);
                        IF InsureLineRecCharges.FINDFIRST THEN
                            REPEAT
                                IF ((LoadingDisc."Applicable to" = LoadingDisc."Applicable to"::"Certificate Charge") OR
                                    (LoadingDisc."Applicable to" = LoadingDisc."Applicable to"::COMESA)) THEN
                                    IF InsureLineRecCharges."Account No." = LoadingDisc."Account No." THEN BEGIN
                                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                                            ChargesAmt := ChargesAmt + (-InsureLineRecCharges.Amount);
                                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                                            ChargesAmt := ChargesAmt + InsureLineRecCharges.Amount;
                                    END;


                            UNTIL InsureLineRecCharges.NEXT = 0;
                    UNTIL LoadingDisc.NEXT = 0;
                END;
                // MESSAGE('Charges amount=%1',ChargesAmt);
                // MESSAGE('Total Invoice=%1 Charges amount=%2',TotalInvoice,ChargesAmt);
                TotalInvoice := TotalInvoice - ChargesAmt;

                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                GenJnlLine."Document No." := InsureHeader."Posting No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                IF InsureHeader."Bill To Customer No." <> '' THEN
                    GenJnlLine."Account No." := InsureHeader."Bill To Customer No."
                ELSE
                    GenJnlLine."Account No." := InsureHeader."Insured No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);

                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                    GenJnlLine.Amount := -TotalInvoice * (100 - InsureHeader."Premium Finance %") / 100;
                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                    GenJnlLine.Amount := -TotalInvoice * (100 - InsureHeader."Premium Finance %") / 100;
                IF InsureHeader."Applies-to Doc. No." <> '' THEN BEGIN
                    GenJnlLine."Applies-to Doc. No." := InsureHeader."Applies-to Doc. No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                /* GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                 GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                //GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
                GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Net Premium";
                GenJnlLine."Policy No" := InsureHeader."Policy No";
                IF InsureHeader."Endorsement Policy No." = '' THEN
                    GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                ELSE
                    GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                GenJnlLine."Action Type" := InsureHeader."Action Type";
                DimensionSetEntryRec.RESET;
                DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                IF DimensionSetEntryRec.FINDFIRST THEN
                    REPEAT

                        DimensionSetEntryRecCopy.INIT;
                        DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                        DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                        DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                        DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                        DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                        DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                        IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                            DimensionSetEntryRecCopy.INSERT;
                    UNTIL DimensionSetEntryRec.NEXT = 0;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;


                //Post charges --certificate charge etc
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                GenJnlLine."Document No." := InsureHeader."Posting No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                IF InsureHeader."Bill To Customer No." <> '' THEN
                    GenJnlLine."Account No." := InsureHeader."Bill To Customer No."
                ELSE
                    GenJnlLine."Account No." := InsureHeader."Insured No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);

                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                    GenJnlLine.Amount := -ChargesAmt;
                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                    GenJnlLine.Amount := -ChargesAmt;
                IF InsureHeader."Applies-to Doc. No." <> '' THEN BEGIN
                    GenJnlLine."Applies-to Doc. No." := InsureHeader."Applies-to Doc. No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                /* GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                 GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                //GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
                GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Net Premium";
                GenJnlLine."Policy No" := InsureHeader."Policy No";
                IF InsureHeader."Endorsement Policy No." = '' THEN
                    GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                ELSE
                    GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                GenJnlLine."Action Type" := InsureHeader."Action Type";
                DimensionSetEntryRec.RESET;
                DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                IF DimensionSetEntryRec.FINDFIRST THEN
                    REPEAT

                        DimensionSetEntryRecCopy.INIT;
                        DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                        DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                        DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                        DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                        DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                        DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                        IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                            DimensionSetEntryRecCopy.INSERT;
                    UNTIL DimensionSetEntryRec.NEXT = 0;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;








                //***post Premium financiers Portion

                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                GenJnlLine."Document No." := InsureHeader."Posting No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := InsureHeader."Premium Financier";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);

                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                    GenJnlLine.Amount := -TotalInvoice * (InsureHeader."Premium Finance %" / 100);
                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                    GenJnlLine.Amount := -TotalInvoice * (InsureHeader."Premium Finance %" / 100);
                IF InsureHeader."Applies-to Doc. No." <> '' THEN BEGIN
                    GenJnlLine."Applies-to Doc. No." := InsureHeader."Applies-to Doc. No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                /* GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                 GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                //GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
                GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Net Premium";
                GenJnlLine."Policy No" := InsureHeader."Policy No";
                IF InsureHeader."Endorsement Policy No." = '' THEN
                    GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                ELSE
                    GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                GenJnlLine."Action Type" := InsureHeader."Action Type";
                DimensionSetEntryRec.RESET;
                DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                IF DimensionSetEntryRec.FINDFIRST THEN
                    REPEAT

                        DimensionSetEntryRecCopy.INIT;
                        DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                        DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                        DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                        DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                        DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                        DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                        IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                            DimensionSetEntryRecCopy.INSERT;
                    UNTIL DimensionSetEntryRec.NEXT = 0;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;

            END;

            CoInsureReinsureBrokerLines.RESET;
            CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."Document Type", InsureHeader."Document Type");
            CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."No.", InsureHeader."No.");
            IF CoInsureReinsureBrokerLines.FINDFIRST THEN
                REPEAT

                    IF CoInsureReinsureBrokerLines."Transaction Type" = CoInsureReinsureBrokerLines."Transaction Type"::"Broker " THEN BEGIN

                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        // MESSAGE('Broker =%1',InsureHeader."Agent/Broker");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."Broker Commission";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."Broker Commission";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        /*GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                        GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                        GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Commission;
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := AccountsMapping."Gross Commission Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            //MESSAGE('Dimension =%1 Value=%2 Set ID=%3',DimensionSetEntryRecCopy."Dimension Code",DimensionSetEntryRecCopy."Dimension Value Code",GenJnlLine."Dimension Set ID");
                            UNTIL DimensionSetEntryRec.NEXT = 0;

                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."WHT Amount";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."WHT Amount";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        /*GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                        GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                        GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Wht;
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        IF Cust.GET(CoInsureReinsureBrokerLines."Partner No.") THEN
                            IF VATPostingSetup.GET(Cust."VAT Bus. Posting Group", Isetup."Default WHT Code") THEN
                                GenJnlLine."Bal. Account No." := VATPostingSetup."Sales VAT Account";
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;


                    END
                    ELSE BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;

                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        CoInsureReinsureBrokerLines.TESTFIELD(CoInsureReinsureBrokerLines."Partner No.");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines.Premium;
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines.Premium;
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        /* GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                         GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                         GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                         GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                        GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                        GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Reinsurance Premium";
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        AccountsMapping.TESTFIELD(AccountsMapping."Quota Share-Premium Account");

                        AccountsMapping.TESTFIELD(AccountsMapping."1st Surplus Account");
                        IF CoInsureReinsureBrokerLines."Quota Share" THEN
                            GenJnlLine."Bal. Account No." := AccountsMapping."Quota Share-Premium Account";
                        //MESSAGE('Quota share Premium ac=%1',GenJnlLine."Bal. Account No.");
                        IF CoInsureReinsureBrokerLines.Surplus THEN
                            GenJnlLine."Bal. Account No." := AccountsMapping."1st Surplus Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;

                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        CoInsureReinsureBrokerLines.TESTFIELD(CoInsureReinsureBrokerLines."Partner No.");
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."Cedant Commission";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."Cedant Commission";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Shortcut Dimension 1 Code" := InsureHeader."Shortcut Dimension 1 Code";
                        /* GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                         GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                         GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                        GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                        GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Reinsurance Commission";
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        AccountsMapping.TESTFIELD(AccountsMapping."Quata Share-Comm.Account");
                        AccountsMapping.TESTFIELD(AccountsMapping."1st Surplus Comm. Account");
                        //MESSAGE('Quota share comm ac=%1',AccountsMapping."Quata Share-Comm.Account");
                        IF CoInsureReinsureBrokerLines."Quota Share" THEN
                            GenJnlLine."Bal. Account No." := AccountsMapping."Quata Share-Comm.Account";
                        IF CoInsureReinsureBrokerLines.Surplus THEN
                            GenJnlLine."Bal. Account No." := AccountsMapping."1st Surplus Comm. Account";
                        GenJnlLine.TESTFIELD(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;


                    END;


                UNTIL CoInsureReinsureBrokerLines.NEXT = 0;




        END
        ELSE
            ERROR('Please set account mappings for class %1', InsureHeader."Policy Type");


        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

        GLEntry.RESET;
        GLEntry.SETCURRENTKEY(GLEntry."Document No.");
        GLEntry.SETRANGE(GLEntry."Document No.", InsureHeader."Posting No.");
        //GLEntry.SETRANGE(GLEntry.Reversed,FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN



            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN BEGIN
                PostedDrHeader.INIT;
                PostedDrHeader.TRANSFERFIELDS(InsureHeader);
                PostedDrHeader."No." := InsureHeader."Posting No.";
                PolicyHeader.RESET;
                PolicyHeader.SETRANGE(PolicyHeader."Document Type", PolicyHeader."Document Type"::Policy);
                PolicyHeader.SETRANGE(PolicyHeader."Quotation No.", InsureHeader."Copied from No.");
                IF PolicyHeader.FINDFIRST THEN BEGIN
                    PostedDrHeader."Endorsement Policy No." := PolicyHeader."No.";

                END;
                PostedDrHeader.INSERT;


                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT

                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT

                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", InsureHeaderLoading_DiscountCopy.Code);


                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT

                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", InstalmentLinesCopy."Payment No");
                    UNTIL InstalmentLines.NEXT = 0;




            END;
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN BEGIN
                PostedCrHeader.INIT;
                PostedCrHeader.TRANSFERFIELDS(InsureHeader);
                PostedCrHeader."No." := InsureHeader."Posting No.";
                PolicyHeader.RESET;
                PolicyHeader.SETRANGE(PolicyHeader."Document Type", PolicyHeader."Document Type"::Policy);
                PolicyHeader.SETRANGE(PolicyHeader."Quotation No.", InsureHeader."Copied from No.");
                IF PolicyHeader.FINDFIRST THEN BEGIN
                    PostedCrHeader."Endorsement Policy No." := PolicyHeader."No.";

                END;
                PostedCrHeader.INSERT;

                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT

                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT

                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", InsureHeaderLoading_DiscountCopy.Code);


                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT

                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", InstalmentLinesCopy."Payment No");
                    UNTIL InstalmentLines.NEXT = 0;



            END;


            InsureLines.RESET;
            InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
            InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");

            IF InsureLines.FINDFIRST THEN
                REPEAT
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN BEGIN
                        PostedDrLines.INIT;
                        PostedDrLines.TRANSFERFIELDS(InsureLines);
                        PostedDrLines."Document No." := InsureHeader."Posting No.";
                        IF (PostedDrLines."Description Type" = PostedDrLines."Description Type"::"Schedule of Insured") OR (PostedDrLines.Amount <> 0) THEN
                            PostedDrLines.INSERT;
                        CertificateforPrint.INIT;
                        CertificateforPrint."Document No." := PostedDrLines."Document No.";
                        CertificateforPrint."Line No." := PostedDrLines."Line No.";
                        CertificateforPrint."Registration No." := PostedDrLines."Registration No.";
                        CertificateforPrint.Make := PostedDrLines.Make;
                        CertificateforPrint."Year of Manufacture" := PostedDrLines."Year of Manufacture";
                        CertificateforPrint."Type of Body" := PostedDrLines."Type of Body";
                        CertificateforPrint.Amount := PostedDrLines.Amount;
                        CertificateforPrint."Policy Type" := PostedDrLines."Policy Type";
                        CertificateforPrint."Policy No" := InsureHeader."Policy No";
                        CertificateforPrint."Start Date" := InsureHeader."Cover Start Date";
                        CertificateforPrint."End Date" := InsureHeader."Cover End Date";
                        CertificateforPrint."No. Of Instalments" := PostedDrLines."No. Of Instalments";
                        CertificateforPrint."Chassis No." := PostedDrLines."Chassis No.";
                        CertificateforPrint."Engine No." := PostedDrLines."Engine No.";
                        CertificateforPrint."Seating Capacity" := PostedDrLines."Seating Capacity";
                        CertificateforPrint."Carrying Capacity" := PostedDrLines."Carrying Capacity";
                        CertificateforPrint."Vehicle License Class" := PostedDrLines."Vehicle License Class";
                        CertificateforPrint."Vehicle Usage" := PostedDrLines."Vehicle Usage";
                        CertificateforPrint."Certificate Status" := CertificateforPrint."Certificate Status"::Active;
                        /*IF PolicyType.GET(CertificateforPrint."Policy Type") THEN
                        CertificateforPrint."Certificate Type":=PolicyType."Certificate Type";*/
                        IF PolicyType.GET(CertificateforPrint."Policy Type") THEN BEGIN
                            IF PolicyType."Bus Seating Capacity Cut-off" <> 0 THEN BEGIN
                                IF CertificateforPrint."Seating Capacity" <= PolicyType."Bus Seating Capacity Cut-off" THEN
                                    CertificateforPrint."Certificate Type" := PolicyType."Certificate Type"
                                ELSE
                                    CertificateforPrint."Certificate Type" := PolicyType."Certificate Type Bus";
                            END
                            ELSE
                                CertificateforPrint."Certificate Type" := PolicyType."Certificate Type"
                        END;
                        IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN
                            IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::"Create New" THEN
                                //MESSAGE('%1',CertificateforPrint."Certificate Type");
                                IF CertificateforPrint."Registration No." <> '' THEN
                                    CertificateforPrint.INSERT;

                    END;

                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN BEGIN
                        PostedCrLines.INIT;
                        PostedCrLines.TRANSFERFIELDS(InsureLines);
                        PostedCrLines."Document No." := InsureHeader."Posting No.";
                        IF (PostedCrLines."Description Type" = PostedCrLines."Description Type"::"Schedule of Insured") OR (PostedCrLines.Amount <> 0) THEN
                            PostedCrLines.INSERT;
                    END;

                UNTIL InsureLines.NEXT = 0;

            GLEntry.RESET;
            GLEntry.SETRANGE(GLEntry."Document No.", InsureHeader."Posting No.");
            GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
            IF GLEntry.FINDFIRST THEN BEGIN
                // MESSAGE('Entry posted');
                /*InsureLines.RESET;
                InsureLines.SETRANGE(InsureLines."Document Type",InsureHeader."Document Type");
                InsureLines.SETRANGE(InsureLines."Document No.",InsureHeader."No.");
                InsureLines.DELETEALL;*/
                PostedDrHeader.SETRECFILTER;
                PostedDrHeader.PrintRecords(FALSE);

                IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::Cancel THEN
                    EffectCancellation(InsureHeader);

                IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::Suspend THEN
                    EffectSuspension(InsureHeader);

                IF EndorsementType."Action Type" = EndorsementType."Action Type"::Renewal THEN
                    EffectRenewal(InsureHeader);

                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy.DELETE(TRUE);
                InsureHeaderOrder.RESET;
                InsureHeaderOrder.SETRANGE(InsureHeaderOrder."Document Type", InsureHeaderOrder."Document Type"::Endorsement);
                InsureHeaderOrder.SETRANGE(InsureHeaderOrder."No.", InsureHeader."Copied from No.");
                IF InsureHeaderOrder.FINDFIRST THEN
                    InsureHeaderOrder.DELETE(TRUE);

                InsureHeaderOrder.RESET;
                InsureHeaderOrder.SETRANGE(InsureHeaderOrder."Document Type", InsureHeaderOrder."Document Type"::Quote);
                InsureHeaderOrder.SETRANGE(InsureHeaderOrder."No.", InsureHeader."Quotation No.");
                IF InsureHeaderOrder.FINDFIRST THEN
                    InsureHeaderOrder.DELETE(TRUE);


            END;
        END;
        //MESSAGE('Finished!!!');

    end;

    //Bkk 17.03.2021 /Posting for Brokerage
    procedure PostInsureHeaderB(var InsureHeader: Record "Insure Header");
    var
        GenJnlLine: Record "Gen. Journal Line";
        AccountsMapping: Record "Insurance Accounting Mappings";
        Isetup: Record "Insurance setup";
        GenBatch: Record "Gen. Journal Batch";
        InsureLines: Record "Insure Lines";
        CoInsureReinsureBrokerLines: Record "Coinsurance Reinsurance Lines";
        TotalInvoice: Decimal;
        GLEntry: Record "G/L Entry";
        PostedDrHeader: Record "Insure Debit Note";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        PostedCrHeader: Record "Insure Credit Note";
        PostedDrLines: Record "Insure Debit Note Lines";
        PostedCrLines: Record "Insure Credit Note Lines";
        InsureHeaderOrder: Record "Insure Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CertificateforPrint: Record "Certificate Printing";
        UserDetails: Record "User Setup Details";
        PolicyType: Record "Underwriter Policy Types";
        PolicyHeader: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        DimensionSetEntryRec: Record "Dimension Set Entry";
        DimensionSetEntryRecCopy: Record "Dimension Set Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        InsureLineRecCharges: Record "Insure Lines";
        LoadingDisc: Record "Loading and Discounts Setup";
        ChargesAmt: Decimal;
    begin
        IF InsureHeader.Posted THEN
            ERROR('This document is already posted');
        //MESSAGE('Posting No. Series=%1',InsureHeader."Posting No. Series");
        InsureHeader."Posting No." := NoSeriesMgt.GetNextNo(InsureHeader."Posting No. Series", InsureHeader."Posting Date", TRUE);
        //MESSAGE('Document No =%1 and Document Type=%2 and Policy No=%3',InsureHeader."No.",InsureHeader."Document Type",InsureHeader."Policy No");

        InsureHeader.TESTFIELD(InsureHeader."Policy No");
        TotalInvoice := 0;
        Isetup.GET;
        Isetup.TESTFIELD(Isetup."Insurance Template");
        GenBatch.INIT;
        GenBatch."Journal Template Name" := Isetup."Insurance Template";
        GenBatch.Name := InsureHeader."No.";
        IF NOT GenBatch.GET(GenBatch."Journal Template Name", GenBatch.Name) THEN
            GenBatch.INSERT;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", Isetup."Insurance Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", InsureHeader."No.");
        GenJnlLine.DELETEALL;

        //AccountsMapping.RESET;
        //AccountsMapping.SETRANGE(AccountsMapping."Class Code", InsureHeader."Policy Type");
        IF PolicyType.GET(InsureHeader."Policy Type") THEN BEGIN
            //Premium
            InsureHeader.CALCFIELDS(InsureHeader."Total Premium Amount");
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
            GenJnlLine."Journal Batch Name" := InsureHeader."No.";
            GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
            GenJnlLine."Posting Date" := InsureHeader."Posting Date";
            GenJnlLine."Document No." := InsureHeader."Posting No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Customer";
            GenJnlLine."Account No." := InsureHeader."Bill To Customer No.";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");

            //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
            GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                GenJnlLine.Amount := -InsureHeader."Total Premium Amount";
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                GenJnlLine.Amount := InsureHeader."Total Premium Amount";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            TotalInvoice := TotalInvoice + GenJnlLine.Amount;

            GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
            GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
            GenJnlLine."Insured ID" := InsureHeader."Insured No.";
            GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Premium;
            GenJnlLine."Policy No" := InsureHeader."Policy No";
            IF InsureHeader."Endorsement Policy No." = '' THEN
                GenJnlLine."Endorsement No." := InsureHeader."Policy No"
            ELSE
                GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";

            GenJnlLine."Policy Type" := InsureHeader."Policy Type";
            GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
            GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
            GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
            GenJnlLine."Action Type" := InsureHeader."Action Type";
            GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
            GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
            GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
            GenJnlLine."Action Type" := InsureHeader."Action Type";
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Vendor;
            //GenJnlLine."Bal. Account No.":=InsureHeader.Underwriter;
            //GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");


            IF GenJnlLine.Amount <> 0 THEN
                GenJnlLine.INSERT;

            //Tax
            DimensionSetEntryRec.RESET;
            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
            IF DimensionSetEntryRec.FINDFIRST THEN
                REPEAT

                    DimensionSetEntryRecCopy.INIT;
                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                        DimensionSetEntryRecCopy.INSERT;
                UNTIL DimensionSetEntryRec.NEXT = 0;
            ///End Premium debit note posting
            /*InsureLines.RESET;
            InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
            InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
            InsureLines.SETRANGE(InsureLines."Description Type", InsureLines."Description Type"::Tax);
            IF InsureLines.FINDFIRST THEN
                REPEAT
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                    GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                    GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                    GenJnlLine."Document No." := InsureHeader."Posting No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := InsureLines."Account No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                        GenJnlLine.Amount := -InsureLines.Amount;
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                        GenJnlLine.Amount := InsureLines.Amount;
                    GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                    GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                    IF InsureHeader."Endorsement Policy No." = '' THEN
                        GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                    ELSE
                        GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                    TotalInvoice := TotalInvoice + GenJnlLine.Amount;
                    /*GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");

                    GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Tax;
                    GenJnlLine."Policy No" := InsureHeader."Policy No";
                    GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                    GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                    GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                    GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                    GenJnlLine."Action Type" := InsureHeader."Action Type";
                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;

                UNTIL InsureLines.NEXT = 0;
                */






            /*IF InsureHeader."Premium Finance %" = 0 THEN BEGIN



                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                GenJnlLine."Document No." := InsureHeader."Posting No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                IF InsureHeader."Bill To Customer No." <> '' THEN
                    GenJnlLine."Account No." := InsureHeader."Bill To Customer No."
                ELSE
                    GenJnlLine."Account No." := InsureHeader."Insured No.";
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);

                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                    GenJnlLine.Amount := -TotalInvoice;
                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                    GenJnlLine.Amount := -TotalInvoice;
                IF InsureHeader."Applies-to Doc. No." <> '' THEN BEGIN
                    GenJnlLine."Applies-to Doc. No." := InsureHeader."Applies-to Doc. No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                /* GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                 GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                //GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
                GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Net Premium";
                GenJnlLine."Policy No" := InsureHeader."Policy No";
                IF InsureHeader."Endorsement Policy No." = '' THEN
                    GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                ELSE
                    GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                GenJnlLine."Action Type" := InsureHeader."Action Type";
                DimensionSetEntryRec.RESET;
                DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                IF DimensionSetEntryRec.FINDFIRST THEN
                    REPEAT

                        DimensionSetEntryRecCopy.INIT;
                        DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                        DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                        DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                        DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                        DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                        DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                        IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                            DimensionSetEntryRecCopy.INSERT;
                    UNTIL DimensionSetEntryRec.NEXT = 0;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
            END
            ELSE BEGIN
                LoadingDisc.RESET;
                IF LoadingDisc.FINDFIRST THEN BEGIN
                    ChargesAmt := 0;
                    REPEAT
                        InsureLineRecCharges.RESET;
                        InsureLineRecCharges.SETRANGE(InsureLineRecCharges."Document Type", InsureHeader."Document Type");
                        InsureLineRecCharges.SETRANGE(InsureLineRecCharges."Document No.", InsureHeader."No.");
                        InsureLineRecCharges.SETFILTER(InsureLineRecCharges.Amount, '<>%1', 0);
                        IF InsureLineRecCharges.FINDFIRST THEN
                            REPEAT
                                IF ((LoadingDisc."Applicable to" = LoadingDisc."Applicable to"::"Certificate Charge") OR
                                    (LoadingDisc."Applicable to" = LoadingDisc."Applicable to"::COMESA)) THEN
                                    IF InsureLineRecCharges."Account No." = LoadingDisc."Account No." THEN BEGIN
                                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                                            ChargesAmt := ChargesAmt + (-InsureLineRecCharges.Amount);
                                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                                            ChargesAmt := ChargesAmt + InsureLineRecCharges.Amount;
                                    END;


                            UNTIL InsureLineRecCharges.NEXT = 0;
                    UNTIL LoadingDisc.NEXT = 0;
                END;
                // MESSAGE('Charges amount=%1',ChargesAmt);
                // MESSAGE('Total Invoice=%1 Charges amount=%2',TotalInvoice,ChargesAmt);
                TotalInvoice := TotalInvoice - ChargesAmt;

                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                GenJnlLine."Document No." := InsureHeader."Posting No.";
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                IF InsureHeader."Bill To Customer No." <> '' THEN
                    GenJnlLine."Account No." := InsureHeader."Bill To Customer No."
                ELSE
                    GenJnlLine."Account No." := InsureHeader."Insured No.";
                GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);

                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                    GenJnlLine.Amount := -TotalInvoice * (100 - InsureHeader."Premium Finance %") / 100;
                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                    GenJnlLine.Amount := -TotalInvoice * (100 - InsureHeader."Premium Finance %") / 100;
                IF InsureHeader."Applies-to Doc. No." <> '' THEN BEGIN
                    GenJnlLine."Applies-to Doc. No." := InsureHeader."Applies-to Doc. No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                END;
                GenJnlLine.VALIDATE(GenJnlLine.Amount);
                /* GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                 GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                 GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                //GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
                GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Net Premium";
                GenJnlLine."Policy No" := InsureHeader."Policy No";
                IF InsureHeader."Endorsement Policy No." = '' THEN
                    GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                ELSE
                    GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                GenJnlLine."Action Type" := InsureHeader."Action Type";
                DimensionSetEntryRec.RESET;
                DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                IF DimensionSetEntryRec.FINDFIRST THEN
                    REPEAT

                        DimensionSetEntryRecCopy.INIT;
                        DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                        DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                        DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                        DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                        DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                        DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                        IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                            DimensionSetEntryRecCopy.INSERT;
                    UNTIL DimensionSetEntryRec.NEXT = 0;
                IF GenJnlLine.Amount <> 0 THEN
                    GenJnlLine.INSERT;
            */
            /*

               //Post charges --certificate charge etc
               GenJnlLine.INIT;
               GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
               GenJnlLine."Journal Batch Name" := InsureHeader."No.";
               GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
               GenJnlLine."Posting Date" := InsureHeader."Posting Date";
               GenJnlLine."Document No." := InsureHeader."Posting No.";
               GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
               IF InsureHeader."Bill To Customer No." <> '' THEN
                   GenJnlLine."Account No." := InsureHeader."Bill To Customer No."
               ELSE
                   GenJnlLine."Account No." := InsureHeader."Insured No.";
               GenJnlLine.VALIDATE(GenJnlLine."Account No.");
               //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
               GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);

               IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                   GenJnlLine.Amount := -ChargesAmt;
               IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                   GenJnlLine.Amount := -ChargesAmt;
               IF InsureHeader."Applies-to Doc. No." <> '' THEN BEGIN
                   GenJnlLine."Applies-to Doc. No." := InsureHeader."Applies-to Doc. No.";
                   GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
               END;
               GenJnlLine.VALIDATE(GenJnlLine.Amount);
               /* GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
               //GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
               GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
               GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
               GenJnlLine."Insured ID" := InsureHeader."Insured No.";

               GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Net Premium";
               GenJnlLine."Policy No" := InsureHeader."Policy No";
               IF InsureHeader."Endorsement Policy No." = '' THEN
                   GenJnlLine."Endorsement No." := InsureHeader."Policy No"
               ELSE
                   GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
               GenJnlLine."Policy Type" := InsureHeader."Policy Type";
               GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
               GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
               GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
               GenJnlLine."Action Type" := InsureHeader."Action Type";
               DimensionSetEntryRec.RESET;
               DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
               IF DimensionSetEntryRec.FINDFIRST THEN
                   REPEAT

                       DimensionSetEntryRecCopy.INIT;
                       DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                       DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                       DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                       DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                       DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                       DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                       IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                           DimensionSetEntryRecCopy.INSERT;
                   UNTIL DimensionSetEntryRec.NEXT = 0;
               IF GenJnlLine.Amount <> 0 THEN
                   GenJnlLine.INSERT;
                   */








            //***post Premium financiers Portion

            /*GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
            GenJnlLine."Journal Batch Name" := InsureHeader."No.";
            GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
            GenJnlLine."Posting Date" := InsureHeader."Posting Date";
            GenJnlLine."Document No." := InsureHeader."Posting No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            GenJnlLine."Account No." := InsureHeader."Premium Financier";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
            GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);

            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                GenJnlLine.Amount := -TotalInvoice * (InsureHeader."Premium Finance %" / 100);
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                GenJnlLine.Amount := -TotalInvoice * (InsureHeader."Premium Finance %" / 100);
            IF InsureHeader."Applies-to Doc. No." <> '' THEN BEGIN
                GenJnlLine."Applies-to Doc. No." := InsureHeader."Applies-to Doc. No.";
                GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
            END;
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            /* GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
             GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
             GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
             GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
            //GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
            GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
            GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
            GenJnlLine."Insured ID" := InsureHeader."Insured No.";

            GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Net Premium";
            GenJnlLine."Policy No" := InsureHeader."Policy No";
            IF InsureHeader."Endorsement Policy No." = '' THEN
                GenJnlLine."Endorsement No." := InsureHeader."Policy No"
            ELSE
                GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
            GenJnlLine."Policy Type" := InsureHeader."Policy Type";
            GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
            GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
            GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
            GenJnlLine."Action Type" := InsureHeader."Action Type";
            DimensionSetEntryRec.RESET;
            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
            IF DimensionSetEntryRec.FINDFIRST THEN
                REPEAT

                    DimensionSetEntryRecCopy.INIT;
                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                        DimensionSetEntryRecCopy.INSERT;
                UNTIL DimensionSetEntryRec.NEXT = 0;
            IF GenJnlLine.Amount <> 0 THEN
                GenJnlLine.INSERT;

        END;
        */

            CoInsureReinsureBrokerLines.RESET;
            CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."Document Type", InsureHeader."Document Type");
            CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."No.", InsureHeader."No.");
            IF CoInsureReinsureBrokerLines.FINDFIRST THEN
                REPEAT

                    IF CoInsureReinsureBrokerLines."Transaction Type" = CoInsureReinsureBrokerLines."Transaction Type"::"Co-insurance" THEN BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        // MESSAGE('Broker =%1',InsureHeader."Agent/Broker");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."Broker Commission";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."Broker Commission";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        /*GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                        GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                        GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Commission;
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := AccountsMapping."Gross Commission Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            //MESSAGE('Dimension =%1 Value=%2 Set ID=%3',DimensionSetEntryRecCopy."Dimension Code",DimensionSetEntryRecCopy."Dimension Value Code",GenJnlLine."Dimension Set ID");
                            UNTIL DimensionSetEntryRec.NEXT = 0;
                    END;
                    IF CoInsureReinsureBrokerLines."Transaction Type" = CoInsureReinsureBrokerLines."Transaction Type"::"Broker " THEN BEGIN

                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        // MESSAGE('Broker =%1',InsureHeader."Agent/Broker");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."Broker Commission";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."Broker Commission";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        /*GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                        GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                        GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Commission;
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := AccountsMapping."Gross Commission Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            //MESSAGE('Dimension =%1 Value=%2 Set ID=%3',DimensionSetEntryRecCopy."Dimension Code",DimensionSetEntryRecCopy."Dimension Value Code",GenJnlLine."Dimension Set ID");
                            UNTIL DimensionSetEntryRec.NEXT = 0;

                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."WHT Amount";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."WHT Amount";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        /*GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");*/
                        GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                        GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Wht;
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        IF Cust.GET(CoInsureReinsureBrokerLines."Partner No.") THEN
                            IF VATPostingSetup.GET(Cust."VAT Bus. Posting Group", Isetup."Default WHT Code") THEN
                                GenJnlLine."Bal. Account No." := VATPostingSetup."Sales VAT Account";
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;


                    END;
                /*ELSE BEGIN
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                    GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                    GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                    GenJnlLine."Document No." := InsureHeader."Posting No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;

                    GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                    CoInsureReinsureBrokerLines.TESTFIELD(CoInsureReinsureBrokerLines."Partner No.");
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                        GenJnlLine.Amount := -CoInsureReinsureBrokerLines.Premium;
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                        GenJnlLine.Amount := CoInsureReinsureBrokerLines.Premium;
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    /* GenJnlLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                     GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                     GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                     GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                    GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                    GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Reinsurance Premium";
                    GenJnlLine."Policy No" := InsureHeader."Policy No";
                    IF InsureHeader."Endorsement Policy No." = '' THEN
                        GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                    ELSE
                        GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    AccountsMapping.TESTFIELD(AccountsMapping."Quota Share-Premium Account");

                    AccountsMapping.TESTFIELD(AccountsMapping."1st Surplus Account");
                    IF CoInsureReinsureBrokerLines."Quota Share" THEN
                        GenJnlLine."Bal. Account No." := AccountsMapping."Quota Share-Premium Account";
                    //MESSAGE('Quota share Premium ac=%1',GenJnlLine."Bal. Account No.");
                    IF CoInsureReinsureBrokerLines.Surplus THEN
                        GenJnlLine."Bal. Account No." := AccountsMapping."1st Surplus Account";
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                    GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                    GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                    GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                    GenJnlLine."Action Type" := InsureHeader."Action Type";

                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;

                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;

                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := InsureHeader."No.";
                    GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                    GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                    GenJnlLine."Document No." := InsureHeader."Posting No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                    GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                    CoInsureReinsureBrokerLines.TESTFIELD(CoInsureReinsureBrokerLines."Partner No.");
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                        GenJnlLine.Amount := CoInsureReinsureBrokerLines."Cedant Commission";
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                        GenJnlLine.Amount := -CoInsureReinsureBrokerLines."Cedant Commission";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Shortcut Dimension 1 Code" := InsureHeader."Shortcut Dimension 1 Code";
                    /* GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                     GenJnlLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                     GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine."Effective Start Date" := InsureHeader."Cover Start Date";
                    GenJnlLine."Effective End Date" := InsureHeader."Cover End Date";
                    GenJnlLine."Insured ID" := InsureHeader."Insured No.";

                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Reinsurance Commission";
                    GenJnlLine."Policy No" := InsureHeader."Policy No";
                    IF InsureHeader."Endorsement Policy No." = '' THEN
                        GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                    ELSE
                        GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    AccountsMapping.TESTFIELD(AccountsMapping."Quata Share-Comm.Account");
                    AccountsMapping.TESTFIELD(AccountsMapping."1st Surplus Comm. Account");
                    //MESSAGE('Quota share comm ac=%1',AccountsMapping."Quata Share-Comm.Account");
                    IF CoInsureReinsureBrokerLines."Quota Share" THEN
                        GenJnlLine."Bal. Account No." := AccountsMapping."Quata Share-Comm.Account";
                    IF CoInsureReinsureBrokerLines.Surplus THEN
                        GenJnlLine."Bal. Account No." := AccountsMapping."1st Surplus Comm. Account";
                    GenJnlLine.TESTFIELD(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                    GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                    GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                    GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                    GenJnlLine."Action Type" := InsureHeader."Action Type";
                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;

                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;


                END;*/


                UNTIL CoInsureReinsureBrokerLines.NEXT = 0;




        END
        ELSE
            ERROR('Please select Policy Type for %1', InsureHeader."No.");


        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

        GLEntry.RESET;
        GLEntry.SETCURRENTKEY(GLEntry."Document No.");
        GLEntry.SETRANGE(GLEntry."Document No.", InsureHeader."Posting No.");
        //GLEntry.SETRANGE(GLEntry.Reversed,FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN



            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN BEGIN
                PostedDrHeader.INIT;
                PostedDrHeader.TRANSFERFIELDS(InsureHeader);
                PostedDrHeader."No." := InsureHeader."Posting No.";
                PolicyHeader.RESET;
                PolicyHeader.SETRANGE(PolicyHeader."Document Type", PolicyHeader."Document Type"::Policy);
                PolicyHeader.SETRANGE(PolicyHeader."Quotation No.", InsureHeader."Copied from No.");
                IF PolicyHeader.FINDFIRST THEN BEGIN
                    PostedDrHeader."Endorsement Policy No." := PolicyHeader."No.";

                END;
                PostedDrHeader.INSERT;


                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT

                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT

                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", InsureHeaderLoading_DiscountCopy.Code);


                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT

                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", InstalmentLinesCopy."Payment No");
                    UNTIL InstalmentLines.NEXT = 0;




            END;
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN BEGIN
                PostedCrHeader.INIT;
                PostedCrHeader.TRANSFERFIELDS(InsureHeader);
                PostedCrHeader."No." := InsureHeader."Posting No.";
                PolicyHeader.RESET;
                PolicyHeader.SETRANGE(PolicyHeader."Document Type", PolicyHeader."Document Type"::Policy);
                PolicyHeader.SETRANGE(PolicyHeader."Quotation No.", InsureHeader."Copied from No.");
                IF PolicyHeader.FINDFIRST THEN BEGIN
                    PostedCrHeader."Endorsement Policy No." := PolicyHeader."No.";

                END;
                PostedCrHeader.INSERT;

                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT

                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT

                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", InsureHeaderLoading_DiscountCopy.Code);


                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT

                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", InstalmentLinesCopy."Payment No");
                    UNTIL InstalmentLines.NEXT = 0;



            END;


            InsureLines.RESET;
            InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
            InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");

            IF InsureLines.FINDFIRST THEN
                REPEAT
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN BEGIN
                        PostedDrLines.INIT;
                        PostedDrLines.TRANSFERFIELDS(InsureLines);
                        PostedDrLines."Document No." := InsureHeader."Posting No.";
                        IF (PostedDrLines."Description Type" = PostedDrLines."Description Type"::"Schedule of Insured") OR (PostedDrLines.Amount <> 0) THEN
                            PostedDrLines.INSERT;
                        CertificateforPrint.INIT;
                        CertificateforPrint."Document No." := PostedDrLines."Document No.";
                        CertificateforPrint."Line No." := PostedDrLines."Line No.";
                        CertificateforPrint."Registration No." := PostedDrLines."Registration No.";
                        CertificateforPrint.Make := PostedDrLines.Make;
                        CertificateforPrint."Year of Manufacture" := PostedDrLines."Year of Manufacture";
                        CertificateforPrint."Type of Body" := PostedDrLines."Type of Body";
                        CertificateforPrint.Amount := PostedDrLines.Amount;
                        CertificateforPrint."Policy Type" := PostedDrLines."Policy Type";
                        CertificateforPrint."Policy No" := InsureHeader."Policy No";
                        CertificateforPrint."Start Date" := InsureHeader."Cover Start Date";
                        CertificateforPrint."End Date" := InsureHeader."Cover End Date";
                        CertificateforPrint."No. Of Instalments" := PostedDrLines."No. Of Instalments";
                        CertificateforPrint."Chassis No." := PostedDrLines."Chassis No.";
                        CertificateforPrint."Engine No." := PostedDrLines."Engine No.";
                        CertificateforPrint."Seating Capacity" := PostedDrLines."Seating Capacity";
                        CertificateforPrint."Carrying Capacity" := PostedDrLines."Carrying Capacity";
                        CertificateforPrint."Vehicle License Class" := PostedDrLines."Vehicle License Class";
                        CertificateforPrint."Vehicle Usage" := PostedDrLines."Vehicle Usage";
                        CertificateforPrint."Certificate Status" := CertificateforPrint."Certificate Status"::Active;
                        /*IF PolicyType.GET(CertificateforPrint."Policy Type") THEN
                        CertificateforPrint."Certificate Type":=PolicyType."Certificate Type";*/
                        IF PolicyType.GET(CertificateforPrint."Policy Type") THEN BEGIN
                            IF PolicyType."Bus Seating Capacity Cut-off" <> 0 THEN BEGIN
                                IF CertificateforPrint."Seating Capacity" <= PolicyType."Bus Seating Capacity Cut-off" THEN
                                    CertificateforPrint."Certificate Type" := PolicyType."Certificate Type"
                                ELSE
                                    CertificateforPrint."Certificate Type" := PolicyType."Certificate Type Bus";
                            END
                            ELSE
                                CertificateforPrint."Certificate Type" := PolicyType."Certificate Type"
                        END;
                        IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN
                            IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::"Create New" THEN
                                //MESSAGE('%1',CertificateforPrint."Certificate Type");
                                IF CertificateforPrint."Registration No." <> '' THEN
                                    CertificateforPrint.INSERT;

                    END;

                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN BEGIN
                        PostedCrLines.INIT;
                        PostedCrLines.TRANSFERFIELDS(InsureLines);
                        PostedCrLines."Document No." := InsureHeader."Posting No.";
                        IF (PostedCrLines."Description Type" = PostedCrLines."Description Type"::"Schedule of Insured") OR (PostedCrLines.Amount <> 0) THEN
                            PostedCrLines.INSERT;
                    END;

                UNTIL InsureLines.NEXT = 0;

            GLEntry.RESET;
            GLEntry.SETRANGE(GLEntry."Document No.", InsureHeader."Posting No.");
            GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
            IF GLEntry.FINDFIRST THEN BEGIN
                // MESSAGE('Entry posted');
                /*InsureLines.RESET;
                InsureLines.SETRANGE(InsureLines."Document Type",InsureHeader."Document Type");
                InsureLines.SETRANGE(InsureLines."Document No.",InsureHeader."No.");
                InsureLines.DELETEALL;*/
                PostedDrHeader.SETRECFILTER;
                PostedDrHeader.PrintRecords(FALSE);

                IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::Cancel THEN
                    EffectCancellation(InsureHeader);

                IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::Suspend THEN
                    EffectSuspension(InsureHeader);

                IF EndorsementType."Action Type" = EndorsementType."Action Type"::Renewal THEN
                    EffectRenewal(InsureHeader);

                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy.DELETE(TRUE);
                InsureHeaderOrder.RESET;
                InsureHeaderOrder.SETRANGE(InsureHeaderOrder."Document Type", InsureHeaderOrder."Document Type"::Endorsement);
                InsureHeaderOrder.SETRANGE(InsureHeaderOrder."No.", InsureHeader."Copied from No.");
                IF InsureHeaderOrder.FINDFIRST THEN
                    InsureHeaderOrder.DELETE(TRUE);

                InsureHeaderOrder.RESET;
                InsureHeaderOrder.SETRANGE(InsureHeaderOrder."Document Type", InsureHeaderOrder."Document Type"::Quote);
                InsureHeaderOrder.SETRANGE(InsureHeaderOrder."No.", InsureHeader."Quotation No.");
                IF InsureHeaderOrder.FINDFIRST THEN
                    InsureHeaderOrder.DELETE(TRUE);


            END;
        END;
        MESSAGE('Finished!!!');

    end;


    //Bkk
    procedure ConvertPolicy2RenewalQuote(var InsureHeader: Record "Insure Header");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
    begin
        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Quote;
        InsureHeaderCopy."Policy No" := InsureHeader."No.";
        InsureHeaderCopy."Quote Type" := InsureHeader."Quote Type"::Renewal;
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeader."Document Type";
                ReinslinesCopy."No." := InsureHeader."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeader."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeader."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
    end;

    procedure Endorsement(var InsureHeader: Record "Insure Header");
    var
        SalesQuote: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        SalesQuoteLine: Record "Insure Lines";
    begin

        IF InsureHeader."Policy Status" = InsureHeader."Policy Status"::Live THEN BEGIN


            SalesQuote.INIT;
            SalesQuote.TRANSFERFIELDS(InsureHeader);
            SalesQuote."Document Type" := SalesQuote."Document Type"::Quote;
            SalesQuote.Status := SalesQuote.Status::Open;
            SalesQuote."Posting Date" := TODAY;
            SalesQuote."Document Date" := TODAY;
            SalesQuote."Modification Type" := SalesQuote."Modification Type"::Addition;
            SalesQuote."Quote Type" := SalesQuote."Quote Type"::Modification;
            SalesQuote."No." := '';
            // SalesQuote."Shipping No.":='';
            // SalesQuote."Posting No.":='';
            SalesQuote."Insurer Policy No" := InsureHeader."No.";
            SalesQuote."Mid Term Adjustment Factor" := CalculateMidTermFactor(SalesQuote);
            //MESSAGE('%1',SalesQuote."Mid Term Adjustment Factor");
            SalesQuote.INSERT(TRUE);

            PolicyLines.RESET;
            PolicyLines.SETRANGE(PolicyLines."Document Type", InsureHeader."Document Type");
            PolicyLines.SETRANGE(PolicyLines."Document No.", InsureHeader."No.");
            PolicyLines.SETFILTER(PolicyLines."Description Type", '<>%1', PolicyLines."Description Type"::"Schedule of Insured");
            IF PolicyLines.FIND('-') THEN BEGIN
                REPEAT
                    SalesQuoteLine.INIT;
                    SalesQuoteLine.COPY(PolicyLines);
                    SalesQuoteLine."Document No." := SalesQuote."No.";
                    SalesQuoteLine."Document Type" := SalesQuote."Document Type";
                    SalesQuoteLine.INSERT;

                UNTIL PolicyLines.NEXT = 0;
            END;
        END;

        IF SalesQuote."Cover Type" = SalesQuote."Cover Type"::Group THEN
            PAGE.RUN(51513070, SalesQuote);




        IF SalesQuote."Cover Type" = SalesQuote."Cover Type"::Group THEN
            PAGE.RUN(51513070, SalesQuote);
    end;

    procedure PolicyDeletion(var InsureHeader: Record "Insure Header");
    var
        SalesQuote: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        SalesQuoteLine: Record "Insure Lines";
    begin

        //CurrForm.Policymembers.FORM.GetmembertoDelete;
        IF InsureHeader."Policy Status" = InsureHeader."Policy Status"::Live THEN BEGIN


            SalesQuote.INIT;
            SalesQuote.TRANSFERFIELDS(InsureHeader);
            SalesQuote."Document Type" := SalesQuote."Document Type"::"Credit Note";
            SalesQuote.Status := SalesQuote.Status::Open;
            // SalesQuote."Order Date":=TODAY;
            SalesQuote."Posting Date" := TODAY;
            SalesQuote."Document Date" := TODAY;
            SalesQuote."Modification Type" := SalesQuote."Modification Type"::Deletion;
            SalesQuote."Quote Type" := SalesQuote."Quote Type"::Modification;
            SalesQuote."No." := '';
            //SalesQuote."Shipping No.":='';
            // SalesQuote."Posting No.":='';
            SalesQuote."Insurer Policy No" := InsureHeader."No.";
            InsureHeader."Policy No" := InsureHeader."No.";
            SalesQuote."Mid Term Adjustment Factor" := CalculateMidTermFactor(SalesQuote);

            //MESSAGE('%1',SalesQuote."Mid Term Adjustment Factor");
            SalesQuote.INSERT(TRUE);

            PolicyLines.RESET;
            PolicyLines.SETRANGE(PolicyLines."Document Type", InsureHeader."Document Type");
            PolicyLines.SETRANGE(PolicyLines."Document No.", InsureHeader."No.");
            PolicyLines.SETRANGE(PolicyLines."Mark for Deletion", TRUE);
            IF PolicyLines.FIND('-') THEN BEGIN
                REPEAT
                    SalesQuoteLine.INIT;
                    SalesQuoteLine.COPY(PolicyLines);
                    SalesQuoteLine."Document No." := SalesQuote."No.";
                    SalesQuoteLine."Document Type" := SalesQuote."Document Type";
                    SalesQuoteLine."Deletion Date" := SalesQuote."Document Date";

                    SalesQuoteLine.INSERT;

                UNTIL PolicyLines.NEXT = 0;
            END;

            PolicyLines.RESET;
            PolicyLines.SETRANGE(PolicyLines."Document Type", InsureHeader."Document Type");
            PolicyLines.SETRANGE(PolicyLines."Document No.", InsureHeader."No.");
            PolicyLines.SETFILTER(PolicyLines."Description Type", '<>%1', PolicyLines."Description Type"::
            "Schedule of Insured");
            IF PolicyLines.FIND('-') THEN BEGIN
                REPEAT
                    SalesQuoteLine.INIT;
                    SalesQuoteLine.COPY(PolicyLines);
                    SalesQuoteLine."Document No." := SalesQuote."No.";
                    SalesQuoteLine."Document Type" := SalesQuote."Document Type";
                    IF PolicyLines."Description Type" = PolicyLines."Description Type"::Tax THEN BEGIN
                        // SalesQuoteLine."Qty. to Ship":=0;
                        // SalesQuoteLine."Return Qty. to Receive":=1;
                    END;
                    SalesQuoteLine.INSERT;

                UNTIL PolicyLines.NEXT = 0;
            END;



        END;
        IF SalesQuote."Cover Type" = SalesQuote."Cover Type"::Individual THEN
            PAGE.RUN(51513078, SalesQuote);

        IF SalesQuote."Cover Type" = SalesQuote."Cover Type"::Group THEN
            PAGE.RUN(51513078, SalesQuote);
    end;

    procedure RenewPolicy(var InsureHeader: Record "Insure Header");
    var
        InsQuote: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        InsQLines: Record "Insure Lines";
    begin

        IF InsureHeader."Policy Status" = InsureHeader."Policy Status"::Live THEN BEGIN
            IF InsureHeader."Expected Renewal Date" > WORKDATE THEN
                IF CONFIRM('This policy is not due for renewal..do you want to continue?', FALSE) THEN BEGIN
                    InsQuote.INIT;
                    InsQuote.TRANSFERFIELDS(InsureHeader);
                    InsQuote."Quote Type" := InsQuote."Quote Type"::Renewal;
                    InsQuote."Document Type" := InsQuote."Document Type"::Quote;
                    InsQuote."Posting Date" := InsureHeader."Expected Renewal Date";
                    InsQuote."Document Date" := InsureHeader."Expected Renewal Date";
                    InsQuote."No." := '';
                    //InsQuote."Shipping No.":='';
                    //InsQuote."Posting No.":='';
                    InsQuote."Insurer Policy No" := InsureHeader."No.";
                    InsQuote."Policy No" := InsureHeader."No.";
                    InsQuote.Status := InsQuote.Status::Open;


                    InsQuote."From Date" := InsureHeader."Expected Renewal Date";
                    InsQuote.VALIDATE(InsQuote."From Date");
                    IF InsuranceSetup.GET THEN
                        InsQuote."No." := '';
                    //InsQuote.VALIDATE(InsQuote."No.");


                    InsQuote.INSERT(TRUE);

                    PolicyLines.RESET;
                    PolicyLines.SETRANGE(PolicyLines."Document Type", InsureHeader."Document Type");
                    PolicyLines.SETRANGE(PolicyLines."Document No.", InsureHeader."No.");
                    IF PolicyLines.FIND('-') THEN BEGIN
                        REPEAT
                            InsQLines.INIT;
                            InsQLines.TRANSFERFIELDS(PolicyLines);
                            InsQLines."Document Type" := InsQLines."Document Type"::Quote;
                            InsQLines.VALIDATE(InsQLines."Date of Birth");
                            InsQLines."Document No." := InsQuote."No.";
                            InsQLines.INSERT;

                        UNTIL PolicyLines.NEXT = 0;
                    END;
                    IF InsureHeader."Cover Type" = InsureHeader."Cover Type"::Individual THEN
                        PAGE.RUN(51513065, InsQuote);

                    IF InsureHeader."Cover Type" = InsureHeader."Cover Type"::Group THEN
                        PAGE.RUN(51513065, InsQuote);

                END;

        END
        ELSE
            ERROR('This is not an active/live policy');
    end;

    procedure CancelPolicy(var InsureHeader: Record "Insure Header");
    var
        SalesCrmemoHeader: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        SalesCrmemoLines: Record "Insure Lines";
    begin


        SalesCrmemoHeader.INIT;

        SalesCrmemoHeader.TRANSFERFIELDS(InsureHeader);
        SalesCrmemoHeader."Document Type" := SalesCrmemoHeader."Document Type"::"Credit Note";
        SalesCrmemoHeader.Status := SalesCrmemoHeader.Status::Open;
        SalesCrmemoHeader."No." := '';
        //SalesCrmemoHeader."Shipping No.":='';
        //SalesCrmemoHeader."Posting No.":='';
        //SalesCrmemoHeader."Pmt. Discount Date":=0D;

        SalesCrmemoHeader.INSERT(TRUE);

        PolicyLines.RESET;
        PolicyLines.SETRANGE(PolicyLines."Document Type", InsureHeader."Document Type");
        PolicyLines.SETRANGE(PolicyLines."Document No.", InsureHeader."No.");
        IF PolicyLines.FIND('-') THEN BEGIN
            REPEAT
                SalesCrmemoLines.INIT;
                SalesCrmemoLines.TRANSFERFIELDS(PolicyLines);

                SalesCrmemoLines."Document Type" := SalesCrmemoLines."Document Type"::"Credit Note";
                //MESSAGE('%1',SalesCrmemoHeader."No.");
                SalesCrmemoLines."Document No." := SalesCrmemoHeader."No.";
                SalesCrmemoLines.INSERT;



            UNTIL PolicyLines.NEXT = 0;

        END;
    end;

    procedure AcceptQuote(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
    begin

        IF InsureHeader."Document Type" = InsureHeader."Document Type"::Quote THEN
            IF InsureHeader.CheckCustomerCreated(TRUE) THEN
                InsureHeader.GET(InsureHeader."Document Type"::Quote, InsureHeader."No.")
            ELSE
                EXIT;

        InsureHeader.TESTFIELD(InsureHeader."Document Type", InsureHeader."Document Type"::Quote);
        CheckInProgressOpportunities(InsureHeader);
        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::"Accepted Quote";
        InsureHeaderCopy."Policy No" := InsureHeader."No.";
        InsureHeaderCopy."Quote Type" := InsureHeader."Quote Type"::New;
        IF Contact.GET(InsureHeaderCopy."Contact No.") THEN BEGIN

            Cust.RESET;
            Cust.SETRANGE(Cust."ID/Passport No.", Contact."Family Name");
            IF Cust.FINDLAST THEN BEGIN
                InsureHeaderCopy."Insured No." := Cust."No.";
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Insured No.");

            END
            ELSE BEGIN
                //Contact.CreateCustomer(InsureHeaderCopy."Insure Template Code");

            END;



        END;






        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        MoveWonLostOpportunites(InsureHeader, InsureHeaderCopy);
    end;

    procedure GenerateCovers(var InsureHeader: Record "Insure Header");
    var
        RiskCovers: Record "Risk Covers";
        PolicyLines: Record "Insure Lines";
        StartDate: Date;
        i: Integer;
        PaymentTerms: Record "No. of Instalments";
        RiskCoverCopy: Record "Risk Covers";
    begin
        // MESSAGE('Yes being triggered');

        RiskCovers.RESET;
        RiskCovers.SETRANGE(RiskCovers."Policy No.", InsureHeader."No.");
        RiskCovers.DELETEALL;
        PolicyLines.RESET;
        PolicyLines.SETRANGE(PolicyLines."Document Type", InsureHeader."Document Type");
        PolicyLines.SETRANGE(PolicyLines."Document No.", InsureHeader."No.");
        PolicyLines.SETRANGE(PolicyLines."Description Type", PolicyLines."Description Type"::"Schedule of Insured");
        //PolicyLines.SETFILTER(PolicyLines."Risk ID", '<>%1', '');

        IF PolicyLines.FINDFIRST THEN
            REPEAT

                IF InsureHeader."No." <> '' THEN BEGIN
                    IF PaymentTerms.GET(InsureHeader."No. Of Instalments") THEN BEGIN
                        IF PaymentTerms."No. Of Instalments" > 1 THEN BEGIN

                            StartDate := InsureHeader."From Date";
                            FOR i := 1 TO PaymentTerms."No. Of Instalments" DO BEGIN
                                RiskCovers.INIT;
                                RiskCovers."Policy No." := PolicyLines."Document No.";
                                //RiskCovers."Risk Id" := PolicyLines."Risk ID";
                                RiskCovers."Cover No." := i;

                                // PaymentSchedule."Amount Due":=TotalPremium/PaymentTerms."No. of Payments";

                                IF i = 1 THEN BEGIN

                                    RiskCovers."Cover Start Date" := StartDate;
                                    RiskCovers."Cover End Date" := CALCDATE(PaymentTerms."Period Length", RiskCovers."Cover Start Date") - 1;

                                END
                                ELSE BEGIN
                                    StartDate := CALCDATE(PaymentTerms."Period Length", StartDate);
                                    RiskCovers."Cover Start Date" := StartDate;
                                    RiskCovers."Cover End Date" := CALCDATE(PaymentTerms."Period Length", RiskCovers."Cover Start Date") - 1;

                                END;


                                IF RiskCovers.GET(RiskCovers."Policy No.", RiskCovers."Risk Id", RiskCovers."Cover No.") THEN
                                    RiskCovers.MODIFY
                                ELSE
                                    RiskCovers.INSERT;

                            END;

                        END;
                    END;
                END;

            //MESSAGE('Vehicle no=%1 and month=%2',PolicyLines."Risk ID",i);
            UNTIL PolicyLines.NEXT = 0;
    end;

    procedure SuspendCover(var Riskcover: Record "Risk Covers");
    begin
        IF Riskcover."Suspension Date" = 0D THEN
            ERROR('Please indicate the date for suspension and ask the insured to bring back the current certificate');
        Riskcover.Status := Riskcover.Status::Suspended;
        Riskcover.MODIFY;
    end;

    procedure ReinstateCover(var Riskcover: Record "Risk Covers");
    var
        RiskCoverCopy: Record "Risk Covers";
    begin
        IF Riskcover."Re-instatement Date" = 0D THEN
            ERROR('You must specify the reinstatement date for the cover');
        RiskCoverCopy.INIT;
        RiskCoverCopy.TRANSFERFIELDS(Riskcover);
        RiskCoverCopy."Re-instatement Date" := 0D;
        RiskCoverCopy.Status := RiskCoverCopy.Status::Active;
        RiskCoverCopy."Cover Start Date" := Riskcover."Re-instatement Date";
        RiskCoverCopy.INSERT(TRUE);
    end;

    procedure ExtendCover(var RiskCover: Record "Risk Covers");
    var
        RiskcoverCopy: Record "Risk Covers";
    begin
        IF FORMAT(RiskCover."Extension Period") = '' THEN
            ERROR('Please specify the extension period');
        RiskcoverCopy.INIT;
        RiskcoverCopy.TRANSFERFIELDS(RiskCover);
        RiskcoverCopy."Re-instatement Date" := 0D;
        RiskcoverCopy.Status := RiskcoverCopy.Status::Active;
        RiskcoverCopy."Cover Start Date" := RiskCover."Cover End Date" + 1;

        RiskcoverCopy."Cover End Date" := CALCDATE(RiskCover."Extension Period", RiskcoverCopy."Cover Start Date") - 1;
        RiskcoverCopy.INSERT(TRUE);
    end;

    procedure GenerateFirstCover(var InsureHeader: Record "Insure Header");
    var
        RiskCovers: Record "Risk Covers";
        PolicyLines: Record "Insure Lines";
        i: Integer;
    begin
        RiskCovers.RESET;
        RiskCovers.SETRANGE(RiskCovers."Policy No.", InsureHeader."No.");
        RiskCovers.DELETEALL;
        PolicyLines.RESET;
        PolicyLines.SETRANGE(PolicyLines."Document Type", InsureHeader."Document Type");
        PolicyLines.SETRANGE(PolicyLines."Document No.", InsureHeader."No.");
        PolicyLines.SETRANGE(PolicyLines."Description Type", PolicyLines."Description Type"::"Schedule of Insured");
        //PolicyLines.SETFILTER(PolicyLines."Risk ID", '<>%1', '');

        IF PolicyLines.FINDFIRST THEN
            REPEAT

                IF InsureHeader."No." <> '' THEN BEGIN
                    i := 1;
                    //StartDate:=InsureHeader."From Date";
                    RiskCovers.INIT;
                    RiskCovers."Policy No." := PolicyLines."Document No.";
                    //RiskCovers."Risk Id" := PolicyLines."Risk ID";
                    RiskCovers."Cover No." := i;
                    RiskCovers."Cover Start Date" := InsureHeader."Cover Start Date";
                    RiskCovers."Cover End Date" := InsureHeader."Cover End Date";

                    // PaymentSchedule."Amount Due":=TotalPremium/PaymentTerms."No. of Payments";





                    IF RiskCovers.GET(RiskCovers."Policy No.", RiskCovers."Risk Id", RiskCovers."Cover No.") THEN
                        RiskCovers.MODIFY
                    ELSE
                        RiskCovers.INSERT;

                END;



            //MESSAGE('Vehicle no=%1 and month=%2',PolicyLines."Risk ID",i);
            UNTIL PolicyLines.NEXT = 0;
    end;

    procedure GetNoOfMonths(var Startdate: Date; var EndDate: Date) NoOfmonths: Integer;
    var
        NextmonthStart: Date;
        CoverEndDate: Date;
    begin
        NoOfmonths := 0;
        NextmonthStart := Startdate;
        REPEAT
            NextmonthStart := CALCDATE('1M', NextmonthStart);
            CoverEndDate := NextmonthStart - 1;
            IF CoverEndDate <= EndDate THEN BEGIN
                NoOfmonths := NoOfmonths + 1;
                //MESSAGE('Doc Date=%1 and Nextmonth=%2',EndDate,NextmonthStart);
            END;
        UNTIL NextmonthStart >= EndDate;
    end;

    procedure ConvertPolicy2DebitNote(var InsureHeader: Record "Insure Header"; var RiskCover: Record "Risk Covers");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
    begin
        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::"Debit Note";
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy2.RESET;
        InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Document Type", InsureHeaderCopy2."Document Type"::Policy);
        InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Quotation No.", InsureHeader."No.");
        IF InsureHeaderCopy2.FINDFIRST THEN
            InsureHeaderCopy."Policy No" := InsureHeaderCopy2."No.";
        InsureHeaderCopy."Cover Start Date" := RiskCover."Cover Start Date";
        InsureHeaderCopy."Cover End Date" := RiskCover."Cover End Date";
        InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Cover End Date");

        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;

                InsureLinesCopy.TRANSFERFIELDS(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.TRANSFERFIELDS(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.TRANSFERFIELDS(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;

            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT

                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy.RENAME(InsureHeader."Document Type", InsureHeader."No.", InstalmentLinesCopy."Payment No");
            UNTIL InstalmentLines.NEXT = 0;
    end;

    procedure SubstituteRisk(var RiskCover: Record "Risk Covers");
    var
        RiskcoverCopy: Record "Risk Covers";
        PolicyHeader: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        PolicyLinesCopy: Record "Insure Lines";
    begin
        IF RiskCover."Substitution Date" = 0D THEN
            ERROR('Please specify substitution date');


        IF RiskCover."Substitute Risk ID" = '' THEN
            ERROR('Please specify substitution risk id');

        RiskcoverCopy.INIT;
        RiskcoverCopy.TRANSFERFIELDS(RiskCover);
        RiskcoverCopy."Re-instatement Date" := 0D;
        RiskcoverCopy.Status := RiskcoverCopy.Status::Active;
        RiskcoverCopy."Cover Start Date" := RiskCover."Substitution Date";
        RiskcoverCopy.VALIDATE(RiskcoverCopy."Cover End Date");
        RiskcoverCopy.INSERT(TRUE);

        IF PolicyHeader.GET(PolicyHeader."Document Type"::Policy, RiskCover."Policy No.") THEN BEGIN
            //Insert
            PolicyLines.INIT;
            PolicyLines."Document Type" := PolicyHeader."Document Type";
            PolicyLines."Document No." := PolicyHeader."No.";
            //PolicyLines."Risk ID" := RiskCover."Substitute Risk ID";
            PolicyLines."Description Type" := PolicyLines."Description Type"::"Schedule of Insured";
            PolicyLines."Endorsement Date" := RiskCover."Substitution Date";
            PolicyLines.INSERT;


            PolicyLinesCopy.RESET;
            PolicyLinesCopy.SETRANGE(PolicyLinesCopy."Document Type", PolicyLinesCopy."Document Type"::Policy);
            PolicyLinesCopy.SETRANGE(PolicyLinesCopy."Document No.", RiskCover."Policy No.");
            //PolicyLinesCopy.SETRANGE(PolicyLinesCopy."Risk ID", RiskCover."Risk Id");
            IF PolicyLinesCopy.FINDFIRST THEN BEGIN
                PolicyLinesCopy."Deletion Date" := RiskCover."Substitution Date";
                PolicyLinesCopy.Status := PolicyLinesCopy.Status::Live;
                PolicyLinesCopy.MODIFY;
            END;

            ConvertPolicy2DebitNote(PolicyHeader, RiskcoverCopy);


        END;
    end;

    procedure PostClaimsNew(var Claim: Record Claim);
    var
        Isetup: Record "Insurance setup";
        ClaimsLines: Record "Claim Lines";
        GenJnLine: Record "Gen. Journal Line";
        LineNo: Integer;
        PolicyHeader: Record "Sales Header";
        GLEntry: Record "G/L Entry";
        Batch: Record "Gen. Journal Batch";
        ClaimReservationLines: Record "Claim Reservation lines";
    begin

        IF CONFIRM('Are you sure u want post Claim no ' + Claim."Claim No" + ' ?', FALSE) = TRUE THEN BEGIN
            //IF Claim.Status<>Claim.Status::Released THEN
            //   ERROR('The Claim no '+Rec.ClaimNumber+' has not been fully approved\Check that the status is released');
            Claim.CALCFIELDS(Claim."Reserve Amount");
            //IF Claim.GrossAmount=0 THEN
            //  ERROR('Amount cannot be zero');
            //Claim.TESTFIELD(Claim.Policy);
            Isetup.GET;

            //Delete any lines available on the Journal Lines
            GenJnLine.RESET;
            GenJnLine.SETRANGE(GenJnLine."Journal Template Name", Isetup."Insurance Template");
            GenJnLine.SETRANGE(GenJnLine."Journal Batch Name", Claim."Claim No");
            GenJnLine.DELETEALL;

            Batch.INIT;
            Batch."Journal Template Name" := Isetup."Insurance Template";
            Batch.Name := Claim."Claim No";
            IF NOT Batch.GET(Batch."Journal Template Name", Batch.Name) THEN
                Batch.INSERT;
            // Get Treaty Details
            //GetTreaty(Rec);
            //*********//
            IntegrationSetup.RESET;
            IF IntegrationSetup.FINDFIRST THEN BEGIN
                ClaimReservationLines.RESET;
                ClaimReservationLines.SETRANGE(ClaimReservationLines.Posted, FALSE);
                IF ClaimReservationLines.FINDFIRST THEN BEGIN
                    REPEAT
                        LineNo := LineNo + 10000;
                        GenJnLine.INIT;
                        GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnLine."Journal Batch Name" := Claim."Claim No";
                        GenJnLine."Line No." := LineNo;
                        GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                        GenJnLine."Account No." := IntegrationSetup."Claim Reserve";
                        GenJnLine.VALIDATE(GenJnLine."Account No.");
                        GenJnLine."Posting Date" := TODAY;
                        GenJnLine."Document No." := Claim."Claim No";
                        GenJnLine.Description := 'Claims for ' + FORMAT(Claim."Policy No");

                        GenJnLine."Bal. Account No." := IntegrationSetup."Claims Reserves OS";
                        GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                        GenJnLine.Amount := ClaimReservationLines.Amount;
                        GenJnLine.VALIDATE(GenJnLine.Amount);
                        GenJnLine."External Document No." := Claim."Policy No";
                        IF GenJnLine.Amount <> 0 THEN
                            GenJnLine.INSERT;
                    UNTIL ClaimReservationLines.NEXT = 0;

                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnLine);


                    GLEntry.RESET;
                    GLEntry.SETRANGE(GLEntry."Document No.", Claim."Claim No");
                    GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
                    IF GLEntry.FINDFIRST THEN BEGIN

                        Claim.MODIFY(TRUE);
                    END;
                    ClaimReservationLines.RESET;
                    ClaimReservationLines.SETRANGE(ClaimReservationLines.Posted, FALSE);
                    IF ClaimReservationLines.FINDFIRST THEN BEGIN
                        REPEAT
                            ClaimReservationLines.Posted := TRUE;
                            ClaimReservationLines.MODIFY;
                        UNTIL ClaimReservationLines.NEXT = 0;
                    END;

                END;
            END;
        END;
    end;

    procedure PostClaimsReserve(var ClaimReserve: Record "Claim Reservation Header");
    var
        Isetup: Record "Insurance setup";
        ClaimsLines: Record "Claim Lines";
        GenJnLine: Record "Gen. Journal Line";
        LineNo: Integer;
        PolicyHeader: Record "Insure Header";
        GLEntry: Record "G/L Entry";
        Batch: Record "Gen. Journal Batch";
        ClaimReservationLines: Record "Claim Reservation lines";
        ReinsureLines: Record "Coinsurance Reinsurance Lines";
        PreviousReserve: Record "Claim Reservation Header";
    begin
        IF ClaimReserve.Posted THEN
            ERROR('Claim Reservation %1 is already posted', ClaimReserve."Claim No.");
        CreateReservationReinsEntries(ClaimReserve);

        IF CONFIRM('Are you sure u want post Claim Reservation no ' + ClaimReserve."No." + ' ?', FALSE) = TRUE THEN BEGIN
            /*IF Claim.Status<>Claim.Status::Released THEN
              ERROR('The Claim no '+Rec.ClaimNumber+' has not been fully approved\Check that the status is released');*/
            ClaimReserve.CALCFIELDS(ClaimReserve."Reserve Amount");
            //IF Claim.GrossAmount=0 THEN
            //  ERROR('Amount cannot be zero');
            //Claim.TESTFIELD(Claim.Policy);
            Isetup.GET;

            //Delete any lines available on the Journal Lines
            GenJnLine.RESET;
            GenJnLine.SETRANGE(GenJnLine."Journal Template Name", Isetup."Insurance Template");
            GenJnLine.SETRANGE(GenJnLine."Journal Batch Name", InsuranceSetup."Insurance Batch");
            GenJnLine.DELETEALL;

            Batch.INIT;
            Batch."Journal Template Name" := Isetup."Insurance Template";
            Batch.Name := InsuranceSetup."Insurance Batch";
            IF NOT Batch.GET(Batch."Journal Template Name", Batch.Name) THEN
                Batch.INSERT;
            // Get Treaty Details
            //GetTreaty(Rec);
            //*********//
            //MESSAGE('Class=%1',ClaimReserve."Insurance Class");
            IntegrationSetup.RESET;
            IntegrationSetup.SETRANGE(IntegrationSetup."Class Code", ClaimReserve."Insurance Class");
            IF IntegrationSetup.FINDFIRST THEN BEGIN
                IF ClaimReserve."Previous Reserve Amount" <> 0 THEN BEGIN
                    //MESSAGE('get to the previous');
                    LineNo := LineNo + 10000;
                    GenJnLine.INIT;
                    GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                    GenJnLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                    GenJnLine."Line No." := LineNo;
                    GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                    GenJnLine."Account No." := IntegrationSetup."Claim Reserve";
                    GenJnLine.VALIDATE(GenJnLine."Account No.");
                    GenJnLine."Posting Date" := TODAY;
                    GenJnLine."Document No." := ClaimReserve."No.";
                    GenJnLine.Description := 'Reversal of ' + FORMAT(ClaimReserve."Claim No.");
                    GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::"Claim Reserve";
                    //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
                    //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                    GenJnLine."Shortcut Dimension 1 Code" := ClaimReserve."Shortcut Dimension 1 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                    GenJnLine."Shortcut Dimension 2 Code" := ClaimReserve."Shortcut Dimension 2 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                    GenJnLine."Shortcut Dimension 3 Code" := ClaimReserve."Shortcut Dimension 3 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                    GenJnLine."Shortcut Dimension 4 Code" := ClaimReserve."Shortcut Dimension 4 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");


                    //GenJnLine."Shortcut Dimension 3 Code":=ClaimReserve."Shortcut Dimension 3 Code";

                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                    GenJnLine.Amount := -ClaimReserve."Previous Reserve Amount";
                    GenJnLine.VALIDATE(GenJnLine.Amount);
                    GenJnLine."Claim No." := ClaimReserve."Claim No.";
                    GenJnLine."Claimant ID" := ClaimReserve."Claimant ID";
                    GenJnLine."External Document No." := ClaimReserve."Claim No.";
                    GenJnLine."Policy Type" := ClaimReserve."Insurance Class";

                    IF GenJnLine.Amount <> 0 THEN
                        GenJnLine.INSERT;


                    LineNo := LineNo + 10000;
                    GenJnLine.INIT;
                    GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                    GenJnLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                    GenJnLine."Line No." := LineNo;
                    //Introduced by BKK to enable posting to vendor sub-ledger
                    IF PreviousReserve.GET(ClaimReserve."Revised Reserve Link") THEN
                        ;
                    IF PreviousReserve."Service Provider Code" = '' THEN BEGIN
                        GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                        GenJnLine."Account No." := IntegrationSetup."Claims Reserves OS";
                        GenJnLine.VALIDATE(GenJnLine."Account No.");
                    END;
                    IF PreviousReserve."Service Provider Code" <> '' THEN BEGIN
                        GenJnLine."Account Type" := GenJnLine."Account Type"::Vendor;
                        GenJnLine."Account No." := PreviousReserve."Service Provider Code";
                        GenJnLine.VALIDATE(GenJnLine."Account No.");
                        GenJnLine."External Document No." := PreviousReserve."Invoice No.";
                        GenJnLine."Posting Group" := IntegrationSetup."Claims Out. Posting Group";
                        GenJnLine.VALIDATE(GenJnLine."Posting Group");
                    END;

                    GenJnLine."Posting Date" := TODAY;
                    GenJnLine."Document No." := ClaimReserve."No.";
                    GenJnLine.Description := 'Reversal of ' + FORMAT(ClaimReserve."Claim No.");
                    //GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Claim Reserve";
                    //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
                    //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                    GenJnLine."Shortcut Dimension 1 Code" := ClaimReserve."Shortcut Dimension 1 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                    GenJnLine."Shortcut Dimension 2 Code" := ClaimReserve."Shortcut Dimension 2 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                    GenJnLine."Shortcut Dimension 3 Code" := ClaimReserve."Shortcut Dimension 3 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                    GenJnLine."Shortcut Dimension 4 Code" := ClaimReserve."Shortcut Dimension 4 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                    GenJnLine.Amount := ClaimReserve."Previous Reserve Amount";
                    GenJnLine.VALIDATE(GenJnLine.Amount);
                    GenJnLine."Claim No." := ClaimReserve."Claim No.";
                    GenJnLine."Claimant ID" := ClaimReserve."Claimant ID";
                    GenJnLine."External Document No." := ClaimReserve."Claim No.";
                    IF GenJnLine.Amount <> 0 THEN
                        GenJnLine.INSERT;
                END;

                //MESSAGE('get to the current');
                LineNo := LineNo + 10000;
                GenJnLine.INIT;
                GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                GenJnLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                GenJnLine."Line No." := LineNo;
                GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                GenJnLine."Account No." := IntegrationSetup."Claim Reserve";
                GenJnLine.VALIDATE(GenJnLine."Account No.");
                GenJnLine."Posting Date" := TODAY;
                GenJnLine."Document No." := ClaimReserve."No.";
                GenJnLine.Description := 'Claims for ' + FORMAT(ClaimReserve."Claim No.");
                GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::"Claim Reserve";
                //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
                //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                GenJnLine."Shortcut Dimension 1 Code" := ClaimReserve."Shortcut Dimension 1 Code";
                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                GenJnLine."Shortcut Dimension 2 Code" := ClaimReserve."Shortcut Dimension 2 Code";
                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                GenJnLine."Shortcut Dimension 3 Code" := ClaimReserve."Shortcut Dimension 3 Code";
                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                GenJnLine."Shortcut Dimension 4 Code" := ClaimReserve."Shortcut Dimension 4 Code";
                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                GenJnLine.Amount := ClaimReserve."Reserve Amount";
                GenJnLine.VALIDATE(GenJnLine.Amount);
                GenJnLine."External Document No." := ClaimReserve."Claim No.";
                GenJnLine."Claim No." := ClaimReserve."Claim No.";
                GenJnLine."Claimant ID" := ClaimReserve."Claimant ID";
                GenJnLine."Policy Type" := ClaimReserve."Insurance Class";
                IF GenJnLine.Amount <> 0 THEN
                    GenJnLine.INSERT;

                LineNo := LineNo + 10000;
                GenJnLine.INIT;
                GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                GenJnLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                GenJnLine."Line No." := LineNo;

                IF ClaimReserve."Service Provider Code" = '' THEN BEGIN
                    GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                    GenJnLine."Account No." := IntegrationSetup."Claims Reserves OS";
                    GenJnLine.VALIDATE(GenJnLine."Account No.");
                END;
                IF ClaimReserve."Service Provider Code" <> '' THEN BEGIN
                    GenJnLine."Account Type" := GenJnLine."Account Type"::Vendor;
                    GenJnLine."Account No." := ClaimReserve."Service Provider Code";
                    GenJnLine.VALIDATE(GenJnLine."Account No.");
                    GenJnLine."Posting Group" := IntegrationSetup."Claims Out. Posting Group";
                    GenJnLine.VALIDATE(GenJnLine."Posting Group");
                END;


                GenJnLine."Posting Date" := TODAY;
                GenJnLine."Document No." := ClaimReserve."No.";
                GenJnLine.Description := 'Claims Reservation for ' + FORMAT(ClaimReserve."Claim No.");
                //GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Claim Reserve";
                //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
                //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                GenJnLine.Amount := -ClaimReserve."Reserve Amount";
                GenJnLine.VALIDATE(GenJnLine.Amount);
                GenJnLine."External Document No." := ClaimReserve."Claim No.";
                GenJnLine."Claim No." := ClaimReserve."Claim No.";
                GenJnLine."Claimant ID" := ClaimReserve."Claimant ID";
                GenJnLine."Policy Type" := ClaimReserve."Insurance Class";
                GenJnLine."Shortcut Dimension 1 Code" := ClaimReserve."Shortcut Dimension 1 Code";
                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                GenJnLine."Shortcut Dimension 2 Code" := ClaimReserve."Shortcut Dimension 2 Code";
                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                GenJnLine."Shortcut Dimension 3 Code" := ClaimReserve."Shortcut Dimension 3 Code";
                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                GenJnLine."Shortcut Dimension 4 Code" := ClaimReserve."Shortcut Dimension 4 Code";
                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                IF GenJnLine.Amount <> 0 THEN
                    GenJnLine.INSERT;

                //Reinsurance portion
                ReinsureLines.RESET;
                ReinsureLines.SETRANGE(ReinsureLines."No.", ClaimReserve."No.");
                IF ReinsureLines.FINDFIRST THEN BEGIN
                    REPEAT

                        LineNo := LineNo + 10000;
                        GenJnLine.INIT;
                        GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                        GenJnLine."Line No." := LineNo;
                        GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                        GenJnLine."Account No." := IntegrationSetup."Reinsurer Share of Reserves-A";
                        GenJnLine.VALIDATE(GenJnLine."Account No.");
                        GenJnLine."Posting Date" := TODAY;
                        GenJnLine."Document No." := ClaimReserve."No.";
                        GenJnLine.Description := 'Claims for ' + FORMAT(ClaimReserve."Claim No.");
                        GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::"Reinsurance Claim Reserve";
                        //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
                        //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                        GenJnLine."Shortcut Dimension 1 Code" := ClaimReserve."Shortcut Dimension 1 Code";
                        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                        GenJnLine."Shortcut Dimension 2 Code" := ClaimReserve."Shortcut Dimension 2 Code";
                        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                        GenJnLine."Shortcut Dimension 3 Code" := ClaimReserve."Shortcut Dimension 3 Code";
                        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                        GenJnLine."Shortcut Dimension 4 Code" := ClaimReserve."Shortcut Dimension 4 Code";
                        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                        GenJnLine.Amount := ReinsureLines."Claim Reserve Amount";
                        GenJnLine.VALIDATE(GenJnLine.Amount);
                        GenJnLine."External Document No." := ClaimReserve."Claim No.";
                        GenJnLine."Claim No." := ClaimReserve."Claim No.";
                        GenJnLine."Claimant ID" := ClaimReserve."Claimant ID";
                        GenJnLine."Policy Type" := ClaimReserve."Insurance Class";

                        IF GenJnLine.Amount <> 0 THEN
                            GenJnLine.INSERT;

                        LineNo := LineNo + 10000;
                        GenJnLine.INIT;
                        GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                        GenJnLine."Line No." := LineNo;
                        GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                        GenJnLine."Account No." := IntegrationSetup."Reinsurer Share of Reserves-L";
                        GenJnLine.VALIDATE(GenJnLine."Account No.");
                        GenJnLine."Posting Date" := TODAY;
                        GenJnLine."Document No." := ClaimReserve."No.";
                        GenJnLine.Description := 'Claims for ' + FORMAT(ClaimReserve."Claim No.");
                        //GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Claim Reserve";
                        //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
                        //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                        GenJnLine."Shortcut Dimension 1 Code" := ClaimReserve."Shortcut Dimension 1 Code";
                        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                        GenJnLine."Shortcut Dimension 2 Code" := ClaimReserve."Shortcut Dimension 2 Code";
                        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                        GenJnLine."Shortcut Dimension 3 Code" := ClaimReserve."Shortcut Dimension 3 Code";
                        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                        GenJnLine."Shortcut Dimension 4 Code" := ClaimReserve."Shortcut Dimension 4 Code";
                        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                        GenJnLine.Amount := -ReinsureLines."Claim Reserve Amount";
                        GenJnLine.VALIDATE(GenJnLine.Amount);
                        GenJnLine."External Document No." := ClaimReserve."Claim No.";
                        GenJnLine."Claim No." := ClaimReserve."Claim No.";
                        GenJnLine."Claimant ID" := ClaimReserve."Claimant ID";
                        GenJnLine."Policy Type" := ClaimReserve."Insurance Class";
                        IF GenJnLine.Amount <> 0 THEN
                            GenJnLine.INSERT;
                        ReinsureLines.Posted := TRUE;
                        ReinsureLines.MODIFY;
                    UNTIL ReinsureLines.NEXT = 0;
                END;

                //Reinsurance portion Reversal
                IF ClaimReserve."Revised Reserve Link" <> '' THEN BEGIN
                    ReinsureLines.RESET;
                    ReinsureLines.SETRANGE(ReinsureLines."No.", ClaimReserve."Revised Reserve Link");
                    IF ReinsureLines.FINDFIRST THEN BEGIN
                        REPEAT
                            //MESSAGE('updates when there is a link');
                            LineNo := LineNo + 10000;
                            GenJnLine.INIT;
                            GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                            GenJnLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                            GenJnLine."Line No." := LineNo;
                            GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                            GenJnLine."Account No." := IntegrationSetup."Reinsurer Share of Reserves-A";
                            GenJnLine.VALIDATE(GenJnLine."Account No.");
                            GenJnLine."Posting Date" := TODAY;
                            GenJnLine."Document No." := ClaimReserve."No.";
                            GenJnLine.Description := 'Claims for ' + FORMAT(ClaimReserve."Claim No.");
                            GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::"Reinsurance Claim Reserve";
                            //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
                            //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                            GenJnLine."Shortcut Dimension 1 Code" := ClaimReserve."Shortcut Dimension 1 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                            GenJnLine."Shortcut Dimension 2 Code" := ClaimReserve."Shortcut Dimension 2 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                            GenJnLine."Shortcut Dimension 3 Code" := ClaimReserve."Shortcut Dimension 3 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                            GenJnLine."Shortcut Dimension 4 Code" := ClaimReserve."Shortcut Dimension 4 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                            GenJnLine."Treaty Code" := ReinsureLines."Treaty Code";
                            GenJnLine."Addendum Code" := ReinsureLines."Addendum Code";
                            GenJnLine."Layer Code" := ReinsureLines.TreatyLineID;
                            GenJnLine.Amount := -ReinsureLines."Claim Reserve Amount";
                            GenJnLine.VALIDATE(GenJnLine.Amount);
                            GenJnLine."External Document No." := ClaimReserve."Claim No.";
                            GenJnLine."Claim No." := ClaimReserve."Claim No.";
                            GenJnLine."Claimant ID" := ClaimReserve."Claimant ID";
                            GenJnLine."Policy Type" := ClaimReserve."Insurance Class";
                            IF GenJnLine.Amount <> 0 THEN
                                GenJnLine.INSERT;

                            LineNo := LineNo + 10000;
                            GenJnLine.INIT;
                            GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                            GenJnLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                            GenJnLine."Line No." := LineNo;
                            GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                            GenJnLine."Account No." := IntegrationSetup."Reinsurer Share of Reserves-L";
                            GenJnLine.VALIDATE(GenJnLine."Account No.");
                            GenJnLine."Posting Date" := TODAY;
                            GenJnLine."Document No." := ClaimReserve."No.";
                            GenJnLine.Description := 'Claims for ' + FORMAT(ClaimReserve."Claim No.");
                            //GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Claim Reserve";
                            //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
                            //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                            GenJnLine."Shortcut Dimension 1 Code" := ClaimReserve."Shortcut Dimension 1 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                            GenJnLine."Shortcut Dimension 2 Code" := ClaimReserve."Shortcut Dimension 2 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                            GenJnLine."Shortcut Dimension 3 Code" := ClaimReserve."Shortcut Dimension 3 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                            GenJnLine."Shortcut Dimension 4 Code" := ClaimReserve."Shortcut Dimension 4 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                            GenJnLine."Treaty Code" := ReinsureLines."Treaty Code";
                            GenJnLine."Addendum Code" := ReinsureLines."Addendum Code";
                            GenJnLine."Layer Code" := ReinsureLines.TreatyLineID;
                            GenJnLine.Amount := ReinsureLines."Claim Reserve Amount";
                            GenJnLine.VALIDATE(GenJnLine.Amount);
                            GenJnLine."External Document No." := ClaimReserve."Claim No.";
                            GenJnLine."Claim No." := ClaimReserve."Claim No.";
                            GenJnLine."Claimant ID" := ClaimReserve."Claimant ID";
                            GenJnLine."Policy Type" := ClaimReserve."Insurance Class";
                            IF GenJnLine.Amount <> 0 THEN
                                GenJnLine.INSERT;
                            ReinsureLines.Reversed := TRUE;
                            ReinsureLines.Posted := TRUE;
                            ReinsureLines.MODIFY;
                        UNTIL ReinsureLines.NEXT = 0;
                    END;
                END
                ELSE BEGIN
                    ReinsureLines.RESET;
                    ReinsureLines.SETRANGE(ReinsureLines."Claim No.", ClaimReserve."Claim No.");
                    ReinsureLines.SETRANGE(ReinsureLines."Claimant ID", ClaimReserve."Claimant ID");
                    ReinsureLines.SETRANGE(ReinsureLines.Posted, TRUE);
                    ReinsureLines.SETFILTER(ReinsureLines."No.", '<>%1', ClaimReserve."No.");
                    ReinsureLines.SETRANGE(ReinsureLines.Reversed, FALSE);

                    IF ReinsureLines.FINDFIRST THEN BEGIN
                        REPEAT
                            //MESSAGE('updates when there is no link');
                            LineNo := LineNo + 10000;
                            GenJnLine.INIT;
                            GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                            GenJnLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                            GenJnLine."Line No." := LineNo;
                            GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                            GenJnLine."Account No." := IntegrationSetup."Reinsurer Share of Reserves-A";
                            GenJnLine.VALIDATE(GenJnLine."Account No.");
                            GenJnLine."Posting Date" := TODAY;
                            GenJnLine."Document No." := ClaimReserve."No.";
                            GenJnLine.Description := 'Claims for ' + FORMAT(ClaimReserve."Claim No.");
                            GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::"Reinsurance Claim Reserve";
                            //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
                            //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                            GenJnLine."Shortcut Dimension 1 Code" := ClaimReserve."Shortcut Dimension 1 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                            GenJnLine."Shortcut Dimension 2 Code" := ClaimReserve."Shortcut Dimension 2 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                            GenJnLine."Shortcut Dimension 3 Code" := ClaimReserve."Shortcut Dimension 3 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                            GenJnLine."Shortcut Dimension 4 Code" := ClaimReserve."Shortcut Dimension 4 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                            GenJnLine."Treaty Code" := ReinsureLines."Treaty Code";
                            GenJnLine."Addendum Code" := ReinsureLines."Addendum Code";
                            GenJnLine."Layer Code" := ReinsureLines.TreatyLineID;

                            GenJnLine.Amount := -ReinsureLines."Claim Reserve Amount";
                            GenJnLine.VALIDATE(GenJnLine.Amount);
                            GenJnLine."External Document No." := ClaimReserve."Claim No.";
                            GenJnLine."Claim No." := ClaimReserve."Claim No.";
                            GenJnLine."Claimant ID" := ClaimReserve."Claimant ID";
                            GenJnLine."Policy Type" := ClaimReserve."Insurance Class";
                            IF GenJnLine.Amount <> 0 THEN
                                GenJnLine.INSERT;

                            LineNo := LineNo + 10000;
                            GenJnLine.INIT;
                            GenJnLine."Journal Template Name" := Isetup."Insurance Template";
                            GenJnLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                            GenJnLine."Line No." := LineNo;
                            GenJnLine."Account Type" := GenJnLine."Account Type"::"G/L Account";
                            GenJnLine."Account No." := IntegrationSetup."Reinsurer Share of Reserves-L";
                            GenJnLine.VALIDATE(GenJnLine."Account No.");
                            GenJnLine."Posting Date" := TODAY;
                            GenJnLine."Document No." := ClaimReserve."No.";
                            GenJnLine.Description := 'Claims for ' + FORMAT(ClaimReserve."Claim No.");
                            //GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Claim Reserve";
                            //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
                            //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                            GenJnLine."Shortcut Dimension 1 Code" := ClaimReserve."Shortcut Dimension 1 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                            GenJnLine."Shortcut Dimension 2 Code" := ClaimReserve."Shortcut Dimension 2 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                            GenJnLine."Shortcut Dimension 3 Code" := ClaimReserve."Shortcut Dimension 3 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                            GenJnLine."Shortcut Dimension 4 Code" := ClaimReserve."Shortcut Dimension 4 Code";
                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                            GenJnLine."Treaty Code" := ReinsureLines."Treaty Code";
                            GenJnLine."Addendum Code" := ReinsureLines."Addendum Code";
                            GenJnLine."Layer Code" := ReinsureLines.TreatyLineID;
                            GenJnLine.Amount := ReinsureLines."Claim Reserve Amount";
                            GenJnLine.VALIDATE(GenJnLine.Amount);
                            GenJnLine."External Document No." := ClaimReserve."Claim No.";
                            GenJnLine."Claim No." := ClaimReserve."Claim No.";
                            GenJnLine."Claimant ID" := ClaimReserve."Claimant ID";
                            GenJnLine."Policy Type" := ClaimReserve."Insurance Class";
                            IF GenJnLine.Amount <> 0 THEN
                                GenJnLine.INSERT;
                            ReinsureLines.Reversed := TRUE;
                            ReinsureLines.Posted := TRUE;
                            ReinsureLines.MODIFY;
                        UNTIL ReinsureLines.NEXT = 0;
                    END;
                END;
                //End

                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnLine);


                GLEntry.RESET;
                GLEntry.SETRANGE(GLEntry."Document No.", ClaimReserve."No.");
                GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
                IF GLEntry.FINDFIRST THEN BEGIN
                    ClaimReserve.Posted := TRUE;
                    ClaimReserve."Posted By" := USERID;
                    ClaimReserve.MODIFY(TRUE);

                END;


            END;
        END;

    end;

    procedure GenerateReserve(var ClaimRec: Record Claim);
    var
        ClaimReserveHeader: Record "Claim Reservation Header";
        ClaimReserveLines: Record "Claim Reservation Line";
        ClaimInvolvedParties: Record "Claim Involved Parties";
        Losstype: Record "Loss Type";
        UserSetupDetails: Record "User Setup Details";
        PolicyType: Record "Policy Type";
    begin

        ClaimReserveHeader.INIT;
        ClaimReserveHeader."No." := '';
        ClaimReserveHeader."Document Date" := WORKDATE;
        ClaimReserveHeader."Creation Date" := WORKDATE;
        ClaimReserveHeader."Creation Time" := TIME;
        ClaimReserveHeader."Claim No." := ClaimRec."Claim No";
        ClaimReserveHeader."Insurance Class" := ClaimRec.Class;
        IF PolicyType.GET(ClaimRec.Class) THEN
            ClaimReserveHeader."Shortcut Dimension 3 Code" := PolicyType.Class;
        IF UserSetupDetails.GET(USERID) THEN BEGIN
            ClaimReserveHeader."Shortcut Dimension 1 Code" := UserSetupDetails."Global Dimension 1 Code";
            ClaimReserveHeader."Shortcut Dimension 2 Code" := UserSetupDetails."Global Dimension 2 Code";
        END;
        ClaimReserveHeader.INSERT(TRUE);
        ClaimInvolvedParties.RESET;
        ClaimInvolvedParties.SETRANGE(ClaimInvolvedParties."Claim No.", ClaimRec."Claim No");
        ClaimInvolvedParties.SETRANGE(ClaimInvolvedParties."Minimum Reserve Posted", FALSE);
        IF ClaimInvolvedParties.FINDFIRST THEN
            REPEAT
                ClaimReserveLines.INIT;
                ClaimReserveLines."Claim Reservation No." := ClaimReserveHeader."No.";
                ClaimReserveLines."Claim No." := ClaimInvolvedParties."Claim No.";
                ClaimReserveLines."Line No." := ClaimInvolvedParties."Claim Line No.";
                IF Losstype.GET(ClaimInvolvedParties."Loss Type") THEN
                    ClaimReserveLines.Description := Losstype.Description + ' Minimum Reserves';
                ClaimReserveLines."Reserved Amount" := ClaimInvolvedParties."Minimum Reserve Amount";
                IF ClaimInvolvedParties."Minimum Reserve Amount" <> 0 THEN
                    ClaimReserveLines.INSERT;
                ClaimReserveHeader."Claimant ID" := ClaimInvolvedParties."Claim Line No.";
                ClaimInvolvedParties."Minimum Reserve Posted" := TRUE;
                ClaimReserveHeader.MODIFY;
                ClaimInvolvedParties.MODIFY;
            UNTIL ClaimInvolvedParties.NEXT = 0;

        PostClaimsReserve(ClaimReserveHeader);
    end;

    procedure TransferReport2Reserve(var ClaimReport: Record "Claim Report Header");
    var
        ClaimReserveHeader: Record "Claim Reservation Header";
        ClaimReserveLines: Record "Claim Reservation Line";
        ClaimReportLines: Record "Claim Report lines";
        Losstype: Record "Loss Type";
    begin

        ClaimReserveHeader.INIT;
        ClaimReserveHeader."No." := '';
        ClaimReserveHeader."Document Date" := WORKDATE;
        ClaimReserveHeader."Creation Date" := WORKDATE;
        ClaimReserveHeader."Creation Time" := TIME;
        ClaimReserveHeader."Claim No." := ClaimReport."Claim No.";
        ClaimReserveHeader.VALIDATE(ClaimReserveHeader."Claim No.");
        //ClaimReserveHeader."Insurance Class":=claimreport."Policy Type";
        ClaimReserveHeader.INSERT(TRUE);
        ClaimReportLines.RESET;
        ClaimReportLines.SETRANGE(ClaimReportLines."Claim Report No.", ClaimReport."No.");
        IF ClaimReportLines.FINDFIRST THEN
            REPEAT
                ClaimReserveLines.INIT;
                ClaimReserveLines."Claim Reservation No." := ClaimReserveHeader."No.";
                ClaimReserveLines."Claim No." := ClaimReportLines."Claim No.";
                ClaimReserveLines."Line No." := ClaimReportLines."Line No.";
                //IF Losstype.GET(ClaimInvolvedParties."Loss Type") THEN
                ClaimReserveLines.Description := ClaimReportLines.Description;
                ClaimReserveLines."Reserved Amount" := ClaimReportLines."Estimated Value";

                ClaimReserveLines.INSERT;

            UNTIL ClaimReportLines.NEXT = 0;

        //PostClaimsReserve(ClaimReserveHeader);
    end;

    procedure TransferReserve2Payment(var ClaimReserve: Record "Claim Reservation Header");
    var
        PV: Record Payments1;
        PVLines: Record 51511001;
        ClaimReserveLines: Record "Claim Reservation lines";
        Losstype: Record "Loss Type";
        ReceiptPaymentTypes: Record 51511002;
    begin
        ClaimReserve.CALCFIELDS(ClaimReserve."Reserve Amount");
        ReceiptPaymentTypes.RESET;
        ReceiptPaymentTypes.SETRANGE(ReceiptPaymentTypes."Insurance Trans Type", ReceiptPaymentTypes."Insurance Trans Type"::"Claim Payment");
        IF ReceiptPaymentTypes.FINDFIRST THEN BEGIN


            PV.INIT;
            PV.No := '';
            PV.Date := WORKDATE;
            PV.Type := ReceiptPaymentTypes.Code;

            //ClaimReserveHeader."Insurance Class":=claimreport."Policy Type";
            PV.INSERT(TRUE);

            PVLines.INIT;
            PVLines."PV No" := PV.No;
            PVLines."Line No" := PVLines."Line No" + 10000;
            PVLines.Amount := ClaimReserve."Reserve Amount";
            PVLines.Description := 'Claim payment';
            PVLines."Claim No" := ClaimReserve."Claim No.";

            PVLines.INSERT(TRUE);


        END
        ELSE
            ERROR('Please setup a claim payment option on Receipts and payments setup');
        //PostClaimsReserve(ClaimReserveHeader);
    end;

    procedure DrawMDPPayScheduleTreaty(var Treaty: Record Treaty);
    var
        PaymentSchedule: Record "MDP Schedule";
        TotalPremium: Decimal;
        PolicyLines: Record "Insure Lines";
        StartDate: Date;
        i: Integer;
        PaymentTerms: Record "No. of Instalments";
        XOLLayers: Record "XOL Layers";
    begin
        PaymentSchedule.RESET;
        PaymentSchedule.SETRANGE(PaymentSchedule."Treaty Code", Treaty."Treaty Code");
        PaymentSchedule.SETRANGE(PaymentSchedule."Treaty Addendum", Treaty."Addendum Code");
        PaymentSchedule.DELETEALL;

        IF PaymentTerms.GET(Treaty."MDP No. Of Instalments") THEN BEGIN
            IF Treaty."MDP No. Of Instalments" > 1 THEN BEGIN


                XOLLayers.RESET;
                XOLLayers.SETRANGE(XOLLayers."Treaty Code", Treaty."Treaty Code");
                XOLLayers.SETRANGE(XOLLayers."Addendum Code", Treaty."Addendum Code");
                IF XOLLayers.FINDFIRST THEN BEGIN

                    REPEAT
                        StartDate := Treaty."Effective date";

                        FOR i := 1 TO Treaty."MDP No. Of Instalments" DO BEGIN
                            PaymentSchedule.INIT;
                            PaymentSchedule."Treaty Code" := Treaty."Treaty Code";
                            PaymentSchedule."Treaty Addendum" := Treaty."Addendum Code";
                            PaymentSchedule."Payment No." := i;
                            PaymentSchedule."XOL Layer" := XOLLayers.Layer;

                            PaymentSchedule."Premium Amount" := XOLLayers."Minimum Deposit Premium" / Treaty."MDP No. Of Instalments";

                            //PaymentSchedule."Amount Due":=Treaty."Minimum Premium Deposit(MDP)";

                            IF i = 1 THEN
                                PaymentSchedule."Instalment Due Date" := StartDate
                            ELSE BEGIN
                                StartDate := CALCDATE(PaymentTerms."Period Length", StartDate);
                                PaymentSchedule."Instalment Due Date" := StartDate;

                            END;
                            //MESSAGE('date=%1 and premium=%2',PaymentSchedule."Due Date",PaymentSchedule."Amount Due");

                            IF PaymentSchedule.GET(PaymentSchedule."Treaty Code", PaymentSchedule."Treaty Addendum", PaymentSchedule."XOL Layer", PaymentSchedule."Payment No.") THEN
                                PaymentSchedule.MODIFY
                            ELSE
                                PaymentSchedule.INSERT;
                        END;
                    UNTIL XOLLayers.NEXT = 0;
                END;
            END;
        END;
        //END;

    end;

    procedure ExtendPolicyCover(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        PaySchedule: Record "Instalment Payment Plan";
    begin

        IF NOT SelectAllRisksTest(InsureHeader) THEN
            ERROR('Please select the Risks to extend cover for on Policy %1', InsureHeader."No.");

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
        EndorsementType.RESET;
        EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Extension);
        IF EndorsementType.FINDLAST THEN BEGIN
            InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
            InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
        END;
        IF (InsureHeader."Action Type" = InsureHeader."Action Type"::New) OR (InsureHeader."Action Type" = InsureHeader."Action Type"::Renewal) THEN
            InsureHeaderCopy."Policy No" := InsureHeader."No.";
        //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
        InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
        InsureHeaderCopy."Cover Start Date" := GetEndorsementStartDate(InsureHeaderCopy);
        PaySchedule.RESET;
        PaySchedule.SETRANGE(PaySchedule."Document Type", InsureHeader."Document Type");
        PaySchedule.SETRANGE(PaySchedule."Document No.", InsureHeader."No.");
        PaySchedule.SETRANGE(PaySchedule."Due Date", InsureHeaderCopy."Cover Start Date");
        IF PaySchedule.FINDLAST THEN
            InsureHeaderCopy."Instalment No." := PaySchedule."Payment No";

        //InsureHeaderCopy.VALIDATE("Cover Start Date");
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines.Selected, TRUE);
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        PAGE.RUN(51513183, InsureHeaderCopy);
    end;

    procedure CancelPolicyCover(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
    begin

        IF NOT SelectAllRisksTest(InsureHeader) THEN
            ERROR('Please select the Risks to Cancel on Policy %1', InsureHeader."No.");

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
        EndorsementType.RESET;
        EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Cancellation);
        IF EndorsementType.FINDLAST THEN BEGIN
            InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
            InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
        END;
        InsureHeaderCopy."Policy No" := InsureHeader."No.";
        InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
        //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines.Selected, TRUE);
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        PAGE.RUN(51513183, InsureHeaderCopy);
    end;

    procedure SuspendPolicyCover(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
    begin

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
        EndorsementType.RESET;
        EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Suspension);
        IF EndorsementType.FINDLAST THEN BEGIN
            InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
            InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
        END;
        InsureHeaderCopy."Policy No" := InsureHeader."No.";
        InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
        //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
        InsureHeaderCopy."No. Of Days" := (InsureHeader."Cover End Date" - TODAY) + 1;
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines.Selected, TRUE);
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        PAGE.RUN(51513183, InsureHeaderCopy);
    end;

    procedure ResumePolicyCover(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        CreditNote: Record "Insure Credit Note";
        CreditnoteLines: Record "Insure Credit Note Lines";
    begin
        IF InsureHeader."Action Type" <> InsureHeader."Action Type"::Suspension THEN
            ERROR('Please select a suspended policy/endorsement');
        IF SelectAllRisksTest(InsureHeader) THEN
            InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
        EndorsementType.RESET;
        EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Resumption);
        IF EndorsementType.FINDLAST THEN BEGIN
            InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
            InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
        END;
        // commented InsureHeaderCopy."Policy No":="Policy No"."No.";
        //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
        InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines.Selected, TRUE);
        //InsureLines.SETRANGE(InsureLines.Status,InsureLines.Status::Suspended);
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;
                CreditnoteLines.RESET;
                CreditnoteLines.SETRANGE(CreditnoteLines."Description Type", CreditnoteLines."Description Type"::"Schedule of Insured");
                CreditnoteLines.SETRANGE(CreditnoteLines."Registration No.", InsureLines."Registration No.");
                IF CreditnoteLines.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Applies-to Doc. Type" := InsureHeaderCopy."Applies-to Doc. Type"::"Credit Memo";
                    InsureHeaderCopy."Applies-to Doc. No." := CreditnoteLines."Document No.";
                    InsureHeaderCopy.MODIFY;
                END;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        PAGE.RUN(51513183, InsureHeaderCopy);
    end;

    procedure SubstitutePolicyCover(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
    begin

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
        EndorsementType.RESET;
        EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Substitution);
        IF EndorsementType.FINDLAST THEN BEGIN
            InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
            InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
        END;
        IF InsureHeaderCopy."Policy No" = '' THEN
            InsureHeaderCopy."Policy No" := InsureHeader."No.";
        InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
        //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
        InsureHeaderCopy."Cover Start Date" := TODAY;
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        /*InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type",InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.",InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines.Selected,TRUE);
        IF InsureLines.FINDFIRST THEN
        REPEAT
           InsureLinesCopy.INIT;
           InsureLinesCopy.COPY(InsureLines);
           InsureLinesCopy."Document Type":=InsureHeaderCopy."Document Type";
           InsureLinesCopy."Document No.":=InsureHeaderCopy."No.";
           InsureLinesCopy."Policy No":=InsureHeader."No.";
           InsureLinesCopy."Select Risk ID":=InsureLines."Line No.";
           InsureLinesCopy.INSERT;
        UNTIL InsureLines.NEXT=0;*/

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        PAGE.RUN(51513183, InsureHeaderCopy);

    end;

    procedure RevisePolicyCover(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
    begin

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
        EndorsementType.RESET;
        EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Revision);
        IF EndorsementType.FINDLAST THEN BEGIN
            InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
            InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
        END;
        InsureHeaderCopy."Policy No" := InsureHeader."No.";
        InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
        //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines.Selected, TRUE);
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        PAGE.RUN(51513183, InsureHeaderCopy);
    end;

    procedure NilPolicyCover(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
    begin
        IF SelectAllRisksTest(InsureHeader) THEN
            InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
        EndorsementType.RESET;
        EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Nil);
        IF EndorsementType.FINDLAST THEN BEGIN
            InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
            InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
        END;
        InsureHeaderCopy."Policy No" := InsureHeader."No.";
        //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
        InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines.Selected, TRUE);
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        PAGE.RUN(51513183, InsureHeaderCopy);
    end;

    local procedure AddPolicyCover();
    begin
    end;

    procedure UpdateTPOPremiumTable(var PremTable: Record "Premium Table");
    var
        PremiumTabLines: Record "Premium table Lines";
        TPO: Record TPO;
        NoOfInstalments: Record "No. of Instalments";
        SeatingCapacity: Record "Vehicle Capacity";
    begin
        TPO.RESET;
        IF TPO.FINDFIRST THEN
            REPEAT

                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 1;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."1";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;

                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 2;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."2";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;


                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 3;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."Payment Terms";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;

                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 4;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO.Currency;
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;

                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 5;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."5";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;


                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 6;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."6";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;

                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 7;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."7";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;

                //8
                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 8;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."8";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;
                //9
                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 9;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."Country/Region";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;
                //10
                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 10;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."10";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;
                //11
                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 11;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."11";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;

                //12
                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 12;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."Gen. Jnl.-Post Line";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;
                //26
                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 26;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."26";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;
                //52
                PremiumTabLines.INIT;
                PremiumTabLines."Premium Table" := PremTable.Code;
                IF NOT SeatingCapacity.GET(TPO."Seating Capacity") THEN BEGIN
                    SeatingCapacity.INIT;
                    SeatingCapacity."Seating Capacity" := TPO."Seating Capacity";
                    SeatingCapacity.INSERT;
                END;
                PremiumTabLines."Seating Capacity" := TPO."Seating Capacity";
                PremiumTabLines.Instalments := 52;
                PremiumTabLines."Policy Type" := '';
                PremiumTabLines."Premium Amount" := TPO."52";
                PremiumTabLines."Effective Date" := PremTable."Effective Date";
                PremiumTabLines."Vehicle Type" := PremTable."Vehicle Class";
                PremiumTabLines."Vehicle Usage" := PremTable."Vehicle Usage";
                IF PremiumTabLines.GET(PremiumTabLines."Premium Table", PremiumTabLines."Seating Capacity", PremiumTabLines.Instalments, PremiumTabLines."Policy Type") THEN
                    PremiumTabLines.MODIFY
                ELSE
                    PremiumTabLines.INSERT;
            UNTIL TPO.NEXT = 0;
    end;

    procedure ConvertDebitNote2CreditNote(var InsureHeader: Record "Insure Debit Note");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Debit Note Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
    begin
        InsureHeaderCopy.TRANSFERFIELDS(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::"Credit Note";
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.TRANSFERFIELDS(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy.INSERT;
            //InsureLinesCopy.RENAME(InsureHeaderCopy."Document Type",InsureHeaderCopy."No.",InsureLinesCopy."Risk ID",InsureLinesCopy."Line No.");

            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT

                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT

                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", InsureHeaderLoading_DiscountCopy.Code);


            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT

                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy.RENAME(InsureHeader."Document Type", InsureHeader."No.", InstalmentLinesCopy."Payment No");
            UNTIL InstalmentLines.NEXT = 0;
    end;

    procedure SelectAllRisks(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
    begin
        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines."Description Type", InsureLines."Description Type"::"Schedule of Insured");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLines.Selected := TRUE;
                InsureLines.MODIFY;

            UNTIL InsureLines.NEXT = 0;
    end;

    procedure UnSelectAllRisks(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
    begin
        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines.Selected, TRUE);
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLines.Selected := FALSE;
                InsureLines.MODIFY;

            UNTIL InsureLines.NEXT = 0;
    end;

    procedure SelectAllRisksTest(var InsureHeader: Record "Insure Header") SelectedRec: Boolean;
    var
        InsureLines: Record "Insure Lines";
    begin
        SelectedRec := FALSE;
        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines."Description Type", InsureLines."Description Type"::"Schedule of Insured");
        InsureLines.SETRANGE(InsureLines.Selected, TRUE);
        IF InsureLines.FINDFIRST THEN
            SelectedRec := TRUE
        ELSE
            SelectedRec := FALSE;
    end;

    procedure PostEndorsement(var InsureHeader: Record "Insure Header");
    var
        EndorsementType: Record "Endorsement Types";
        CountriesVisited: Record "Countries Visited";
    begin
        InsureHeader.VALIDATE(InsureHeader."Policy Type");
        InsureHeader.VALIDATE(InsureHeader."Document Date");
        InsertTaxesReinsurance(InsureHeader);
        IF InsureHeader."Action Type" = InsureHeader."Action Type"::Extension THEN BEGIN
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Policy Risk Actions" = EndorsementType."Policy Risk Actions"::"Create New" THEN
                    ConvertQuote2Policy(InsureHeader);

                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Debit Note" THEN
                    ConvertEndorsement2DebitNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Credit Note" THEN
                    ConvertEndorsement2CreditNote(InsureHeader);

            END;
        END;
        IF InsureHeader."Action Type" = InsureHeader."Action Type"::"Yellow Card" THEN BEGIN
            CountriesVisited.RESET;
            CountriesVisited.SETRANGE(CountriesVisited."Document Type", InsureHeader."Document Type");
            CountriesVisited.SETRANGE(CountriesVisited."Document No.", InsureHeader."No.");
            IF NOT CountriesVisited.FINDFIRST THEN
                ERROR('You must select at least one country where the insured will visit when applying for yellow card');



            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Policy Risk Actions" = EndorsementType."Policy Risk Actions"::"Create New" THEN
                    ConvertQuote2Policy(InsureHeader);

                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Debit Note" THEN
                    ConvertEndorsement2DebitNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Credit Note" THEN
                    ConvertEndorsement2CreditNote(InsureHeader);

            END;
        END;

        IF InsureHeader."Action Type" = InsureHeader."Action Type"::"Additional Riders" THEN BEGIN
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Policy Risk Actions" = EndorsementType."Policy Risk Actions"::"Create New" THEN
                    ConvertQuote2Policy(InsureHeader);

                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Debit Note" THEN
                    ConvertEndorsement2DebitNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Credit Note" THEN
                    ConvertEndorsement2CreditNote(InsureHeader);

            END;
        END;
        IF InsureHeader."Action Type" = InsureHeader."Action Type"::Cancellation THEN BEGIN
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Policy Risk Actions" = EndorsementType."Policy Risk Actions"::"Create New" THEN
                    ConvertQuote2Policy(InsureHeader);

                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Debit Note" THEN
                    ConvertEndorsement2DebitNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Credit Note" THEN
                    ConvertEndorsement2CreditNote(InsureHeader);

                //EffectCancellation(InsureHeader);
            END;
        END;

        IF InsureHeader."Action Type" = InsureHeader."Action Type"::Suspension THEN BEGIN
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Policy Risk Actions" = EndorsementType."Policy Risk Actions"::"Create New" THEN
                    ConvertQuote2Policy(InsureHeader);

                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Debit Note" THEN
                    ConvertEndorsement2DebitNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Credit Note" THEN
                    ConvertEndorsement2CreditNote(InsureHeader);

                // EffectSuspension(InsureHeader);
            END;
        END;

        IF InsureHeader."Action Type" = InsureHeader."Action Type"::Resumption THEN BEGIN
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Policy Risk Actions" = EndorsementType."Policy Risk Actions"::"Create New" THEN
                    ConvertQuote2Policy(InsureHeader);

                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Debit Note" THEN
                    ConvertEndorsement2DebitNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Credit Note" THEN
                    ConvertEndorsement2CreditNote(InsureHeader);

                //EffectSuspension(InsureHeader);
            END;
        END;

        IF InsureHeader."Action Type" = InsureHeader."Action Type"::Substitution THEN BEGIN
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Policy Risk Actions" = EndorsementType."Policy Risk Actions"::"Create New" THEN
                    ConvertQuote2Policy(InsureHeader);

                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Debit Note" THEN
                    ConvertEndorsement2DebitNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Credit Note" THEN
                    ConvertEndorsement2CreditNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::Both THEN BEGIN
                    ConvertEndorsement2CreditNoteSub(InsureHeader);
                    EffectCancellation(InsureHeader);
                    ConvertEndorsement2DebitNoteSub(InsureHeader);
                END;
                //EffectSuspension(InsureHeader);
            END;
        END;

        IF InsureHeader."Action Type" = InsureHeader."Action Type"::Renewal THEN BEGIN
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Policy Risk Actions" = EndorsementType."Policy Risk Actions"::"Create New" THEN
                    ConvertQuote2Policy(InsureHeader);

                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Debit Note" THEN
                    ConvertEndorsement2DebitNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Credit Note" THEN
                    ConvertEndorsement2CreditNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::Both THEN BEGIN
                    ConvertEndorsement2CreditNote(InsureHeader);
                    ConvertEndorsement2DebitNote(InsureHeader);

                END;
                //EffectRenewal(InsureHeader);
            END;
        END;
        IF InsureHeader."Action Type" = InsureHeader."Action Type"::Revision THEN BEGIN
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Policy Risk Actions" = EndorsementType."Policy Risk Actions"::"Create New" THEN
                    ConvertQuote2Policy(InsureHeader);

                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Debit Note" THEN
                    ConvertEndorsement2DebitNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Credit Note" THEN
                    ConvertEndorsement2CreditNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::Both THEN BEGIN
                    ConvertEndorsement2CreditNote(InsureHeader);
                    ConvertEndorsement2DebitNote(InsureHeader);

                END;
                //EffectSuspension(InsureHeader);
            END;
        END;
        IF InsureHeader."Action Type" = InsureHeader."Action Type"::Nil THEN BEGIN
            // MESSAGE('Comes here');
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Policy Risk Actions" = EndorsementType."Policy Risk Actions"::"Create New" THEN
                    ConvertQuote2Policy(InsureHeader);

                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Debit Note" THEN
                    ConvertEndorsement2DebitNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::"Credit Note" THEN
                    ConvertEndorsement2CreditNote(InsureHeader);
                IF EndorsementType."Accounting Actions" = EndorsementType."Accounting Actions"::Both THEN BEGIN
                    ConvertEndorsement2CreditNote(InsureHeader);
                    ConvertEndorsement2DebitNote(InsureHeader);

                END;

                //EffectSuspension(InsureHeader);
            END;

        END;

    end;

    procedure ConvertEndorsement2DebitNote(var InsureHeader: Record "Insure Header");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        PostedCreditNote: Record "Insure Credit Note";
        CustLedger: Record "Cust. Ledger Entry";
        PolicyHeader: Record "Insure Header";
    begin

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::"Debit Note";
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy2.RESET;
        /*InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Document Type",InsureHeaderCopy2."Document Type"::Policy);
        InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Quotation No.",InsureHeader."No.");
        IF InsureHeaderCopy2.FINDFIRST THEN*/
        InsureHeaderCopy."Copied from No." := InsureHeader."No.";

        PolicyHeader.RESET;
        PolicyHeader.SETRANGE(PolicyHeader."Document Type", PolicyHeader."Document Type"::Policy);
        PolicyHeader.SETRANGE(PolicyHeader."Quotation No.", InsureHeader."No.");
        IF PolicyHeader.FINDFIRST THEN BEGIN
            InsureHeaderCopy."Endorsement Policy No." := PolicyHeader."No.";

        END;



        MESSAGE('Endorsement Policy no=%1', InsureHeaderCopy."Endorsement Policy No.");
        //Look for credit note to apply to
        PostedCreditNote.RESET;
        PostedCreditNote.SETRANGE(PostedCreditNote."Insured No.", InsureHeaderCopy."Insured No.");
        PostedCreditNote.SETRANGE(PostedCreditNote."Policy No", InsureHeaderCopy."Policy No");
        IF CreditMemo.FINDFIRST THEN
            REPEAT
                CustLedger.RESET;
                CustLedger.SETCURRENTKEY(CustLedger."Document No.");
                CustLedger.SETRANGE(CustLedger."Document No.", PostedCreditNote."No.");
                IF CustLedger.FINDFIRST THEN
                    CustLedger.CALCFIELDS(CustLedger."Remaining Amount");
                IF CustLedger."Remaining Amount" <> 0 THEN
                    InsureHeaderCopy."Applies-to Doc. No." := CustLedger."Document No.";
            //MESSAGE('Credit Note=%1',CustLedger."Document No.");




            UNTIL CreditMemo.NEXT = 0;


        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;

                InsureLinesCopy.TRANSFERFIELDS(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT

                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.TRANSFERFIELDS(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;

            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.TRANSFERFIELDS(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;

            UNTIL InsureHeaderLoading_Discount.NEXT = 0;


        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.TRANSFERFIELDS(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;

                InstalmentLinesCopy.TRANSFERFIELDS(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        //Post Debit Note
        PostInsureHeader(InsureHeaderCopy);

    end;

    procedure ConvertEndorsement2CreditNote(var InsureHeader: Record "Insure Header");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        LoadingDiscSetup: Record "Loading and Discounts Setup";
    begin

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::"Credit Note";
        InsureHeaderCopy."No." := '';
        /*InsureHeaderCopy2.RESET;
        InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Document Type",InsureHeaderCopy2."Document Type"::Policy);
        InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Quotation No.",InsureHeader."No.");
        IF InsureHeaderCopy2.FINDFIRST THEN
        InsureHeaderCopy."Policy No":=InsureHeaderCopy2."No.";*/

        InsureHeaderCopy."Copied from No." := InsureHeader."No.";
        //MESSAGE('Policy no=%1',InsureHeaderCopy."Policy No");
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;

                InsureLinesCopy.TRANSFERFIELDS(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT

                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.TRANSFERFIELDS(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;

            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");

        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.TRANSFERFIELDS(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                IF LoadingDiscSetup.GET(InsureHeaderLoading_DiscountCopy.Code) THEN
                    IF LoadingDiscSetup."Applicable to" <> LoadingDiscSetup."Applicable to"::"Certificate Charge" THEN
                        InsureHeaderLoading_DiscountCopy.INSERT;

            UNTIL InsureHeaderLoading_Discount.NEXT = 0;


        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.TRANSFERFIELDS(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;

                InstalmentLinesCopy.TRANSFERFIELDS(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        //Post Debit Note
        PostInsureHeader(InsureHeaderCopy);

    end;

    procedure UpdateCoverDates(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
    begin
        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines."Description Type", InsureLines."Description Type"::"Schedule of Insured");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLines."Start Date" := InsureHeader."Cover Start Date";
                InsureLines."End Date" := InsureHeader."Cover End Date";
                InsureLines.MODIFY;

            UNTIL InsureLines.NEXT = 0;
    end;

    procedure GetNoOfDays(var Startdate: Date; var EndDate: Date) NoOfDays: Integer;
    var
        NextmonthStart: Date;
    begin
        NoOfDays := 0;
        NextmonthStart := Startdate;
        REPEAT
            NextmonthStart := CALCDATE('1D', NextmonthStart);
            NoOfDays := NoOfDays + 1;

        UNTIL NextmonthStart >= EndDate;
    end;

    procedure GetEndorsementStartDate(var InsureHeader: Record "Insure Header") StartDate: Date;
    var
        InsureDebitNote: Record "Insure Header";
        NoOfInstalmentsRec: Record "No. of Instalments";
        InstalmentRatioRec: Record "Instalment Ratio";
        PaymentSchedule: Record "Instalment Payment Plan";
    begin
        StartDate := 0D;
        /*MESSAGE('No. =%1 and Policy No. =%2 action type=%3',InsureHeader."No.",InsureHeader."Policy No",InsureHeader."Action Type");
        InsureDebitNote.RESET;
        InsureDebitNote.SETCURRENTKEY(InsureDebitNote."Cover Start Date");
        InsureDebitNote.SETRANGE(InsureDebitNote."Document Type",InsureDebitNote."Document Type"::Policy);
        InsureDebitNote.SETRANGE(InsureDebitNote."Policy No",InsureHeader."No.");
        IF InsureDebitNote.FINDLAST THEN
        
          BEGIN
            MESSAGE('Cover start date ***=%1 %2',InsureDebitNote."Cover Start Date",InsureDebitNote."Insured Name");
        
          InstalmentRatioRec.RESET;
          InstalmentRatioRec.SETRANGE(InstalmentRatioRec."Policy Type",InsureDebitNote."Policy Type");
          InstalmentRatioRec.SETRANGE(InstalmentRatioRec."No. Of Instalments",InsureDebitNote."No. Of Instalments");
          InstalmentRatioRec.SETRANGE(InstalmentRatioRec."Instalment No",InsureDebitNote."Instalment No."+1);
          IF InstalmentRatioRec.FINDLAST THEN
            BEGIN
              MESSAGE('Instalment No=%1',InstalmentRatioRec."Instalment No");
              StartDate:=CALCDATE(InstalmentRatioRec."Period Length",InsureDebitNote."Cover Start Date");
               MESSAGE('Cover start date for Extension=%1',StartDate);
            END
            ELSE
            BEGIN
          IF NoOfInstalmentsRec.GET(InsureHeader."No. Of Instalments") THEN
          StartDate:=CALCDATE(NoOfInstalmentsRec."Period Length",InsureDebitNote."Cover Start Date");
          END;*/

        PaymentSchedule.RESET;
        PaymentSchedule.SETRANGE(PaymentSchedule."Document Type", InsureHeader."Document Type");
        PaymentSchedule.SETRANGE(PaymentSchedule."Document No.", InsureHeader."No.");
        PaymentSchedule.SETRANGE(PaymentSchedule."Payment No", InsureHeader."Instalment No." +
        InsureHeader."No. Of Cover Periods");
        IF PaymentSchedule.FINDFIRST THEN
            StartDate := PaymentSchedule."Cover Start Date";




        IF StartDate > InsureHeader."To Date" THEN
            ERROR('Policy %1 cannot be endorsed beyond the policy period', InsureHeader."Policy No");

        // END;

    end;

    procedure GetSerialNo4Print(var CertPrint: Record "Certificate Printing") SerialNo: Code[30];
    var
        ILE: Record "Item Ledger Entry";
        ItemRelation: Record "Item Entry Relation";
    begin
        ILE.RESET;
        ILE.SETRANGE(ILE."Item No.", CertPrint."Certificate Type");
        ILE.SETRANGE(ILE.Positive, TRUE);
        ILE.SETRANGE(ILE.Open, TRUE);
        IF ILE.FINDFIRST THEN BEGIN
            IF ItemRelation.GET(ILE."Entry No.") THEN
                EXIT(ItemRelation."Serial No.");
        END;
    end;

    procedure CertPrintandReduceStocks(var CertPrint: Record "Certificate Printing") SerialNo: Code[30];
    var
        ILE: Record "Item Ledger Entry";
        ItemRelation: Record "Item Entry Relation";
        ItemJournaline: Record "Item Journal Line";
        ReserveEntry: Record "Reservation Entry";
        CertNo: Code[20];
        PolicyLines: Record "Insure Lines";
        CertPrintCopy: Record "Certificate Printing";
        CertPrintCopyMod: Record "Certificate Printing";
    begin
        //CertPrintCopyMod.COPY(CertPrint);
        ItemJournaline.RESET;
        ItemJournaline.SETRANGE(ItemJournaline."Journal Template Name", 'ITEM');
        ItemJournaline.SETRANGE(ItemJournaline."Journal Batch Name", 'CERT');
        ItemJournaline.DELETEALL;

        ItemJournaline.INIT;
        ItemJournaline."Journal Template Name" := 'ITEM';
        ItemJournaline."Journal Batch Name" := 'CERT';
        ItemJournaline."Line No." := ItemJournaline."Line No." + 10000;
        ItemJournaline."Item No." := CertPrint."Certificate Type";
        ItemJournaline.VALIDATE(ItemJournaline."Item No.");
        ItemJournaline.Description := STRSUBSTNO('Reg. No: %1 Period: %2..%3', CertPrint."Registration No.", CertPrint."Start Date", CertPrint."End Date");
        ItemJournaline."Document No." := CertPrint."Document No.";
        ItemJournaline."Posting Date" := WORKDATE;
        ItemJournaline."Entry Type" := ItemJournaline."Entry Type"::"Negative Adjmt.";
        ItemJournaline.Quantity := 1;
        ItemJournaline.VALIDATE(ItemJournaline.Quantity);
        ItemJournaline."Registration No." := CertPrint."Registration No.";
        //ItemJournaline."Location Code":=
        ItemJournaline.INSERT;

        ReserveEntry.DELETEALL;

        ReserveEntry.INIT;
        ReserveEntry."Entry No." := GetILEEntryNo(CertPrint) + 1;
        ReserveEntry."Item No." := CertPrint."Shortcut Dimension 1 Code";
        //ReserveEntry."Location Code":=
        ReserveEntry."Quantity (Base)" := -1;
        ReserveEntry."Reservation Status" := ReserveEntry."Reservation Status"::Prospect;
        ReserveEntry.Description := ItemJournaline.Description;
        ReserveEntry."Creation Date" := TODAY;
        ReserveEntry."Source Type" := 83;
        ReserveEntry."Source Subtype" := 3;
        ReserveEntry."Source ID" := 'ITEM';
        ReserveEntry."Source Batch Name" := 'CERT';
        ReserveEntry."Source Ref. No." := ItemJournaline."Line No.";
        ReserveEntry."Shipment Date" := TODAY;
        ReserveEntry."Serial No." := GetSerialNo4Print(CertPrint);
        CertNo := GetSerialNo4Print(CertPrint);
        //MESSAGE('%1',CertNo);
        ReserveEntry."Created By" := USERID;
        ReserveEntry."Qty. per Unit of Measure" := 1;
        ReserveEntry.Quantity := -1;
        ReserveEntry."Planning Flexibility" := ReserveEntry."Planning Flexibility"::Unlimited;
        ReserveEntry."Qty. to Handle (Base)" := -1;
        ReserveEntry."Qty. to Invoice (Base)" := -1;
        ReserveEntry."Item Tracking" := ReserveEntry."Item Tracking"::"Serial No.";
        ReserveEntry.INSERT;

        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournaline);
        ILE.RESET;
        ILE.SETRANGE(ILE."Document No.", CertPrint."Document No.");
        //ILE.SETRANGE(ILE."Registration No.", CertPrint."Registration No.");
        IF ILE.FINDFIRST THEN BEGIN




            IF CertPrintCopyMod.GET(CertPrint."Document No.", CertPrint."Line No.") THEN BEGIN
                CertPrintCopyMod.Printed := TRUE;


                CertPrintCopyMod."Certificate No." := CertNo;
                //MESSAGE('Item Relation Serial No=%1 and assigned=%2',CertNo,CertPrint."Certificate No.");
                CertPrintCopyMod."Certificate Type" := ILE."Item No.";
                CertPrintCopyMod."Date Printed" := TODAY;
                CertPrintCopyMod."Print Time" := TIME;
                CertPrintCopyMod."Printed By" := USERID;
                CertPrintCopyMod.MODIFY;
            END;

            PolicyLines.RESET;
            PolicyLines.SETCURRENTKEY(PolicyLines."Start Date");
            PolicyLines.SETRANGE(PolicyLines."Document Type", PolicyLines."Document Type"::Policy);
            PolicyLines.SETRANGE(PolicyLines."Registration No.", CertPrint."Registration No.");
            //PolicyLines.SETRANGE(PolicyLines.Status,PolicyLines.Status::Live);
            IF PolicyLines.FINDLAST THEN BEGIN

                PolicyLines."Certificate No." := CertNo;
                PolicyLines.MODIFY;
                CertPrintCopy.RESET;
                CertPrintCopy.SETRANGE(CertPrintCopy."Document No.", CertPrint."Document No.");
                CertPrintCopy.SETRANGE(CertPrintCopy."Line No.", CertPrint."Line No.");
                IF CertPrintCopy.FINDFIRST THEN
                    REPORT.RUNMODAL(51513107, FALSE, FALSE, CertPrintCopy);
                CertPrintCopy.RESET;

            END;



            ItemJournaline.RESET;
            ItemJournaline.SETRANGE(ItemJournaline."Journal Template Name", 'ITEM');
            ItemJournaline.SETRANGE(ItemJournaline."Journal Batch Name", 'CERT');
            ItemJournaline.DELETEALL;
        END;
        /*PolicyLines.RESET;
        PolicyLines.SETRANGE(PolicyLines."Document Type",PolicyLines."Document Type"::Policy);
        PolicyLines.SETRANGE(PolicyLines."Registration No.",CertPrint."Registration No.");
        //PolicyLines.SETRANGE(PolicyLines.Status,PolicyLines.Status::Live);
        IF PolicyLines.FINDLAST THEN
          BEGIN
             //MESSAGE('found the vehicle');
          PolicyLines."Certificate No.":=CertNo;
          PolicyLines.MODIFY;
          CertPrintCopy.RESET;
          CertPrintCopy.SETRANGE(CertPrintCopy."Document No.",CertPrint."Document No.");
          CertPrintCopy.SETRANGE(CertPrintCopy."Line No.",CertPrint."Line No.");
          IF CertPrintCopy.FINDFIRST THEN
          REPORT.RUNMODAL(51513107,TRUE,FALSE,CertPrintCopy);
          CertPrintCopy.RESET;

          END;*/

    end;

    procedure GetILEEntryNo(var CertPrint: Record "Certificate Printing") EntryNo: Integer;
    var
        ILE: Record "Item Ledger Entry";
        ItemRelation: Record "Item Entry Relation";
    begin
        ILE.RESET;
        ILE.SETRANGE(ILE."Item No.", CertPrint."Certificate Type");
        ILE.SETRANGE(ILE.Positive, TRUE);
        ILE.SETRANGE(ILE.Open, TRUE);
        IF ILE.FINDFIRST THEN BEGIN

            EXIT(ILE."Entry No.");
        END;
    end;

    procedure EffectCancellation(var Endorsement: Record "Insure Header");
    var
        EndorsementLines: Record "Insure Lines";
        PolicyHeader: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        CertRec: Record "Certificate Printing";
    begin
        //MESSAGE('Endorsment XXXX policy No=%1 and Doc Type=%2',Endorsement."Policy No",Endorsement."Document Type");
        EndorsementLines.RESET;
        EndorsementLines.SETRANGE(EndorsementLines."Document Type", Endorsement."Document Type");
        EndorsementLines.SETRANGE(EndorsementLines."Document No.", Endorsement."No.");
        EndorsementLines.SETRANGE(EndorsementLines."Description Type", EndorsementLines."Description Type"::"Schedule of Insured");
        IF EndorsementLines.FINDFIRST THEN
            REPEAT
                //  MESSAGE('Risk ID =%1 and Reg No=%1',EndorsementLines."Select Risk ID",EndorsementLines."Registration No.");
                PolicyLines.RESET;
                PolicyLines.SETRANGE(PolicyLines."Document Type", PolicyLines."Document Type"::Policy);
                PolicyLines.SETRANGE(PolicyLines."Document No.", Endorsement."Policy No");
                PolicyLines.SETRANGE(PolicyLines."Line No.", EndorsementLines."Select Risk ID");
                IF PolicyLines.FINDFIRST THEN BEGIN
                    //  MESSAGE('Cancelling');
                    PolicyLines.Status := PolicyLines.Status::Cancelled;
                    PolicyLines.MODIFY;
                    PolicyLines."Endorsement Date" := TODAY;

                END;
                CertRec.RESET;
                CertRec.SETRANGE(CertRec."Registration No.", EndorsementLines."Registration No.");
                IF CertRec.FINDLAST THEN BEGIN
                    //MESSAGE('found cert Cancelling');
                    CertRec."cancellation Reason" := Endorsement."Cancellation Reason";
                    CertRec."Cancellation Date" := TODAY;
                    CertRec."Certificate Status" := CertRec."Certificate Status"::Cancelled;
                    CertRec.MODIFY;

                END;
            UNTIL EndorsementLines.NEXT = 0;
    end;

    procedure EffectSuspension(var Endorsement: Record "Insure Header");
    var
        EndorsementLines: Record "Insure Lines";
        PolicyHeader: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        CertRec: Record "Certificate Printing";
    begin


        EndorsementLines.RESET;
        EndorsementLines.SETRANGE(EndorsementLines."Document Type", Endorsement."Document Type");
        EndorsementLines.SETRANGE(EndorsementLines."Document No.", Endorsement."No.");
        IF EndorsementLines.FINDFIRST THEN
            REPEAT
                PolicyLines.RESET;
                PolicyLines.SETRANGE(PolicyLines."Document Type", PolicyLines."Document Type"::Policy);
                PolicyLines.SETRANGE(PolicyLines."Document No.", Endorsement."Policy No");
                PolicyLines.SETRANGE(PolicyLines."Line No.", EndorsementLines."Select Risk ID");
                IF PolicyLines.FINDFIRST THEN BEGIN
                    PolicyLines.Status := PolicyLines.Status::Suspended;
                    PolicyLines.MODIFY;
                    PolicyLines."Endorsement Date" := TODAY;

                END;
                CertRec.RESET;
                CertRec.SETRANGE(CertRec."Registration No.", EndorsementLines."Registration No.");
                IF CertRec.FINDLAST THEN BEGIN
                    CertRec."Certificate Status" := CertRec."Certificate Status"::Suspended;
                    CertRec.MODIFY;

                END;
            UNTIL EndorsementLines.NEXT = 0;
    end;

    procedure ConvertCreditNote2DebitNote(var InsureHeader: Record "Insure Debit Note");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Debit Note Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
    begin
        InsureHeaderCopy.TRANSFERFIELDS(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::"Debit Note";
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.TRANSFERFIELDS(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy.INSERT;
            //InsureLinesCopy.RENAME(InsureHeaderCopy."Document Type",InsureHeaderCopy."No.",InsureLinesCopy."Risk ID",InsureLinesCopy."Line No.");

            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT

                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT

                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", InsureHeaderLoading_DiscountCopy.Code);


            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT

                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy.RENAME(InsureHeaderCopy."Document Type", InsureHeaderCopy."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy.RENAME(InsureHeader."Document Type", InsureHeader."No.", InstalmentLinesCopy."Payment No");
            UNTIL InstalmentLines.NEXT = 0;
    end;

    procedure ConvertEndorsement2CreditNoteSub(var InsureHeader: Record "Insure Header");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        LoadingDiscSetup: Record "Loading and Discounts Setup";
    begin

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::"Credit Note";
        InsureHeaderCopy."No." := '';
        /*InsureHeaderCopy2.RESET;
        InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Document Type",InsureHeaderCopy2."Document Type"::Policy);
        InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Quotation No.",InsureHeader."No.");
        IF InsureHeaderCopy2.FINDFIRST THEN
        InsureHeaderCopy."Policy No":=InsureHeaderCopy2."No.";*/

        InsureHeaderCopy."Copied from No." := InsureHeader."No.";
        //MESSAGE('Policy no=%1',InsureHeaderCopy."Policy No");
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETRANGE(InsureLines."Description Type", InsureLines."Description Type"::"Schedule of Insured");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                IF InsureLines."Registration No." <> '' THEN BEGIN
                    IF InsureLines."Select Risk ID" = 0 THEN
                        ERROR('You must select a Risk ID being substituted by %1', InsureLines."Registration No.");
                    IF PolicyLines.GET(PolicyLines."Document Type"::Policy, InsureLines."Policy No", InsureLines."Select Risk ID") THEN
                        InsureLinesCopy.TRANSFERFIELDS(PolicyLines);
                END;
                InsureLinesCopy."Line No." := InsureLinesCopy."Line No." + 10000;
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT

                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.TRANSFERFIELDS(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;

            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.TRANSFERFIELDS(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                IF LoadingDiscSetup.GET(InsureHeaderLoading_DiscountCopy.Code) THEN
                    IF LoadingDiscSetup."Applicable to" <> LoadingDiscSetup."Applicable to"::"Certificate Charge" THEN
                        InsureHeaderLoading_DiscountCopy.INSERT;

            UNTIL InsureHeaderLoading_Discount.NEXT = 0;


        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.TRANSFERFIELDS(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;

                InstalmentLinesCopy.TRANSFERFIELDS(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        //Post Debit Note
        InsertTaxesReinsurance(InsureHeaderCopy);
        PostInsureHeaderDeffer(InsureHeaderCopy);

    end;

    procedure PostInsureHeaderDeffer(var InsureHeader: Record "Insure Header");
    var
        GenJnlLine: Record "Gen. Journal Line";
        AccountsMapping: Record "Insurance Accounting Mappings";
        Isetup: Record "Insurance setup";
        GenBatch: Record "Gen. Journal Batch";
        InsureLines: Record "Insure Lines";
        CoInsureReinsureBrokerLines: Record "Coinsurance Reinsurance Lines";
        TotalInvoice: Decimal;
        GLEntry: Record "G/L Entry";
        PostedDrHeader: Record "Insure Debit Note";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        PostedCrHeader: Record "Insure Credit Note";
        PostedDrLines: Record "Insure Debit Note Lines";
        PostedCrLines: Record "Insure Credit Note Lines";
        InsureHeaderOrder: Record "Insure Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CertificateforPrint: Record "Certificate Printing";
        UserDetails: Record "User Setup Details";
        PolicyType: Record "Policy Type";
        PolicyHeader: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        DimensionSetEntryRec: Record "Dimension Set Entry";
        DimensionSetEntryRecCopy: Record "Dimension Set Entry";
    begin
        IF InsureHeader.Posted THEN
            ERROR('This document is already posted');
        //MESSAGE('Posting No. Series=%1',InsureHeader."Posting No. Series");
        InsureHeader."Posting No." := NoSeriesMgt.GetNextNo(InsureHeader."Posting No. Series", InsureHeader."Posting Date", TRUE);
        //MESSAGE('Document No =%1 and Document Type=%2 and Policy No=%3',InsureHeader."No.",InsureHeader."Document Type",InsureHeader."Policy No");

        InsureHeader.TESTFIELD(InsureHeader."Policy No");
        TotalInvoice := 0;
        Isetup.GET;
        Isetup.TESTFIELD(Isetup."Insurance Template");
        GenBatch.INIT;
        GenBatch."Journal Template Name" := Isetup."Insurance Template";
        GenBatch.Name := InsuranceSetup."Insurance Batch";
        IF NOT GenBatch.GET(GenBatch."Journal Template Name", GenBatch.Name) THEN
            GenBatch.INSERT;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", Isetup."Insurance Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", InsuranceSetup."Insurance Batch");
        GenJnlLine.DELETEALL;

        AccountsMapping.RESET;
        AccountsMapping.SETRANGE(AccountsMapping."Class Code", InsureHeader."Policy Type");
        IF AccountsMapping.FINDFIRST THEN BEGIN
            //Premium
            InsureHeader.CALCFIELDS(InsureHeader."Total Premium Amount");
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
            GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
            GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
            GenJnlLine."Posting Date" := InsureHeader."Posting Date";
            GenJnlLine."Document No." := InsureHeader."Posting No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := AccountsMapping."Gross Premium Account";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
            GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                GenJnlLine.Amount := -InsureHeader."Total Premium Amount";
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                GenJnlLine.Amount := InsureHeader."Total Premium Amount";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            TotalInvoice := TotalInvoice + GenJnlLine.Amount;
            GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Premium;
            GenJnlLine."Policy No" := InsureHeader."Policy No";
            IF InsureHeader."Endorsement Policy No." = '' THEN
                GenJnlLine."Endorsement No." := InsureHeader."Policy No"
            ELSE
                GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
            GenJnlLine."Insured ID" := InsureHeader."Insured No.";
            GenJnlLine."Policy Type" := InsureHeader."Policy Type";
            GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
            GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
            GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
            GenJnlLine."Action Type" := InsureHeader."Action Type";

            IF GenJnlLine.Amount <> 0 THEN
                GenJnlLine.INSERT;
            //Tax
            DimensionSetEntryRec.RESET;
            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
            IF DimensionSetEntryRec.FINDFIRST THEN
                REPEAT

                    DimensionSetEntryRecCopy.INIT;
                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                        DimensionSetEntryRecCopy.INSERT;
                UNTIL DimensionSetEntryRec.NEXT = 0;

            InsureLines.RESET;
            InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
            InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
            InsureLines.SETRANGE(InsureLines."Description Type", InsureLines."Description Type"::Tax);
            IF InsureLines.FINDFIRST THEN
                REPEAT
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                    GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                    GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                    GenJnlLine."Document No." := InsureHeader."Posting No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := InsureLines."Account No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                        GenJnlLine.Amount := -InsureLines.Amount;
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                        GenJnlLine.Amount := InsureLines.Amount;

                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    TotalInvoice := TotalInvoice + GenJnlLine.Amount;
                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Tax;
                    GenJnlLine."Policy No" := InsureHeader."Policy No";
                    IF InsureHeader."Endorsement Policy No." = '' THEN
                        GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                    ELSE
                        GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                    GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                    GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                    GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                    GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                    GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                    GenJnlLine."Action Type" := InsureHeader."Action Type";


                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;


                UNTIL InsureLines.NEXT = 0;

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
            GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
            GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
            GenJnlLine."Posting Date" := InsureHeader."Posting Date";
            GenJnlLine."Document No." := InsureHeader."Posting No.";

            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            IF InsureHeader."Bill To Customer No." <> '' THEN
                GenJnlLine."Account No." := InsureHeader."Bill To Customer No."
            ELSE
                GenJnlLine."Account No." := InsureHeader."Insured No.";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
            GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);

            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                GenJnlLine.Amount := -TotalInvoice;
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                GenJnlLine.Amount := -TotalInvoice;

            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Net Premium";
            GenJnlLine."Policy No" := InsureHeader."Policy No";
            IF InsureHeader."Endorsement Policy No." = '' THEN
                GenJnlLine."Endorsement No." := InsureHeader."Policy No"
            ELSE
                GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
            GenJnlLine."Insured ID" := InsureHeader."Insured No.";
            GenJnlLine."Policy Type" := InsureHeader."Policy Type";
            GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
            GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
            GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
            GenJnlLine."Action Type" := InsureHeader."Action Type";

            IF GenJnlLine.Amount <> 0 THEN
                GenJnlLine.INSERT;

            DimensionSetEntryRec.RESET;
            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
            IF DimensionSetEntryRec.FINDFIRST THEN
                REPEAT

                    DimensionSetEntryRecCopy.INIT;
                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                        DimensionSetEntryRecCopy.INSERT;
                UNTIL DimensionSetEntryRec.NEXT = 0;



            CoInsureReinsureBrokerLines.RESET;
            CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."Document Type", InsureHeader."Document Type");
            CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."No.", InsureHeader."No.");
            IF CoInsureReinsureBrokerLines.FINDFIRST THEN
                REPEAT

                    IF CoInsureReinsureBrokerLines."Transaction Type" = CoInsureReinsureBrokerLines."Transaction Type"::"Broker " THEN BEGIN

                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        // MESSAGE('Broker =%1',InsureHeader."Agent/Broker");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."Broker Commission";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."Broker Commission";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Commission;
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := AccountsMapping."Gross Commission Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;

                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."WHT Amount";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."WHT Amount";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Wht;
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := Isetup."Withholding Tax Account";
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;



                    END
                    ELSE BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines.Premium;
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines.Premium;
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Reinsurance Premium";
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := AccountsMapping."XOL Premium Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;


                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                        GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."Cedant Commission";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."Cedant Commission";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Reinsurance Commission";
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := AccountsMapping."XOL Commission Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;




                    END;


                UNTIL CoInsureReinsureBrokerLines.NEXT = 0;




        END
        ELSE
            ERROR('Please set account mappings for class %1', InsureHeader."Policy Type");


        //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);

        /*GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.",InsureHeader."No.");
        GLEntry.SETRANGE(GLEntry.Reversed,FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN
        InsureHeader.Posted:=TRUE;
        InsureHeader."Posted DateTime":=CURRENTDATETIME;
        InsureHeader."Posted By":=USERID;
        InsureHeader.MODIFY;
        END;*/

        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
        //debit note
        BEGIN
            PostedDrHeader.INIT;
            PostedDrHeader.TRANSFERFIELDS(InsureHeader);
            PostedDrHeader."No." := InsureHeader."Posting No.";
            PolicyHeader.RESET;
            PolicyHeader.SETRANGE(PolicyHeader."Document Type", PolicyHeader."Document Type"::Policy);
            PolicyHeader.SETRANGE(PolicyHeader."Quotation No.", InsureHeader."Copied from No.");
            IF PolicyHeader.FINDFIRST THEN BEGIN
                PostedDrHeader."Endorsement Policy No." := PolicyHeader."No.";

            END;
            PostedDrHeader.INSERT;


            AdditionalBenefits.RESET;
            AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
            AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
            IF AdditionalBenefits.FINDFIRST THEN
                REPEAT

                    AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                    AdditionalBenefitsCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
                UNTIL AdditionalBenefits.NEXT = 0;

            InsureHeaderLoading_Discount.RESET;
            InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
            InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
            IF InsureHeaderLoading_Discount.FINDFIRST THEN
                REPEAT

                    InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                    InsureHeaderLoading_DiscountCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", InsureHeaderLoading_DiscountCopy.Code);


                UNTIL InsureHeaderLoading_Discount.NEXT = 0;

            Reinslines.RESET;
            Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
            Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
            IF Reinslines.FINDFIRST THEN
                REPEAT

                    ReinslinesCopy.COPY(Reinslines);
                    ReinslinesCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

                UNTIL Reinslines.NEXT = 0;

            InstalmentLines.RESET;
            InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
            InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
            IF InstalmentLines.FINDFIRST THEN
                REPEAT
                    InstalmentLinesCopy.COPY(InstalmentLines);
                    InstalmentLinesCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", InstalmentLinesCopy."Payment No");
                UNTIL InstalmentLines.NEXT = 0;




        END; //debit note

        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN BEGIN
            PostedCrHeader.INIT;
            PostedCrHeader.TRANSFERFIELDS(InsureHeader);
            PostedCrHeader."No." := InsureHeader."Posting No.";
            PolicyHeader.RESET;
            PolicyHeader.SETRANGE(PolicyHeader."Document Type", PolicyHeader."Document Type"::Policy);
            PolicyHeader.SETRANGE(PolicyHeader."Quotation No.", InsureHeader."Copied from No.");
            IF PolicyHeader.FINDFIRST THEN BEGIN
                PostedDrHeader."Endorsement Policy No." := PolicyHeader."No.";

            END;
            PostedCrHeader.INSERT;

            AdditionalBenefits.RESET;
            AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
            AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
            IF AdditionalBenefits.FINDFIRST THEN
                REPEAT

                    AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                    AdditionalBenefitsCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
                UNTIL AdditionalBenefits.NEXT = 0;

            InsureHeaderLoading_Discount.RESET;
            InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
            InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
            IF InsureHeaderLoading_Discount.FINDFIRST THEN
                REPEAT

                    InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                    InsureHeaderLoading_DiscountCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", InsureHeaderLoading_DiscountCopy.Code);


                UNTIL InsureHeaderLoading_Discount.NEXT = 0;

            Reinslines.RESET;
            Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
            Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
            IF Reinslines.FINDFIRST THEN
                REPEAT

                    ReinslinesCopy.COPY(Reinslines);
                    ReinslinesCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

                UNTIL Reinslines.NEXT = 0;

            InstalmentLines.RESET;
            InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
            InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
            IF InstalmentLines.FINDFIRST THEN
                REPEAT
                    InstalmentLinesCopy.COPY(InstalmentLines);
                    InstalmentLinesCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", InstalmentLinesCopy."Payment No");
                UNTIL InstalmentLines.NEXT = 0;



        END;


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");

        IF InsureLines.FINDFIRST THEN
            REPEAT
                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN BEGIN
                    PostedDrLines.INIT;
                    PostedDrLines.TRANSFERFIELDS(InsureLines);
                    PostedDrLines."Document No." := InsureHeader."Posting No.";
                    IF ((PostedDrLines."Registration No." <> '') OR (PostedDrLines.Amount <> 0)) THEN
                        PostedDrLines.INSERT;
                    CertificateforPrint.INIT;
                    CertificateforPrint."Document No." := PostedDrLines."Document No.";
                    CertificateforPrint."Line No." := PostedDrLines."Line No.";
                    CertificateforPrint."Registration No." := PostedDrLines."Registration No.";
                    CertificateforPrint.Make := PostedDrLines.Make;
                    CertificateforPrint."Year of Manufacture" := PostedDrLines."Year of Manufacture";
                    CertificateforPrint."Type of Body" := PostedDrLines."Type of Body";
                    CertificateforPrint.Amount := PostedDrLines.Amount;
                    CertificateforPrint."Policy Type" := PostedDrLines."Policy Type";
                    CertificateforPrint."Policy No" := InsureHeader."Policy No";
                    CertificateforPrint."Start Date" := InsureHeader."Cover Start Date";
                    CertificateforPrint."End Date" := InsureHeader."Cover End Date";
                    CertificateforPrint."No. Of Instalments" := PostedDrLines."No. Of Instalments";
                    CertificateforPrint."Chassis No." := PostedDrLines."Chassis No.";
                    CertificateforPrint."Engine No." := PostedDrLines."Engine No.";
                    CertificateforPrint."Seating Capacity" := PostedDrLines."Seating Capacity";
                    CertificateforPrint."Carrying Capacity" := PostedDrLines."Carrying Capacity";
                    CertificateforPrint."Certificate Status" := CertificateforPrint."Certificate Status"::Active;
                    CertificateforPrint."Vehicle License Class" := PostedDrLines."Vehicle License Class";
                    CertificateforPrint."Vehicle Usage" := PostedDrLines."Vehicle Usage";
                    IF PolicyType.GET(CertificateforPrint."Policy Type") THEN BEGIN
                        IF PolicyType."Bus Seating Capacity Cut-off" <> 0 THEN BEGIN
                            IF CertificateforPrint."Seating Capacity" <= PolicyType."Bus Seating Capacity Cut-off" THEN
                                CertificateforPrint."Certificate Type" := PolicyType."Certificate Type"
                            ELSE
                                CertificateforPrint."Certificate Type" := PolicyType."Certificate Type Bus";
                        END
                        ELSE
                            CertificateforPrint."Certificate Type" := PolicyType."Certificate Type"
                    END;
                    IF CertificateforPrint."Registration No." <> '' THEN
                        CertificateforPrint.INSERT;

                END;

                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN BEGIN
                    PostedCrLines.INIT;
                    PostedCrLines.TRANSFERFIELDS(InsureLines);
                    PostedCrLines."Document No." := InsureHeader."Posting No.";
                    IF ((PostedCrLines."Registration No." <> '') OR (PostedCrLines.Amount <> 0)) THEN
                        PostedCrLines.INSERT;
                END;

            UNTIL InsureLines.NEXT = 0;

        GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.", InsureHeader."Posting No.");
        GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN
            // MESSAGE('Entry posted');
            /*InsureLines.RESET;
            InsureLines.SETRANGE(InsureLines."Document Type",InsureHeader."Document Type");
            InsureLines.SETRANGE(InsureLines."Document No.",InsureHeader."No.");
            InsureLines.DELETEALL;*/

            /*InsureHeaderCopy.COPY(InsureHeader);
            InsureHeaderCopy.DELETE(TRUE);
            InsureHeaderOrder.RESET;
            InsureHeaderOrder.SETRANGE(InsureHeaderOrder."Document Type",InsureHeaderOrder."Document Type"::Endorsement);
            InsureHeaderOrder.SETRANGE(InsureHeaderOrder."No.",InsureHeader."Copied from No.");
            IF InsureHeaderOrder.FINDFIRST THEN
            InsureHeaderOrder.DELETE(TRUE);*/

            /*InsureHeaderOrder.RESET;
            InsureHeaderOrder.SETRANGE(InsureHeaderOrder."Document Type",InsureHeaderOrder."Document Type"::Quote);
            InsureHeaderOrder.SETRANGE(InsureHeaderOrder."No.",InsureHeader."Quotation No.");
            IF InsureHeaderOrder.FINDFIRST THEN
            InsureHeaderOrder.DELETE(TRUE);*/
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN
                IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::Cancel THEN
                    EffectCancellation(InsureHeader);

        END;


    end;

    //Bkk 17.03.21--Brokerage Posting procedure


    //bkk 17.03.21
    procedure RenewPolicyCover(var InsureHeader: Record "Insure Header");
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
    begin

        /*IF NOT SelectAllRisksTest(InsureHeader) THEN
          ERROR('Please select the Risks to extend cover for on Policy %1',InsureHeader."No.");*/

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
        EndorsementType.RESET;
        EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Renewal);
        IF EndorsementType.FINDLAST THEN BEGIN
            InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
            InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
        END;
        InsureHeaderCopy."Policy No" := InsureHeader."No.";
        //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
        InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Expected Renewal Date";
        InsureHeaderCopy."Cover Start Date" := InsureHeader."Expected Renewal Date";
        InsureHeaderCopy."Document Date" := InsureHeader."Expected Renewal Date";
        InsureHeaderCopy."From Date" := InsureHeader."Expected Renewal Date";
        InsureHeaderCopy.VALIDATE(InsureHeaderCopy."From Date");
        InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Cover Start Date");
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        //InsureLines.SETRANGE(InsureLines.Selected,TRUE);
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;
            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT
                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;
            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;



            UNTIL InsureHeaderLoading_Discount.NEXT = 0;

        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.COPY(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;
                InstalmentLinesCopy.COPY(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        PAGE.RUN(51513183, InsureHeaderCopy);

    end;

    procedure EffectRenewal(var Endorsement: Record "Insure Header");
    var
        EndorsementLines: Record "Insure Lines";
        PolicyHeader: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        CertRec: Record "Certificate Printing";
    begin
        IF PolicyHeader.GET(PolicyHeader."Document Type"::Policy, Endorsement."Policy No") THEN BEGIN
            PolicyHeader."Policy Status" := PolicyHeader."Policy Status"::Renewed;
            PolicyHeader.MODIFY;
        END;

        EndorsementLines.RESET;
        EndorsementLines.SETRANGE(EndorsementLines."Document Type", Endorsement."Document Type");
        EndorsementLines.SETRANGE(EndorsementLines."Document No.", Endorsement."No.");
        IF EndorsementLines.FINDFIRST THEN
            REPEAT
                PolicyLines.RESET;
                PolicyLines.SETRANGE(PolicyLines."Document Type", PolicyLines."Document Type"::Policy);
                PolicyLines.SETRANGE(PolicyLines."Document No.", Endorsement."Policy No");
                PolicyLines.SETRANGE(PolicyLines."Line No.", EndorsementLines."Select Risk ID");
                IF PolicyLines.FINDFIRST THEN BEGIN
                    PolicyLines.Status := PolicyLines.Status::Renewed;
                    PolicyLines.MODIFY;
                    PolicyLines."Endorsement Date" := TODAY;

                END;
                CertRec.RESET;
                CertRec.SETRANGE(CertRec."Registration No.", EndorsementLines."Registration No.");
                IF CertRec.FINDLAST THEN BEGIN
                    CertRec."Certificate Status" := CertRec."Certificate Status"::Cancelled;
                    CertRec.MODIFY;

                END;
            UNTIL EndorsementLines.NEXT = 0;
    end;

    procedure ConvertEndorsement2DebitNoteSub(var InsureHeader: Record "Insure Header");
    var
        Reinslines: Record "Coinsurance Reinsurance Lines";
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        LoadingDiscSetup: Record "Loading and Discounts Setup";
        Creditnotelines: Record "Insure Credit Note Lines";
    begin

        InsureHeaderCopy.COPY(InsureHeader);
        InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::"Debit Note";
        InsureHeaderCopy."No." := '';
        InsureHeaderCopy2.RESET;
        /*InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Document Type",InsureHeaderCopy2."Document Type"::Policy);
        InsureHeaderCopy2.SETRANGE(InsureHeaderCopy2."Quotation No.",InsureHeader."No.");
        IF InsureHeaderCopy2.FINDFIRST THEN*/
        InsureHeaderCopy."Copied from No." := InsureHeader."No.";
        //MESSAGE('Policy no=%1',InsureHeaderCopy."Policy No");
        InsureHeaderCopy.INSERT(TRUE);


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        IF InsureLines.FINDFIRST THEN
            REPEAT
                InsureLinesCopy.INIT;

                InsureLinesCopy.TRANSFERFIELDS(InsureLines);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy.INSERT;
                //bring here
                Creditnotelines.RESET;
                Creditnotelines.SETRANGE(Creditnotelines."Description Type", Creditnotelines."Description Type"::"Schedule of Insured");
                //Creditnotelines.SETRANGE(Creditnotelines."Policy No",InsureHeaderCopy."Policy No");
                Creditnotelines.SETRANGE(Creditnotelines."Registration No.", InsureLines."Substituted Vehicle Reg. No");
                IF Creditnotelines.FINDLAST THEN BEGIN
                    IF InsureLines."Substituted Vehicle Reg. No" <> '' THEN BEGIN
                        InsureHeaderCopy."Applies-to Doc. Type" := InsureHeaderCopy."Applies-to Doc. Type"::"Credit Memo";
                        InsureHeaderCopy."Applies-to Doc. No." := Creditnotelines."Document No.";
                        InsureHeaderCopy.MODIFY;
                    END;
                END;

            UNTIL InsureLines.NEXT = 0;

        AdditionalBenefits.RESET;
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
        AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
        IF AdditionalBenefits.FINDFIRST THEN
            REPEAT

                AdditionalBenefitsCopy.INIT;
                AdditionalBenefitsCopy.TRANSFERFIELDS(AdditionalBenefits);
                AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                AdditionalBenefitsCopy.INSERT;

            UNTIL AdditionalBenefits.NEXT = 0;

        InsureHeaderLoading_Discount.RESET;
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
        InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
        IF InsureHeaderLoading_Discount.FINDFIRST THEN
            REPEAT
                InsureHeaderLoading_DiscountCopy.INIT;
                InsureHeaderLoading_DiscountCopy.TRANSFERFIELDS(InsureHeaderLoading_Discount);
                InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                InsureHeaderLoading_DiscountCopy.INSERT;

            UNTIL InsureHeaderLoading_Discount.NEXT = 0;


        Reinslines.RESET;
        Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
        Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
        IF Reinslines.FINDFIRST THEN
            REPEAT
                ReinslinesCopy.INIT;
                ReinslinesCopy.TRANSFERFIELDS(Reinslines);
                ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                ReinslinesCopy."No." := InsureHeaderCopy."No.";
                ReinslinesCopy.INSERT;

            UNTIL Reinslines.NEXT = 0;

        InstalmentLines.RESET;
        InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
        InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
        IF InstalmentLines.FINDFIRST THEN
            REPEAT
                InstalmentLinesCopy.INIT;

                InstalmentLinesCopy.TRANSFERFIELDS(InstalmentLines);
                InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                InstalmentLinesCopy.INSERT;
            UNTIL InstalmentLines.NEXT = 0;
        //Post Debit Note
        PostInsureHeaderBoth(InsureHeaderCopy);

    end;

    procedure PostInsureHeaderBoth(var InsureHeader: Record "Insure Header");
    var
        GenJnlLine: Record "Gen. Journal Line";
        AccountsMapping: Record "Insurance Accounting Mappings";
        Isetup: Record "Insurance setup";
        GenBatch: Record "Gen. Journal Batch";
        InsureLines: Record "Insure Lines";
        CoInsureReinsureBrokerLines: Record "Coinsurance Reinsurance Lines";
        TotalInvoice: Decimal;
        GLEntry: Record "G/L Entry";
        PostedDrHeader: Record "Insure Debit Note";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        PostedCrHeader: Record "Insure Credit Note";
        PostedDrLines: Record "Insure Debit Note Lines";
        PostedCrLines: Record "Insure Credit Note Lines";
        InsureHeaderOrder: Record "Insure Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CertificateforPrint: Record "Certificate Printing";
        UserDetails: Record "User Setup Details";
        PolicyType: Record "Policy Type";
        PolicyHeader: Record "Insure Header";
        PolicyLines: Record "Insure Lines";
        LastLineNo: Integer;
        CrNoteHeader: Record "Insure Header";
        DimensionSetEntryRec: Record "Dimension Set Entry";
        DimensionSetEntryRecCopy: Record "Dimension Set Entry";
    begin
        IF InsureHeader.Posted THEN
            ERROR('This document is already posted');
        //MESSAGE('Posting No. Series=%1',InsureHeader."Posting No. Series");
        InsureHeader."Posting No." := NoSeriesMgt.GetNextNo(InsureHeader."Posting No. Series", InsureHeader."Posting Date", TRUE);
        //MESSAGE('Document No =%1 and Document Type=%2 and Policy No=%3',InsureHeader."No.",InsureHeader."Document Type",InsureHeader."Policy No");

        InsureHeader.TESTFIELD(InsureHeader."Policy No");
        TotalInvoice := 0;
        Isetup.GET;
        Isetup.TESTFIELD(Isetup."Insurance Template");
        GenBatch.INIT;
        GenBatch."Journal Template Name" := Isetup."Insurance Template";
        GenBatch.Name := InsuranceSetup."Insurance Batch";
        IF NOT GenBatch.GET(GenBatch."Journal Template Name", GenBatch.Name) THEN
            GenBatch.INSERT;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", Isetup."Insurance Template");
        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", InsuranceSetup."Insurance Batch");
        IF GenJnlLine.FINDLAST THEN
            LastLineNo := GenJnlLine."Line No.";

        AccountsMapping.RESET;
        AccountsMapping.SETRANGE(AccountsMapping."Class Code", InsureHeader."Policy Type");
        IF AccountsMapping.FINDFIRST THEN BEGIN
            //Premium
            InsureHeader.CALCFIELDS(InsureHeader."Total Premium Amount");
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
            GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
            LastLineNo := LastLineNo + 10000;
            GenJnlLine."Line No." := LastLineNo;
            GenJnlLine."Posting Date" := InsureHeader."Posting Date";
            GenJnlLine."Document No." := InsureHeader."Posting No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := AccountsMapping."Gross Premium Account";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
            GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                GenJnlLine.Amount := -InsureHeader."Total Premium Amount";
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                GenJnlLine.Amount := InsureHeader."Total Premium Amount";
            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            TotalInvoice := TotalInvoice + GenJnlLine.Amount;
            GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Premium;
            GenJnlLine."Policy No" := InsureHeader."Policy No";
            IF InsureHeader."Endorsement Policy No." = '' THEN
                GenJnlLine."Endorsement No." := InsureHeader."Policy No"
            ELSE
                GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
            GenJnlLine."Insured ID" := InsureHeader."Insured No.";
            GenJnlLine."Policy Type" := InsureHeader."Policy Type";
            GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
            GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
            GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
            GenJnlLine."Action Type" := InsureHeader."Action Type";

            IF GenJnlLine.Amount <> 0 THEN
                GenJnlLine.INSERT;
            //Tax
            DimensionSetEntryRec.RESET;
            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
            IF DimensionSetEntryRec.FINDFIRST THEN
                REPEAT

                    DimensionSetEntryRecCopy.INIT;
                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                        DimensionSetEntryRecCopy.INSERT;
                UNTIL DimensionSetEntryRec.NEXT = 0;

            InsureLines.RESET;
            InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
            InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
            InsureLines.SETRANGE(InsureLines."Description Type", InsureLines."Description Type"::Tax);
            IF InsureLines.FINDFIRST THEN
                REPEAT
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                    LastLineNo := LastLineNo + 10000;
                    GenJnlLine."Line No." := LastLineNo;

                    GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                    GenJnlLine."Document No." := InsureHeader."Posting No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := InsureLines."Account No.";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                        GenJnlLine.Amount := -InsureLines.Amount;
                    IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                        GenJnlLine.Amount := InsureLines.Amount;

                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    TotalInvoice := TotalInvoice + GenJnlLine.Amount;
                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Tax;
                    GenJnlLine."Policy No" := InsureHeader."Policy No";
                    IF InsureHeader."Endorsement Policy No." = '' THEN
                        GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                    ELSE
                        GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                    GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                    GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                    GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                    GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                    GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                    GenJnlLine."Action Type" := InsureHeader."Action Type";
                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;

                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;


                UNTIL InsureLines.NEXT = 0;

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
            GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
            LastLineNo := LastLineNo + 10000;
            GenJnlLine."Line No." := LastLineNo;

            GenJnlLine."Posting Date" := InsureHeader."Posting Date";
            GenJnlLine."Document No." := InsureHeader."Posting No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            IF InsureHeader."Bill To Customer No." <> '' THEN
                GenJnlLine."Account No." := InsureHeader."Bill To Customer No."
            ELSE
                GenJnlLine."Account No." := InsureHeader."Insured No.";
            GenJnlLine.VALIDATE(GenJnlLine."Account No.");
            //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
            GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);

            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                GenJnlLine.Amount := -TotalInvoice;
            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                GenJnlLine.Amount := -TotalInvoice;

            GenJnlLine.VALIDATE(GenJnlLine.Amount);
            GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Net Premium";
            GenJnlLine."Policy No" := InsureHeader."Policy No";
            IF InsureHeader."Endorsement Policy No." = '' THEN
                GenJnlLine."Endorsement No." := InsureHeader."Policy No"
            ELSE
                GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
            GenJnlLine."Insured ID" := InsureHeader."Insured No.";
            GenJnlLine."Policy Type" := InsureHeader."Policy Type";
            GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
            GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
            GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
            GenJnlLine."Action Type" := InsureHeader."Action Type";

            IF GenJnlLine.Amount <> 0 THEN
                GenJnlLine.INSERT;
            DimensionSetEntryRec.RESET;
            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
            IF DimensionSetEntryRec.FINDFIRST THEN
                REPEAT

                    DimensionSetEntryRecCopy.INIT;
                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                        DimensionSetEntryRecCopy.INSERT;
                UNTIL DimensionSetEntryRec.NEXT = 0;


            CoInsureReinsureBrokerLines.RESET;
            CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."Document Type", InsureHeader."Document Type");
            CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."No.", InsureHeader."No.");
            IF CoInsureReinsureBrokerLines.FINDFIRST THEN
                REPEAT

                    IF CoInsureReinsureBrokerLines."Transaction Type" = CoInsureReinsureBrokerLines."Transaction Type"::"Broker " THEN BEGIN

                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                        LastLineNo := LastLineNo + 10000;
                        GenJnlLine."Line No." := LastLineNo;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        // MESSAGE('Broker =%1',InsureHeader."Agent/Broker");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."Broker Commission";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."Broker Commission";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Shortcut Dimension 1 Code" := InsureHeader."Shortcut Dimension 1 Code";
                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Commission;
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        GenJnlLine."Bal. Account No." := AccountsMapping."Gross Commission Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;

                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                        LastLineNo := LastLineNo + 10000;
                        GenJnlLine."Line No." := LastLineNo;
                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."WHT Amount";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."WHT Amount";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Shortcut Dimension 1 Code" := InsureHeader."Shortcut Dimension 1 Code";
                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::Wht;
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        GenJnlLine."Bal. Account No." := Isetup."Withholding Tax Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;



                    END
                    ELSE BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                        LastLineNo := LastLineNo + 10000;
                        GenJnlLine."Line No." := LastLineNo;

                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        GenJnlLine.VALIDATE("Account No.");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines.Premium;
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines.Premium;
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Reinsurance Premium";
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := AccountsMapping."XOL Premium Account";
                        GenJnlLine.VALIDATE("Bal. Account No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;

                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := Isetup."Insurance Template";
                        GenJnlLine."Journal Batch Name" := InsuranceSetup."Insurance Batch";
                        LastLineNo := LastLineNo + 10000;
                        GenJnlLine."Line No." := LastLineNo;


                        GenJnlLine."Posting Date" := InsureHeader."Posting Date";
                        GenJnlLine."Document No." := InsureHeader."Posting No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                        GenJnlLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                        GenJnlLine.VALIDATE("Account No.");
                        //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", InsureHeader."Policy No"), 1, 50);
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                            GenJnlLine.Amount := CoInsureReinsureBrokerLines."Cedant Commission";
                        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                            GenJnlLine.Amount := -CoInsureReinsureBrokerLines."Cedant Commission";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Reinsurance Commission";
                        GenJnlLine."Policy No" := InsureHeader."Policy No";
                        IF InsureHeader."Endorsement Policy No." = '' THEN
                            GenJnlLine."Endorsement No." := InsureHeader."Policy No"
                        ELSE
                            GenJnlLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                        GenJnlLine."Insured ID" := InsureHeader."Insured No.";
                        GenJnlLine."Policy Type" := InsureHeader."Policy Type";
                        GenJnlLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                        GenJnlLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                        GenJnlLine."Endorsement Type" := InsureHeader."Endorsement Type";
                        GenJnlLine."Action Type" := InsureHeader."Action Type";

                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := AccountsMapping."XOL Commission Account";
                        GenJnlLine.VALIDATE("Bal. Account No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                        DimensionSetEntryRec.RESET;
                        DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                        IF DimensionSetEntryRec.FINDFIRST THEN
                            REPEAT

                                DimensionSetEntryRecCopy.INIT;
                                DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                                DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                    DimensionSetEntryRecCopy.INSERT;
                            UNTIL DimensionSetEntryRec.NEXT = 0;




                    END;


                UNTIL CoInsureReinsureBrokerLines.NEXT = 0;




        END
        ELSE
            ERROR('Please set account mappings for class %1', InsureHeader."Policy Type");


        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

        /*GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.",InsureHeader."No.");
        GLEntry.SETRANGE(GLEntry.Reversed,FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN
        InsureHeader.Posted:=TRUE;
        InsureHeader."Posted DateTime":=CURRENTDATETIME;
        InsureHeader."Posted By":=USERID;
        InsureHeader.MODIFY;
        END;*/

        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN BEGIN
            PostedDrHeader.INIT;
            PostedDrHeader.TRANSFERFIELDS(InsureHeader);
            PostedDrHeader."No." := InsureHeader."Posting No.";
            PolicyHeader.RESET;
            PolicyHeader.SETRANGE(PolicyHeader."Document Type", PolicyHeader."Document Type"::Policy);
            PolicyHeader.SETRANGE(PolicyHeader."Quotation No.", InsureHeader."Copied from No.");
            IF PolicyHeader.FINDFIRST THEN BEGIN
                PostedDrHeader."Endorsement Policy No." := PolicyHeader."No.";

            END;
            PostedDrHeader.INSERT;


            AdditionalBenefits.RESET;
            AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
            AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
            IF AdditionalBenefits.FINDFIRST THEN
                REPEAT

                    AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                    AdditionalBenefitsCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
                UNTIL AdditionalBenefits.NEXT = 0;

            InsureHeaderLoading_Discount.RESET;
            InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
            InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
            IF InsureHeaderLoading_Discount.FINDFIRST THEN
                REPEAT

                    InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                    InsureHeaderLoading_DiscountCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", InsureHeaderLoading_DiscountCopy.Code);


                UNTIL InsureHeaderLoading_Discount.NEXT = 0;

            Reinslines.RESET;
            Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
            Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
            IF Reinslines.FINDFIRST THEN
                REPEAT

                    ReinslinesCopy.COPY(Reinslines);
                    ReinslinesCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

                UNTIL Reinslines.NEXT = 0;

            InstalmentLines.RESET;
            InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
            InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
            IF InstalmentLines.FINDFIRST THEN
                REPEAT
                    InstalmentLinesCopy.COPY(InstalmentLines);
                    InstalmentLinesCopy.RENAME(InsureHeader."Document Type", PostedDrHeader."No.", InstalmentLinesCopy."Payment No");
                UNTIL InstalmentLines.NEXT = 0;




        END;
        IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN BEGIN
            PostedCrHeader.INIT;
            PostedCrHeader.TRANSFERFIELDS(InsureHeader);
            PostedCrHeader."No." := InsureHeader."Posting No.";
            PolicyHeader.RESET;
            PolicyHeader.SETRANGE(PolicyHeader."Document Type", PolicyHeader."Document Type"::Policy);
            PolicyHeader.SETRANGE(PolicyHeader."Quotation No.", InsureHeader."Copied from No.");
            IF PolicyHeader.FINDFIRST THEN BEGIN
                PostedDrHeader."Endorsement Policy No." := PolicyHeader."No.";

            END;
            PostedCrHeader.INSERT;

            AdditionalBenefits.RESET;
            AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
            AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
            IF AdditionalBenefits.FINDFIRST THEN
                REPEAT

                    AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                    AdditionalBenefitsCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", AdditionalBenefitsCopy."Risk ID", AdditionalBenefitsCopy."Option ID");
                UNTIL AdditionalBenefits.NEXT = 0;

            InsureHeaderLoading_Discount.RESET;
            InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
            InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
            IF InsureHeaderLoading_Discount.FINDFIRST THEN
                REPEAT

                    InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                    InsureHeaderLoading_DiscountCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", InsureHeaderLoading_DiscountCopy.Code);


                UNTIL InsureHeaderLoading_Discount.NEXT = 0;

            Reinslines.RESET;
            Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
            Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
            IF Reinslines.FINDFIRST THEN
                REPEAT

                    ReinslinesCopy.COPY(Reinslines);
                    ReinslinesCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", ReinslinesCopy."Transaction Type", ReinslinesCopy."Partner No.", ReinslinesCopy.TreatyLineID);

                UNTIL Reinslines.NEXT = 0;

            InstalmentLines.RESET;
            InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
            InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
            IF InstalmentLines.FINDFIRST THEN
                REPEAT
                    InstalmentLinesCopy.COPY(InstalmentLines);
                    InstalmentLinesCopy.RENAME(InsureHeader."Document Type", PostedCrHeader."No.", InstalmentLinesCopy."Payment No");
                UNTIL InstalmentLines.NEXT = 0;



        END;


        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", InsureHeader."Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
        InsureLines.SETFILTER(InsureLines.Amount, '<>%1', 0);
        IF InsureLines.FINDFIRST THEN
            REPEAT
                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN BEGIN
                    PostedDrLines.INIT;
                    PostedDrLines.TRANSFERFIELDS(InsureLines);
                    PostedDrLines."Document No." := InsureHeader."Posting No.";
                    PostedDrLines.INSERT;
                    CertificateforPrint.INIT;
                    CertificateforPrint."Document No." := PostedDrLines."Document No.";
                    CertificateforPrint."Line No." := PostedDrLines."Line No.";
                    CertificateforPrint."Registration No." := PostedDrLines."Registration No.";
                    CertificateforPrint.Make := PostedDrLines.Make;
                    CertificateforPrint."Year of Manufacture" := PostedDrLines."Year of Manufacture";
                    CertificateforPrint."Type of Body" := PostedDrLines."Type of Body";
                    CertificateforPrint.Amount := PostedDrLines.Amount;
                    CertificateforPrint."Policy Type" := PostedDrLines."Policy Type";
                    CertificateforPrint."Policy No" := InsureHeader."Policy No";
                    CertificateforPrint."Start Date" := InsureHeader."Cover Start Date";
                    CertificateforPrint."End Date" := InsureHeader."Cover End Date";
                    CertificateforPrint."No. Of Instalments" := PostedDrLines."No. Of Instalments";
                    CertificateforPrint."Chassis No." := PostedDrLines."Chassis No.";
                    CertificateforPrint."Engine No." := PostedDrLines."Engine No.";
                    CertificateforPrint."Seating Capacity" := PostedDrLines."Seating Capacity";
                    CertificateforPrint."Carrying Capacity" := PostedDrLines."Carrying Capacity";
                    CertificateforPrint."Certificate Status" := CertificateforPrint."Certificate Status"::Active;
                    CertificateforPrint."Vehicle License Class" := PostedDrLines."Vehicle License Class";
                    CertificateforPrint."Vehicle Usage" := PostedDrLines."Vehicle Usage";
                    /*IF PolicyType.GET(CertificateforPrint."Policy Type") THEN
                    CertificateforPrint."Certificate Type":=PolicyType."Certificate Type";*/
                    IF PolicyType.GET(CertificateforPrint."Policy Type") THEN BEGIN
                        IF PolicyType."Bus Seating Capacity Cut-off" <> 0 THEN BEGIN
                            IF CertificateforPrint."Seating Capacity" <= PolicyType."Bus Seating Capacity Cut-off" THEN
                                CertificateforPrint."Certificate Type" := PolicyType."Certificate Type"
                            ELSE
                                CertificateforPrint."Certificate Type" := PolicyType."Certificate Type Bus";
                        END
                        ELSE
                            CertificateforPrint."Certificate Type" := PolicyType."Certificate Type"
                    END;
                    IF CertificateforPrint."Registration No." <> '' THEN
                        CertificateforPrint.INSERT;

                END;

                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN BEGIN
                    PostedCrLines.INIT;
                    PostedCrLines.TRANSFERFIELDS(InsureLines);
                    PostedCrLines."Document No." := InsureHeader."Posting No.";
                    PostedCrLines.INSERT;
                END;

            UNTIL InsureLines.NEXT = 0;

        GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.", InsureHeader."Posting No.");
        GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN
            // MESSAGE('Entry posted');
            /*InsureLines.RESET;
            InsureLines.SETRANGE(InsureLines."Document Type",InsureHeader."Document Type");
            InsureLines.SETRANGE(InsureLines."Document No.",InsureHeader."No.");
            InsureLines.DELETEALL;*/




            InsureHeaderCopy.COPY(InsureHeader);
            InsureHeaderCopy.DELETE(TRUE);
            InsureHeaderOrder.RESET;
            InsureHeaderOrder.SETRANGE(InsureHeaderOrder."Document Type", InsureHeaderOrder."Document Type"::Endorsement);
            InsureHeaderOrder.SETRANGE(InsureHeaderOrder."No.", InsureHeader."Copied from No.");
            IF InsureHeaderOrder.FINDFIRST THEN
                InsureHeaderOrder.DELETE(TRUE);

            InsureHeaderOrder.RESET;
            InsureHeaderOrder.SETRANGE(InsureHeaderOrder."Document Type", InsureHeaderOrder."Document Type"::Quote);
            InsureHeaderOrder.SETRANGE(InsureHeaderOrder."No.", InsureHeader."Quotation No.");
            IF InsureHeaderOrder.FINDFIRST THEN
                InsureHeaderOrder.DELETE(TRUE);


        END;


    end;

    procedure DrawPaymentClaimInvoice(var PolicyHeader: Record "Purchase Header");
    var
        PaymentSchedule: Record "Instalment Payment Plan";
        TotalPremium: Decimal;
        PolicyLines: Record "Insure Lines";
        StartDate: Date;
        i: Integer;
        PaymentTerms: Record "No. of Instalments";
    begin
        PaymentSchedule.RESET;
        PaymentSchedule.SETRANGE(PaymentSchedule."Document Type", PolicyHeader."Document Type");
        PaymentSchedule.SETRANGE(PaymentSchedule."Document No.", PolicyHeader."No.");
        PaymentSchedule.DELETEALL;

        IF PolicyHeader."No." <> '' THEN BEGIN
            IF PaymentTerms.GET(PolicyHeader."No. Of Instalments") THEN BEGIN
                IF PaymentTerms."No. Of Instalments" > 1 THEN BEGIN

                    StartDate := PolicyHeader."Document Date";
                    FOR i := 1 TO PaymentTerms."No. Of Instalments" DO BEGIN
                        PaymentSchedule.INIT;
                        PaymentSchedule."Document Type" := PolicyHeader."Document Type";
                        PaymentSchedule."Document No." := PolicyHeader."No.";
                        PaymentSchedule."Payment No" := i;
                        PolicyHeader.CALCFIELDS(PolicyHeader."Amount Including VAT");
                        PaymentSchedule."Amount Due" := PolicyHeader."Amount Including VAT" / PolicyHeader."No. Of Instalments";

                        //PaymentSchedule."Amount Due":=PolicyHeader."Amount Including VAT";
                        IF i = 1 THEN
                            PaymentSchedule."Due Date" := StartDate
                        ELSE BEGIN
                            StartDate := CALCDATE(PaymentTerms."Period Length", StartDate);
                            PaymentSchedule."Due Date" := StartDate;

                        END;


                        IF PaymentSchedule.GET(PaymentSchedule."Document Type", PaymentSchedule."Document No.", PaymentSchedule."Payment No") THEN
                            PaymentSchedule.MODIFY
                        ELSE
                            PaymentSchedule.INSERT;

                    END;

                END;
            END;
        END;
    end;

    local procedure CheckInProgressOpportunities(var SalesHeader: Record "Insure Header");
    var
        Opp: Record Opportunity;
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
    begin
        Opp.RESET;
        Opp.SETCURRENTKEY("Sales Document Type", "Sales Document No.");
        Opp.SETRANGE("Sales Document Type", Opp."Sales Document Type"::Quote);
        Opp.SETRANGE("Sales Document No.", SalesHeader."No.");
        Opp.SETRANGE(Status, Opp.Status::"In Progress");
        IF Opp.FINDFIRST THEN BEGIN
            IF NOT CONFIRM(Text000, TRUE, Opp.TABLECAPTION, Opp."Sales Document Type"::Quote, Opp."Sales Document Type"::Order) THEN
                ERROR('');
            TempOpportunityEntry.DELETEALL;
            TempOpportunityEntry.INIT;
            TempOpportunityEntry.VALIDATE("Opportunity No.", Opp."No.");
            TempOpportunityEntry."Sales Cycle Code" := Opp."Sales Cycle Code";
            TempOpportunityEntry."Contact No." := Opp."Contact No.";
            TempOpportunityEntry."Contact Company No." := Opp."Contact Company No.";
            TempOpportunityEntry."Salesperson Code" := Opp."Salesperson Code";
            TempOpportunityEntry."Campaign No." := Opp."Campaign No.";
            TempOpportunityEntry."Action Taken" := TempOpportunityEntry."Action Taken"::Won;
            TempOpportunityEntry."Wizard Step" := 1;
            TempOpportunityEntry.INSERT;
            TempOpportunityEntry.SETRANGE("Action Taken", TempOpportunityEntry."Action Taken"::Won);
            PAGE.RUNMODAL(PAGE::"Close Opportunity", TempOpportunityEntry);
            Opp.RESET;
            Opp.SETCURRENTKEY("Sales Document Type", "Sales Document No.");
            Opp.SETRANGE("Sales Document Type", Opp."Sales Document Type"::Quote);
            Opp.SETRANGE("Sales Document No.", SalesHeader."No.");
            Opp.SETRANGE(Status, Opp.Status::"In Progress");
            IF Opp.FINDFIRST THEN
                ERROR(Text001, Opp.TABLECAPTION, Opp."Sales Document Type"::Quote, Opp."Sales Document Type"::Order);
            COMMIT;
            SalesHeader.GET(SalesHeader."Document Type", SalesHeader."No.");
        END;
    end;

    local procedure MoveWonLostOpportunites(var SalesQuoteHeader: Record "Insure Header"; var SalesOrderHeader: Record "Insure Header");
    var
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
    begin
        Opp.RESET;
        Opp.SETCURRENTKEY("Sales Document Type", "Sales Document No.");
        Opp.SETRANGE("Sales Document Type", Opp."Sales Document Type"::Quote);
        Opp.SETRANGE("Sales Document No.", SalesQuoteHeader."No.");
        IF Opp.FINDFIRST THEN
            IF Opp.Status = Opp.Status::Won THEN BEGIN
                Opp."Sales Document Type" := Opp."Sales Document Type"::Order;
                Opp."Sales Document No." := SalesOrderHeader."No.";
                Opp.MODIFY;
                OpportunityEntry.RESET;
                OpportunityEntry.SETCURRENTKEY(Active, "Opportunity No.");
                OpportunityEntry.SETRANGE(Active, TRUE);
                OpportunityEntry.SETRANGE("Opportunity No.", Opp."No.");
                IF OpportunityEntry.FINDFIRST THEN BEGIN
                    OpportunityEntry."Calcd. Current Value (LCY)" := SalesOrderHeader."Total Net Premium";
                    OpportunityEntry.MODIFY;
                END;
            END ELSE
                IF Opp.Status = Opp.Status::Lost THEN BEGIN
                    Opp."Sales Document Type" := Opp."Sales Document Type"::" ";
                    Opp."Sales Document No." := '';
                    Opp.MODIFY;
                END;
    end;

    /* procedure CheckPaymentforDebitNote(var Certprint: Record "Certificate Printing") Paid: Boolean;
    var
        CustLedger: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        ReceiptLines: Record "Receipt Lines";
        ReceiptHeader: Record "Receipts Header";
        CustLedgerDnotes: Record "Cust. Ledger Entry";
        CustLedgerREc: Record "Cust. Ledger Entry";
        TotalDebitNote: Decimal;
        TotalReceipts: Decimal;
    begin
        Paid := FALSE;
        CustLedger.RESET;
        CustLedger.SETCURRENTKEY(CustLedger."Document No.");
        CustLedger.SETRANGE(CustLedger."Document No.", Certprint."Document No.");
        CustLedger.SETRANGE(CustLedger."Insurance Trans Type", CustLedger."Insurance Trans Type"::"Net Premium");
        IF CustLedger.FINDFIRST THEN BEGIN
            CustLedger.CALCFIELDS(CustLedger."Remaining Amount");
            IF CustLedger."Remaining Amount" = 0 THEN
                Paid := TRUE;
            IF NOT Paid THEN BEGIN
                ReceiptLines.RESET;
                ReceiptLines.SETCURRENTKEY(ReceiptLines."Applies to Doc. No");
                ReceiptLines.SETRANGE(ReceiptLines."Applies to Doc. No", CustLedger."Document No.");
                 IF ReceiptLines.FINDFIRST THEN
                    IF ReceiptHeader.GET(ReceiptLines."Receipt No.") THEN
                        IF ReceiptHeader."Receipt Amount type" = ReceiptHeader."Receipt Amount type"::"Net " THEN BEGIN
                            TotalDebitNote := 0;
                            TotalReceipts := 0;
                            CustLedger.RESET;
                            CustLedgerREc.SETCURRENTKEY(CustLedgerREc."Document No.");
                            CustLedgerREc.SETRANGE(CustLedgerREc."Document No.", ReceiptHeader."Receipt No.");
                            CustLedgerREc.SETRANGE(CustLedgerREc."Insurance Trans Type", CustLedger."Insurance Trans Type"::"Net Premium");
                            IF CustLedgerREc.FINDFIRST THEN
                                REPEAT
                                    CustLedgerREc.CALCFIELDS(CustLedgerREc."Amount (LCY)");
                                    TotalReceipts := TotalReceipts + CustLedgerREc."Amount (LCY)";

                                UNTIL CustLedgerREc.NEXT = 0;

                            CustLedgerDnotes.SETCURRENTKEY(CustLedgerDnotes."Document No.");
                            CustLedgerDnotes.SETRANGE(CustLedgerDnotes."Document No.", CustLedger."Document No.");
                            // CustLedgerDnotes.SETRANGE(CustLedgerDnotes."Insurance Trans Type",CustLedgerDnotes."Insurance Trans Type"::"Net Premium");
                            IF CustLedgerDnotes.FINDFIRST THEN
                                REPEAT
                                    CustLedgerDnotes.CALCFIELDS(CustLedgerDnotes."Amount (LCY)");
                                    TotalDebitNote := TotalDebitNote + CustLedgerDnotes."Amount (LCY)";

                                UNTIL CustLedgerDnotes.NEXT = 0;
                            // MESSAGE('Total Receipts=%1 and Total Debit Note=%2',TotalReceipts,TotalDebitNote);
                            IF TotalDebitNote + TotalReceipts = 0 THEN
                                Paid := TRUE;
                        END; 
            end;
        end;


            
            IF DEbetNote.GET(Certprint."Document No.") THEN
            IF Cust.GET(DEbetNote."Bill To Customer No.") THEN
            Cust.CALCFIELDS(Cust.Balance);
            IF Cust."Credit Limit (LCY)"=0 THEN
              IF Cust.Balance>0 THEN
                ERROR('The balance on the account is %1 and cannot allow printing of certificate',Cust.Balance)
              ELSE
                Paid:=TRUE;
            EXIT(Paid);

        end; */


    procedure ExtendPolicyCoverRisk(var VehicleRegNo: Code[20]);
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        InsureLinesRec: Record "Insure Lines";
        InsureHeader: Record "Insure Header";
        Payschedule: Record "Instalment Payment Plan";
    begin

        InsureLinesRec.RESET;
        InsureLinesRec.SETCURRENTKEY(InsureLinesRec."Start Date");
        InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
        InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Live);
        InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", VehicleRegNo);
        IF InsureLinesRec.FINDLAST THEN BEGIN
            IF InsureHeader.GET(InsureLinesRec."Document Type", InsureLinesRec."Document No.") THEN BEGIN
                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
                EndorsementType.RESET;
                EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Extension);
                IF EndorsementType.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
                    InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
                END;
                IF (InsureHeader."Action Type" = InsureHeader."Action Type"::New) OR (InsureHeader."Action Type" = InsureHeader."Action Type"::Renewal) THEN
                    InsureHeaderCopy."Policy No" := InsureHeader."No.";
                InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
                //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
                //InsureHeaderCopy."Cover Start Date":=GetEndorsementStartDate(InsureHeaderCopy);
                /*Payschedule.RESET;
                Payschedule.SETRANGE(Payschedule."Document Type",InsureHeader."Document Type");
                Payschedule.SETRANGE(Payschedule."Document No.",InsureHeader."No.");
                Payschedule.SETRANGE(Payschedule."Payment No",InsureHeader."Instalment No."+1);
                IF Payschedule.FINDLAST THEN
                  BEGIN
                  InsureHeaderCopy."Instalment No.":=Payschedule."Payment No";
                  InsureHeaderCopy."Cover Start Date":=Payschedule."Cover Start Date";
                  //InsureHeaderCopy.VALIDATE("Cover Start Date");

                  //InsureHeaderCopy."Cover End Date":=Payschedule."Cover End Date";

                END;*/
                InsureHeaderCopy."No." := '';
                InsureHeaderCopy.INSERT(TRUE);

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.INIT;
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                        InstalmentLinesCopy.INSERT;
                    UNTIL InstalmentLines.NEXT = 0;
                // MESSAGE('Instalment Number=%1',InsureHeader."Instalment No."+
                //InsureHeader."No. Of Cover Periods");
                Payschedule.RESET;
                Payschedule.SETRANGE(Payschedule."Document Type", InsureHeaderCopy."Document Type");
                Payschedule.SETRANGE(Payschedule."Document No.", InsureHeaderCopy."No.");
                Payschedule.SETRANGE(Payschedule."Payment No", InsureHeader."Instalment No." +
              InsureHeader."No. Of Cover Periods");

                IF Payschedule.FINDFIRST THEN BEGIN
                    InsureHeaderCopy."Cover Start Date" := Payschedule."Due Date";
                    InsureHeaderCopy."Instalment No." := Payschedule."Payment No";
                    InsureHeaderCopy."Cover End Date" := Payschedule."Cover End Date";
                    //MESSAGE('Cover start date=%1 Instalment no=%2',InsureHeaderCopy."Cover Start Date",InsureHeaderCopy."Instalment No.");
                END;
                InsureHeaderCopy.VALIDATE("Cover Start Date");
                InsureHeaderCopy.MODIFY;
                //MESSAGE('Cover End date=%1',InsureHeaderCopy."Cover End Date");

                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLinesRec);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;


                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT
                        AdditionalBenefitsCopy.INIT;
                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                        AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                        AdditionalBenefitsCopy.INSERT;
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT
                        InsureHeaderLoading_DiscountCopy.INIT;
                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                        InsureHeaderLoading_DiscountCopy.INSERT;



                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT
                        ReinslinesCopy.INIT;
                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        ReinslinesCopy."No." := InsureHeaderCopy."No.";
                        ReinslinesCopy.INSERT;

                    UNTIL Reinslines.NEXT = 0;


                PAGE.RUN(51513183, InsureHeaderCopy);
            END;
        END
        ELSE
            ERROR('Vehicle Registration No %1 is not on the database', VehicleRegNo);

    end;

    procedure CancelPolicyCoverRisk(var VehicleRegNo: Code[20]);
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        InsureHeader: Record "Insure Header";
        InsureLinesRec: Record "Insure Lines";
    begin

        InsureLinesRec.RESET;
        InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
        InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Live);
        InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", VehicleRegNo);
        IF InsureLinesRec.FINDLAST THEN BEGIN
            IF InsureHeader.GET(InsureLinesRec."Document Type", InsureLinesRec."Document No.") THEN BEGIN


                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
                EndorsementType.RESET;
                EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Cancellation);
                IF EndorsementType.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
                    InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
                END;
                InsureHeaderCopy."Policy No" := InsureHeader."No.";
                InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
                InsureHeaderCopy."Cover Start Date" := TODAY;
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Cover Start Date");
                InsureHeaderCopy."Document Date" := TODAY;
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Document Date");
                //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
                InsureHeaderCopy."No." := '';
                InsureHeaderCopy.INSERT(TRUE);

                //InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Document Date");

                /*InsureLines.RESET;
                InsureLines.SETRANGE(InsureLines."Document Type",InsureHeader."Document Type");
                InsureLines.SETRANGE(InsureLines."Document No.",InsureHeader."No.");
                InsureLines.SETRANGE(InsureLines.Selected,TRUE);
                IF InsureLines.FINDFIRST THEN
                REPEAT*/
                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLinesRec);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;
                //UNTIL InsureLines.NEXT=0;

                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT
                        AdditionalBenefitsCopy.INIT;
                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                        AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                        AdditionalBenefitsCopy.INSERT;
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT
                        InsureHeaderLoading_DiscountCopy.INIT;
                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                        InsureHeaderLoading_DiscountCopy.INSERT;



                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT
                        ReinslinesCopy.INIT;
                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        ReinslinesCopy."No." := InsureHeaderCopy."No.";
                        ReinslinesCopy.INSERT;

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.INIT;
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                        InstalmentLinesCopy.INSERT;
                    UNTIL InstalmentLines.NEXT = 0;

                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Policy Type");

                PAGE.RUN(51513183, InsureHeaderCopy);
            END;
        END
        ELSE
            ERROR('Vehicle Registration No %1 is not on the database', VehicleRegNo);

    end;

    procedure SuspendPolicyCoverRisk(var VehicleRegNo: Code[20]);
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        InsureLinesRec: Record "Insure Lines";
        InsureHeader: Record "Insure Header";
    begin
        InsureLinesRec.RESET;
        InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
        InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Live);
        InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", VehicleRegNo);
        IF InsureLinesRec.FINDLAST THEN BEGIN
            IF InsureHeader.GET(InsureLinesRec."Document Type", InsureLinesRec."Document No.") THEN BEGIN

                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
                EndorsementType.RESET;
                EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Suspension);
                IF EndorsementType.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
                    InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
                END;
                InsureHeaderCopy."Policy No" := InsureHeader."No.";
                InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
                //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
                InsureHeaderCopy."No." := '';
                InsureHeaderCopy."Cover Start Date" := TODAY;
                InsureHeaderCopy."No. Of Days" := (InsureHeader."Cover End Date" - TODAY) + 1;
                InsureHeaderCopy.INSERT(TRUE);



                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLinesRec);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;


                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT
                        AdditionalBenefitsCopy.INIT;
                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                        AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                        AdditionalBenefitsCopy.INSERT;
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT
                        InsureHeaderLoading_DiscountCopy.INIT;
                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                        InsureHeaderLoading_DiscountCopy.INSERT;



                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT
                        ReinslinesCopy.INIT;
                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        ReinslinesCopy."No." := InsureHeaderCopy."No.";
                        ReinslinesCopy.INSERT;

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.INIT;
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                        InstalmentLinesCopy.INSERT;
                    UNTIL InstalmentLines.NEXT = 0;
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Policy Type");
                PAGE.RUN(51513183, InsureHeaderCopy);
            END;
        END
        ELSE
            ERROR('Vehicle Registration No %1 is not on the database', VehicleRegNo);
    end;

    procedure ResumePolicyCoverRisk(var VehicleRegNo: Code[20]);
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        InsureLinesRec: Record "Insure Lines";
        InsureHeader: Record "Insure Header";
        CreditnoteLines: Record "Insure Credit Note Lines";
    begin

        InsureLinesRec.RESET;
        InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
        InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Cancelled);
        InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", VehicleRegNo);
        IF InsureLinesRec.FINDLAST THEN BEGIN
            IF InsureHeader.GET(InsureLinesRec."Document Type", InsureLinesRec."Document No.") THEN BEGIN



                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
                EndorsementType.RESET;
                EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Resumption);
                IF EndorsementType.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
                    InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
                END;
                //commented..test InsureHeaderCopy."Policy No":=InsureHeader."No.";
                //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
                CreditnoteLines.RESET;
                CreditnoteLines.SETRANGE(CreditnoteLines."Description Type", CreditnoteLines."Description Type"::"Schedule of Insured");
                CreditnoteLines.SETRANGE(CreditnoteLines."Registration No.", InsureLinesRec."Registration No.");
                IF CreditnoteLines.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Applies-to Doc. Type" := InsureHeaderCopy."Applies-to Doc. Type"::"Credit Memo";
                    InsureHeaderCopy."Applies-to Doc. No." := CreditnoteLines."Document No.";

                END;
                InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
                InsureHeaderCopy."Cover Start Date" := TODAY;
                InsureHeaderCopy."No." := '';
                InsureHeaderCopy.INSERT(TRUE);



                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLinesRec);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLinesRec."Line No.";
                InsureLinesCopy.INSERT;


                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT
                        AdditionalBenefitsCopy.INIT;
                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                        AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                        AdditionalBenefitsCopy.INSERT;
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT
                        InsureHeaderLoading_DiscountCopy.INIT;
                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                        InsureHeaderLoading_DiscountCopy.INSERT;



                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT
                        ReinslinesCopy.INIT;
                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        ReinslinesCopy."No." := InsureHeaderCopy."No.";
                        ReinslinesCopy.INSERT;

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.INIT;
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                        InstalmentLinesCopy.INSERT;
                    UNTIL InstalmentLines.NEXT = 0;
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Policy Type");
                PAGE.RUN(51513183, InsureHeaderCopy);
            END;
        END
        ELSE
            ERROR('Vehicle Registration No %1 is not on the database', VehicleRegNo);
    end;

    procedure SubstitutePolicyCoverRisk(var VehicleRegNo: Code[20]);
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        InsureLinesRec: Record "Insure Lines";
        InsureHeader: Record "Insure Header";
    begin

        InsureLinesRec.RESET;
        InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
        InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Live);
        InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", VehicleRegNo);
        IF InsureLinesRec.FINDLAST THEN BEGIN
            IF InsureHeader.GET(InsureLinesRec."Document Type", InsureLinesRec."Document No.") THEN BEGIN
                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
                EndorsementType.RESET;
                EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Substitution);
                IF EndorsementType.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
                    InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
                END;
                IF InsureHeaderCopy."Policy No" = '' THEN
                    InsureHeaderCopy."Policy No" := InsureHeader."No.";
                InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
                InsureHeaderCopy."Cover Start Date" := TODAY;
                //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
                InsureHeaderCopy."No." := '';
                InsureHeaderCopy.INSERT(TRUE);


                /*InsureLines.RESET;
                InsureLines.SETRANGE(InsureLines."Document Type",InsureHeader."Document Type");
                InsureLines.SETRANGE(InsureLines."Document No.",InsureHeader."No.");
                InsureLines.SETRANGE(InsureLines.Selected,TRUE);
                IF InsureLines.FINDFIRST THEN
                REPEAT
                   InsureLinesCopy.INIT;
                   InsureLinesCopy.COPY(InsureLines);
                   InsureLinesCopy."Document Type":=InsureHeaderCopy."Document Type";
                   InsureLinesCopy."Document No.":=InsureHeaderCopy."No.";
                   InsureLinesCopy."Policy No":=InsureHeader."No.";
                   InsureLinesCopy."Select Risk ID":=InsureLines."Line No.";
                   InsureLinesCopy.INSERT;
                UNTIL InsureLines.NEXT=0;*/

                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT
                        AdditionalBenefitsCopy.INIT;
                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                        AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                        AdditionalBenefitsCopy.INSERT;
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT
                        InsureHeaderLoading_DiscountCopy.INIT;
                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                        InsureHeaderLoading_DiscountCopy.INSERT;



                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT
                        ReinslinesCopy.INIT;
                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        ReinslinesCopy."No." := InsureHeaderCopy."No.";
                        ReinslinesCopy.INSERT;

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.INIT;
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                        InstalmentLinesCopy.INSERT;
                    UNTIL InstalmentLines.NEXT = 0;
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Policy Type");
                PAGE.RUN(51513183, InsureHeaderCopy);
            END;
        END
        ELSE
            ERROR('Vehicle Registration No %1 is not on the database', VehicleRegNo);

    end;

    procedure RevisePolicyCoverRisk(var VehicleRegNo: Code[20]);
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        InsureLinesRec: Record "Insure Lines";
        InsureHeader: Record "Insure Header";
    begin

        InsureLinesRec.RESET;
        InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
        InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Live);
        InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", VehicleRegNo);
        IF InsureLinesRec.FINDLAST THEN BEGIN
            IF InsureHeader.GET(InsureLinesRec."Document Type", InsureLinesRec."Document No.") THEN BEGIN


                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
                EndorsementType.RESET;
                EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Revision);
                IF EndorsementType.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
                    InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
                END;
                InsureHeaderCopy."Policy No" := InsureHeader."No.";
                InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
                //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
                InsureHeaderCopy."No." := '';
                InsureHeaderCopy.INSERT(TRUE);



                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLinesRec);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;


                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT
                        AdditionalBenefitsCopy.INIT;
                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                        AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                        AdditionalBenefitsCopy.INSERT;
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT
                        InsureHeaderLoading_DiscountCopy.INIT;
                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                        InsureHeaderLoading_DiscountCopy.INSERT;



                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT
                        ReinslinesCopy.INIT;
                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        ReinslinesCopy."No." := InsureHeaderCopy."No.";
                        ReinslinesCopy.INSERT;

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.INIT;
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                        InstalmentLinesCopy.INSERT;
                    UNTIL InstalmentLines.NEXT = 0;
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Policy Type");
                PAGE.RUN(51513183, InsureHeaderCopy);

            END;
        END
        ELSE
            ERROR('Vehicle Registration No %1 is not on the database', VehicleRegNo);
    end;

    procedure NilPolicyCoverRisk(var VehicleRegNo: Code[20]);
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        InsureLinesRec: Record "Insure Lines";
        InsureHeader: Record "Insure Header";
    begin

        InsureLinesRec.RESET;
        InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
        InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Live);
        InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", VehicleRegNo);
        IF InsureLinesRec.FINDLAST THEN BEGIN
            IF InsureHeader.GET(InsureLinesRec."Document Type", InsureLinesRec."Document No.") THEN BEGIN


                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
                EndorsementType.RESET;
                EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Nil);
                IF EndorsementType.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
                    InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
                END;
                InsureHeaderCopy."Policy No" := InsureHeader."No.";
                //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
                InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
                InsureHeaderCopy."No." := '';
                InsureHeaderCopy.INSERT(TRUE);



                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLinesRec);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;


                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT
                        AdditionalBenefitsCopy.INIT;
                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                        AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                        AdditionalBenefitsCopy.INSERT;
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT
                        InsureHeaderLoading_DiscountCopy.INIT;
                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                        InsureHeaderLoading_DiscountCopy.INSERT;



                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT
                        ReinslinesCopy.INIT;
                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        ReinslinesCopy."No." := InsureHeaderCopy."No.";
                        ReinslinesCopy.INSERT;

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.INIT;
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                        InstalmentLinesCopy.INSERT;
                    UNTIL InstalmentLines.NEXT = 0;
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Policy Type");
                PAGE.RUN(51513183, InsureHeaderCopy);

            END;
        END
        ELSE
            ERROR('Vehicle Registration No %1 is not on the database', VehicleRegNo);
    end;

    procedure RenewPolicyCoverRisk(var VehicleRegNo: Code[20]);
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        InsureLinesRec: Record "Insure Lines";
        InsureHeader: Record "Insure Header";
    begin

        /*IF NOT SelectAllRisksTest(InsureHeader) THEN
          ERROR('Please select the Risks to extend cover for on Policy %1',InsureHeader."No.");*/

        InsureLinesRec.RESET;
        InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
        InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Live);
        InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", VehicleRegNo);
        IF InsureLinesRec.FINDLAST THEN BEGIN
            IF InsureHeader.GET(InsureLinesRec."Document Type", InsureLinesRec."Document No.") THEN BEGIN


                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
                EndorsementType.RESET;
                EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::Renewal);
                IF EndorsementType.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
                    InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
                END;
                InsureHeaderCopy."Policy No" := InsureHeader."No.";
                //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
                InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Expected Renewal Date";
                InsureHeaderCopy."Cover Start Date" := InsureHeader."Expected Renewal Date";
                InsureHeaderCopy."Document Date" := InsureHeader."Expected Renewal Date";
                InsureHeaderCopy."From Date" := InsureHeader."Expected Renewal Date";
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."From Date");
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Cover Start Date");
                InsureHeaderCopy."No." := '';
                InsureHeaderCopy.INSERT(TRUE);



                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLinesRec);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;

                AdditionalBenefits.RESET;
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document Type", InsureHeader."Document Type");
                AdditionalBenefits.SETRANGE(AdditionalBenefits."Document No.", InsureHeader."No.");
                IF AdditionalBenefits.FINDFIRST THEN
                    REPEAT
                        AdditionalBenefitsCopy.INIT;
                        AdditionalBenefitsCopy.COPY(AdditionalBenefits);
                        AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                        AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                        AdditionalBenefitsCopy.INSERT;
                    UNTIL AdditionalBenefits.NEXT = 0;

                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT
                        InsureHeaderLoading_DiscountCopy.INIT;
                        InsureHeaderLoading_DiscountCopy.COPY(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                        InsureHeaderLoading_DiscountCopy.INSERT;



                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT
                        ReinslinesCopy.INIT;
                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        ReinslinesCopy."No." := InsureHeaderCopy."No.";
                        ReinslinesCopy.INSERT;

                    UNTIL Reinslines.NEXT = 0;

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.INIT;
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                        InstalmentLinesCopy.INSERT;
                    UNTIL InstalmentLines.NEXT = 0;
                InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Policy Type");
                PAGE.RUN(51513183, InsureHeaderCopy);
            END;
        END
        ELSE
            ERROR('Vehicle Registration No %1 is not on the database', VehicleRegNo);

    end;

    procedure CreateClassInstalmentRatio(var PolicyINstal: Record "Policy Instalments");
    var
        InstalmentRatio: Record "Instalment Ratio";
        i: Integer;
    begin
        InstalmentRatio.RESET;
        InstalmentRatio.SETRANGE(InstalmentRatio."Policy Type", PolicyINstal."Policy Type");
        InstalmentRatio.SETRANGE(InstalmentRatio."No. Of Instalments", PolicyINstal."No. Of Instalments");
        InstalmentRatio.DELETEALL;

        FOR i := 1 TO PolicyINstal."No. Of Instalments" DO BEGIN
            InstalmentRatio.INIT;
            InstalmentRatio."Policy Type" := PolicyINstal."Policy Type";
            InstalmentRatio."No. Of Instalments" := PolicyINstal."No. Of Instalments";
            InstalmentRatio."Instalment No" := i;
            InstalmentRatio.INSERT;

        END;
    end;

    procedure DrawPaymentScheduleComp(var PolicyHeader: Record "Insure Header");
    var
        PaymentSchedule: Record "Instalment Payment Plan";
        TotalPremium: Decimal;
        PolicyLines: Record "Insure Lines";
        StartDate: Date;
        i: Integer;
        PaymentTerms: Record "No. of Instalments";
        InstalmentRatioRec: Record "Instalment Ratio";
    begin
        //MESSAGE('Running comprehensive');
        WITH PolicyHeader DO BEGIN
            CALCFIELDS("Total Comprehensive Premium", "Total TPO Premium", "Total PLL Premium", "Total Extra Premium", "Total Tax");
            IF "From Date" <> 0D THEN BEGIN  //Read from Instalment Percentage setups
                PaymentSchedule.RESET;
                PaymentSchedule.SETRANGE(PaymentSchedule."Document Type", "Document Type");
                PaymentSchedule.SETRANGE(PaymentSchedule."Document No.", "No.");
                PaymentSchedule.DELETEALL;

                InstalmentRatioRec.RESET;
                InstalmentRatioRec.SETRANGE(InstalmentRatioRec."Policy Type", "Policy Type");
                InstalmentRatioRec.SETRANGE(InstalmentRatioRec."No. Of Instalments", "No. Of Instalments");
                IF InstalmentRatioRec.FINDFIRST THEN BEGIN
                    StartDate := "From Date";
                    REPEAT
                        PaymentSchedule.INIT;
                        PaymentSchedule."Document Type" := "Document Type";
                        PaymentSchedule."Document No." := "No.";
                        PaymentSchedule."Payment No" := InstalmentRatioRec."Instalment No";
                        PaymentSchedule."Due Date" := StartDate;
                        PaymentSchedule."Cover Start Date" := PaymentSchedule."Due Date";
                        PaymentSchedule."Period Length" := InstalmentRatioRec."Period Length";
                        PaymentSchedule."Cover End Date" := CALCDATE(PaymentSchedule."Period Length", PaymentSchedule."Cover Start Date") - 1;
                        StartDate := CALCDATE(InstalmentRatioRec."Period Length", StartDate);
                        PaymentSchedule."Instalment Percentage" := InstalmentRatioRec.Percentage;
                        PaymentSchedule."Amount Due" := (PaymentSchedule."Instalment Percentage" / 100) * ("Total Comprehensive Premium" + "Total TPO Premium" + "Total PLL Premium" + "Total Extra Premium" + "Total Tax");
                        PaymentSchedule.INSERT;
                    UNTIL InstalmentRatioRec.NEXT = 0;
                END;
            END;
        END;
    end;

    procedure CancelCert(var CertificatePrinting: Record "Certificate Printing");
    var
        CertCopy: Record "Certificate Printing";
        CertCopy2: Record "Certificate Printing";
    begin
        IF CertificatePrinting."cancellation Reason" = '' THEN
            ERROR('Please select certificate cancellation reason for Reg. no %1', CertificatePrinting."Registration No.");
        CertificatePrinting."Certificate Status" := CertificatePrinting."Certificate Status"::Cancelled;

        CertificatePrinting."Cancellation Date" := TODAY;

        CertificatePrinting.MODIFY;
        MESSAGE('Certificate has been cancelled Please do an endorsement to re-print');

        /*CertCopy2.RESET;
        CertCopy2.SETRANGE(CertCopy2."Document Type",CertificatePrinting."Document Type");
        CertCopy2.SETRANGE(CertCopy2."Document No.",CertificatePrinting."Document No.");
        CertCopy2.SETRANGE(CertCopy2."Registration No.",CertificatePrinting."Registration No.");
        IF CertCopy2.FINDLAST THEN
          BEGIN
            CertCopy.INIT;
            CertCopy.COPY(CertificatePrinting);
            CertCopy."Line No.":=CertCopy2."Line No."+10000;
            CertCopy."Certificate No.":='';
            CertCopy.Printed:=FALSE;
            CertCopy."Print Time":=0T;
            CertCopy."Printed By":='';
            CertCopy.INSERT;
            CertificatePrinting."Certificate Status":=CertificatePrinting."Certificate Status"::Cancelled;
            CertificatePrinting.MODIFY;
            MESSAGE('Certificate has been cancelled and is available for re-printing');
          END;*/

    end;

    procedure GetTreatyPremiumNew(var InsureHeader: Record "Insure Header");
    var
        Treaty: Record Treaty;
        Class: Record "Insurance Class";
        PolicyType: Record "Policy Type";
        TreatyReinsuranceShare: Record "Treaty Reinsurance Share";
        InsLines: Record "Insure Lines";
        LineNo: Integer;
        InsuranceSetup: Record "Insurance setup";
        ReinsLines: Record "Coinsurance Reinsurance Lines";
        GenJnlLine: Record "Gen. Journal Line";
        CedingCommission: Decimal;
        Whtx: Decimal;
        ShareNotCoveredAmt: Decimal;
        ShareNotCoveredPercent: Decimal;
        SharecoveredPercent: Decimal;
        AUC: Decimal;
    begin
        InsureHeader.CALCFIELDS("Total Premium Amount", "Total Net Premium", "Total Sum Insured");
        //Check if Total Premium Exceeds The Treaty Limits
        //Get the treaty details

        Treaty.RESET;
        Treaty.SETRANGE(Treaty."Class of Insurance", InsureHeader."Policy Type");
        Treaty.SETRANGE(Treaty."Treaty Status", Treaty."Treaty Status"::Accepted);
        IF Treaty.FINDLAST THEN BEGIN   //Treaty


            //Confirm Effective date
            IF (InsureHeader."From Date" <= Treaty."Expiry Date") AND (InsureHeader."From Date" >= Treaty."Effective date") THEN BEGIN   //treaty range

                CedingCommission := 0;
                //Check whether proportional or non proportional

                //MESSAGE('within the date limits Treaty found');

                IF Treaty."Apportionment Type" = Treaty."Apportionment Type"::Proportional
                  THEN BEGIN
                    IF Treaty."Quota Share" = TRUE AND Treaty.Surplus = FALSE THEN BEGIN
                        IF InsureHeader."Total Sum Insured" > Treaty."Treaty Capacity" THEN BEGIN //Sum Insured greater than Treaty capacity
                            ShareNotCoveredAmt := InsureHeader."Total Sum Insured" - Treaty."Treaty Capacity";
                            IF InsureHeader."Total Sum Insured" <> 0 THEN
                                ShareNotCoveredPercent := (ShareNotCoveredAmt / InsureHeader."Total Sum Insured") * 100;
                            SharecoveredPercent := 100 - ShareNotCoveredPercent;
                            LineNo := LineNo + 1000;
                            ReinsLines.INIT;
                            ReinsLines."Document Type" := InsureHeader."Document Type";
                            ReinsLines."No." := InsureHeader."No.";
                            //ReinsLines."Line No.":=LineNo;
                            //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                            // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                            ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                            ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                            ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                            ReinsLines.VALIDATE(ReinsLines."Partner No.");
                            //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";

                            ReinsLines.Premium := (100 - Treaty."Cedant quota percentage") / 100 * SharecoveredPercent * InsureHeader."Total Premium Amount";



                            CedingCommission := ReinsLines.Premium * (Treaty."Broker Commision" / 100);
                            ReinsLines."Cedant Commission" := CedingCommission;
                            ReinsLines."Quota Share" := TRUE;
                            //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                            //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                            //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                            //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                            IF ReinsLines.Premium <> 0 THEN
                                ReinsLines.INSERT(TRUE);



                        END; //Sum Insured greater than Treaty capacity

                        IF InsureHeader."Total Sum Insured" <= Treaty."Treaty Capacity" THEN BEGIN //Sum Insured greater than Treaty capacity
                                                                                                   //ShareNotCoveredAmt:=InsureHeader."Total Sum insured"-Treaty."Treaty Capacity";
                                                                                                   //IF InsureHeader."Total Sum insured"<>0 THEN
                                                                                                   //ShareNotCoveredPercent:=(ShareNotCoveredAmt/InsureHeader."Total Sum insured")*100;
                                                                                                   // SharecoveredPercent:=100-ShareNotCoveredPercent;
                            LineNo := LineNo + 1000;
                            ReinsLines.INIT;
                            ReinsLines."Document Type" := InsureHeader."Document Type";
                            ReinsLines."No." := InsureHeader."No.";
                            //ReinsLines."Line No.":=LineNo;
                            //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                            // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                            ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                            ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                            ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                            ReinsLines.VALIDATE(ReinsLines."Partner No.");
                            //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                            ReinsLines."Quota Share" := TRUE;

                            ReinsLines.Premium := (100 - Treaty."Cedant quota percentage") / 100 * InsureHeader."Total Premium Amount";



                            CedingCommission := ReinsLines.Premium * (Treaty."Broker Commision" / 100);
                            ReinsLines."Cedant Commission" := CedingCommission;
                            //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                            //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                            //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                            //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                            IF ReinsLines.Premium <> 0 THEN
                                ReinsLines.INSERT(TRUE);



                        END; //Sum Insured greater than Treaty capacity

                    END; //Quota share

                    IF Treaty."Quota Share" = FALSE AND Treaty.Surplus = TRUE THEN BEGIN //Pure surplus

                        AUC := Treaty."Net Retained Line" + (Treaty."No. of Lines" * Treaty."Net Retained Line");
                        IF InsureHeader."Total Sum Insured" <= AUC THEN BEGIN


                            ReinsLines.INIT;
                            ReinsLines."Document Type" := InsureHeader."Document Type";
                            ReinsLines."No." := InsureHeader."No.";
                            //ReinsLines."Line No.":=LineNo;
                            //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                            // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                            ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                            ReinsLines."Account No." := Treaty."Lead Reinsurer";
                            ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                            ReinsLines.VALIDATE(ReinsLines."Partner No.");
                            //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                            IF InsureHeader."Total Sum Insured" <> 0 THEN
                                ReinsLines.Premium := ((InsureHeader."Total Sum Insured" - Treaty."Net Retained Line") / InsureHeader."Total Sum Insured") * InsureHeader."Total Premium Amount";



                            CedingCommission := ReinsLines.Premium * (Treaty."Broker Commision" / 100);
                            ReinsLines."Cedant Commission" := CedingCommission;
                            ReinsLines.Surplus := TRUE;
                            //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                            //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                            //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                            //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                            IF ReinsLines.Premium <> 0 THEN
                                ReinsLines.INSERT(TRUE);


                        END;//Automatic Underwriting limit greater than sum insured...

                        IF InsureHeader."Total Sum Insured" > AUC THEN BEGIN


                            ReinsLines.INIT;
                            ReinsLines."Document Type" := InsureHeader."Document Type";
                            ReinsLines."No." := InsureHeader."No.";
                            //ReinsLines."Line No.":=LineNo;
                            //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                            // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                            ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                            ReinsLines."Account No." := Treaty."Lead Reinsurer";
                            ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                            ReinsLines.VALIDATE(ReinsLines."Partner No.");
                            //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                            IF InsureHeader."Total Sum Insured" <> 0 THEN
                                ReinsLines.Premium := ((AUC - Treaty."Net Retained Line") / InsureHeader."Total Sum Insured") * InsureHeader."Total Premium Amount";



                            CedingCommission := ReinsLines.Premium * (Treaty."Broker Commision" / 100);
                            ReinsLines."Cedant Commission" := CedingCommission;
                            ReinsLines.Surplus := TRUE;
                            //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                            //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                            //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                            //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                            IF ReinsLines.Premium <> 0 THEN
                                ReinsLines.INSERT(TRUE);


                        END;//Automatic Underwriting limit less than sum insured...




                    END; //Pure surplus

                END;



                /*IF Treaty."Apportionment Type"=Treaty."Apportionment Type"::"Non-proportional"
                THEN BEGIN


                   IF Rec."Total Sum Insured">Treaty."Surplus Retention" THEN BEGIN
                    InsLines.RESET;
                    InsLines.SETRANGE(InsLines."Document Type",Rec."Document Type");
                    InsLines.SETRANGE(InsLines."Document No.",Rec."No.");
                     IF InsLines.FINDLAST THEN BEGIN
                        LineNo:=InsLines."Line No.";
                     END;

                    InsLines.RESET;
                    InsLines.SETRANGE(InsLines."Document Type",Rec."Document Type");
                    InsLines.SETRANGE(InsLines."Document No.",Rec."No.");
                    InsLines.SETRANGE(InsLines."Description Type",InsLines."Description Type"::"Schedule of Insured");
                    InsLines.SETFILTER(InsLines."Gross Premium",'<>%1',0);
                    IF InsLines.FINDFIRST THEN BEGIN
                      // REPEAT
                       //Modify gross premium for insurance firm
                      { IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                       InsLines."Gross Premium":=(Treaty."Limit Of Indemnity"*InsLines."Rate %age"/100)
                       ELSE
                       InsLines."Gross Premium":=(Treaty."Limit Of Indemnity"*InsLines."Rate %age"/1000);
                       InsLines.VALIDATE("Gross Premium");
                       InsLines.MODIFY(TRUE);}
                       //MESSAGE('Non proportional treaty Sum Insured=%1 and Retention=%2 Premium=%3',Rec."Total Sum Insured", Treaty."Surplus Retention",Rec."Total Premium Amount");
                       //Insert entries for reinsurance firms
                       LineNo:=LineNo+1000;
                       ReinsLines.INIT;
                       ReinsLines."Document Type":=Rec."Document Type";
                       ReinsLines."No.":=Rec."No.";
                       //ReinsLines."Line No.":=LineNo;
                       //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                      // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                       ReinsLines."Transaction Type":=ReinsLines."Transaction Type"::"Re-insurance ";
                       ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                       ReinsLines."Partner No.":=TreatyReinsuranceShare."Re-insurer code";
                       ReinsLines.VALIDATE(ReinsLines."Partner No.");
                       //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";

                       ReinsLines.Premium:=(((Rec."Total Sum Insured"-Treaty."Surplus Retention")/Rec."Total Sum Insured")*Rec."Total Premium Amount"
                                          *(TreatyReinsuranceShare."Percentage %"/100));


                       CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                       ReinsLines."Cedant Commission":=CedingCommission;
                       //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                       //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                       //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                       //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                       IF ReinsLines.Premium<>0 THEN
                       ReinsLines.INSERT(TRUE);

                       END;
                       END;
                       END ELSE BEGIN
                       // MESSAGE(' proportional treaty');
                       IF TreatyReinsuranceShare."Quota Share" THEN
                         IF Rec."Total Sum Insured"<= Treaty."Quota share Retention" THEN BEGIN
                          InsLines.RESET;
                          InsLines.SETRANGE(InsLines."Document Type",Rec."Document Type");
                          InsLines.SETRANGE(InsLines."Document No.",Rec."No.");
                          InsLines.SETRANGE(InsLines."Description Type",InsLines."Description Type"::"Schedule of Insured");
                          InsLines.SETFILTER(InsLines."Gross Premium",'<>%1',0);
                          IF InsLines.FINDFIRST THEN BEGIN
                             //REPEAT
                             {//Modify gross premium for insurance firm
                             InsLines."Gross Premium":=(InsLines."Gross Premium"*Treaty."Cedant quota percentage"/100);
                             InsLines.VALIDATE("Gross Premium");
                             IF Treaty."Cedant quota percentage"/100=(InsLines."Gross Premium"/Rec."Total Premium Amount")THEN
                             InsLines.MODIFY(TRUE);}

                              //Insert entries for reinsurance firms
                              LineNo:=LineNo+1000;
                              ReinsLines.INIT;
                              ReinsLines."Document Type":=Rec."Document Type";
                              ReinsLines."No.":=Rec."No.";
                              //ReinsLines."Line No.":=LineNo;
                              //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                              //ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                              ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                              ReinsLines."Partner No.":=TreatyReinsuranceShare."Re-insurer code";
                              ReinsLines.VALIDATE(ReinsLines."Partner No.");
                              //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                              ReinsLines.Premium:=(Rec."Total Premium Amount"*(TreatyReinsuranceShare."Percentage %"/100));
                              //ReinsLines.VALIDATE(ReinsLines.Amount);
                              CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                              ReinsLines."Cedant Commission":=CedingCommission;
                              //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                              //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                              //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                              //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                              IF ReinsLines.Premium<>0 THEN
                                 ReinsLines.INSERT(TRUE);
                               END;
                               END




                             ELSE
                              IF Rec."Total Sum Insured">Treaty."Quota share Retention" THEN
                              BEGIN
                              InsLines.RESET;
                              InsLines.SETRANGE(InsLines."Document Type",Rec."Document Type");
                              InsLines.SETRANGE(InsLines."Document No.",Rec."No.");
                              InsLines.SETRANGE(InsLines."Description Type",InsLines."Description Type"::"Schedule of Insured");
                              InsLines.SETFILTER(InsLines."Gross Premium",'<>%1',0);
                              IF InsLines.FINDFIRST THEN BEGIN
                               // REPEAT
                                { //Modify gross premium for insurance firm
                                 IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                 InsLines."Gross Premium":=((Treaty."Quota share Retention"*InsLines."Rate %age"/100)
                                 *Treaty."Cedant quota percentage"/100)
                                 ELSE
                                 InsLines."Gross Premium":=((Treaty."Quota share Retention"*InsLines."Rate %age"/1000)
                                 *Treaty."Cedant quota percentage"/100);
                                 InsLines.VALIDATE("Gross Premium");
                                 InsLines.MODIFY(TRUE);}
                                //Insert entries for reinsurance firms
                                LineNo:=LineNo+1000;
                                ReinsLines.INIT;
                                ReinsLines."Document Type":=Rec."Document Type";
                                ReinsLines."No.":=Rec."No.";
                                //ReinsLines."Line No.":=LineNo;
                                //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                               // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                                ReinsLines."Partner No.":=TreatyReinsuranceShare."Re-insurer code";
                                ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                ReinsLines.Premium:=((Treaty."Quota share Retention"*InsLines."Rate %age"/100)
                                *(TreatyReinsuranceShare."Percentage %"/100))
                                ELSE
                                ReinsLines.Premium:=((Treaty."Quota share Retention"*InsLines."Rate %age"/1000)
                                *(TreatyReinsuranceShare."Percentage %"/100));

                                CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                IF ReinsLines.Amount<>0 THEN
                                ReinsLines.INSERT(TRUE);
                                END;

                                IF Treaty.Surplus THEN BEGIN
                                //Insert entries for reinsurance firms
                                LineNo:=LineNo+1000;
                                ReinsLines.INIT;
                                ReinsLines."Document Type":=Rec."Document Type";
                                ReinsLines."No.":=Rec."No.";
                                //ReinsLines."Line No.":=LineNo;
                                //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                                ReinsLines."Partner No.":=TreatyReinsuranceShare."Re-insurer code";
                                ReinsLines.VALIDATE(ReinsLines."Partner No.");
                               // ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";


                                IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                ReinsLines.Premium:=(((Rec."Total Sum Insured"-
                                Treaty."Quota share Retention")*InsLines."Rate %age"/100)
                                *(TreatyReinsuranceShare."Percentage %"/100))
                                ELSE
                                ReinsLines.Premium:=(((Rec."Total Sum Insured"-
                                Treaty."Quota share Retention")*InsLines."Rate %age"/100)
                                *(TreatyReinsuranceShare."Percentage %"/100));
                                ReinsLines.VALIDATE(ReinsLines.Amount);
                                CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                ReinsLines."Cedant Commission":=CedingCommission;
                                //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                IF ReinsLines.Premium<>0 THEN
                                ReinsLines.INSERT(TRUE);
                                END;
                                IF Rec."Total Sum Insured">Treaty."Surplus Retention" THEN
                                   IF Treaty.Facultative THEN BEGIN
                                //Insert entries for reinsurance firms
                                LineNo:=LineNo+1000;
                                ReinsLines.INIT;
                                ReinsLines."Document Type":=Rec."Document Type";
                                ReinsLines."No.":=Rec."No.";
                               // ReinsLines."Line No.":=LineNo;
                                //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                ReinsLines."Account No.":=TreatyReinsuranceShare."Re-insurer code";
                                ReinsLines."Partner No.":=TreatyReinsuranceShare."Re-insurer code";
                                ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                IF InsLines."Rate Type"=InsLines."Rate Type"::"Per Cent" THEN
                                ReinsLines.Premium:=(((Rec."Total Sum Insured"-
                                Treaty."Surplus Retention")*InsLines."Rate %age"/100)
                                *(TreatyReinsuranceShare."Percentage %"/100))
                                ELSE
                                ReinsLines.Premium:=(((Rec."Total Sum Insured"-
                                Treaty."Surplus Retention")*InsLines."Rate %age"/100)
                                *(TreatyReinsuranceShare."Percentage %"/100));

                                CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                ReinsLines."Cedant Commission":=CedingCommission;
                                //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                IF ReinsLines.Premium<>0 THEN
                                ReinsLines.INSERT(TRUE);
                                END;












                            END;
                           END;
                                UNTIL
                                TreatyReinsuranceShare.NEXT=0;

                          END;*/
            END;
        END;

    end;

    procedure CreateReservationReinsEntries(var ClaimReserve: Record "Claim Reservation Header");
    var
        Treaty: Record Treaty;
        Class: Record "Insurance Class";
        PolicyType: Record "Policy Type";
        TreatyReinsuranceShare: Record "Treaty Reinsurance Share";
        InsLines: Record "Insure Lines";
        LineNo: Integer;
        InsuranceSetup: Record "Insurance setup";
        ReinsLines: Record "Coinsurance Reinsurance Lines";
        GenJnlLine: Record "Gen. Journal Line";
        CedingCommission: Decimal;
        Whtx: Decimal;
        ShareNotCoveredAmt: Decimal;
        ShareNotCoveredPercent: Decimal;
        SharecoveredPercent: Decimal;
        AUC: Decimal;
        ClaimRec: Record Claim;
        InsureHeader: Record "Insure Header";
        XOLLayers: Record "XOL Layers";
        XOLBalance: Decimal;
        ReinsuranceShareLines: Record "Treaty Reinsurance Share";
        ClaimRecoverableLine: Decimal;
        LayerNo: Integer;
        EndBracket: Boolean;
    begin
        ClaimReserve.CALCFIELDS(ClaimReserve."Reserve Amount");
        IF PolicyType.GET(ClaimReserve."Insurance Class") THEN
            IF Treaty.GET(PolicyType."Treaty Code", PolicyType."Addendum No.") THEN
                 //Check if Total Premium Exceeds The Treaty Limits
                 //Get the treaty details
                 //MESSAGE('Class=%1',ClaimReserve."Insurance Class");
                 // Treaty.RESET;
                 //  Treaty.SETRANGE(Treaty."Class of Insurance",ClaimReserve."Insurance Class");
                 // Treaty.SETRANGE(Treaty."Treaty Status",Treaty."Treaty Status"::Accepted);
                 // IF Treaty.FINDLAST THEN
                 BEGIN   //Treaty
                         //MESSAGE('Treaty=%1',Treaty."Treaty description");
                         //FindPolicy;
                IF ClaimRec.GET(ClaimReserve."Claim No.") THEN
                    InsureHeader.RESET;
                InsureHeader.SETRANGE(InsureHeader."Document Type", InsureHeader."Document Type"::Policy);
                InsureHeader.SETRANGE(InsureHeader."No.", ClaimRec."Policy No");
                IF InsureHeader.FINDLAST THEN
                    //Confirm Effective date
                    // MESSAGE('%1..%2',InsureHeader."From Date",InsureHeader."To Date");
                    IF (InsureHeader."From Date" <= Treaty."Expiry Date") AND (InsureHeader."From Date" >= Treaty."Effective date") THEN BEGIN   //treaty range

                        CedingCommission := 0;
                        //Check whether proportional or non proportional

                        // MESSAGE('within the date limits Treaty found');

                        IF Treaty."Apportionment Type" = Treaty."Apportionment Type"::Proportional
                          THEN BEGIN
                            IF Treaty."Quota Share" = TRUE AND Treaty.Surplus = FALSE THEN BEGIN
                                IF InsureHeader."Total Sum Insured" > Treaty."Treaty Capacity" THEN BEGIN //Sum Insured greater than Treaty capacity
                                    ShareNotCoveredAmt := InsureHeader."Total Sum Insured" - Treaty."Treaty Capacity";
                                    IF InsureHeader."Total Sum Insured" <> 0 THEN
                                        ShareNotCoveredPercent := (ShareNotCoveredAmt / InsureHeader."Total Sum Insured") * 100;
                                    SharecoveredPercent := 100 - ShareNotCoveredPercent;
                                    LineNo := LineNo + 1000;
                                    ReinsLines.INIT;
                                    ReinsLines."Document Type" := ReinsLines."Document Type"::"Claim Reserves";
                                    ReinsLines."No." := ClaimReserve."No.";
                                    //ReinsLines."Line No.":=LineNo;
                                    //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                    // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                    ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                    ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                                    ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                                    ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                    //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";

                                    ReinsLines."Claim Reserve Amount" := (100 - Treaty."Cedant quota percentage") / 100 * SharecoveredPercent * ClaimReserve."Reserve Amount";
                                    ReinsLines."Quota Share" := TRUE;
                                    ReinsLines."Claim No." := ClaimReserve."Claim No.";
                                    ReinsLines."Claimant ID" := ClaimReserve."Claimant ID";
                                    IF ReinsLines."Claim Reserve Amount" <> 0 THEN
                                        ReinsLines.INSERT(TRUE);



                                END; //Sum Insured greater than Treaty capacity

                                IF InsureHeader."Total Sum Insured" <= Treaty."Treaty Capacity" THEN BEGIN //Sum Insured greater than Treaty capacity
                                                                                                           //ShareNotCoveredAmt:=InsureHeader."Total Sum insured"-Treaty."Treaty Capacity";
                                                                                                           //IF InsureHeader."Total Sum insured"<>0 THEN
                                                                                                           //ShareNotCoveredPercent:=(ShareNotCoveredAmt/InsureHeader."Total Sum insured")*100;
                                                                                                           // SharecoveredPercent:=100-ShareNotCoveredPercent;
                                    LineNo := LineNo + 1000;
                                    ReinsLines.INIT;
                                    ReinsLines."Document Type" := ReinsLines."Document Type"::"Claim Reserves";
                                    ReinsLines."No." := ClaimReserve."No.";
                                    //ReinsLines."Line No.":=LineNo;
                                    //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                    // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                    ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                    ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                                    ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                                    ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                    //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                    ReinsLines."Quota Share" := TRUE;

                                    ReinsLines."Claim Reserve Amount" := (100 - Treaty."Cedant quota percentage") / 100 * ClaimReserve."Reserve Amount";
                                    //CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                    //ReinsLines."Cedant Commission":=CedingCommission;
                                    ReinsLines."Claim No." := ClaimReserve."Claim No.";
                                    ReinsLines."Claimant ID" := ClaimReserve."Claimant ID";
                                    IF ReinsLines."Claim Reserve Amount" <> 0 THEN
                                        ReinsLines.INSERT(TRUE);



                                END; //Sum Insured greater than Treaty capacity

                            END; //Quota share

                            IF Treaty."Quota Share" = FALSE AND Treaty.Surplus = TRUE THEN BEGIN //Pure surplus

                                AUC := Treaty."Net Retained Line" + (Treaty."No. of Lines" * Treaty."Net Retained Line");
                                IF InsureHeader."Total Sum Insured" <= AUC THEN BEGIN


                                    ReinsLines.INIT;
                                    ReinsLines."Document Type" := ReinsLines."Document Type"::"Claim Reserves";
                                    ReinsLines."No." := ClaimReserve."No.";
                                    //ReinsLines."Line No.":=LineNo;
                                    //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                    // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                    ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                    ReinsLines."Account No." := Treaty."Lead Reinsurer";
                                    ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                                    ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                    //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                    IF InsureHeader."Total Sum Insured" <> 0 THEN
                                        ReinsLines."Claim Reserve Amount" := ((InsureHeader."Total Sum Insured" - Treaty."Net Retained Line") / InsureHeader."Total Sum Insured") * ClaimReserve."Reserve Amount";



                                    //CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                    //ReinsLines."Cedant Commission":=CedingCommission;
                                    ReinsLines.Surplus := TRUE;
                                    //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                    //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                    //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                    //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                    ReinsLines."Claim No." := ClaimReserve."Claim No.";
                                    ReinsLines."Claimant ID" := ClaimReserve."Claimant ID";
                                    IF ReinsLines."Claim Reserve Amount" <> 0 THEN
                                        ReinsLines.INSERT(TRUE);


                                END;//Automatic Underwriting limit greater than sum insured...

                                IF InsureHeader."Total Sum Insured" > AUC THEN BEGIN


                                    ReinsLines.INIT;

                                    ReinsLines."Document Type" := ReinsLines."Document Type"::"Claim Reserves";
                                    ReinsLines."No." := ClaimReserve."No.";
                                    //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                    // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                    ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                    ReinsLines."Account No." := Treaty."Lead Reinsurer";
                                    ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                                    ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                    //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                    IF InsureHeader."Total Sum Insured" <> 0 THEN
                                        ReinsLines."Claim Reserve Amount" := ((AUC - Treaty."Net Retained Line") / InsureHeader."Total Sum Insured") * ClaimReserve."Reserve Amount";



                                    //CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                    // ReinsLines."Cedant Commission":=CedingCommission;
                                    ReinsLines.Surplus := TRUE;
                                    //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                    //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                    //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                    //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                    IF ReinsLines."Claim Reserve Amount" <> 0 THEN
                                        ReinsLines.INSERT(TRUE);


                                END;//Automatic Underwriting limit less than sum insured...




                            END; //Pure surplus

                        END;//Proportional
                        IF Treaty."Apportionment Type" = Treaty."Apportionment Type"::"Non-proportional" THEN BEGIN //Non Proportional
                                                                                                                    //MESSAGE('exess of loss');
                            IF Treaty."Exess of loss" = TRUE THEN BEGIN
                                ClaimRec.CALCFIELDS(ClaimRec."Reserve Amount", ClaimRec."ClaimReserve Amt");
                                IF ClaimReserve."Revised Reserve Link" = '' THEN
                                    XOLBalance := ClaimReserve."Reserve Amount" + ClaimRec."ClaimReserve Amt"
                                ELSE
                                    XOLBalance := ClaimReserve."Reserve Amount";
                                //MESSAGE('XOL Balance=%1',XOLBalance);
                                LayerNo := 0;
                                XOLLayers.RESET;
                                XOLLayers.SETRANGE(XOLLayers."Treaty Code", Treaty."Treaty Code");
                                XOLLayers.SETRANGE(XOLLayers."Addendum Code", Treaty."Addendum Code");
                                IF XOLLayers.FINDFIRST THEN
                                    REPEAT
                                        ClaimRecoverableLine := 0;
                                        LayerNo := LayerNo + 1;
                                        //IF XOLBalance>0 THEN
                                        // BEGIN
                                        // MESSAGE('Balance =%1 at Round =%2',XOLBalance,XOLLayers.Layer);
                                        IF XOLBalance <= XOLLayers."Line Total" THEN BEGIN
                                            EndBracket := TRUE;

                                            IF XOLBalance > XOLLayers.Deductible THEN
                                                ClaimRecoverableLine := XOLBalance - XOLLayers.Deductible

                                            ELSE
                                                ClaimRecoverableLine := 0;

                                            // MESSAGE('Layer=%1 and XOLbalance=%2',LayerNo,XOLBalance);


                                        END
                                        ELSE BEGIN

                                            ClaimRecoverableLine := XOLLayers.Cover;

                                            //  XOLBalance:=XOLBalance-XOLLayers."Line Total";
                                            //  MESSAGE('XOLBalance after=%1',XOLBalance,XOLLayers.Layer);
                                        END;
                                        //END;
                                        // MESSAGE('Claim recoverable=%1 Layer=%2',ClaimRecoverableLine,XOLLayers.Layer);
                                        ReinsuranceShareLines.RESET;
                                        ReinsuranceShareLines.SETRANGE(ReinsuranceShareLines."Treaty Code", XOLLayers."Treaty Code");
                                        ReinsuranceShareLines.SETRANGE(ReinsuranceShareLines."Addendum Code", XOLLayers."Addendum Code");
                                        IF ReinsuranceShareLines.FINDFIRST THEN
                                            REPEAT

                                                //CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                                // ReinsLines."Cedant Commission":=CedingCommission;
                                                ReinsLines.INIT;
                                                ReinsLines."Document Type" := ReinsLines."Document Type"::"Claim Reserves";
                                                ReinsLines."No." := ClaimReserve."No.";
                                                ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                                ReinsLines."Account No." := Treaty.Broker;
                                                ReinsLines."Partner No." := ReinsuranceShareLines."Re-insurer code";
                                                ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                                ReinsLines."Excess Of Loss" := TRUE;
                                                ReinsLines.TreatyLineID := XOLLayers.Layer;
                                                ReinsLines."Claim Reserve Amount" := ClaimRecoverableLine * (ReinsuranceShareLines."Percentage %" / 100);
                                                //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                                //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                                //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                                //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                                ReinsLines."Claim No." := ClaimReserve."Claim No.";
                                                ReinsLines."Claimant ID" := ClaimReserve."Claimant ID";
                                                IF ReinsLines."Claim Reserve Amount" <> 0 THEN
                                                    ReinsLines.INSERT(TRUE);

                                            UNTIL ReinsuranceShareLines.NEXT = 0;

                                    UNTIL ((XOLLayers.NEXT = 0) OR (EndBracket = TRUE));






                            END;

                        END //Non Proportional
                    END;
            END;
    end;

    procedure CreatePVReinsEntries(var PV: Record Payments1);
    var
        Treaty: Record Treaty;
        Class: Record "Insurance Class";
        PolicyType: Record "Policy Type";
        TreatyReinsuranceShare: Record "Treaty Reinsurance Share";
        InsLines: Record "Insure Lines";
        LineNo: Integer;
        InsuranceSetup: Record "Insurance setup";
        ReinsLines: Record "Coinsurance Reinsurance Lines";
        GenJnlLine: Record "Gen. Journal Line";
        CedingCommission: Decimal;
        Whtx: Decimal;
        ShareNotCoveredAmt: Decimal;
        ShareNotCoveredPercent: Decimal;
        SharecoveredPercent: Decimal;
        AUC: Decimal;
        ClaimRec: Record Claim;
        InsureHeader: Record "Insure Header";
        XOLLayers: Record "XOL Layers";
        PVLines: Record "PV Lines1";
        XOLBalance: Decimal;
        ClaimRecoverableLine: Decimal;
        ReinsuranceShareLines: Record "Treaty Reinsurance Share";
        EndBracket: Boolean;
        ClaimantsRec: Record "Claim Involved Parties";
        ReinsurancePremium: Decimal;
        MaximumCapacity: Decimal;
        ClaimChargeabletoLayer: Decimal;
        ReinstatementPremium: Decimal;
    begin
        //ClaimReserve.CALCFIELDS(ClaimReserve."Reserve Amount");
        //Check if Total Premium Exceeds The Treaty Limits
        //Get the treaty details


        PVLines.RESET;
        PVLines.SETRANGE(PVLines."PV No", PV.No);
        PVLines.SETRANGE(PVLines."Insurance Trans Type", PVLines."Insurance Trans Type"::"Claim Payment");
        IF PVLines.FINDFIRST THEN BEGIN
            REPEAT
                IF ClaimRec.GET(PVLines."Claim No") THEN
                    //  MESSAGE('Policy=%1',ClaimRec."Policy No");
                    IF PolicyType.GET(ClaimRec."Policy Type") THEN
                        IF Treaty.GET(PolicyType."Treaty Code", PolicyType."Addendum No.") THEN

                       //Treaty.RESET;
                       //Treaty.SETRANGE(Treaty."Class of Insurance",ClaimRec."Policy Type");
                       //Treaty.SETRANGE(Treaty."Treaty Status",Treaty."Treaty Status"::Accepted);
                       //IF Treaty.FINDLAST THEN
                       BEGIN   //Treaty

                            //FindPolicy;

                            InsureHeader.RESET;
                            InsureHeader.SETRANGE(InsureHeader."Document Type", InsureHeader."Document Type"::Policy);
                            InsureHeader.SETRANGE(InsureHeader."No.", ClaimRec."Policy No");
                            IF InsureHeader.FINDLAST THEN
                                //Confirm Effective date
                                IF (InsureHeader."From Date" <= Treaty."Expiry Date") AND (InsureHeader."From Date" >= Treaty."Effective date") THEN BEGIN   //treaty range

                                    CedingCommission := 0;
                                    //Check whether proportional or non proportional

                                    //MESSAGE('within the date limits Treaty found');

                                    IF Treaty."Apportionment Type" = Treaty."Apportionment Type"::Proportional
                                      THEN BEGIN
                                        IF Treaty."Quota Share" = TRUE AND Treaty.Surplus = FALSE THEN BEGIN
                                            IF InsureHeader."Total Sum Insured" > Treaty."Treaty Capacity" THEN BEGIN //Sum Insured greater than Treaty capacity
                                                ShareNotCoveredAmt := InsureHeader."Total Sum Insured" - Treaty."Treaty Capacity";
                                                IF InsureHeader."Total Sum Insured" <> 0 THEN
                                                    ShareNotCoveredPercent := (ShareNotCoveredAmt / InsureHeader."Total Sum Insured") * 100;
                                                SharecoveredPercent := 100 - ShareNotCoveredPercent;
                                                LineNo := LineNo + 1000;
                                                ReinsLines.INIT;
                                                ReinsLines."Document Type" := ReinsLines."Document Type"::"Claim payment";
                                                ReinsLines."No." := PV.No;
                                                //ReinsLines."Line No.":=LineNo;
                                                //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                                // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                                ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                                ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                                                ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                                                ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                                //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";

                                                ReinsLines."Claims Payment Amount" := (100 - Treaty."Cedant quota percentage") / 100 * SharecoveredPercent * PVLines.Amount;
                                                ReinsLines."Quota Share" := TRUE;

                                                IF ReinsLines."Claims Payment Amount" <> 0 THEN
                                                    ReinsLines.INSERT(TRUE);



                                            END; //Sum Insured greater than Treaty capacity

                                            IF InsureHeader."Total Sum Insured" <= Treaty."Treaty Capacity" THEN BEGIN //Sum Insured greater than Treaty capacity
                                                                                                                       //ShareNotCoveredAmt:=InsureHeader."Total Sum insured"-Treaty."Treaty Capacity";
                                                                                                                       //IF InsureHeader."Total Sum insured"<>0 THEN
                                                                                                                       //ShareNotCoveredPercent:=(ShareNotCoveredAmt/InsureHeader."Total Sum insured")*100;
                                                                                                                       // SharecoveredPercent:=100-ShareNotCoveredPercent;
                                                LineNo := LineNo + 1000;
                                                ReinsLines.INIT;
                                                ReinsLines."Document Type" := ReinsLines."Document Type"::"Claim payment";
                                                ReinsLines."No." := PV.No;
                                                //ReinsLines."Line No.":=LineNo;
                                                //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                                // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                                ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                                ReinsLines."Account No." := TreatyReinsuranceShare."Re-insurer code";
                                                ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                                                ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                                //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                                ReinsLines."Quota Share" := TRUE;

                                                ReinsLines."Claims Payment Amount" := (100 - Treaty."Cedant quota percentage") / 100 * PVLines.Amount;
                                                //CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                                //ReinsLines."Cedant Commission":=CedingCommission;

                                                IF ReinsLines."Claims Payment Amount" <> 0 THEN
                                                    ReinsLines.INSERT(TRUE);



                                            END; //Sum Insured greater than Treaty capacity

                                        END; //Quota share

                                        IF Treaty."Quota Share" = FALSE AND Treaty.Surplus = TRUE THEN BEGIN //Pure surplus

                                            AUC := Treaty."Net Retained Line" + (Treaty."No. of Lines" * Treaty."Net Retained Line");
                                            IF InsureHeader."Total Sum Insured" <= AUC THEN BEGIN


                                                ReinsLines.INIT;
                                                ReinsLines."Document Type" := ReinsLines."Document Type"::"Claim payment";
                                                ReinsLines."No." := PV.No;
                                                ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                                ReinsLines."Account No." := Treaty."Lead Reinsurer";
                                                ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                                                ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                                //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                                IF InsureHeader."Total Sum Insured" <> 0 THEN
                                                    ReinsLines."Claims Payment Amount" := ((InsureHeader."Total Sum Insured" - Treaty."Net Retained Line") / InsureHeader."Total Sum Insured") * PVLines.Amount;



                                                //CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                                //ReinsLines."Cedant Commission":=CedingCommission;
                                                ReinsLines.Surplus := TRUE;
                                                //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                                //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                                //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                                //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                                IF ReinsLines."Claims Payment Amount" <> 0 THEN
                                                    ReinsLines.INSERT(TRUE);


                                            END;//Automatic Underwriting limit greater than sum insured...

                                            IF InsureHeader."Total Sum Insured" > AUC THEN BEGIN


                                                ReinsLines.INIT;

                                                ReinsLines."Document Type" := ReinsLines."Document Type"::"Claim payment";
                                                ReinsLines."No." := PV.No;
                                                //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                                // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                                ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                                ReinsLines."Account No." := Treaty."Lead Reinsurer";
                                                ReinsLines."Partner No." := Treaty."Lead Reinsurer";
                                                ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                                //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                                IF InsureHeader."Total Sum Insured" <> 0 THEN
                                                    ReinsLines."Claims Payment Amount" := ((AUC - Treaty."Net Retained Line") / InsureHeader."Total Sum Insured") * PVLines.Amount;



                                                //CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                                // ReinsLines."Cedant Commission":=CedingCommission;
                                                ReinsLines.Surplus := TRUE;
                                                //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                                //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                                //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                                //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                                IF ReinsLines."Claims Payment Amount" <> 0 THEN
                                                    ReinsLines.INSERT(TRUE);


                                            END;//Automatic Underwriting limit less than sum insured...




                                        END; //Pure surplus

                                    END;//Proportional
                                    IF Treaty."Apportionment Type" = Treaty."Apportionment Type"::"Non-proportional" THEN BEGIN //Non Proportional

                                        /*IF Treaty."Exess of loss"=TRUE THEN
                                          BEGIN

                                            XOLLayers.RESET;
                                            XOLLayers.SETRANGE(XOLLayers."Treaty Code",Treaty."Treaty Code");
                                            XOLLayers.SETRANGE(XOLLayers."Addendum Code",Treaty."Addendum Code");
                                            IF XOLLayers.FINDFIRST THEN
                                              REPEAT

                                             ReinsLines.INIT;
                                             ReinsLines."Document Type":=ReinsLines."Document Type"::"Claim payment";
                                             ReinsLines."No.":=PV.No;
                                             //ReinsLines."Sell-to Customer No.":=Rec."Sell-to Customer No.";
                                            // ReinsLines."Account Type":=ReinsLines."Account Type"::Vendor;
                                             ReinsLines."Transaction Type":=ReinsLines."Transaction Type"::"Re-insurance ";
                                             ReinsLines."Account No.":=Treaty."Lead Reinsurer";
                                             ReinsLines."Partner No.":=Treaty."Lead Reinsurer";
                                             ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                             //ReinsLines.Description:=TreatyReinsuranceShare."Re-insurer Name";
                                             IF PVLines.Amount>XOLLayers.Deductible THEN
                                             ReinsLines."Claims Payment Amount":=PVLines.Amount-XOLLayers.Deductible;



                                             //CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                            // ReinsLines."Cedant Commission":=CedingCommission;
                                             ReinsLines."Excess Of Loss":=TRUE;
                                             ReinsLines.TreatyLineID:=XOLLayers.Layer;
                                             //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                             //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                             //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                             //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                             IF ReinsLines."Claims Payment Amount"<>0 THEN
                                             ReinsLines.INSERT(TRUE);

                                              UNTIL XOLLayers.NEXT=0;*/
                                        IF Treaty."Exess of loss" = TRUE THEN BEGIN
                                            PV.CALCFIELDS(PV."Total Amount");
                                            IF ClaimantsRec.GET(PVLines."Claim No", PVLines."Claimant ID") THEN
                                                ClaimantsRec.CALCFIELDS(ClaimantsRec."Treaty Recoverable", ClaimantsRec."Amount Paid");
                                            XOLBalance := PVLines.Amount + ClaimantsRec."Amount Paid";
                                            //MESSAGE('XOL Balance=%1',XOLBalance);
                                            XOLLayers.RESET;
                                            XOLLayers.SETRANGE(XOLLayers."Treaty Code", Treaty."Treaty Code");
                                            XOLLayers.SETRANGE(XOLLayers."Addendum Code", Treaty."Addendum Code");
                                            IF XOLLayers.FINDFIRST THEN
                                                REPEAT
                                                    ClaimRecoverableLine := 0;
                                                    /*  IF XOLBalance>0 THEN
                                                     BEGIN

                                                      IF XOLBalance<=XOLLayers."Line Total" THEN
                                                         BEGIN
                                                           IF XOLBalance>XOLLayers.Deductible THEN
                                                             BEGIN
                                                           ClaimRecoverableLine:=XOLBalance-XOLLayers.Deductible;
                                                           XOLBalance:=XOLBalance-XOLLayers."Line Total";
                                                           //MESSAGE('XOLBalance less than Line Total ending layer=%1 Layer=%2',XOLBalance,XOLLayers.Layer);
                                                            END;
                                                         END
                                                         ELSE
                                                         BEGIN
                                                          // MESSAGE('XOLBalance=%1 Layer=%2',XOLBalance,XOLLayers.Layer);
                                                          ClaimRecoverableLine:=XOLLayers."Line Total"-XOLLayers.Deductible;

                                                           XOLBalance:=XOLBalance-XOLLayers."Line Total";
                                                           // MESSAGE('XOLBalance after=%1',XOLBalance,XOLLayers.Layer);
                                                         END;
                                                         END;*/

                                                    IF XOLBalance <= XOLLayers."Line Total" THEN BEGIN
                                                        EndBracket := TRUE;

                                                        IF XOLBalance > XOLLayers.Deductible THEN
                                                            ClaimRecoverableLine := XOLBalance - XOLLayers.Deductible

                                                        ELSE
                                                            ClaimRecoverableLine := 0;

                                                        // MESSAGE('Layer=%1 and XOLbalance=%2',LayerNo,XOLBalance);


                                                    END
                                                    ELSE BEGIN

                                                        ClaimRecoverableLine := XOLLayers.Cover;

                                                    END;

                                                    //Calculate Reinstatement Premium
                                                    XOLLayers.CALCFIELDS(XOLLayers.GNPI);
                                                    ReinsurancePremium := XOLLayers.GNPI * (XOLLayers."Max. Rate" / 100);
                                                    MaximumCapacity := 2 * XOLLayers.Cover;

                                                    ClaimChargeabletoLayer := ClaimRecoverableLine;

                                                    IF XOLLayers.Cover <> 0 THEN
                                                        ReinstatementPremium := (ReinsurancePremium * ClaimChargeabletoLayer * (XOLLayers.Reinstatement / 100)) / XOLLayers.Cover;

                                                    //End Reinstatement Calculation


                                                    ReinsuranceShareLines.RESET;
                                                    ReinsuranceShareLines.SETRANGE(ReinsuranceShareLines."Treaty Code", XOLLayers."Treaty Code");
                                                    ReinsuranceShareLines.SETRANGE(ReinsuranceShareLines."Addendum Code", XOLLayers."Addendum Code");
                                                    IF ReinsuranceShareLines.FINDFIRST THEN
                                                        REPEAT

                                                            //CedingCommission:=ReinsLines.Premium*(Treaty."Broker Commision"/100);
                                                            // ReinsLines."Cedant Commission":=CedingCommission;



                                                            ReinsLines.INIT;
                                                            ReinsLines."Document Type" := ReinsLines."Document Type"::"Claim payment";
                                                            ReinsLines."No." := PV.No;
                                                            ReinsLines."Transaction Type" := ReinsLines."Transaction Type"::"Re-insurance ";
                                                            ReinsLines."Account No." := Treaty.Broker;
                                                            ReinsLines."Partner No." := ReinsuranceShareLines."Re-insurer code";
                                                            ReinsLines.VALIDATE(ReinsLines."Partner No.");
                                                            ReinsLines."Excess Of Loss" := TRUE;
                                                            ReinsLines.TreatyLineID := XOLLayers.Layer;
                                                            IF ClaimantsRec.GET(PVLines."Claim No", PVLines."Claimant ID") THEN
                                                                ClaimantsRec.SETRANGE(ClaimantsRec."Partner Filter", ReinsuranceShareLines."Re-insurer code");
                                                            ClaimantsRec.SETRANGE(ClaimantsRec."XOL Layer Filter", XOLLayers.Layer);
                                                            ClaimantsRec.CALCFIELDS(ClaimantsRec."XOLTreaty Recoverable");
                                                            //ClaimRecoverableLine:=ClaimRecoverableLine-ClaimantsRec."XOLTreaty Recoverable";
                                                            ReinsLines."Claims Payment Amount" := ClaimRecoverableLine * (ReinsuranceShareLines."Percentage %" / 100) - ClaimantsRec."XOLTreaty Recoverable";
                                                            // MESSAGE('Reinsurance amount=%1 proportion for %2 =%3 and after deducting previous =%4',ClaimRecoverableLine,
                                                            // ReinsuranceShareLines."Re-insurer Name",ClaimRecoverableLine*(ReinsuranceShareLines."Percentage %"/100),ReinsLines."Claims Payment Amount");

                                                            //ReinsLines."Shortcut Dimension 1 Code":=InsLines."Shortcut Dimension 1 Code";
                                                            //NewLines.VALIDATE("Shortcut Dimension 1 Code");
                                                            //ReinsLines."Shortcut Dimension 2 Code":=InsLines."Shortcut Dimension 2 Code";
                                                            //NewLines.VALIDATE("Shortcut Dimension 2 Code");
                                                            ReinsLines."Reinstated Amount" := ReinsLines."Claims Payment Amount";
                                                            ReinsLines."Claim No." := PVLines."Claim No";
                                                            ReinsLines."Claimant ID" := PVLines."Claimant ID";
                                                            ReinsLines."Transaction Date" := PV.Date;
                                                            IF ReinsLines."Claims Payment Amount" <> 0 THEN
                                                                ReinsLines.INSERT(TRUE);

                                                        UNTIL ReinsuranceShareLines.NEXT = 0;

                                                UNTIL ((XOLLayers.NEXT = 0) OR (EndBracket = TRUE));







                                        END;

                                    END //Non Proportional
                                END;
                        END;
            UNTIL PVLines.NEXT = 0;
        END; //Pvlines found


    end;

    procedure GetNewPeriodLength(var PeriodL: DateFormula; var NoOfPeriods: Integer) newDF: Text;
    var
        DateFormText: Text;
        StringPositionD: Integer;
        StringPositionW: Integer;
        StringPositionM: Integer;
        StringPositionQ: Integer;
        StringPositionY: Integer;
        IntValtext: Text;
        IntVal: Integer;
        Strlength: Integer;
    begin

        DateFormText := FORMAT(PeriodL);
        Strlength := STRLEN(DateFormText);
        StringPositionD := STRPOS(DateFormText, 'D');
        StringPositionW := STRPOS(DateFormText, 'W');
        StringPositionM := STRPOS(DateFormText, 'M');
        StringPositionQ := STRPOS(DateFormText, 'Q');
        StringPositionY := STRPOS(DateFormText, 'Y');
        IF StringPositionD <> 0 THEN BEGIN
            IntValtext := COPYSTR(DateFormText, 1, Strlength - 1);
            EVALUATE(IntVal, IntValtext);
            newDF := FORMAT(IntVal * NoOfPeriods) + 'D';
        END;

        IF StringPositionW <> 0 THEN BEGIN
            IntValtext := COPYSTR(DateFormText, 1, Strlength - 1);
            EVALUATE(IntVal, IntValtext);
            newDF := FORMAT(IntVal * NoOfPeriods) + 'W';
        END;

        IF StringPositionM <> 0 THEN BEGIN


            IntValtext := COPYSTR(DateFormText, 1, Strlength - 1);
            EVALUATE(IntVal, IntValtext);
            newDF := FORMAT(IntVal * NoOfPeriods) + 'M';
        END;

        IF StringPositionQ <> 0 THEN BEGIN
            IntValtext := COPYSTR(DateFormText, 1, Strlength - 1);
            EVALUATE(IntVal, IntValtext);
            newDF := FORMAT(IntVal * NoOfPeriods) + 'Q';
        END;
        IF StringPositionY <> 0 THEN BEGIN
            IntValtext := COPYSTR(DateFormText, 1, Strlength - 1);
            EVALUATE(IntVal, IntValtext);
            newDF := FORMAT(IntVal * NoOfPeriods) + 'Y';
        END;

    end;

    procedure CheckValidity(var InsureHeader: Record "Insure Header");
    var
        CertPrinting: Record "Certificate Printing";
        InsureLinesRec: Record "Insure Lines";
        PolicyLines: Record "Insure Lines";
        EndorsementTypeRec: Record "Endorsement Types";
    begin
        IF InsureHeader."Action Type" <> InsureHeader."Action Type"::Substitution THEN BEGIN
            IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN BEGIN
                IF EndorsementType."Certificate Actions" = EndorsementType."Certificate Actions"::"Create New" THEN BEGIN
                    InsureLinesRec.RESET;
                    InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureHeader."Document Type");
                    InsureLinesRec.SETRANGE(InsureLinesRec."Document No.", InsureHeader."No.");
                    InsureLinesRec.SETRANGE(InsureLinesRec."Description Type", InsureLinesRec."Description Type"::"Schedule of Insured");
                    InsureLinesRec.SETFILTER(InsureLinesRec."Registration No.", '<>%1', '');
                    IF InsureLinesRec.FINDFIRST THEN
                        REPEAT
                            CertPrinting.RESET;
                            CertPrinting.SETRANGE(CertPrinting."Registration No.", InsureLinesRec."Registration No.");
                            CertPrinting.SETRANGE(CertPrinting."Certificate Status", CertPrinting."Certificate Status"::Active);
                            IF CertPrinting.FINDFIRST THEN
                                REPEAT

                                    IF InsureHeader."Cover Start Date" <= CertPrinting."End Date" THEN
                                        ERROR('vehicle %1 is already covered between %2..%3 change cover start date to avoid overlap or cancel existing certificate', CertPrinting."Registration No.", CertPrinting."Start Date", CertPrinting."End Date");


                                UNTIL CertPrinting.NEXT = 0;
                        UNTIL InsureLinesRec.NEXT = 0;
                END;
            END;
        END;
    end;

    procedure DrawPostedDatedChequesPV(var PV: Record Payments1);
    var
        PaymentSchedule: Record "Instalment Payment Plan";
        TotalPremium: Decimal;
        PolicyLines: Record "Insure Lines";
        StartDate: Date;
        i: Integer;
        PaymentTerms: Record "No. of Instalments";
    begin
        PaymentSchedule.RESET;
        PaymentSchedule.SETRANGE(PaymentSchedule."Document Type", PaymentSchedule."Document Type"::"Post dated Cheque");
        PaymentSchedule.SETRANGE(PaymentSchedule."Document No.", PV.No);
        PaymentSchedule.DELETEALL;

        IF PV.No <> '' THEN BEGIN
            IF PaymentTerms.GET(PV."No. Of Instalments") THEN BEGIN
                IF PaymentTerms."No. Of Instalments" > 1 THEN BEGIN

                    StartDate := PV.Date;
                    FOR i := 1 TO PaymentTerms."No. Of Instalments" DO BEGIN
                        PaymentSchedule.INIT;
                        PaymentSchedule."Document Type" := PaymentSchedule."Document Type"::"Post dated Cheque";
                        PaymentSchedule."Document No." := PV.No;
                        PaymentSchedule."Payment No" := i;
                        PV.CALCFIELDS(PV."Total Amount");
                        PaymentSchedule."Amount Due" := PV."Total Amount" / PV."No. Of Instalments";

                        //PaymentSchedule."Amount Due":=PolicyHeader."Amount Including VAT";
                        IF i = 1 THEN
                            PaymentSchedule."Due Date" := StartDate
                        ELSE BEGIN
                            StartDate := CALCDATE(PaymentTerms."Period Length", StartDate);
                            PaymentSchedule."Due Date" := StartDate;

                        END;


                        IF PaymentSchedule.GET(PaymentSchedule."Document Type", PaymentSchedule."Document No.", PaymentSchedule."Payment No") THEN
                            PaymentSchedule.MODIFY
                        ELSE
                            PaymentSchedule.INSERT;

                    END;

                END;
            END;
        END;
    end;

    /* procedure DrawPostedDatedChequesRec(var ReceiptHeader: Record "Receipts Header");
    var
        PaymentSchedule: Record "Instalment Payment Plan";
        TotalPremium: Decimal;
        PolicyLines: Record "Insure Lines";
        StartDate: Date;
        i: Integer;
        PaymentTerms: Record "No. of Instalments";
    begin
        PaymentSchedule.RESET;
        PaymentSchedule.SETRANGE(PaymentSchedule."Document Type", PaymentSchedule."Document Type"::"Post dated Cheque");
        PaymentSchedule.SETRANGE(PaymentSchedule."Document No.", ReceiptHeader."No.");
        PaymentSchedule.DELETEALL;

        IF ReceiptHeader."No." <> '' THEN BEGIN
            IF PaymentTerms.GET(ReceiptHeader."No. Of Instalments") THEN BEGIN
                IF PaymentTerms."No. Of Instalments" > 1 THEN BEGIN

                    StartDate := ReceiptHeader."Receipt Date";
                    FOR i := 1 TO PaymentTerms."No. Of Instalments" DO BEGIN
                        PaymentSchedule.INIT;
                        PaymentSchedule."Document Type" := PaymentSchedule."Document Type"::"Post dated Cheque";
                        PaymentSchedule."Document No." := ReceiptHeader."No.";
                        PaymentSchedule."Payment No" := i;
                        ReceiptHeader.CALCFIELDS(ReceiptHeader."Total Amount");
                        PaymentSchedule."Amount Due" := ReceiptHeader."Total Amount" / ReceiptHeader."No. Of Instalments";

                        //PaymentSchedule."Amount Due":=PolicyHeader."Amount Including VAT";
                        IF i = 1 THEN
                            PaymentSchedule."Due Date" := StartDate
                        ELSE BEGIN
                            StartDate := CALCDATE(PaymentTerms."Period Length", StartDate);
                            PaymentSchedule."Due Date" := StartDate;

                        END;


                        IF PaymentSchedule.GET(PaymentSchedule."Document Type", PaymentSchedule."Document No.", PaymentSchedule."Payment No") THEN
                            PaymentSchedule.MODIFY
                        ELSE
                            PaymentSchedule.INSERT;

                    END;

                END;
            END;
        END;
    end; */

    procedure AddYellowCardPolicyCoverRisk(var VehicleRegNo: Code[20]);
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        InsureLinesRec: Record "Insure Lines";
        InsureHeader: Record "Insure Header";
        Payschedule: Record "Instalment Payment Plan";
        OptionalCovers: Record "Optional Covers";
        LoadingsDiscSetup: Record "Loading and Discounts Setup";
    begin

        InsureLinesRec.RESET;
        InsureLinesRec.SETCURRENTKEY(InsureLinesRec."Start Date");
        InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
        InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Live);
        InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", VehicleRegNo);
        IF InsureLinesRec.FINDLAST THEN BEGIN
            IF InsureHeader.GET(InsureLinesRec."Document Type", InsureLinesRec."Document No.") THEN BEGIN
                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
                EndorsementType.RESET;
                EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::"Yellow Card");
                IF EndorsementType.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
                    InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
                END;
                IF (InsureHeader."Action Type" = InsureHeader."Action Type"::New) OR (InsureHeader."Action Type" = InsureHeader."Action Type"::Renewal) THEN
                    InsureHeaderCopy."Policy No" := InsureHeader."No.";
                InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
                InsureHeaderCopy."Cover Start Date" := TODAY;
                //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
                //InsureHeaderCopy."Cover Start Date":=GetEndorsementStartDate(InsureHeaderCopy);
                /*Payschedule.RESET;
                Payschedule.SETRANGE(Payschedule."Document Type",InsureHeader."Document Type");
                Payschedule.SETRANGE(Payschedule."Document No.",InsureHeader."No.");
                Payschedule.SETRANGE(Payschedule."Payment No",InsureHeader."Instalment No."+1);
                IF Payschedule.FINDLAST THEN
                  BEGIN
                  InsureHeaderCopy."Instalment No.":=Payschedule."Payment No";
                  InsureHeaderCopy."Cover Start Date":=Payschedule."Cover Start Date";
                  //InsureHeaderCopy.VALIDATE("Cover Start Date");

                  //InsureHeaderCopy."Cover End Date":=Payschedule."Cover End Date";

                END;*/
                InsureHeaderCopy."No." := '';
                InsureHeaderCopy.INSERT(TRUE);

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.INIT;
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                        InstalmentLinesCopy.INSERT;
                    UNTIL InstalmentLines.NEXT = 0;
                // MESSAGE('Instalment Number=%1',InsureHeader."Instalment No."+
                /*//InsureHeader."No. Of Cover Periods");
                  Payschedule.RESET;
                  Payschedule.SETRANGE(Payschedule."Document Type",InsureHeaderCopy."Document Type");
                  Payschedule.SETRANGE(Payschedule."Document No.",InsureHeaderCopy."No.");
                  Payschedule.SETRANGE(Payschedule."Payment No",InsureHeader."Instalment No."+
                InsureHeader."No. Of Cover Periods");

                IF Payschedule.FINDFIRST THEN
                  BEGIN
                InsureHeaderCopy."Cover Start Date":=TODAY;
                InsureHeaderCopy."Instalment No.":=Payschedule."Payment No";
                //MESSAGE('Cover start date=%1 Instalment no=%2',InsureHeaderCopy."Cover Start Date",InsureHeaderCopy."Instalment No.");
                END;
                 InsureHeaderCopy.VALIDATE("Cover Start Date");
                 InsureHeaderCopy.MODIFY;
                 //MESSAGE('Cover End date=%1',InsureHeaderCopy."Cover End Date");*/

                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLinesRec);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;


                /*OptionalCovers.RESET;
                OptionalCovers.SETRANGE(OptionalCovers."Yellow Card",TRUE);
                IF OptionalCovers.FINDFIRST THEN
                BEGIN

                  AdditionalBenefitsCopy.INIT;
                  AdditionalBenefitsCopy."Document Type":=InsureHeaderCopy."Document Type";
                  AdditionalBenefitsCopy."Document No.":=InsureHeaderCopy."No.";
                  AdditionalBenefitsCopy."Risk ID":=InsureLinesRec."Line No.";
                  AdditionalBenefitsCopy."Option ID":=OptionalCovers.Code;
                  AdditionalBenefitsCopy.VALIDATE(AdditionalBenefitsCopy."Option ID");
                  AdditionalBenefitsCopy.Premium:=OptionalCovers."Loading Amount";
                  AdditionalBenefitsCopy.INSERT;
                 // MESSAGE('doing it');
                END
                ELSE
                ERROR('Please setup COMESA Yellow Card as an optional cover benefit');*/

                //
                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT
                        InsureHeaderLoading_DiscountCopy.INIT;
                        InsureHeaderLoading_DiscountCopy.TRANSFERFIELDS(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                        InsureHeaderLoading_DiscountCopy.INSERT;

                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                //
                /*LoadingsDiscSetup.RESET;
                LoadingsDiscSetup.SETRANGE(LoadingsDiscSetup."Applicable to",LoadingsDiscSetup."Applicable to"::COMESA);
                IF LoadingsDiscSetup.FINDFIRST THEN
                BEGIN
                  InsureHeaderLoading_DiscountCopy.INIT;
                  InsureHeaderLoading_DiscountCopy."Document Type":=InsureHeaderCopy."Document Type";
                  InsureHeaderLoading_DiscountCopy."No.":=InsureHeaderCopy."No.";
                  InsureHeaderLoading_DiscountCopy.Code:=LoadingsDiscSetup.Code;
                  InsureHeaderLoading_DiscountCopy.VALIDATE(InsureHeaderLoading_DiscountCopy.Code);
                  InsureHeaderLoading_DiscountCopy.Description:=LoadingsDiscSetup.Description;
                  InsureHeaderLoading_DiscountCopy.Selected:=TRUE;

                  InsureHeaderLoading_DiscountCopy.INSERT;



                END
                ELSE
                ERROR('Please setup COMESA Certificate charge on Loadings and Discounts setup');*/

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT
                        ReinslinesCopy.INIT;
                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        ReinslinesCopy."No." := InsureHeaderCopy."No.";
                        ReinslinesCopy.INSERT;

                    UNTIL Reinslines.NEXT = 0;


                PAGE.RUN(51513183, InsureHeaderCopy);
            END;
        END
        ELSE
            ERROR('Vehicle Registration No %1 is not on the database', VehicleRegNo);

    end;

    procedure CreditLimitExceeded(var CustNo: Code[20]; var RefDate: Date) WithinCreditLimit: Boolean;
    var
        CreditRequest: Record "Credit Request";
    begin
        IF CreditLimitExists(CustNo, RefDate) THEN
            IF Cust.GET(CustNo) THEN
                Cust.CALCFIELDS(Cust.Balance);
        CreditRequest.RESET;
        CreditRequest.SETRANGE(CreditRequest."Customer ID", CustNo);
        CreditRequest.SETFILTER(CreditRequest."Credit Start Date", '<=%1', RefDate);
        CreditRequest.SETFILTER(CreditRequest."Credit End Date", '>=%1', RefDate);
        CreditRequest.SETRANGE(CreditRequest.Status, CreditRequest.Status::Released);
        IF CreditRequest.FINDFIRST THEN BEGIN
            IF (CreditRequest."Credit Amount" - Cust.Balance) <= 0 THEN
                WithinCreditLimit := TRUE
            ELSE
                WithinCreditLimit := FALSE;
            MESSAGE('Credit limit=%1 and Balance=%2', CreditRequest."Credit Amount", Cust.Balance);
        END;
    end;

    procedure CreditLimitExists(var CustNo: Code[20]; var RefDate: Date) ExistsRec: Boolean;
    var
        CreditRequestRec: Record "Credit Request";
    begin
        CreditRequestRec.RESET;
        CreditRequestRec.SETRANGE(CreditRequestRec."Customer ID", CustNo);
        CreditRequestRec.SETFILTER(CreditRequestRec."Credit Start Date", '<=%1', RefDate);
        CreditRequestRec.SETFILTER(CreditRequestRec."Credit End Date", '>=%1', RefDate);
        CreditRequestRec.SETRANGE(CreditRequestRec.Status, CreditRequestRec.Status::Released);
        IF CreditRequestRec.FINDFIRST THEN
            ExistsRec := TRUE;
    end;

    procedure AddRiderRisk(var VehicleRegNo: Code[20]);
    var
        InsureLines: Record "Insure Lines";
        AdditionalBenefits: Record "Additional Benefits";
        InsureHeaderLoading_Discount: Record "Insure Header Loading_Discount";
        InsureHeaderCopy: Record "Insure Header";
        InsureLinesCopy: Record "Insure Lines";
        AdditionalBenefitsCopy: Record "Additional Benefits";
        InsureHeaderLoading_DiscountCopy: Record "Insure Header Loading_Discount";
        ReinslinesCopy: Record "Coinsurance Reinsurance Lines";
        InstalmentLines: Record "Instalment Payment Plan";
        InstalmentLinesCopy: Record "Instalment Payment Plan";
        InsureHeaderCopy2: Record "Insure Header";
        Reinslines: Record "Coinsurance Reinsurance Lines";
        EndorsementType: Record "Endorsement Types";
        InsureLinesRec: Record "Insure Lines";
        InsureHeader: Record "Insure Header";
        Payschedule: Record "Instalment Payment Plan";
        OptionalCovers: Record "Optional Covers";
        LoadingsDiscSetup: Record "Loading and Discounts Setup";
    begin

        InsureLinesRec.RESET;
        InsureLinesRec.SETCURRENTKEY(InsureLinesRec."Start Date");
        InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
        InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Live);
        InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", VehicleRegNo);
        IF InsureLinesRec.FINDLAST THEN BEGIN
            IF InsureHeader.GET(InsureLinesRec."Document Type", InsureLinesRec."Document No.") THEN BEGIN
                InsureHeaderCopy.COPY(InsureHeader);
                InsureHeaderCopy."Document Type" := InsureHeaderCopy."Document Type"::Endorsement;
                EndorsementType.RESET;
                EndorsementType.SETRANGE(EndorsementType."Action Type", EndorsementType."Action Type"::"Yellow Card");
                IF EndorsementType.FINDLAST THEN BEGIN
                    InsureHeaderCopy."Endorsement Type" := EndorsementType.Code;
                    InsureHeaderCopy.VALIDATE(InsureHeaderCopy."Endorsement Type");
                END;
                IF (InsureHeader."Action Type" = InsureHeader."Action Type"::New) OR (InsureHeader."Action Type" = InsureHeader."Action Type"::Renewal) THEN
                    InsureHeaderCopy."Policy No" := InsureHeader."No.";
                InsureHeaderCopy."Original Cover Start Date" := InsureHeader."Cover Start Date";
                InsureHeaderCopy."Cover Start Date" := TODAY;
                //InsureHeaderCopy."Quote Type":=InsureHeader."Quote Type"::Renewal;
                //InsureHeaderCopy."Cover Start Date":=GetEndorsementStartDate(InsureHeaderCopy);
                /*Payschedule.RESET;
                Payschedule.SETRANGE(Payschedule."Document Type",InsureHeader."Document Type");
                Payschedule.SETRANGE(Payschedule."Document No.",InsureHeader."No.");
                Payschedule.SETRANGE(Payschedule."Payment No",InsureHeader."Instalment No."+1);
                IF Payschedule.FINDLAST THEN
                  BEGIN
                  InsureHeaderCopy."Instalment No.":=Payschedule."Payment No";
                  InsureHeaderCopy."Cover Start Date":=Payschedule."Cover Start Date";
                  //InsureHeaderCopy.VALIDATE("Cover Start Date");

                  //InsureHeaderCopy."Cover End Date":=Payschedule."Cover End Date";

                END;*/
                InsureHeaderCopy."No." := '';
                InsureHeaderCopy.INSERT(TRUE);

                InstalmentLines.RESET;
                InstalmentLines.SETRANGE(InstalmentLines."Document Type", InsureHeader."Document Type");
                InstalmentLines.SETRANGE(InstalmentLines."Document No.", InsureHeader."No.");
                IF InstalmentLines.FINDFIRST THEN
                    REPEAT
                        InstalmentLinesCopy.INIT;
                        InstalmentLinesCopy.COPY(InstalmentLines);
                        InstalmentLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InstalmentLinesCopy."Document No." := InsureHeaderCopy."No.";
                        InstalmentLinesCopy.INSERT;
                    UNTIL InstalmentLines.NEXT = 0;
                // MESSAGE('Instalment Number=%1',InsureHeader."Instalment No."+
                /*//InsureHeader."No. Of Cover Periods");
                  Payschedule.RESET;
                  Payschedule.SETRANGE(Payschedule."Document Type",InsureHeaderCopy."Document Type");
                  Payschedule.SETRANGE(Payschedule."Document No.",InsureHeaderCopy."No.");
                  Payschedule.SETRANGE(Payschedule."Payment No",InsureHeader."Instalment No."+
                InsureHeader."No. Of Cover Periods");

                IF Payschedule.FINDFIRST THEN
                  BEGIN
                InsureHeaderCopy."Cover Start Date":=TODAY;
                InsureHeaderCopy."Instalment No.":=Payschedule."Payment No";
                //MESSAGE('Cover start date=%1 Instalment no=%2',InsureHeaderCopy."Cover Start Date",InsureHeaderCopy."Instalment No.");
                END;
                 InsureHeaderCopy.VALIDATE("Cover Start Date");
                 InsureHeaderCopy.MODIFY;
                 //MESSAGE('Cover End date=%1',InsureHeaderCopy."Cover End Date");*/

                InsureLinesCopy.INIT;
                InsureLinesCopy.COPY(InsureLinesRec);
                InsureLinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                InsureLinesCopy."Document No." := InsureHeaderCopy."No.";
                InsureLinesCopy."Policy No" := InsureHeader."No.";
                InsureLinesCopy."Select Risk ID" := InsureLines."Line No.";
                InsureLinesCopy.INSERT;


                OptionalCovers.RESET;
                OptionalCovers.SETRANGE(OptionalCovers."Yellow Card", TRUE);
                IF OptionalCovers.FINDFIRST THEN BEGIN

                    AdditionalBenefitsCopy.INIT;
                    AdditionalBenefitsCopy."Document Type" := InsureHeaderCopy."Document Type";
                    AdditionalBenefitsCopy."Document No." := InsureHeaderCopy."No.";
                    AdditionalBenefitsCopy."Risk ID" := InsureLinesRec."Line No.";
                    AdditionalBenefitsCopy."Option ID" := OptionalCovers.Code;
                    AdditionalBenefitsCopy.VALIDATE(AdditionalBenefitsCopy."Option ID");
                    AdditionalBenefitsCopy.Premium := OptionalCovers."Loading Amount";
                    AdditionalBenefitsCopy.INSERT;
                    // MESSAGE('doing it');
                END
                ELSE
                    ERROR('Please setup COMESA Yellow Card as an optional cover benefit');

                //
                InsureHeaderLoading_Discount.RESET;
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."Document Type", InsureHeader."Document Type");
                InsureHeaderLoading_Discount.SETRANGE(InsureHeaderLoading_Discount."No.", InsureHeader."No.");
                IF InsureHeaderLoading_Discount.FINDFIRST THEN
                    REPEAT
                        InsureHeaderLoading_DiscountCopy.INIT;
                        InsureHeaderLoading_DiscountCopy.TRANSFERFIELDS(InsureHeaderLoading_Discount);
                        InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                        InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                        InsureHeaderLoading_DiscountCopy.INSERT;

                    UNTIL InsureHeaderLoading_Discount.NEXT = 0;

                //
                LoadingsDiscSetup.RESET;
                LoadingsDiscSetup.SETRANGE(LoadingsDiscSetup."Applicable to", LoadingsDiscSetup."Applicable to"::COMESA);
                IF LoadingsDiscSetup.FINDFIRST THEN BEGIN
                    InsureHeaderLoading_DiscountCopy.INIT;
                    InsureHeaderLoading_DiscountCopy."Document Type" := InsureHeaderCopy."Document Type";
                    InsureHeaderLoading_DiscountCopy."No." := InsureHeaderCopy."No.";
                    InsureHeaderLoading_DiscountCopy.Code := LoadingsDiscSetup.Code;
                    InsureHeaderLoading_DiscountCopy.VALIDATE(InsureHeaderLoading_DiscountCopy.Code);
                    InsureHeaderLoading_DiscountCopy.Description := LoadingsDiscSetup.Description;
                    InsureHeaderLoading_DiscountCopy.Selected := TRUE;

                    InsureHeaderLoading_DiscountCopy.INSERT;



                END
                ELSE
                    ERROR('Please setup COMESA Certificate charge on Loadings and Discounts setup');

                Reinslines.RESET;
                Reinslines.SETRANGE(Reinslines."Document Type", InsureHeader."Document Type");
                Reinslines.SETRANGE(Reinslines."No.", InsureHeader."No.");
                IF Reinslines.FINDFIRST THEN
                    REPEAT
                        ReinslinesCopy.INIT;
                        ReinslinesCopy.COPY(Reinslines);
                        ReinslinesCopy."Document Type" := InsureHeaderCopy."Document Type";
                        ReinslinesCopy."No." := InsureHeaderCopy."No.";
                        ReinslinesCopy.INSERT;

                    UNTIL Reinslines.NEXT = 0;


                PAGE.RUN(51513183, InsureHeaderCopy);
            END;
        END
        ELSE
            ERROR('Vehicle Registration No %1 is not on the database', VehicleRegNo);

    end;

    /* procedure BirthDayNotification(Client: Record Customer);
    var
        DayMonth: Code[10];
        //MessageTypeRec: Record "Notification Template";";
        FullMessage: Text[250];
        UserSetup: Record "User Setup";
        SMTP: Codeunit "SMTP Mail";
    begin

        //ClientSetup.GET;
        MessageTypeRec.RESET;
        MessageTypeRec.SETRANGE(MessageTypeRec.Type, MessageTypeRec.Type::Birthday);
        IF MessageTypeRec.FIND('-') THEN BEGIN

            //AppMngtNotification.FillLeaveTemplate(Client);
            FullMessage := STRSUBSTNO(MessageTypeRec."SMS MESSAGE", Client.Name);
            //CreateSMS(Client."Mobile 1",FullMessage);
            InsertSMStoVendorDB(Client.Mobile, FullMessage);

        END
        ELSE
            ERROR('Notification message for Application confirmation..Not set');
    end; */

    procedure CreateBirthDateMonth(var BirthDate: Date) DateMonth: Code[4];
    var
        Client: Record Vendor;
    begin
        DateMonth := FORMAT(DATE2DMY(BirthDate, 1)) + FORMAT(DATE2DMY(BirthDate, 2));
    end;

    procedure InsertSMStoVendorDB(var PhoneNo: Text; var Messagetxt: Text);
    var
        SMSSetup: Record "SMS Setup";
        DotNetString: Variant;
        PhoneLength: Integer;
        phoneparam: Text;
        SenderID: Code[20];
        PSVsms: Record "PSV_SMS";
        PSVsmsCopy: Record "PSV_SMS";
    begin
        //SMSSaverApp := SMSSaverApp.callthepin();
        //formatting
        SMSSetup.SETRANGE(Status, SMSSetup.Status::Active);
        IF SMSSetup.FIND('+') THEN BEGIN
            phoneparam := SMSSetup."Phone Parameter";
            SenderID := SMSSetup."Sender ID";
        END;


        PhoneLength := STRLEN(PhoneNo);

        IF COPYSTR(PhoneNo, 1, 1) = '0' THEN
            PhoneNo := COPYSTR(PhoneNo, 2, 10);

        //VOO
        IF COPYSTR(PhoneNo, 1, 3) = '254' THEN
            PhoneNo := COPYSTR(PhoneNo, 4, 10);

        IF COPYSTR(PhoneNo, 1, 4) = SMSSetup."Phone Prefix" THEN
            PhoneNo := COPYSTR(PhoneNo, 5, 10);
        PhoneNo := SMSSetup."Phone Prefix" + PhoneNo;

        //
        //SMSSaverApp.savesms(SenderID,PhoneNo,Message);
        MESSAGE('Phone =%1 and Message=%2', PhoneNo, Messagetxt);
        PSVsms.RESET;
        IF PSVsms.FINDLAST THEN BEGIN
            PSVsmsCopy.INIT;
            PSVsmsCopy.SmsID := PSVsms.SmsID + 1;
            PSVsmsCopy.V_phone := PhoneNo;
            PSVsmsCopy.V_message := Messagetxt;
            PSVsmsCopy.INSERT;


        END
        ELSE BEGIN
            PSVsmsCopy.INIT;
            PSVsmsCopy.SmsID := 1;
            PSVsmsCopy.V_phone := PhoneNo;
            PSVsmsCopy.V_message := Messagetxt;
            PSVsmsCopy.INSERT;
        END;
    end;

    /* procedure SendBirthdayNotificationMail(Client: Record Customer);
    var
    //SNN
    ////////////MessageTypeRec: Record "Notification Template";
    //Text040: ;
    begin
        MessageTypeRec.RESET;
        MessageTypeRec.SETRANGE(MessageTypeRec.Type, MessageTypeRec.Type::Birthday);
        IF MessageTypeRec.FIND('+') THEN BEGIN

            SetTemplateMessageType(MessageTypeRec);

        END;

        MessageTypeRec.CALCFIELDS(MessageTypeRec."Notification Body");
        IF NOT MessageTypeRec."Notification Body".HASVALUE THEN
            ERROR(Text040);
        MessageTypeRec."Notification Body".CREATEINSTREAM(InStreamTemplate);

        Subject := MessageTypeRec.Description;
        Body := ''; // Text013;
        Recipient := Client."E-Mail";
        SMTP.CreateMessage(SenderName, SenderAddress, Recipient, Subject, Body, TRUE);
        Body := '';

        WHILE InStreamTemplate.EOS() = FALSE DO BEGIN
            InStreamTemplate.READTEXT(InSReadChar, 1);
            IF InSReadChar = '%' THEN BEGIN
                SMTP.AppendBody(Body);
                Body := InSReadChar;
                IF InStreamTemplate.READTEXT(InSReadChar, 1) <> 0 THEN;
                IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN BEGIN
                    Body := Body + '1';
                    CharNo := InSReadChar;
                    WHILE (InSReadChar >= '0') AND (InSReadChar <= '9') DO BEGIN
                        IF InStreamTemplate.READTEXT(InSReadChar, 1) <> 0 THEN;
                        IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN
                            CharNo := CharNo + InSReadChar;
                    END;
                END ELSE
                    Body := Body + InSReadChar;
                FillClientBirthDayTemplate(Body, CharNo, Client);
                SMTP.AppendBody(Body);
                Body := InSReadChar;
            END ELSE BEGIN
                Body := Body + InSReadChar;
                I := I + 1;
                IF I = 500 THEN BEGIN
                    SMTP.AppendBody(Body);
                    Body := '';
                    I := 0;
                END;
            END;
        END;
        SMTP.AppendBody(Body);
        SMTP.Send;
    end; */

    /*procedure SetTemplateMessageType(MessageType: Record "Notification Template");
    begin

        MessageType.CALCFIELDS(MessageType."Notification Body");
        IF NOT MessageType."Notification Body".HASVALUE THEN
            ERROR(Text040);
        MessageType."Notification Body".CREATEINSTREAM(InStreamTemplate);
        SenderName := COMPANYNAME;
        CLEAR(SenderAddress);
        CLEAR(Recipient);
        GetEmailAddressStanbic();
    end;*/

    procedure FillClientBirthDayTemplate(var Body: Text[254]; TextNo: Text[30]; Header: Record Customer);
    var
        BirthdateTxt: Text[30];
        TodaysText: Text[30];
    begin
        CASE TextNo OF
            '1':
                Body := STRSUBSTNO(Body, Header.Name);
            '2':
                Body := STRSUBSTNO(Body, Header.Name);
        END;
    end;

    procedure GetEmailAddressStanbic();
    var
        UserSetup: Record "User Setup";
        ClientSetup: Record "Insurance setup";
    begin
        ClientSetup.GET;
        SenderAddress := ClientSetup."Company Default Email";
        FromUser := ClientSetup."Company Default Email";
    end;

    procedure RenewalSMSNotification(InsureLines: Record "Insure Lines"; InsureHeader: Record "Insure Header");
    var
        DayMonth: Code[10];
        //MessageTypeRec: Record "Notification Template";
        FullMessage: Text[250];
        UserSetup: Record "User Setup";
        SMTP: Codeunit "SMTP Mail";
        Client: Record Customer;
    begin

        /* //ClientSetup.GET;
        MessageTypeRec.RESET;
        MessageTypeRec.SETRANGE(MessageTypeRec.Type, MessageTypeRec.Type::"Renewal Notice");
        IF MessageTypeRec.FIND('-') THEN BEGIN

            //AppMngtNotification.FillLeaveTemplate(Client);
            FullMessage := STRSUBSTNO(MessageTypeRec."SMS MESSAGE", InsureLines."Registration No.", InsureHeader."To Date");
            //CreateSMS(Client."Mobile 1",FullMessage);
            IF Client.GET(InsureHeader."Insured No.") THEN
                InsertSMStoVendorDB(Client.Mobile, FullMessage);

        END
        ELSE
            ERROR('Notification message for Application confirmation..Not set'); */
    end;

    procedure SendRenewalNotificationMail(Insurelines: Record "Insure Lines"; InsureHeader: Record "Insure Header");
    var
        //SNN
        ////////////MessageTypeRec: Record "Notification Template";
        //Text040: ;
        Client: Record Customer;
    begin
        /* MessageTypeRec.RESET;
        MessageTypeRec.SETRANGE(MessageTypeRec.Type, MessageTypeRec.Type::"Renewal Notice");
        IF MessageTypeRec.FIND('+') THEN BEGIN

            SetTemplateMessageType(MessageTypeRec);

        END;

        MessageTypeRec.CALCFIELDS(MessageTypeRec."Notification Body");
        IF NOT MessageTypeRec."Notification Body".HASVALUE THEN
            ERROR(Text040);
        MessageTypeRec."Notification Body".CREATEINSTREAM(InStreamTemplate);

        Subject := MessageTypeRec.Description;
        Body := ''; // Text013;
        IF Client.GET(InsureHeader."Insured No.") THEN
            Recipient := Client."E-Mail";
        SMTP.CreateMessage(SenderName, SenderAddress, Recipient, Subject, Body, TRUE);
        Body := '';

        WHILE InStreamTemplate.EOS() = FALSE DO BEGIN
            InStreamTemplate.READTEXT(InSReadChar, 1);
            IF InSReadChar = '%' THEN BEGIN
                SMTP.AppendBody(Body);
                Body := InSReadChar;
                IF InStreamTemplate.READTEXT(InSReadChar, 1) <> 0 THEN;
                IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN BEGIN
                    Body := Body + '1';
                    CharNo := InSReadChar;
                    WHILE (InSReadChar >= '0') AND (InSReadChar <= '9') DO BEGIN
                        IF InStreamTemplate.READTEXT(InSReadChar, 1) <> 0 THEN;
                        IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN
                            CharNo := CharNo + InSReadChar;
                    END;
                END ELSE
                    Body := Body + InSReadChar;
                FillRenewalTemplate(Body, CharNo, InsureHeader);
                SMTP.AppendBody(Body);
                Body := InSReadChar;
            END ELSE BEGIN
                Body := Body + InSReadChar;
                I := I + 1;
                IF I = 500 THEN BEGIN
                    SMTP.AppendBody(Body);
                    Body := '';
                    I := 0;
                END;
            END;
        END;
        SMTP.AppendBody(Body);
        SMTP.Send; */
    end;

    procedure FillRenewalTemplate(var Body: Text[254]; TextNo: Text[30]; Header: Record "Insure Header");
    var
        BirthdateTxt: Text[30];
        TodaysText: Text[30];
    begin
        CASE TextNo OF
            '1':
                Body := STRSUBSTNO(Body, Header."Insured Name");
            '2':
                Body := STRSUBSTNO(Body, Header."To Date");
        END;
    end;

    procedure MissingDocumentsSMSNotification(InsDocs: Record "Insurance Documents");
    var
        DayMonth: Code[10];
        //MessageTypeRec: Record "Notification Template";
        FullMessage: Text[250];
        UserSetup: Record "User Setup";
        SMTP: Codeunit "SMTP Mail";
        Client: Record Customer;
        claimrec: Record Claim;
        Insheader: Record "Insure Header";
    begin

        //ClientSetup.GET;
        /* MessageTypeRec.RESET;
        MessageTypeRec.SETRANGE(MessageTypeRec.Type, MessageTypeRec.Type::"Outstanding Documentation");
        IF MessageTypeRec.FIND('-') THEN BEGIN

            //AppMngtNotification.FillLeaveTemplate(Client);
            FullMessage := STRSUBSTNO(MessageTypeRec."SMS MESSAGE", InsDocs."Document Name", InsDocs."Date Required");
            //CreateSMS(Client."Mobile 1",FullMessage);
            IF InsDocs."Document Type" = InsDocs."Document Type"::claim THEN BEGIN
                IF claimrec.GET(InsDocs."Document No") THEN
                    IF Client.GET(claimrec.Insured) THEN
                        InsertSMStoVendorDB(Client.Mobile, FullMessage);
            END;

            IF InsDocs."Document Type" <> InsDocs."Document Type"::claim THEN BEGIN
                IF Insheader.GET(InsDocs."Document Type", InsDocs."Document No") THEN
                    IF Client.GET(Insheader."Insured No.") THEN
                        InsertSMStoVendorDB(Client.Mobile, FullMessage);
            END;
        END
        ELSE
            ERROR('Notification message for Application confirmation..Not set'); */
    end;

    procedure SendMissingDocumentsNotificationMail(InsDocs: Record "Insurance Documents");
    var
        //SNN
        ////////////MessageTypeRec: Record "Notification Template";
        //Text040: ;
        Client: Record Customer;
        ClaimRec: Record Claim;
        Insheader: Record "Insure Header";
    begin
        /* MessageTypeRec.RESET;
        MessageTypeRec.SETRANGE(MessageTypeRec.Type, MessageTypeRec.Type::"Renewal Notice");
        IF MessageTypeRec.FIND('+') THEN BEGIN

            SetTemplateMessageType(MessageTypeRec);

        END;

        MessageTypeRec.CALCFIELDS(MessageTypeRec."Notification Body");
        IF NOT MessageTypeRec."Notification Body".HASVALUE THEN
            ERROR(Text040);
        MessageTypeRec."Notification Body".CREATEINSTREAM(InStreamTemplate);

        Subject := MessageTypeRec.Description;
        Body := ''; // Text013;
        IF Insheader.GET(InsDocs."Document Type", InsDocs."Document No") THEN BEGIN
            IF Client.GET(Insheader."Insured No.") THEN
                Recipient := Client."E-Mail";
        END;
        IF InsDocs."Document Type" = InsDocs."Document Type"::claim THEN BEGIN
            IF ClaimRec.GET(InsDocs."Document No") THEN
                IF Client.GET(ClaimRec.Insured) THEN
                    Recipient := Client."E-Mail";
        END;


        SMTP.CreateMessage(SenderName, SenderAddress, Recipient, Subject, Body, TRUE);
        Body := '';

        WHILE InStreamTemplate.EOS() = FALSE DO BEGIN
            InStreamTemplate.READTEXT(InSReadChar, 1);
            IF InSReadChar = '%' THEN BEGIN
                SMTP.AppendBody(Body);
                Body := InSReadChar;
                IF InStreamTemplate.READTEXT(InSReadChar, 1) <> 0 THEN;
                IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN BEGIN
                    Body := Body + '1';
                    CharNo := InSReadChar;
                    WHILE (InSReadChar >= '0') AND (InSReadChar <= '9') DO BEGIN
                        IF InStreamTemplate.READTEXT(InSReadChar, 1) <> 0 THEN;
                        IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN
                            CharNo := CharNo + InSReadChar;
                    END;
                END ELSE
                    Body := Body + InSReadChar;
                FillMissingDocslTemplate(Body, CharNo, InsDocs);
                SMTP.AppendBody(Body);
                Body := InSReadChar;
            END ELSE BEGIN
                Body := Body + InSReadChar;
                I := I + 1;
                IF I = 500 THEN BEGIN
                    SMTP.AppendBody(Body);
                    Body := '';
                    I := 0;
                END;
            END;
        END;
        SMTP.AppendBody(Body);
        SMTP.Send; */
    end;

    procedure FillMissingDocslTemplate(var Body: Text[254]; TextNo: Text[30]; Header: Record "Insurance Documents");
    var
        BirthdateTxt: Text[30];
        TodaysText: Text[30];
    begin
        CASE TextNo OF
            '1':
                Body := STRSUBSTNO(Body, Header."Document Name");
            '2':
                Body := STRSUBSTNO(Body, Header."Date Required");
        END;
    end;

    /*procedure HolidaySMSNotification(ClientRec: Record Customer; NotificationTemplate: Record "Notification Template");
    var
        DayMonth: Code[10];
        MessageTypeRec: Record "Notification Template";
        FullMessage: Text[250];
        UserSetup: Record "User Setup";
        SMTP: Codeunit "SMTP Mail";
        Client: Record Customer;
        claimrec: Record Claim;
        Insheader: Record "Insure Header";
    begin

        ClientSetup.GET;
        MessageTypeRec.RESET;
        MessageTypeRec.SETRANGE(MessageTypeRec.Type,MessageTypeRec.Type::Holiday);
        IF MessageTypeRec.FIND('-') THEN
        BEGIN

        AppMngtNotification.FillLeaveTemplate(Client);
        FullMessage := STRSUBSTNO(NotificationTemplate."SMS MESSAGE", ClientRec.Name);
        CreateSMS(Client."Mobile 1",FullMessage);



        InsertSMStoVendorDB(ClientRec.Mobile, FullMessage);



        END
        ELSE
        ERROR('Notification message for Application confirmation..Not set');

    end;*/

    /*procedure HolidayNotificationMail(ClientRec: Record Customer; NotifyTemplate: Record "Notification Template");
    var
        //SNN
        ////////////MessageTypeRec: Record "Notification Template";
        //Text040: ;
        Client: Record Customer;
        ClaimRec: Record Claim;
        Insheader: Record "Insure Header";
    begin
        MessageTypeRec.COPY(NotifyTemplate);
        SetTemplateMessageType(MessageTypeRec);



        MessageTypeRec.CALCFIELDS(MessageTypeRec."Notification Body");
        IF NOT MessageTypeRec."Notification Body".HASVALUE THEN
            ERROR(Text040);
        MessageTypeRec."Notification Body".CREATEINSTREAM(InStreamTemplate);

        Subject := MessageTypeRec.Description;
        Body := ''; // Text013;

        Recipient := ClientRec."E-Mail";


        SMTP.CreateMessage(SenderName, SenderAddress, Recipient, Subject, Body, TRUE);
        Body := '';

        WHILE InStreamTemplate.EOS() = FALSE DO BEGIN
            InStreamTemplate.READTEXT(InSReadChar, 1);
            IF InSReadChar = '%' THEN BEGIN
                SMTP.AppendBody(Body);
                Body := InSReadChar;
                IF InStreamTemplate.READTEXT(InSReadChar, 1) <> 0 THEN;
                IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN BEGIN
                    Body := Body + '1';
                    CharNo := InSReadChar;
                    WHILE (InSReadChar >= '0') AND (InSReadChar <= '9') DO BEGIN
                        IF InStreamTemplate.READTEXT(InSReadChar, 1) <> 0 THEN;
                        IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN
                            CharNo := CharNo + InSReadChar;
                    END;
                END ELSE
                    Body := Body + InSReadChar;
                FillHolidayDocslTemplate(Body, CharNo, ClientRec);
                SMTP.AppendBody(Body);
                Body := InSReadChar;
            END ELSE BEGIN
                Body := Body + InSReadChar;
                I := I + 1;
                IF I = 500 THEN BEGIN
                    SMTP.AppendBody(Body);
                    Body := '';
                    I := 0;
                END;
            END;
        END;
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;*/

    procedure FillHolidayDocslTemplate(var Body: Text[254]; TextNo: Text[30]; Header: Record Customer);
    var
        BirthdateTxt: Text[30];
        TodaysText: Text[30];
    begin
        CASE TextNo OF
            '1':
                Body := STRSUBSTNO(Body, Header.Name);
        //'2': Body := STRSUBSTNO(Body,Header."Date Required");
        END;
    end;

    procedure SendImprestNotificationMail(Imprest: Record "Request Header");
    var
        //SNN
        ////////////MessageTypeRec: Record "Notification Template";
        //Text040: ;
        cashsetup: Record "Cash Management Setup";
        Client: Record Customer;
    begin
        /*MessageTypeRec.RESET;
        MessageTypeRec.SETRANGE(MessageTypeRec.Type, MessageTypeRec.Type::"Imprest Accounting");
        IF MessageTypeRec.FIND('+') THEN BEGIN

            SetTemplateMessageType(MessageTypeRec);

        END;

        MessageTypeRec.CALCFIELDS(MessageTypeRec."Notification Body");
        IF NOT MessageTypeRec."Notification Body".HASVALUE THEN
            ERROR(Text040);
        MessageTypeRec."Notification Body".CREATEINSTREAM(InStreamTemplate);

        Subject := MessageTypeRec.Description;
        Body := ''; // Text013;
        IF Client.GET(Imprest."Customer A/C") THEN
            Recipient := Client."E-Mail";
        SMTP.CreateMessage(SenderName, SenderAddress, Recipient, Subject, Body, TRUE);
        Body := '';

        WHILE InStreamTemplate.EOS() = FALSE DO BEGIN
            InStreamTemplate.READTEXT(InSReadChar, 1);
            IF InSReadChar = '%' THEN BEGIN
                SMTP.AppendBody(Body);
                Body := InSReadChar;
                IF InStreamTemplate.READTEXT(InSReadChar, 1) <> 0 THEN;
                IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN BEGIN
                    Body := Body + '1';
                    CharNo := InSReadChar;
                    WHILE (InSReadChar >= '0') AND (InSReadChar <= '9') DO BEGIN
                        IF InStreamTemplate.READTEXT(InSReadChar, 1) <> 0 THEN;
                        IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN
                            CharNo := CharNo + InSReadChar;
                    END;
                END ELSE
                    Body := Body + InSReadChar;
                FillImprestReturnTemplate(Body, CharNo, Imprest);
                SMTP.AppendBody(Body);
                Body := InSReadChar;
            END ELSE BEGIN
                Body := Body + InSReadChar;
                I := I + 1;
                IF I = 500 THEN BEGIN
                    SMTP.AppendBody(Body);
                    Body := '';
                    I := 0;
                END;
            END;
        END;*/
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;

    procedure FillImprestReturnTemplate(var Body: Text[254]; TextNo: Text[30]; Header: Record "Request Header");
    var
        BirthdateTxt: Text[30];
        TodaysText: Text[30];
    begin
        CASE TextNo OF
            '1':
                Body := STRSUBSTNO(Body, Header."Employee Name");
        //'2':
        //Body := STRSUBSTNO(Body, Header."Deadline for Imprest Return");
        END;
    end;

    procedure PrecheckInsureHeader(var InsureHeader: Record "Insure Header");
    begin
        CheckValidity(InsureHeader);
        InsureHeader.TESTFIELD(InsureHeader."Policy Type");
        InsureHeader.TESTFIELD(InsureHeader."From Date");
        InsureHeader.TESTFIELD(InsureHeader."To Date");
        InsureHeader.TESTFIELD(InsureHeader."Cover Start Date");
        InsureHeader.TESTFIELD(InsureHeader."Cover End Date");
        InsureHeader.TESTFIELD(InsureHeader."No. Of Instalments");
        InsureHeader.TESTFIELD(InsureHeader."Agent/Broker");
        IF EndorsementType.GET(InsureHeader."Endorsement Type") THEN
            IF EndorsementType."Requires Cancellation Reason" THEN
                IF InsureHeader."Cancellation Reason" = '' THEN
                    ERROR('Please select a cancellation/Endorsment reason');

        InsuranceDocs.RESET;
        InsuranceDocs.SETRANGE(InsuranceDocs."Document Type", InsureHeader."Document Type");
        InsuranceDocs.SETRANGE(InsuranceDocs."Document No", InsureHeader."No.");
        IF InsuranceDocs.FINDFIRST THEN
            REPEAT
                //MESSAGE('%1 and %2',InsuranceDocs."Document Type",InsuranceDocs."Document No");
                IF ((InsuranceDocs.Required = TRUE) AND (InsuranceDocs.Received = FALSE)) THEN
                    ERROR('Document %1 is required and has not been indicated as received please check if the document is available before proceeding', InsuranceDocs."Document Name");

            UNTIL InsuranceDocs.NEXT = 0;
        // Bkk -removed to facilitate direct Business InsureHeader.TESTFIELD(InsureHeader."Agent/Broker");
    end;

    procedure TransferAmicableSettlemnt2Reserve(var ClaimReport: Record "Claim Letters");
    var
        ClaimReserveHeader: Record "Claim Reservation Header";
        ClaimReserveLines: Record "Claim Reservation Line";
        ClaimReportLines: Record "Claim Report lines";
        Losstype: Record "Loss Type";
    begin

        ClaimReserveHeader.INIT;
        ClaimReserveHeader."No." := '';
        ClaimReserveHeader."Document Date" := WORKDATE;
        ClaimReserveHeader."Creation Date" := WORKDATE;
        ClaimReserveHeader."Creation Time" := TIME;
        ClaimReserveHeader."Claim No." := ClaimReport."Claim No.";
        ClaimReserveHeader.VALIDATE(ClaimReserveHeader."Claim No.");
        ClaimReserveHeader."Claimant ID" := ClaimReport."Claimant ID";
        ClaimReserveHeader.VALIDATE(ClaimReserveHeader."Claimant ID");
        ClaimReserveHeader."Revised Reserve Link" := ClaimReport."Reserve Link";
        //ClaimReserveHeader."Insurance Class":=claimreport."Policy Type";
        ClaimReserveHeader.INSERT(TRUE);

        ClaimReserveLines.INIT;
        ClaimReserveLines."Claim Reservation No." := ClaimReserveHeader."No.";
        ClaimReserveLines."Claim No." := ClaimReserveHeader."Claim No.";
        ClaimReserveLines."Line No." := ClaimReserveLines."Line No." + 10000;
        //IF Losstype.GET(ClaimInvolvedParties."Loss Type") THEN
        ClaimReserveLines.Description := 'Amicable settlement';
        ClaimReserveLines."Reserved Amount" := ClaimReport."Agreed Settlement Amount";
        IF ClaimReserveLines."Reserved Amount" <> 0 THEN
            ClaimReserveLines.INSERT;



        //PostClaimsReserve(ClaimReserveHeader);
    end;

    procedure TransferLegalDecision2Payment(var ClaimReserve: Record "Legal Diary");
    var
        PV: Record Payments1;
        PVLines: Record "PV Lines1";
        ClaimReserveLines: Record "Claim Reservation lines";
        Losstype: Record "Loss Type";
        ReceiptPaymentTypes: Record "Receipts and Payment Types";
        Cases: Record Litigations;
    begin
        //ClaimReserve.CALCFIELDS(ClaimReserve."Reserve Amount");
        ReceiptPaymentTypes.RESET;
        ReceiptPaymentTypes.SETRANGE(ReceiptPaymentTypes."Insurance Trans Type", ReceiptPaymentTypes."Insurance Trans Type"::"Claim Payment");
        IF ReceiptPaymentTypes.FINDFIRST THEN BEGIN


            PV.INIT;
            PV.No := '';
            PV.Date := WORKDATE;
            PV.Type := ReceiptPaymentTypes.Code;

            //ClaimReserveHeader."Insurance Class":=claimreport."Policy Type";
            PV.INSERT(TRUE);

            PVLines.INIT;
            PVLines."PV No" := PV.No;
            PVLines."Line No" := PVLines."Line No" + 10000;
            PVLines.Amount := ClaimReserve."Amount awarded";
            PVLines.Description := 'Court settlement';
            IF Cases.GET(ClaimReserve."Case No.") THEN BEGIN
                PVLines."Claim No" := Cases."Claim No.";
                PVLines."Claimant ID" := Cases."Claimant ID";

            END;


            PVLines.INSERT(TRUE);


        END
        ELSE
            ERROR('Please setup a claim payment option on Receipts and payments setup');
        //PostClaimsReserve(ClaimReserveHeader);
    end;

    procedure CalculateAnnuityPP(var Periodic_Amount: Decimal; var Interest_rate: Decimal; var Age: Integer; var Gender: Option " ",Male,Female; var Guaranteed_Period: Integer; var NoOfInstalments: Integer) PP: Decimal;
    var
        AnnuityRate: Decimal;
        AnnuityRateTable: Record "Annuity Rates";
    begin

        PP := (Periodic_Amount * NoOfInstalments) * GetAnnuityRate(Interest_rate, Age, Gender, Guaranteed_Period, NoOfInstalments);

    end;

    procedure GetAnnuityRate(var Interest_rate: Decimal; var Age: Integer; var Gender: Option " ",Male,Female; var Guaranteed_Period: Integer; var NoOfInstalments: Integer) Annuity_Rate: Decimal;
    var
        AnnuityRateTable: Record "Annuity Rates";
    begin
        AnnuityRateTable.RESET;
        AnnuityRateTable.SETRANGE(AnnuityRateTable."Guarantee Years", Guaranteed_Period);
        AnnuityRateTable.SETRANGE(AnnuityRateTable."Retire Age", Age);
        AnnuityRateTable.SETRANGE(AnnuityRateTable.Interest, Interest_rate);
        IF AnnuityRateTable.FINDLAST THEN BEGIN
            IF Gender = Gender::Male THEN
                Annuity_Rate := AnnuityRateTable."Male Rate" / AnnuityRateTable.Denominator;
            IF Gender = Gender::Female THEN
                Annuity_Rate := AnnuityRateTable."Female Rate" / AnnuityRateTable.Denominator;

        END;
        EXIT(Annuity_Rate);
    end;

    procedure CalculateAnnuityPeriodic_GrossPay(var PP: Decimal; var Interest_rate: Decimal; var Age: Integer; var Gender: Option " ",Male,Female; var Guaranteed_Period: Integer; var NoOfInstalments: Integer) PeriodicGross_Pay: Decimal;
    var
        AnnuityRate: Decimal;
        AnnuityRateTable: Record "Annuity Rates";
    begin

        PeriodicGross_Pay := PP * GetAnnuityRate(Interest_rate, Age, Gender, Guaranteed_Period, NoOfInstalments) / NoOfInstalments;

    end;
}

