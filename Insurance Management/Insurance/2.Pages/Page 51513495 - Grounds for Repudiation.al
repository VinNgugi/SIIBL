page 51513495 "Grounds for Repudiation"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Denial Reasons";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Reason Code"; "Reason Code")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

