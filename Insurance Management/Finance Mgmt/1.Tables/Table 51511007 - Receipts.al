table 51511007 Receipts
{
    // version FINANCE


    fields
    {
        field(1; No; Code[20])
        {

            trigger OnValidate()
            begin
                IF No <> xRec.No THEN BEGIN
                    GenLedgerSetup.GET;
                    NoSeriesMgt.TestManual(GenLedgerSetup."Payments No");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Date; Date)
        {
        }
        field(4; "Pay Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,EFT,Credit Card';
            OptionMembers = " ",Cash,Cheque,EFT,"Credit Card";
        }
        field(5; "Cheque No"; Code[20])
        {
        }
        field(6; "Cheque Date"; Date)
        {

            trigger OnValidate()
            begin
                /*
                GenLedgerSetup.GET;
                IF CALCDATE(GenLedgerSetup."Withholding Agent","Cheque Date")<=TODAY THEN BEGIN
                ERROR('The cheque date is not within the allowed range.');
                END;
                  */
                IF "Cheque Date" > TODAY THEN BEGIN
                    ERROR('The cheque date is not within the allowed range.');
                END;

            end;
        }
        field(9; "Received From"; Text[100])
        {

            trigger OnValidate()
            begin
                "On Behalf Of" := "Received From";
            end;
        }
        field(10; "On Behalf Of"; Text[100])
        {
        }
        field(11; Cashier; Code[20])
        {
        }
        field(12; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(13; "Account No."; Code[20])
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
                "Account Name" := '';

                IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer,
                "Account Type"::Vendor, "Account Type"::"IC Partner"] THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No.");
                                "Account Name" := GLAcc.Name;
                                "Received From" := GLAcc.Name;
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                "Account Name" := Cust.Name;
                                "Received From" := Cust.Name;
                                Currency := Cust."Currency Code";
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                "Account Name" := Vend.Name;
                                "Received From" := Vend.Name;
                                Currency := Vend."Currency Code";
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                "Account Name" := BankAcc.Name;
                                "Received From" := BankAcc.Name;
                                Currency := BankAcc."Currency Code";
                            END;
                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No.");
                                "Account Name" := FA.Description;
                                "Received From" := FA.Description;

                            END;
                    END;
                VALIDATE("Received From");
            end;
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Account Name"; Text[150])
        {
        }
        field(16; Posted; Boolean)
        {
        }
        field(17; "Date Posted"; Date)
        {
        }
        field(18; "Time Posted"; Time)
        {
        }
        field(19; "Posted By"; Code[20])
        {
        }
        field(20; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                "Amount (LCY)" := CurrExchRate.ExchangeAmtFCYToLCY(TODAY, Currency, Amount, "Exchange Factor");
            end;
        }
        field(21; Remarks; Text[100])
        {

            trigger OnValidate()
            begin
                VALIDATE("Applies-to Doc. No.");
            end;
        }
        field(22; "Transaction Name"; Text[100])
        {
        }
        field(27; "Receiving Bank Account"; Code[20])
        {
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                IF BankAcc.GET("Receiving Bank Account") THEN BEGIN
                    Currency := BankAcc."Currency Code";
                    //VALIDATE(Currency);
                END;
            end;
        }
        field(28; Currency; Code[10])
        {
            TableRelation = Currency.Code;

            trigger OnValidate()
            begin
                IF Currency <> '' THEN BEGIN
                    CurrExchRate.RESET;
                    CurrExchRate.SETRANGE(CurrExchRate."Currency Code", Currency);
                    CurrExchRate.SETRANGE(CurrExchRate."Starting Date", 0D, TODAY);
                    IF CurrExchRate.FIND('+') THEN BEGIN
                        "Exchange Rate" := CurrExchRate."Relational Exch. Rate Amount";
                        IF CurrExchRate."Relational Exch. Rate Amount" <> 0 THEN
                            "Exchange Factor" := CurrExchRate."Exchange Rate Amount" / CurrExchRate."Relational Exch. Rate Amount";

                    END;
                END;
            end;
        }
        field(29; "Exchange Rate"; Decimal)
        {
        }
        field(30; "Amount (LCY)"; Decimal)
        {
        }
        field(31; "Exchange Factor"; Decimal)
        {
        }
        field(32; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(33; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
                PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
            begin
            end;

            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                VendLedgEntry: Record "Vendor Ledger Entry";
                TempGenJnlLine: Record "Gen. Journal Line" temporary;
            begin
            end;
        }
        field(34; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';
        }
        field(35; "Policy Type"; Code[20])
        {
        }
        field(50044; "Agent/Broker"; Code[20])
        {
            //TableRelation = Vendor WHERE("Vendor Type" = CONST("Professional Bodies"));
        }
        field(50045; Underwriter; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law firms"));
        }
        field(50047; "Brokers Name"; Text[50])
        {
            Editable = false;
        }
        field(50048; "Undewriter Name"; Text[30])
        {
            Editable = false;
        }
        field(50062; "Quote Type"; Option)
        {
            Editable = true;
            InitValue = New;
            OptionMembers = " ",New,Modification,Renewal;
        }
        field(50066; "Broker #2"; Code[10])
        {
            //TableRelation = Vendor WHERE("Vendor Type" = CONST("Professional Bodies"));
        }
        field(50067; "Broker #3"; Code[10])
        {
           // TableRelation = Vendor WHERE("Vendor Type" = CONST("Professional Bodies"));
        }
        field(50068; "Broker #2 Name"; Text[30])
        {
            Editable = false;
        }
        field(50070; "Commission Due"; Decimal)
        {
        }
        field(50071; "Split 1"; Decimal)
        {
        }
        field(50072; "Split 2"; Decimal)
        {
        }
        field(50073; "Split 3"; Decimal)
        {
        }
        field(50074; "Commissions Generated"; Boolean)
        {
        }
        field(50075; YOA; Code[10])
        {
        }
        field(50076; "Policy Inception Date"; Date)
        {
        }
        field(50077; "Payment Frequency"; Code[20])
        {
        }
        field(50078; "Premium Due Date"; Date)
        {
        }
        field(50079; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Posted = TRUE THEN
            ERROR('The transaction has already been posted and therefore cannot be modified.');
    end;

    trigger OnInsert()
    begin
        IF No = '' THEN BEGIN
            GenLedgerSetup.GET;
            GenLedgerSetup.TESTFIELD(GenLedgerSetup."Payments No");
            NoSeriesMgt.InitSeries(GenLedgerSetup."Payments No", xRec."No. Series", 0D, No, "No. Series");
        END;


        Date := TODAY;
        Cashier := USERID;
    end;

    trigger OnModify()
    begin
        IF Posted = TRUE THEN
            ERROR('The transaction has already been posted and therefore cannot be modified.');
    end;

    trigger OnRename()
    begin
        IF Posted = TRUE THEN
            ERROR('The transaction has already been posted and therefore cannot be modified.');
    end;

    var
        GenLedgerSetup: Record "Cash Management Setup";
        RecPayTypes: Record "Receipts Header";
        GenJnlTemplate: Record 80;
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Cust2: Record Customer;
        Vend: Record Vendor;
        Vend2: Record Vendor;
        ICPartner: Record 413;
        Currency: code [10];
        CurrExchRate: Record "Currency Exchange Rate";
        PaymentTerms: Record 3;
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GenJnlAlloc: Record 221;
        VATPostingSetup: Record "VAT Posting Setup";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        BankAcc3: Record "Bank Account";
        FA: Record "Fixed Asset";
        FASetup: Record 5603;
        FADeprBook: Record "FA Depreciation Book";
        GenBusPostingGrp: Record 250;
        GenProdPostingGrp: Record 251;
        GLSetup: Record "General Ledger Setup";
        JobCurrency: Record 4;
        Job: Record 167;
        JobJnlLine: Record 210;
        ApplyCustEntries: Page 232;
        ApplyVendEntries: Page 233;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustCheckCreditLimit: Codeunit 312;
        SalesTaxCalculate: Codeunit 398;
        GenJnlApply: Codeunit 225;
        CustEntrySetApplID: Codeunit 101;
        VendEntrySetApplID: Codeunit 111;
        DimMgt: Codeunit DimensionManagement;
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        AccNo: Code[20];
        FromCurrencyCode: Code[10];
        ToCurrencyCode: Code[10];
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        ReplaceInfo: Boolean;
        CurrencyCode: Code[10];
        OK: Boolean;
        TemplateFound: Boolean;
        CurrencyDate: Date;
        SourceCodeSetup: Record 242;
        TotalExpenDonPj: Decimal;
        RemainingBalDonPj: Decimal;
        Test: Boolean;
        ExpenPjDon: Decimal;
        BudgetPjDon: Decimal;
        Test1: Boolean;
        BankToTest: Code[20];
        BankOrGLTxn: Boolean;
        Editing: Boolean;
        GnlJournalLineCp: Record "Gen. Journal Line";
        vendor: Record Vendor;
        SalesInvoiceHeadr: Record "Sales Invoice Header";
}

