page 51513223 "User Group Approval Limits"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "User Group Approval Limits";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Workflow Code"; "Workflow Code")
                {
                }
                field("Approval Amount Limit"; "Approval Amount Limit")
                {
                }
                field("Rate Discount % Limit"; "Rate Discount % Limit")
                {
                }
                field("TPO Premium Discount % Limit"; "TPO Premium Discount % Limit")
                {
                }
            }
        }
    }

    actions
    {
    }
}

