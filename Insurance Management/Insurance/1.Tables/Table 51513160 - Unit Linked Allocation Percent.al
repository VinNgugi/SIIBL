table 51513160 "Unit Linked Allocation Percent"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Table Code";Code[20])
        {
            TableRelation = "Premium Tables";
        }
        field(2;"Term Code";Code[20])
        {
            TableRelation = Term;
        }
        field(3;"Allocation %";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Table Code")
        {
        }
    }

    fieldgroups
    {
    }
}

