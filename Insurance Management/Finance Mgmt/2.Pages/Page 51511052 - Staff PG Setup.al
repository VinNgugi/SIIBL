page 51511052 "Staff PG Setup"
{
    // version FINANCE

    PageType = List;
    SourceTable = "Staff PGroups";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field(Type; Type)
                {
                }
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("G/L Account"; "G/L Account")
                {
                }
                field("GL Account Employer"; "GL Account Employer")
                {
                }
            }
        }
    }

    actions
    {
    }
}

