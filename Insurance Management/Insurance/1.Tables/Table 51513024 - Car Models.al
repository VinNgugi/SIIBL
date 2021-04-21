table 51513024 "Car Models"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Car Maker";Code[20])
        {
            TableRelation = "Car Makers";
        }
        field(2;Model;Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Car Maker",Model)
        {
        }
    }

    fieldgroups
    {
    }
}

