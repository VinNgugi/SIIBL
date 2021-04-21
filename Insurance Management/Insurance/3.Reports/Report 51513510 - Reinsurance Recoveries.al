report 51513510 "Reinsurance Recoveries"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Reinsurance Recoveries.rdl';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code")
                                WHERE("Insurance Trans Type" = CONST("Claim Recovery"));
            RequestFilterFields = "Global Dimension 1 Code";
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
            column(BranchAgent; BranchAgent)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(DepartmentName; DepartmentName)
            {
            }
            column(ShortCode; ShortCode)
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEnddate; PeriodEnddate)
            {
            }
            column(ReferenceNo; ReferenceNo)
            {
            }
            column(CustomerNo_CustLedgerEntry; "Cust. Ledger Entry"."Customer No.")
            {
            }
            column(PostingDate_CustLedgerEntry; "Cust. Ledger Entry"."Posting Date")
            {
            }
            column(DocumentType_CustLedgerEntry; "Cust. Ledger Entry"."Document Type")
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
            column(ClaimNo_CustLedgerEntry; "Cust. Ledger Entry"."Claim No.")
            {
            }
            column(InsuredID_CustLedgerEntry; "Cust. Ledger Entry"."Insured ID")
            {
            }
            column(Description; Description)
            {
            }
            column(DateofLoss; DateofLoss)
            {
            }
            column(NameofInsured; NameofInsured)
            {
            }
            column(PolicyNo; PolicyNo)
            {
            }
            column(CauseDescription; CauseDescription)
            {
            }
            column(ClassName; ClassName)
            {
            }
            column(Payee; Payee)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(ToDate; ToDate)
            {
            }
            column(TreatyClaim; TreatyClaim)
            {
            }
            column(FacultativeClaim; FacultativeClaim)
            {
            }
            column(XOLClaim; XOLClaim)
            {
            }
            column(QuotaShare; QuotaShare)
            {
            }
            column(PSTClaim; PSTClaim)
            {
            }
            column(TotalCheqPayments; TotalCheqPayments)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);

                /*
                Payments.SETRANGE(Payments.No, "Bank Account Ledger Entry"."Document No.");
                IF Payments.FINDFIRST THEN BEGIN
                  Payee:=Payments.Payee;
                  END;
                PVLines1.SETRANGE(PVLines1."PV No", "Bank Account Ledger Entry"."Document No.");
                IF PVLines1.FINDFIRST THEN BEGIN
                  ClaimNo:=PVLines1."Claim No";
                BranchCode:=PVLines1."Shortcut Dimension 1 Code";
                DepartmentCode:=PVLines1."Shortcut Dimension 2 Code";
                END
                */
                NameofInsured := '';
                PSTClaim := 0;
                PolicyNo := '';
                ShortCode := '';

                Claim.SETRANGE(Claim."Claim No", "Cust. Ledger Entry"."Claim No.");
                IF Claim.FINDFIRST THEN BEGIN
                    DateofLoss := Claim."Date of Occurence";
                    Description := Claim."Loss Type Description";
                    Claim.CALCFIELDS("Amount Settled", "Treaty Claim Recoveries", "Facultative Claim Recovries", "XOL Claim Recoveries", "Quota Share");
                    TotalCheqPayments := Claim."Amount Settled";
                    CauseDescription := Claim."Cause Description";
                    ClassName := Claim."Class Description";
                    TreatyClaim := Claim."Treaty Claim Recoveries";
                    FacultativeClaim := Claim."Facultative Claim Recovries";
                    XOLClaim := Claim."XOL Claim Recoveries";
                    QuotaShare := Claim."Quota Share";
                    PSTClaim := Claim."PSTM Claims";
                    ShortCode := Claim."Class Description";
                    PolicyNo := Claim."Policy No";
                    NameofInsured := Claim."Name of Insured";

                END;
                InsureHeader.SETRANGE(InsureHeader."No.", PolicyNo);
                IF InsureHeader.FIND('-') THEN BEGIN
                    FromDate := InsureHeader."From Date";
                    ToDate := InsureHeader."To Date";
                    Description := InsureHeader."Policy Description";
                END;
                //MESSAGE('%1',FromDate);
                //}
                GenLedgSetup.GET;
                //Branch
                IF DimValue.GET(GenLedgSetup."Global Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;

                IF DimValue.GET(GenLedgSetup."Shortcut Dimension 2 Code", DepartmentCode) THEN
                    DepartmentName := DimValue.Name;
                //From Date, To Date
                /*
                PolicyType.SETRANGE(PolicyType.Description,Description);
                IF PolicyType.FIND('-') THEN
                  ShortCode:= PolicyType."short code";
                */

            end;

            trigger OnPreDataItem();
            begin
                VerifyDates();
                "Cust. Ledger Entry".SETRANGE("Cust. Ledger Entry"."Posting Date", PeriodStartDate, PeriodEnddate);
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
                    field(EndingDate; PeriodEnddate)
                    {
                        Caption = 'Ending Date';
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
            PeriodEnddate := WORKDATE;
        end;
    }

    labels
    {
        ReportTitleLbl = 'REINSURANCE CLAIM RECOVERIES';
    }

    var
        CompInfor: Record 79;
        PolicyType: Record "Policy Type";
        Cust: Record Customer;
        ClaimNo: Text;
        PolicyNo: Text;
        DateofLoss: Date;
        Description: Text;
        NameofInsured: Text;
        TotalCheqPayments: Decimal;
        CauseDescription: Text;
        Dimensions: Record 348;
        ClassName: Text;
        Payments: Record Payments1;
        Payee: Text;
        InsuranceClass: Record "Insurance Class";
        PolicyHolder: Text;
        InsureHeader: Record "Insure Header";
        FromDate: Date;
        ToDate: Date;
        TreatyClaim: Decimal;
        FacultativeClaim: Decimal;
        XOLClaim: Decimal;
        QuotaShare: Decimal;
        PSTClaim: Decimal;
        BranchAgent: Code[10];
        GenLedgSetup: Record "General Ledger Setup";
        BranchName: Text;
        BranchCode: Code[30];
        DimValue: Record "Dimension Value";
        DepartmentCode: Code[30];
        DepartmentName: Text;
        ShortCode: Code[30];
        PeriodStartDate: Date;
        PeriodEnddate: Date;
        BlankStartDateErr: Label 'Start Date must have a value.';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';
        PVLines1: Record 51511001;
        GlEntry: Record "G/L Entry";
        ReferenceNo: Code[10];
        Claim: Record Claim;

    procedure InitializeRequest(StartDate: Date; EndDate: Date);
    begin
        PeriodStartDate := StartDate;
        PeriodEnddate := EndDate;
    end;

    local procedure VerifyDates();
    begin
        IF PeriodStartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF PeriodEnddate = 0D THEN
            ERROR(BlankEndDateErr);
        IF PeriodStartDate > PeriodEnddate THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;
}

