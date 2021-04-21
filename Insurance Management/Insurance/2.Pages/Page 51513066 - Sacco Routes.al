page 51513066 "Sacco Routes"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "SACCO Routes";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Route ID"; "Route ID")
                {
                }
                field("Route Name"; "Route Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

