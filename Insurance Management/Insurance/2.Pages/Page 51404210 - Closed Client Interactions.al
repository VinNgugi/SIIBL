page 51404210 "Closed Client Interactions"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New list form created for Complaint Incedent

    Caption = 'Closed Client Interactions';
    CardPageID = "Closed Client Interaction";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Client Interaction Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Interact Code"; "Interact Code")
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
                field(Notes; Notes)
                {
                    MultiLine = true;
                }
                field("User ID"; "User ID")
                {
                }
                field(Date; Date)
                {
                    Caption = 'Logged Date';
                }
                field("Current Status"; "Current Status")
                {
                }
                field("Last Updated Date and Time"; "Last Updated Date and Time")
                {
                }
                field("Region Code"; "Region Code")
                {
                }
                field("Additional Notes"; "Additional Notes")
                {
                }
                field("Major Category"; "Major Category")
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
                    RunObject = Page "Client Interaction";
                    RunPageLink = "Interact Code" = FIELD("Interact Code");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SETRANGE("Current Status", "Current Status"::Closed);
    end;

    procedure GetClientInterNo() IntCode: Code[10]
    begin
        IntCode := "Interact Code";
    end;

    procedure RecGet(var RecClientLine: Record "Client Interaction Header")
    begin
    end;
}

