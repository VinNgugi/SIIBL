table 51511013 "Petty Cash Lines"
{
    // version FINANCE

    DrillDownPageID = 51511002;
    LookupPageID = 51511002;

    fields
    {
        field(1; "PV No"; Code[20])
        {

            trigger OnValidate()
            begin
                /*PV.RESET;
                IF PV.GET("PV No") THEN
                 BEGIN
                  IF PV."Account Type"=PV."Account Type"::Vendor THEN
                   BEGIN
                    "Account Type":="Account Type"::Vendor;
                    "Account No":=PV."Account No.";
                    "Account Name":=PV.
                   END ELSE
                  IF PV."Account Type"=PV."Account Type"::Customer THEN
                   BEGIN
                    "Account Type":="Account Type"::Customer;
                    "Account No":=PV."Account No.";
                    "Account Name":=PV."Account Name";
                   END ELSE
                   BEGIN
                    "Account Type":="Account Type"::"G/L Account";
                    "Account No":='';
                   END;
                 END;
                 */

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

            trigger OnValidate()
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
                                //"KBA Branch Code":=Cust."KBA Code";
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

            trigger OnValidate()
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

            trigger OnValidate()
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




                ///////////////////////
                CashMngt.GET;

                IF CashMngt."Use Budget and Commit Setup" THEN BEGIN

                    CASE "Activity Type" OF
                        "Activity Type"::WorkPlan:
                            BEGIN
                                GLSetup.GET;
                                GLAccount.SETFILTER(GLAccount."Budget Filter", GLSetup."Current Budget");
                                //GLAccount.SETFILTER(GLAccount."WorkPlan  Filter",Activity);
                                GLAccount.SETRANGE(GLAccount."No.", "Account No");
                                //Get budget amount avaliable GLAccount."WorkPlan  Filter"
                                GLAccount.SETRANGE(GLAccount."Date Filter", GLSetup."Current Budget Start Date", GLSetup."Current Budget End Date");
                                IF GLAccount.FIND('-') THEN BEGIN
                                    GLAccount.CALCFIELDS(GLAccount."Budgeted Amount", GLAccount."Net Change");
                                    BudgetAmount := GLAccount."Budgeted Amount";
                                    Expenses := GLAccount."Net Change";

                                    MESSAGE('Budgeted Amnt%1, NetChange%2', BudgetAmount, Expenses);
                                    BudgetAvailable := GLAccount."Budgeted Amount" - GLAccount."Net Change";
                                    //MESSAGE('Budget Amount%1 NetChange%2',GLAccount."Budgeted Amount",GLAccount."Net Change");
                                END;

                                //Get committed Amount
                                CommittedAmount := 0;
                                CommitmentEntries.RESET;
                                // CommitmentEntries.SETCURRENTKEY(CommitmentEntries.GLAccount);
                                //  CommitmentEntries.SETRANGE(CommitmentEntries.GLAccount,"Account No");

                                ImprestHeader.RESET;
                                ImprestHeader.SETRANGE(ImprestHeader."No.", "PV No");
                                IF ImprestHeader.FIND('-') THEN BEGIN

                                    IF ImprestHeader."Request Date" = 0D THEN
                                        ERROR('Please insert the imprest date');
                                    /*
                                     CommitmentEntries.SETRANGE(CommitmentEntries."Commitment Date",GLSetup."Current Budget Start Date",
                                                               ImprestHeader."Request Date");
                                     CommitmentEntries.CALCSUMS(CommitmentEntries."Committed Amount");
                                     CommittedAmount:=CommitmentEntries."Committed Amount";
                                     */
                                    /*IF LineBudget(No,"Account No.","Line No")THEN
                                       MESSAGE('Line No %1 has been included in the Budget',"Line No")
                                    ELSE*/
                                    IF Rec."Account Type" = "Account Type"::"G/L Account" THEN
                                        IF CommittedAmount + Amount > BudgetAvailable THEN
                                            ERROR('You have Exceeded Budget for Activitiy %1 By %2 Budget Available %3 CommittedAmount %4'
                                           , Activity,
                                            ABS(BudgetAvailable - (CommittedAmount + Amount)), BudgetAvailable, CommittedAmount);
                                END;


                            END;
                        "Activity Type"::"P&E":
                            BEGIN

                                GLSetup.GET;
                                GLAccount.SETFILTER(GLAccount."Budget Filter", GLSetup."Current Budget");
                                // GLAccount.SETFILTER(GLAccount."PE Admin Filter",Activity);
                                GLAccount.SETRANGE(GLAccount."No.", "Account No");
                                //Get budget amount avaliable
                                GLAccount.SETRANGE(GLAccount."Date Filter", GLSetup."Current Budget Start Date", GLSetup."Current Budget End Date");
                                IF GLAccount.FIND('-') THEN BEGIN
                                    GLAccount.CALCFIELDS(GLAccount."Budgeted Amount", GLAccount."Net Change");
                                    BudgetAmount := GLAccount."Budgeted Amount";
                                    Expenses := GLAccount."Net Change";
                                    BudgetAvailable := GLAccount."Budgeted Amount" - GLAccount."Net Change";
                                    //MESSAGE('Budget Amount%1 NetChange%2',GLAccount."Budgeted Amount",GLAccount."Net Change");
                                END;

                                //Get committed Amount
                                CommittedAmount := 0;
                                CommitmentEntries.RESET;
                                // CommitmentEntries.SETCURRENTKEY(CommitmentEntries.GLAccount);
                                // CommitmentEntries.SETRANGE(CommitmentEntries.GLAccount,"Account No");

                                ImprestHeader.RESET;
                                ImprestHeader.SETRANGE(ImprestHeader."No.", "PV No");
                                IF ImprestHeader.FIND('-') THEN BEGIN

                                    IF ImprestHeader."Request Date" = 0D THEN
                                        ERROR('Please insert the imprest date');
                                    /*
                                    CommitmentEntries.SETRANGE(CommitmentEntries."Commitment Date",GLSetup."Current Budget Start Date",
                                                              ImprestHeader."Request Date");
                                    CommitmentEntries.CALCSUMS(CommitmentEntries."Committed Amount");
                                    CommittedAmount:=CommitmentEntries."Committed Amount";
                                    */
                                    /*
                                    IF LineBudget(No,"Account No.","Line No")THEN
                                       MESSAGE('Line No %1 has been included in the Budget',"Line No")
                                    ELSE
                                    IF Rec."Account Type" = "Account Type"::"G/L Account" THEN
                                      IF CommittedAmount + Amount>BudgetAvailable THEN
                                         ERROR('You have Exceeded Budget for G/L Account No %1 By %2 Budget Available %3 CommittedAmount %4'
                                        ,"Account No",
                                         ABS(BudgetAvailable - (CommittedAmount+Amount)),BudgetAvailable,CommittedAmount);
                                         */
                                END;
                            END;
                    END;


                END;

            end;
        }
        field(7; Grouping; Code[10])
        {
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
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

            trigger OnLookup()
            var
                GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
                PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
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

            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                VendLedgEntry: Record "Vendor Ledger Entry";
                TempGenJnlLine: Record "Gen. Journal Line" temporary;
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
        }
        field(13; "Benefit ID"; Code[20])
        {
        }
        field(14; "Claimant ID"; Integer)
        {
        }
        field(15; "Policy No"; Code[20])
        {
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
            TableRelation = "Staff  Bank Account".Code;
        }
        field(45; "Bank Account No"; Code[250])
        {
        }
        field(46; "W/Tax Code"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
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

            trigger OnValidate()
            begin
                VALIDATE(Amount);
            end;
        }
        field(54; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
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

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(58; "Global Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(59; "Sub Department"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(0));
        }
        field(60; Activity; Code[20])
        {
           /* TableRelation = IF ("Activity Type" = CONST(WorkPlan)) "Work Plan Activitiesz".Code WHERE("Activity Type" = CONST(Standard),
                                                                                                   "Work Plan Code" = FIELD("Current Budget"),
                                                                                                   Blocked = FILTER(No))
            ELSE
            IF ("Activity Type" = CONST("P&E")) "Procurement Plan Header"."PE Activity Code" WHERE(Code = FIELD("Current Budget"), 
                                                                                                                    Blocked = FILTER(No));*/

            trigger OnValidate()
            begin
                GLSetup.GET;

                CASE "Activity Type" OF
                    "Activity Type"::WorkPlan:
                        BEGIN
                            /* WorkPlan.RESET;
                            WorkPlan.SETRANGE(Code, Activity);
                            IF WorkPlan.FIND('-') THEN BEGIN
                                Activity := WorkPlan.Code;
                                "Account Type" := "Account Type"::"G/L Account";
                                "Account No" := WorkPlan."G/L Account";
                                VALIDATE("Account No");
                                Description := WorkPlan.Name;
                                "Shortcut Dimension 1 Code" := WorkPlan."Global Dimension 1 Code";
                                "Shortcut Dimension 2 Code" := WorkPlan."Global Dimension 2 Code";
                                "Available Amount" := WorkPlan.Amount;
                            END; */
                        END;
                    "Activity Type"::"P&E":
                        BEGIN

                          /*   AdminPlan.RESET;
                            AdminPlan.SETRANGE("PE Activity Code", Activity);
                            IF AdminPlan.FIND('-') THEN BEGIN
                                Activity := AdminPlan."PE Activity Code";
                                "Account Type" := "Account Type"::"G/L Account";
                                "Account No" := AdminPlan."G/L Account";
                                VALIDATE("Account No");
                                Description := AdminPlan.Name;
                                "Shortcut Dimension 1 Code" := AdminPlan."Global Dimension 1 Code";
                                "Shortcut Dimension 2 Code" := AdminPlan."Global Dimension 2 Code";
                                "Available Amount" := AdminPlan.Amount;
                            END; */
                        END;
                END;
            end;
        }
        field(61; Committed; Boolean)
        {
        }
        field(62; "Activity Type"; Option)
        {
            OptionCaption = ',WorkPlan,P&E';
            OptionMembers = ,WorkPlan,"P&E";
        }
        field(63; "Current Budget"; Code[100])
        {
            TableRelation = "G/L Budget Name";
        }
        field(64; "Available Amount"; Decimal)
        {
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

    trigger OnDelete()
    begin
        IF Payments.GET("PV No") THEN
            IF Payments.Posted THEN
                ERROR('You cannot delete the line at this stage');

        IF Payments.GET("PV No") THEN
            IF Payments.Status <> Payments.Status::Open THEN
                ERROR('You cannot delete the line at this stage');
    end;

    trigger OnInsert()
    begin
        IF Payments.GET("PV No") THEN
            IF Payments.Status <> Payments.Status::Open THEN
                ERROR('You cannot insert the line at this stage');
    end;

    trigger OnModify()
    begin
        IF Payments.GET("PV No") THEN
            IF Payments.Posted THEN
                ERROR('You cannot delete the line at this stage');
        IF Payments.GET("PV No") THEN
            IF Payments.Status <> Payments.Status::Open THEN
                ERROR('You cannot modify the line at this stage');
    end;

    trigger OnRename()
    begin
        IF Payments.GET("PV No") THEN
            IF Payments.Posted THEN
                ERROR('You cannot rename the lines at this stage');

        IF Payments.GET("PV No") THEN
            IF Payments.Status <> Payments.Status::Open THEN
                ERROR('You cannot rename the line at this stage');
    end;

    var
        RecPayTypes: Record "Receipts and Payment Types";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenLedgerSetup: Record "Cash Management Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        Payments: Record "Request Header";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        PV: Record "Request Header";
        CurrencyExchange: Record "Currency Exchange Rate";
        SalesInvoiceHeadr: Record "Sales Cr.Memo Header";
        AccNo: Code[20];
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchInv: Record "Purch. Inv. Header";
        TariffCodes: Record "Tarriff Codes";
        Amt: Decimal;
        Direction: Text[30];
        VATAmount: Decimal;
        "W/TAmount": Decimal;
        RetAmount: Decimal;
        NetAmount: Decimal;
        VATSetup: Record "VAT Posting Setup";
        CustLedger: Record "Cust. Ledger Entry";
        CustLedger1: Record "Cust. Ledger Entry";
        VendLedger: Record "Vendor Ledger Entry";
        VendLedger1: Record "Vendor Ledger Entry";
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Bank: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        CSetup: Record "Cash Management Setup";
        DimMgt: Codeunit DimensionManagement;
        //WorkPlan: Record 51511205;
        Expenses: Decimal;
        BudgetAvailable: Decimal;
        Committments: Record "Commitment Entries";
        CommittedAmount: Decimal;
        CommitmentEntries: Record "Commitment Entries";
        ImprestHeader: Record "Request Header";
        TotalCommittedAmount: Decimal;
        CashMngt: Record "Cash Management Setup";
        //AdminPlan: Record "Procurement Plan Header";
        GLSetup: Record "Cash Management Setup";
        BudgetAmount: Decimal;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDimensions()
    begin

        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "PV No", "Line No"),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}

