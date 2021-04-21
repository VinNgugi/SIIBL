table 51511029 "Trip Advances Setup"
{
    // version FINANCE

    DrillDownPageID = 51511019;
    LookupPageID = 51511019;

    fields
    {
        field(1;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[50])
        {
        }
        field(3;"Mapped Account";Code[20])
        {
            TableRelation = "G/L Account";
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

