report 51513289 "Premium Closing Report"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Premium Closing Report.rdl';

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
        {
            RequestFilterFields = "Posting Date";
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
            column(Insured; Insured)
            {
            }
            column(Class; Class)
            {
            }
            column(Insurer; Insurer)
            {
            }
            column(Orderhereon; Orderhereon)
            {
            }
            column(TotalGrossPremium; TotalGrossPremium)
            {
            }
            column(GrossPremium; GrossPremium)
            {
            }
            column(TotalNetPremium; TotalNetPremium)
            {
            }
            column(NetDueToInsurer; NetDueToInsurer)
            {
            }
            column(Netcommision; Netcommision)
            {
            }

            trigger OnAfterGetRecord();
            begin


                DebitNote.SETRANGE(DebitNote."No.", "Detailed Cust. Ledg. Entry"."Document No.");
                DebitNote.SETRANGE(DebitNote."Document Type", DebitNote."Document Type"::"Debit Note");
                IF DebitNote.FIND('-') THEN BEGIN

                    IF PolicyType.GET(DebitNote."Policy Type") THEN
                        Class := PolicyType.Description;
                    PolicyNumber := DebitNote."Policy No";
                    DebitNote.CALCFIELDS(DebitNote."Total Premium Amount");
                    GrossPremium := DebitNote."Total Premium Amount";
                    CommissionRate := DebitNote."Commission Due";
                    GrossCommission := (DebitNote."Commission Due" / 100) * GrossPremium;
                    Insured := DebitNote."Insured Name";
                    Insurer := DebitNote."Underwriter Name";
                    Orderhereon := DebitNote."Order Hereon";
                    IF Orderhereon = 0 THEN
                        Orderhereon := 100;
                    GrossCommission := (DebitNote."Commission Due" / 100) * GrossPremium;
                    //wTX:=0.05*GrossCommission;
                    Netcommision := GrossCommission;
                    NetDueToInsurer := GrossPremium - Netcommision;


                    CreditNote.SETRANGE(CreditNote."No.", "Detailed Cust. Ledg. Entry"."Document No.");
                    CreditNote.SETRANGE(CreditNote."Document Type", CreditNote."Document Type"::"Credit Note");
                    IF CreditNote.FIND('-') THEN BEGIN


                        IF PolicyType.GET(CreditNote."Policy Type") THEN
                            Class := PolicyType.Description;
                        PolicyNumber := CreditNote."Policy No";
                        //Insured:=CreditNote."Sell-to Customer Name";
                        CreditNote.CALCFIELDS(CreditNote."Total Premium Amount");
                        GrossPremium := -CreditNote."Total Premium Amount";
                        CommissionRate := CreditNote."Commission Due";
                        Insured := CreditNote."Insured Name";
                        Insurer := CreditNote."Underwriter Name";

                        Orderhereon := CreditNote."Order Hereon";
                        IF Orderhereon = 0 THEN
                            Orderhereon := 100;

                    END;
                END;
                GrossCommission := (CreditNote."Commission Due" / 100) * GrossPremium;
                //wTX:=0.05*GrossCommission;
                Netcommision := GrossCommission;
                NetDueToInsurer := GrossPremium - Netcommision;


                GrossPremium := (Orderhereon / 100) * GrossPremium;
            end;

            trigger OnPreDataItem();
            begin

                //SNN
                //CurrReport.CREATETOTALS(GrossPremium, wTX, TaxesArrayVal, GrossCommission, Netcommision, NetDueToInsurer);
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
        iNSURERrEC: Record Vendor;
        Insurer: Text[250];
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
        Orderhereon: Decimal;
        wTX: Decimal;
        Netcommision: Decimal;
        NetDueToInsurer: Decimal;
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
}

