report 51513333 "GH Commission Statement"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/GH Commission Statement.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
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
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                CalcFields = Amount, "Remaining Amount";
                DataItemLink = "Vendor No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter");

                trigger OnAfterGetRecord();
                begin

                    Clientnames := '';
                    WitholdingTax := 0;
                    RemainingAmt := 0;
                    CommissionAmt := 0;


                    IF DebitNote.GET("Vendor Ledger Entry"."Document No.") THEN BEGIN
                        Class := DebitNote."Policy Type";
                        Clientnames := DebitNote."Insured Name";
                        IF policyType.GET(DebitNote."Policy Type") THEN
                            //Class:=policyType."Policy Type";
                            PolicyNumber := DebitNote."Policy No";
                        //DebitNote.CALCFIELDS(DebitNote."Total Premium Amount");



                    END;

                    IF Cust.GET("Vendor Ledger Entry"."Vendor No.") THEN BEGIN
                        Clientnames := Cust.Name;

                        IF Clientnames = '' THEN
                            Clientnames := FORMAT(Cust.Title) + ' ' + Cust."First name" + ' ' + Cust."Family Name";
                    END;


                    Class := DebitNote."Policy Type";


                    "Vendor Ledger Entry".CALCFIELDS("Vendor Ledger Entry"."Remaining Amount", "Vendor Ledger Entry".Amount);
                    //IF "Vendor Ledger Entry"."Commission Percentage"<>0 THEN
                    //CommissionAmt:="Vendor Ledger Entry".Amount;
                    //RemainingAmt:="Vendor Ledger Entry"."Remaining Amount";
                    //RemainingAmt:="Vendor Ledger Entry".Amount-"Vendor Ledger Entry"."Withholding Tax";
                    //WitholdingTax:="Vendor Ledger Entry"."Withholding Tax";

                    TotalCommission := TotalCommission + CommissionAmt;
                    TotalRemaining := TotalRemaining + RemainingAmt;

                    //TotalPremium:=TotalPremium+ROUND("Vendor Ledger Entry".Premium);

                    TotalWtx := TotalWtx + WitholdingTax;
                    TotalNet := TotalNet + NetCommission;

                    IF ReportInCurrency = '' THEN
                        ReportInCurrency := 'USD';


                    CurrencyFactor :=
                          CurrencyExchangeRate.ExchangeRate("Posting Date", ReportInCurrency);


                    TotalPremiumkSH := ROUND(
                    CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                     "Posting Date", ReportInCurrency,
                     TotalPremium, CurrencyFactor));
                    TotalCommissionksh := ROUND(
                   CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                    "Posting Date", ReportInCurrency,
                    TotalCommission, CurrencyFactor));

                    TotalWtxksh := ROUND(
                   CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                    "Posting Date", ReportInCurrency,
                    TotalWtx, CurrencyFactor));

                    TotalRemainingksh := ROUND(
                   CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                    "Posting Date", ReportInCurrency,
                    TotalRemaining, CurrencyFactor));
                end;
            }

            trigger OnAfterGetRecord();
            begin

                TotalGross := 0;
                TotalWtx := 0;
                TotalNet := 0;
                TotalRemaining := 0;
                TotalCommission := 0;
                OpeningBal := 0;
                TotalPremium := 0;

                VendCopy.COPY(Vendor);
                VendCopy.SETRANGE(VendCopy."Date Filter", 0D, MinDate - 1);
                VendCopy.CALCFIELDS(VendCopy."Net Change");
                OpeningBal := VendCopy."Net Change";
                VendCopy.COPY(Vendor);
                VendCopy.SETRANGE(VendCopy."Date Filter", 0D, MaxDate);
                VendCopy.CALCFIELDS(VendCopy."Net Change");
                ClosingBal := VendCopy."Net Change";


                //IF NOT (ExistTransaction(Vendor."No.")) AND (OpeningBal=0) THEN
                //CurrReport.SKIP;
            end;

            trigger OnPreDataItem();
            begin
                FormatAddr.Company(CompanyAddr, companyInfo);
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
        TotalNetksh: Decimal;
        TotalWtxksh: Decimal;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        ReportInCurrency: Code[10];
        DebitNote: Record "Insure Header";
        GLAcc: Record "G/L Account";
        Class: Text[130];
        PolicyNumber: Code[20];
        ClientName: Text[200];
        WitholdingTax: Decimal;
        NetCommission: Decimal;
        vendledger: Record "Vendor Ledger Entry";
        PolicyDescription: Text[230];
        policyType: Record "Policy Type";
        Clientnames: Text[130];
        CompanyAddr: array[8] of Text[60];
        companyInfo: Record 79;
        FormatAddr: Codeunit 365;
        TotalGross: Decimal;
        TotalWtx: Decimal;
        TotalNet: Decimal;
        TotalRemaining: Decimal;
        Cust: Record Customer;
        CommissionAmt: Decimal;
        RemainingAmt: Decimal;
        TotalCommission: Decimal;
        PeriodFilter: Text[30];
        MinDate: Date;
        MaxDate: Date;
        VendCopy: Record Vendor;
        OpeningBal: Decimal;
        TotalPremium: Decimal;
        ClosingBal: Decimal;
        TotalPremiumkSH: Decimal;
        CurrencyFactor: Decimal;
        TotalCommissionksh: Decimal;
        TotalRemainingksh: Decimal;

    procedure ExistTransaction(var "Vendor No": Code[20]) transactExist: Boolean;
    var
        VendLedgerCopy: Record "Vendor Ledger Entry";
    begin
        transactExist := FALSE;
        VendLedgerCopy.RESET;
        VendLedgerCopy.SETRANGE(VendLedgerCopy."Vendor No.", "Vendor No");
        VendLedgerCopy.SETRANGE(VendLedgerCopy."Posting Date", MinDate, MaxDate);
        IF VendLedgerCopy.FIND('-') THEN
            transactExist := TRUE;
    end;
}

