table 51511004 "Request Lines"
{
    // version FINANCE


    fields
    {
        field(1; "Document No"; Code[20])
        {

            trigger OnValidate()
            begin
                RequestHeader.RESET;
                IF RequestHeader.GET("Document No") THEN
                    "Customer A/C" := RequestHeader."Customer A/C";
            end;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Description; Text[250])
        {
        }
        field(4; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                VALIDATE("Unit Price");

                "Requested Amount" := ROUND((Quantity * "Unit Price"), 0.1);
                /*
                IF "Currency Code"<>'' THEN BEGIN
                "USD Amount":=ROUND((Quantity*"Unit Price"),0.1);
                VALIDATE("Exchange Rate");
                END  ELSE
                */
                Amount := ROUND((Quantity * "Unit Price"), 0.1);

            end;
        }
        field(5; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(6; "Unit Price"; Decimal)
        {

            trigger OnValidate()
            begin
                VALIDATE(County);
                //Amount:=ROUND((Quantity*"Unit Price"),0.1);
            end;
        }
        field(7; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Available Amount" < Amount THEN BEGIN
                    ERROR(Text003, "Available Amount", "Budgetted Amount", Amount);
                END;
            end;
        }
        field(8; "Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(9; "Account No"; Code[10])
        {
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

                TESTFIELD("Global Dimension 1 Code");
                TESTFIELD("Global Dimension 2 Code");
                //TESTFIELD("Global Dimension 3 Code");
                //TESTFIELD("Account No");

                //Get Budgetted amount
                "Budgetted Amount" := 0;
                GLSetup.GET;
                BudgetEntry.RESET;
                BudgetEntry.SETRANGE(BudgetEntry."Budget Name", GLSetup."Current Budget");
                BudgetEntry.SETRANGE(BudgetEntry."G/L Account No.", "Account No");
                BudgetEntry.SETRANGE(BudgetEntry."Global Dimension 1 Code", "Global Dimension 1 Code");
                BudgetEntry.SETRANGE(BudgetEntry."Global Dimension 2 Code", "Global Dimension 2 Code");
                //BudgetEntry.SETRANGE(BudgetEntry."Global Dimension 3 Code", "Global Dimension 3 Code");
                IF BudgetEntry.FIND('-') THEN BEGIN
                    BudgetEntry.CALCSUMS(Amount);
                    BudgetAmount := BudgetEntry.Amount;
                END;
                "Budgetted Amount" := BudgetAmount;


                //Get actual Spent
                "Actual Spent" := 0;
                GLEntry.RESET;
                GLEntry.SETRANGE(GLEntry."G/L Account No.", "Account No");
                GLEntry.SETRANGE(GLEntry."Global Dimension 1 Code", "Global Dimension 1 Code");
                GLEntry.SETRANGE(GLEntry."Global Dimension 2 Code", "Global Dimension 2 Code");
                //GLEntry.SETRANGE(GLEntry."Global Dimension 3 Code", "Global Dimension 3 Code");
                IF GLEntry.FIND('-') THEN BEGIN
                    GLEntry.CALCSUMS(Amount);
                    "Actual Spent" := GLEntry.Amount;
                END;

                //Get Committed Amount
                CommitmentEntries.RESET;
                CommitmentEntries.SETRANGE(CommitmentEntries."Account No.", "Account No");
                CommitmentEntries.SETRANGE(CommitmentEntries."Global Dimension 1 Code", "Global Dimension 1 Code");
                CommitmentEntries.SETRANGE(CommitmentEntries."Global Dimension 2 Code", "Global Dimension 2 Code");
                //CommitmentEntries.SETRANGE(CommitmentEntries.Type,CommitmentEntries.Type::Committed);

                IF CommitmentEntries.FIND('-') THEN BEGIN
                    CommitmentEntries.CALCSUMS(Amount);

                    CommittedAmount := CommitmentEntries.Amount;
                    Committment := CommitmentEntries.Amount;
                END;

                "Available Amount" := ABS("Budgetted Amount") - ABS("Actual Spent") - ABS(CommittedAmount);
                MODIFY;



            end;
        }
        field(10; "Transaction Type"; Code[30])
        {
            TableRelation = "Transaction Types";

            trigger OnValidate()
            begin
                IF TransactionTypeRec.GET("Transaction Type") THEN BEGIN
                    "Account Type" := TransactionTypeRec."Account Type";
                    "Account No" := TransactionTypeRec."Account No.";
                    Description := TransactionTypeRec."Transaction Name";
                    IF TransactionTypeRec."Default Amount" <> 0 THEN
                        "USD Amount" := TransactionTypeRec."Default Amount";
                END;
            end;
        }
        field(11; "Reference No"; Code[20])
        {
        }
        field(12; "Requested Amount"; Decimal)
        {
        }
        field(13; Type; Code[10])
        {
            TableRelation = "Trip Advances Setup";

            trigger OnValidate()
            var
                //Triprec: Record 51511273;
            begin
                IF RequestHeader.GET("Document No") THEN BEGIN
                    IF TravelRates.GET(RequestHeader."Job Group", RequestHeader.Country, RequestHeader.City, Type) THEN BEGIN
                        "Unit Price" := TravelRates.Amount;
                    END

                END;

                //=========================Brian K
                Triprecs.RESET;
                Triprecs.SETFILTER(Code, Type);
                IF Triprecs.FINDSET THEN BEGIN
                    IF Triprecs."Mapped Account" <> '' THEN BEGIN
                        Activity := Triprecs."Mapped Account";
                        IF RequestHeader.GET("Document No") THEN BEGIN
                            IF RequestHeader.Type = RequestHeader.Type::PettyCash THEN BEGIN
                                "Account Type" := "Account Type"::"G/L Account";
                                "Account No" := Triprecs."Mapped Account";
                            END;
                        END;
                        VALIDATE(Activity);
                    END;
                END;
                //================================
            end;
        }
        field(14; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = FILTER(Standard),
                                                          Blocked = CONST(False));
        }
        field(15; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = FILTER(Standard),
                                                          Blocked = CONST(False));
        }
        field(16; "Asset No"; Code[20])
        {
            TableRelation = "Fixed Asset";
        }
        field(23; "Actual Spent"; Decimal)
        {

            trigger OnValidate()
            begin
                IF ReceiptNo <> '' THEN BEGIN
                    IF ReceiptsHeader.GET(ReceiptNo) THEN BEGIN
                        ReceiptsHeader.CALCFIELDS("Total Amount");

                        TotalActual := 0;
                        TotalAmount := 0;

                        RequestLines.RESET;
                        RequestLines.SETRANGE(RequestLines."Document No", "Document No");
                        RequestLines.SETRANGE(RequestLines.ReceiptNo, ReceiptNo);
                        IF RequestLines.FIND('-') THEN BEGIN
                            REPEAT
                                TotalActual := TotalActual + RequestLines."Actual Spent";
                                TotalAmount := TotalAmount + RequestLines.Amount;
                            UNTIL RequestLines.NEXT = 0;
                        END;

                        IF ReceiptsHeader."Total Amount" >= ((Amount + TotalAmount) - ("Actual Spent" + TotalActual)) THEN
                            "Remaining Amount" := 0
                        ELSE
                            IF ReceiptsHeader."Total Amount" < ((Amount + TotalAmount) - ("Actual Spent" + TotalActual)) THEN
                                "Remaining Amount" := (Amount - "Actual Spent") - (ReceiptsHeader."Total Amount" - (TotalAmount - TotalActual));
                    END;
                END
                ELSE
                    "Remaining Amount" := Amount - "Actual Spent";
            end;
        }
        field(24; "Remaining Amount"; Decimal)
        {
        }
        field(25; "Entry No"; Integer)
        {
            TableRelation = "Cust. Ledger Entry" WHERE("Customer No." = FIELD("Customer A/C"),
                                                        Open = CONST(True));

            trigger OnValidate()
            begin
                CustLedger.RESET;
                CustLedger.SETRANGE(CustLedger."Entry No.", "Entry No");
                CustLedger.SETRANGE(CustLedger.Open, TRUE);
                IF CustLedger.FIND('-') THEN BEGIN
                    Description := CustLedger.Description;
                    Quantity := 1;
                    CustLedger.CALCFIELDS(CustLedger."Remaining Amount", CustLedger.Amount);
                    "Unit Price" := CustLedger."Remaining Amount";
                    Amount := CustLedger."Remaining Amount";
                    //MESSAGE('RemainingAmt=%1\RequestedAmt=%2',CustLedger.Amount,"Requested Amount");
                    "Reference No" := CustLedger."Document No.";
                    // MESSAGE('Reference=%1',CustLedger."Document No.");
                END;
            end;
        }
        field(26; "Customer A/C"; Code[30])
        {
        }
        field(27; "Expense Type"; Option)
        {
            OptionCaption = 'Accountable Expenses,Non-Accountable Expenses';
            OptionMembers = "Accountable Expenses","Non-Accountable Expenses";
        }
        field(28; Surrender; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Expense Type" = "Expense Type"::"Non-Accountable Expenses" THEN
                    ERROR(Text000);
                IF Amount = 0 THEN
                    ERROR(Text001);
            end;
        }
        field(29; ReceiptNo; Code[30])
        {

            trigger OnValidate()
            begin
                IF ReceiptsHeader.GET(ReceiptNo) THEN BEGIN
                    ReceiptsHeader.CALCFIELDS("Total Amount");
                    "Receipt Amount" := ReceiptsHeader."Total Amount";
                END;
            end;
        }
        field(30; "Receipt Amount"; Decimal)
        {
            Editable = false;
        }
        field(31; Activity; Code[20])
        {
        }
        field(33; Committed; Boolean)
        {
        }
        field(34; "Activity Type"; Option)
        {
            OptionCaption = ',WorkPlan,Admin & PE,Proc Plan';
            OptionMembers = ,WorkPlan,"Admin & PE","Proc Plan";
        }
        field(35; "Current Budget"; Code[100])
        {
            TableRelation = "G/L Budget Name";
        }
        field(36; "Available Amount"; Decimal)
        {
        }
        field(37; "PE Allowed"; Boolean)
        {
        }
        field(38; Country; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(39; County; Code[30])
        {
            TableRelation = Counties;
        }
        field(40; "County Name"; Text[30])
        {
            Editable = false;
        }
        field(50055; "Imprest Purpose"; Option)
        {
            OptionCaption = 'DSA,OTHER';
            OptionMembers = DSA,OTHER;
        }
        field(50056; "Actual Spent Zero"; Boolean)
        {
        }
        field(50057; "Salary Advance Start Date"; Date)
        {
        }
        field(50058; "Salary Advance End Date"; Date)
        {
        }
        field(50059; "Salary Advance Installlments"; Integer)
        {
        }
        field(50060; "USD Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF RequestHeader.GET("Document No") THEN BEGIN
                    RequestHeader.TESTFIELD("Request Date");
                    "Exchange Rate" :=
                          CurrExchRate.ExchangeRate(RequestHeader."Request Date", "Currency Code");
                    IF "Currency Code" = '' THEN
                        "Unit Price" := "USD Amount"
                    ELSE
                        "Unit Price" := ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              RequestHeader."Request Date", "Currency Code",
                              "USD Amount", "Exchange Rate"));
                END;
                Amount := Quantity * "Unit Price";
            end;
        }
        field(50061; "Exchange Rate"; Decimal)
        {

            trigger OnValidate()
            begin

                IF "Exchange Rate" <> 0 THEN BEGIN
                    Amount := "Exchange Rate" * "USD Amount";
                    "Requested Amount" := "Exchange Rate" * "USD Amount";
                END;
            end;
        }
        field(50062; "Global Dimension 3 Code"; Code[20])
        {
            Caption = 'Sub Item Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(False));

            trigger OnValidate()
            begin

                IF ((Quantity <> 0) AND ("Unit Price" <> 0)) THEN
                    Amount := Quantity * "Unit Price";

                VALIDATE("Account No");
            end;
        }
        field(50063; "Budgetted Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50064; "Travel Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Local,International';
            OptionMembers = ,"Local Travel","International Travel";

            trigger OnValidate()
            begin
                IF "Travel Type" = "Travel Type"::"International Travel" THEN BEGIN
                    "Currency Code" := 'USD';
                    VALIDATE("Currency Code");
                    IF TransactionTypeRec.GET("Transaction Type") THEN BEGIN
                        IF TransactionTypeRec."Per Diem" = FALSE THEN BEGIN
                            IF "USD Amount" <> 0 THEN
                                "Unit of Measure" := 'DAY';
                            VALIDATE("USD Amount");
                        END;
                    END;
                END;
                IF "Travel Type" = "Travel Type"::"Local Travel" THEN BEGIN
                    IF "USD Amount" <> 0 THEN
                        "USD Amount" := 0;
                    "Unit Price" := 0;
                    Amount := 0;
                END;
            end;
        }
        field(50065; Destination; Code[20])
        {
            DataClassification = ToBeClassified;
           /*  TableRelation = IF ("Travel Type" = CONST("Local Travel")) "SRC Cluster Places"."Cluster Place"
            ELSE
            IF ("Travel Type" = CONST("International Travel")) "Country/Region.Code";
 */
            trigger OnValidate()
            begin
                CashMngt.GET;
                IF RequestHeader.GET("Document No") THEN BEGIN
                    IF Destination <> '' THEN BEGIN
                        IF RequestHeader."No. of Days" <> 0 THEN
                            Quantity := RequestHeader."No. of Days";
                    END;
                END;
                IF TransactionTypeRec.GET("Transaction Type") THEN BEGIN
                    IF TransactionTypeRec."Per Diem" = TRUE THEN BEGIN
                        //International Travel
                        IF "Travel Type" = "Travel Type"::"International Travel" THEN BEGIN
                            IF ReqHeader.GET("Document No") THEN BEGIN
                                IF Empl.GET(ReqHeader."Employee No") THEN BEGIN
                                    scrscalesinter.RESET;
                                    scrscalesinter.SETRANGE(Country, Destination);
                                    //scrscalesinter.SETRANGE("Salary Scale", Empl."Salary Scale");
                                    IF scrscalesinter.FIND('-') THEN BEGIN
                                        "USD Amount" := scrscalesinter.Amount;
                                        "Unit of Measure" := 'DAY';
                                        "Currency Code" := 'USD';
                                        Description := 'Perdim-International : ';
                                        IF countryrec.GET(Destination) THEN
                                            "Destination Name" := countryrec.Name;
                                        //"Account No":=CashMngt."Per Diem Account";
                                        VALIDATE("USD Amount");
                                    END;
                                END;
                            END;
                        END;
                        //Local Travel
                        IF "Travel Type" = "Travel Type"::"Local Travel" THEN BEGIN
                            IF ReqHeader.GET("Document No") THEN BEGIN
                                IF Empl.GET(ReqHeader."Employee No") THEN BEGIN
                                    Clusterrec.RESET;
                                    Clusterrec.SETRANGE("Cluster Place", Destination);
                                    IF Clusterrec.FIND('-') THEN BEGIN
                                        srcscaleslocal.RESET;
                                        srcscaleslocal.SETRANGE("SRC Cluster", Clusterrec."Cluster Code");
                                        //srcscaleslocal.SETRANGE("Salary Scale", Empl."Salary Scale");
                                        IF srcscaleslocal.FIND('-') THEN BEGIN
                                            "Unit Price" := srcscaleslocal.Amount;
                                            "Unit of Measure" := 'DAY';
                                            Description := 'Perdim-Local : ';
                                            Amount := Quantity * "Unit Price";
                                            "Account No" := CashMngt."Per Diem Account";
                                            "Destination Name" := Clusterrec."Cluster Place";
                                        END;
                                    END;
                                END;
                            END;
                        END;
                    END;
                END;
            end;
        }
        field(50066; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency.Code;

            trigger OnValidate()
            begin
                IF RequestHeader.GET("Document No") THEN BEGIN
                    IF "Currency Code" <> '' THEN BEGIN
                        "Exchange Rate" :=
                            CurrExchRate.ExchangeRate(RequestHeader."Request Date", "Currency Code");
                    END;
                END;
            end;
        }
        field(50067; "Destination Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50068; Committment; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No", "Line No.")
        {
            SumIndexFields = Amount;
        }
        key(Key2; "Expense Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        /*IF RequestHeader.GET("Document No") THEN
        IF RequestHeader.Status<>RequestHeader.Status::Open THEN
        ERROR('You cannot change this document at this stage');
         */

    end;

    trigger OnInsert()
    begin
        //NameDataTypeSubtypeLength WorkPlanRecordWork Plan Activitiesremoved temp
        /*IF RequestHeader.GET("Document No") THEN
        IF RequestHeader.Status<>RequestHeader.Status::Open THEN
        ERROR('You cannot change this document at this stage');
        */

        CashMngt.GET;
        GLSetup.GET;
        "Current Budget" := GLSetup."Current Budget";
        //MESSAGE('%1',"Current Budget");
        ReqHeader.RESET;
        ReqHeader.SETRANGE("No.", "Document No");
        IF ReqHeader.FIND('-') THEN BEGIN
            "Global Dimension 1 Code" := ReqHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := ReqHeader."Global Dimension 2 Code";
            IF ReqHeader."No. of Days" <> 0 THEN BEGIN
                Quantity := ReqHeader."No. of Days";
                "Unit of Measure" := 'DAY';
            END;
            //travelrec.RESET;




        END;

        IF "Imprest Purpose" = "Imprest Purpose"::DSA THEN
            "Unit of Measure" := 'DAY';

    end;

    trigger OnModify()
    begin
        IF RequestHeader.GET("Document No") THEN
            IF RequestHeader.Status <> RequestHeader.Status::Open THEN
                ERROR('You cannot change this document at this stage');


        IF RequestHeader.GET("Document No") THEN BEGIN
            IF RequestHeader.Posted THEN
                ERROR('You cannot change this document at this stage');
        END;


        IF "Imprest Purpose" = "Imprest Purpose"::DSA THEN
            "Unit of Measure" := 'DAY';
    end;

    var
        TravelRates: Record "Trip Advances";
        RequestHeader: Record "Request Header";
        BudgetEntry: Record "G/L Budget Entry";
        GLSetup: Record "Cash Management Setup";
        GLEntry: Record "G/L Entry";
        Committment: Decimal;
        BudgetAmount: Decimal;
        //WorkPlan: Record 51511205;
        Balance: Decimal;
        CustLedger: Record "Cust. Ledger Entry";
        TransactionTypeRec: Record "Transaction Types";
        Text000: Label 'This transaction line cannot be surrendered since it''s not accountable';
        Text001: Label 'You cannot surrender a zero amount';
        ReceiptsHeader: Record "Receipts Header";
        RequestLines: Record "Request Lines";
        TotalActual: Decimal;
        TotalAmount: Decimal;
        GLAccount: Record "G/L Account";
        Expenses: Decimal;
        BudgetAvailable: Decimal;
        Committments: Record "Commitment Entries";
        CommittedAmount: Decimal;
        CommitmentEntries: Record "Commitment Entries";
        ImprestHeader: Record "Request Header";
        TotalCommittedAmount: Decimal;
        CashMngt: Record "Cash Management Setup";
        //AdminPlan: Record "Procurement Plan Header";
        ReqHeader: Record "Request Header";
        TempPEApp: Record "PE Temp Approval";
        //ProcurementPlan: Record "Procurement Plan Header";
        ImpRates: Record "Imprest Rates";
        PostRec: Record Counties;
        Empl: Record Employee;
        Text002: Label 'Imprest Total Amount of %1 is Greater than %2 of your Allowable Allowance Amount for this City of %3 Postal Code %4';
        glaccount2: Record "G/L Account";
        glsetup2: Record "General Ledger Setup";
        glentrybd: Record "G/L Entry";
        WCDate: Date;
        //empmap: Record "Employee Account Mapping";
        startD: Date;
        endD: Date;
        Dimset: Record 480;
        dimvalue: Record "Dimension Value";
        budgetrec: Record 95;
        Empcode: Code[20];
        clubtotposted: Decimal;
        requestlines2: Record "Request Lines";
        requestlinesamount: Decimal;
        totalreqClubamount: Decimal;
        //travelrec: Record 51511203;
        //travelemprec: Record 51511202;
        Triprecs: Record "Trip Advances Setup";
        Factory: Codeunit 51511015;
        glAccountNo: Code[20];
        Text003: Label 'You have exceeded the budget. Available amount is %1 and the budgetted amount is %2.The amount you are applying for is %3. \\Please contact your HOD.';
        Clusterrec: Record 51511026;
        srcscaleslocal: Record 51511024;
        scrscalesinter: Record 51511025;
        countryrec: Record 9;
        CurrExchRate: Record "Currency Exchange Rate";
}

