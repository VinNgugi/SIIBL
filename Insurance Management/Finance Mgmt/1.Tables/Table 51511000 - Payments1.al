table 51511000 Payments1
{
    // version CSHBK

    DrillDownPageID = 51511001;
    LookupPageID = 51511001;

    fields
    {
        field(1; No; Code[20])
        {

            trigger OnValidate();
            begin


                IF No <> xRec.No THEN BEGIN
                    GenLedgerSetup.GET;
                    IF "Payment Type" = "Payment Type"::Normal THEN BEGIN
                        NoSeriesMgt.TestManual(GenLedgerSetup."Payments No");
                    END
                    ELSE BEGIN
                        //NoSeriesMgt.TestManual(GenLedgerSetup."Petty Cash Payments No");
                    END;
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Date; Date)
        {

            trigger OnValidate();
            begin
                /* IF Status=Status::Released THEN BEGIN
                    ERROR('You cannot change the date at this stage');
                     EXIT;
             // change the property so that it cannot be change after the document is released;
                 END*/

            end;
        }
        field(3; Type; Code[20])
        {
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = FILTER(Payment));

            trigger OnValidate();
            begin
                "Account No." := '';
                "Account Name" := '';
                Remarks := '';

                IF RecPayTypes.GET(Type, RecPayTypes.Type::Payment) THEN BEGIN
                    Grouping := RecPayTypes."Default Grouping";
                    "Account Type" := RecPayTypes."Account Type";
                    "Transaction Name" := RecPayTypes.Description;




                    IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" THEN BEGIN
                        IF RecPayTypes."G/L Account" <> '' THEN BEGIN
                            "Account No." := RecPayTypes."G/L Account";
                            VALIDATE("Account No.");
                        END;
                    END;


                END;

                //VALIDATE("Account No.");
            end;
        }
        field(4; "Pay Mode"; Code[30])
        {
            NotBlank = true;
            TableRelation = "Pay Modes".Code;

            trigger OnValidate();
            begin
                IF BankAcc.GET("Paying Bank Account") THEN BEGIN
                    Currency := BankAcc."Currency Code";
                    "Bank Name" := BankAcc.Name;
                    VALIDATE(Currency);
                    VALIDATE(Amount);
                    IF "Pay Mode" = 'CHEQUE' THEN BEGIN
                        "Cheque No" := BankAcc."Last Check No.";
                        MODIFY;
                    END;
                END;
            end;
        }
        field(5; "Cheque No"; Code[20])
        {

            trigger OnValidate();
            begin
                IF "Pay Mode" = 'CHEQUE' THEN
                    ValidateChequeNo("Cheque No");
                PVRec.RESET;
                PVRec.SETRANGE(PVRec."Cheque No", "Cheque No");
                //PVRec.SETFILTER(PVRec.Status,'<>%1',PVRec.Status::Rejected);
                IF PVRec.FIND('-') THEN
                    ERROR('Cheque No %1 has already been used in Payment %2!', PVRec."Cheque No", PVRec.No);
            end;
        }
        field(6; "Cheque Date"; Date)
        {
        }
        field(7; "Cheque Type"; Code[20])
        {
            TableRelation = "Cheque Types";
        }
        field(8; "KBA Bank Code"; Code[20])
        {
            //TableRelation = "Employee Bank Account".Code;
        }
        field(9; "Received From"; Text[100])
        {
        }
        field(10; "On Behalf Of"; Text[100])
        {
        }
        field(11; Cashier; Code[80])
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

            trigger OnValidate();
            begin
                "Account Name" := '';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code, Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);

                IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner"]
                THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No.");
                                "Account Name" := GLAcc.Name;
                                "VAT Code" := RecPayTypes."VAT Code";
                                "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                                "Global Dimension 1 Code" := '';
                                Payee := "Account Name";
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                "Account Name" := Cust.Name;
                                //"VAT Code":=Cust."Default VAT Code";
                                //"Withholding Tax Code":=Cust."Default Withholding Tax Code";
                                //"Global Dimension 1 Code":=Cust."Global Dimension 1 Code";
                                Payee := "Account Name";
                                //SNN 03302021 "KBA Branch Code" := Cust."Preferred Bank Account";
                                "Bank Account No" := Cust."Our Account No.";
                                //SNN 03302021 IF BankCodes.GET(Cust."Preferred Bank Account") THEN
                                "Bank Name and Branch" := BankCodes."Bank Name and Branch";
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                "Account Name" := Vend.Name;
                                //"VAT Code":=Vend."Default VAT Code";
                                //"Withholding Tax Code":=Vend."Default Withholding Tax Code";
                                //"Global Dimension 1 Code":=Vend."Global Dimension 1 Code";
                                Payee := "Account Name";
                                // MESSAGE('%1 and Bank code=%2',Vend.Name,Vend."Preferred Bank Account");;
                                //SNN 03302021 "KBA Branch Code" := Vend."Preferred Bank Account";
                                "Bank Account No" := Vend."Our Account No.";
                                //SNN 03302021 IF BankCodes.GET(Vend."Preferred Bank Account") THEN
                                "Bank Name and Branch" := BankCodes."Bank Name and Branch";
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                "Account Name" := BankAcc.Name;
                                Payee := "Account Name";
                                // "VAT Code":=RecPayTypes."VAT Code";
                                // "Withholding Tax Code":=RecPayTypes."Withholding Tax Code";
                                // "Global Dimension 1 Code":=BankAcc."Global Dimension 1 Code";

                            END;
                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No.");
                                "Account Name" := FA.Description;
                                Payee := "Account Name";
                                //"VAT Code":=FA."Default VAT Code";
                                //"Withholding Tax Code":=FA."Default Withholding Tax Code";
                                // "Global Dimension 1 Code":=FA."Global Dimension 1 Code";

                            END;
                    END;
                Payee := "Account Name";
                VALIDATE(Payee);
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
            Editable = false;
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
        field(19; "Posted By"; Code[80])
        {
        }
        field(20; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                "Amount (LCY)" := CurrExchRate.ExchangeAmtFCYToLCY(Date, Currency, Amount, "Exchange Factor");
                /* IF Tarriff.GET("Withholding Tax Code") THEN
                 BEGIN
                  "Withholding Tax Amount":=(Tarriff.Percentage/100)*Amount;
                  "Net Amount":=Amount-"Withholding Tax Amount";
                 END;*/

            end;
        }
        field(21; Remarks; Text[100])
        {
        }
        field(22; "Transaction Name"; Text[100])
        {
        }
        field(23; "VAT Code"; Code[20])
        {
            TableRelation = "Tarriff Codes";
        }
        field(24; "Withholding Tax Code"; Code[20])
        {
            TableRelation = "Tarriff Codes";

            trigger OnValidate();
            begin
                /* IF Tarriff.GET("Withholding Tax Code") THEN
                 BEGIN
                // MESSAGE('gETS HERE');
                  "Withholding Tax Amount":=(Tarriff.Percentage/100)*Amount;
                  "Net Amount":=Amount-"Withholding Tax Amount";
                 END;*/

            end;
        }
        field(25; "VAT Amount"; Decimal)
        {
        }
        field(26; "Withholding Tax Amount"; Decimal)
        {
        }
        field(27; "Net Amount"; Decimal)
        {
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Bank Account"."No.";

            trigger OnValidate();
            begin
                IF BankAcc.GET("Paying Bank Account") THEN BEGIN
                    Currency := BankAcc."Currency Code";
                    "Bank Name" := BankAcc.Name;
                    VALIDATE(Currency);
                    VALIDATE(Amount);
                    IF "Pay Mode" = 'CHEQUE' THEN BEGIN
                        IF BankAcc."Last Check No." = '' THEN BEGIN
                            PVRec.RESET;
                            PVRec.SETFILTER(PVRec."Cheque No", '<>%1', '');
                            IF PVRec.FIND('+') THEN
                                BankAcc."Last Check No." := PVRec."Cheque No";
                            BankAcc.MODIFY;
                        END;
                        // MESSAGE('Last check no=%1',BankAcc."Last Check No.");

                        EVALUATE(VarInteger, BankAcc."Last Check No.");
                        "Cheque No" := FORMAT(VarInteger + 1);
                        BankAcc."Last Check No." := "Cheque No";
                        BankAcc.MODIFY;

                        // MESSAGE('Last check no=%1',BankAcc."Last Check No.");
                    END;
                END;
            end;
        }
        field(29; Payee; Text[100])
        {
            NotBlank = true;

            trigger OnValidate();
            begin
                Payee := UPPERCASE(Payee);
            end;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(31; "Branch Code"; Code[20])
        {
        }
        field(32; "PO/INV No"; Code[20])
        {
        }
        field(33; "Bank Account No"; Code[20])
        {
        }
        field(34; "Cashier Bank Account"; Code[20])
        {
        }
        field(35; Status; Option)
        {
            Editable = false;
            Enabled = true;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Rejected,Cancelled';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Rejected,Cancelled;
        }
        field(36; Select; Boolean)
        {
        }
        field(37; Grouping; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group".Code
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group".Code;
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";

            trigger OnValidate();
            begin
                IF BankAcc.GET("Paying Bank Account") THEN BEGIN
                    Currency := BankAcc."Currency Code";
                    "Bank Name" := BankAcc.Name;
                    VALIDATE(Currency);
                    VALIDATE(Amount);
                    IF "Pay Mode" = 'CHEQUE' THEN BEGIN
                        "Cheque No" := BankAcc."Last Check No.";
                        MODIFY;
                    END;
                END;
            end;
        }
        field(39; "Bank Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
        }
        field(40; "PV Type"; Option)
        {
            OptionMembers = Normal,Other;
        }
        field(41; "Apply to"; Code[20])
        {
        }
        field(42; "Apply to ID"; Code[20])
        {
        }
        field(43; "No of Units"; Decimal)
        {
        }
        field(44; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(45; Currency; Code[10])
        {
            TableRelation = Currency.Code;

            trigger OnValidate();
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
        field(46; "Exchange Rate"; Decimal)
        {
        }
        field(47; "Amount (LCY)"; Decimal)
        {
        }
        field(48; "Exchange Factor"; Decimal)
        {
        }
        field(49; "Cheque Printed"; Boolean)
        {
        }
        field(50; "Bank Name"; Text[250])
        {
            Editable = false;
        }
        field(51; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("PV Lines1"."Net Amount" WHERE("PV No" = FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52; "KBA Branch Code"; Code[10])
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Bank Account".Code WHERE("Customer No." = FIELD("Account No."))
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Account No."));
        }
        field(53; "Base Amount"; Decimal)
        {
            CalcFormula = Sum("PV Lines1".Amount WHERE("PV No" = FIELD(No), Tax = CONST(false)));
            FieldClass = FlowField;
        }
        field(54; "Transaction Type"; Option)
        {
            OptionMembers = Payments,Imprest;
        }
        field(55; "Imprest No"; Code[20])
        {
            TableRelation = "Request Header";

            trigger OnValidate();
            begin
                IF ReaquestHeader.GET("Imprest No") THEN BEGIN

                END;
            end;
        }
        field(56; Paid; Boolean)
        {
        }
        field(57; "Vendor No"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                IF Vend.GET("Vendor No") THEN
                    Payee := Vend.Name;
            end;
        }
        field(59; Archived; Boolean)
        {
        }
        field(60; Institution; Text[30])
        {
        }
        field(61; "Investment No"; Code[20])
        {
        }
        field(62; "Investment Type"; Option)
        {
            OptionMembers = " ","Money Market",Property,Equity,Mortgage;
        }
        field(63; "Investment Transcation Type"; Option)
        {
            OptionMembers = " ",Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,"Share-split",Premium,Discounts,"Other Income",Expenses,Principal;
        }
        field(64; "Issue No."; Code[20])
        {
        }
        field(65; Rate; Decimal)
        {
        }
        field(66; "No. Printed"; Integer)
        {
        }
        field(67; Collected; Boolean)
        {
        }
        field(68; "Eft Generated"; Boolean)
        {
            Editable = true;
        }
        field(69; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(70; BoardMemberNo; Code[30])
        {
            TableRelation = Employee;
        }
        field(71; "No of Approvals"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(51511003),
                                                        "Document No." = FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(72; "Approval Document Type"; Enum "Approval Document Type")
        {

        }
        field(50000; "Reason Code"; Code[10])
        {
            TableRelation = "Reason Code";
        }
        field(50001; Priority; Option)
        {
            OptionCaption = '" ,High,Medium,Low"';
            OptionMembers = " ",High,Medium,Low;
        }
        field(50002; "No. Of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments";
        }
        field(50003; "Deal Number"; Code[20])
        {
        }
        field(50004; "Charge By"; Option)
        {
            OptionCaption = '" ,OUR,BEN,SHA"';
            OptionMembers = " ",OUR,BEN,SHA;
        }
        field(50005; "Global Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(50006; "Payee Bank account No."; Code[20])
        {
            TableRelation = "Bank Codes";
        }
        field(50007; "Bank Name and Branch"; Text[130])
        {
        }
        field(50008; "Cancellation Reason"; Text[130])
        {
        }
        field(50009; "No. Of signatories"; Integer)
        {
            CalcFormula = Count("Payment Signatories selection" WHERE(PV = FIELD(No)));
            FieldClass = FlowField;
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

    trigger OnDelete();
    begin
        IF Posted = TRUE THEN
            ERROR('The transaction has already been posted and therefore cannot be modified.');

        IF Status <> Status::Open THEN
            ERROR('You cannot modify this voucher');
    end;

    trigger OnInsert();
    begin
        IF No = '' THEN BEGIN
            GenLedgerSetup.GET;

            IF "Payment Type" = "Payment Type"::Normal THEN BEGIN
                GenLedgerSetup.TESTFIELD(GenLedgerSetup."Payments No");
                NoSeriesMgt.InitSeries(GenLedgerSetup."Payments No", xRec."No. Series", 0D, No, "No. Series");
            END
            ELSE BEGIN
                //GenLedgerSetup.TESTFIELD(GenLedgerSetup."Petty Cash Payments No");
                //NoSeriesMgt.InitSeries(GenLedgerSetup."Petty Cash Payments No",xRec."No. Series",0D,No,"No. Series");
            END;
        END;

        Date := TODAY;
        Cashier := USERID;

        IF ImprestRec.GET("PO/INV No") THEN BEGIN
            ImprestRec.CALCFIELDS(ImprestRec."Total Amount Requested");
            IF ImprestRec."Total Amount Requested" > GenLedgerSetup."Cash Limit" THEN
                "Paying Bank Account" := GenLedgerSetup."Default Bank Account"
            ELSE
                "Paying Bank Account" := GenLedgerSetup."Default Cash Account";
        END
        ELSE BEGIN
            "Paying Bank Account" := GenLedgerSetup."Default Bank Account";
            VALIDATE("Paying Bank Account");
        END;
    end;

    trigger OnRename();
    begin
        IF Posted = TRUE THEN
            ERROR('The transaction has already been posted and therefore cannot be modified.');

        IF Status <> Status::Open THEN
            ERROR('You cannot modify this voucher');
    end;

    var
        GLAcc: Record 15;
        Cust: Record 18;
        Vend: Record 23;
        FA: Record 5600;
        BankAcc: Record 270;
        NoSeriesMgt: Codeunit 396;
        GenLedgerSetup: Record 51511018;
        RecPayTypes: Record 51511002;
        CurrExchRate: Record 330;
        LastLineNo: Integer;
        ReaquestHeader: Record 51511003;
        RequestLines: Record 51511004;
        Text000: Label 'You cannot enter zero as the first digit of a cheque Number';
        Text001: Label 'The Cheque Number length should be 5';
        PVRec: Record 51511000;
        VarInteger: Integer;
        NewChequeNo: Integer;
        DimVal: Record 349;
        GLsetup: Record 98;
        BankCodes: Record 51507250;
        ImprestRec: Record 51511003;

    procedure CreateTaxes(var PV: Record Payments1);
    var
        PVlines: Record 51511001;
        GenJnline: Record 81;
        TariffRec: Record 51511008;
        VATPsetup: Record 325;
        PurchInvoice: Record 122;
    begin
        GenJnline.RESET;
        ;
        GenJnline.SETRANGE(GenJnline."Journal Template Name", 'GENERAL');
        GenJnline.SETRANGE(GenJnline."Journal Batch Name", 'ACCR-TAX');
        IF GenJnline.FIND('+') THEN
            LastLineNo := GenJnline."Line No.";


        PVlines.RESET;
        PVlines.SETRANGE(PVlines."PV No", PV.No);
        IF PVlines.FIND('-') THEN
            REPEAT
                LastLineNo := LastLineNo + 10000;
                GenJnline.INIT;
                GenJnline."Journal Template Name" := 'GENERAL';
                GenJnline."Journal Batch Name" := 'ACCR-TAX';
                GenJnline."Line No." := LastLineNo;
                GenJnline."Account Type" := PVlines."Account Type";
                GenJnline."Account No." := PVlines."Account No";
                GenJnline."Posting Date" := PV.Date;
                GenJnline."Document No." := PVlines."PV No";
                GenJnline."External Document No." := PVlines."Applies to Doc. No";
                GenJnline.Description := 'VAT Withheld';
                GenJnline.Amount := PVlines."VAT Amount";
                GenJnline."Bal. Account Type" := GenJnline."Bal. Account Type"::"G/L Account";
                GenJnline."Bal. Account No." := '304000';
                IF GenJnline.Amount <> 0 THEN
                    GenJnline.INSERT;


                GenJnline.INIT;
                LastLineNo := LastLineNo + 10000;
                GenJnline."Journal Template Name" := 'GENERAL';
                GenJnline."Journal Batch Name" := 'ACCR-TAX';
                GenJnline."Line No." := LastLineNo;
                GenJnline."Account Type" := PVlines."Account Type";
                GenJnline."Account No." := PVlines."Account No";
                GenJnline."Posting Date" := PV.Date;
                GenJnline."Document No." := PVlines."PV No";
                GenJnline."External Document No." := PVlines."Applies to Doc. No";
                GenJnline.Description := 'Tax Withheld';
                GenJnline.Amount := PVlines."W/Tax Amount";
                GenJnline."Bal. Account Type" := GenJnline."Bal. Account Type"::"G/L Account";
                GenJnline."Bal. Account No." := '307000';
                IF GenJnline.Amount <> 0 THEN
                    GenJnline.INSERT;



            UNTIL PVlines.NEXT = 0;
    end;

    procedure ValidateChequeNo(ChequeNo: Code[10]);
    var
        FirstDigit: Text[1];
        ChequeLength: Integer;
    begin
        FirstDigit := COPYSTR(ChequeNo, 1, 1);
        IF FirstDigit = '0' THEN
            ERROR(Text000);
        ChequeLength := STRLEN(ChequeNo);
        IF ChequeLength <> 5 THEN
            ERROR(Text001);
    end;
}

