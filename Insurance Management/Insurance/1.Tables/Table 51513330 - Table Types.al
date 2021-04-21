table 51513330 "Table Types"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Table Type";Option)
        {
            OptionCaption = 'Premium,Amount At Risk';
            OptionMembers = Premium,"Amount At Risk";
        }
        field(3;Type;Code[20])
        {
        }
        field(4;Description;Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Table Type")
        {
        }
    }

    fieldgroups
    {
    }
}

