page 51513180 "Reinsurance Loadings"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Reinsurance Treaty Loadings";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loading_Discount Code"; "Loading_Discount Code")
                {
                }
                field(Type; Type)
                {
                }
                field("Loading Amount"; "Loading Amount")
                {
                }
                field("Loading Percentage"; "Loading Percentage")
                {
                }
                field("Discount Amount"; "Discount Amount")
                {
                }
                field("Discount Percentage"; "Discount Percentage")
                {
                }
                field("Calculation Method"; "Calculation Method")
                {
                }
                field("Applicable to"; "Applicable to")
                {
                }
                field("Option Applicable to"; "Option Applicable to")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field(Tax; Tax)
                {
                }
            }
        }
    }

    actions
    {
    }
}

