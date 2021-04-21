page 51513212 "Agent Class Portfolio"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Premium by Agent and Class";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Class Code"; "Class Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Premium Written"; "Premium Written")
                {
                }
            }
        }
    }

    actions
    {
    }
}

