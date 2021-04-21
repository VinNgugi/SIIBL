page 51513459 "Online Default Level One Menu"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Online Default Level One Menu";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LevelOneActionID; LevelOneActionID)
                {
                }
                field(OrderStep; OrderStep)
                {
                }
                field(DefaultMenuID; DefaultMenuID)
                {
                }
                field(DefaultMenuName; DefaultMenuName)
                {
                    Editable = false;
                }
                field(DefaultLevelOneActionName; DefaultLevelOneActionName)
                {
                }
                field(URL; URL)
                {
                }
                field(IsActive; IsActive)
                {
                }
                field(HasAdditional; HasAdditional)
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
        area(navigation)
        {
            action("Level Two Sub Links")
            {
                RunObject = Page 51513460;
                RunPageLink = LevelOneActionID = FIELD(DefaultMenuID);
            }
        }
    }
}

