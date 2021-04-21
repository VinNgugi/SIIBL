page 51513232 "Loss Type per Cover"
{
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Product Loss Type";

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
                field("Minimum Reserve"; "Minimum Reserve")
                {
                }
                field("Reserve calculation type"; "Reserve calculation type")
                {
                }
                field(Percentage; Percentage)
                {
                }
                field(Type; Type)
                {
                }
                field("Excess Required"; "Excess Required")
                {
                }
            }
        }
    }

    actions
    {
    }
}

