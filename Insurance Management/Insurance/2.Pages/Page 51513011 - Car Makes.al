page 51513011 "Car Makes"
{
    // version AES-INS 1.0

    CardPageID = "Car Make Card";
    PageType = List;
    SourceTable = "Car Makers";
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
        area(navigation)
        {
            action("Car Models")
            {
                RunObject = Page 51513013;
                RunPageLink = "Car Maker" = FIELD(Code);
            }
        }
    }
}

