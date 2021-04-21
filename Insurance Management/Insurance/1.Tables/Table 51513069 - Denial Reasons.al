table 51513069 "Denial Reasons"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513495;
    LookupPageID = 51513495;

    fields
    {
        field(1;"Reason Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[130])
        {
        }
    }

    keys
    {
        key(Key1;"Reason Code")
        {
        }
    }

    fieldgroups
    {
    }
}

