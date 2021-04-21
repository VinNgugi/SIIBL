page 51513443 "Loss Type Stages"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Loss type stages";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Claim Stage"; "Claim Stage")
                {
                }
                field("Stage Description"; "Stage Description")
                {
                }
                field(Sequence; Sequence)
                {
                }
            }
        }
    }

    actions
    {
    }
}

