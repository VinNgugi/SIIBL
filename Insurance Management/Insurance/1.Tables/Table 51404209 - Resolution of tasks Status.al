table 51404209 "Resolution of tasks Status"
{
    // version AES-PAS 1.0


    fields
    {
        field(1;"Resolution Code";Code[20])
        {
            TableRelation = "Client Interaction Header"."Interact Code";
        }
        field(2;IRCode;Code[20])
        {
            TableRelation = "Interaction Resolution"."Cause No.";
        }
        field(3;"Step Number";Integer)
        {
        }
        field(4;"Resolution Description";Text[250])
        {
        }
        field(5;"Resolution Status";Option)
        {
            OptionMembers = Outstanding,Skipped,Completed;
        }
    }

    keys
    {
        key(Key1;"Resolution Code",IRCode,"Step Number")
        {
        }
    }

    fieldgroups
    {
    }
}

