page 51513181 "Loss Type Setup"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Loss Type";

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
                field("Reserve calculation type"; "Reserve calculation type")
                {
                }
                field("Minimum Reserve"; "Minimum Reserve")
                {
                }
                field(Percentage; Percentage)
                {
                }
                field(Type; Type)
                {
                }
                field("Excess Required"; "Excess Required")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Stages)
            {
                RunObject = Page 51513443;
                RunPageLink = "Loss Type" = FIELD(Code);
            }
        }
    }
}

