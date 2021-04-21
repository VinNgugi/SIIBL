page 51513022 "Optional Benefits"
{
    // version AES-INS 1.0

    Caption='Benefits setup';

    PageType = List;
    SourceTable = "Optional Covers";
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
                field(Type; Type)
                {
                }
                field("Free Limit Value"; "Free Limit Value")
                {
                }
                field("Calculation Method"; "Calculation Method")
                {
                }
                field("Rate Type"; "Rate Type")
                {
                }
                field(Rate; Rate)
                {
                }
                field("Premium Table Link"; "Premium Table Link")
                {
                }
                field("Loading Amount"; "Loading Amount")
                {
                }
                field("Discount Amount"; "Discount Amount")
                {
                }
                field("Medical Per Person"; "Medical Per Person")
                {
                }
                field("Yellow Card"; "Yellow Card")
                {
                }
            }
        }
    }

    actions
    {
    }
}

