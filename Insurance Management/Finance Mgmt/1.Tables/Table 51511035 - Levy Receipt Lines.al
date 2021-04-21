table 51511035 "Levy Receipt Lines"
{
    // version FINANCE


    fields
    {
        field(1; "Document No."; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Levy Receipt Header";

            trigger OnValidate()
            begin
                IF LeviesHeader.GET("Receipt No.") THEN BEGIN
                    "Financial Year" := LeviesHeader."Financial Year";
                    //"Payment Date":=LeviesHeader."Posted Date";
                END;
            end;
        }
        field(2; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(3; "Payment Type"; Option)
        {
            DataClassification = ToBeClassified;
            InitValue = Levy;
            OptionCaption = ' ,Levy,Penalty,Registration';
            OptionMembers = " ",Levy,Penalty,Registration;
        }
        field(5; "In Payment For"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Registration No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Customer No."; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No."; //WHERE(CustomerTypeID = CONST(1));

            trigger OnValidate()
            begin
                IF "Receipt No." = '' THEN BEGIN
                    Levysetup.GET;
                    //Levysetup.TESTFIELD("Levy Receipt Nos.");
                    //NoSeriesMgt.InitSeries(Levysetup."Levy Receipt Nos.", xRec."No. Series", 0D, "Receipt No.", "No. Series");
                END;

                IF LeviesHeader.GET("Document No.") THEN BEGIN
                    IF Customer.GET(LeviesHeader."Scheme Registration No.") THEN BEGIN
                        /* IF (Customer.CustomerTypeID = 1) THEN BEGIN
                            IF (Customer."No." <> "Customer No.") THEN BEGIN
                                MESSAGE('You cannot select a different scheme');
                                "Customer No." := Customer."No.";
                                "In Payment For" := Customer.Name;
                                VALIDATE("Customer No.");
                                VALIDATE("In Payment For");
                            END ELSE BEGIN

                                "In Payment For" := Customer.Name;
                                VALIDATE("In Payment For");
                            END;
                        END ELSE BEGIN
                            IF Customer.GET("Customer No.") THEN BEGIN
                                "In Payment For" := Customer.Name;
                                VALIDATE("In Payment For");

                            END;
                        END; */
                    END;
                END;
                "Account Type" := "Account Type"::Customer;
                VALIDATE("Account Type");
                "Account No." := "Customer No.";
                VALIDATE("Account No.");
                CALCFIELDS("Amount Due");
                // Amount:="Amount Due";
                // VALIDATE(Amount);
                IF LeviesHeader.GET("Document No.") THEN
                    "Financial Year" := LeviesHeader."Financial Year";
            end;
        }
        field(10; "Levy Reference No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = Levy.LevyNo WHERE("CustomerNo." = FIELD("Customer No."));

            trigger OnValidate()
            begin
                IF Levies.GET("Levy Reference No.") THEN
                    "In Payment For" := Levies.Name;
                "Customer No." := Levies."CustomerNo.";
                Levies.CALCFIELDS("Amount Paid");
                "Amount Due" := Levies.Amount - Levies."Amount Paid";
            end;
        }
        field(11; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Account Type"; Enum "Gen. Journal Account Type")
        {
            DataClassification = ToBeClassified;
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(13; "Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
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
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            IF Vendor.GET("Account No.") THEN
                                "Account Name" := Vendor.Name;
                        END;
                END;
            end;
        }
        field(14; "Account Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(18; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(19; "Amount Due"; Decimal)
        {
            CalcFormula = Sum(Levy.Amount WHERE(LevyTypeCode = CONST('001'),
                                                 "CustomerNo." = FIELD("Customer No.")));
            FieldClass = FlowField;
        }
        field(20; "Applies to Doc. No"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin

                "Applies to Doc. No" := '';
                Amt := 0;
                CustLedger.RESET;
                CustLedger.SETCURRENTKEY(CustLedger."Customer No.", Open, "Document No.");
                CustLedger.SETRANGE(CustLedger."Customer No.", "Customer No.");
                CustLedger.SETRANGE(Open, TRUE);
                CustLedger.CALCFIELDS(CustLedger.Amount);
                IF PAGE.RUNMODAL(0, CustLedger) = ACTION::LookupOK THEN BEGIN

                    IF CustLedger."Applies-to ID" <> '' THEN BEGIN
                        CustLedger1.RESET;
                        CustLedger1.SETCURRENTKEY(CustLedger1."Customer No.", Open, "Applies-to ID");
                        CustLedger1.SETRANGE(CustLedger1."Customer No.", "Customer No.");
                        CustLedger1.SETRANGE(Open, TRUE);
                        CustLedger1.SETRANGE("Applies-to ID", CustLedger."Applies-to ID");
                        IF CustLedger1.FIND('-') THEN BEGIN
                            REPEAT
                                CustLedger1.CALCFIELDS(CustLedger1.Amount);
                                Amt := Amt + ABS(CustLedger1.Amount);
                            UNTIL CustLedger1.NEXT = 0;
                        END;

                        IF Amt <> Amt THEN
                            //ERROR('Amount is not equal to the amount applied on the application form');
                            IF Amount = 0 THEN
                                Amount := Amt;
                        VALIDATE(Amount);
                        "Applies to Doc. No" := CustLedger."Document No.";
                    END ELSE BEGIN
                        IF Amount <> ABS(CustLedger.Amount) THEN
                            CustLedger.CALCFIELDS(CustLedger."Remaining Amount");
                        IF Amount = 0 THEN
                            Amount := ABS(CustLedger."Remaining Amount");
                        VALIDATE(Amount);
                        "Applies to Doc. No" := CustLedger."Document No.";

                    END;
                END;
                VALIDATE(Amount);
            end;
        }
        field(21; "Levy Type Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Levy Types";
        }
        field(22; "Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(24; "Financial Year"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Receipt Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Levy,Penalty,Fees,Arrears';
            OptionMembers = Levy,Penalty,Fees,Arrears;
        }
        field(26; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Receipt No.", "Document No.")
        {
            SumIndexFields = Amount;
        }
        key(Key2; "Payment Type", "Account No.")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Payment Type", "Customer No.", Posted)
        {
            SumIndexFields = Amount;
        }
        key(Key4; "Levy Type Code", "Customer No.")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    var
        Levies: Record "Levy";
        Customer: Record Customer;
        LeviesHeader: Record "Levy Receipt Header";
        GLAccount: Record "G/L Account";
        Cust: Record Customer;
        Vendor: Record Vendor;
        FixedAsset: Record "Fixed Asset";
        BankAccount: Record "Bank Account";
        CustLedger: Record "Cust. Ledger Entry";
        CustLedger1: Record "Cust. Ledger Entry";
        Amt: Decimal;
        Levysetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

