page 51513226 "Case Stage List"
{
    // version AES-INS 1.0

    CardPageID = "Case Stage Card";
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Case Stages";

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

