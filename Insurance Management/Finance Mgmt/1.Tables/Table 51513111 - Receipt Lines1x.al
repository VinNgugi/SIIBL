table 51513111 "Receipt Lines1x"
{
    // version CSHBK

    DrillDownPageID = 51513125;
    LookupPageID = 51513125;

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Receipt No."; Code[20])
        {
            TableRelation = "Receipts Headerx";
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
                /* IF ReceiptHeader.GET("Receipt No.") THEN
                   BEGIN
                  IF "Account No."<>ReceiptHeader."Account No." THEN
                    ERROR('Account no. on the header must match the account no. on the lines');
                  IF "Account Type"<>ReceiptHeader."Account Type" THEN
                    ERROR('Account Type on the header must match the account Type on the lines');
                
                  END;*/

            end;
        }
        field(5; "Account Name"; Text[50])
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
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(14; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Applies to Doc. No"; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                GenJnlPostLine: Codeunit 12;
                PaymentToleranceMgt: Codeunit 426;
            begin
                IF ReceiptHeader.GET("Receipt No.") THEN
                    IF ReceiptHeader."Receipt Amount type" = ReceiptHeader."Receipt Amount type"::" " THEN
                        ERROR('Please specify receipt amount type');

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
                            IF "Insurance Trans Type" <> "Insurance Trans Type"::"Net Premium" THEN
                                CustLedger.SETRANGE(CustLedger."Customer No.", "Account No.")
                            ELSE
                                CustLedger.SETRANGE(CustLedger."Insured ID", "Insured ID");
                            // bkk 30.03.2021 CustLedger.SETRANGE(CustLedger."Insurance Trans Type", "Insurance Trans Type");
                            CustLedger.SETRANGE(Open, TRUE);
                            CustLedger.CALCFIELDS("Remaining Amount");
                            IF PAGE.RUNMODAL(0, CustLedger) = ACTION::LookupOK THEN BEGIN

                                IF CustLedger."Applies-to ID" <> '' THEN BEGIN
                                    CustLedger1.RESET;
                                    CustLedger1.SETCURRENTKEY(CustLedger1."Customer No.", Open, "Applies-to ID");
                                    IF "Insurance Trans Type" <> "Insurance Trans Type"::"Net Premium" THEN
                                        CustLedger1.SETRANGE(CustLedger1."Customer No.", "Account No.")
                                    ELSE
                                        CustLedger1.SETRANGE(CustLedger1."Insured ID", "Insured ID");
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
                                    // Insurer:=CustLedger.Insurer;
                                END ELSE BEGIN
                                    IF Amount <> ABS(CustLedger."Remaining Amount") THEN
                                        CustLedger.CALCFIELDS(CustLedger."Remaining Amount");
                                    IF Amount = 0 THEN
                                        Amount := ABS(CustLedger."Remaining Amount");
                                    VALIDATE(Amount);
                                    "Applies to Doc. No" := CustLedger."Document No.";
                                    IF DrNote.GET("Applies to Doc. No") THEN BEGIN
                                        "Policy No." := DrNote."Policy No";
                                        "Account No." := CustLedger1."Customer No.";
                                        "Endorsement Policy No." := DrNote."Endorsement Policy No.";

                                    END;
                                    IF CrNote.GET("Applies to Doc. No") THEN BEGIN

                                        "Policy No." := CrNote."Policy No";
                                        "Account No." := CustLedger1."Customer No.";
                                    END;
                                    //Insurer:=CustLedger.Insurer;



                                END;
                            END;
                            IF ReceiptHeader."Receipt Amount type" = ReceiptHeader."Receipt Amount type"::"Net " THEN BEGIN
                                Amt := 0;
                                CustLedger1.RESET;
                                CustLedger1.SETRANGE(Open, TRUE);
                                CustLedger1.SETRANGE(CustLedger1."Policy Number", "Policy No.");
                                CustLedger1.SETFILTER(CustLedger1."Insurance Trans Type", '%1|%2|%3', "Insurance Trans Type"::"Net Premium", "Insurance Trans Type"::Commission, "Insurance Trans Type"::Wht);
                                //CustLedger1.SETRANGE(CustLedger1."Insurance Trans Type",CustLedger1."Insurance Trans Type"::"Net Premium");
                                IF CustLedger1.FIND('-') THEN BEGIN
                                    REPEAT
                                        CustLedger1.CALCFIELDS("Remaining Amount");
                                        Amt := Amt + CustLedger1."Remaining Amount";
                                        "Applies to Doc. No" := CustLedger1."Document No.";
                                        "Endorsement Policy No." := CustLedger1."Endorsement No.";
                                    UNTIL CustLedger1.NEXT = 0;
                                END;
                                Amount := Amt;
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
                CustLedgEntry: Record 21;
                VendLedgEntry: Record 25;
                TempGenJnlLine: Record 81 temporary;
            begin


                CASE "Account Type" OF
                    "Account Type"::Customer:
                        BEGIN
                            CustLedger.RESET;
                            IF "Insurance Trans Type" <> "Insurance Trans Type"::"Net Premium" THEN
                                CustLedger.SETRANGE("Customer No.", "Account No.")
                            ELSE
                                CustLedger.SETRANGE(CustLedger."Insured ID", "Insured ID");

                            CustLedger.SETRANGE(Open, TRUE);
                            CustLedger.SETRANGE("Document No.", "Applies to Doc. No");
                            IF CustLedger.FIND('-') THEN BEGIN
                                "Applies-to Doc. Type" := CustLedger."Document Type";
                                //Insurer:=CustLedger.Insurer;
                                IF DrNote.GET("Applies to Doc. No") THEN BEGIN
                                    "Policy No." := DrNote."Policy No";
                                    IF DrNote."Endorsement Policy No." = '' THEN
                                        "Endorsement Policy No." := DrNote."Policy No"
                                    ELSE
                                        "Endorsement Policy No." := DrNote."Endorsement Policy No.";

                                    IF "Insurance Trans Type" <> "Insurance Trans Type"::"Net Premium" THEN
                                        "Insured ID" := DrNote."Insured No."
                                    ELSE BEGIN
                                        "Account No." := CustLedger."Customer No.";

                                        "Global Dimension 1 Code" := DrNote."Shortcut Dimension 1 Code";
                                    END;
                                    IF CrNote.GET("Applies to Doc. No") THEN BEGIN
                                        "Policy No." := CrNote."Policy No";
                                        IF "Insurance Trans Type" <> "Insurance Trans Type"::"Net Premium" THEN
                                            "Insured ID" := CrNote."Insured No."
                                        ELSE BEGIN
                                            "Account No." := CustLedger."Customer No.";

                                            "Global Dimension 1 Code" := CrNote."Shortcut Dimension 1 Code";
                                        END;
                                    END;
                                END;
                            END;
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
        field(17; "In Payment For"; Text[100])
        {
        }
        field(18; Insurer; Code[20])
        {
            TableRelation = Vendor;
        }
        field(19; Paid; Boolean)
        {
        }
        field(20; "Policy No."; Code[30])
        {
            TableRelation = "Insure Header"."No." WHERE("Document Type" = CONST(Policy));

            trigger OnValidate()
            begin
                IF ReceiptHeader.GET("Receipt No.") THEN BEGIN
                    IF ReceiptHeader."Receipt Amount type" = ReceiptHeader."Receipt Amount type"::Gross THEN BEGIN
                        CustLedger1.RESET;
                        CustLedger1.SETRANGE(Open, TRUE);
                        CustLedger1.SETRANGE(CustLedger1."Policy Number", "Policy No.");
                        CustLedger1.SETRANGE(CustLedger1."Insurance Trans Type", CustLedger1."Insurance Trans Type"::"Net Premium");
                        IF CustLedger1.FIND('-') THEN BEGIN
                            REPEAT
                                CustLedger1.CALCFIELDS("Remaining Amount");
                                ExpectedAmt := ExpectedAmt + CustLedger1."Remaining Amount";
                                "Applies to Doc. No" := CustLedger1."Document No.";
                                "Endorsement Policy No." := CustLedger1."Endorsement No.";
                            UNTIL CustLedger1.NEXT = 0;
                        END;
                    END;
                    IF ReceiptHeader."Receipt Amount type" = ReceiptHeader."Receipt Amount type"::"Net " THEN BEGIN
                        CustLedger1.RESET;
                        CustLedger1.SETRANGE(Open, TRUE);
                        CustLedger1.SETRANGE(CustLedger1."Policy Number", "Policy No.");
                        CustLedger1.SETFILTER(CustLedger1."Insurance Trans Type", '%1|%2|%3', "Insurance Trans Type"::"Net Premium", "Insurance Trans Type"::Commission, "Insurance Trans Type"::Wht);
                        //CustLedger1.SETRANGE(CustLedger1."Insurance Trans Type",CustLedger1."Insurance Trans Type"::"Net Premium");
                        IF CustLedger1.FIND('-') THEN BEGIN
                            REPEAT
                                CustLedger1.CALCFIELDS("Remaining Amount");
                                ExpectedAmt := ExpectedAmt + CustLedger1."Remaining Amount";
                                "Applies to Doc. No" := CustLedger1."Document No.";
                                "Endorsement Policy No." := CustLedger1."Endorsement No.";
                            UNTIL CustLedger1.NEXT = 0;
                        END;
                    END;
                END;


                "Expected Amount Due" := ExpectedAmt;
                CustLedger1.RESET;
                CustLedger1.SETRANGE(CustLedger1."Policy Number", "Policy No.");
                IF CustLedger1.FINDLAST THEN BEGIN
                    "Account Type" := "Account Type"::Customer;
                    "Account No." := CustLedger1."Customer No.";
                    "Insured ID" := CustLedger1."Insured ID";

                END;
            end;
        }
        field(50004; "Insurance Trans Type"; Option)
        {
            OptionCaption = ' ,Premium,Commission,Tax,Wht,Excess,Claim Reserve,Claim Payment,Reinsurance Premium,Reinsurance Commission,Reinsurance Premium Taxes,Reinsurance Commission Taxes,Net Premium,Claim Recovery,Salvage,Reinsurance Claim Reserve,Reinsurance Recovery Payment ,Accrued Reinsurance Premium,Deposit Premium,XOL Adjustment Premium';
            OptionMembers = " ",Premium,Commission,Tax,Wht,Excess,"Claim Reserve","Claim Payment","Reinsurance Premium","Reinsurance Commission","Reinsurance Premium Taxes","Reinsurance Commission Taxes","Net Premium","Claim Recovery",Salvage,"Reinsurance Claim Reserve","Reinsurance Recovery Payment ","Accrued Reinsurance Premium","Deposit Premium","XOL Adjustment Premium";
        }
        field(50005; "Investment Transaction Type"; Option)
        {
            OptionCaption = ' ,Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,Share-split,Premium,Discounts,Other Income,Expenses,Principal';
            OptionMembers = " ",Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,"Share-split",Premium,Discounts,"Other Income",Expenses,Principal;
        }
        field(68000; "Transaction Type"; Option)
        {
            OptionCaption = ',Registration Fee,Deposit Contribution,Share Contribution,Loan,Loan Repayment,Withdrawal,Interest Due,Interest Paid,Investment,Dividend Paid,Processing Fee,Withholding Tax,BBF Contribution,Admin Charges,Commission';
            OptionMembers = ,"Registration Fee","Deposit Contribution","Share Contribution",Loan,"Loan Repayment",Withdrawal,"Interest Due","Interest Paid",Investment,"Dividend Paid","Processing Fee","Withholding Tax","BBF Contribution","Admin Charges",Commission;
        }
        field(68001; "Loan No"; Code[20])
        {
            //TableRelation = "Loan Application1" WHERE ("Debtors Code"=FIELD("Account No."));
        }
        field(68002; "Group Code"; Code[20])
        {
        }
        field(68003; Type; Option)
        {
            OptionCaption = ' ,Registration,PassBook,Loan Insurance,Loan Application Fee,Down Payment';
            OptionMembers = " ",Registration,PassBook,"Loan Insurance","Loan Application Fee","Down Payment";
        }
        field(68004; "Member Name"; Text[30])
        {
        }
        field(68005; "Loan Product Type"; Code[20])
        {
        }
        field(68006; "Reference Period"; Date)
        {
            //TableRelation = "Loan Repayment Schedule"."Repayment Date" WHERE (Member No.=FIELD(Account No.),Loan No.=FIELD(Loan No));
        }
        field(68007; "Principal Repayment"; Decimal)
        {
        }
        field(68008; "Interest Repayment"; Decimal)
        {
        }
        field(68009; "Claim No."; Code[20])
        {
            TableRelation = Claim;

            trigger OnValidate()
            begin
                IF ClaimRec.GET("Claim No.") THEN BEGIN

                    "Policy No." := ClaimRec."Policy No";
                    "Policy Type" := ClaimRec."Policy Type";
                    "Global Dimension 3 Code" := ClaimRec.MainClasscode;
                    "Insured Name" := ClaimRec."Name of Insured";
                END;
            end;
        }
        field(68010; "Insured ID"; Code[20])
        {
        }
        field(68011; "Claimant ID"; Integer)
        {
            TableRelation = "Claim Involved Parties"."Claim Line No." WHERE("Claim No."=FIELD("Claim No."));

            trigger OnValidate()
            begin
                IF ClaimantRec.GET("Claim No.","Claimant ID") THEN
                  "Claimant Name":=ClaimantRec.Surname;
            end;
        }
        field(68012;"Endorsement Policy No.";Code[30])
        {
        }
        field(68013;"Expected Amount Due";Decimal)
        {
        }
        field(68014;"Global Dimension 3 Code";Code[20])
        {
            CaptionClass = '1,2,3';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3));
        }
        field(68015;"Global Dimension 4 Code";Code[20])
        {
            CaptionClass = '1,2,4';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(4));
        }
        field(68016;"Policy Type";Code[20])
        {
            TableRelation = "Policy Type";
        }
        field(68017;"Insured Name";Text[80])
        {
        }
        field(68018;"Claimant Name";Text[80])
        {
        }
        field(68019;"Imprest No.";Code[20])
        {
            TableRelation = "Request Header" WHERE ("Customer A/C"=FIELD("Account No."));
        }
    }

    keys
    {
        key(Key1;"Line No","Receipt No.")
        {
            SumIndexFields = Amount;
        }
        key(Key2;"Applies to Doc. No",Paid)
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF ReceiptHeader.GET("Receipt No.") THEN
          BEGIN
            "Account Type":=ReceiptHeader."Account Type";
            IF ReceiptHeader."Account No."<>'' THEN
            "Account No.":=ReceiptHeader."Account No.";

            IF ReceiptHeader."Agent Code"<>'' THEN
            "Account No.":=ReceiptHeader."Agent Code";

            "Insured ID":=ReceiptHeader."Account No.";

            VALIDATE("Account No.");
            Description:=ReceiptHeader."Payments for";
            IF ReceiptPayTypes.GET(ReceiptHeader."Receipt Type",ReceiptPayTypes.Type::Receipt) THEN
              BEGIN
                "Insurance Trans Type":=ReceiptPayTypes."Insurance Trans Type";
                "Investment Transaction Type":=ReceiptPayTypes."Investment Transaction Type";
              END;
              "Global Dimension 1 Code":=ReceiptHeader."Global Dimension 1 Code";
              "Global Dimension 2 Code":=ReceiptHeader."Global Dimension 2 Code";

          END;
    end;

    trigger OnModify()
    begin
        IF ReceiptHeader.GET("Receipt No.") THEN
          IF ReceiptHeader.Posted THEN

            ERROR('You cannot change any value on a posted receipt');
    end;

    var
        GLAccount: Record 15;
        Cust: Record 18;
        Vendor: Record 23;
        FixedAsset: Record 5600;
        BankAccount: Record 270;
        CustLedger: Record 21;
        CustLedger1: Record 21;
        VendLedger: Record 25;
        VendLedger1: Record 25;
        Amt: Decimal;
        NetAmount: Decimal;
        InsureHeader: Record 51513016;
        ReceiptHeader: Record 51513110;
        DrNote: Record 51513086;
        CrNote: Record 51513088;
        ReceiptPayTypes: Record 51511002;
        ExpectedAmt: Decimal;
        ClaimRec: Record 51513013;
        ClaimantRec: Record 51513094;
}

