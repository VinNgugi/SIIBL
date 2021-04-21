report 51513290 "Commission Report"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Commission Report.rdl';

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
        {
            DataItemTableView = SORTING("Document No.", "Document Type", "Posting Date")
                                WHERE("Document Type" = FILTER(<> Payment),
                                      Amount = FILTER(<> 0));
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
            column(PolicyNumber; PolicyNumber)
            {
            }
            column(GrossPremium; GrossPremium)
            {
            }
            column(GrossCommission; GrossCommission)
            {
            }
            column(TotalGrossPremium; TotalGrossPremium)
            {
            }
            column(TotalNetPremium; TotalNetPremium)
            {
            }
            column(TotalCommission; TotalCommission)
            {
            }
            column(TotalWtx; TotalWtx)
            {
            }
            column(CommissionRate; CommissionRate)
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(DocumentNo_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Document No.")
            {
            }
            column(InsuranceTransType_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Insurance Trans Type")
            {
            }
            column(CreditAmount_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Credit Amount")
            {
            }
            column(DocType; DocType)
            {
            }
            column(Commissiondue; Commissiondue)
            {
            }
            column(AgentCode; AgentCode)
            {
            }
            column(AgentName; AgentName)
            {
            }
            column(BrokerName; BrokerName)
            {
            }
            column(NetPremium; NetPremium)
            {
            }

            trigger OnAfterGetRecord();
            begin
                /*
                "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Insurance Trans Type", "Detailed Cust. Ledg. Entry"."Insurance Trans Type"::Commission);
                "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Document No.");
                "Detailed Cust. Ledg. Entry".FINDLAST;
                TotalCommission:="Detailed Cust. Ledg. Entry".Amount;
                */


                "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Document No.", "Detailed Cust. Ledg. Entry"."Document No.");
                "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Posting Date", "Detailed Cust. Ledg. Entry"."Posting Date");
                "Detailed Cust. Ledg. Entry".FINDLAST;
                Commissiondue := 0;
                TotalWtx := 0;
                TotalCommission := 0;
                BrokerName := '';
                AgentName := '';
                NetPremium := 0;


                CreditNote.SETRANGE(CreditNote."No.", "Detailed Cust. Ledg. Entry"."Document No.");
                CreditNote.SETRANGE(CreditNote."Document Type", CreditNote."Document Type"::"Credit Note");
                IF CreditNote.FIND('-') THEN BEGIN
                    IF PolicyType.GET(CreditNote."Policy Type") THEN
                        Class := PolicyType.Description;
                    PolicyNumber := CreditNote."Policy No";
                    CreditNote.CALCFIELDS(CreditNote."Total Premium Amount");
                    GrossPremium := -CreditNote."Total Premium Amount";
                    CommissionRate := CreditNote."Commission Due";
                    Insured := CreditNote."Insured Name";
                    StartDate := CreditNote."Posting Date";
                    DocType := 'CRN';
                    AgentCode := CreditNote."Agent/Broker";
                    IF Cust2.GET(AgentCode) THEN BEGIN
                        CustPostingGroup := Cust2."Customer Posting Group";
                        IF CustPostingGroup = 'BROKERS' THEN
                            BrokerName := Cust2.Name;
                        IF CustPostingGroup = 'AGENTS' THEN
                            AgentName := Cust2.Name;
                    END;
                END;


                DebitNote.SETRANGE(DebitNote."No.", "Detailed Cust. Ledg. Entry"."Document No.");
                IF DebitNote.FIND('-') THEN BEGIN
                    IF PolicyType.GET(DebitNote."Policy Type") THEN
                        Class := PolicyType.Description;
                    PolicyNumber := DebitNote."Policy No";
                    DebitNote.CALCFIELDS(DebitNote."Total Premium Amount");
                    GrossPremium := DebitNote."Total Premium Amount";
                    CommissionRate := DebitNote."Commission Due";
                    Insured := DebitNote."Insured Name";
                    StartDate := DebitNote."Posting Date";
                    AgentCode := DebitNote."Agent/Broker";
                    IF Cust2.GET(AgentCode) THEN BEGIN
                        CustPostingGroup := Cust2."Customer Posting Group";
                        IF CustPostingGroup = 'BROKERS' THEN
                            BrokerName := Cust2.Name;
                        IF CustPostingGroup = 'AGENTS' THEN
                            AgentName := Cust2.Name;
                    END;
                    DocType := 'DRN';
                END;

                DetailedCustLedger.RESET;
                DetailedCustLedger.SETRANGE(DetailedCustLedger."Document No.", "Detailed Cust. Ledg. Entry"."Document No.");
                DetailedCustLedger.SETRANGE(DetailedCustLedger."Posting Date", "Detailed Cust. Ledg. Entry"."Posting Date");
                DetailedCustLedger.SETRANGE(DetailedCustLedger."Insurance Trans Type", DetailedCustLedger."Insurance Trans Type"::Commission);
                IF DetailedCustLedger.FINDFIRST THEN
                    TotalCommission := DetailedCustLedger.Amount;

                DetailedCustLedger.RESET;
                DetailedCustLedger.SETRANGE(DetailedCustLedger."Document No.", "Detailed Cust. Ledg. Entry"."Document No.");
                DetailedCustLedger.SETRANGE(DetailedCustLedger."Posting Date", "Detailed Cust. Ledg. Entry"."Posting Date");
                DetailedCustLedger.SETRANGE(DetailedCustLedger."Insurance Trans Type", DetailedCustLedger."Insurance Trans Type"::"Net Premium");
                IF DetailedCustLedger.FINDFIRST THEN
                    //DetailedCustLedger.CALCFIELDS(DetailedCustLedger.Amount);
                    NetPremium := DetailedCustLedger.Amount;


                DetailedCustLedger.RESET;
                DetailedCustLedger.SETRANGE(DetailedCustLedger."Document No.", "Detailed Cust. Ledg. Entry"."Document No.");
                DetailedCustLedger.SETRANGE(DetailedCustLedger."Posting Date", "Detailed Cust. Ledg. Entry"."Posting Date");
                DetailedCustLedger.SETRANGE(DetailedCustLedger."Insurance Trans Type", DetailedCustLedger."Insurance Trans Type"::Wht);
                IF DetailedCustLedger.FINDFIRST THEN
                    TotalWtx := DetailedCustLedger.Amount;
                /*
                IF "Detailed Cust. Ledg. Entry"."Insurance Trans Type"= "Detailed Cust. Ledg. Entry"."Insurance Trans Type"::Commission THEN
                TotalCommission:="Detailed Cust. Ledg. Entry".Amount ;
                
                IF "Detailed Cust. Ledg. Entry"."Insurance Trans Type"="Detailed Cust. Ledg. Entry"."Insurance Trans Type"::Wht THEN
                TotalWtx:="Detailed Cust. Ledg. Entry".Amount;*/

                Commissiondue := TotalCommission + TotalWtx;


                /*
                "Detailed Cust. Ledg. Entry".RESET;
                "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Insurance Trans Type", "Detailed Cust. Ledg. Entry"."Insurance Trans Type"::Commission);
                TotalCommission:="Detailed Cust. Ledg. Entry".Amount;
                */
                /*
                
                TotalGrossPremium:=TotalGrossPremium+GrossPremium;
                TotalCommission:=TotalCommission+ROUND((GrossPremium*(CommissionRate/100)),1);
                TotalWtx:=TotalWtx+ROUND((GrossPremium*((CommissionRate/100))*0.05),1);
                TotalNetPremium:=TotalNetPremium+ROUND((GrossPremium*CommissionRate/100),1);
                //MESSAGE('TotalGrossPremium =%1 GrossPremium=%2 DR no =%3',TotalGrossPremium,GrossPremium,DtldCustLedgEntries."Document No.");
                */
                "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Document No.");
                "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Posting Date");

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
        DebitNote: Record "Insure Debit Note";
        PolicyType: Record "Policy Type";
        Class: Text[250];
        PolicyNumber: Code[30];
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
        CreditNote: Record "Insure Credit Note";
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
        DocType: Text;
        Commissiondue: Decimal;
        AgentCode: Code[30];
        AgentName: Text;
        OptionValue: Option;
        DetailedCustLedger: Record 379;
        CustPostingGroup: Code[30];
        BrokerName: Text;
        NetPremium: Decimal;
}

