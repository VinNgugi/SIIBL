table 51513029 "Premium Table"
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
        field(3;"Inclusive of Taxes";Boolean)
        {
        }
        field(4;"Effective Date";Date)
        {
        }
        field(5;"Policy Type";Code[20])
        {
            TableRelation = "Policy Type";
        }
        field(6;"Vehicle Class";Code[20])
        {
            TableRelation = "Motor Classification";
        }
        field(7;"Vehicle Usage";Code[20])
        {
            TableRelation = "Vehicle Usage";
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

