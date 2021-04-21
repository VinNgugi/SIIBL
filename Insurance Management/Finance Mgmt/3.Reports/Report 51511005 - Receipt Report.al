report 51511005 "Receipt Report"
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Receipt Report.rdl';

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = SORTING("Document No.", "Posting Date")
                                WHERE(Amount = FILTER(> 0));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Entry No.", "Document No.", "Posting Date";
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(STRSUBSTNO_TXT002_CompanyInfo_Address_CompanyInfo__Post_Code__CompanyInfo_City_; STRSUBSTNO(TXT002, CompanyInfo.Address, CompanyInfo."Post Code", CompanyInfo.City))
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfoEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page" + ' ' + CompanyInfo."E-Mail")
            {
            }
            column(FORMAT__Posting_Date__; FORMAT("Posting Date"))
            {
            }
            column(Bank_Account_Ledger_Entry__Pay_Mode_; "Pay Mode")
            {
            }
            column(BankAccountLedgerEntryBankAccountNo; "Bank Account Ledger Entry"."Bank Account No.")
            {
            }
            column(Bank_Account_Ledger_Entry__Bank_Account_Ledger_Entry___External_Document_No__; "Bank Account Ledger Entry"."External Document No.")
            {
            }
            column(Bank_Account_Ledger_Entry__Bank_Account_Ledger_Entry__Description; "Bank Account Ledger Entry".Description)
            {
            }
            column(STRSUBSTNO___1___2__CurrencyCodeText_Amount_; Amount)
            {
            }
            column(Bank_Account_Ledger_Entry__Cheque_Date_; "Cheque Date")
            {
            }
            column(ChequeCaption; ChequeCaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry_Remarks; PaymentFor)
            {
            }
            column(NumberText_1_; NumberText[1])
            {
            }
            column(NumberText_2_; NumberText[2])
            {
            }
            column(Bank_Account_Ledger_Entry__Bank_Account_Ledger_Entry___Document_No__; "Bank Account Ledger Entry"."Document No.")
            {
            }
            column(RECEIPTCaption; RECEIPTCaptionLbl)
            {
            }
            column(DATECaption; DATECaptionLbl)
            {
            }
            column(PAY_MODECaption; PAY_MODECaptionLbl)
            {
            }
            column(Cheque_No_Caption; Cheque_No_CaptionLbl)
            {
            }
            column(RECEIVED_FROMCaption; RECEIVED_FROMCaptionLbl)
            {
            }
            column(With_ThanksCaption; With_ThanksCaptionLbl)
            {
            }
            column(AMOUNTCaption; AMOUNTCaptionLbl)
            {
            }
            column(RECEIPT__DETAILSCaption; RECEIPT__DETAILSCaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Cheque_Date_Caption; FIELDCAPTION("Cheque Date"))
            {
            }
            column(Being_payment_forCaption; Being_payment_forCaptionLbl)
            {
            }
            column(the_sum_of_Caption; the_sum_of_CaptionLbl)
            {
            }
            column(CompanyName; CompName)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(RECEIPT_NUMBERCaption; RECEIPT_NUMBERCaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }
            column(AccountCodeLbl; AccountCodeLbl)
            {
            }
            column(AccountCreditText; AccountCreditText)
            {
            }
            column(SignatureLbl; SignatureLbl)
            {
            }
            column(AmountToLbl; AmountToLbl)
            {
            }
            column(TotalAmountLbl; TotalAmountLbl)
            {
            }
            column(ChangeLbl; ChangeLbl)
            {
            }
            /*column(UserRecPicture; UserRec.Picture)
            {
            }*/
            column(CashierName; CashierName)
            {
            }
            column(CashierDesignation; CashierDesignation)
            {
            }
            column(Posted_Time; PostedTime)
            {
            }
            dataitem("Receipt Lines"; "Receipt Lines")
            {
                DataItemLink = "Receipt No." = FIELD("Document No.");
                column(Receipt_Lines1_Account_TypeCaption; "Receipt Lines"."Account Type")
                {
                    IncludeCaption = true;
                }
                column(Receipt_Lines1_Account_NoCaption; "Receipt Lines"."Account No.")
                {
                    IncludeCaption = true;
                }
                column(Receipt_Lines1_Account_NameCaption; "Receipt Lines"."Account Name")
                {
                    IncludeCaption = true;
                }
                column(Receipt_Lines1_DescriptionCaption; "Receipt Lines".Description)
                {
                    IncludeCaption = true;
                }
                column(Receipt_Lines1_AmountCaption; "Receipt Lines".Amount)
                {
                    IncludeCaption = true;
                }
                column(Receipt_Lines1_Net_AmountCaption; "Receipt Lines"."Net Amount")
                {
                    IncludeCaption = true;
                }
                column(Receipt_Lines1_Global_Dimension_1_CodeCaption; "Receipt Lines"."Global Dimension 1 Code")
                {
                    IncludeCaption = true;
                }
                column(Receipt_Lines1_Global_Dimension_2_CodeCaption; "Receipt Lines"."Global Dimension 2 Code")
                {
                    IncludeCaption = true;
                }
                column(Receipt_Lines1_Applies_to_Doc_NoCaption; "Receipt Lines"."Applies to Doc. No")
                {
                    IncludeCaption = true;
                }
                column(Receipt_Lines1_Receipt_NoCaption; "Receipt Lines"."Receipt No.")
                {
                    IncludeCaption = true;
                }
            }

            trigger OnAfterGetRecord()
            begin
                IF "Currency Code" <> '' THEN
                    CurrencyCodeText := "Currency Code"
                ELSE
                    CurrencyCodeText := GLsetup."LCY Code";

                CompanyInfo.GET;
                CompName := CompanyInfo.Name;
                CompanyInfo.CALCFIELDS(Picture);
                Banks.RESET;
                Banks.SETRANGE(Banks."No.", "Bank Account Ledger Entry"."Bank Account No.");
                IF Banks.FIND('-') THEN BEGIN
                    BankName := Banks.Name;
                END
                ELSE BEGIN
                    BankName := '';
                END;

                PaymentFor := '';
                ReceiptLines.RESET;
                ReceiptLines.SETRANGE(ReceiptLines."Receipt No.", "Bank Account Ledger Entry"."Document No.");
                IF ReceiptLines.FIND('-') THEN
                    REPEAT
                        PaymentFor := PaymentFor + ReceiptLines.Description;
                    UNTIL ReceiptLines.NEXT = 0;

                IF ReceiptHeader.GET("Bank Account Ledger Entry"."Document No.") THEN BEGIN
                    IF UserRec.GET(ReceiptHeader.Cashier) THEN BEGIN
                        //UserRec.CALCFIELDS(UserRec.Picture);
                        IF EmpRec.GET(UserRec."Employee No.") THEN BEGIN
                            CashierName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
                            CashierDesignation := EmpRec."Job Title";
                        END;
                    END;
                END;

                IF ReceiptHeader.GET("Bank Account Ledger Entry"."Document No.") THEN
                    PostedTime := ReceiptHeader."Posted Time";

                InitTextVariable;
                FormatNoText(NumberText, Amount, CurrencyCodeText);
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        SalesSetup.GET;
        GLsetup.GET;
        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo.GET;
                    CompanyInfo.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo.GET;
                    CompanyInfo.CALCFIELDS(Picture);
                END;
        END;
    end;

    var
        DimValues: Record "Dimension Value";
        CompName: Text[100];
        TypeOfDoc: Text[100];
        RecPayTypes: Record "Receipts and Payment Types";
        BankName: Text[100];
        Banks: Record "Bank Account";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Text000: Label 'Preview is not allowed.';
        TXT002: Label '%1, %2 %3';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: Label 'Salesperson';
        Text007: Label 'Purchaser';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text009: Label 'Our Contact';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text015: Label 'Payment';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: Label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: Label 'XXX';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        Text063: Label 'Net Amount %1';
        Text064: Label '%1 must not be %2 for %3 %4.';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        GLsetup: Record "General Ledger Setup";
        NumberText: array[2] of Text[80];
        CurrencyCodeText: Code[10];
        RECEIPTCaptionLbl: Label 'RECEIPT';
        DATECaptionLbl: Label 'Date:';
        PAY_MODECaptionLbl: Label 'Pay Mode';
        Cheque_No_CaptionLbl: Label 'Cheque No.';
        RECEIVED_FROMCaptionLbl: Label 'Name:';
        With_ThanksCaptionLbl: Label 'With Thanks';
        AMOUNTCaptionLbl: Label 'Cash Amount';
        RECEIPT__DETAILSCaptionLbl: Label 'Receipt  Details';
        Being_payment_forCaptionLbl: Label 'Being payment of:';
        the_sum_of_CaptionLbl: Label 'Amount in words';
        EmptyStringCaptionLbl: Label '______________';
        RECEIPT_NUMBERCaptionLbl: Label 'Receipt No.';
        ChequeCaptionLbl: Label 'Cheque';
        PaymentDetails: Text[1024];
        AccountCodeLbl: Label 'Account Code:';
        AccountCreditText: Label 'Your account has been credited with the value of this receipt';
        SignatureLbl: Label 'Signature';
        AmountToLbl: Label 'Amount to';
        TotalAmountLbl: Label 'Total Amount';
        ChangeLbl: Label 'Change';
        UserRec: Record "User Setup";
        ReceiptHeader: Record 51511027;
        CashierDesignation: Text[100];
        EmpRec: Record Employee;
        CashierName: Text[150];
        PaymentFor: Text[1024];
        ReceiptLines: Record 51511028;
        PostedTime: Time;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;
}

