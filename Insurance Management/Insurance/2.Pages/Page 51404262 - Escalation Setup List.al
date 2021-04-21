page 51404262 "Escalation Setup List"
{
    // version AES-PAS 1.0

    Editable = true;
    PageType = Listpart;
    SourceTable = "Interactions Escalation Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Channel No.";"Channel No.")
                {
                    Editable = true;
                }
                field("Channel Name";"Channel Name")
                {
                    Editable = true;
                }
                field("Level Code";"Level Code")
                {
                }
                field("Level Duration - Hours";"Level Duration - Hours")
                {
                }
                field("Level Alert Time";"Level Alert Time")
                {
                }
                field("Distribution E-mail for Level";"Distribution E-mail for Level")
                {
                }
                field("Overall Level Duration Hrs";"Overall Level Duration Hrs")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        recInterChannel.RESET;
        recInterChannel.SETRANGE(recInterChannel."No.","Channel No.");
        IF recInterChannel.FINDFIRST THEN BEGIN
          "Channel Name" := recInterChannel.Description;
        END;
    end;

    var
        //ImportEscalationLevels: XMLport 51404086;
        recInterChannel: Record "Interaction Type";
}

