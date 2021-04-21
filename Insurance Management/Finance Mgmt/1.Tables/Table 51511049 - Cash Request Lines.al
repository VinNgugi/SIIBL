table 51511049 "Cash Request Lines"
{
    // version FINANCE


    fields
    {
        field(1; "Document No."; Code[10])
        {
            TableRelation = "Request Header"."No.";
        }
        field(2; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(3; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer WHERE("Customer Posting Group" = FILTER('STAFF'))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor;

            trigger OnValidate()
            begin

                PaymentHeader.RESET;
                PaymentHeader.SETRANGE(PaymentHeader."No.", "Document No.");
                IF PaymentHeader.FINDFIRST THEN BEGIN
                    //PaymentHeader.TESTFIELD("Currency Code");
                    PaymentHeader.TESTFIELD("Global Dimension 1 Code");
                    // PaymentHeader.TESTFIELD("GOK Code");
                    // PaymentHeader.TESTFIELD("Posting Date");

                    // "Currency Code":=PaymentHeader."Currency Code";
                    //  "Department Code":=PaymentHeader."Department Code";
                    // "GOK Code":=PaymentHeader."GOK Code";
                    // "Posting Date":=PaymentHeader."Request Date";
                END;

                CASE "Account Type" OF
                    "Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.RESET;
                            GLAcc.SETRANGE(GLAcc."No.", "Account No.");
                            IF GLAcc.FINDFIRST THEN BEGIN
                                Description := GLAcc.Name;
                            END;
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            Vend.RESET;
                            Vend.SETRANGE(Vend."No.", "Account No.");
                            IF Vend.FINDFIRST THEN
                                Description := Vend.Name;
                        END;
                    "Account Type"::Customer:
                        BEGIN
                            Cust.RESET;
                            Cust.SETRANGE(Cust."No.", "Account No.");
                            IF Cust.FINDFIRST THEN
                                Description := Cust.Name;
                        END;
                END;
            end;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(6; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(7; "Amount Balance"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Balance';
            Editable = false;
        }
        field(8; "Department Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "GOK Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(10; "Amount Paid"; Decimal)
        {

            trigger OnValidate()
            begin
                IF ("VAT Code" = '') OR ("WithHolding Tax Code" = '') THEN
                    "Line Amount" := "Amount Paid"
                ELSE BEGIN
                    CalcVAT;
                    CalcWTAX;
                END;
                RefreshHeader;
            end;
        }
        field(11; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(12; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            InitValue = Invoice;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(13; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
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

            trigger OnLookup()
            var
                GenJnlPostLine: Codeunit 12;
                PaymentToleranceMgt: Codeunit 426;
            begin
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Vendor No.", "Account No.");
                    VendorLedgerEntry.SETRANGE(VendorLedgerEntry.Open, TRUE);
                    VendorLedgerEntries.SETTABLEVIEW(VendorLedgerEntry);
                    VendorLedgerEntries.SETRECORD(VendorLedgerEntry);
                    VendorLedgerEntries.LOOKUPMODE(TRUE);
                    IF VendorLedgerEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        VendorLedgerEntries.GETRECORD(VendorLedgerEntry);
                        "Applies-to Doc. No." := VendorLedgerEntry."Document No.";
                    END;
                    CLEAR(VendorLedgerEntries);
                END;
            end;

            trigger OnValidate()
            var
                CustLedgEntry: Record 21;
                VendLedgEntry: Record 25;
                TempGenJnlLine: Record 81 temporary;
            begin
            end;
        }
        field(14; "VAT Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(15; "WTax Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'WTax Amount';
        }
        field(16; "VAT Code"; Code[10])
        {
            Caption = 'VAT Code';
            TableRelation = "Tarriff Codes";

            trigger OnValidate()
            begin
                CalcVAT;
            end;
        }
        field(17; "WithHolding Tax Code"; Code[10])
        {
            Caption = 'WithHolding Tax Code';
            TableRelation = "Tarriff Codes";

            trigger OnValidate()
            begin
                CalcWTAX;
            end;
        }
        field(19; "VAT Account"; Code[10])
        {
        }
        field(20; Status; Option)
        {
            OptionCaption = 'Preparation,Votebook Accountant,Examination,Chief Finance Accountant,Director Finance Accountant,To Post,Posted';
            OptionMembers = Preparation,"Votebook Accountant",Examination,"Chief Finance Accountant","Director Finance Accountant","To Post",Posted;
        }
        field(21; "Line No."; Integer)
        {
        }
        field(22; "Line Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Line Amount" > "Available Amount" THEN BEGIN
                    ERROR('Sorry. The Amount you put is more than Available Amount By %1!!!', ROUND("Line Amount" - "Available Amount", 0.01));
                END;
            end;
        }
        field(23; "WTax Account"; Code[10])
        {
        }
        field(24; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(25; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(66; Activity; Code[20])
        {

            trigger OnValidate()
            begin
                /*GLSetup.GET;
                
                CASE "Activity Type" OF
                 "Activity Type"::WorkPlan:
                  BEGIN
                  WorkPlan.RESET;
                  WorkPlan.SETRANGE(Code,Activity);
                  IF WorkPlan.FIND('-') THEN BEGIN
                    Activity:=WorkPlan.Code;
                    "Account Type":="Account Type"::"G/L Account";
                    "Account No":=WorkPlan."G/L Account";
                     VALIDATE("Account No");
                     Description:=WorkPlan.Name;
                    "Global Dimension 1 Code":=WorkPlan."Global Dimension 1 Code";
                    "Global Dimension 2 Code":=WorkPlan."Global Dimension 2 Code";
                     "Available Amount":=WorkPlan.Amount;
                   END;
                  END;
                  "Activity Type"::"P&E":
                   BEGIN
                
                   AdminPlan.RESET;
                   AdminPlan.SETRANGE("PE Activity Code",Activity);
                   IF AdminPlan.FIND('-') THEN BEGIN
                    Activity:=AdminPlan."PE Activity Code";
                    "Account Type":="Account Type"::"G/L Account";
                    "Account No":=AdminPlan."G/L Account";
                     VALIDATE("Account No");
                     Description:=AdminPlan.Name;
                    "Global Dimension 1 Code":=AdminPlan."Global Dimension 1 Code";
                    "Global Dimension 2 Code":=AdminPlan."Global Dimension 2 Code";
                    "Available Amount":=AdminPlan.Amount;
                   END;
                   END;
                 END;
                 */

            end;
        }
        field(100; "Activity Type"; Option)
        {
            OptionCaption = ',WorkPlan,Admin & PE,Proc Plan';
            OptionMembers = ,WorkPlan,"Admin & PE","Proc Plan";
        }
        field(101; "Current Budget"; Code[100])
        {
            TableRelation = "G/L Budget Name";
        }
        field(102; "Available Amount"; Decimal)
        {
        }
        field(103; "PE Allowed"; Boolean)
        {
        }
        field(104; Activity_; Code[20])
        {

            trigger OnValidate()
            begin
                //IF (Activity Type=CONST(WorkPlan)) "Work Plan Activities".Code WHERE (Activity Type=CONST(Standard), Work Plan Code=FIELD(Current Budget), Blocked=CONST(False)) ELSE IF (Activity Type=CONST(Admin & PE)) "Procurement Plan Header"."PE Activity Code" W
                /*GLSetup.GET;
                
                CASE "Activity Type" OF
                 "Activity Type"::WorkPlan:
                  BEGIN
                  WorkPlan.RESET;
                  WorkPlan.SETRANGE(Code,Activity_);
                  IF WorkPlan.FIND('+') THEN BEGIN
                  //Message(format(WorkPlan."G/L Account"));
                    Activity:=WorkPlan.Code;
                    "Account Type":="Account Type"::"G/L Account";
                    "Account No.":=WorkPlan."G/L Account";
                     VALIDATE("Account No.");
                     Description:=WorkPlan.Name;
                    //"Global Dimension 1 Code":=WorkPlan."Global Dimension 1 Code";
                    //"Global Dimension 2 Code":=WorkPlan."Global Dimension 2 Code";
                     "Available Amount":=WorkPlan.Balance;//WorkPlan.Amount;
                
                   END;
                  END;
                  "Activity Type"::"Admin & PE":
                   BEGIN
                   //error('...');
                   AdminPlan.RESET;
                   AdminPlan.SETRANGE("PE Activity Code",Activity_);
                   IF AdminPlan.FIND('+') THEN BEGIN
                    Activity:=AdminPlan."PE Activity Code";
                    "Account Type":="Account Type"::"G/L Account";
                    "Account No.":=AdminPlan."G/L Account";
                     VALIDATE("Account No.");
                     Description:=AdminPlan.Name;
                    //"Global Dimension 1 Code":=AdminPlan."Global Dimension 1 Code";
                    //"Global Dimension 2 Code":=AdminPlan."Global Dimension 2 Code";
                    "Available Amount":=AdminPlan.Balance;//AdminPlan.Amount;
                   END;
                   END;
                
                 "Activity Type"::"Proc Plan":
                   BEGIN
                   ProcurementPlan.RESET;
                   ProcurementPlan.SETRANGE("Plan Item No",Activity_);
                   ProcurementPlan.SETRANGE(Type,ProcurementPlan.Type::"G/L Account"); //Add Department Filter
                   ProcurementPlan.SETFILTER("Budget Filter",GLSetup."Current Budget");
                   IF ProcurementPlan.FIND('+') THEN BEGIN
                    Activity:=ProcurementPlan."Plan Item No";
                    "Account No.":=ProcurementPlan."No.";
                    VALIDATE("Account No.");
                     Description:=ProcurementPlan."Item Description";
                
                     //"Unit Price":=ProcurementPlan."Unit Price";
                    //"Global Dimension 1 Code":=ProcurementPlan."Global Dimension 1 Code";
                    //"Global Dimension 2 Code":=ProcurementPlan."Global Dimension 2 Code";
                    "Available Amount":=ProcurementPlan.Balance;//ProcurementPlan."Estimated Cost";
                   END;
                   END;
                 END;
                 */

            end;
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        CashMngt.GET;
        GLSetup.GET;
        "Current Budget" := GLSetup."Current Budget";
        //message('%1',"Current Budget");

        //Allow some PE to Non-Finance Dept People
        CASE "Activity Type" OF
            "Activity Type"::"Admin & PE":
                BEGIN
                    /*AdminPlan.RESET;
                    AdminPlan.SETRANGE(AdminPlan.Code, GLSetup."Current Budget");
                    AdminPlan.SETRANGE(AdminPlan."Global Dimension 1 Code",ReqHeader."Global Dimension 1 Code");
                    AdminPlan.SETRANGE(AdminPlan."Global Dimension 2 Code",ReqHeader."Global Dimension 2 Code");//CashMngt."Finance Code");
                    IF AdminPlan.FIND('-') THEN
                        "PE Allowed" := TRUE;
                    TempPEApp.RESET;
                    TempPEApp.SETRANGE(TempPEApp."Employee No", ReqHeader."Employee No");
                    TempPEApp.SETRANGE(TempPEApp."Doc Request No", ReqHeader."No.");
                    TempPEApp.SETRANGE(TempPEApp.Archived, FALSE);
                    TempPEApp.SETRANGE(TempPEApp.Approved, TRUE);
                    IF TempPEApp.FIND('-') THEN BEGIN
                        AdminPlan.RESET;
                        AdminPlan.SETRANGE(AdminPlan.Code, GLSetup."Current Budget");
                        AdminPlan.SETRANGE(AdminPlan."PE Activity Code", TempPEApp."PE Code");
                        IF AdminPlan.FIND('+') THEN BEGIN
                            "PE Allowed" := TRUE;
                            "Global Dimension 1 Code" := AdminPlan."Global Dimension 1 Code";
                            "Global Dimension 2 Code" := AdminPlan."Global Dimension 2 Code";
                        END;
                    END;*/
                END;
        END;


        //==================================================================================
        userrec.RESET;
        userrec.GET(USERID);
        emprec.RESET;
        emprec.GET(userrec."Employee No.");
        "Global Dimension 1 Code" := emprec."Global Dimension 1 Code";
        "Global Dimension 2 Code" := emprec."Global Dimension 2 Code";
    end;

    var
        TarrifCode: Record 51511008;
        PaymentHeader: Record 51511003;
        GLAcc: Record "G/L Account";
        Vend: Record 23;
        VATPostingSetup: Record 325;
        VATPercentage: Integer;
        WATPercentage: Integer;
        Cust: Record 18;
        VendorLedgerEntry: Record 25;
        VendorLedgerEntries: Page 29;
        GLSetup: Record "Cash Management Setup";
        GLEntry: Record 17;
        Committment: Decimal;
        BudgetAmount: Decimal;
        Balance: Decimal;
        CustLedger: Record 21;
        TransactionTypeRec: Record 51511015;
        ReceiptsHeader: Record 51511027;
        RequestLines: Record 51511004;
        TotalActual: Decimal;
        TotalAmount: Decimal;
        //WorkPlan: Record 51511205;
        GLAccount: Record "G/L Account";
        Expenses: Decimal;
        BudgetAvailable: Decimal;
        Committments: Record "Commitment Entries";
        CommittedAmount: Decimal;
        CommitmentEntries: Record "Commitment Entries";
        ImprestHeader: Record 51511003;
        TotalCommittedAmount: Decimal;
        CashMngt: Record 51511003;
        //AdminPlan: Record 51511390;
        ReqHeader: Record 51511003;
        TempPEApp: Record 51511020;
        //ProcurementPlan: Record 51511391;
        ImpRates: Record 51511021;
        PostRec: Record 51511022;
        Empl: Record Employee;
        userrec: Record "User Setup";
        emprec: Record Employee;

    procedure CalcVAT()
    begin
        IF ("Account Type" = "Account Type"::"G/L Account") OR ("Account Type" = "Account Type"::Vendor) THEN BEGIN
            TarrifCode.RESET;
            TarrifCode.SETRANGE(TarrifCode.Code, "VAT Code");
            IF TarrifCode.FINDFIRST THEN BEGIN
                "Line Amount" := 0;
                "VAT Amount" := 0;
                "VAT Account" := TarrifCode."G/L Account";
                VATPercentage := TarrifCode.Percentage;
                "VAT Amount" := VATPercentage / 100 * "Amount Paid";
                "Line Amount" := "Amount Paid" + "WTax Amount" + "VAT Amount";
            END;
        END;
    end;

    procedure CalcWTAX()
    begin
        IF ("Account Type" = "Account Type"::"G/L Account") OR ("Account Type" = "Account Type"::Vendor) THEN BEGIN
            TarrifCode.RESET;
            TarrifCode.SETRANGE(TarrifCode.Code, "WithHolding Tax Code");
            IF TarrifCode.FINDFIRST THEN BEGIN
                "Line Amount" := 0;
                "WTax Amount" := 0;
                "WTax Account" := TarrifCode."G/L Account";
                WATPercentage := TarrifCode.Percentage;
                "WTax Amount" := WATPercentage / 100 * "Amount Paid";
                "Line Amount" := "Amount Paid" + "WTax Amount" + "VAT Amount";
            END;
        END;
    end;

    procedure RefreshHeader()
    begin
        /*
        CREATE(wShell);
        wShell.SendKeys('^{DOWN}');
        wShell.SendKeys('^{UP}');
        CLEAR(wShell);
         */

    end;
}

