table 51404206 "Interaction Channel"
{
    // version AES-PAS 1.0

    DrillDownPageID = 51404260;
    LookupPageID = 51404260;

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[100])
        {
        }
        field(3;"Day Start Time";Time)
        {
        }
        field(4;"Day End Time";Time)
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

