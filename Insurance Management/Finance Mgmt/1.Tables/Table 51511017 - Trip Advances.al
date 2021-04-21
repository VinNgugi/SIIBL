table 51511017 "Trip Advances"
{
    // version FINANCE


    fields
    {
        field(1;"Job Group";Code[10])
        {
           // TableRelation = "Salary Scales";
        }
        field(2;Country;Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(3;City;Code[10])
        {
            TableRelation = "Post Code";
        }
        field(4;"Advance Code";Code[10])
        {
            TableRelation = "Trip Advances Setup";
        }
        field(5;"Effective Date";Date)
        {
        }
        field(6;Amount;Decimal)
        {
        }
        field(7;"Currency Code";Code[10])
        {
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1;"Job Group",Country,City,"Advance Code")
        {
        }
    }

    fieldgroups
    {
    }
}

