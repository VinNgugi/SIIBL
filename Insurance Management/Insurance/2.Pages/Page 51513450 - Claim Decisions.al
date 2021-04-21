page 51513450 "Claim Decisions"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim Decisions";

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
                field(Action; Action)
                {
                }
            }
        }
    }

    actions
    {
    }
}

