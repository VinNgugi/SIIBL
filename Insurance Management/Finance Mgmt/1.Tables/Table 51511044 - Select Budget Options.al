table 51511044 "Select Budget Options"
{
    // version FINANCE


    fields
    {
        field(1;"Budget Name";Code[20])
        {
            TableRelation = "G/L Budget Name";
        }
        field(2;Department;Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('DEPARTMENT'));
        }
    }

    keys
    {
        key(Key1;Department)
        {
        }
    }

    fieldgroups
    {
    }
}

