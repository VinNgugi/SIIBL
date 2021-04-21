page 51404206 "Logged Client Interactions"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New list form created for Complaint Incedent

    Caption = 'Logged Client Interactions';
    CardPageID = "Client Interaction";
    Editable = false;
    PageType = List;
    SourceTable = "Client Interaction header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Interact Code";"Interact Code")
                {
                }
                field("Date and Time";"Date and Time")
                {
                }
                field(PIN;PIN)
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Interaction Type No.";"Interaction Type No.")
                {
                }
                field("Interaction Channel";"Interaction Channel")
                {
                }
                field("Interaction Type Desc.";"Interaction Type Desc.")
                {
                }
                field("Interaction Cause Desc.";"Interaction Cause Desc.")
                {
                }
                field(Notes;Notes)
                {
                }
                field("User ID";"User ID")
                {
                }
                field(Date;Date)
                {
                    Caption = 'Logged Date';
                }
                field("Current Status";"Current Status")
                {
                }
                field("Last Updated Date and Time";"Last Updated Date and Time")
                {
                }
                field("Region Code";"Region Code")
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
        SETFILTER("Current Status",'%1|%2',"Current Status"::Logged,"Current Status"::Reopened);
        SETRANGE("User ID",USERID);
    end;

    procedure GetClientInterNo() IntCode: Code[10]
    begin
        IntCode := "Interact Code";
    end;

    procedure RecGet(var RecClientLine: Record 51404204)
    begin
    end;
}

