report 51513027 "Quote Listing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Quote Listing.rdl';
    dataset
    {
        dataitem(InsureHeader; "Insure Header")
        {
            column(DocumentType; "Document Type")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(ContactNo; "Contact No.")
            {
            }
            column(ContactName; "Contact Name")
            {
            }
            column(Underwriter; Underwriter)
            {
            }
            column(UnderwriterName; "Underwriter Name")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
