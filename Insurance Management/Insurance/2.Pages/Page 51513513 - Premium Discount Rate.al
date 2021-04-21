page 51513513 "Premium Discount Rate"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Premium Discount Rate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SA Lower Limit"; "SA Lower Limit")
                {
                }
                field("SA Upper Limit"; "SA Upper Limit")
                {
                }
                field("Discount (Rate Reduction Amt)"; "Discount (Rate Reduction Amt)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

