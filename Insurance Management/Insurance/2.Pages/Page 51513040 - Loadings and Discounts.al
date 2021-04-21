page 51513040 "Loadings and Discounts"
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Insure Header Loading_Discount";
    UsageCategory=Lists;

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
                field("Discount %"; "Discount %")
                {
                }
                field("Loading %"; "Loading %")
                {
                }
                field("Discount Amount"; "Discount Amount")
                {
                }
                field("Loading Amount"; "Loading Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

