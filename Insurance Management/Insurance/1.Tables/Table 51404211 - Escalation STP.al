table 51404211 "Escalation STP"
{
    // version AES-PAS 1.0


    fields
    {
        field(2;"Channel No.";Code[20])
        {
            Editable = true;

            trigger OnValidate()
            begin

                //recInterChannel.RESET;
                //recInterChannel.SETRANGE(recInterChannel.Code,"Channel No.");
                //IF recInterChannel.FINDFIRST THEN BEGIN
                //  "Channel Name" := recInterChannel.Description;
                //END;
            end;
        }
        field(3;"Channel Name";Text[100])
        {
            Editable = false;
        }
        field(4;"Level Code";Code[10])
        {
        }
        field(5;"Level Duration - Hours";Integer)
        {
        }
        field(12;"Distribution E-mail for Level";Text[100])
        {
        }
        field(30;"Level Alert Time";Time)
        {
        }
    }

    keys
    {
        key(Key1;"Channel No.","Level Code")
        {
        }
    }

    fieldgroups
    {
    }
}

