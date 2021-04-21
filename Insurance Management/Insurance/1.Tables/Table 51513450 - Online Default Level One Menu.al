table 51513450 "Online Default Level One Menu"
{
    // version AES-INS 1.0


    fields
    {
        field(1; LevelOneActionID; Integer)
        {
            AutoIncrement = true;
        }
        field(2; OrderStep; Option)
        {
            OptionCaption = 'Step 1, Step 2, Step 3, Step 4, Step 5, Step 6, Step 7, Step 8, Step 9, Step 10, Step 11, Step 12';
            OptionMembers = "Step 1"," Step 2"," Step 3"," Step 4"," Step 5"," Step 6"," Step 7"," Step 8"," Step 9"," Step 10"," Step 11"," Step 12";
        }
        field(3; DefaultMenuID; Integer)
        {
            TableRelation = "Online Default Menu".DefaultMenuID;

            trigger OnValidate();
            begin
                IF DefaulMenu.GET(DefaultMenuID) THEN BEGIN
                    DefaultMenuName := DefaulMenu.DefaultMenuName;
                END;
            end;
        }
        field(4; DefaultLevelOneActionName; Text[30])
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
        field(9; DefaultMenuName; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; LevelOneActionID)
        {
        }
    }

    fieldgroups
    {
    }

    var
        DefaulMenu: Record "Online Default Menu";
}

