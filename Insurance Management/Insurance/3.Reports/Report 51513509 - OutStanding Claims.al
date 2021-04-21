report 51513509 "OutStanding Claims"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/OutStanding Claims.rdl';

    dataset
    {
        dataitem("Policy Type"; "Policy Type")
        {
            RequestFilterFields = "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
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
            column(GrossPremium_PolicyType; "Policy Type"."Gross Premium")
            {
            }
            column(Class_PolicyType; "Policy Type".Class)
            {
            }
            column(DefaultAreaCode_PolicyType; "Policy Type"."Default Area Code")
            {
            }
            column(PremiumCalculation_PolicyType; "Policy Type"."Premium Calculation")
            {
            }
            column(Period_PolicyType; "Policy Type".Period)
            {
            }
            column(ClaimsValidityPeriod_PolicyType; "Policy Type"."Claims Validity Period")
            {
            }
            column(ClaimsPaid_PolicyType; "Policy Type"."Claims Paid")
            {
            }
            column(OutstandingClaims_PolicyType; "Policy Type"."Outstanding Claims")
            {
            }
            column(ClaimsIncurred_PolicyType; "Policy Type"."Claims Incurred")
            {
            }
            column(RetentionOutstanding_PolicyType; "Policy Type"."Retention Outstanding")
            {
            }
            column(Quotashare_PolicyType; "Policy Type"."Quota share")
            {
            }
            column(SurplusShare_PolicyType; "Policy Type"."Surplus Share")
            {
            }
            column(FacultativeShare_PolicyType; "Policy Type"."Facultative Share")
            {
            }
            column(XLoss1_PolicyType; "Policy Type"."X Loss 1")
            {
            }
            column(XLoss2_PolicyType; "Policy Type"."X Loss 2")
            {
            }
            column(XLoss3_PolicyType; "Policy Type"."X Loss 3")
            {
            }
            column(DepartmentCode; DepartmentCode)
            {
            }
            column(ClassDesc; ClassDesc)
            {
            }
            column(NoofClaimsPaid_PolicyType; "Policy Type"."No. of Claims Paid")
            {
            }
            column(KRShare_PolicyType; "Policy Type"."PPL Cost Per PAX")
            {
            }
            column(Description_PolicyType; "Policy Type".Description)
            {
            }
            column(DepartmentName; DepartmentName)
            {
            }
            column(Code_PolicyType; "Policy Type".Code)
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEndDate; PeriodEndDate)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                GenLedgSetup.GET;
                BranchCode := "Policy Type"."Global Dimension 1 Filter";
                IF DimValue.GET(GenLedgSetup."Global Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;
                DepartmentCode := "Policy Type"."Global Dimension 2 Filter";
                IF DimValue.GET(GenLedgSetup."Global Dimension 2 Code", DepartmentCode) THEN
                    DepartmentName := DimValue.Name;
                "Policy Type".CALCFIELDS("Outstanding Claims");
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
        ReportTitle = 'Claims Outstanding Report';
    }

    trigger OnPreReport();
    begin
        "Policy Type".SETRANGE("Policy Type"."Date Filter", PeriodStartDate, PeriodEndDate);
    end;

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
        DepartmentCode: Code[10];
        InsuranceClass: Record "Insurance Class";
        ClassDesc: Text;
        AllFilters: Text;
        BranchCode: Code[10];
        DepartmentName: Text;
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Date value is a future date';
        PeriodStartDate: Date;
        PeriodEndDate: Date;

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

