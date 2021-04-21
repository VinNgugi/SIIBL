page 51513458 "Online Default Menu Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Online Default Menu";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(DefaultMenuName; DefaultMenuName)
                {
                }
                field(AccountTypeID; AccountTypeID)
                {
                }
                field(AccountTypeName; AccountTypeName)
                {
                    Editable = false;
                }
                field(OrderStep; OrderStep)
                {
                }
                field(URL; URL)
                {
                }
                field(IsActive; IsActive)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Level One Sub Menu")
            {
                RunObject = Page 51513459;
            }
        }
    }
}

