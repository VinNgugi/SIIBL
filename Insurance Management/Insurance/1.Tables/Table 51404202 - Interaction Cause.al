table 51404202 "Interaction Cause"
{
    // version AES-PAS 1.0

   DrillDownPageID = 51404257;
    LookupPageID = 51404257;

    fields
    {
        field(1;"No.";Code[10])
        {
        }
        field(2;"Interaction No.";Code[10])
        {
            TableRelation = "Interaction Type";
        }
        field(3;Description;Text[200])
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }
}

