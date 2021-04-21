table 51404208 "Resolution Steps"
{
    // version AES-PAS 1.0


    fields
    {
        field(1;IRCode;Code[20])
        {
            TableRelation = "Interaction Resolution"."No.";
        }
        field(2;"Step Number";Integer)
        {
        }
        field(3;"Resolution Description";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;IRCode,"Step Number")
        {
        }
    }

    fieldgroups
    {
    }
}

