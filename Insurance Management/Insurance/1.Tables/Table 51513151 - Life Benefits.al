table 51513151 "Life Benefits"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[50])
        {
        }
        field(3;"Benefit Type";Option)
        {
            OptionCaption = '" ,Main,Rider"';
            OptionMembers = " ",Main,Rider;
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

