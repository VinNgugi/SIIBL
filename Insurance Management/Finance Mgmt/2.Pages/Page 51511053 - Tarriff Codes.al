page 51511053 "Tarriff Codes"
{
    // version FINANCE

    PageType = List;
    SourceTable = "Tarriff Codes";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Percentage; Percentage)
                {
                }
                field("G/L Account"; "G/L Account")
                {
                }
            }
        }
    }

    actions
    {
    }
}

