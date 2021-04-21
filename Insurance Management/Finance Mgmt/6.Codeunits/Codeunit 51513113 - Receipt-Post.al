codeunit 51513113 "Receipt-Post"
{
    // version CSHBK


    trigger OnRun()
    begin
    end;

    var
        CMSetup: Record "Cash Management Setup";
        ReceiptType: Record 51511002;
        PaymodeRec: Record 51511006;
        RcptLedgerPrint: Record 271;
        NoSeriesMgt: Codeunit 396;
        ReversalEntry: Record 179;


    procedure PostReceipt(RptHeader: Record 51513110)
    var
        GenJnLine: Record 81;
        RcptLine: Record 51513111;
        LineNo: Integer;
        Batch: Record 232;
        GLEntry: Record 17;
        CoInsureReinsureBrokerLines: Record "Coinsurance Reinsurance lines";
        PolicyType: Record "Underwriter Policy Types";
        InsureHeader: Record "Insure Debit Note";
        DimensionSetEntryRec: Record "Dimension Set Entry";
        DimensionSetEntryRecCopy: record "Dimension Set Entry";
        Cust: Record Customer;
        Vend: Record Vendor;
        Isetup: record "Insurance Setup";
        VATPostingSetup: record "VAT Posting Setup";
    begin


        IF CONFIRM('Are you sure you want to post the receipt no ' + RptHeader."No." + ' ?') = TRUE THEN BEGIN

            IF RptHeader.Posted THEN
                ERROR('The Receipt has been posted');

            //RptHeader.TESTFIELD("Account No.");
            RptHeader.TESTFIELD("Pay Mode");
            // RptHeader.TESTFIELD("Paid in By");
            // RptHeader.TESTFIELD("Receipt Date");

            IF RptHeader."Pay Mode" = 'CHEQUE' THEN BEGIN
                RptHeader.TESTFIELD("Cheque No");
                RptHeader.TESTFIELD("Cheque Date");
            END;

            IF PaymodeRec.GET(RptHeader."Pay Mode") THEN BEGIN
                IF PaymodeRec.Electronic THEN BEGIN
                    RptHeader.TESTFIELD(RptHeader."REF NO.");

                END;
            END;

            CMSetup.GET();
            RptHeader."Receipt No." := NoSeriesMgt.GetNextNo(RptHeader."Posting No. Series", RptHeader."Receipt Date", TRUE);
            //MESSAGE('Receipt number=%1',RptHeader."Receipt No.");
            // Delete Lines Present on the General Journal Line
            GenJnLine.RESET;
            GenJnLine.SETRANGE(GenJnLine."Journal Template Name", CMSetup."Receipt Template");
            GenJnLine.SETRANGE(GenJnLine."Journal Batch Name", RptHeader."No.");
            GenJnLine.DELETEALL;

            Batch.INIT;
            IF CMSetup.GET() THEN
                Batch."Journal Template Name" := CMSetup."Receipt Template";
            Batch.Name := RptHeader."No.";
            IF NOT Batch.GET(Batch."Journal Template Name", Batch.Name) THEN
                Batch.INSERT;

            //Post Bank entries
            RptHeader.CALCFIELDS(RptHeader."Total Amount");
            LineNo := LineNo + 1000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
            GenJnLine."Journal Batch Name" := RptHeader."No.";
            GenJnLine."Line No." := LineNo;
            GenJnLine."Account Type" := GenJnLine."Account Type"::"Bank Account";
            GenJnLine."Account No." := RptHeader."Bank Code";
            GenJnLine.VALIDATE("Account No.");
            GenJnLine."Receipt and Payment Type" := RptHeader."Receipt Type";
            //GenJnLine."Document Type" := GenJnLine."Document Type"::Payment;
            GenJnLine."Posting Date" := RptHeader."Receipt Date";
            //GenJnLine."Document No.":=RptHeader."No.";
            GenJnLine."Document No." := RptHeader."Receipt No.";
            GenJnLine.Description := RptHeader."Received From";
            GenJnLine.Amount := RptHeader."Total Amount";
            GenJnLine.VALIDATE(GenJnLine.Amount);

            GenJnLine."External Document No." := RptHeader."Cheque No";
            IF GenJnLine."External Document No." = '' THEN
                GenJnLine."External Document No." := RptHeader."REF NO.";
            GenJnLine."Currency Code" := RptHeader."Currency Code";
            GenJnLine.VALIDATE(GenJnLine."Currency Code");
            //RptHeader."Receipt Type":=RptHeader."Receipt Type";
            IF RptHeader."Pay Mode" = 'CHEQUE' THEN
                GenJnLine."Document Date" := RptHeader."Cheque Date";
            GenJnLine."Receipt and Payment Type" := RptHeader."Receipt Type";
            GenJnLine."Shortcut Dimension 1 Code" := RptHeader."Global Dimension 1 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code" := RptHeader."Global Dimension 2 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");

            IF GenJnLine.Amount <> 0 THEN
                GenJnLine.INSERT;


            //Post the receipt lines
            RcptLine.RESET;
            RcptLine.SETRANGE(RcptLine."Receipt No.", RptHeader."No.");
            IF RcptLine.FINDFIRST THEN BEGIN
                REPEAT
                    IF RcptLine.Amount <> 0 THEN BEGIN
                        IF ReceiptType.GET(RptHeader."Receipt Type", ReceiptType.Type::Receipt) THEN BEGIN
                            IF ReceiptType."Policy No. Mandatory" THEN
                                IF RcptLine."Policy No." = '' THEN
                                    ERROR('Policy No. must be selected for %1 receipt type', RptHeader."Receipt Type");

                            IF ReceiptType."Claim No. Mandatory" THEN
                                IF RcptLine."Claim No." = '' THEN
                                    ERROR('Claim No. must be selected for %1 receipt type', RptHeader."Receipt Type");

                            IF ReceiptType."Claimant ID. Mandatory" THEN
                                IF RcptLine."Claimant ID" = 0 THEN
                                    ERROR('Claimant ID must be selected for %1 receipt type', RptHeader."Receipt Type");
                            IF ReceiptType."Loan No. Mandatory" THEN
                                IF RcptLine."Loan No" = '' THEN
                                    ERROR('Loan No must be selected for %1 receipt type', RptHeader."Receipt Type");

                            IF ReceiptType."Debit Note Mandatory" THEN
                                IF RcptLine."Applies to Doc. No" = '' THEN
                                    ERROR('Applies to Doc. No Must have a value for %1 receipt type', RptHeader."Receipt Type");
                        END;

                    END;
                    //END;
                    RcptLine.VALIDATE(Amount);
                    LineNo := LineNo + 1000;
                    GenJnLine.INIT;
                    GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                    GenJnLine."Journal Batch Name" := RptHeader."No.";
                    GenJnLine."Line No." := LineNo;
                    GenJnLine."Account Type" := RcptLine."Account Type";
                    /* IF RcptLine."Account Type"=RcptLine."Account Type"::Vendor THEN
                       GenJnLine."Document Type":=GenJnLine."Document Type"::" " ELSE
                      GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;*/
                    GenJnLine."Account No." := RcptLine."Account No.";
                    // GenJnLine.VALIDATE(GenJnLine."Account No.");
                    GenJnLine."Posting Date" := RptHeader."Receipt Date";
                    //GenJnLine."Document No.":=RptHeader."No.";
                    GenJnLine."Document No." := RptHeader."Receipt No.";
                    GenJnLine.Description := COPYSTR(RcptLine.Description + '' + RcptLine."Account Name", 1, 50);
                    GenJnLine.Amount := -RcptLine.Amount;
                    //message('%1',GenJnLine.Amount);
                    GenJnLine."External Document No." := RptHeader."Cheque No";
                    // GenJnLine."Applies-to Doc. Type":=RcptLine."Applies-to Doc. Type"::Invoice;
                    GenJnLine."Applies-to Doc. No." := RcptLine."Applies to Doc. No";
                    GenJnLine."Currency Code" := RptHeader."Currency Code";
                    GenJnLine.VALIDATE(GenJnLine."Currency Code");
                    GenJnLine."Shortcut Dimension 1 Code" := RcptLine."Global Dimension 1 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                    GenJnLine."Shortcut Dimension 2 Code" := RcptLine."Global Dimension 2 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");

                    GenJnLine."Shortcut Dimension 3 Code" := RcptLine."Global Dimension 3 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                    GenJnLine."Shortcut Dimension 4 Code" := RcptLine."Global Dimension 4 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                    //GenJnLine."UnderWriter ID":=RcptLine.Insurer;
                    //GenJnLine."Document Type" := GenJnLine."Document Type"::Payment;
                    GenJnLine."Loan No" := RcptLine."Loan No";
                    //GenJnLine."Investment Code":=RcptLine."Investme";
                    GenJnLine."Period Reference" := RcptLine."Reference Period";
                    GenJnLine."Claim No." := RcptLine."Claim No.";
                    GenJnLine."Claimant ID" := RcptLine."Claimant ID";
                    GenJnLine."Policy No" := RcptLine."Policy No.";
                    GenJnLine."Receipt and Payment Type" := RptHeader."Receipt Type";
                    GenJnLine."Insured ID" := RcptLine."Insured ID";
                    GenJnLine."Endorsement No." := RcptLine."Endorsement Policy No.";
                    GenJnLine."Policy Type" := RcptLine."Policy Type";

                    IF ReceiptType.GET(RptHeader."Receipt Type", 1) THEN BEGIN
                        GenJnLine."Insurance Trans Type" := ReceiptType."Insurance Trans Type";

                    END;
                    //GenJnLine."Insurance Trans Type":=RcptLine."Transaction Type"
                    IF GenJnLine.Amount <> 0 THEN
                        GenJnLine.INSERT;

                    //BKk 26.03.2021
                    IF InsureHeader.GET(RcptLine."Applies to Doc. No") then begin
                        IF PolicyType.GET(InsureHeader."Policy Type", InsureHeader.Underwriter) THEN
                            ;
                        CoInsureReinsureBrokerLines.RESET;
                        // CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."Document Type", InsureHeader."Document Type");
                        CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."No.", RcptLine."Applies to Doc. No");
                        IF CoInsureReinsureBrokerLines.FINDFIRST THEN
                            REPEAT

                                IF CoInsureReinsureBrokerLines."Transaction Type" = CoInsureReinsureBrokerLines."Transaction Type"::"Broker " THEN BEGIN
                                    IF PolicyType."Commission Calculation Basis" = PolicyType."Commission Calculation Basis"::" Paid Business" THEN BEGIN
                                        IF CoInsureReinsureBrokerLines."Partner No." <> InsureHeader.Underwriter then begin
                                            GenJnLine.INIT;
                                            GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                                            GenJnLine."Journal Batch Name" := RptHeader."No.";
                                            GenJnLine."Line No." := GenJnLine."Line No." + 10000;
                                            GenJnLine."Posting Date" := RptHeader."Receipt Date";
                                            GenJnLine."Document No." := RptHeader."No.";
                                            GenJnLine."Account Type" := GenJnLine."Account Type"::Vendor;
                                            GenJnLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                                            // MESSAGE('Broker =%1',InsureHeader."Agent/Broker");
                                            //GenJnLine."Document Type":=GenJnLine."Document Type"::Invoice;
                                            GenJnLine.VALIDATE(GenJnLine."Account No.");
                                            GenJnLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", Rcptline."Policy No."), 1, 50);
                                            //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                                            GenJnLine.Amount := -CoInsureReinsureBrokerLines."Broker Commission";
                                            //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                                            //  GenJnLine.Amount := CoInsureReinsureBrokerLines."Broker Commission";
                                            GenJnLine.VALIDATE(GenJnLine.Amount);
                                            /*GenJnLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                                            GenJnLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");*/
                                            GenJnLine."Effective Start Date" := InsureHeader."Cover Start Date";
                                            GenJnLine."Effective End Date" := InsureHeader."Cover End Date";
                                            GenJnLine."Insured ID" := InsureHeader."Insured No.";

                                            GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::Commission;
                                            GenJnLine."Policy No" := RcptLine."Policy No.";
                                            IF InsureHeader."Endorsement Policy No." = '' THEN
                                                GenJnLine."Endorsement No." := RcptLine."Policy No."
                                            ELSE
                                                GenJnLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                                            GenJnLine."Policy Type" := InsureHeader."Policy Type";
                                            GenJnLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                                            GenJnLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                                            GenJnLine."Endorsement Type" := InsureHeader."Endorsement Type";
                                            GenJnLine."Action Type" := InsureHeader."Action Type";
                                            GenJnLine."Bal. Account Type" := GenJnLine."Bal. Account Type"::"G/L Account";
                                            IF PolicyType.GET(InsureHeader."Policy Type", InsureHeader.Underwriter) THEN
                                                IF PolicyType."Account No" <> '' THEN
                                                    GenJnLine."Bal. Account No." := PolicyType."Account No"
                                                ELSE
                                                    ERROR('Please Define account for commission for Product %1 and Underwriter %2', InsureHeader."Policy Type",
                                                    InsureHeader."Underwriter");
                                            GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                                            IF GenJnLine.Amount <> 0 THEN
                                                GenJnLine.INSERT;

                                            DimensionSetEntryRec.RESET;
                                            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                                            IF DimensionSetEntryRec.FINDFIRST THEN
                                                REPEAT

                                                    DimensionSetEntryRecCopy.INIT;
                                                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnLine."Dimension Set ID";
                                                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                                        DimensionSetEntryRecCopy.INSERT;
                                                //MESSAGE('Dimension =%1 Value=%2 Set ID=%3',DimensionSetEntryRecCopy."Dimension Code",DimensionSetEntryRecCopy."Dimension Value Code",GenJnLine."Dimension Set ID");
                                                UNTIL DimensionSetEntryRec.NEXT = 0;

                                            GenJnLine.INIT;
                                            GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                                            GenJnLine."Journal Batch Name" := RptHeader."No.";
                                            GenJnLine."Line No." := GenJnLine."Line No." + 10000;
                                            GenJnLine."Posting Date" := RptHeader."Receipt Date";
                                            GenJnLine."Document No." := RptHeader."No.";
                                            GenJnLine."Account Type" := GenJnLine."Account Type"::Vendor;
                                            GenJnLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                                            //GenJnLine."Document Type":=GenJnLine."Document Type"::Invoice;
                                            GenJnLine.VALIDATE(GenJnLine."Account No.");
                                            GenJnLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", Rcptline."Policy No."), 1, 50);
                                            //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                                            GenJnLine.Amount := CoInsureReinsureBrokerLines."WHT Amount";
                                            //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                                            //  GenJnLine.Amount := -CoInsureReinsureBrokerLines."WHT Amount";
                                            GenJnLine.VALIDATE(GenJnLine.Amount);
                                            /*GenJnLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                                            GenJnLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");*/
                                            GenJnLine."Effective Start Date" := InsureHeader."Cover Start Date";
                                            GenJnLine."Effective End Date" := InsureHeader."Cover End Date";
                                            GenJnLine."Insured ID" := InsureHeader."Insured No.";

                                            GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::Wht;
                                            GenJnLine."Policy No" := RcptLine."Policy No.";
                                            IF InsureHeader."Endorsement Policy No." = '' THEN
                                                GenJnLine."Endorsement No." := RcptLine."Policy No."
                                            ELSE
                                                GenJnLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                                            GenJnLine."Policy Type" := InsureHeader."Policy Type";
                                            GenJnLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                                            GenJnLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                                            GenJnLine."Endorsement Type" := InsureHeader."Endorsement Type";
                                            GenJnLine."Action Type" := InsureHeader."Action Type";

                                            GenJnLine."Bal. Account Type" := GenJnLine."Bal. Account Type"::"G/L Account";
                                            IF vend.GET(CoInsureReinsureBrokerLines."Partner No.") THEN
                                                IF VATPostingSetup.GET(Vend."VAT Bus. Posting Group", Isetup."Default WHT Code") THEN
                                                    GenJnLine."Bal. Account No." := VATPostingSetup."Sales VAT Account";
                                            IF GenJnLine.Amount <> 0 THEN
                                                GenJnLine.INSERT;

                                            DimensionSetEntryRec.RESET;
                                            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                                            IF DimensionSetEntryRec.FINDFIRST THEN
                                                REPEAT

                                                    DimensionSetEntryRecCopy.INIT;
                                                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnLine."Dimension Set ID";
                                                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                                        DimensionSetEntryRecCopy.INSERT;
                                                UNTIL DimensionSetEntryRec.NEXT = 0;
                                        end;
                                        IF CoInsureReinsureBrokerLines."Partner No." = InsureHeader.Underwriter then begin
                                            GenJnLine.INIT;
                                            GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                                            GenJnLine."Journal Batch Name" := RptHeader."No.";
                                            GenJnLine."Line No." := GenJnLine."Line No." + 10000;
                                            GenJnLine."Posting Date" := RptHeader."Receipt Date";
                                            GenJnLine."Document No." := RptHeader."No.";
                                            GenJnLine."Account Type" := GenJnLine."Account Type"::Vendor;
                                            GenJnLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                                            // MESSAGE('Broker =%1',InsureHeader."Agent/Broker");
                                            //GenJnLine."Document Type":=GenJnLine."Document Type"::Invoice;
                                            GenJnLine.VALIDATE(GenJnLine."Account No.");
                                            GenJnLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", Rcptline."Policy No."), 1, 50);
                                            //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                                            GenJnLine.Amount := CoInsureReinsureBrokerLines."Broker Commission";
                                            //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                                            //  GenJnLine.Amount := -CoInsureReinsureBrokerLines."Broker Commission";
                                            GenJnLine.VALIDATE(GenJnLine.Amount);
                                            /*GenJnLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                                            GenJnLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");*/
                                            GenJnLine."Effective Start Date" := InsureHeader."Cover Start Date";
                                            GenJnLine."Effective End Date" := InsureHeader."Cover End Date";
                                            GenJnLine."Insured ID" := InsureHeader."Insured No.";

                                            GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::Commission;
                                            GenJnLine."Policy No" := Rcptline."Policy No.";
                                            IF InsureHeader."Endorsement Policy No." = '' THEN
                                                GenJnLine."Endorsement No." := Rcptline."Policy No."
                                            ELSE
                                                GenJnLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                                            GenJnLine."Policy Type" := InsureHeader."Policy Type";
                                            GenJnLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                                            GenJnLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                                            GenJnLine."Endorsement Type" := InsureHeader."Endorsement Type";
                                            GenJnLine."Action Type" := InsureHeader."Action Type";
                                            GenJnLine."Bal. Account Type" := GenJnLine."Bal. Account Type"::"G/L Account";
                                            IF PolicyType.GET(InsureHeader."Policy Type", InsureHeader.Underwriter) THEN
                                                IF PolicyType."Account No" <> '' THEN
                                                    GenJnLine."Bal. Account No." := PolicyType."Account No"
                                                ELSE
                                                    ERROR('Please Define account for commission for Product %1 and Underwriter %2', InsureHeader."Policy Type",
                                                    InsureHeader."Underwriter");
                                            GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                                            IF GenJnLine.Amount <> 0 THEN
                                                GenJnLine.INSERT;

                                            DimensionSetEntryRec.RESET;
                                            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                                            IF DimensionSetEntryRec.FINDFIRST THEN
                                                REPEAT

                                                    DimensionSetEntryRecCopy.INIT;
                                                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnLine."Dimension Set ID";
                                                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                                        DimensionSetEntryRecCopy.INSERT;
                                                //MESSAGE('Dimension =%1 Value=%2 Set ID=%3',DimensionSetEntryRecCopy."Dimension Code",DimensionSetEntryRecCopy."Dimension Value Code",GenJnLine."Dimension Set ID");
                                                UNTIL DimensionSetEntryRec.NEXT = 0;

                                            GenJnLine.INIT;
                                            GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                                            GenJnLine."Journal Batch Name" := RptHeader."No.";
                                            GenJnLine."Line No." := GenJnLine."Line No." + 10000;
                                            GenJnLine."Posting Date" := RptHeader."Receipt Date";
                                            GenJnLine."Document No." := RptHeader."No.";
                                            GenJnLine."Account Type" := GenJnLine."Account Type"::Vendor;
                                            GenJnLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                                            //GenJnLine."Document Type":=GenJnLine."Document Type"::Invoice;
                                            GenJnLine.VALIDATE(GenJnLine."Account No.");
                                            GenJnLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", Rcptline."Policy No."), 1, 50);
                                            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                                                GenJnLine.Amount := -CoInsureReinsureBrokerLines."WHT Amount";
                                            IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                                                GenJnLine.Amount := CoInsureReinsureBrokerLines."WHT Amount";
                                            GenJnLine.VALIDATE(GenJnLine.Amount);
                                            /*GenJnLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                                            GenJnLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                                            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");*/
                                            GenJnLine."Effective Start Date" := InsureHeader."Cover Start Date";
                                            GenJnLine."Effective End Date" := InsureHeader."Cover End Date";
                                            GenJnLine."Insured ID" := InsureHeader."Insured No.";

                                            GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::Wht;
                                            GenJnLine."Policy No" := Rcptline."Policy No.";
                                            IF InsureHeader."Endorsement Policy No." = '' THEN
                                                GenJnLine."Endorsement No." := Rcptline."Policy No."
                                            ELSE
                                                GenJnLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                                            GenJnLine."Policy Type" := InsureHeader."Policy Type";
                                            GenJnLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                                            GenJnLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                                            GenJnLine."Endorsement Type" := InsureHeader."Endorsement Type";
                                            GenJnLine."Action Type" := InsureHeader."Action Type";

                                            GenJnLine."Bal. Account Type" := GenJnLine."Bal. Account Type"::"G/L Account";
                                            IF Vend.GET(CoInsureReinsureBrokerLines."Partner No.") THEN
                                                IF VATPostingSetup.GET(vend."VAT Bus. Posting Group", Isetup."Default WHT Code") THEN
                                                    GenJnLine."Bal. Account No." := VATPostingSetup."Sales VAT Account";
                                            IF GenJnLine.Amount <> 0 THEN
                                                GenJnLine.INSERT;

                                            DimensionSetEntryRec.RESET;
                                            DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                                            IF DimensionSetEntryRec.FINDFIRST THEN
                                                REPEAT

                                                    DimensionSetEntryRecCopy.INIT;
                                                    DimensionSetEntryRecCopy."Dimension Set ID" := GenJnLine."Dimension Set ID";
                                                    DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                                    DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                                    DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                                    DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                                    DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                                    IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                                        DimensionSetEntryRecCopy.INSERT;
                                                UNTIL DimensionSetEntryRec.NEXT = 0;
                                        end;
                                    end;
                                end;
                            UNTIL CoInsureReinsureBrokerLines.Next = 0;
                    End;
                UNTIL RcptLine.Next = 0;
            end;










            //debit note

            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnLine);
            GLEntry.RESET;
            GLEntry.SETRANGE(GLEntry."Document No.", RptHeader."Receipt No.");
            GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
            IF GLEntry.FINDFIRST THEN BEGIN
                RptHeader.Posted := TRUE;
                RptHeader."Posted Date" := TODAY;
                RptHeader."Posted Time" := TIME;
                RptHeader."Posted By" := USERID;
                RptHeader.MODIFY;

                IF Batch.GET(Batch."Journal Template Name", Batch.Name) THEN
                    Batch.DELETE;

                IF PaymodeRec.GET(RptHeader."Pay Mode") THEN BEGIN
                    IF PaymodeRec."Print Receipt" THEN BEGIN
                        RcptLedgerPrint.RESET;
                        RcptLedgerPrint.SETRANGE(RcptLedgerPrint."Document No.", RptHeader."Receipt No.");
                        IF RcptLedgerPrint.FINDFIRST THEN
                            REPORT.RUNMODAL(51511275, FALSE, TRUE, RcptLedgerPrint);
                    END;
               END;



            END;
        END;

    end;

    procedure CancelReceipt(var RptHeader: Record 51513110)
    var
        GLRegister: Record 45;
        GenJnLine: Record 81;
        RcptLine: Record 51513111;
        LineNo: Integer;
        Batch: Record 232;
        GLEntry: Record 17;
    begin

        IF RptHeader."Cancellation Reason" = '' THEN
            ERROR('You must enter a cancellation reason before cancelling a Receipt');



        /*GLRegister.RESET;
        GLRegister.SETRANGE(GLRegister."Journal Batch Name",PV."No.");
        IF GLRegister.FINDFIRST THEN
          ReversalEntry.ReverseRegister(GLRegister."No.");
        
        PV.Status :=PV.Status::Cancelled;
        PV.MODIFY;
        MESSAGE('Receipt %1 has been Cancelled',PV."Receipt No.");*/


        IF CONFIRM('Are you sure you want to Cancel Receipt no. ' + RptHeader."No." + ' ?') = TRUE THEN BEGIN

            IF RptHeader.Posted = FALSE THEN
                ERROR('Can only Cancel Posted Receipts');

            //RptHeader.TESTFIELD("Account No.");
            RptHeader.TESTFIELD("Pay Mode");
            // RptHeader.TESTFIELD("Paid in By");
            // RptHeader.TESTFIELD("Receipt Date");

            IF RptHeader."Pay Mode" = 'CHEQUE' THEN BEGIN
                RptHeader.TESTFIELD("Cheque No");
                RptHeader.TESTFIELD("Cheque Date");
            END;

            IF PaymodeRec.GET(RptHeader."Pay Mode") THEN BEGIN
                IF PaymodeRec.Electronic THEN BEGIN
                    RptHeader.TESTFIELD(RptHeader."REF NO.");

                END;
            END;

            CMSetup.GET();
            RptHeader."Receipt No." := NoSeriesMgt.GetNextNo(RptHeader."Posting No. Series", RptHeader."Receipt Date", TRUE);
            //MESSAGE('Receipt number=%1',RptHeader."Receipt No.");
            // Delete Lines Present on the General Journal Line
            GenJnLine.RESET;
            GenJnLine.SETRANGE(GenJnLine."Journal Template Name", CMSetup."Receipt Template");
            GenJnLine.SETRANGE(GenJnLine."Journal Batch Name", RptHeader."No.");
            GenJnLine.DELETEALL;

            Batch.INIT;
            IF CMSetup.GET() THEN
                Batch."Journal Template Name" := CMSetup."Receipt Template";
            Batch.Name := RptHeader."No.";
            IF NOT Batch.GET(Batch."Journal Template Name", Batch.Name) THEN
                Batch.INSERT;

            //Post Bank entries
            RptHeader.CALCFIELDS(RptHeader."Total Amount");
            LineNo := LineNo + 1000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
            GenJnLine."Journal Batch Name" := RptHeader."No.";
            GenJnLine."Line No." := LineNo;
            GenJnLine."Account Type" := GenJnLine."Account Type"::"Bank Account";
            GenJnLine."Account No." := RptHeader."Bank Code";
            GenJnLine.VALIDATE("Account No.");
            GenJnLine."Receipt and Payment Type" := RptHeader."Receipt Type";
            // GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
            GenJnLine."Posting Date" := RptHeader."Receipt Date";
            //GenJnLine."Document No.":=RptHeader."No.";
            GenJnLine."Document No." := RptHeader."Receipt No.";
            GenJnLine.Description := RptHeader."Received From";
            GenJnLine.Amount := -RptHeader."Total Amount";
            GenJnLine.VALIDATE(GenJnLine.Amount);

            GenJnLine."External Document No." := RptHeader."Cheque No";
            IF GenJnLine."External Document No." = '' THEN
                GenJnLine."External Document No." := RptHeader."REF NO.";
            GenJnLine."Currency Code" := RptHeader."Currency Code";
            GenJnLine.VALIDATE(GenJnLine."Currency Code");
            //RptHeader."Receipt Type":=RptHeader."Receipt Type";
            IF RptHeader."Pay Mode" = 'CHEQUE' THEN
                GenJnLine."Document Date" := RptHeader."Cheque Date";
            GenJnLine."Receipt and Payment Type" := RptHeader."Receipt Type";
            GenJnLine."Shortcut Dimension 1 Code" := RptHeader."Global Dimension 1 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code" := RptHeader."Global Dimension 2 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");

            IF GenJnLine.Amount <> 0 THEN
                GenJnLine.INSERT;


            //Post the receipt lines
            RcptLine.RESET;
            RcptLine.SETRANGE(RcptLine."Receipt No.", RptHeader."No.");
            IF RcptLine.FINDFIRST THEN BEGIN
                REPEAT
                    IF RcptLine.Amount <> 0 THEN BEGIN
                        IF ReceiptType.GET(RptHeader."Receipt Type", ReceiptType.Type::Receipt) THEN BEGIN
                            IF ReceiptType."Policy No. Mandatory" THEN
                                IF RcptLine."Policy No." = '' THEN
                                    ERROR('Policy No. must be selected for %1 receipt type', RptHeader."Receipt Type");

                            IF ReceiptType."Claim No. Mandatory" THEN
                                IF RcptLine."Claim No." = '' THEN
                                    ERROR('Claim No. must be selected for %1 receipt type', RptHeader."Receipt Type");

                            IF ReceiptType."Claimant ID. Mandatory" THEN
                                IF RcptLine."Claimant ID" = 0 THEN
                                    ERROR('Claimant ID must be selected for %1 receipt type', RptHeader."Receipt Type");
                            IF ReceiptType."Loan No. Mandatory" THEN
                                IF RcptLine."Loan No" = '' THEN
                                    ERROR('Loan No must be selected for %1 receipt type', RptHeader."Receipt Type");

                            IF ReceiptType."Debit Note Mandatory" THEN
                                IF RcptLine."Applies to Doc. No" = '' THEN
                                    ERROR('Applies to Doc. No Must have a value for %1 receipt type', RptHeader."Receipt Type");
                        END;

                    END;
                    //END;
                    RcptLine.VALIDATE(Amount);
                    LineNo := LineNo + 1000;
                    GenJnLine.INIT;
                    GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                    GenJnLine."Journal Batch Name" := RptHeader."No.";
                    GenJnLine."Line No." := LineNo;
                    GenJnLine."Account Type" := RcptLine."Account Type";
                    /* IF RcptLine."Account Type"=RcptLine."Account Type"::Vendor THEN
                       GenJnLine."Document Type":=GenJnLine."Document Type"::" " ELSE
                      GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;*/
                    GenJnLine."Account No." := RcptLine."Account No.";
                    // GenJnLine.VALIDATE(GenJnLine."Account No.");
                    GenJnLine."Posting Date" := RptHeader."Receipt Date";
                    //GenJnLine."Document No.":=RptHeader."No.";
                    GenJnLine."Document No." := RptHeader."Receipt No.";
                    GenJnLine.Description := COPYSTR(RcptLine.Description + '' + RcptLine."Account Name", 1, 50);
                    GenJnLine.Amount := RcptLine.Amount;
                    //message('%1',GenJnLine.Amount);
                    GenJnLine."External Document No." := RptHeader."Cheque No";
                    // GenJnLine."Applies-to Doc. Type":=RcptLine."Applies-to Doc. Type"::Invoice;
                    GenJnLine."Applies-to Doc. No." := RcptLine."Applies to Doc. No";
                    GenJnLine."Currency Code" := RptHeader."Currency Code";
                    GenJnLine.VALIDATE(GenJnLine."Currency Code");
                    GenJnLine."Shortcut Dimension 1 Code" := RcptLine."Global Dimension 1 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                    GenJnLine."Shortcut Dimension 2 Code" := RcptLine."Global Dimension 2 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");

                    GenJnLine."Shortcut Dimension 3 Code" := RcptLine."Global Dimension 3 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
                    GenJnLine."Shortcut Dimension 4 Code" := RcptLine."Global Dimension 4 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
                    //GenJnLine."UnderWriter ID":=RcptLine.Insurer;
                    // GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
                    GenJnLine."Loan No" := RcptLine."Loan No";
                    //GenJnLine."Investment Code":=RcptLine."Investme";
                    GenJnLine."Period Reference" := RcptLine."Reference Period";
                    GenJnLine."Claim No." := RcptLine."Claim No.";
                    GenJnLine."Claimant ID" := RcptLine."Claimant ID";
                    GenJnLine."Policy No" := RcptLine."Policy No.";
                    GenJnLine."Receipt and Payment Type" := RptHeader."Receipt Type";
                    GenJnLine."Insured ID" := RcptLine."Insured ID";
                    GenJnLine."Endorsement No." := RcptLine."Endorsement Policy No.";
                    GenJnLine."Policy Type" := RcptLine."Policy Type";

                    IF ReceiptType.GET(RptHeader."Receipt Type", 1) THEN BEGIN
                        GenJnLine."Insurance Trans Type" := ReceiptType."Insurance Trans Type";

                    END;
                    //GenJnLine."Insurance Trans Type":=RcptLine."Transaction Type"
                    IF GenJnLine.Amount <> 0 THEN
                        GenJnLine.INSERT;
                UNTIL
                 RcptLine.NEXT = 0;
            END;

            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnLine);
            GLEntry.RESET;
            GLEntry.SETRANGE(GLEntry."Document No.", RptHeader."Receipt No.");
            GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
            IF GLEntry.FINDFIRST THEN BEGIN
                RptHeader.Status := RptHeader.Status::Cancelled;
                RptHeader.MODIFY;
                MESSAGE('Receipt %1 has been Cancelled', RptHeader."Receipt No.");




            END;
        END;

    end;



    Procedure PostUnderwriterRec(Var RptHeader: record "Underwriter Receipt")

    var

        GenJnLine: Record 81;
        RcptLine: Record 51513111;
        LineNo: Integer;
        Batch: Record 232;
        GLEntry: Record 17;
        CoInsureReinsureBrokerLines: Record "Coinsurance Reinsurance lines";
        PolicyType: Record "Underwriter Policy Types";
        InsureHeader: Record "Insure Debit Note";
        DimensionSetEntryRec: Record "Dimension Set Entry";
        DimensionSetEntryRecCopy: record "Dimension Set Entry";
        Cust: Record Customer;
        Vend: Record Vendor;
        Isetup: record "Insurance Setup";
        VATPostingSetup: record "VAT Posting Setup";
        GenJourBatch: record "Gen. Journal Batch";

    begin
        
        If CMSetup.GET() then
        CMsetup.TestField(CMSetup."Receipt Template");
        //MESSAGE('The one %1',CMSetup."Receipt Template");
        If Not GenJourBatch.GET(CMSetup."Receipt Template",RptHeader."No.") then
        BEGIN
            GenJourBatch.INIT;
            GenJourBatch."Journal Template Name":=CMSetup."Receipt Template";
            GenJourBatch.Name:=RptHeader."No.";
            GenJourBatch.INSERT;
        END;
           
        IF InsureHeader.GET(RptHeader."Debit Note No.") then begin
            IF PolicyType.GET(InsureHeader."Policy Type", InsureHeader.Underwriter) THEN
            IF PolicyType."Commission Calculation Basis"=PolicyType."Commission Calculation Basis"::" " then
            Error('Please specify the Commission Calculation basis for Product %1 Insured by %',PolicyType.Description,PolicyType."Underwriter Code");
            //MESSAGE('%1',PolicyType.Code);
            ;
            CoInsureReinsureBrokerLines.RESET;
            // CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."Document Type", InsureHeader."Document Type");
            CoInsureReinsureBrokerLines.SETRANGE(CoInsureReinsureBrokerLines."No.", RptHeader."Debit Note No.");
            IF CoInsureReinsureBrokerLines.FINDFIRST THEN
                REPEAT
                   
                    IF CoInsureReinsureBrokerLines."Transaction Type" = CoInsureReinsureBrokerLines."Transaction Type"::"Broker " THEN BEGIN
                       // MESSAGE('Comm Basis %1 and code=%2',PolicyType."Commission Calculation Basis",PolicyType.Code);
                        IF PolicyType."Commission Calculation Basis" = PolicyType."Commission Calculation Basis"::" Paid Business" THEN BEGIN
                            IF CoInsureReinsureBrokerLines."Partner No." <> InsureHeader.Underwriter then begin
                                GenJnLine.INIT;
                                GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                                GenJnLine."Journal Batch Name" := RptHeader."No.";
                               // MESSAGE('Template=%1 and Batch=%2',CMSetup."Receipt Template",RptHeader."No.");
                                GenJnLine."Line No." := GenJnLine."Line No." + 10000;
                                GenJnLine."Posting Date" := RptHeader."Date receipted";
                                GenJnLine."Document No." := RptHeader."No.";
                                GenJnLine."Account Type" := GenJnLine."Account Type"::Vendor;
                                GenJnLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                                // MESSAGE('Broker =%1',InsureHeader."Agent/Broker");
                                //GenJnLine."Document Type":=GenJnLine."Document Type"::Invoice;
                                GenJnLine.VALIDATE(GenJnLine."Account No.");
                                GenJnLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", Rcptline."Policy No."), 1, 50);
                                //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                                GenJnLine.Amount := -CoInsureReinsureBrokerLines."Broker Commission";
                                //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                                //  GenJnLine.Amount := CoInsureReinsureBrokerLines."Broker Commission";
                                GenJnLine.VALIDATE(GenJnLine.Amount);
                                /*GenJnLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                                GenJnLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");*/
                                GenJnLine."Effective Start Date" := InsureHeader."Cover Start Date";
                                GenJnLine."Effective End Date" := InsureHeader."Cover End Date";
                                GenJnLine."Insured ID" := InsureHeader."Insured No.";

                                GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::Commission;
                                GenJnLine."Policy No" := RcptLine."Policy No.";
                                IF InsureHeader."Endorsement Policy No." = '' THEN
                                    GenJnLine."Endorsement No." := RcptLine."Policy No."
                                ELSE
                                    GenJnLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                                GenJnLine."Policy Type" := InsureHeader."Policy Type";
                                GenJnLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                                GenJnLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                                GenJnLine."Endorsement Type" := InsureHeader."Endorsement Type";
                                GenJnLine."Action Type" := InsureHeader."Action Type";
                                GenJnLine."Bal. Account Type" := GenJnLine."Bal. Account Type"::"G/L Account";
                                IF PolicyType.GET(InsureHeader."Policy Type", InsureHeader.Underwriter) THEN
                                    IF PolicyType."Account No" <> '' THEN
                                        GenJnLine."Bal. Account No." := PolicyType."Account No"
                                    ELSE
                                        ERROR('Please Define account for commission for Product %1 and Underwriter %2', InsureHeader."Policy Type",
                                        InsureHeader."Underwriter");
                                GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                                IF GenJnLine.Amount <> 0 THEN
                                    GenJnLine.INSERT;

                                DimensionSetEntryRec.RESET;
                                DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                                IF DimensionSetEntryRec.FINDFIRST THEN
                                    REPEAT

                                        DimensionSetEntryRecCopy.INIT;
                                        DimensionSetEntryRecCopy."Dimension Set ID" := GenJnLine."Dimension Set ID";
                                        DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                        DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                        DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                        DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                        DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                        IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                            DimensionSetEntryRecCopy.INSERT;
                                    //MESSAGE('Dimension =%1 Value=%2 Set ID=%3',DimensionSetEntryRecCopy."Dimension Code",DimensionSetEntryRecCopy."Dimension Value Code",GenJnLine."Dimension Set ID");
                                    UNTIL DimensionSetEntryRec.NEXT = 0;

                                GenJnLine.INIT;
                                GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                                GenJnLine."Journal Batch Name" := RptHeader."No.";
                                GenJnLine."Line No." := GenJnLine."Line No." + 10000;
                                GenJnLine."Posting Date" := RptHeader."Date Receipted";
                                GenJnLine."Document No." := RptHeader."No.";
                                GenJnLine."Account Type" := GenJnLine."Account Type"::Vendor;
                                GenJnLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                                //GenJnLine."Document Type":=GenJnLine."Document Type"::Invoice;
                                GenJnLine.VALIDATE(GenJnLine."Account No.");
                                GenJnLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", Rcptline."Policy No."), 1, 50);
                                //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                                GenJnLine.Amount := CoInsureReinsureBrokerLines."WHT Amount";
                                //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                                //  GenJnLine.Amount := -CoInsureReinsureBrokerLines."WHT Amount";
                                GenJnLine.VALIDATE(GenJnLine.Amount);
                                /*GenJnLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                                GenJnLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");*/
                                GenJnLine."Effective Start Date" := InsureHeader."Cover Start Date";
                                GenJnLine."Effective End Date" := InsureHeader."Cover End Date";
                                GenJnLine."Insured ID" := InsureHeader."Insured No.";

                                GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::Wht;
                                GenJnLine."Policy No" := RcptLine."Policy No.";
                                IF InsureHeader."Endorsement Policy No." = '' THEN
                                    GenJnLine."Endorsement No." := RcptLine."Policy No."
                                ELSE
                                    GenJnLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                                GenJnLine."Policy Type" := InsureHeader."Policy Type";
                                GenJnLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                                GenJnLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                                GenJnLine."Endorsement Type" := InsureHeader."Endorsement Type";
                                GenJnLine."Action Type" := InsureHeader."Action Type";

                                GenJnLine."Bal. Account Type" := GenJnLine."Bal. Account Type"::"G/L Account";
                                IF vend.GET(CoInsureReinsureBrokerLines."Partner No.") THEN
                                    IF VATPostingSetup.GET(Vend."VAT Bus. Posting Group", Isetup."Default WHT Code") THEN
                                        GenJnLine."Bal. Account No." := VATPostingSetup."Sales VAT Account";
                                IF GenJnLine.Amount <> 0 THEN
                                    GenJnLine.INSERT;

                                DimensionSetEntryRec.RESET;
                                DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                                IF DimensionSetEntryRec.FINDFIRST THEN
                                    REPEAT

                                        DimensionSetEntryRecCopy.INIT;
                                        DimensionSetEntryRecCopy."Dimension Set ID" := GenJnLine."Dimension Set ID";
                                        DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                        DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                        DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                        DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                        DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                        IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                            DimensionSetEntryRecCopy.INSERT;
                                    UNTIL DimensionSetEntryRec.NEXT = 0;
                            end;
                            IF CoInsureReinsureBrokerLines."Partner No." = InsureHeader.Underwriter then begin
                               // MESSAGE('Gets here');
                                
                                GenJnLine.INIT;
                                GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                                GenJnLine."Journal Batch Name" := RptHeader."No.";
                                GenJnLine."Line No." := GenJnLine."Line No." + 10000;
                                GenJnLine."Posting Date" := RptHeader."Date Receipted";
                                GenJnLine."Document No." := RptHeader."No.";
                                GenJnLine."Account Type" := GenJnLine."Account Type"::Vendor;
                                GenJnLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                                // MESSAGE('Broker =%1',InsureHeader."Agent/Broker");
                                //GenJnLine."Document Type":=GenJnLine."Document Type"::Invoice;
                                GenJnLine.VALIDATE(GenJnLine."Account No.");
                                GenJnLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", Rcptline."Policy No."), 1, 50);
                                //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                                GenJnLine.Amount := CoInsureReinsureBrokerLines."Broker Commission";
                                //IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                                //  GenJnLine.Amount := -CoInsureReinsureBrokerLines."Broker Commission";
                                GenJnLine.VALIDATE(GenJnLine.Amount);
                                /*GenJnLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                                GenJnLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");*/
                                GenJnLine."Effective Start Date" := InsureHeader."Cover Start Date";
                                GenJnLine."Effective End Date" := InsureHeader."Cover End Date";
                                GenJnLine."Insured ID" := InsureHeader."Insured No.";

                                GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::Commission;
                                GenJnLine."Policy No" := Rcptline."Policy No.";
                                IF InsureHeader."Endorsement Policy No." = '' THEN
                                    GenJnLine."Endorsement No." := Rcptline."Policy No."
                                ELSE
                                    GenJnLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                                GenJnLine."Policy Type" := InsureHeader."Policy Type";
                                GenJnLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                                GenJnLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                                GenJnLine."Endorsement Type" := InsureHeader."Endorsement Type";
                                GenJnLine."Action Type" := InsureHeader."Action Type";
                                GenJnLine."Bal. Account Type" := GenJnLine."Bal. Account Type"::"G/L Account";
                                IF PolicyType.GET(InsureHeader."Policy Type", InsureHeader.Underwriter) THEN
                                    IF PolicyType."Account No" <> '' THEN
                                        GenJnLine."Bal. Account No." := PolicyType."Account No"
                                    ELSE
                                        ERROR('Please Define account for commission for Product %1 and Underwriter %2', InsureHeader."Policy Type",
                                        InsureHeader."Underwriter");
                                GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
                                IF GenJnLine.Amount <> 0 THEN
                                    GenJnLine.INSERT;

                                DimensionSetEntryRec.RESET;
                                DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                                IF DimensionSetEntryRec.FINDFIRST THEN
                                    REPEAT

                                        DimensionSetEntryRecCopy.INIT;
                                        DimensionSetEntryRecCopy."Dimension Set ID" := GenJnLine."Dimension Set ID";
                                        DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                        DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                        DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                        DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                        DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                        IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                            DimensionSetEntryRecCopy.INSERT;
                                    //MESSAGE('Dimension =%1 Value=%2 Set ID=%3',DimensionSetEntryRecCopy."Dimension Code",DimensionSetEntryRecCopy."Dimension Value Code",GenJnLine."Dimension Set ID");
                                    UNTIL DimensionSetEntryRec.NEXT = 0;

                                GenJnLine.INIT;
                                GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                                GenJnLine."Journal Batch Name" := RptHeader."No.";
                                GenJnLine."Line No." := GenJnLine."Line No." + 10000;
                                GenJnLine."Posting Date" := RptHeader."Date Receipted";
                                GenJnLine."Document No." := RptHeader."No.";
                                GenJnLine."Account Type" := GenJnLine."Account Type"::Vendor;
                                GenJnLine."Account No." := CoInsureReinsureBrokerLines."Partner No.";
                                //GenJnLine."Document Type":=GenJnLine."Document Type"::Invoice;
                                GenJnLine.VALIDATE(GenJnLine."Account No.");
                                GenJnLine.Description := COPYSTR(STRSUBSTNO('%1 POLICY No. %2', InsureHeader."Insured Name", Rcptline."Policy No."), 1, 50);
                                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Debit Note" THEN
                                    GenJnLine.Amount := -CoInsureReinsureBrokerLines."WHT Amount";
                                IF InsureHeader."Document Type" = InsureHeader."Document Type"::"Credit Note" THEN
                                    GenJnLine.Amount := CoInsureReinsureBrokerLines."WHT Amount";
                                GenJnLine.VALIDATE(GenJnLine.Amount);
                                /*GenJnLine."Shortcut Dimension 1 Code":=InsureHeader."Shortcut Dimension 1 Code";
                                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                                GenJnLine."Shortcut Dimension 2 Code":=InsureHeader."Shortcut Dimension 2 Code";
                                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");*/
                                GenJnLine."Effective Start Date" := InsureHeader."Cover Start Date";
                                GenJnLine."Effective End Date" := InsureHeader."Cover End Date";
                                GenJnLine."Insured ID" := InsureHeader."Insured No.";

                                GenJnLine."Insurance Trans Type" := GenJnLine."Insurance Trans Type"::Wht;
                                GenJnLine."Policy No" := Rcptline."Policy No.";
                                IF InsureHeader."Endorsement Policy No." = '' THEN
                                    GenJnLine."Endorsement No." := Rcptline."Policy No."
                                ELSE
                                    GenJnLine."Endorsement No." := InsureHeader."Endorsement Policy No.";
                                GenJnLine."Policy Type" := InsureHeader."Policy Type";
                                GenJnLine."Shortcut Dimension 3 Code" := InsureHeader."Shortcut Dimension 3 Code";
                                GenJnLine."Shortcut Dimension 4 Code" := InsureHeader."Shortcut Dimension 4 Code";
                                GenJnLine."Endorsement Type" := InsureHeader."Endorsement Type";
                                GenJnLine."Action Type" := InsureHeader."Action Type";

                                GenJnLine."Bal. Account Type" := GenJnLine."Bal. Account Type"::"G/L Account";
                                IF Vend.GET(CoInsureReinsureBrokerLines."Partner No.") THEN
                                    IF VATPostingSetup.GET(vend."VAT Bus. Posting Group", Isetup."Default WHT Code") THEN
                                        GenJnLine."Bal. Account No." := VATPostingSetup."Sales VAT Account";
                                IF GenJnLine.Amount <> 0 THEN
                                    GenJnLine.INSERT;

                                DimensionSetEntryRec.RESET;
                                DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", InsureHeader."Dimension Set ID");
                                IF DimensionSetEntryRec.FINDFIRST THEN
                                    REPEAT

                                        DimensionSetEntryRecCopy.INIT;
                                        DimensionSetEntryRecCopy."Dimension Set ID" := GenJnLine."Dimension Set ID";
                                        DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                                        DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                                        DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                                        DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                                        DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                                        IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                            DimensionSetEntryRecCopy.INSERT;
                                    UNTIL DimensionSetEntryRec.NEXT = 0;
                            end;
                        end;
                    end

                UNTIL CoInsureReinsureBrokerLines.Next = 0;

        end;







       
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnLine);

        GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.", RptHeader."No.");
        GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN
            RptHeader.Acknowledged := True;
            RptHeader.MODIFY;
            MESSAGE('Receipt %1 has been Posted', RptHeader."No.");
        end;

    end;
}