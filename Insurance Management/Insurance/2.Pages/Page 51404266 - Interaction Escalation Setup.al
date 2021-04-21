page 51404266 "Interaction Escalation Setup"
{
    // version AES-PAS 1.0

    //  //

    Editable = true;
    PageType = Card;
    SourceTable = "Interaction Type";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Interaction Type"; "Interaction Type")
                {
                }
                field("Day Start Time"; "Day Start Time")
                {
                }
                field("Day End Time"; "Day End Time")
                {
                }
            }
            part("Escalation Setuup"; "Escalation Setup List")
            {
                SubPageLink = "Channel No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Escalation Levels")
            {
                Caption = 'Import Escalation Levels';

                trigger OnAction()
                begin
                    ImportEscalationLevels.RUN;
                end;
            }
            action("Modify Escalation Levels")
            {
                Caption = 'Modify Escalation Levels';

                trigger OnAction()
                begin

                    ModifyEscalationLevels.RUN;
                end;
            }
        }
    }

    var
        ModifyEscalationLevels: XMLport 51405086;
        ImportEscalationLevels: XMLport 51404086;
}

