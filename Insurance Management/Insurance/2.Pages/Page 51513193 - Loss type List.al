page 51513193 "Loss Type List"
{
    // version AES-INS 1.0

    Editable = true;
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
                RunObject = Page "Loss Type Stages";
                RunPageLink = "Loss Type" = FIELD(Code);
            }
        }
    }
}

