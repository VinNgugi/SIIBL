page 51513034 "Vehicle Usage"
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Vehicle Usage";
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

