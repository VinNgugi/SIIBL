page 51513003 "Interest Details"
{
    // version AES-INS 1.0

    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Policy Details";
    SourceTableView = WHERE("Description Type" = CONST(Interest));

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

