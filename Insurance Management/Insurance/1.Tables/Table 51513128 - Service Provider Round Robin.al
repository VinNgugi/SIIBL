table 51513128 "Service Provider Round Robin"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Service Provider";Code[20])
        {
        }
        field(2;Round;Integer)
        {
        }
        field(3;"Service Provider Type";Option)
        {
            OptionMembers = " ",Assessor,Lawyer,Garage;
        }
    }

    keys
    {
        key(Key1;"Service Provider",Round,"Service Provider Type")
        {
        }
    }

    fieldgroups
    {
    }
}

