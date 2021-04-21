page 51404265 "Interaction Central"
{
    // version AES-PAS 1.0

    PageType = Card;
    SourceTable = "Client Interaction Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Interact Code";"Interact Code")
                {
                }
                field("Date and Time";"Date and Time")
                {
                    Editable = false;
                    Enabled = true;
                }
                field("Client No.";"Client No.")
                {
                }
                field("Client Name";"Client Name")
                {
                    Editable = false;
                }
                field("Interaction Channel";"Interaction Channel")
                {
                }
                field("Interaction Type";"Interaction Type")
                {
                }
                field("Interaction Type No.";"Interaction Type No.")
                {
                }
                field("Interaction Type Desc.";"Interaction Type Desc.")
                {
                    Editable = false;
                }
                field("Interaction Cause No.";"Interaction Cause No.")
                {
                }
                field("Interaction Cause Desc.";"Interaction Cause Desc.")
                {
                    Editable = false;
                }
                field("Interaction Resolution No.";"Interaction Resolution No.")
                {
                }
                field("Interaction Resol. Desc.";"Interaction Resol. Desc.")
                {
                    Editable = false;
                }
                
                field("State Code";"State Code")
                {
                }
                
                field("State Name";"State Name")
                {
                    Editable = false;
                }
                field("Client Feedback";"Client Feedback")
                {
                }
                field("Reviewing Officer Remarks";"Reviewing Officer Remarks")
                {
                }
                field("User ID";"User ID")
                {
                }
                field("Current Status";"Current Status")
                {
                }
                field("Assigned to User";"Assigned to User")
                {
                }
                field("Last Updated Date and Time";"Last Updated Date and Time")
                {
                    Editable = false;
                }
                field("Escalation Level No.";"Escalation Level No.")
                {
                }
                field(IsEscalated;IsEscalated)
                {
                }
                field("Assigned Flag";"Assigned Flag")
                {
                }
                field("Escalation Level Name";"Escalation Level Name")
                {
                }
                field("Escalation Clock";"Escalation Clock")
                {
                }
                field(Notes;Notes)
                {
                }
                part("Resolution Steps";"Resolution Subform")
                {
                    SubPageLink = IRCode=FIELD("Interaction Resolution No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Comment)
            {
                Caption = 'Comment';
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = Page 124;
               // RunPageLink = "Table Name"=CONST(17),
                           //   "No."=FIELD("Interact Code");
                ToolTip = 'Comment';
            }
        }
    }

    var
        Text19006892: Label 'Location where client reported the interaction';
}

