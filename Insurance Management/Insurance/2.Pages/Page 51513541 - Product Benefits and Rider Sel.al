page 51513541 "Product Benefits and Rider Sel"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Header Cover Selection";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Selected; Selected)
                {
                }
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Discount %"; "Discount %")
                {
                }
                field("Loading %"; "Loading %")
                {
                }
                field("Loading Amount"; "Loading Amount")
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

