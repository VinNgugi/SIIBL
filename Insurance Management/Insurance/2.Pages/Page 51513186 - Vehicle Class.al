page 51513186 "Vehicle Class"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Motor Classification";

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

