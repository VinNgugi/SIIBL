table 51513131 "Case Witnesses"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Case No.";Code[30])
        {
            TableRelation = Litigations;
        }
        field(2;"Stage Code";Code[20])
        {
        }
        field(3;"Witness ID/Passport";Code[20])
        {
        }
        field(4;"Witness Required";Text[80])
        {
        }
        field(5;"Witness Available";Text[80])
        {
        }
        field(6;"Witness summons Required";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Case No.","Stage Code")
        {
        }
    }

    fieldgroups
    {
    }
}

