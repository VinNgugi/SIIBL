table 51511048 "Consolidated Budget"
{
    // version FINANCE


    fields
    {
        field(1; CreationID; Integer)
        {
            AutoIncrement = false;
        }
        field(2; "Commision Approved"; Boolean)
        {
        }
        field(3; "Creation No"; Code[20])
        {
            TableRelation = "Budget Creation"."Creation No";
        }
        field(4; "Budget Name"; Code[30])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(5; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(6; "Date Created"; Date)
        {
        }
        field(7; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "No of Budget Periods"; Option)
        {
            OptionMembers = "1","2","4","12";
        }
        field(9; "G/L Account Name"; Text[250])
        {
        }
        field(10; Description; Text[250])
        {
        }
        field(11; Amount; Decimal)
        {
        }
        field(13; Trasfered; Boolean)
        {
        }
        field(14; Number; Integer)
        {
        }
    }

    keys
    {
        key(Key1; CreationID)
        {
        }
    }

    fieldgroups
    {
    }
}

