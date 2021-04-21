report 51513556 "Premium Production Summary"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Premium Production Summary.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Intermediary No.";
            column(No_Cust; "No.")
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                    WHERE("Document Type" = FILTER(<> Payment));
                RequestFilterFields = "Global Dimension 1 Code", "Endorsement Type", "Policy Type";
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
                column(EntryNo_CustLedgerEntry; "Cust. Ledger Entry"."Entry No.")
                {
                }
                column(DocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."Document No.")
                {
                }
                column(Description_CustLedgerEntry; "Cust. Ledger Entry".Description)
                {
                }
                column(Amount_CustLedgerEntry; "Cust. Ledger Entry".Amount)
                {
                }
                column(GrossPremium; GrossPremium)
                {
                }
                column(Amt; Amt)
                {
                }
                column(TransactionTypeS; TransactionTypeS)
                {
                }
                column(PostingDate; "Cust. Ledger Entry"."Posting Date")
                {
                }
                column(InsuredNAme; InsuredNAme)
                {
                }
                column(ClassOfInsurance; ClassOfInsurance)
                {
                }
                column(POlicyNo; POlicyNo)
                {
                }
                column(NetPremium; NetPremium)
                {
                }
                column(Insurer; Insurer)
                {
                }
                column(RegNo; RegNo)
                {
                }
                column(SeatingCapacity; SeatingCapacity)
                {
                }
                column(FromDate; FromDate)
                {
                }
                column(ToDate; ToDate)
                {
                }
                column(Intermediary; Intermediary)
                {
                }
                column(CertNo; CertNo)
                {
                }
                column(ReceiptNo; ReceiptNo)
                {
                }
                column(ReceiptedAmount; ReceiptedAmount)
                {
                }
                column(IntermediaryCode; IntermediaryCode)
                {
                }
                column(BranchName; BranchName)
                {
                }
                column(SumInsured; SumInsured)
                {
                }
                column(CommissionAmount; CommissionAmount)
                {
                }
                column(TaxDescription; TaxDescription)
                {
                }
                column(TaxAmount; TaxAmount)
                {
                }
                column(BusinessTypeName; BusinessTypeName)
                {
                }
                column(PCFAmount; PCFAmount)
                {
                }
                column(StampDutyAmount; StampDutyAmount)
                {
                }
                column(TrainingLevyAmount; TrainingLevyAmount)
                {
                }
                column(InsuranceTransType_CustLedgerEntry; "Cust. Ledger Entry"."Insurance Trans Type")
                {
                }
                column(CertificateChargeAmount; CertificateChargeAmount)
                {
                }
                column(SourceOfBusiness; SourceOfBusiness)
                {
                }
                column(StardDate; StartDate)
                {
                }
                column(EndDate; EndDate)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    CompInfor.GET;
                    CompInfor.CALCFIELDS(Picture);
                    "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Document No.", "Cust. Ledger Entry"."Document No.");
                    "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Posting Date", "Cust. Ledger Entry"."Posting Date");
                    "Cust. Ledger Entry".FINDLAST;
                    Amt := 0;
                    PCFAmount := 0;
                    StampDutyAmount := 0;
                    TrainingLevyAmount := 0;
                    CertificateChargeAmount := 0;

                    Amt := ROUND(Amount, 1);
                    GeneralLedgSetup.GET;
                    BranchCode := "Cust. Ledger Entry"."Global Dimension 1 Code";
                    IF DimValue.GET(GeneralLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                        BranchName := DimValue.Name;

                    //  IF PostedDebitNote.GET("Cust. Ledger Entry"."Document No.") THEN
                    // BEGIN
                    //"Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Document No.", "Cust. Ledger Entry"."Document No.");
                    PostedDebitNote.SETRANGE(PostedDebitNote."Document Type", PostedDebitNote."Document Type"::"Debit Note");
                    PostedDebitNote.SETRANGE(PostedDebitNote."No.", "Cust. Ledger Entry"."Document No.");
                    IF PostedDebitNote.FIND('-') THEN BEGIN

                        InsuredNAme := PostedDebitNote."Insured Name";
                        IF PolicyRec.GET(PostedDebitNote."Policy Type") THEN
                            ClassOfInsurance := PolicyRec.Description;

                        Insurer := PostedDebitNote."Undewriter Name";
                        POlicyNo := PostedDebitNote."Policy No";
                        PostedDebitNote.CALCFIELDS(PostedDebitNote."Total Sum Insured");
                        SumInsured := PostedDebitNote."Total Sum Insured";
                        PostedDebitNote.CALCFIELDS(PostedDebitNote."Total Net Premium");
                        NetPremium := PostedDebitNote."Total Net Premium";
                        FromDate := PostedDebitNote."From Date";
                        ToDate := PostedDebitNote."To Date";
                        IntermediaryCode := PostedDebitNote."Agent/Broker";
                        Intermediary := PostedDebitNote."Brokers Name";
                        SourceOfBusiness := PostedDebitNote."Source of Business";

                        SalesCRLine.SETRANGE(SalesCRLine."Document No.", PostedDebitNote."No.");
                        IF SalesCRLine.FIND('-') THEN
                            RegNo := SalesCRLine."Registration No.";
                        SeatingCapacity := SalesCRLine."Seating Capacity";

                        IF PostedDebitNote."Quote Type" = PostedDebitNote."Quote Type"::New THEN
                            TransactionTypeS := 'NB';
                        IF PostedDebitNote."Quote Type" = PostedDebitNote."Quote Type"::Renewal THEN
                            TransactionTypeS := 'REN';

                        IF PostedDebitNote."Quote Type" = PostedDebitNote."Quote Type"::Modification THEN
                            IF PostedDebitNote."Modification Type" = PostedDebitNote."Modification Type"::Addition THEN
                                TransactionTypeS := 'END';

                        PostedDebitNote.CALCFIELDS(PostedDebitNote."Total Premium Amount");
                        GrossPremium := ROUND(PostedDebitNote."Total Premium Amount", 1);
                        // CommissionAmount:=GrossPremium*10/100;

                        BusinessTypeCode := PostedDebitNote."Endorsement Type";
                        IF EndorsementType.GET(BusinessTypeCode) THEN
                            BusinessTypeName := EndorsementType.Description;
                    END;

                    InsureDBLines.SETRANGE(InsureDBLines."Document No.", "Cust. Ledger Entry"."Document No.");
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


                    CertificatesPrinting.SETRANGE(CertificatesPrinting."Policy No", POlicyNo);
                    IF CertificatesPrinting.FIND('-') THEN
                        CertNo := CertificatesPrinting."Certificate No.";
                    //ReceiptNo and Amount
                    ReceiptLines1x.SETRANGE(ReceiptLines1x."Applies to Doc. No", "Cust. Ledger Entry"."Document No.");
                    IF ReceiptLines1x.FIND('-') THEN
                        ReceiptNo := ReceiptLines1x."Receipt No.";
                    ReceiptedAmount := ReceiptLines1x."Net Amount";

                    //Registration Number and seating capacity

                    //  CertificateNo:=SalesCRLine


                    // IF creditnote.GET("Cust. Ledger Entry"."Document No.") THEN
                    // BEGIN
                    creditnote.SETRANGE(creditnote."Document Type", creditnote."Document Type"::"Credit Note");
                    creditnote.SETRANGE(creditnote."No.", "Cust. Ledger Entry"."Document No.");
                    IF creditnote.FIND('-') THEN BEGIN


                        TransactionTypeS := 'END';
                        InsuredNAme := creditnote."Insured Name";

                        IF PolicyRec.GET(creditnote."Policy Type") THEN
                            ClassOfInsurance := PolicyRec.Description;

                        Insurer := creditnote."Undewriter Name";
                        POlicyNo := creditnote."Policy No";
                        creditnote.CALCFIELDS(creditnote."Total Net Premium");
                        NetPremium := creditnote."Total Net Premium";
                        POlicyNo := creditnote."Policy No";
                        creditnote.CALCFIELDS(creditnote."Total Sum Insured");
                        SumInsured := creditnote."Total Sum Insured";
                        FromDate := creditnote."From Date";
                        ToDate := creditnote."To Date";
                        SourceOfBusiness := PostedDebitNote."Source of Business";

                        IntermediaryCode := creditnote."Agent/Broker";
                        BusinessTypeCode := creditnote."Endorsement Type";
                        IF EndorsementType.GET(BusinessTypeCode) THEN
                            BusinessTypeName := EndorsementType.Description;

                        creditnote.CALCFIELDS(creditnote."Total Premium Amount");
                        GrossPremium := -ROUND(creditnote."Total Premium Amount", 1);
                        //  CommissionAmount:=GrossPremium*10/100;

                        InsureCRLines.SETRANGE(InsureCRLines."Document No.", "Cust. Ledger Entry"."Document No.");
                        InsureCRLines.SETRANGE(InsureCRLines."Description Type", InsureCRLines."Description Type"::Tax);
                        IF InsureCRLines.FINDFIRST THEN
                            REPEAT
                                TaxDescription := InsureCRLines.Description;
                                TaxAmount := InsureCRLines.Amount;
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



                    END;

                    "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Insurance Trans Type", "Cust. Ledger Entry"."Insurance Trans Type"::Commission);
                    IF "Cust. Ledger Entry".FINDFIRST THEN
                        CommissionAmount := "Cust. Ledger Entry".Amount;

                    "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Document No.");
                    "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Posting Date");
                end;

                trigger OnPreDataItem();
                begin
                    SETRANGE("Customer No.", Customer."No.");
                    SETRANGE("Posting Date", StartDate, EndDate);

                    LastFieldNo := FIELDNO("Customer No.");
                    //CurrReport.CREATETOTALS(GrossPremium, TaxesArrayVal, Amt);
                end;
            }

            trigger OnPreDataItem();
            begin
                VerifyDates;
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
                    field("Start Date"; StartDate)
                    {
                        Caption = 'Start Date';
                    }
                    field("End Date"; EndDate)
                    {
                        Caption = 'End Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            StartDate := WORKDATE;
            EndDate := WORKDATE;
        end;
    }

    labels
    {
    }

    var
        CompInfor: Record 79;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        PostedDebitNote: Record "Insure Debit Note";
        Taxes: Record 5630;
        TaxesArray: array[10] of Code[10];
        TaxesArrayVal: array[10] of Decimal;
        i: Integer;
        SalesLine: Record "Insure Lines";
        GrossPremium: Decimal;
        NetPremium: Decimal;
        TaxesArraydesc: array[10] of Text[30];
        TransactionTypeS: Text[50];
        InsuredNAme: Text[250];
        ClassOfInsurance: Text[250];
        POlicyNo: Code[30];
        Insurer: Text[250];
        creditnote: Record "Insure Credit Note";
        SalesCRLine: Record "Insure Lines";
        PolicyRec: Record "Policy Type";
        Amt: Decimal;
        FromDate: Date;
        ToDate: Date;
        SeatingCapacity: Integer;
        RegNo: Code[30];
        CertificateNo: Code[30];
        Intermediary: Text;
        CertNo: Code[30];
        CertificatesPrinting: Record "Certificate Printing";
        ReceiptLines1x: Record "Receipt Lines";
        ReceiptNo: Code[30];
        ReceiptedAmount: Decimal;
        IntermediaryCode: Code[30];
        GeneralLedgSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        BranchName: Text;
        BranchCode: Code[10];
        SumInsured: Decimal;
        CommissionAmount: Decimal;
        InsureCRLines: Record "Insure Credit Note Lines";
        InsureDBLines: Record "Insure Debit Note Lines";
        TaxDescription: Text;
        TaxAmount: Decimal;
        BusinessTypeCode: Code[30];
        BusinessTypeName: Text;
        DescriptionLine: array[2] of Text;
        LblPCF: Text;
        PCFAmount: Decimal;
        StampDutyLbl: Text;
        StampDutyAmount: Decimal;
        TrainingLevyAmount: Decimal;
        TrainingLevyLbl: Text;
        EndorsementType: Record "Endorsement Types";
        CertificateChargeAmount: Decimal;
        CertificateChargeCaption: Text;
        StartDate: Date;
        EndDate: Date;
        SourceOfBusiness: Code[30];
        BlankStartDateErr: Label 'Start Date must have a value.';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';

    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date);
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;

    local procedure VerifyDates();
    begin
        IF StartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF EndDate = 0D THEN
            ERROR(BlankEndDateErr);
        IF StartDate > EndDate THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;
}

