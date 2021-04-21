page 51513457 "Online Default Menu List"
{
    // version AES-INS 1.0

    CardPageID = "Online Default Menu Card";
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Online Default Menu";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DefaultMenuName; DefaultMenuName)
                {
                }
                field(AccountTypeID; AccountTypeID)
                {
                }
                field(AccountTypeName; AccountTypeName)
                {
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
                field(ProfileID; ProfileID)
                {
                }
                field(LastUpdatedTime; LastUpdatedTime)
                {
                }
            }
        }
    }

    actions
    {
    }
}

