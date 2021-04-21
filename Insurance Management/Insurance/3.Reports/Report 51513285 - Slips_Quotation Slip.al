report 51513285 "Slips_Quotation Slip"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Slips_Quotation Slip.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            column(DocumentType_InsureHeader; "Insure Header"."Document Type")
            {
            }
            column(No_InsureHeader; "Insure Header"."No.")
            {
            }
            column(InsuredNo_InsureHeader; "Insure Header"."Insured No.")
            {
            }
            dataitem("Insure Lines"; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(DocumentType_InsureLines; "Insure Lines"."Document Type")
                {
                }
                column(DocumentNo_InsureLines; "Insure Lines"."Document No.")
                {
                }
                column(RiskID_InsureLines; "Insure Lines"."Risk ID")
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
}

