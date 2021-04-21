page 51513444 "Documents Required"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Documents Required";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Type"; "Transaction Type")
                {
                }
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Document Name"; "Document Name")
                {
                }
                field(Mandatory; Mandatory)
                {
                }
            }
        }
    }

    actions
    {
    }
}

