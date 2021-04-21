table 51511016 "Work Plans"
{
    // version FINANCE


    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            var
                GLAcc: Record "G/L Account";
                BusUnit: Record "Business Unit";
                Item: Record Item;
                Location: Record Location;
            begin
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(50000; "Total Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

