report 51513501 "Claims Paid"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Claims Paid.rdl';

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Bank Account No.", "Posting Date");
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
            column(DocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Document No.")
            {
            }
            column(Description_BankAccountLedgerEntry; "Bank Account Ledger Entry".Description)
            {
            }
            column(Amount_BankAccountLedgerEntry; "Bank Account Ledger Entry".Amount)
            {
            }
            column(NameofInsured; NameofInsured)
            {
            }
            column(PolicyNo; PolicyNo)
            {
            }
            column(Description; Description)
            {
            }
            column(TotalCheqPayments; TotalCheqPayments)
            {
            }
            column(CauseDescription; CauseDescription)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(ClassName; ClassName)
            {
            }
            column(Payee; Payee)
            {
            }
            column(ClaimNo; ClaimNo)
            {
            }
            column(ChequeNo; ChequeNo)
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEndDate; PeriodEndDate)
            {
            }
            column(PostingDate_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Posting Date")
            {
            }
            column(RemainingAmount_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Remaining Amount")
            {
            }
            column(AmountLCY_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Amount (LCY)")
            {
            }
            column(DateofLoss; DateofLoss)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(Picture);
                NameofInsured := '';
                DateofLoss := 0D;
                Description := '';
                CauseDescription := '';
                ClassName := '';
                PolicyNo := '';
                ChequeNo := '';
                Payee := '';
                IF RecPay.GET("Bank Account Ledger Entry"."Rec and Pay Type") THEN
                    IF RecPay."Insurance Trans Type" <> RecPay."Insurance Trans Type"::"Claim Payment" THEN
                        CurrReport.SKIP;

                "Bank Account Ledger Entry".SETRANGE("Bank Account Ledger Entry"."Document No.", "Bank Account Ledger Entry"."Document No.");
                "Bank Account Ledger Entry".SETRANGE("Bank Account Ledger Entry"."Posting Date", "Bank Account Ledger Entry"."Posting Date");
                "Bank Account Ledger Entry".FINDLAST;
                Payments.SETRANGE(Payments.No, "Bank Account Ledger Entry"."Document No.");
                IF Payments.FINDFIRST THEN BEGIN
                    ChequeNo := Payments."Cheque No";
                    Payee := Payments.Payee;
                END;
                PVLines1.SETRANGE(PVLines1."PV No", "Bank Account Ledger Entry"."Document No.");
                IF PVLines1.FINDFIRST THEN BEGIN

                    GenLedgSetup.GET;
                    BranchCode := PVLines1."Shortcut Dimension 1 Code";
                    IF DimValue.GET(GenLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                        BranchName := DimValue.Name;
                    Claim.SETRANGE(Claim."Claim No", PVLines1."Claim No");
                    IF Claim.FINDFIRST THEN BEGIN
                        NameofInsured := Claim."Name of Insured";
                        DateofLoss := Claim."Date of Occurence";
                        Description := Claim."Loss Type Description";
                        TotalCheqPayments := Claim."Amount Settled";
                        ClaimNo := Claim."Claim No";
                        CauseDescription := Claim."Cause Description";
                        ClassName := Claim."Class Description";
                        PolicyNo := Claim."Policy No";
                    END;
                END;
                "Bank Account Ledger Entry".SETRANGE("Bank Account Ledger Entry"."Document No.");
                "Bank Account Ledger Entry".SETRANGE("Bank Account Ledger Entry"."Posting Date");
            end;

            trigger OnPreDataItem();
            begin
                VerifyDates();
                "Bank Account Ledger Entry".SETRANGE("Bank Account Ledger Entry"."Posting Date", PeriodStartDate, PeriodEndDate);
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
                    field("Starting Date"; PeriodStartDate)
                    {
                        Caption = 'Date';
                    }
                    field("Ending Date"; PeriodEndDate)
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
            PeriodStartDate := WORKDATE;
            PeriodEndDate := WORKDATE;
        end;
    }

    labels
    {
        MonthlyClaimsLbl = 'MONTHLY CLAIMS REGISTER'; ReportTitleLbl = 'CLAIMS PAID';
    }

    var
        CompInfor: Record 79;
        AgentContact: Text;
        Cust: Record Customer;
        ClaimNo: Text;
        PolicyNo: Text;
        DateofLoss: Date;
        Description: Text;
        Claim: Record Claim;
        NameofInsured: Text;
        TotalCheqPayments: Decimal;
        CauseDescription: Text;
        BranchName: Text;
        DimValue: Record "Dimension Value";
        Dimensions: Record 348;
        ClassName: Text;
        Payments: Record Payments1;
        Payee: Text;
        GenLedgSetup: Record "General Ledger Setup";
        InsuranceClass: Record "Insurance Class";
        PolicyType: Integer;
        BranchCode: Code[10];
        PvLines: Record Payments1;
        PVLines1: Record 51511001;
        ChequeNo: Code[10];
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Date value is a future date';
        Insured: Text;
        RecPay: Record 51511002;

    procedure InitializeRequest(StartDate: Date; EndDate: Date);
    begin
        PeriodStartDate := StartDate;
        PeriodEndDate := EndDate;
    end;

    local procedure VerifyDates();
    begin
        IF PeriodStartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF PeriodStartDate > WORKDATE THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;
}

