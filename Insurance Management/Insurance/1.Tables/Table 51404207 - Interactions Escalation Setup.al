table 51404207 "Interactions Escalation Setup"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New table created for Escalation Setup.

    DrillDownPageID = 51404262;
    LookupPageID = 51404262;

    fields
    {
        field(2;"Channel No.";Code[20])
        {
            Editable = true;
            TableRelation = "Interaction Type"."No.";

            trigger OnValidate()
            begin

                recInterChannel.RESET;
                recInterChannel.SETRANGE(recInterChannel."No.",rec."Channel No.");
                IF recInterChannel.FINDFIRST THEN BEGIN
                  "Channel Name" := recInterChannel.Description;
                END;
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
            NotBlank = true;
        }
        field(12;"Distribution E-mail for Level";Text[100])
        {
        }
        field(30;"Level Alert Time";Time)
        {
        }
        field(31;"Overall Level Duration Hrs";Integer)
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

    trigger OnInsert()
    begin
         IF "Level Code" ='' THEN
         DELETE
    end;

    var
        recInterChannel: Record "Interaction Type";
}

