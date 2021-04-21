table 51513055 "Area List"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;"Area Description";Text[30])
        {
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

