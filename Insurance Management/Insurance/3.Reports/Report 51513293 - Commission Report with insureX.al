report 51513293 "Commission Report with insureX"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Commission Report with insureX.rdl';

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
        {
            RequestFilterFields = "Document Type", "Document No.";
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
            column(Date; "Detailed Cust. Ledg. Entry"."Posting Date")
            {
            }
            column(DocumentNo; "Detailed Cust. Ledg. Entry"."Document No.")
            {
            }
            column(Insured; Insured)
            {
            }
            column(Class; Class)
            {
            }
            column(Periodstart; Periodstart)
            {
            }
            column(PeriodEnd; PeriodEnd)
            {
            }
            column(PolicyNumber; PolicyNumber)
            {
            }
            column(BasicPremium; GrossPremium)
            {
            }
            column(CommissionRate; CommissionRate)
            {
            }
            column(TotalGrossPremium; TotalGrossPremium)
            {
            }
            column(TotalWtx; TotalWtx)
            {
            }
            column(TotalNetPremium; TotalNetPremium)
            {
            }
            column(Insurer; Insurer)
            {
            }
            column(DocumentType; "Detailed Cust. Ledg. Entry"."Document Type")
            {
            }
            column(TotalCommission; TotalCommission)
            {
            }

            trigger OnAfterGetRecord();
            begin

                //IF"Detailed Cust. Ledg. Entry"."Document Type"="Detailed Cust. Ledg. Entry"."Document Type"::" " THEN
                //CurrReport.SKIP;

                //message( 'test %1',DebitNote."Total Premium Amount");
                //message( 'test %1',CreditNote."Total Premium Amount");

                DebitNote.SETRANGE(DebitNote."No.", "Detailed Cust. Ledg. Entry"."Document No.");
                DebitNote.SETRANGE(DebitNote."Document Type", DebitNote."Document Type"::"Debit Note");
                IF DebitNote.FIND('-') THEN BEGIN

                    IF PolicyType.GET(DebitNote."Policy Type") THEN
                        Class := PolicyType.Description;
                    PolicyNumber := DebitNote."Policy No";
                    DebitNote.CALCFIELDS(DebitNote."Total Premium Amount");
                    GrossPremium := DebitNote."Total Premium Amount";
                    CommissionRate := DebitNote."Commission Due";
                    Insured := DebitNote."Insured Name";
                    Insurer := DebitNote."Underwriter Name";
                    Periodstart := DebitNote."Cover Start Date";
                    PeriodEnd := DebitNote."Cover End Date";



                    CreditNote.SETRANGE(CreditNote."No.", "Detailed Cust. Ledg. Entry"."Document No.");
                    CreditNote.SETRANGE(CreditNote."Document Type", CreditNote."Document Type"::"Credit Note");
                    IF CreditNote.FIND('-') THEN BEGIN

                        IF PolicyType.GET(CreditNote."Policy Type") THEN
                            Class := PolicyType.Description;
                        PolicyNumber := CreditNote."Policy No";
                        Insured := CreditNote."Insured Name";
                        CreditNote.CALCFIELDS(CreditNote."Total Premium Amount");
                        GrossPremium := -CreditNote."Total Premium Amount";
                        CommissionRate := CreditNote."Commission Due";
                        Insured := CreditNote."Insured Name";
                        Insurer := CreditNote."Underwriter Name";
                        Periodstart := CreditNote."Cover Start Date";
                        PeriodEnd := CreditNote."Cover End Date";

                    END;
                END;




                TotalGrossPremium := TotalGrossPremium + GrossPremium;
                TotalCommission := TotalCommission + ROUND((GrossPremium * (CommissionRate / 100)), 1);
                TotalWtx := TotalWtx + ROUND((GrossPremium * ((CommissionRate / 100)) * 0.05), 1);
                TotalNetPremium := TotalNetPremium + ROUND((GrossPremium * CommissionRate / 100) * 0.95, 1);
                //MESSAGE('TotalGrossPremium =%1 GrossPremium=%2 DR no =%3',TotalGrossPremium,GrossPremium,DtldCustLedgEntries."Document No.");
            end;

            trigger OnPreDataItem();
            begin
                //"Detailed Cust. Ledg. Entry".SETFILTER("Detailed Cust. Ledg. Entry"."Document Type",'<>%1',"Detailed Cust. Ledg. Entry"."Document Type"::" ");
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
        Insured: Text[250];
        Taxes: Record 5630;
        TaxesArray: array[10] of Code[10];
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record 79;
        Cust2: Record Customer;
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        Language: Record 8;
        "Cust. Ledger Entry": Record "Cust. Ledger Entry";
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
        TaxesArraydesc: array[10] of Text[250];
        TaxesArrayVal: array[10] of Decimal;
        GrossCommission: Decimal;
        CommissionRate: Decimal;
        TotalGrossPremium: Decimal;
        TotalWtx: Decimal;
        TotalNetPremium: Decimal;
        CreditNote: Record "Insure Header";
        SalesCrLine: Record "Insure Lines";
        TotalCommission: Decimal;
        Periodstart: Date;
        PeriodEnd: Date;
        Insurer: Text[130];
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
            CustLedgEntry.GET(DtldCustLedgEntries."Cust. Ledger Entry No.");
            IF CustLedgEntry.Reversed THEN
                EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;
}

