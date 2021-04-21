table 51513093 "Claim Decisions"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Action";Option)
        {
            OptionMembers = " ","Assign Garage",Payment,"Issue Claim Reserve";
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

