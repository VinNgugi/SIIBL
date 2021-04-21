table 51513004 "Document Setup"
{
    // version AES-INS 1.0

    //DrillDownPageID = 51513445;
    //LookupPageID = 51513445;

    fields
    {
        field(1; "Document Name"; Text[50])
        {
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Document Name")
        {
        }
    }

    fieldgroups
    {
    }
}

