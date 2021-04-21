table 51513451 "Online Default Level Two Menu"
{
    // version AES-INS 1.0


    fields
    {
        field(1; LevelTwoActionID; Integer)
        {
            AutoIncrement = true;
        }
        field(2; OrderStep; Option)
        {
            OptionCaption = 'Step 1, Step 2, Step 3, Step 4, Step 5, Step 6, Step 7, Step 8, Step 9, Step 10, Step 11, Step 12';
            OptionMembers = "Step 1"," Step 2"," Step 3"," Step 4"," Step 5"," Step 6"," Step 7"," Step 8"," Step 9"," Step 10"," Step 11"," Step 12";
        }
        field(3; LevelOneActionID; Integer)
        {
            TableRelation = "Online Default Level One Menu".LevelOneActionID;

            trigger OnValidate();
            begin
                IF OnlineDefaultLevelOneMenu.GET(LevelOneActionID) THEN BEGIN
                    DefaultLevelOneActionName := OnlineDefaultLevelOneMenu.DefaultLevelOneActionName;
                END;
            end;
        }
        field(4; DefaultLevelTwoActionName; Text[250])
        {
        }
        field(5; URL; Text[250])
        {
        }
        field(6; IsActive; Boolean)
        {
        }
        field(7; HasAdditional; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(8; LastUpdatedTime; DateTime)
        {
        }
        field(9; DefaultLevelOneActionName; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; LevelTwoActionID)
        {
        }
    }

    fieldgroups
    {
    }

    var
        OnlineDefaultLevelOneMenu: Record "Online Default Level One Menu";
}

