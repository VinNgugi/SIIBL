table 51511001 "PV Lines1"
{
    // version CSHBK

    DrillDownPageID = 51511002;
    LookupPageID = 51511002;

    fields
    {
        field(1; "PV No"; Code[20])
        {

            trigger OnValidate();
            begin


                IF PV.GET("PV No") THEN BEGIN
                    IF PV."Account Type" = PV."Account Type"::Vendor THEN BEGIN
                        "Account Type" := "Account Type"::Vendor;
                        "Account No" := PV."Account No.";
                        "Account Name" := PV."Account Name";
                    END ELSE
                        IF PV."Account Type" = PV."Account Type"::Customer THEN BEGIN
                            "Account Type" := "Account Type"::Customer;
                            "Account No" := PV."Account No.";
                            "Account Name" := PV."Account Name";
                        END ELSE BEGIN
                            "Account Type" := "Account Type"::"G/L Account";
                            "Account No" := '';
                        END;
                END;
            end;
        }
        field(2; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(3; "Account No"; Code[100])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate();
            begin


                IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner"]
                THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No");
                                "Account Name" := GLAcc.Name;
                                IF NOT GLAcc."Direct Posting" THEN
                                    ERROR('You cannot select a control account');
                                // "VAT Code":=RecPayTypes."VAT Code";
                                // "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                // "Global Dimension 1 Code":='';
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No");
                                "Account Name" := Cust.Name;
                                //"VAT Code":=Cust."Default VAT Code";
                                //"Withholding Tax Code":=Cust."Default Withholding Tax Code";
                                //"Global Dimension 1 Code":=Cust."Global Dimension 1 Code";
                                //Payee:="Account Name";
                                //"KBA Branch Code":=Cust."Preferred Bank Account";
                                "Bank Account No" := Cust."Our Account No.";

                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No");
                                "Account Name" := Vend.Name;
                                //"VAT Code":=Vend."Default VAT Code";
                                //"Withholding Tax Code":=Vend."Withholding Tax Code";
                                //"KBA Branch Code":=Vend."KBA Code";
                                //"Bank Account No":=Vend."Our Account No.";

                                //"Global Dimension 1 Code":=Vend."Global Dimension 1 Code";
                                //Payee:="Account Name";
                                //"KBA Branch Code":=Vend."Preferred Bank Account";
                                "Bank Account No" := Vend."Our Account No.";
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No");
                                "Account Name" := BankAcc.Name;
                                // "VAT Code":=RecPayTypes."VAT Code";
                                // "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                // "Global Dimension 1 Code":=BankAcc."Global Dimension 1 Code";

                            END;
                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No");
                                "Account Name" := FA.Description;
                                //"VAT Code":=FA."Default VAT Code";
                                //"Withholding Tax Code":=FA."Default Withholding Tax Code";
                                // "Global Dimension 1 Code":=FA."Global Dimension 1 Code";

                            END;
                    END;
                //VALIDATE(Payee);
            end;
        }
        field(4; "Account Name"; Text[150])
        {
        }
        field(5; Description; Text[130])
        {

            trigger OnValidate();
            begin
                /*
                IF PV.GET("PV No") THEN BEGIN
                  "Account Type":=PV."Account Type";
                  "Account No":=PV."Account No."
                END;
                VALIDATE("Account No");
                */

            end;
        }
        field(6; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                VALIDATE("Applies to Doc. No");
                CSetup.GET;
                CSetup.TESTFIELD("Rounding Precision");
                IF CSetup."Rounding Type" = CSetup."Rounding Type"::Up THEN
                    Direction := '>'
                ELSE
                    IF CSetup."Rounding Type" = CSetup."Rounding Type"::Nearest THEN
                        Direction := '='
                    ELSE
                        IF CSetup."Rounding Type" = CSetup."Rounding Type"::Down THEN
                            Direction := '<';
                CASE "Account Type" OF
                    "Account Type"::"G/L Account":
                        BEGIN
                            //Check for Retention
                            IF "Retention Code" <> '' THEN BEGIN
                                IF GLAccount.GET("Account No") THEN
                                    IF VATSetup.GET(GLAccount."VAT Bus. Posting Group", "Retention Code") THEN BEGIN
                                        IF VATSetup."VAT %" <> 0 THEN BEGIN
                                            RetAmount := ROUND((Amount / (1 + VATSetup."VAT %" / 100) * VATSetup."VAT %" / 100), CSetup."Rounding Precision", Direction);
                                            NetAmount := Amount - RetAmount;
                                            "Retention Amount" := RetAmount;
                                        END;
                                    END;
                            END;
                            //End of Retention
                            IF "VAT Code" <> '' THEN BEGIN
                                IF GLAccount.GET("Account No") THEN
                                    IF VATSetup.GET(GLAccount."VAT Bus. Posting Group", "VAT Code") THEN BEGIN
                                        IF VATSetup."VAT %" <> 0 THEN BEGIN
                                            VATAmount := ROUND((Amount / (1 + VATSetup."VAT %" / 100) * VATSetup."VAT %" / 100), CSetup."Rounding Precision", Direction);
                                            NetAmount := Amount - VATAmount;
                                            "VAT Amount" := VATAmount;
                                            IF CSetup."Post VAT" THEN//Check IF VAT is to be posted
                                                "Net Amount" := Amount - VATAmount
                                            ELSE
                                                "Net Amount" := Amount;
                                            IF "W/Tax Code" <> '' THEN BEGIN
                                                IF GLAccount.GET("Account No") THEN
                                                    IF VATSetup.GET(GLAccount."Gen. Bus. Posting Group", "W/Tax Code") THEN BEGIN
                                                        "W/TAmount" := ROUND(NetAmount * VATSetup."VAT %" / 100, CSetup."Rounding Precision", Direction);
                                                        "W/Tax Amount" := "W/TAmount";
                                                        NetAmount := NetAmount - "W/TAmount";
                                                        IF CSetup."Post VAT" THEN//Check IF VAT is to be posted
                                                            "Net Amount" := NetAmount
                                                        ELSE
                                                            "Net Amount" := Amount - "W/TAmount";
                                                    END;
                                            END;
                                        END ELSE BEGIN
                                            "Net Amount" := Amount;
                                            NetAmount := Amount;
                                            IF "W/Tax Code" <> '' THEN BEGIN
                                                IF GLAccount.GET("Account No") THEN
                                                    IF VATSetup.GET(GLAccount."Gen. Bus. Posting Group", "W/Tax Code") THEN BEGIN
                                                        "W/TAmount" := ROUND(NetAmount * VATSetup."VAT %" / 100, CSetup."Rounding Precision", Direction);
                                                        "W/Tax Amount" := "W/TAmount";
                                                        NetAmount := NetAmount - "W/TAmount";
                                                        "Net Amount" := Amount - "W/TAmount";
                                                    END;
                                            END;
                                        END;
                                    END;
                            END
                            ELSE BEGIN
                                "Net Amount" := Amount;
                                NetAmount := Amount;
                                IF "W/Tax Code" <> '' THEN BEGIN
                                    IF GLAccount.GET("Account No") THEN
                                        IF VATSetup.GET(GLAccount."Gen. Bus. Posting Group", "W/Tax Code") THEN BEGIN
                                            "W/TAmount" := ROUND(NetAmount * VATSetup."VAT %" / 100, CSetup."Rounding Precision", Direction);
                                            "W/Tax Amount" := "W/TAmount";
                                            NetAmount := NetAmount - "W/TAmount";
                                            "Net Amount" := Amount - "W/TAmount";
                                        END;
                                END;
                            END;
                        END;
                    "Account Type"::Customer:
                        BEGIN
                            //Check for Retention
                            IF "Retention Code" <> '' THEN BEGIN
                                IF Customer.GET("Account No") THEN
                                    IF VATSetup.GET(Customer."VAT Bus. Posting Group", "Retention Code") THEN BEGIN
                                        IF VATSetup."VAT %" <> 0 THEN BEGIN
                                            RetAmount := ROUND((Amount / (1 + VATSetup."VAT %" / 100) * VATSetup."VAT %" / 100), CSetup."Rounding Precision", Direction);
                                            NetAmount := Amount - RetAmount;
                                            "Retention Amount" := RetAmount;
                                        END;
                                    END;
                            END;
                            //End of Retention
                            IF "VAT Code" <> '' THEN BEGIN
                                IF Customer.GET("Account No") THEN
                                    IF VATSetup.GET(Customer."VAT Bus. Posting Group", "VAT Code") THEN BEGIN
                                        VATAmount := ROUND((Amount / (1 + VATSetup."VAT %" / 100) * VATSetup."VAT %" / 100), CSetup."Rounding Precision", Direction);
                                        IF VATSetup."VAT %" <> 0 THEN BEGIN
                                            NetAmount := Amount - VATAmount;
                                            "VAT Amount" := VATAmount;
                                            IF CSetup."Post VAT" THEN//Check IF VAT is to be posted
                                                "Net Amount" := Amount - VATAmount
                                            ELSE
                                                "Net Amount" := Amount;
                                            IF "W/Tax Code" <> '' THEN BEGIN
                                                IF Customer.GET("Account No") THEN
                                                    IF VATSetup.GET(Customer."VAT Bus. Posting Group", "W/Tax Code") THEN BEGIN
                                                        "W/TAmount" := ROUND(NetAmount * VATSetup."VAT %" / 100, CSetup."Rounding Precision", Direction);
                                                        "W/Tax Amount" := "W/TAmount";
                                                        NetAmount := NetAmount - "W/TAmount";
                                                        IF CSetup."Post VAT" THEN//Check IF VAT is to be posted
                                                            "Net Amount" := NetAmount
                                                        ELSE
                                                            "Net Amount" := Amount - "W/TAmount";
                                                    END;
                                            END;
                                        END ELSE BEGIN
                                            "Net Amount" := Amount;
                                            NetAmount := Amount;
                                            IF "W/Tax Code" <> '' THEN BEGIN
                                                IF Customer.GET("Account No") THEN
                                                    IF VATSetup.GET(Customer."VAT Bus. Posting Group", "W/Tax Code") THEN BEGIN
                                                        "W/TAmount" := ROUND(NetAmount * VATSetup."VAT %" / 100, CSetup."Rounding Precision", Direction);
                                                        "W/Tax Amount" := "W/TAmount";
                                                        NetAmount := NetAmount - "W/TAmount";
                                                        "Net Amount" := Amount - "W/TAmount";
                                                    END;
                                            END;
                                        END;
                                    END;
                            END
                            ELSE BEGIN
                                "Net Amount" := Amount;
                                NetAmount := Amount;
                                IF "W/Tax Code" <> '' THEN BEGIN
                                    IF Customer.GET("Account No") THEN
                                        IF VATSetup.GET(Customer."VAT Bus. Posting Group", "W/Tax Code") THEN BEGIN
                                            "W/TAmount" := ROUND(NetAmount * VATSetup."VAT %" / 100, CSetup."Rounding Precision", Direction);
                                            "W/Tax Amount" := "W/TAmount";
                                            NetAmount := NetAmount - "W/TAmount";
                                            "Net Amount" := Amount - "W/TAmount";
                                        END;
                                END;
                            END;
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            //Check for Retention
                            IF "Retention Code" <> '' THEN BEGIN
                                IF Vendor.GET("Account No") THEN
                                    IF VATSetup.GET(Vendor."VAT Bus. Posting Group", "Retention Code") THEN BEGIN
                                        IF VATSetup."VAT %" <> 0 THEN BEGIN
                                            RetAmount := ROUND((Amount / (1 + VATSetup."VAT %" / 100) * VATSetup."VAT %" / 100), CSetup."Rounding Precision", Direction);
                                            NetAmount := Amount - RetAmount;
                                            "Retention Amount" := RetAmount;

                                        END;
                                    END;
                            END;
                            //End of Retention
                            IF "VAT Code" <> '' THEN BEGIN
                                IF Vendor.GET("Account No") THEN
                                    IF VATSetup.GET(Vendor."VAT Bus. Posting Group", "VAT Code") THEN BEGIN
                                        //MESSAGE('Combination =%1 and %2 VAT= %3',Vendor."VAT Bus. Posting Group","VAT Code",VATSetup."VAT %");
                                        IF VATSetup."VAT %" <> 0 THEN BEGIN
                                            VATAmount := ROUND((Amount / (1 + VATSetup."VAT %" / 100) * VATSetup."VAT %" / 100), CSetup."Rounding Precision", Direction);
                                            NetAmount := Amount - VATAmount;
                                            "VAT Amount" := VATAmount;
                                            IF CSetup."Post VAT" THEN//Check IF VAT is to be posted
                                                "Net Amount" := Amount - VATAmount
                                            ELSE
                                                "Net Amount" := Amount;
                                            IF "W/Tax Code" <> '' THEN BEGIN
                                                IF Vendor.GET("Account No") THEN
                                                    IF VATSetup.GET(Vendor."VAT Bus. Posting Group", "W/Tax Code") THEN BEGIN
                                                        "W/TAmount" := ROUND(NetAmount * VATSetup."VAT %" / 100, CSetup."Rounding Precision", Direction);
                                                        "W/Tax Amount" := "W/TAmount";
                                                        NetAmount := NetAmount - "W/TAmount";
                                                        IF CSetup."Post VAT" THEN//Check IF VAT is to be posted
                                                            "Net Amount" := NetAmount
                                                        ELSE
                                                            "Net Amount" := Amount - "W/TAmount";
                                                    END;
                                            END;
                                        END ELSE BEGIN
                                            "Net Amount" := Amount;
                                            NetAmount := Amount;
                                            IF "W/Tax Code" <> '' THEN BEGIN
                                                IF Vendor.GET("Account No") THEN
                                                    IF VATSetup.GET(Vendor."VAT Bus. Posting Group", "W/Tax Code") THEN BEGIN
                                                        "W/TAmount" := ROUND(NetAmount * VATSetup."VAT %" / 100, CSetup."Rounding Precision", Direction);
                                                        "W/Tax Amount" := "W/TAmount";
                                                        NetAmount := NetAmount - "W/TAmount";
                                                        "Net Amount" := Amount - "W/TAmount";
                                                    END;
                                            END;
                                        END;
                                    END;
                            END
                            ELSE BEGIN
                                "Net Amount" := Amount;
                                NetAmount := Amount;
                                IF "W/Tax Code" <> '' THEN BEGIN
                                    IF Vendor.GET("Account No") THEN
                                        IF VATSetup.GET(Vendor."VAT Bus. Posting Group", "W/Tax Code") THEN BEGIN
                                            "W/TAmount" := ROUND(NetAmount * VATSetup."VAT %" / 100, CSetup."Rounding Precision", Direction);

                                            "W/Tax Amount" := "W/TAmount";
                                            NetAmount := NetAmount - "W/TAmount";
                                            "Net Amount" := Amount - "W/TAmount";
                                        END;
                                END;
                            END;
                        END;
                    "Account Type"::"Bank Account":
                        "Net Amount" := Amount;
                END;
                VALIDATE("Claim No");
                VALIDATE("Claimant ID");
            end;
        }
        field(7; Grouping; Code[10])
        {
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(10; "Line No"; Integer)
        {
        }
        field(11; "Applies to Doc. No"; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup();
            var
                GenJnlPostLine: Codeunit 12;
                PaymentToleranceMgt: Codeunit 426;
            begin

                "Applies to Doc. No" := '';
                Amt := 0;
                VATAmount := 0;
                "W/TAmount" := 0;

                CASE "Account Type" OF
                    "Account Type"::Customer:
                        BEGIN
                            CustLedger.RESET;
                            CustLedger.SETCURRENTKEY(CustLedger."Customer No.", Open, "Document No.");
                            CustLedger.SETRANGE(CustLedger."Customer No.", "Account No");
                            CustLedger.SETRANGE(Open, TRUE);
                            CustLedger.CALCFIELDS(CustLedger.Amount);
                            IF PAGE.RUNMODAL(0, CustLedger) = ACTION::LookupOK THEN BEGIN

                                IF CustLedger."Applies-to ID" <> '' THEN BEGIN
                                    CustLedger1.RESET;
                                    CustLedger1.SETCURRENTKEY(CustLedger1."Customer No.", Open, "Applies-to ID");
                                    CustLedger1.SETRANGE(CustLedger1."Customer No.", "Account No");
                                    CustLedger1.SETRANGE(Open, TRUE);
                                    CustLedger1.SETRANGE("Applies-to ID", CustLedger."Applies-to ID");
                                    IF CustLedger1.FIND('-') THEN BEGIN
                                        REPEAT
                                            CustLedger1.CALCFIELDS(CustLedger1."Remaining Amount");
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
                                    IF Amount <> ABS(CustLedger.Amount) THEN
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
                            VendLedger.SETRANGE(VendLedger."Vendor No.", "Account No");
                            VendLedger.SETRANGE(Open, TRUE);
                            VendLedger.CALCFIELDS("Remaining Amount");
                            IF PAGE.RUNMODAL(0, VendLedger) = ACTION::LookupOK THEN BEGIN

                                IF VendLedger."Applies-to ID" <> '' THEN BEGIN
                                    VendLedger1.RESET;
                                    VendLedger1.SETCURRENTKEY(VendLedger1."Vendor No.", Open, "Applies-to ID");
                                    VendLedger1.SETRANGE(VendLedger1."Vendor No.", "Account No");
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

            trigger OnValidate();
            var
                CustLedgEntry: Record 21;
                VendLedgEntry: Record 25;
                TempGenJnlLine: Record 81 temporary;
            begin
                //VALIDATE(Description);
                CASE "Account Type" OF
                    "Account Type"::Customer:
                        BEGIN
                            CustLedger.RESET;
                            CustLedger.SETRANGE("Customer No.", "Account No");
                            CustLedger.SETRANGE(Open, TRUE);
                            CustLedger.SETRANGE("Document No.", "Applies to Doc. No");
                            IF CustLedger.FIND('-') THEN BEGIN
                                "Applies-to Doc. Type" := CustLedger."Document Type";
                                //Added to Autopopulate the Invoice Description
                                Description := VendLedger.Description;
                            END;

                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            VendLedger.RESET;
                            VendLedger.SETRANGE("Vendor No.", "Account No");
                            VendLedger.SETRANGE(Open, TRUE);
                            VendLedger.SETRANGE("Document No.", "Applies to Doc. No");
                            IF VendLedger.FIND('-') THEN BEGIN
                                "Applies-to Doc. Type" := VendLedger."Document Type";
                                //Added to Autopopulate the Invoice Description
                                Description := VendLedger.Description;
                            END;

                        END;
                END;
            end;
        }
        field(12; "Claim No"; Code[20])
        {
            TableRelation = Claim WHERE("Claim Status" = CONST(Open));

            trigger OnValidate();
            var
                Claim: Record 51513013;
            begin
                IF Claim.GET("Claim No") THEN BEGIN
                    "Policy Type" := Claim."Policy Type";
                    "Policy No" := Claim."Policy No";
                    IF PolicyType.GET(Claim."Policy Type") THEN
                        "Shortcut Dimension 3 Code" := PolicyType.Class;

                    BalanceRemain := Amount;
                    IF Claim.CALCFIELDS(Claim."Reserve Amount") THEN
                        IF Amount > Claim."Reserve Amount" THEN
                            ERROR('Please increase the Reserve');
                    "Treaty Code" := Claim.TreatyNumber;
                    IF TreatyRec.GET(Claim.TreatyNumber, TreatyRec."Addendum Code") THEN
                        IF TreatyRec."Apportionment Type" = TreatyRec."Apportionment Type"::Proportional THEN
                            IF Amount > TreatyRec."Cash call limit" THEN
                                MESSAGE('This payment exceeds cash call limit');
                    /*Treaty.RESET;
                    IF Treaty.FINDFIRST THEN
                      BEGIN
                        XOLLayers.RESET;
                        XOLLayers.SETRANGE(XOLLayers."Treaty Code",Treaty."Treaty Code");
                        IF XOLLayers.FINDFIRST THEN
                          REPEAT
                            CoinsuranceReinsuranceLines.INIT;
                            CoinsuranceReinsuranceLines."Document Type":=CoinsuranceReinsuranceLines."Document Type"::" ";
                            CoinsuranceReinsuranceLines."No.":=Rec."PV No";
                            CoinsuranceReinsuranceLines."Account Type":=CoinsuranceReinsuranceLines."Account Type"::Customer;
                            CoinsuranceReinsuranceLines."Transaction Type":=CoinsuranceReinsuranceLines."Transaction Type"::"Re-insurance ";
                            CoinsuranceReinsuranceLines."Partner No.":=Treaty."Lead Reinsurer";
                            CoinsuranceReinsuranceLines."Account No.":='040-001';
                            CoinsuranceReinsuranceLines."Excess Of Loss":=TRUE;
                            BalanceRemain:=BalanceRemain-XOLLayers.Deductible;
                            CoinsuranceReinsuranceLines.Amount:=BalanceRemain;
                            //MESSAGE('Inserting %1',BalanceRemain);
                            IF (BalanceRemain>0) AND (XOLLayers.Deductible<>0) THEN
                            CoinsuranceReinsuranceLines.INSERT;

                          UNTIL XOLLayers.NEXT=0;


                      END;*/

                END;




            end;
        }
        field(13; "Benefit ID"; Code[20])
        {
        }
        field(14; "Claimant ID"; Integer)
        {
            TableRelation = "Claim Involved Parties"."Claim Line No." WHERE("Claim No." = FIELD("Claim No"));

            trigger OnValidate();
            begin
                IF Claimants.GET("Claim No", "Claimant ID") THEN BEGIN
                    Claimants.CALCFIELDS(Claimants."Posted Reserve Amount", Claimants."Exess Paid");
                    IF Amount > Claimants."Posted Reserve Amount" THEN
                        ERROR('Please increase reserve amounts for %1', Claimants.Surname);
                    IF Claim.GET("Claim No") THEN
                        Claim.CALCFIELDS(Claim."Premium Balance", Claim."Excess Amount");
                    IF Claim."Premium Balance" > 0 THEN
                        ERROR('You cannot process this claim because the Insured still has a balance of %1', Claim."Premium Balance");
                    IF Claimants."Excess Amount Required" <> 0 THEN
                        IF ABS(Claim."Excess Amount") <> Claimants."Excess Amount Required" THEN
                            ERROR('This claim requires the claimant/insured to pay %1 as an excess and this has not been paid', Claimants."Excess Amount Required");


                END;
            end;
        }
        field(15; "Policy No"; Code[30])
        {
            TableRelation = "Insure Header"."No." WHERE("Document Type" = CONST(Policy));
        }
        field(16; "Amt Premium Currency"; Decimal)
        {
        }
        field(17; "Amt Reporting Currency"; Decimal)
        {
        }
        field(18; Underwriter; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law firms"));
        }
        field(19; "Policy Type"; Code[20])
        {
        }
        field(20; "Claim Line Line No"; Integer)
        {
        }
        field(21; "Patients Name"; Text[250])
        {
        }
        field(22; Insured; Text[30])
        {
        }
        field(23; "Client Type"; Text[30])
        {
        }
        field(24; "Plan Type"; Text[130])
        {
        }
        field(25; Provider; Text[130])
        {
        }
        field(26; Payee; Text[130])
        {
        }
        field(27; "Date of Service"; Date)
        {
        }
        field(28; Diagnosis; Text[250])
        {
        }
        field(29; "ICD10 Code"; Code[10])
        {
        }
        field(30; "Notification date"; Date)
        {
        }
        field(31; "Date settled"; Date)
        {
        }
        field(32; "External Reference"; Code[20])
        {
        }
        field(33; YOA; Code[10])
        {
        }
        field(34; ChequeNo; Code[20])
        {
        }
        field(35; "Pay member"; Decimal)
        {
        }
        field(36; "Pay Provider"; Decimal)
        {
        }
        field(37; "Denial Reason Code"; Code[10])
        {
        }
        field(38; "Denial Statement"; Text[150])
        {
            FieldClass = Normal;
        }
        field(39; "Payment Frequency"; Code[20])
        {
        }
        field(40; "Premium Due Date"; Date)
        {
        }
        field(41; Tax; Boolean)
        {
        }
        field(42; "Bal. Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(43; "Bal. Account No."; Code[30])
        {
        }
        field(44; "KBA Branch Code"; Code[20])
        {
            TableRelation = "Bank Codes";
        }
        field(45; "Bank Account No"; Code[250])
        {
        }
        field(46; "W/Tax Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate();
            begin
                VALIDATE(Amount);
            end;
        }

        field(47; "VAT Amount"; Decimal)
        {
        }
        field(48; "W/Tax Amount"; Decimal)
        {
        }
        field(49; "Net Amount"; Decimal)
        {
            Editable = false;
        }
        field(50; "Loan No"; Code[20])
        {
        }
        field(51; "Asset No"; Code[20])
        {
            TableRelation = "Fixed Asset";
        }
        field(52; "Amount(LCY)"; Decimal)
        {
        }
        field(53; "VAT Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate();
            begin
                VALIDATE(Amount);
            end;
        }
        field(54; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(55; "Retention Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
        }
        field(56; "Retention Amount"; Decimal)
        {
        }
        field(57; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDimensions;
            end;
        }
        field(58; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(59; "Sub Department"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(0));
        }
        field(60; "Transaction Type"; Option)
        {
            OptionCaption = ',Registration Fee,Deposit Contribution,Share Contribution,Loan,Loan Repayment,Withdrawal,Interest Due,Interest Paid,Investment,Dividend Paid,Processing Fee,Withholding Tax,BBF Contribution,Admin Charges,Commission';
            OptionMembers = ,"Registration Fee","Deposit Contribution","Share Contribution",Loan,"Loan Repayment",Withdrawal,"Interest Due","Interest Paid",Investment,"Dividend Paid","Processing Fee","Withholding Tax","BBF Contribution","Admin Charges",Commission;
        }
        field(61; "Commission Amount"; Decimal)
        {
        }
        field(62; "Admin Charges"; Decimal)
        {
        }
        field(50000; "Investment Asset No."; Code[20])
        {
            //TableRelation = Asset;
        }
        field(50001; "Investment Transaction Type"; Option)
        {
            OptionCaption = '" ,Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,Share-split,Premium,Discounts,Other Income,Expenses,Principal"';
            OptionMembers = " ",Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,"Share-split",Premium,Discounts,"Other Income",Expenses,Principal;
        }
        field(50004; "Insurance Trans Type"; Option)
        {
            OptionCaption = '" ,Premium,Commission,Tax,Wht,Excess,Claim Reserve,Claim Payment,Reinsurance Premium,Reinsurance Commission,Reinsurance Premium Taxes,Reinsurance Commission Taxes,Net Premium,Claim Recovery,Salvage,Reinsurance Claim Reserve,Reinsurance Recovery Payment ,Accrued Reinsurance Premium,Deposit Premium,XOL Adjustment Premium"';
            OptionMembers = " ",Premium,Commission,Tax,Wht,Excess,"Claim Reserve","Claim Payment","Reinsurance Premium","Reinsurance Commission","Reinsurance Premium Taxes","Reinsurance Commission Taxes","Net Premium","Claim Recovery",Salvage,"Reinsurance Claim Reserve","Reinsurance Recovery Payment ","Accrued Reinsurance Premium","Deposit Premium","XOL Adjustment Premium";
        }
        field(50005; "Instalment Plan No."; Integer)
        {
            TableRelation = "Instalment Payment Plan"."Payment No";
        }
        field(50006; "Treaty Code"; Code[30])
        {
            TableRelation = Treaty."Treaty Code";
        }
        field(50007; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(50008; "Treaty Addendum"; Integer)
        {
            TableRelation = Treaty."Addendum Code" WHERE("Treaty Code" = FIELD("Treaty Code"));
        }
        field(50009; "XOL Layer"; Code[10])
        {
            TableRelation = "XOL Layers".Layer WHERE("Treaty Code" = FIELD("Treaty Code"),
                                                      "Addendum Code" = FIELD("Treaty Addendum"));
        }
        field(50010; "No. of Units"; Decimal)
        {
        }
        field(50011; "Unit Price"; Decimal)
        {

            trigger OnValidate();
            begin
                Amount := "No. of Units" * "Unit Price";
                VALIDATE(Amount);
            end;
        }
    }

    keys
    {
        key(Key1; "PV No", "Line No")
        {
            SumIndexFields = Amount, "Net Amount";
        }
        key(Key2; Tax)
        {
            SumIndexFields = Amount, "Net Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin

        IF Payments.GET("PV No") THEN
            IF Payments.Posted THEN
                ERROR('You cannot delete the lines at this stage');

        IF Payments.Status <> Payments.Status::Open THEN
            ERROR('You cannot delete the line at this stage');
    end;

    trigger OnInsert();
    begin
        IF Payments.GET("PV No") THEN BEGIN
            IF Payments.Status <> Payments.Status::Open THEN
                ERROR('You cannot insert the line at this stage');
            IF Payments.GET("PV No") THEN BEGIN
                RecPayTypes.RESET;
                // SNN 03302021 RecPayTypes.SETRANGE(RecPayTypes.Code, Payments.Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
                IF RecPayTypes.FINDFIRST THEN BEGIN
                    "Insurance Trans Type" := RecPayTypes."Insurance Trans Type";
                    IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" THEN BEGIN
                        "Account Type" := RecPayTypes."Account Type";
                        "Account No" := RecPayTypes."G/L Account";


                    END
                    ELSE BEGIN
                        "Account Type" := RecPayTypes."Account Type";
                        "Account No" := RecPayTypes."G/L Account";


                    END;
                END;

                "Account Type" := Payments."Account Type";
                "Account No" := Payments."Account No.";

            END;
        END;

        IF RecPayTypes.GET(Payments.Type, RecPayTypes.Type::Payment) THEN BEGIN
            "Insurance Trans Type" := RecPayTypes."Insurance Trans Type";
            "Investment Transaction Type" := RecPayTypes."Investment Transaction Type";
            IF RecPayTypes."VAT Chargeable" = RecPayTypes."VAT Chargeable"::Yes THEN
                "VAT Code" := RecPayTypes."VAT Code";
            IF RecPayTypes."Withholding Tax Chargeable" = RecPayTypes."Withholding Tax Chargeable"::Yes THEN
                "W/Tax Code" := RecPayTypes."Withholding Tax Code";
            IF "Account No" <> '' THEN
                VALIDATE("Account No");
        END;
    end;

    trigger OnModify();
    begin
        IF Payments.GET("PV No") THEN
            IF Payments.Posted THEN
                ERROR('You cannot delete the lines at this stage');

        IF Payments.Status <> Payments.Status::Open THEN
            ERROR('You cannot modify the line at this stage');
    end;

    var
        RecPayTypes: Record 51511002;
        GLAcc: Record 15;
        Cust: Record 18;
        Vend: Record 23;
        FA: Record 5600;
        BankAcc: Record 270;
        NoSeriesMgt: Codeunit 396;
        GenLedgerSetup: Record 98;
        CurrExchRate: Record 330;
        Payments: Record 51511003;
        PaymentToleranceMgt: Codeunit 426;
        PV: Record 51511000;
        CurrencyExchange: Record 330;
        SalesInvoiceHeadr: Record 114;
        AccNo: Code[20];
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        CustLedgEntry: Record 21;
        VendLedgEntry: Record 25;
        PurchInv: Record 122;
        TariffCodes: Record 51511008;
        Amt: Decimal;
        Direction: Text[30];
        VATAmount: Decimal;
        "W/TAmount": Decimal;
        RetAmount: Decimal;
        NetAmount: Decimal;
        VATSetup: Record 325;
        CustLedger: Record 21;
        CustLedger1: Record 21;
        VendLedger: Record 25;
        VendLedger1: Record 25;
        GLAccount: Record 15;
        Customer: Record 18;
        Vendor: Record 23;
        Bank: Record 270;
        FixedAsset: Record 5600;
        CSetup: Record "Cash Management Setup";
        DimMgt: Codeunit 408;
        Treaty: Record 51513007;
        CoinsuranceReinsuranceLines: Record 51513070;
        XOLLayers: Record 51513440;
        BalanceRemain: Decimal;
        TreatyRec: Record 51513007;
        Claimants: Record 51513094;
        PolicyType: Record 51513000;
        Claim: Record 51513013;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDimensions();
    begin

        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "PV No", "Line No"),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}

