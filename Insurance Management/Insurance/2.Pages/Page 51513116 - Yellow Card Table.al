page 51513116 "Yellow Card Table"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Yellow Card Tables";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Of Months"; "No. Of Months")
                {
                }
                field("% of Annual Premium"; "% of Annual Premium")
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
    }
}

