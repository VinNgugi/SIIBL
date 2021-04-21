table 51513301 "Reassurance Share"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Treaty Code"; Code[30])
        {
        }
        field(2; "Qouta Share"; Boolean)
        {
        }
        field(3; Surplus; Boolean)
        {
        }
        field(4; Facultative; Boolean)
        {
        }
        field(5; "Excess of loss"; Boolean)
        {
        }
        field(6; "Reassurer code"; Code[10])
        {
            TableRelation = Vendor WHERE(Type = CONST(Reinsurer));
        }
        field(7; "Reasurer Name"; Text[100])
        {
        }
        field(8; "Percentage %"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                /*
                QuotaTotalPercent:=0;
                SurplusTotalPercent:=0;
                FuclultativeTotalPercent:=0;
                
                //Quota Share.
                IF "Qouta Share"=TRUE THEN BEGIN
                
                TreatyVal.GET("Treaty Code","Addendum Code");
                
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Qouta Share",TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                //ReassurerShare.SETRANGE(ReassurerShare.Rider,Rider);
                
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                QuotaTotalPercent:=QuotaTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF TreatyVal."Cedant quota percentage"+QuotaTotalPercent+"Percentage %">100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                END;
                
                
                //Surplus
                IF Surplus=TRUE THEN BEGIN
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare.Surplus,TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                //ReassurerShare.SETRANGE(ReassurerShare.Rider,Rider);
                
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                SurplusTotalPercent:=SurplusTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF SurplusTotalPercent+"Percentage %">100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                END;
                
                //Fucultative
                IF Facultative=TRUE THEN BEGIN
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare.Facultative,TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                //ReassurerShare.SETRANGE(ReassurerShare.Rider,Rider);
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                FuclultativeTotalPercent:=FuclultativeTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF FuclultativeTotalPercent+"Percentage %">100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                END;
                
                
                //Fucultative
                IF "Excess of loss"=TRUE THEN BEGIN
                TreatyVal.GET("Treaty Code","Addendum Code");
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Excess of loss",TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                //ReassurerShare.SETRANGE(ReassurerShare.Rider,Rider);
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                ExcessTotalPercent:=ExcessTotalPercent+ReassurerShare."Percentage %";
                
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF ExcessTotalPercent+"Percentage %">100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                
                //MESSAGE('%1',ExcessTotalPercent);
                
                Amount:=("Percentage %"/100)*TreatyVal."Minimum Premium Deposit(MDP)";
                "Currency Code":=TreatyVal."Currency Code";
                MODIFY;
                END;
                 */

            end;
        }
        field(9; "Addendum Code"; Integer)
        {
        }
        field(10; Blocked; Boolean)
        {
        }
        field(11; "QS Amount"; Decimal)
        {
        }
        field(12; "Surplus Amount"; Decimal)
        {
        }
        field(13; "Facultative Amount"; Decimal)
        {
        }
        field(14; Rider; Boolean)
        {
        }
        field(15; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                /*GetCurrency;
                IF "Currency Code" = '' THEN
                  "Premium (LCY)" := Amount
                ELSE
                  "Premium (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Period Ended","Currency Code",
                      Amount,"Currency Factor"));
                  */

            end;
        }
        field(16; "Period Ended"; Date)
        {

            trigger OnValidate();
            begin
                VALIDATE("Currency Code");
                VALIDATE("Currency Factor");
            end;
        }
        field(19; "Sums Assured"; Decimal)
        {

            trigger OnValidate();
            begin
                /*GetCurrency;
                
                IF "Currency Code" = '' THEN
                  "Sums Assured (LCY)" := "Sums Assured"
                ELSE
                  "Sums Assured (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Period Ended","Currency Code",
                      "Sums Assured","Currency Factor"));
                  */

            end;
        }
        field(21; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            begin
                /*
                
                IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
                  IF BankAcc3.GET("Bal. Account No.") AND (BankAcc3."Currency Code" <> '')THEN
                    BankAcc3.TESTFIELD("Currency Code","Currency Code");
                END;
                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                  IF BankAcc3.GET("Account No.") AND (BankAcc3."Currency Code" <> '') THEN
                    BankAcc3.TESTFIELD("Currency Code","Currency Code");
                END;
                IF ("Recurring Method" IN
                    ["Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance"]) AND
                   ("Currency Code" <> '')
                THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Currency Code"),FIELDCAPTION("Recurring Method"),"Recurring Method");
                
                */

                ///  good
                /*
                IF "Currency Code" <> '' THEN BEGIN
                  GetCurrency;
                  IF ("Currency Code" <> xRec."Currency Code") OR
                     ("Due Date" <> xRec."Due Date") OR
                     (CurrFieldNo = FIELDNO("Currency Code")) OR
                     ("Currency Factor" = 0)
                  THEN
                    "Currency Factor" :=
                      CurrExchRate.ExchangeRate("Due Date","Currency Code");
                END ELSE
                  "Currency Factor" := 0;
                VALIDATE("Currency Factor");
                */
                ///


                /*
                IF (("Currency Code" <> xRec."Currency Code") AND (Amount <> 0)) THEN
                  PaymentToleranceMgt.PmtTolGenJnl(Rec);
                */

            end;
        }
        field(22; "Sums Assured (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin
                /*
                
                GetCurrency;
                
                IF "Currency Code" = '' THEN
                 "Sums Assured":=  "Sums Assured (LCY)"
                ELSE
                  "Sums Assured" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Period Ended","Currency Code",
                      "Sums Assured (LCY)","Currency Factor"));
                */

            end;
        }
        field(23; "Premium (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin
                /*
                
                GetCurrency;
                
                IF "Currency Code" = '' THEN
                 Amount:=  "Premium (LCY)"
                ELSE
                  Amount := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Period Ended","Currency Code",
                      "Premium (LCY)","Currency Factor"));
                
                */

            end;
        }
        field(24; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
                VALIDATE("Sums Assured");
                //VALIDATE("Premium (LCY)");
                //VALIDATE("Sums Assured (LCY)");
            end;
        }
        field(25; Posted; Boolean)
        {
        }
        field(26; "Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(27; "Posting Date"; Date)
        {
        }
        field(28; "Posting Time"; Time)
        {
        }
        field(29; "% Of Remainder"; Decimal)
        {

            trigger OnValidate();
            begin
                /*
                //Quota Share.
                IF "Qouta Share"=TRUE THEN BEGIN
                
                TreatyVal.GET("Treaty Code","Addendum Code");
                
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Qouta Share",TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                //ReassurerShare.SETRANGE(ReassurerShare.Rider,Rider);
                
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                QuotaTotalPercent:=QuotaTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF QuotaTotalPercent+"Percentage %">100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                END;
                
                "Percentage %":=("% Of Remainder"/100)*(100-TreatyVal."Cedant quota percentage");
                VALIDATE("Percentage %");
                 */

            end;
        }
        field(30; "Indiv refund"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details".Refund WHERE("Insurer/Reassurer Code" = FIELD("Reassurer code"),
                                                                      "Qouta Share" = FIELD("Qouta Share"),
                                                                      Surplus = FIELD(Surplus),
                                                                      Facultative = FIELD(Facultative),
                                                                      Retro = CONST(false),
                                                                      "Treaty Code" = FIELD("Treaty Code"),
                                                                      "Addendum Code" = FIELD("Addendum Code")));
            FieldClass = FlowField;
        }
        field(31; "Indiv  cedant Commission"; Decimal)
        {
        }
        field(32; "Ind Broker Commision"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Treaty Code", "Qouta Share", Surplus, Facultative, "Excess of loss", "Reassurer code", "Addendum Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PurchSetup: Record "Purchases & Payables Setup";
        CommentLine: Record "Comment Line";
        PurchOrderLine: Record "Purchase Line";
        PostCode: Record "Post Code";
        VendBankAcc: Record "Vendor Bank Account";
        OrderAddr: Record "Order Address";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        ItemCrossReference: Record "Item Cross Reference";
        RMSetup: Record "Marketing Setup";
        ServiceItem: Record "Service Item";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MoveEntries: Codeunit MoveEntries;
        UpdateContFromVend: Codeunit "VendCont-Update";
        DimMgt: Codeunit 408;
        InsertFromContact: Boolean;
        Text000: Label 'You cannot delete %1 %2 because there is at least one outstanding Purchase %3 for this vendor.';
        Text002: Label 'You have set %1 to %2. Do you want to update the %3 price list accordingly?';
        Text003: Label 'Do you wish to create a contact for %1 %2?';
        Text004: Label 'Contact %1 %2 is not related to vendor %3 %4.';
        Text005: Label 'post';
        Text006: Label 'create';
        Text007: Label 'You cannot %1 this type of document when Vendor %2 is blocked with type %3';
        Text008: Label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3.';
        Text009: Label 'Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
        Text010: Label 'You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
        Text011: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';

    procedure AssistEdit(OldVend: Record Vendor): Boolean;
    var
        Vend: Record Vendor;
    begin
        /*WITH Vend DO BEGIN
          Vend := Rec;
          PurchSetup.GET;
          PurchSetup.TESTFIELD("Vendor Nos.");
          IF NoSeriesMgt.SelectSeries(PurchSetup."Vendor Nos.",OldVend."No. Series","No. Series") THEN BEGIN
            PurchSetup.GET;
            PurchSetup.TESTFIELD("Vendor Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Vend;
            EXIT(TRUE);
          END;
        END;
        */

    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        /*DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Vendor,"No.",FieldNumber,ShortcutDimCode);
        MODIFY;
        */

    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        /*DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Vendor,"No.",FieldNumber,ShortcutDimCode);
         */

    end;

    procedure ShowContact();
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
    begin
        /*IF "No." = '' THEN
          EXIT;
        
        ContBusRel.SETCURRENTKEY("Link to Table","No.");
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
        ContBusRel.SETRANGE("No.","No.");
        IF NOT ContBusRel.FIND('-') THEN BEGIN
          IF NOT CONFIRM(Text003,FALSE,TABLECAPTION,"No.") THEN
            EXIT;
          UpdateContFromVend.InsertNewContact(Rec,FALSE);
          ContBusRel.FIND('-');
        END;
        COMMIT;
        
        IF ISSERVICETIER THEN BEGIN
          Cont.SETCURRENTKEY("Company Name","Company No.",Type,Name);
          Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
          FORM.RUN(FORM::"Contact List",Cont);
          EXIT;
        END;
        
        Cont.GET(ContBusRel."Contact No.");
        FORM.RUN(FORM::"Contact Card",Cont);
        */

    end;

    procedure SetInsertFromContact(FromContact: Boolean);
    begin
        InsertFromContact := FromContact;
    end;

    procedure CheckBlockedVendOnDocs(Vend2: Record Vendor; Transaction: Boolean);
    begin
        IF Vend2.Blocked = Vend2.Blocked::All THEN
            VendBlockedErrorMessage(Vend2, Transaction);
    end;

    procedure CheckBlockedVendOnJnls(Vend2: Record Vendor; DocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge",Reminder,Refund; Transaction: Boolean);
    begin
        WITH Vend2 DO BEGIN
            IF (Blocked = Blocked::All) OR
               (Blocked = Blocked::Payment) AND (DocType = DocType::Payment)
            THEN
                VendBlockedErrorMessage(Vend2, Transaction);
        END;
    end;

    procedure VendBlockedErrorMessage(Vend2: Record Vendor; Transaction: Boolean);
    var
        "Action": Text[30];
    begin
        IF Transaction THEN
            Action := Text005
        ELSE
            Action := Text006;
        ERROR(Text007, Action, Vend2."No.", Vend2.Blocked);
    end;

    procedure DisplayMap();
    var
        MapPoint: Record "Online Map Setup";
    //MapMgt: Codeunit "Online Map Management";
    begin
        IF MapPoint.FIND('-') THEN
            //MapMgt.MakeSelection(DATABASE::Vendor, GETPOSITION)
            //ELSE
            MESSAGE(Text011);
    end;

    procedure GetCurrency();
    begin
    end;
}

