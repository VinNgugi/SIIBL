table 51513159 "Tax Table Lines"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Table Code";Code[20])
        {
            TableRelation = "Premium Tables";
        }
        field(2;"Band No";Integer)
        {
        }
        field(3;"Lower Limit";Decimal)
        {
        }
        field(4;"Upper Limit";Decimal)
        {
        }
        field(5;"Tax Amount";Decimal)
        {
        }
        field(6;"% age";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Table Code","Band No")
        {
        }
    }

    fieldgroups
    {
    }
}

