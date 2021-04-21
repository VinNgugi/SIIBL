page 51513014 "Vehicle Body Type"
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Vehicle Body Type";
    UsageCategory=Lists;

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

