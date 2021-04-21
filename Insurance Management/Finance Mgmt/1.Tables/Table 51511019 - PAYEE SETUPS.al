table 51511019 "PAYEE SETUPS"
{
    // version FINANCE

    //DrillDownPageID = 51511956;
    //LookupPageID = 51511956;

    fields
    {
        field(1;No;Code[10])
        {
        }
        field(2;PAYEE;Decimal)
        {
        }
        field(3;Description;Text[30])
        {
        }
        field(4;"G/L Account";Code[10])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1;No)
        {
        }
    }

    fieldgroups
    {
    }
}

