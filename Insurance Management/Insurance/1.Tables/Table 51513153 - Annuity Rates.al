table 51513153 "Annuity Rates"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Guarantee Years";Integer)
        {
        }
        field(2;Interest;Decimal)
        {
        }
        field(3;"Retire Age";Integer)
        {
        }
        field(4;"Male Rate";Decimal)
        {
        }
        field(5;"Female Rate";Decimal)
        {
        }
        field(6;Denominator;Decimal)
        {
        }
        field(7;TableCode;Code[20])
        {
            TableRelation="Premium Table";
        }
    }

    keys
    {
        key(Key1;"Guarantee Years",TableCode)
        {
        }
    }

    fieldgroups
    {
    }
}

