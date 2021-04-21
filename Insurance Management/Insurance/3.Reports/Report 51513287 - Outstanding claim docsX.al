report 51513287 "Outstanding claim docsX"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Outstanding claim docsX.rdl';

    dataset
    {
        dataitem("Claim"; "Claim")
        {
            RequestFilterFields = "Claim No";
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
            column(Class_Claim; Claim.Class)
            {
            }
            column(Insured_Claim; Claim.Insured)
            {
            }
            column(NameofInsured_Claim; Claim."Name of Insured")
            {
            }
            column(Detailsofdamage_Claim; Claim."Details of damage")
            {
            }
            column(ClaimNo_Claim; Claim."Claim No")
            {
            }
            column(DateofOccurence_Claim; Claim."Date of Occurence")
            {
            }
            column(PolicyNo_Claim; Claim."Policy No")
            {
            }
            dataitem("Insurance Documents"; "Insurance Documents")
            {
                column(Status_InsuranceDocuments; "Insurance Documents".Status)
                {
                }
                column(Received_InsuranceDocuments; "Insurance Documents".Received)
                {
                }
                column(Comment_InsuranceDocuments; "Insurance Documents".Comment)
                {
                }
                column(DocumentType_InsuranceDocuments; "Insurance Documents"."Document Type")
                {
                }
                column(DocumentName_InsuranceDocuments; "Insurance Documents"."Document Name")
                {
                }
                column(DateRequired_InsuranceDocuments; "Insurance Documents"."Date Required")
                {
                }
                column(DateReceived_InsuranceDocuments; "Insurance Documents"."Date Received")
                {
                }
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

