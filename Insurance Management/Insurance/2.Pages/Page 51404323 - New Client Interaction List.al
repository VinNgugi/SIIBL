page 51404323 "New Client Interaction List"
{
    Caption = 'New Client Interaction List';
    CardPageID = "Client Interaction";
    PageType = List;
    SourceTable = "Client Interaction Header";
    SourceTableView = WHERE("Major Category"=CONST("Client Services"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Interact Code";"Interact Code")
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
                field("Interaction Channel";"Interaction Channel")
                {
                }
                field("Interaction Type Desc.";"Interaction Type Desc.")
                {
                }
                field("Interaction Cause Desc.";"Interaction Cause Desc.")
                {
                }
                field("Interaction Type";"Interaction Type")
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
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Major Category":="Major Category"::"Client Services";
    end;
}

