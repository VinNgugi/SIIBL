page 51513503 "Occupation List"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = Occupation;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Occupation; Occupation)
                {
                }
            }
        }
    }

    actions
    {
    }
}

