report 51513529 "Agent Statement"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Agent Statement.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "Global Dimension 1 Code", "Customer Posting Group";
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
            column(StartBalanceLCY; StartBalanceLCY)
            {
            }
            column(StartBalance; StartBalance)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(CustAddress2; CustAddress2)
            {
            }
            column(StartBalance2; StartBalance)
            {
                AutoFormatExpression = "Cust. Ledger Entry"."Currency Code";
                AutoFormatType = 1;
            }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Document Type", "Posting Date")
                                    WHERE(Amount = FILTER(<> 0));
                RequestFilterFields = "Posting Date";
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
                column(MaxDate; MaxDate)
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
                column(CustAddress; CustAddress)
                {
                }
                column(PostingDate_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Posting Date")
                {
                }
                column(StampDutyAmount; StampDutyAmount)
                {
                }
                column(TrainingLevyAmount; TrainingLevyAmount)
                {
                }
                column(PCFAmount; PCFAmount)
                {
                }
                column(ReceiptAmount; ReceiptAmount)
                {
                }
                column(CustAccBalance; CustAccBalance)
                {
                }
                column(NetBalance; NetBalance)
                {
                }
                dataitem("<Integer>s"; 2000000026)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));

                    trigger OnAfterGetRecord();
                    begin
                        IF NOT CustLedgEntryExists AND ((StartBalance = 0) OR ExcludeBalanceOnly) THEN BEGIN
                            StartBalanceLCY := 0;
                            CurrReport.SKIP;
                        END;
                    end;
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
                    GrossPremium := 0;
                    TotalWtx := 0;
                    TotalCommission := 0;
                    AgentCode := '';
                    BrokerName := '';
                    AgentName := '';
                    NetPremium := 0;
                    CustAddress := '';
                    DocType := '';
                    ReceiptAmount := 0;
                    PolicyNumber := '';
                    Insured := '';
                    PCFAmount := 0;
                    StampDutyAmount := 0;
                    TrainingLevyAmount := 0;
                    CertificateChargeAmount := 0;
                    /*
                    IF NOT PrintReversedEntries AND Reversed THEN
                      CurrReport.SKIP;
                      */
                    CustLedgEntryExists := TRUE;
                    CustAccBalance := CustAccBalance + Amount;
                    CustAccBalanceLCY := CustAccBalanceLCY + "Amount (LCY)";

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
                                AgentName := Cust2.Name;
                            IF Cust2."Address 2" <> '' THEN
                                CustAddress := 'P.O BOX' + ' ' + Cust2."Address 2" + '-' + Cust2."Post Code" + '   ' + Cust2.City;
                            IF CustPostingGroup = 'AGENTS' THEN
                                AgentName := Cust2.Name;
                            IF Cust2."Address 2" <> '' THEN
                                CustAddress := 'P.O BOX' + ' ' + Cust2."Address 2" + '-' + Cust2."Post Code" + '   ' + Cust2.City;
                        END;
                    END;
                    ReceiptsHeader.SETRANGE(ReceiptsHeader."No.", "Detailed Cust. Ledg. Entry"."Document No.");
                    IF ReceiptsHeader.FINDFIRST THEN BEGIN
                        DocType := 'REC';
                        ReceiptsHeader.CALCFIELDS("Total Amount");
                        ReceiptAmount := ReceiptsHeader."Total Amount";
                        ReceiptsLines.SETRANGE(ReceiptsLines."Receipt No.", ReceiptsHeader."No.");
                        IF ReceiptsLines.FINDFIRST THEN BEGIN
                            DebitNote.SETRANGE(DebitNote."No.", ReceiptsLines."Applies to Doc. No");
                            IF DebitNote.FINDFIRST THEN BEGIN
                                Insured := DebitNote."Insured Name";
                                PolicyNumber := DebitNote."Policy No";
                                AgentCode := DebitNote."Agent/Broker";
                                IF Cust2.GET(AgentCode) THEN BEGIN
                                    CustPostingGroup := Cust2."Customer Posting Group";
                                    IF CustPostingGroup = 'BROKERS' THEN
                                        AgentName := Cust2.Name;
                                    IF Cust2."Address 2" <> '' THEN
                                        CustAddress := 'P.O BOX' + ' ' + Cust2."Address 2" + '-' + Cust2."Post Code" + '   ' + Cust2.City;
                                    IF CustPostingGroup = 'AGENTS' THEN
                                        AgentName := Cust2.Name;
                                    IF Cust2."Address 2" <> '' THEN
                                        CustAddress := 'P.O BOX' + ' ' + Cust2."Address 2" + '-' + Cust2."Post Code" + '   ' + Cust2.City;
                                END;
                            END;
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
                                AgentName := Cust2.Name;
                            IF Cust2."Address 2" <> '' THEN
                                CustAddress := 'P.O BOX' + ' ' + Cust2."Address 2" + '-' + Cust2."Post Code" + '   ' + Cust2.City;
                            IF CustPostingGroup = 'AGENTS' THEN
                                AgentName := Cust2.Name;
                            IF Cust2."Address 2" <> '' THEN
                                CustAddress := 'P.O BOX' + ' ' + Cust2."Address 2" + '-' + Cust2."Post Code" + '   ' + Cust2.City;
                        END;

                        DocType := 'DRN';

                    END;



                    InsureDBLines.SETRANGE(InsureDBLines."Document No.", "Detailed Cust. Ledg. Entry"."Document No.");
                    InsureDBLines.SETRANGE(InsureDBLines."Description Type", InsureDBLines."Description Type"::Tax);
                    IF InsureDBLines.FINDFIRST THEN
                        REPEAT
                            TaxDescription := InsureDBLines.Description;
                            TaxAmount := InsureDBLines.Amount;
                            CASE TaxDescription OF
                                'Certificate Charge':
                                    BEGIN
                                        CertificateChargeCaption := TaxDescription;
                                        CertificateChargeAmount := TaxAmount;
                                    END;

                                'PHCF':
                                    BEGIN
                                        LblPCF := TaxDescription;
                                        PCFAmount := TaxAmount;

                                    END;
                                'Stamp Duty':
                                    BEGIN
                                        StampDutyLbl := TaxDescription;
                                        StampDutyAmount := TaxAmount;
                                    END;
                                'Training Levy':
                                    BEGIN
                                        TrainingLevyLbl := TaxDescription;
                                        TrainingLevyAmount := TaxAmount;

                                    END;


                                ELSE BEGIN
                                        PCFAmount := 0;
                                        StampDutyAmount := 0;
                                        TrainingLevyAmount := 0;
                                        CertificateChargeAmount := 0;
                                    END

                            END;

                        UNTIL InsureDBLines.NEXT = 0;
                    //for credit notes
                    InsureCRLines.RESET;
                    InsureCRLines.SETRANGE(InsureCRLines."Document No.", "Detailed Cust. Ledg. Entry"."Document No.");
                    InsureCRLines.SETRANGE(InsureCRLines."Description Type", InsureCRLines."Description Type"::Tax);
                    IF InsureCRLines.FINDFIRST THEN BEGIN
                        REPEAT
                            TaxDescription := InsureCRLines.Description;
                            TaxAmount := InsureDBLines.Amount;
                            CASE TaxDescription OF
                                'Certificate Charge':
                                    BEGIN
                                        CertificateChargeCaption := TaxDescription;
                                        CertificateChargeAmount := TaxAmount;
                                    END;

                                'PHCF':
                                    BEGIN
                                        LblPCF := TaxDescription;
                                        PCFAmount := TaxAmount;
                                        //MESSAGE('%1%2', InsureDBLines.Description);
                                    END;
                                'Stamp Duty':
                                    BEGIN
                                        StampDutyLbl := TaxDescription;
                                        StampDutyAmount := TaxAmount;
                                    END;
                                'Training Levy':
                                    BEGIN
                                        TrainingLevyLbl := TaxDescription;
                                        TrainingLevyAmount := TaxAmount;

                                    END;


                                ELSE BEGIN
                                        PCFAmount := 0;
                                        StampDutyAmount := 0;
                                        TrainingLevyAmount := 0;
                                        CertificateChargeAmount := 0;
                                    END

                            END;

                        UNTIL InsureDBLines.NEXT = 0;
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
                    NetBalance := NetBalance + GrossPremium + TotalCommission + TotalWtx + TrainingLevyAmount + PCFAmount + ReceiptAmount;
                    //IIF(Fields!ReceiptAmount.Value=0,(Fields!GrossPremium.Value+Fields!TotalCommission.Value+Fields!TotalWtx.Value+Fields!TrainingLevyAmount.Value+Fields!PCFAmount.Value),Fields!ReceiptAmount.Value)


                    "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Document No.");
                    "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Posting Date");

                end;

                trigger OnPreDataItem();
                begin
                    "Detailed Cust. Ledg. Entry".SETRANGE("Posting Date", PeriodStartDate, MaxDate);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CompanyInfo.GET;
                CustAddress2 := '';
                CompInfor.CALCFIELDS(CompInfor.Picture);
                IF MaxDate = 0D THEN
                    ERROR(BlankMaxDateErr);
                SETRANGE("Date Filter", 0D, MaxDate);

                CALCFIELDS("Net Change (LCY)", "Net Change");

                StartBalance := 0;
                IF DateFilter_BankAccount <> '' THEN
                    IF GETRANGEMIN("Date Filter") <> 0D THEN BEGIN
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        CALCFIELDS("Net Change", "Net Change (LCY)");
                        StartBalance := "Net Change";
                        StartBalanceLCY := "Net Change (LCY)";
                        SETFILTER("Date Filter", DateFilter_BankAccount);
                    END;
                CurrReport.PRINTONLYIFDETAIL := ExcludeBalanceOnly OR (StartBalance = 0);
                CustAccBalance := StartBalance;
                CustAccBalanceLCY := StartBalanceLCY;



                IF PrintOnlyOnePerPage THEN
                    PageGroupNo := PageGroupNo + 1;
            end;

            trigger OnPreDataItem();
            begin
                CurrReport.NEWPAGEPERRECORD := PrintOnePrPage;
                VerifyDates;
                Customer.SETRANGE("Date Filter", PeriodStartDate, MaxDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate; PeriodStartDate)
                    {
                        Caption = 'Starting Date';
                    }
                    field(MaxDate; MaxDate)
                    {
                        Caption = 'Ending Date';
                    }
                    field(PrintOnePrPage; PrintOnePrPage)
                    {
                        Caption = 'New Page Per Agent';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            PeriodStartDate := WORKDATE;
            MaxDate := WORKDATE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CustFilter := Customer.GETFILTERS;
        CustDateFilter := Customer.GETFILTER("Date Filter");
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
        DocType: Text;
        Commissiondue: Decimal;
        AgentCode: Code[30];
        AgentName: Text;
        OptionValue: Option;
        DetailedCustLedger: Record 379;
        CustPostingGroup: Code[30];
        BrokerName: Text;
        NetPremium: Decimal;
        CustAddress: Text;
        InsureCRLines: Record "Insure Credit Note Lines";
        TaxDescription: Text;
        TaxAmount: Decimal;
        CertificateChargeCaption: Text;
        CertificateChargeAmount: Decimal;
        InsureDBLines: Record "Insure Debit Note Lines";
        LblPCF: Text;
        PCFAmount: Decimal;
        StampDutyLbl: Text;
        StampDutyAmount: Decimal;
        TrainingLevyAmount: Decimal;
        TrainingLevyLbl: Text;
        ReceiptAmount: Decimal;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        BankAccFilter: Text;
        DateFilter_BankAccount: Text[30];
        CustAccBalance: Decimal;
        CustAccBalanceLCY: Decimal;
        StartBalance: Decimal;
        CustLedgEntryExists: Boolean;
        StartBalanceLCY: Decimal;
        PageGroupNo: Integer;
        PrintOnePrPage: Boolean;
        MaxDate: Date;
        BlankMaxDateErr: Label 'Ending Date must have a value.';
        CustFilter: Text;
        CustDateFilter: Text[30];
        PeriodStartDate: Date;
        BlankStartDateErr: Label 'Start Date must have a value.';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';
        CustAddress2: Text;
        ReceiptsHeader: Record "Receipts Header";
        ReceiptsLines: Record "Receipt Lines";
        RunningBalance: Decimal;
        NetBalance: Decimal;

    procedure InitializeRequest(NewPrintOnePrPage: Boolean; NewEndingDate: Date);
    begin
        PrintOnePrPage := NewPrintOnePrPage;
        MaxDate := NewEndingDate;
    end;

    local procedure VerifyDates();
    begin
        IF PeriodStartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF MaxDate = 0D THEN
            ERROR(BlankEndDateErr);
        IF PeriodStartDate > MaxDate THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;
}

