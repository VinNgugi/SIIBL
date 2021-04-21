table 51513470 "Legal Witnesses"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Case No.";Code[20])
        {
        }
        field(2;"Legal Stage";Code[20])
        {
        }
        field(3;"Event date";Date)
        {
        }
        field(4;"Witness ID";Code[20])
        {
        }
        field(5;"Witness Name";Text[30])
        {
        }
        field(6;Required;Boolean)
        {
        }
        field(7;Attended;Boolean)
        {
        }
        field(8;"Summons Required";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Case No.","Legal Stage","Event date","Witness ID")
        {
        }
    }

    fieldgroups
    {
    }
}

