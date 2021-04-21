page 51513196 "Vehicle Routes"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Vehicle Routes";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Distance (Km)"; "Distance (Km)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

