table 51513462 "MDP Schedule"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Treaty Code";Code[30])
        {
        }
        field(2;"Treaty Addendum";Integer)
        {
        }
        field(3;"XOL Layer";Code[10])
        {
        }
        field(4;"Instalment Due Date";Date)
        {
        }
        field(5;"Premium Amount";Decimal)
        {
        }
        field(6;Paid;Boolean)
        {
        }
        field(7;"Payment No.";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Treaty Code","Treaty Addendum","XOL Layer","Payment No.")
        {
        }
        key(Key2;"Instalment Due Date")
        {
        }
    }

    fieldgroups
    {
    }
}

