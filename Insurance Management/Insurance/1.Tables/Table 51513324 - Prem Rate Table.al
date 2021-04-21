table 51513324 "Prem Rate Table"
{
    // version AES-INS 1.0


    fields
    {
        field(1;Type;Code[20])
        {
            TableRelation = "Table Types".Type WHERE ("Table Type"=CONST(Premium));
        }
        field(2;Age;Integer)
        {
        }
        field(3;Rate;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;Type)
        {
        }
    }

    fieldgroups
    {
    }
}

