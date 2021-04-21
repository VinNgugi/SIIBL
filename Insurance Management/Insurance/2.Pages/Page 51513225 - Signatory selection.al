page 51513225 "Signatory selection"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Payment Signatories selection";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Signatory Name"; "Signatory Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

