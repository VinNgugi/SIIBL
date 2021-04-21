report 51513291 "Commision Per Client SummaryX"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Commision Per Client SummaryX.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Date Filter";
            column(Picture; CompInfor.Picture)
            {
            }
            column(CName; CompInfor.Name)
            {
            }
            column(CAddress; CompInfor.Address)
            {
            }
            column(CAdd2; CompInfor."Address 2")
            {
            }
            column(CCity; CompInfor.City)
            {
            }
            column(CPhoneNo; CompInfor."Phone No.")
            {
            }
            column(CEmail; CompInfor."E-Mail")
            {
            }
            column(CWeb; CompInfor."Home Page")
            {
            }
            column(CFaxno; CompInfor."Fax No.")
            {
            }
            column(TotalNetPremium; TotalNetPremium)
            {
            }
            column(No_Customer; Customer."No.")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                column(Amount_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry".Amount)
                {
                }

                trigger OnAfterGetRecord();
                begin

                    IF SkipReversedUnapplied("Detailed Cust. Ledg. Entry") THEN
                        CurrReport.SKIP;
                    "Remaining Amount" := 0;
                    PrintLine := TRUE;
                    CASE "Entry Type" OF
                        "Entry Type"::"Initial Entry":
                            BEGIN
                                "Cust. Ledger Entry".GET("Cust. Ledger Entry No.");
                                Description := "Cust. Ledger Entry".Description;
                                "Due Date" := "Cust. Ledger Entry"."Due Date";
                                "Cust. Ledger Entry".SETRANGE("Date Filter", 0D, EndDate);
                                "Cust. Ledger Entry".CALCFIELDS("Remaining Amount");
                                "Remaining Amount" := "Cust. Ledger Entry"."Remaining Amount";
                                "Cust. Ledger Entry".SETRANGE("Date Filter");
                            END;
                        "Entry Type"::Application:
                            BEGIN
                                DtldCustLedgEntries2.SETCURRENTKEY("Customer No.", "Posting Date", "Entry Type");
                                DtldCustLedgEntries2.SETRANGE("Customer No.", "Customer No.");
                                DtldCustLedgEntries2.SETRANGE("Posting Date", "Posting Date");
                                DtldCustLedgEntries2.SETRANGE("Entry Type", "Entry Type"::Application);
                                DtldCustLedgEntries2.SETRANGE("Transaction No.", "Transaction No.");
                                DtldCustLedgEntries2.SETFILTER("Currency Code", '<>%1', "Detailed Cust. Ledg. Entry"."Currency Code");
                                IF DtldCustLedgEntries2.FIND('-') THEN BEGIN
                                    Description := Text005;
                                    "Due Date" := 0D;
                                END ELSE
                                    PrintLine := FALSE;
                            END;
                        "Entry Type"::"Payment Discount",
                        "Entry Type"::"Payment Discount (VAT Excl.)",
                        "Entry Type"::"Payment Discount (VAT Adjustment)",
                        "Entry Type"::"Payment Discount Tolerance",
                        "Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                        "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                            BEGIN
                                Description := Text006;
                                "Due Date" := 0D;
                            END;
                        "Entry Type"::"Payment Tolerance",
                        "Entry Type"::"Payment Tolerance (VAT Excl.)",
                        "Entry Type"::"Payment Tolerance (VAT Adjustment)":
                            BEGIN
                                Description := Text014;
                                "Due Date" := 0D;
                            END;
                        "Entry Type"::"Appln. Rounding",
                        "Entry Type"::"Correction of Remaining Amount":
                            BEGIN
                                Description := Text007;
                                "Due Date" := 0D;
                            END;
                    END;

                    IF PrintLine THEN
                        CustBalance := CustBalance + Amount;

                    Class := '';
                    PolicyNumber := '';
                    GrossPremium := 0;
                    CommissionRate := 0;

                    FOR i := 1 TO 10 DO BEGIN
                        CLEAR(TaxesArrayVal[i]);
                    END;
                    IF DebitNote.GET("Detailed Cust. Ledg. Entry"."Document No.") THEN BEGIN
                        IF PolicyType.GET(DebitNote."Policy Type") THEN
                            Class := PolicyType.Description;
                        PolicyNumber := DebitNote."Policy No";
                        DebitNote.CALCFIELDS(DebitNote."Total Premium Amount");
                        GrossPremium := DebitNote."Total Premium Amount";
                        CommissionRate := DebitNote."Commission Due";




                        IF CreditNote.GET("Detailed Cust. Ledg. Entry"."Document No.") THEN BEGIN
                            IF PolicyType.GET(CreditNote."Policy Type") THEN
                                Class := PolicyType.Description;
                            PolicyNumber := CreditNote."Policy No";
                            CreditNote.CALCFIELDS(CreditNote."Total Premium Amount");
                            GrossPremium := -CreditNote."Total Premium Amount";
                            CommissionRate := CreditNote."Commission Due";

                        END;
                    END;




                    TotalGrossPremium := TotalGrossPremium + GrossPremium;
                    TotalCommission := TotalCommission + ROUND((GrossPremium * (CommissionRate / 100)), 1);
                    TotalWtx := TotalWtx + ROUND((GrossPremium * ((CommissionRate / 100)) * 0.05), 1);
                    TotalNetPremium := TotalNetPremium + ROUND((GrossPremium * CommissionRate / 100) * 0.95, 1);
                end;

                trigger OnPreDataItem();
                begin

                    SETRANGE("Customer No.", Customer."No.");
                    SETRANGE("Posting Date", StartDate, EndDate);
                    //SETRANGE("Currency Code",Currency2.Code);

                    IF Currency2.Code = '' THEN BEGIN
                        GLSetup.TESTFIELD("LCY Code");
                        CurrencyCode3 := GLSetup."LCY Code"
                    END ELSE
                        CurrencyCode3 := Currency2.Code;
                end;
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                column(Amount_CustLedgerEntry; "Cust. Ledger Entry".Amount)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    /*
                    IF IncludeAgingBand THEN
                      IF ("Posting Date" > EndDate) AND ("Due Date" >= EndDate) THEN
                        CurrReport.SKIP;
                    "Cust. Ledger Entry" := CustLedgerEntry;
                    "Cust. Ledger Entry".SETRANGE("Date Filter",0D,EndDate);
                    "Cust. Ledger Entry".CALCFIELDS("Remaining Amount");
                    "Remaining Amount" := "Cust. Ledger Entry"."Remaining Amount";
                    IF CustLedgerEntry."Remaining Amount" = 0 THEN
                      CurrReport.SKIP;
                    
                    IF IncludeAgingBand AND ("Posting Date" <= EndDate) THEN
                      UpdateBuffer(Currency2.Code,GetDate("Posting Date","Due Date"),"Remaining Amount");
                    IF ("Due Date" >= EndDate) OR  ("Remaining Amount" < 0) THEN
                      CurrReport.SKIP;
                     */

                end;

                trigger OnPreDataItem();
                begin
                    /*
                   CurrReport.CREATETOTALS("Remaining Amount");
                   IF NOT IncludeAgingBand THEN BEGIN
                     SETRANGE("Due Date",0D,EndDate - 1);
                     SETRANGE(Positive,TRUE);
                   END;
                   SETRANGE("Currency Code",Currency2.Code);
                   IF (NOT PrintEntriesDue) AND (NOT IncludeAgingBand) THEN
                     CurrReport.BREAK;
                       */

                end;
            }

            trigger OnAfterGetRecord();
            begin

                TotalNetPremium := 0;
                TotalGrossPremium := 0;
                TotalWtx := 0;


                AgingBandBuf.DELETEALL;
                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                PrintLine := FALSE;
                Cust2 := Customer;
                COPYFILTER("Currency Filter", Currency2.Code);
                IF PrintAllHavingBal THEN BEGIN
                    IF Currency2.FIND('-') THEN
                        REPEAT
                            Cust2.SETRANGE("Date Filter", 0D, EndDate);
                            Cust2.SETRANGE("Currency Filter", Currency2.Code);
                            Cust2.CALCFIELDS("Net Change");
                            PrintLine := Cust2."Net Change" <> 0;
                        UNTIL (Currency2.NEXT = 0) OR PrintLine;
                END;
                IF (NOT PrintLine) AND PrintAllHavingEntry THEN BEGIN
                    "Cust. Ledger Entry".RESET;
                    "Cust. Ledger Entry".SETCURRENTKEY("Customer No.", "Posting Date");
                    "Cust. Ledger Entry".SETRANGE("Customer No.", Customer."No.");
                    "Cust. Ledger Entry".SETRANGE("Posting Date", StartDate, EndDate);
                    Customer.COPYFILTER("Currency Filter", "Cust. Ledger Entry"."Currency Code");
                    PrintLine := "Cust. Ledger Entry".FIND('-');
                END;
                IF NOT PrintLine THEN
                    CurrReport.SKIP;

                FormatAddr.Customer(CustAddr, Customer);
                CurrReport.PAGENO := 1;

                IF NOT CurrReport.PREVIEW THEN BEGIN
                    Customer.LOCKTABLE;
                    Customer.FIND;
                    Customer."Last Statement No." := Customer."Last Statement No." + 1;
                    Customer.MODIFY;
                    COMMIT;
                END ELSE
                    Customer."Last Statement No." := Customer."Last Statement No." + 1;

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN
                        SegManagement.LogDocument(
                          7, FORMAT(Customer."Last Statement No."), 0, 0, DATABASE::Customer, "No.", "Salesperson Code", '',
                          Text003 + FORMAT(Customer."Last Statement No."), '');
            end;

            trigger OnPreDataItem();
            begin

                StartDate := GETRANGEMIN("Date Filter");
                EndDate := GETRANGEMAX("Date Filter");
                AgingBandEndingDate := EndDate;
                CalcAgingBandDates;

                CompanyInfo.GET;
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                Currency2.Code := '';
                Currency2.INSERT;
                COPYFILTER("Currency Filter", Currency.Code);
                IF Currency.FIND('-') THEN
                    REPEAT
                        Currency2 := Currency;
                        Currency2.INSERT;
                    UNTIL Currency.NEXT = 0;
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

    trigger OnPreReport();
    begin
        CompInfor.GET;
        CompInfor.CALCFIELDS(Picture);
    end;

    var
        CompInfor: Record 79;
        GrandCommission: Decimal;
        Taxes: Record 5630;
        TaxesArray: array[10] of Code[10];
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record 79;
        Cust2: Record Customer;
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        Language: Record 8;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntries2: Record 379;
        AgingBandBuf: Record 47 temporary;
        PrintAllHavingEntry: Boolean;
        PrintAllHavingBal: Boolean;
        PrintEntriesDue: Boolean;
        PrintUnappliedEntries: Boolean;
        PrintReversedEntries: Boolean;
        PrintLine: Boolean;
        LogInteraction: Boolean;
        EntriesExists: Boolean;
        StartDate: Date;
        EndDate: Date;
        "Due Date": Date;
        CustAddr: array[8] of Text[250];
        CompanyAddr: array[8] of Text[250];
        Description: Text[250];
        StartBalance: Decimal;
        CustBalance: Decimal;
        "Remaining Amount": Decimal;
        FormatAddr: Codeunit 365;
        SegManagement: Codeunit 5051;
        CurrencyCode3: Code[10];
        PeriodLength: DateFormula;
        PeriodLength2: DateFormula;
        DateChoice: Option "Due Date","Posting Date";
        AgingDate: array[5] of Date;
        AgingBandEndingDate: Date;
        IncludeAgingBand: Boolean;
        AgingBandCurrencyCode: Code[10];
        DebitNote: Record "Insure Header";
        PolicyType: Record "Policy Type";
        Class: Text[250];
        PolicyNumber: Code[20];
        GrossPremium: Decimal;
        i: Integer;
        SalesLine: Record "Insure Lines";
        TaxesArraydesc: array[10] of Text[30];
        TaxesArrayVal: array[10] of Decimal;
        GrossCommission: Decimal;
        CommissionRate: Decimal;
        TotalGrossPremium: Decimal;
        TotalWtx: Decimal;
        TotalNetPremium: Decimal;
        CreditNote: Record "Insure Header";
        SalesCrLine: Record "Insure Lines";
        TotalCommission: Decimal;
        Text000: Label 'Page %1';
        Text001: Label 'Entries %1';
        Text002: Label 'Overdue Entries %1';
        Text003: Label '"Statement "';
        Text005: Label 'Multicurrency Application';
        Text006: Label 'Payment Discount';
        Text007: Label 'Rounding';
        Text008: Label 'You must specify the Aging Band Period Length.';
        Text010: Label 'You must specify Aging Band Ending Date.';
        Text011: Label 'Aged Summary by %1 (%2 by %3)';
        Text012: Label 'Period Length is out of range.';
        Text013: Label 'Due Date,Posting Date';
        Text014: Label 'Application Writeoffs';

    local procedure GetDate(PostingDate: Date; DueDate: Date): Date;
    begin
        IF DateChoice = DateChoice::"Posting Date" THEN
            EXIT(PostingDate)
        ELSE
            EXIT(DueDate);
    end;

    local procedure CalcAgingBandDates();
    begin
        IF NOT IncludeAgingBand THEN
            EXIT;
        IF AgingBandEndingDate = 0D THEN
            ERROR(Text010);
        IF FORMAT(PeriodLength) = '' THEN
            ERROR(Text008);
        EVALUATE(PeriodLength2, '-' + FORMAT(PeriodLength));
        AgingDate[5] := AgingBandEndingDate;
        AgingDate[4] := CALCDATE(PeriodLength2, AgingDate[5]);
        AgingDate[3] := CALCDATE(PeriodLength2, AgingDate[4]);
        AgingDate[2] := CALCDATE(PeriodLength2, AgingDate[3]);
        AgingDate[1] := CALCDATE(PeriodLength2, AgingDate[2]);
        IF AgingDate[2] <= AgingDate[1] THEN
            ERROR(Text012);
    end;

    local procedure UpdateBuffer(CurrencyCode: Code[10]; Date: Date; Amount: Decimal);
    var
        I: Integer;
        GoOn: Boolean;
    begin
        AgingBandBuf.INIT;
        AgingBandBuf."Currency Code" := CurrencyCode;
        IF NOT AgingBandBuf.FIND THEN
            AgingBandBuf.INSERT;
        I := 1;
        GoOn := TRUE;
        WHILE (I <= 5) AND GoOn DO BEGIN
            IF Date <= AgingDate[I] THEN
                IF I = 1 THEN BEGIN
                    AgingBandBuf."Column 1 Amt." := AgingBandBuf."Column 1 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 2 THEN BEGIN
                    AgingBandBuf."Column 2 Amt." := AgingBandBuf."Column 2 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 3 THEN BEGIN
                    AgingBandBuf."Column 3 Amt." := AgingBandBuf."Column 3 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 4 THEN BEGIN
                    AgingBandBuf."Column 4 Amt." := AgingBandBuf."Column 4 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 5 THEN BEGIN
                    AgingBandBuf."Column 5 Amt." := AgingBandBuf."Column 5 Amt." + Amount;
                    GoOn := FALSE;
                END;
            I := I + 1;
        END;
        AgingBandBuf.MODIFY;
    end;

    procedure SkipReversedUnapplied(var DtldCustLedgEntries: Record 379): Boolean;
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        IF PrintReversedEntries AND PrintUnappliedEntries THEN
            EXIT(FALSE);
        IF NOT PrintUnappliedEntries THEN
            IF "Detailed Cust. Ledg. Entry".Unapplied THEN
                EXIT(TRUE);
        IF NOT PrintReversedEntries THEN BEGIN
            "Cust. Ledger Entry".GET("Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.");
            IF "Cust. Ledger Entry".Reversed THEN
                EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;
}

