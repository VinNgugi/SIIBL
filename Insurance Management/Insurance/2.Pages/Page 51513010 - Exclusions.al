page 51513010 Exclusions
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Policy Details";
    SourceTableView = WHERE("Description Type" = CONST(Exclusions));

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

