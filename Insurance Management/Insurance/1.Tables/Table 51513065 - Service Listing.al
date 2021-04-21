table 51513065 "Service Listing"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"service code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[130])
        {
        }
    }

    keys
    {
        key(Key1;"service code")
        {
        }
    }

    fieldgroups
    {
    }
}

