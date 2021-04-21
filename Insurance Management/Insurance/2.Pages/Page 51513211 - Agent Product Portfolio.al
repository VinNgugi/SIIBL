page 51513211 "Agent Product Portfolio"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Premium by Agent and Product";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Policy Type"; "Policy Type")
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

