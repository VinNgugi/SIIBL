table 51513320 "Medical Tests"
{

    fields
    {
        field(1;"Treaty Code";Code[30])
        {
        }
        field(2;"Addendum Code";Integer)
        {
        }
        field(5;"Test Code";Code[20])
        {
        }
        field(6;"Test Description";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Treaty Code","Addendum Code","Test Code")
        {
        }
    }

    fieldgroups
    {
    }
}

