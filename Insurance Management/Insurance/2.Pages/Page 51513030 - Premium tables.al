page 51513030 "Premium tables"
{
    // version AES-INS 1.0

    CardPageID = "Premium table card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Premium Table";

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
                field("Inclusive of Taxes"; "Inclusive of Taxes")
                {
                }
                field("Effective Date"; "Effective Date")
                {
                }
                field("Policy Type"; "Policy Type")
                {
                }
                field("Vehicle Class"; "Vehicle Class")
                {
                }
                field("Vehicle Usage"; "Vehicle Usage")
                {
                }
            }
        }
    }

    actions
    {
    }
}

