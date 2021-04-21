page 51513002 "Cover Details"
{
    // version AES-INS 1.0

    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Policy Details";
    SourceTableView = WHERE("Description Type" = CONST(Cover));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Text Type"; "Text Type")
                {
                }
                field(Description; Description)
                {
                }
                field("Actual Value"; "Actual Value")
                {
                }
                field(Value; Value)
                {
                }
            }
        }
    }

    actions
    {
    }
}

