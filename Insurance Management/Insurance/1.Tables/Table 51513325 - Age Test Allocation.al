table 51513325 "Age Test Allocation"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Treaty Code";Code[30])
        {
        }
        field(2;"Addendum Code";Integer)
        {
        }
        field(3;"Lower Limit";Decimal)
        {
        }
        field(4;"Upper Limit";Decimal)
        {
        }
        field(5;"Age Lower Limit";Integer)
        {
        }
        field(6;"Test Code";Code[30])
        {
            TableRelation = "Medical Tests"."Test Code" WHERE ("Treaty Code"=FIELD("Treaty Code"),
                                                               "Addendum Code"=FIELD("Addendum Code"));
        }
        field(7;"Age Upper Limit";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Treaty Code")
        {
        }
    }

    fieldgroups
    {
    }
}

