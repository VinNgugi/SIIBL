page 51513545 "Medical test lines"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Medical test lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Test Code";"Test Code")
                {
                }
                field(Results;Results)
                {
                }
            }
        }
    }

    actions
    {
    }
}

