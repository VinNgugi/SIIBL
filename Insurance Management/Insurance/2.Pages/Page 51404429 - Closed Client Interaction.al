page 51404429 "Closed Client Interaction"
{
    // version AES-PAS 1.0

    Editable = false;
    PageType = Card;
    SourceTable = "Client Interaction Header";
    SourceTableView = WHERE("Current Status"=CONST(Closed));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Client No.";"Client No.")
                {
                }
                field(PIN;PIN)
                {
                }
                field("Client Name";"Client Name")
                {
                    Editable = false;
                }
                field("Region Code";"Region Code")
                {
                    Editable = true;
                }
                field("Region Name";"Region Name")
                {
                    Editable = false;
                }
                field("State Code";"State Code")
                {
                    Editable = true;
                }
                field("State Name";"State Name")
                {
                    Editable = false;
                }
                field("LGA Code";"LGA Code")
                {
                    Editable = true;
                }
                field("LGA Name";"LGA Name")
                {
                    Editable = false;
                }
                field("Branch Code";"Branch Code")
                {
                    Caption = 'Branch Code';
                    Editable = true;
                }
                field("Branch Description";"Branch Description")
                {
                    Editable = false;
                }
                field("Interact Code";"Interact Code")
                {
                }
                field("Date and Time";"Date and Time")
                {
                }
                field("Interaction Channel";"Interaction Channel")
                {
                }
                field("Interaction Type";"Interaction Type")
                {
                    Caption = 'Interaction Type';
                }
                field("Interaction Type No.";"Interaction Type No.")
                {
                }
                field("Interaction Type Desc.";"Interaction Type Desc.")
                {
                }
                field("Interaction Cause No.";"Interaction Cause No.")
                {
                }
                field("Interaction Cause Desc.";"Interaction Cause Desc.")
                {
                }
                field("Interaction Resolution No.";"Interaction Resolution No.")
                {
                }
                field("Interaction Resol. Desc.";"Interaction Resol. Desc.")
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
                field("Assign Remarks";"Assign Remarks")
                {
                }
                field("Last Updated Date and Time";"Last Updated Date and Time")
                {
                }
                field("Escalation Level No.";"Escalation Level No.")
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
                    MultiLine = true;
                }
                field("Root Cause Analysis";"Root Cause Analysis")
                {
                    MultiLine = true;
                }
            }
            part("<Resolution Subform>";51404263)
            {
                Caption = 'Resolution Steps';
                SubPageLink = IRCode=FIELD("Interaction Resolution No.");
            }
            part("<Client Interactions List>";51404259)
            {
                Caption = 'Client Interactions';
                SubPageLink = "Client No."=FIELD("Client No.");
            }
            group(Remarks)
            {
                field("Client Feedback";"Client Feedback")
                {
                }
                field("Reviewing Officer Remarks";"Reviewing Officer Remarks")
                {
                }
            }
            systempart(SysNotes;Notes)
            {
            }
            systempart(Outlook;Outlook)
            {
            }
            systempart(Mynotes;MyNotes)
            {
            }
            systempart(Links;Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000041>")
            {
                Caption = 'C&lient';
                action(ReOpen)
                {
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        IF DIALOG.CONFIRM('Are you sure you want to reopen this interaction',TRUE,'') THEN
                          "Current Status":="Current Status"::Reopened;
                        MODIFY;
                    end;
                }
            }
        }
    }
}

