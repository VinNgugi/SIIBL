report 51513281 "Policy List"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Policy List.rdl';

    dataset
    {
        dataitem("Policy Details"; "Policy Details")
        {
            RequestFilterFields = "Policy Type";
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
            column(PolicyType_PolicyDetails; "Policy Details"."Policy Type")
            {
            }
            column(DescriptionType_PolicyDetails; "Policy Details"."Description Type")
            {
            }
            column(No_PolicyDetails; "Policy Details"."No.")
            {
            }
            column(LineNo_PolicyDetails; "Policy Details"."Line No")
            {
            }
            column(Description_PolicyDetails; "Policy Details".Description)
            {
            }
            column(Section_PolicyDetails; "Policy Details".Section)
            {
            }
            column(ActualValue_PolicyDetails; "Policy Details"."Actual Value")
            {
            }
            column(Value_PolicyDetails; "Policy Details".Value)
            {
            }
            column(TextType_PolicyDetails; "Policy Details"."Text Type")
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

