page 51513210 "Countries Visited"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Countries Visited";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Country Code"; "Country Code")
                {
                }
                field("Country Name"; "Country Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

