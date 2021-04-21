page 51513119 "Credit Limit Non Edit"
{
    // version AES-INS 1.0

    Editable = true;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Credit Limit Branch Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Branch Name"; "Branch Name")
                {
                }
                field("Effective Date"; "Effective Date")
                {
                }
                field(Percentage; Percentage)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Applied Credit Amount"; "Applied Credit Amount")
                {
                }
                field("Approved Credit Amount"; "Approved Credit Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

