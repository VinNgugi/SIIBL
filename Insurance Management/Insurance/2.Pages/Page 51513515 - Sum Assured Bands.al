page 51513515 "Sum Assured Bands"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "SA Band";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SA Band Code"; "SA Band Code")
                {
                }
                field("SA Lower Limit"; "SA Lower Limit")
                {
                }
                field("SA Upper Limit"; "SA Upper Limit")
                {
                }
            }
        }
    }

    actions
    {
    }
}

