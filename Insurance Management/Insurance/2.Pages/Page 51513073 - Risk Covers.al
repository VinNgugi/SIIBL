page 51513073 "Risk Covers"
{
    // version AES-INS 1.0

    CardPageID = "Risk Cover Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Risk Covers";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Policy No."; "Policy No.")
                {
                }
                field("Risk Id"; "Risk Id")
                {
                }
                field("Cover No."; "Cover No.")
                {
                }
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
                {
                }
                field("Substitute Risk ID"; "Substitute Risk ID")
                {
                }
                field(Status; Status)
                {
                }
                field(Select; Select)
                {
                }
            }
        }
    }

    actions
    {
    }
}

