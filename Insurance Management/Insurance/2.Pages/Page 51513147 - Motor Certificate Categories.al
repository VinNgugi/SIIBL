page 51513147 "Motor Certificate Categories"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Motor Cetificate Categories";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Type code"; "Type code")
                {
                }
                field("Type Name"; "Type Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

