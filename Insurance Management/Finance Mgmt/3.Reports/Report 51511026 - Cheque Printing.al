report 51511026 "Cheque Printing"
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Cheque Printing.rdl';

    dataset
    {
        dataitem("Payments"; "Payments1")
        {
            column(DocDate; DocDate)
            {
            }
            column(PV_Lines1__PV_Lines1___Account_Name_; Payments.Payee)
            {
            }
            column(PV_Lines1__PV_Lines1__Amount; Payments."Total Amount")
            {
            }
            column(DescriptionLine_1_; DescriptionLine[1])
            {
            }
            column(DescriptionLine_2_; DescriptionLine[2])
            {
            }
            column(Payments_No; No)
            {
            }
            column(Date_Payments; Payments.Date)
            {
            }
            column(Dots_; Dots)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF NOT CurrReport.PREVIEW THEN BEGIN
                    Payments."No. Printed" := Payments."No. Printed" + 1;
                    Payments.MODIFY;
                END;

                Payments.CALCFIELDS("Total Amount");
                FormatNoText(DescriptionLine, Payments."Total Amount", Payments.Currency);
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
        GLSetup.GET;
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
        InitTextVariable;
    end;

    var
        DimValues: Record "Dimension Value";
        CompName: Text[100];
        TypeOfDoc: Text[100];
        BankName: Text[100];
        Bank: Record "Bank Account";
        PayeeBankName: Text[100];
        VendorPG: Record "Vendor Posting Group";
        CustPG: Record "Customer Posting Group";
        FAPG: Record "FA Posting Group";
        BankPG: Record "Bank Account Posting Group";
        PGAccount: Text[50];
        Vend: Record Vendor;
        Cust: Record Customer;
        FA: Record "FA Depreciation Book";
        BankAccountUsed: Text[50];
        BankAccountUsedName: Text[100];
        PGAccountUsedName: Text[50];
        GLAccount: Record "G/L Account";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        OnesText: array[20] of Text[30];
        NumberText: array[2] of Text[80];
        CurrencyCodeText: Code[10];
        TXT001: Label '%1 %2';
        TXT002: Label '%1, %2  %3';
        Text000: Label 'Preview is not allowed.';
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
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        BalancingType: Option "G/L Account",Customer,Vendor,"Bank Account";
        BalancingNo: Code[20];
        ContactText: Text[30];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[46];
        DocType: Text[30];
        DocNo: Text[30];
        VoidText: Text[30];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        UseCheckNo: Code[20];
        FoundLast: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        PreprintedStub: Boolean;
        TotalText: Text[10];
        DocDate: Date;
        PVNo: Code[10];
        CurrencyCode2: Code[20];
        NetAmount: Text[30];
        CurrencyExchangeRate: Record 330;
        LineAmount2: Decimal;
        GLSetup: Record "General Ledger Setup";
        postion: Integer;
        AmountText: Text[30];
        AmtString: Text[30];
        LenofAmt: Decimal;
        "1000Ms": Text[50];
        "10Ms": Text[50];
        Ms: Text[50];
        "100Ts": Text[50];
        "10Ts": Text[50];
        Ts: Text[50];
        "100Hs": Text[50];
        "10Hs": Text[50];
        Units: Text[50];
        "10S": Text[50];
        show: Integer;
        J: Integer;
        newValueText: Text[30];
        NewValue: Integer;
        CHECKAMOUNTICEA: Decimal;
        PaymentRec: Record Payments1;
        Dots: Label '***';

    procedure FormatNoText(var NoText: array[2] of Text[56]; No: Decimal; CurrencyCode: Code[10])
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
        NoText[1] := '***';

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
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + ' CENTS');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[56]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;
        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    local procedure CustUpdateAmounts(var CustLedgEntry2: Record "Cust. Ledger Entry"; RemainingAmount2: Decimal)
    begin
        /*IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        THEN BEGIN
          GenJnlLine3.RESET;
          GenJnlLine3.SETCURRENTKEY(
            "Account Type","Account No.","Applies-to Doc. Type","Applies-to Doc. No.");
          GenJnlLine3.SETRANGE("Account Type",GenJnlLine3."Account Type"::Customer);
          GenJnlLine3.SETRANGE("Account No.",CustLedgEntry2."Customer No.");
          GenJnlLine3.SETRANGE("Applies-to Doc. Type",CustLedgEntry2."Document Type");
          GenJnlLine3.SETRANGE("Applies-to Doc. No.",CustLedgEntry2."Document No.");
          IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
            GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine."Line No.")
          ELSE
            GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine2."Line No.");
          IF CustLedgEntry2."Document Type" <> CustLedgEntry2."Document Type"::" " THEN
            IF GenJnlLine3.FIND('-') THEN
              GenJnlLine3.FIELDERROR(
                "Applies-to Doc. No.",
                STRSUBSTNO(
                  Text030,
                  CustLedgEntry2."Document Type",CustLedgEntry2."Document No.",
                  CustLedgEntry2."Customer No."));
        END;
        
        DocType := FORMAT(CustLedgEntry2."Document Type");
        DocNo := CustLedgEntry2."Document No.";
        DocDate := CustLedgEntry2."Posting Date";
        CurrencyCode2 := CustLedgEntry2."Currency Code";
        
        CustLedgEntry2.CALCFIELDS("Remaining Amount");
        
        LineAmount := -(CustLedgEntry2."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible"-
          CustLedgEntry2."Accepted Payment Tolerance");
        LineAmount2 :=
          ROUND(
            ExchangeAmt(CustLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,LineAmount),
            Currency."Amount Rounding Precision");
        
        IF ((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::Invoice) AND
           (GenJnlLine."Posting Date" <= CustLedgEntry2."Pmt. Discount Date") AND
           (LineAmount2 <= RemainingAmount2)) OR CustLedgEntry2."Accepted Pmt. Disc. Tolerance"
        THEN BEGIN
          LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
          IF CustLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
            LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        END ELSE BEGIN
          IF RemainingAmount2 >=
             ROUND(
              -(ExchangeAmt(CustLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                CustLedgEntry2."Remaining Amount")),Currency."Amount Rounding Precision")
          THEN
            LineAmount2 :=
              ROUND(
                -(ExchangeAmt(CustLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                  CustLedgEntry2."Remaining Amount")),Currency."Amount Rounding Precision")
          ELSE BEGIN
            LineAmount2 := RemainingAmount2;
            LineAmount :=
              ROUND(
                ExchangeAmt(CustLedgEntry2."Posting Date",CurrencyCode2,GenJnlLine."Currency Code",
                LineAmount2),Currency."Amount Rounding Precision");
          END;
          LineDiscount := 0;
        END; */

    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2: Record "Vendor Ledger Entry"; RemainingAmount2: Decimal)
    begin
        /*IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        THEN BEGIN
          GenJnlLine3.RESET;
          GenJnlLine3.SETCURRENTKEY(
            "Account Type","Account No.","Applies-to Doc. Type","Applies-to Doc. No.");
          GenJnlLine3.SETRANGE("Account Type",GenJnlLine3."Account Type"::Vendor);
          GenJnlLine3.SETRANGE("Account No.",VendLedgEntry2."Vendor No.");
          GenJnlLine3.SETRANGE("Applies-to Doc. Type",VendLedgEntry2."Document Type");
          GenJnlLine3.SETRANGE("Applies-to Doc. No.",VendLedgEntry2."Document No.");
          IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
            GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine."Line No.")
          ELSE
            GenJnlLine3.SETFILTER("Line No.",'<>%1',GenJnlLine2."Line No.");
          IF VendLedgEntry2."Document Type" <> VendLedgEntry2."Document Type"::" " THEN
            IF GenJnlLine3.FIND('-') THEN
              GenJnlLine3.FIELDERROR(
                "Applies-to Doc. No.",
                STRSUBSTNO(
                  Text031,
                  VendLedgEntry2."Document Type",VendLedgEntry2."Document No.",
                  VendLedgEntry2."Vendor No."));
        END;
        
        DocType := FORMAT(VendLedgEntry2."Document Type");
        DocNo := VendLedgEntry2."Document No.";
        DocDate := VendLedgEntry2."Posting Date";
        CurrencyCode2 := VendLedgEntry2."Currency Code";
        VendLedgEntry2.CALCFIELDS("Remaining Amount");
        
        LineAmount := -(VendLedgEntry2."Remaining Amount" - VendLedgEntry2."Remaining Pmt. Disc. Possible" -
          VendLedgEntry2."Accepted Payment Tolerance");
        
        LineAmount2 :=
          ROUND(
            ExchangeAmt(VendLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,LineAmount),
            Currency."Amount Rounding Precision");
        
        IF ((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::Invoice) AND
           (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date") AND
           (LineAmount2 <= RemainingAmount2)) OR VendLedgEntry2."Accepted Pmt. Disc. Tolerance"
        THEN BEGIN
          LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
          IF VendLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
            LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        END ELSE BEGIN
         IF RemainingAmount2 >=
             ROUND(
              -(ExchangeAmt(VendLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                VendLedgEntry2."Remaining Amount")),Currency."Amount Rounding Precision")
          THEN
            LineAmount2 :=
              ROUND(
                -(ExchangeAmt(VendLedgEntry2."Posting Date",GenJnlLine."Currency Code",CurrencyCode2,
                  VendLedgEntry2."Remaining Amount")),Currency."Amount Rounding Precision")
          ELSE BEGIN
            LineAmount2 := RemainingAmount2;
            LineAmount :=
              ROUND(
                ExchangeAmt(VendLedgEntry2."Posting Date",CurrencyCode2,GenJnlLine."Currency Code",
                LineAmount2),Currency."Amount Rounding Precision");
          END;
          LineDiscount := 0;
        END;*/

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

    procedure InitializeRequest(BankAcc: Code[20]; LastCheckNo: Code[20]; NewOneCheckPrVend: Boolean; NewReprintChecks: Boolean; NewTestPrint: Boolean; NewPreprintedStub: Boolean)
    begin
        IF BankAcc <> '' THEN
            /* IF BankAcc2.GET(BankAcc) THEN BEGIN
               ERROR('%1',BankAcc2."Last Check No.");
               UseCheckNo := LastCheckNo;
               OneCheckPrVendor := NewOneCheckPrVend;
               ReprintChecks := NewReprintChecks;
               TestPrint := NewTestPrint;
               PreprintedStub := NewPreprintedStub;
             END;  */
          ;

    end;

    procedure ExchangeAmt(PostingDate: Date; CurrencyCode: Code[10]; CurrencyCode2: Code[10]; Amount: Decimal) Amount2: Decimal
    begin
        /*IF (CurrencyCode <> '')  AND (CurrencyCode2 = '') THEN
           Amount2 :=
             CurrencyExchangeRate.ExchangeAmtLCYToFCY(
               PostingDate,CurrencyCode,Amount,CurrencyExchangeRate.ExchangeRate(PostingDate,CurrencyCode))
        ELSE IF (CurrencyCode = '') AND (CurrencyCode2 <> '') THEN
          Amount2 :=
            CurrencyExchangeRate.ExchangeAmtFCYToLCY(
              PostingDate,CurrencyCode2,Amount,CurrencyExchangeRate.ExchangeRate(PostingDate,CurrencyCode2))
        ELSE IF (CurrencyCode <> '') AND (CurrencyCode2 <> '') AND (CurrencyCode <> CurrencyCode2) THEN
          Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(PostingDate,CurrencyCode2,CurrencyCode,Amount)
        ELSE
          Amount2 := Amount;*/

    end;

    procedure GetNosInWords(var Amount: Decimal)
    begin
        //Less than 10
        J := 1;
        Amount := ROUND(ABS(Amount), 1, '>');
        EVALUATE(AmountText, FORMAT(Amount));
        AmountText := DELCHR(AmountText, '=', ',');
        //1,000,000,000;
        IF Amount <= 1000000000 THEN BEGIN
            show := Amount DIV 100000000;
            IF show > 0 THEN BEGIN
                WHILE J < 10 DO BEGIN
                    newValueText := '';
                    newValueText := COPYSTR(AmountText, J, 1);
                    EVALUATE(NewValue, FORMAT(newValueText));
                    IF J = 1 THEN
                        "1000Ms" := WriteNo(NewValue);
                    IF J = 2 THEN
                        "10Ms" := WriteNo(NewValue);
                    IF J = 3 THEN
                        Ms := WriteNo(NewValue);
                    IF J = 4 THEN
                        "100Ts" := WriteNo(NewValue);
                    IF J = 5 THEN
                        "10Ts" := WriteNo(NewValue);
                    IF J = 6 THEN
                        Ts := WriteNo(NewValue);
                    IF J = 7 THEN
                        "100Hs" := WriteNo(NewValue);
                    IF J = 8 THEN
                        "10S" := WriteNo(NewValue);
                    IF J = 9 THEN
                        Units := WriteNo(NewValue);

                    J := J + 1;
                END;
            END;
        END;

        J := 1;
        // 100,000,000

        IF Amount < 100000000 THEN BEGIN
            show := Amount DIV 10000000;
            IF show > 0 THEN BEGIN
                WHILE J < 9 DO BEGIN
                    newValueText := '';
                    newValueText := COPYSTR(AmountText, J, 1);
                    EVALUATE(NewValue, FORMAT(newValueText));
                    "1000Ms" := 'ZERO';
                    IF J = 1 THEN
                        "10Ms" := WriteNo(NewValue);
                    IF J = 2 THEN
                        Ms := WriteNo(NewValue);
                    IF J = 3 THEN
                        "100Ts" := WriteNo(NewValue);
                    IF J = 4 THEN
                        "10Ts" := WriteNo(NewValue);
                    IF J = 5 THEN
                        Ts := WriteNo(NewValue);
                    IF J = 6 THEN
                        "100Hs" := WriteNo(NewValue);
                    IF J = 7 THEN
                        "10S" := WriteNo(NewValue);
                    IF J = 8 THEN
                        Units := WriteNo(NewValue);

                    J := J + 1;

                END;
            END;
        END;

        J := 1;
        // 10,000,000
        IF Amount < 10000000 THEN BEGIN
            show := Amount DIV 1000000;
            IF show > 0 THEN BEGIN
                WHILE J < 8 DO BEGIN
                    newValueText := COPYSTR(AmountText, J, 1);
                    EVALUATE(NewValue, FORMAT(newValueText));
                    "1000Ms" := 'ZERO';
                    "10Ms" := 'ZERO';
                    IF J = 1 THEN
                        Ms := WriteNo(NewValue);
                    IF J = 2 THEN
                        "100Ts" := WriteNo(NewValue);
                    IF J = 3 THEN
                        "10Ts" := WriteNo(NewValue);
                    IF J = 4 THEN
                        Ts := WriteNo(NewValue);
                    IF J = 5 THEN
                        "100Hs" := WriteNo(NewValue);
                    IF J = 6 THEN
                        "10S" := WriteNo(NewValue);
                    IF J = 7 THEN
                        Units := WriteNo(NewValue);

                    J := J + 1;

                END;
            END;
        END;


        // 1,000,000
        J := 1;
        IF Amount < 1000000 THEN BEGIN
            show := Amount DIV 100000;
            IF show > 0 THEN BEGIN
                WHILE J < 7 DO BEGIN
                    newValueText := COPYSTR(AmountText, J, 1);
                    EVALUATE(NewValue, FORMAT(newValueText));
                    "1000Ms" := 'ZERO';
                    "10Ms" := 'ZERO';
                    Ms := 'ZERO';
                    IF J = 1 THEN
                        "100Ts" := WriteNo(NewValue);
                    IF J = 2 THEN
                        "10Ts" := WriteNo(NewValue);
                    IF J = 3 THEN
                        Ts := WriteNo(NewValue);
                    IF J = 4 THEN
                        "100Hs" := WriteNo(NewValue);
                    IF J = 5 THEN
                        "10S" := WriteNo(NewValue);
                    IF J = 6 THEN
                        Units := WriteNo(NewValue);

                    J := J + 1;
                END;
            END;
        END;


        // 100,000
        J := 1;
        IF Amount < 100000 THEN BEGIN
            show := Amount DIV 10000;
            IF show > 0 THEN BEGIN
                WHILE J < 6 DO BEGIN
                    newValueText := COPYSTR(AmountText, J, 1);
                    EVALUATE(NewValue, FORMAT(newValueText));
                    "1000Ms" := 'ZERO';
                    "10Ms" := 'ZERO';
                    Ms := 'ZERO';
                    "100Ts" := 'ZERO';
                    IF J = 1 THEN
                        "10Ts" := WriteNo(NewValue);
                    IF J = 2 THEN
                        Ts := WriteNo(NewValue);
                    IF J = 3 THEN
                        "100Hs" := WriteNo(NewValue);
                    IF J = 4 THEN
                        "10S" := WriteNo(NewValue);
                    IF J = 5 THEN
                        Units := WriteNo(NewValue);

                    J := J + 1;
                END;
            END;
        END;


        // 10,000
        J := 1;
        IF Amount < 10000 THEN BEGIN
            show := Amount DIV 1000;
            IF show > 0 THEN BEGIN
                WHILE J < 5 DO BEGIN
                    newValueText := COPYSTR(AmountText, J, 1);
                    EVALUATE(NewValue, FORMAT(newValueText));
                    "1000Ms" := 'ZERO';
                    "10Ms" := 'ZERO';
                    Ms := 'ZERO';
                    "100Ts" := 'ZERO';
                    "10Ts" := 'ZERO';

                    IF J = 1 THEN
                        Ts := WriteNo(NewValue);
                    IF J = 2 THEN
                        "100Hs" := WriteNo(NewValue);
                    IF J = 3 THEN
                        "10S" := WriteNo(NewValue);
                    IF J = 4 THEN
                        Units := WriteNo(NewValue);

                    J := J + 1;


                END;
            END;
        END;

        // 1000
        J := 1;
        IF Amount < 1000 THEN BEGIN
            show := Amount DIV 100;
            IF show > 0 THEN BEGIN
                WHILE J < 4 DO BEGIN
                    newValueText := COPYSTR(AmountText, J, 1);
                    EVALUATE(NewValue, FORMAT(newValueText));
                    "1000Ms" := 'ZERO';
                    "10Ms" := 'ZERO';
                    Ms := 'ZERO';
                    "100Ts" := 'ZERO';
                    "10Ts" := 'ZERO';
                    Ts := 'ZERO';

                    IF J = 1 THEN
                        "100Hs" := WriteNo(NewValue);
                    IF J = 2 THEN
                        "10S" := WriteNo(NewValue);
                    IF J = 3 THEN
                        Units := WriteNo(NewValue);

                    J := J + 1;
                END;
            END;
        END;


        // 100
        J := 1;
        IF Amount < 100 THEN BEGIN
            show := Amount DIV 10;
            IF show > 0 THEN BEGIN
                WHILE J < 3 DO BEGIN
                    newValueText := COPYSTR(AmountText, J, 1);
                    EVALUATE(NewValue, FORMAT(newValueText));
                    "1000Ms" := 'ZERO';
                    "10Ms" := 'ZERO';
                    Ms := 'ZERO';
                    "100Ts" := 'ZERO';
                    "10Ts" := 'ZERO';
                    Ts := 'ZERO';
                    "100Hs" := 'ZERO';
                    IF J = 1 THEN
                        "10S" := WriteNo(NewValue);
                    IF J = 2 THEN
                        Units := WriteNo(NewValue);

                    J := J + 1;

                END;
            END;
        END;

        // 10
        J := 1;
        IF Amount < 10 THEN BEGIN
            NewValue := Amount;
            "1000Ms" := 'ZERO';
            "10Ms" := 'ZERO';
            Ms := 'ZERO';
            "100Ts" := 'ZERO';
            "10Ts" := 'ZERO';
            Ts := 'ZERO';
            "100Hs" := 'ZERO';
            "10S" := 'ZERO';
            Units := WriteNo(NewValue);
        END;
    end;

    procedure WriteNo(NotoCheck: Integer) WriteNo: Code[30]
    begin

        IF NotoCheck < 1 THEN
            WriteNo := 'ZERO';
        IF NotoCheck = 1 THEN
            WriteNo := 'ONE';
        IF NotoCheck = 2 THEN
            WriteNo := 'TWO';
        IF NotoCheck = 3 THEN
            WriteNo := 'THREE';
        IF NotoCheck = 4 THEN
            WriteNo := 'FOUR';
        IF NotoCheck = 5 THEN
            WriteNo := 'FIVE';
        IF NotoCheck = 6 THEN
            WriteNo := 'SIX';
        IF NotoCheck = 7 THEN
            WriteNo := 'SEVEN';
        IF NotoCheck = 8 THEN
            WriteNo := 'EIGHT';
        IF NotoCheck = 9 THEN
            WriteNo := 'NINE';
    end;

    procedure GetNo(PaymentsRec: Record Payments1)
    begin
        PVNo := PaymentsRec.No;
        DocDate := PaymentsRec.Date;
    end;
}

