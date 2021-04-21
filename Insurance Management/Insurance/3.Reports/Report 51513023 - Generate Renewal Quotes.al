report 51513023 "Generate Renewal Quotes"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Generate Renewal Quotes.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST(Policy));
            RequestFilterFields = "Expected Renewal Date", "Agent/Broker";
            column(InsuredNo; "Insure Header"."Insured No.")
            {
            }
            column(InsuredName; "Insure Header"."Insured Name")
            {
            }
            column(PolicyNo; "Insure Header"."Policy No")
            {
            }
            column(fromDate; "Insure Header"."From Date")
            {
            }
            column(toDate; "Insure Header"."To Date")
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
}

