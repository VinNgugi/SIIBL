page 51404215 "All Open Client Interactions"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New list form created for Complaint Incedent

    Caption = 'Client Complaint List';
    Editable = false;
    PageType = List;
    SourceTable = "Client Interaction Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"Interact Code")
                {
                }
                field("Date and Time";"Date and Time")
                {
                }
                field("Client No.";"Client No.")
                {
                }
                field(PIN;PIN)
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Interaction Channel";"Interaction Channel")
                {
                }
                field("Interaction Type No.";"Interaction Type No.")
                {
                }
                field("Interaction Cause No.";"Interaction Cause No.")
                {
                }
                field("Interaction Resolution No.";"Interaction Resolution No.")
                {
                }
                field(Notes;Notes)
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
                field("Region Code";"Region Code")
                {
                }
                field("Last Updated Date and Time";"Last Updated Date and Time")
                {
                }
                field("Escalation Level No.";"Escalation Level No.")
                {
                }
                field("Root Cause Analysis";"Root Cause Analysis")
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
                    RunObject = Page "Client Interaction";
                    RunPageLink = "Interact Code"=FIELD("Interact Code");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //SETRANGE(Status,Status<>5);
        SETFILTER("Current Status",'<>Closed');
    end;

    procedure GetClientInterNo() IntCode: Code[10]
    begin
        IntCode := "Interact Code";
    end;

    procedure RecGet(var RecClientLine: Record "Client Interaction Header")
    begin
    end;
}

