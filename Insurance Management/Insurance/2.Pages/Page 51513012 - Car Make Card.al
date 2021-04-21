page 51513012 "Car Make Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Car Makers";

    layout
    {
        area(content)
        {
            group(General)
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
        area(navigation)
        {
            action(Models)
            {
                RunObject = Page 51513013;
                RunPageLink = "Car Maker" = FIELD(Code);
            }
        }
    }
}

