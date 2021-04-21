report 51513003 "Monthly Premium Income"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Monthly Premium Income.rdl';
    dataset
    {
        dataitem(VendorLedgerEntry; "Vendor Ledger Entry")
        {
            DataItemTableView = SORTING("Posting Date", "Vendor No.");
            RequestFilterFields = "Posting Date", "Vendor No.";
            column(TransactionType; TransactionType)
            {

            }
            column(AmountLCY; "Amount (LCY)")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(VendorName; "Vendor Name")
            {
            }
            column(SerialNo; SerialNo)
            {
            }

            column(Underwriter; Underwriter)
            {
            }
            column(NameOfAssured; NameOfAssured)
            {
            }

            column(SumInsured; SumInsured)
            {
            }

            column(BrokerageCommission; BrokerageCommission)
            {
            }
            column(NetPremium; NetPremium)
            {
            }
            column(GrossPremium; GrossPremium)
            {

            }
            column(PolicyTenor; PolicyTenor)
            {

            }
            column(AmountReceived; AmountReceived)
            {

            }
            column(DateOfReceiptPremium; DateOfReceiptPremium)
            {

            }
            column(ReceiptNo; ReceiptNo)
            {

            }
            column(NameOfBankLodgement; NameOfBankLodgement)
            {

            }
            column(DateOfLodgement; DateOfLodgement)
            {

            }
            column(NameOfInsurers; NameOfInsurers)
            {

            }
            column(FromDate; FromDate)
            {

            }
            column(ToDate; ToDate)
            {

            }
            column(NameOfBroker; NameOfBroker)
            {

            }
            column(CustomerName; CustomerName)
            {

            }
            column(AmountRemitted; AmountRemitted)
            {

            }
            column(AmountUnremitted; AmountUnremitted)
            {

            }
            column(DatePaid_Transferred; "DatePaid/Transferred")
            {

            }
            column(NameOfBank; NameOfBank)
            {

            }
            column(ChequeNo; ChequeNo)
            {

            }
            column(Insurer_s_ReceiptNo; "Insurer(s)ReceiptNo")
            {

            }
            column(DateToRemitBalance; DateToRemitBalance)
            {

            }
            column(Remarks; Remarks)
            {

            }
            column(CompanyName; CompanyInfo.Name)
            {

            }
            column(CompanyLogo; companyInfo.Picture)
            {

            }
            column(CompanyAddress; CompanyInfo.Address)
            {

            }
            column(ReportDate; ReportDate)
            {
            }
            column(BeginDate; BeginDate)
            {

            }
            column(EndDate; EndDate)
            {

            }
            column(TodaysDate; TodaysDate)
            {

            }

            trigger OnAfterGetRecord()
            begin
                NameOfInsurers := '';
                "Amount (LCY)" := 0;
                NameOfAssured := '';
                SumInsured := 0;
                BrokerageCommission := 0;
                NetPremium := 0;
                GrossPremium := 0;
                PolicyTenor := 0;
                AmountReceived := 0;
                DateOfReceiptPremium := 0D;
                ReceiptNo := '';
                NameOfBankLodgement := '';
                DateOfLodgement := 0D;
                FromDate := 0D;
                ToDate := 0D;
                NameOfBroker := '';
                CustomerName := '';
                AmountRemitted := 0;
                AmountUnremitted := 0;
                "DatePaid/Transferred" := 0D;
                NameOfBank := '';
                ChequeNo := '';
                "Insurer(s)ReceiptNo" := '';
                DateToRemitBalance := 0D;
                Remarks := '';
                TransactionType := '';
                SerialNo := SerialNo + 1;
                InsuredDebitNote.Reset();
                InsuredDebitNote.SetRange("No.", VendorLedgerEntry."Document No.");
                if InsuredDebitNote.Findfirst then begin
                    Message('Insured debit note number %1', InsuredDebitNote."No.");
                    //"Amount (LCY)":=InsuredDebitNote.
                    TransactionType := InsuredDebitNote."Endorsement Type";
                    FromDate := InsuredDebitNote."From Date";
                    ToDate := InsuredDebitNote."To Date";
                    NameOfAssured := InsuredDebitNote."Insured Name";
                    CustomerName := InsuredDebitNote."Insured Name";
                    NameOfBroker := InsuredDebitNote."Agent/Broker";
                    SumInsured := InsuredDebitNote."Total Sum Insured";
                    GrossPremium := InsuredDebitNote."Total Premium Amount";
                    BrokerageCommission := InsuredDebitNote."Total Commission Due";
                    NetPremium := InsuredDebitNote."Total Net Premium";
                    NameOfInsurers := InsuredDebitNote."Insured Name";
                    UnderwriterRec.Reset();
                    UnderwriterRec.SetRange(UnderwriterRec."Debit Note No.", "Document No.");
                    if UnderwriterRec.FindFirst then begin
                        //PolicyTenor:=InsuredDebitNote.
                        AmountReceived := UnderwriterRec.Amount;
                        DateOfReceiptPremium := UnderwriterRec."Date Receipted";
                        ReceiptNo := UnderwriterRec."Insurer Receipt No.";
                        //NameOfBankLodgement:=UnderwriterRec.
                        DateOfLodgement := UnderwriterRec."Date Receipted";
                        "DatePaid/Transferred" := UnderwriterRec."Date Receipted";
                        DLE.Reset();
                        DLE.SetRange(DLE."Entry No.", "Entry No.");
                        DLE.SetRange(DLE."Entry Type", DLE."Entry Type"::Application);
                        if DLE.FindFirst then
                            AmountRemitted := DLE.Amount;
                        AmountUnremitted := Amount - AmountRemitted;

                    end
                end
                else begin
                    ReceiptHeader.Reset();
                    ReceiptHeader.SetRange(ReceiptHeader."No.", ReceiptNo, "Document No.");
                    if ReceiptHeader.FindFirst then begin

                        NameOfBank := ReceiptHeader."Drawer Bank";
                        AmountReceived := ReceiptHeader.Amount;
                        ChequeNo := ReceiptHeader."Cheque No";
                        DateOfReceiptPremium := ReceiptHeader."Receipt Date";
                        ReceiptNo := ReceiptHeader."Receipt No.";
                        "Insurer(s)ReceiptNo" := ReceiptHeader."Receipt No.";





                    end;


                end;

            end;


            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
            end;



        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }


    }
    trigger OnPreReport();
    begin
        BeginDate := VendorLedgerEntry.GETRANGEMIN(VendorLedgerEntry."Posting Date");
        EndDate := VendorLedgerEntry.GETRANGEMAX(VendorLedgerEntry."Posting Date");
    end;

    var

        SerialNo: Integer;
        Underwriter: text[100];
        SumInsured: Decimal;
        BrokerageCommission: Decimal;
        NetPremium: Decimal;
        PolicyTenor: Integer;
        AmountReceived: Decimal;
        DateOfReceiptPremium: Date;
        ReceiptNo: code[20];
        NameOfBankLodgement: text[100];
        DateOfLodgement: Date;
        NameOfInsurers: Text[100];
        AmountRemitted: Decimal;
        AmountUnremitted: Decimal;
        "DatePaid/Transferred": Date;
        NameOfBank: text[100];
        ChequeNo: code[20];
        "Insurer(s)ReceiptNo": code[20];
        DateToRemitBalance: Date;
        Remarks: Text[100];
        TransactionType: text[100];
        FromDate: Date;
        ToDate: Date;
        NameOfBroker: text[200];
        CustomerName: text[200];
        NameOfAssured: text[200];
        GrossPremium: Decimal;
        CompanyInfo: Record "Company Information";
        ReportDate: Date;
        BeginDate: Date;
        EndDate: Date;
        TodaysDate: Date;
        InsuredDebitNote: Record "Insure Debit Note";
        EndorsementTypes: Record "Insure Debit Note";
        UnderwriterRec: Record "Underwriter Receipt";
        ReceiptLine: Record "Receipt Lines1x";
        DLE: Record 380;
        ReceiptHeader: Record "Receipts Headerx";



}
