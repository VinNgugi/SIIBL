table 51513018 "Insurance Class"
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
        field(3;"Commission Percentage";Decimal)
        {
        }
        field(4;Type;Option)
        {
            OptionMembers = " ",Asset,Liability;
        }
        field(5;"Treaty Code";Code[20])
        {
            TableRelation = Treaty;
        }
        field(6;"Addendum Code";Integer)
        {
            TableRelation = Treaty."Addendum Code" WHERE ("Treaty Code"=FIELD("Treaty Code"));
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

