table 51511028 "Receipt Lines"
{
    // version FINANCE


    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Receipt No."; Code[20])
        {
            TableRelation = "Receipts Header";
        }
        field(3; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(4; "Account No."; Code[20])
        {
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
        field(5; "Account Name"; Text[250])
        {
        }
        field(6; Description; Text[250])
        {
        }
        field(7; "VAT Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
        }
        field(8; "W/Tax Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
        }
        field(9; "VAT Amount"; Decimal)
        {
        }
        field(10; "W/Tax Amount"; Decimal)
        {
        }
        field(11; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                VALIDATE("Applies to Doc. No");
                "Net Amount" := Amount;
            end;
        }
        field(12; "Net Amount"; Decimal)
        {
        }
        field(13; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(14; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Applies to Doc. No"; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
                PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
            begin
                "Applies to Doc. No" := '';
                Amt := 0;
                NetAmount := 0;
                //VATAmount:=0;
                //"W/TAmount":=0;

                CASE "Account Type" OF
                    "Account Type"::Customer:
                        BEGIN
                            CustLedger.RESET;
                            CustLedger.SETCURRENTKEY(CustLedger."Customer No.", Open, "Document No.");
                            CustLedger.SETRANGE(CustLedger."Customer No.", "Account No.");
                            CustLedger.SETRANGE(Open, TRUE);
                            CustLedger.CALCFIELDS("Remaining Amount");
                            IF PAGE.RUNMODAL(0, CustLedger) = ACTION::LookupOK THEN BEGIN

                                IF CustLedger."Applies-to ID" <> '' THEN BEGIN
                                    CustLedger1.RESET;
                                    CustLedger1.SETCURRENTKEY(CustLedger1."Customer No.", Open, "Applies-to ID");
                                    CustLedger1.SETRANGE(CustLedger1."Customer No.", "Account No.");
                                    CustLedger1.SETRANGE(Open, TRUE);
                                    CustLedger1.SETRANGE("Applies-to ID", CustLedger."Applies-to ID");
                                    IF CustLedger1.FIND('-') THEN BEGIN
                                        REPEAT
                                            CustLedger1.CALCFIELDS("Remaining Amount");
                                            Amt := Amt + ABS(CustLedger1."Remaining Amount");
                                        UNTIL CustLedger1.NEXT = 0;
                                    END;

                                    IF Amt <> Amt THEN
                                        //ERROR('Amount is not equal to the amount applied on the application form');
                                        IF Amount = 0 THEN
                                            Amount := Amt;
                                    VALIDATE(Amount);
                                    "Applies to Doc. No" := CustLedger."Document No.";
                                END ELSE BEGIN
                                    IF Amount <> ABS(CustLedger."Remaining Amount") THEN
                                        CustLedger.CALCFIELDS(CustLedger."Remaining Amount");
                                    IF Amount = 0 THEN
                                        Amount := ABS(CustLedger."Remaining Amount");
                                    VALIDATE(Amount);
                                    "Applies to Doc. No" := CustLedger."Document No.";
                                END;
                            END;
                            VALIDATE(Amount);
                        END;

                    "Account Type"::Vendor:
                        BEGIN
                            VendLedger.RESET;
                            VendLedger.SETCURRENTKEY(VendLedger."Vendor No.", Open, "Document No.");
                            VendLedger.SETRANGE(VendLedger."Vendor No.", "Account No.");
                            VendLedger.SETRANGE(Open, TRUE);
                            VendLedger.CALCFIELDS("Remaining Amount");
                            IF PAGE.RUNMODAL(0, VendLedger) = ACTION::LookupOK THEN BEGIN

                                IF VendLedger."Applies-to ID" <> '' THEN BEGIN
                                    VendLedger1.RESET;
                                    VendLedger1.SETCURRENTKEY(VendLedger1."Vendor No.", Open, "Applies-to ID");
                                    VendLedger1.SETRANGE(VendLedger1."Vendor No.", "Account No.");
                                    VendLedger1.SETRANGE(Open, TRUE);
                                    VendLedger1.SETRANGE(VendLedger1."Applies-to ID", VendLedger."Applies-to ID");
                                    IF VendLedger1.FIND('-') THEN BEGIN
                                        REPEAT
                                            VendLedger1.CALCFIELDS(VendLedger1."Remaining Amount");

                                            NetAmount := NetAmount + ABS(VendLedger1."Remaining Amount");
                                        UNTIL VendLedger1.NEXT = 0;
                                    END;

                                    IF NetAmount <> NetAmount THEN
                                        //ERROR('Amount is not equal to the amount applied on the application form');
                                        IF Amount = 0 THEN
                                            Amount := NetAmount;

                                    VALIDATE(Amount);
                                    "Applies to Doc. No" := VendLedger."Document No.";
                                END ELSE BEGIN
                                    IF Amount <> ABS(VendLedger."Remaining Amount") THEN
                                        VendLedger.CALCFIELDS(VendLedger."Remaining Amount");
                                    IF Amount = 0 THEN
                                        Amount := ABS(VendLedger."Remaining Amount");
                                    VALIDATE(Amount);
                                    "Applies to Doc. No" := VendLedger."Document No.";
                                END;
                            END;
                            Amount := ABS(VendLedger."Remaining Amount");
                            VALIDATE(Amount);
                        END;
                END;
            end;

            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                VendLedgEntry: Record "Vendor Ledger Entry";
                TempGenJnlLine: Record "Gen. Journal Line" temporary;
            begin

                CASE "Account Type" OF
                    "Account Type"::Customer:
                        BEGIN
                            CustLedger.RESET;
                            CustLedger.SETRANGE("Customer No.", "Account No.");
                            CustLedger.SETRANGE(Open, TRUE);
                            CustLedger.SETRANGE("Document No.", "Applies to Doc. No");
                            IF CustLedger.FIND('-') THEN
                                "Applies-to Doc. Type" := CustLedger."Document Type";
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            VendLedger.RESET;
                            VendLedger.SETRANGE("Vendor No.", "Account No.");
                            VendLedger.SETRANGE(Open, TRUE);
                            VendLedger.SETRANGE("Document No.", "Applies to Doc. No");
                            IF VendLedger.FIND('-') THEN
                                "Applies-to Doc. Type" := VendLedger."Document Type";

                        END;
                END;
            end;
        }
        field(16; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(17; "Procurement Method"; Option)
        {
            OptionCaption = ' ,Direct,RFQ,RFP,Tender,Low Value,Specially Permitted,EOI';
            OptionMembers = " ",Direct,RFQ,RFP,Tender,"Low Value","Specially Permitted",EOI;
        }
        field(18; "Procurement Request"; Code[30])
        {
            //TableRelation = Table51511303;
        }
        field(19; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(20; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Receipt';
            OptionMembers = Receipt;
        }
        field(21; "Receipt Transaction Type"; Code[50])
        {
            TableRelation = "Receipts and Payment Types" WHERE(Type = FILTER(Receipt));

            trigger OnValidate()
            begin
                CashManagementSetup.GET;
                FundsTypes.RESET;
                FundsTypes.SETRANGE(FundsTypes.Code, "Receipt Transaction Type");
                IF FundsTypes.FINDFIRST THEN BEGIN
                    //"Default Grouping":=FundsTypes."Default Grouping";
                    "Account Type" := FundsTypes."Account Type";
                    "Account No." := FundsTypes."G/L Account";
                    "Account Name" := FundsTypes.Description;
                    Description := FundsTypes.Description;
                END;
                "Financial Year" := CashManagementSetup."Current Budget";
                MESSAGE(CashManagementSetup."Current Budget");
                MODIFY;

                /*RHeader.RESET;
                RHeader.SETRANGE(RHeader."No.","Document No");
                 IF RHeader.FINDFIRST THEN BEGIN
                     "Posting Date":=RHeader."Posting Date";
                     "Document Date":=RHeader.Date;
                     "Global Dimension 1 Code":=RHeader."Global Dimension 1 Code";
                     "Global Dimension 2 Code":=RHeader."Global Dimension 2 Code";
                     "Shortcut Dimension 3 Code":=RHeader."Shortcut Dimension 3 Code";
                     "Shortcut Dimension 4 Code":=RHeader."Shortcut Dimension 4 Code";
                     "Shortcut Dimension 5 Code":=RHeader."Shortcut Dimension 5 Code";
                     "Shortcut Dimension 6 Code":=RHeader."Shortcut Dimension 6 Code";
                     "Shortcut Dimension 7 Code":=RHeader."Shortcut Dimension 7 Code";
                     "Shortcut Dimension 8 Code":=RHeader."Shortcut Dimension 8 Code";
                     "Pay Mode":=RHeader."Pay Mode";
                     "Cheque No":=RHeader."Cheque No";
                     "Responsibility Center":=RHeader."Responsibility Center";
                     "Document Type":="Document Type"::Receipt;
                     "Bank Code":=RHeader."Bank Code";
                     VALIDATE("Bank Code");
                     "Currency Code":=RHeader."Currency Code";
                     VALIDATE("Currency Code");
                     "Currency Factor":=RHeader."Currency Factor";
                     VALIDATE("Currency Factor");
                 END;
                 VALIDATE("Account Type");
                 */

            end;
        }
        field(22; "Customer Transaction type"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Customer Transaction Types"."Transaction Type";
        }
        field(23; "Financial Year"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No", "Receipt No.")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    var
        GLAccount: Record "G/L Account";
        Cust: Record Customer;
        Vendor: Record Vendor;
        FixedAsset: Record "Fixed Asset";
        BankAccount: Record "Bank Account";
        CustLedger: Record "Cust. Ledger Entry";
        CustLedger1: Record "Cust. Ledger Entry";
        VendLedger: Record "Vendor Ledger Entry";
        VendLedger1: Record "Vendor Ledger Entry";
        Amt: Decimal;
        NetAmount: Decimal;
        FundsTypes: Record "Receipts and Payment Types";
        CashManagementSetup: Record "Cash Management Setup";
}

