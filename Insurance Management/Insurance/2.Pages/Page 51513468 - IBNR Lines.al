page 51513468 "IBNR Lines"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "IBNR Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Year Look Up"; "Year Look Up")
                {
                }
                field("Year No."; "Year No.")
                {
                }
                field("Period Comparison"; "Period Comparison")
                {
                }
                field("% Age"; "% Age")
                {
                }
            }
        }
    }

    actions
    {
    }
}

