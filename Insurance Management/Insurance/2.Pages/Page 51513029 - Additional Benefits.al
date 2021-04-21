page 51513029 "Additional Benefits"
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Additional Benefits";
    UsageCategory=Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Risk ID"; "Risk ID")
                {
                }
                field("Option ID"; "Option ID")
                {
                }
                field(Description; Description)
                {
                }
                field("Sum Insured"; "Sum Insured")
                {
                }
                field("Free Limit"; "Free Limit")
                {
                }
                field("Additional Cover Required"; "Additional Cover Required")
                {
                }
                field("Rate %"; "Rate %")
                {
                }
                field(Premium; Premium)
                {
                }
                field("Loading Amount"; "Loading Amount")
                {
                }
                field("Discount Amount"; "Discount Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

