page 51513207 "Asset Status"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Asset Status";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

