page 51513185 "Seating Capacity Setup"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Vehicle Capacity";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Seating Capacity"; "Seating Capacity")
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

