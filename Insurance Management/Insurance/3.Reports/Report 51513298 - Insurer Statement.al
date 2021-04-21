report 51513298 "Insurer Statement"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Insurer Statement.rdl';

    dataset
    {
        dataitem(DataItem1; Vendor)
        {
            dataitem(DataItem2; "Vendor Ledger Entry")
            {
                dataitem(DataItem3; "Detailed Vendor Ledg. Entry")
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

