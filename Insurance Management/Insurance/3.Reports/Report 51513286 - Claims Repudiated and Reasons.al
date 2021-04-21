report 51513286 "Claims Repudiated and Reasons"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Claims Repudiated and Reasons.rdl';

    dataset
    {
        dataitem("Claim"; "Claim")
        {
            PrintOnlyIfDetail = false;
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
            column(ClaimType_Claim; Claim."Claim Type")
            {
            }
            column(CurrentStatus_Claim; Claim."Current Status")
            {
            }
            column(InsurersClaimNo_Claim; Claim."Insurer's Claim No.")
            {
            }
            column(ClaimAmount_Claim; Claim."Claim Amount")
            {
            }
            column(ClaimStatus_Claim; Claim."Claim Status")
            {
            }
            column(CoInsurers_Claim; Claim."Co-Insurers")
            {
            }
            column(CoInsurerName_Claim; Claim."Co- Insurer Name")
            {
            }
            column(GrossAmount_Claim; Claim."Premium Balance")
            {
            }
            column(ClassDescription_Claim; Claim."Class Description")
            {
            }
            column(Class_Claim; Claim.Class)
            {
            }
            column(NameofInsured_Claim; Claim."Name of Insured")
            {
            }
            column(Detailsofdamage_Claim; Claim."Details of damage")
            {
            }
            column(ExcessAmount_Claim; Claim."Excess Amount")
            {
            }
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
}

