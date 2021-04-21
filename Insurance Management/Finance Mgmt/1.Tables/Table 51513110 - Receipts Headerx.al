table 51513110 "Receipts Headerx"
{
    // version CSHBK

    DrillDownPageID = "Receipt listX";
    LookupPageID = "Receipt listX";

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin

                GLSetup.GET;
                IF "No." <> xRec."No." THEN BEGIN
                    NoSeriesMgt.TestManual(GLSetup."Receipt No");
                END;
            end;
        }
        field(2; "Posting Date"; Date)
        {
        }
        field(3; "Pay Mode"; Code[20])
        {
            TableRelation = "Pay Modes";
        }
        field(4; "Cheque No"; Code[20])
        {
        }
        field(5; "Cheque Date"; Date)
        {
        }
        field(6; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Receipt Lines1x".Amount WHERE("Receipt No."=FIELD("No.")));
            Editable = false;
            
        }
        field(7; "Amount(LCY)"; Decimal)
        {
        }
        field(8; "Bank Code"; Code[20])
        {
            Editable = true;
            TableRelation = "Bank Account";
        }
        field(9; "Received From"; Text[70])
        {

            trigger OnValidate()
            begin
                "Received From" := UPPERCASE("Received From");
            end;
        }
        field(10; "On Behalf Of"; Text[70])
        {
        }
        field(11; Cashier; Code[30])
        {
            Editable = false;
        }
        field(12; Posted; Boolean)
        {
            Editable = false;
        }
        field(13; "Posted Date"; Date)
        {
            Editable = false;
        }
        field(14; "Posted Time"; Time)
        {
            Editable = false;
        }
        field(15; "Posted By"; Code[30])
        {
            Editable = false;
        }
        field(16; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "Currency Code"; Code[20])
        {
            TableRelation = Currency.Code;

            trigger OnValidate()
            begin
                IF NOT (CurrFieldNo IN [0, FIELDNO("Posting Date")]) OR ("Currency Code" <> xRec."Currency Code") THEN
                    TESTFIELD(Status, Status::Open);
                //IF DOPaymentTransLogEntry.FINDFIRST THEN
                // DOPaymentTransLogMgt.ValidateHasNoValidTransactions("Document Type",FORMAT("Document Type"),"No.");
                IF (CurrFieldNo <> FIELDNO("Currency Code")) AND ("Currency Code" = xRec."Currency Code") THEN
                    UpdateCurrencyFactor
                ELSE
                    IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                        UpdateCurrencyFactor;
                        //RecreateInsureLines(FIELDCAPTION("Currency Code"));
                    END ELSE
                        IF "Currency Code" <> '' THEN BEGIN
                            UpdateCurrencyFactor;
                            IF "Currency Factor" <> xRec."Currency Factor" THEN
                                ConfirmUpdateCurrencyFactor;
                        END;
            end;
        }
        field(18; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(19; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(20; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Pending Prepayment,Released,Rejected,Cancelled';
            OptionMembers = Open,"Pending Approval","Pending Prepayment",Released,Rejected,Cancelled;
        }
        field(21; Amount; Decimal)
        {
        }
        field(22; "Receipt Date"; Date)
        {
            Editable = false;
        }
        field(23; "Account Type"; Option)
        {
            Editable = false;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(24; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer WHERE("Customer Posting Group" = FIELD("Default Posting Group"))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor WHERE("Vendor Posting Group" = FIELD("Default Posting Group"))
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account";

            trigger OnValidate()
            begin

                CASE "Account Type" OF
                    "Account Type"::"G/L Account":
                        BEGIN
                            IF GLAccount.GET("Account No.") THEN
                                "Account Name" := GLAccount.Name;

                        END;
                    "Account Type"::Customer:
                        BEGIN
                            IF Cust.GET("Account No.") THEN
                                "Account Name" := Cust.Name;
                            "On Behalf Of" := Cust.Name;
                            "Received From" := Cust.Name;
                            "Agent Code" := Cust."Intermediary No.";
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            IF Vendor.GET("Account No.") THEN
                                "Account Name" := Vendor.Name;
                            "On Behalf Of" := Vend.Name;
                            "Received From" := Vend.Name;
                        END;
                END;
            end;
        }
        field(25; "Account Name"; Text[50])
        {
        }
        field(26; "Receipt Type"; Code[20])
        {
            TableRelation = "Receipts and Payment Types" WHERE(Type = CONST(Receipt));

            trigger OnValidate()
            begin
                IF RecPayTypes.GET("Receipt Type", RecPayTypes.Type::Receipt) THEN BEGIN
                    Grouping := RecPayTypes."Default Grouping";
                    "Account Type" := RecPayTypes."Account Type";
                    "Payments for" := RecPayTypes.Description;
                    IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::Customer THEN
                        "Default Posting Group" := RecPayTypes."Default Customer Posting Group";

                    IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::Vendor THEN
                        "Default Posting Group" := RecPayTypes."Default Vendor Posting Group";



                    IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" THEN BEGIN
                        IF RecPayTypes."G/L Account" <> '' THEN BEGIN
                            "Account No." := RecPayTypes."G/L Account";
                            //VALIDATE("Account No.");
                        END;
                    END;

                    IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner"]
                    THEN
                        CASE "Account Type" OF
                            "Account Type"::"G/L Account":
                                BEGIN
                                    IF GLAcc.GET("Account No.") THEN
                                        "Account Name" := GLAcc.Name;
                                    //"VAT Code":=RecPayTypes."VAT Code";
                                    //"Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                    //"Global Dimension 1 Code":='';
                                    "Account Name" := "Account Name";
                                END;
                            "Account Type"::Customer:
                                BEGIN
                                    IF Cust.GET("Account No.") THEN
                                        "Account Name" := Cust.Name;
                                    //"VAT Code":=Cust."Default VAT Code";
                                    //"Withholding Tax Code":=Cust."Default Withholding Tax Code";
                                    //"Global Dimension 1 Code":=Cust."Global Dimension 1 Code";
                                    "On Behalf Of" := "Account Name";
                                END;
                            "Account Type"::Vendor:
                                BEGIN
                                    IF Vend.GET("Account No.") THEN
                                        "Account Name" := Vend.Name;
                                    //"VAT Code":=Vend."Default VAT Code";
                                    //"Withholding Tax Code":=Vend."Default Withholding Tax Code";
                                    //"Global Dimension 1 Code":=Vend."Global Dimension 1 Code";
                                    "On Behalf Of" := "Account Name";

                                END;
                            "Account Type"::"Bank Account":
                                BEGIN
                                    IF BankAcc.GET("Account No.") THEN
                                        "Account Name" := BankAcc.Name;
                                    "On Behalf Of" := "Account Name";
                                    // "VAT Code":=RecPayTypes."VAT Code";
                                    // "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                    // "Global Dimension 1 Code":=BankAcc."Global Dimension 1 Code";

                                END;
                            "Account Type"::"Fixed Asset":
                                BEGIN
                                    IF FA.GET("Account No.") THEN
                                        "Account Name" := FA.Description;
                                    "On Behalf Of" := "Account Name";
                                    //"VAT Code":=FA."Default VAT Code";
                                    //"Withholding Tax Code":=FA."Default Withholding Tax Code";
                                    // "Global Dimension 1 Code":=FA."Global Dimension 1 Code";

                                END;
                        END;
                    "On Behalf Of" := "Account Name";
                    VALIDATE("On Behalf Of");


                END;
            end;
        }
        field(27; "REF NO."; Code[30])
        {
        }
        field(28; "Reference Period"; Date)
        {
            TableRelation = "Accounting Period";
        }
        field(29; "Currency Factor"; Decimal)
        {
        }
        field(30; "Payments for"; Text[80])
        {
        }
        field(31; Grouping; Code[20])
        {
        }
        field(32; "Drawer Name"; Text[80])
        {
        }
        field(33; "Drawer Bank"; Text[80])
        {
        }
        field(34; "Drawer Branch"; Text[30])
        {
        }
        field(35; "Agent Code"; Code[20])
        {
            TableRelation = Customer;
        }
        field(50002; "No. Of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments";
        }
        field(50003; "KBA Bank Code"; Code[10])
        {
            //TableRelation = "Bank Codes";

            trigger OnValidate()
            begin
                IF BankCodes.GET("KBA Bank Code") THEN BEGIN
                    "Drawer Bank" := BankCodes."Bank Name and Branch"
                END;
            end;
        }
        field(50004; "Receipt Amount type"; Option)
        {
            OptionCaption = ' ,Gross,Net';
            OptionMembers = " ",Gross,"Net ";
        }
        field(50005; "Receipt No."; Code[20])
        {
            Editable = false;
        }
        field(50006; "Posting No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50007; "Default Posting Group"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group"
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group";
        }
        field(50008; "Cancellation Reason"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN

            GLSetup.GET;
            GLSetup.TESTFIELD(GLSetup."Receipt No");
            NoSeriesMgt.InitSeries(GLSetup."Receipt No", xRec."No. Series", 0D, "No.", "No. Series");
            "Posting Date" := TODAY;
            "Receipt Date" := TODAY;
            "Receipt Amount type" := "Receipt Amount type"::Gross;
        END;
        GLSetup.GET;
        Cashier := USERID;
        /*
        IF UserDetails.GET(USERID) THEN
          BEGIN
          "Global Dimension 1 Code":=UserDetails."Global Dimension 1 Code";
          //"Global Dimension 2 Code":=UserDetails."Global Dimension 2 Code";
          "Bank Code":=UserDetails."Default Receipting Bank";
          /*IF GLSetup."Receipt Numbers Per Branch" THEN
            BEGIN
            IF GenLedgerSetup.GET THEN
            IF DimValRec.GET(GenLedgerSetup."Shortcut Dimension 1 Code","Global Dimension 1 Code") THEN
              BEGIN
               DimValRec.TESTFIELD(DimValRec."Posted Receipt Nos");
              "Posting No. Series":=DimValRec."Posted Receipt Nos";
              END;
            END
            ELSE
            
            BEGIN

              GLSetup.TESTFIELD(GLSetup."Receipt No");
              "Posting No. Series":=GLSetup."Receipt No";
            END;
          END;
          */


        GLSetup.GET;
        GLSetup.TESTFIELD(GLSetup."Posted Receipt Nos.");
        "Posting No. Series" := GLSetup."Posted Receipt Nos.";
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GLSetup: Record "Cash Management Setup";
        GLAccount: Record 15;
        Cust: Record 18;
        Vendor: Record 23;
        // DOPaymentTransLogEntry: Record 829;
        //DOPaymentMgt: Codeunit 825;
        //DOPaymentTransLogMgt: Codeunit 829;
        CurrencyDate: Date;
        CurrExchRate: Record 330;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text021: Label 'Do you want to update the exchange rate?';
        RecPayTypes: Record "Receipts and Payment Types";
        GLAcc: Record 15;
        FA: Record 5600;
        BankAcc: Record 270;
        Vend: Record 23;
        UserDetails: Record 51513104;
        BankCodes: Record 51507250;
        DimValRec: Record 349;
        GenLedgerSetup: Record 98;

    local procedure UpdateCurrencyFactor()
    begin
        IF "Currency Code" <> '' THEN BEGIN
            IF "Posting Date" <> 0D THEN
                CurrencyDate := "Posting Date"
            ELSE
                CurrencyDate := WORKDATE;

            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        END ELSE
            "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        IF HideValidationDialog THEN
            Confirmed := TRUE
        ELSE
            Confirmed := CONFIRM(Text021, FALSE);
        IF Confirmed THEN
            VALIDATE("Currency Factor")
        ELSE
            "Currency Factor" := xRec."Currency Factor";
    end;
}

