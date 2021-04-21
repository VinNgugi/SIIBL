page 51513009 "Geographical Details"
{
    // version AES-INS 1.0

    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Policy Details";
    SourceTableView = WHERE("Description Type" = CONST(Geographic));

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

