page 51513506 "Cover Benefits"
{
    // version AES-INS 1.0

    Editable = true;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Life Benefits";

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
                field("Benefit Type"; "Benefit Type")
                {
                }
            }
        }
    }

    actions
    {
    }
}

