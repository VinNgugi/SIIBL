report 51513511 "Premium Production Report"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Premium Production Report.rdl';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                WHERE("Document Type" = FILTER(<> Payment));
            RequestFilterFields = "Posting Date", "Global Dimension 1 Code";
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
            column(PostingDate_CustLedgerEntry; "Cust. Ledger Entry"."Posting Date")
            {
            }
            column(MonthlyNewBusPremium; MonthlyNewBusPremium)
            {
            }
            column(MonthlyRenewalPremium; MonthlyRenewalPremium)
            {
            }
            column(MonthlyRefundPremium; MonthlyRefundPremium)
            {
            }
            column(MonthlyExtraPremium; MonthlyExtraPremium)
            {
            }
            column(MonthlyMiscDebs; MonthlyMiscDebs)
            {
            }
            column(AdditionalYellowCardCharges; AdditionalYellowCardCharges)
            {
            }
            column(MonthlyTotalPremium; MonthlyTotalPremium)
            {
            }

            trigger OnAfterGetRecord();
            begin

                "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Document No.", "Cust. Ledger Entry"."Document No.");
                "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Posting Date", "Cust. Ledger Entry"."Posting Date");
                "Cust. Ledger Entry".FINDLAST;
                Amt := 0;
                Amt := ROUND(Amount, 1);
                GeneralLedgSetup.GET;
                BranchCode := "Cust. Ledger Entry"."Global Dimension 1 Code";
                IF DimValue.GET(GeneralLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;

                BusinessTypeCode := "Cust. Ledger Entry"."Global Dimension 3 Code";
                IF DimValue.GET(GeneralLedgSetup."Shortcut Dimension 4 Code", BusinessTypeCode) THEN BEGIN
                    DimValue.CALCFIELDS(DimValue."New Business");
                    MonthlyNewBusPremium := DimValue."New Business";
                    DimValue.CALCFIELDS(DimValue."Renewal Business");
                    MonthlyRenewalPremium := DimValue."Renewal Business";
                    DimValue.CALCFIELDS(DimValue."Refund Premium");
                    MonthlyRefundPremium := DimValue."Refund Premium";
                    DimValue.CALCFIELDS(DimValue."Extra Premium");
                    MonthlyExtraPremium := DimValue."Extra Premium";
                    DimValue.CALCFIELDS(DimValue."Misc. Debits/Credits");
                    MonthlyMiscDebs := DimValue."Misc. Debits/Credits";
                    DimValue.CALCFIELDS(DimValue."Additional Certificates/Yellow");
                    AdditionalYellowCardCharges := DimValue."Additional Certificates/Yellow";
                    DimValue.CALCFIELDS(DimValue."Total Premium");
                    MonthlyTotalPremium := DimValue."Total Premium";
                END;

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
                    CommissionAmount := GrossPremium * 10 / 100;

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
                            'PCF':
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
                    IntermediaryCode := creditnote."Agent/Broker";
                    BusinessTypeCode := creditnote."Endorsement Type";
                    IF EndorsementType.GET(BusinessTypeCode) THEN
                        BusinessTypeName := EndorsementType.Description;

                    creditnote.CALCFIELDS(creditnote."Total Premium Amount");
                    GrossPremium := -ROUND(creditnote."Total Premium Amount", 1);
                    CommissionAmount := GrossPremium * 10 / 100;

                    InsureCRLines.SETRANGE(InsureCRLines."Document No.", "Cust. Ledger Entry"."Document No.");
                    InsureCRLines.SETRANGE(InsureCRLines."Description Type", InsureCRLines."Description Type"::Tax);
                    IF InsureCRLines.FINDFIRST THEN
                        REPEAT
                            TaxDescription := InsureCRLines.Description;
                            TaxAmount := InsureCRLines.Amount;
                            CASE TaxDescription OF
                                'PCF':
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
                                    END

                            END;

                        UNTIL InsureDBLines.NEXT = 0;



                END;
                "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Document No.");
                "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Posting Date");
            end;

            trigger OnPreDataItem();
            begin

                LastFieldNo := FIELDNO("Customer No.");
                //CurrReport.CREATETOTALS(GrossPremium, TaxesArrayVal, Amt);
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
        MonthlyNewBusPremium: Decimal;
        MonthlyRenewalPremium: Decimal;
        MonthlyRefundPremium: Decimal;
        MonthlyExtraPremium: Decimal;
        MonthlyMiscDebs: Decimal;
        AdditionalYellowCardCharges: Decimal;
        MonthlyTotalPremium: Integer;
}

