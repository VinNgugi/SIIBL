report 51513502 "Loss Ratios"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Loss Ratios.rdl';

    dataset
    {
        dataitem("Policy Type"; "Policy Type")
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
            column(CEmails; CompInfor."E-Mail")
            {
            }
            column(CWeb; CompInfor."Home Page")
            {
            }
            column(CFaxno; CompInfor."Fax No.")
            {
            }
            column(Code_PolicyType; "Policy Type".Code)
            {
            }
            column(Description_PolicyType; "Policy Type".Description)
            {
            }
            column(Class_PolicyType; "Policy Type".Class)
            {
            }
            column(AccountNo_PolicyType; "Policy Type"."Account No")
            {
            }
            column(CommissionAmount_PolicyType; "Policy Type"."Commission Amount")
            {
            }
            column(Type_PolicyType; "Policy Type".Type)
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
            column(GrossPremium_PolicyType; "Policy Type"."Gross Premium")
            {
            }
            column(shortcode_PolicyType; "Policy Type"."short code")
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(ClassDesc; ClassDesc)
            {
            }
            column(BranchCode; BranchCode)
            {
            }
            column(DepartmentName; DepartmentName)
            {
            }

            trigger OnAfterGetRecord();
            begin

                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                "Policy Type".CALCFIELDS("Claims Paid", "Outstanding Claims", "Gross Premium");
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
        ClaimsByBranchLbl = 'CLAIMS EXPERIENCE PER BRANCH'; LossRatioTitle = 'LOSS RATIOS';
    }

    trigger OnPreReport();
    begin
        GenLedgSetup.GET;

        AllFilters := "Policy Type".GETFILTERS;
        BranchCode := "Policy Type".GETRANGEMIN("Policy Type"."Global Dimension 1 Filter");
        IF DimValue.GET(GenLedgSetup."Global Dimension 1 Code", BranchCode) THEN
            BranchName := DimValue.Name;

        DepartmentCode := "Policy Type".GETRANGEMIN("Policy Type"."Global Dimension 2 Filter");
        IF DimValue.GET(GenLedgSetup."Global Dimension 2 Code", DepartmentCode) THEN
            DepartmentName := DimValue.Name;
    end;

    var
        CompInfor: Record 79;
        GenLedgSetup: Record "General Ledger Setup";
        BranchName: Text;
        DimValue: Record "Dimension Value";
        InsuranceClass: Record "Insurance Class";
        ClassDesc: Text;
        BranchCode: Code[10];
        AllFilters: Text;
        DepartmentCode: Code[10];
        DepartmentName: Text;
}

