page 51404259 "Client Interactions List"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New list form created for Complaint Incedent

    Caption = 'Client Complaint List';
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Client Interaction Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "Interact Code")
                {
                }
                field("Date and Time"; "Date and Time")
                {
                }
                field(PIN; PIN)
                {
                }
                field("Client Name"; "Client Name")
                {
                }
                field("Interaction Channel"; "Interaction Channel")
                {
                }
                field("Interaction Type Desc."; "Interaction Type Desc.")
                {
                }
                field("Interaction Cause Desc."; "Interaction Cause Desc.")
                {
                }
                field("Interaction Type No."; "Interaction Type No.")
                {
                }
                field(Notes; Notes)
                {
                }
                field("Additional Notes"; "Additional Notes")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Escalation Clock"; "Escalation Clock")
                {
                }
                field(Date; Date)
                {
                    Caption = 'Logged Date';
                }
                field("Current Status"; "Current Status")
                {
                }
                field("Reviewing Officer Remarks"; "Reviewing Officer Remarks")
                {
                    Caption = 'Resolution Remarks';
                }
                field("Last Updated Date and Time"; "Last Updated Date and Time")
                {
                }
                field("Root Cause Analysis"; "Root Cause Analysis")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Complaint)
            {
                Caption = 'Complaint';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page 51404200;
                    RunPageLink = "Interact Code" = FIELD("Interact Code");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    procedure GetClientInterNo() IntCode: Code[10]
    begin
        IntCode := "Interact Code";
    end;

    procedure RecGet(var RecClientLine: Record "Client Interaction Header")
    begin
    end;
}

