table 51513449 "Online Default Menu"
{
    // version AES-INS 1.0


    fields
    {
        field(1; DefaultMenuID; Integer)
        {
            AutoIncrement = true;
        }
        field(2; DefaultMenuName; Text[30])
        {
        }
        field(3; AccountTypeID; Integer)
        {
            TableRelation = "Online AccountTypes".AccountTypeID;

            trigger OnValidate();
            begin
                IF AccType.GET(AccountTypeID) THEN BEGIN
                    AccountTypeName := AccType.AccountTypeName;
                END;
            end;
        }
        field(4; OrderStep; Option)
        {
            OptionCaption = 'Step 1, Step 2, Step 3, Step 4, Step 5, Step 6, Step 7, Step 8, Step 9, Step 10, Step 11, Step 12';
            OptionMembers = "Step 1"," Step 2"," Step 3"," Step 4"," Step 5"," Step 6"," Step 7"," Step 8"," Step 9"," Step 10"," Step 11"," Step 12";
        }
        field(5; URL; Text[250])
        {
        }
        field(6; IsActive; Boolean)
        {
        }
        field(7; ProfileID; Integer)
        {
        }
        field(8; LastUpdatedTime; DateTime)
        {
        }
        field(9; AccountTypeName; Text[30])
        {
        }
        field(10; HasAdditional; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
    }

    keys
    {
        key(Key1; DefaultMenuID)
        {
        }
    }

    fieldgroups
    {
    }

    var
        AccType: Record "Online AccountTypes";
}

