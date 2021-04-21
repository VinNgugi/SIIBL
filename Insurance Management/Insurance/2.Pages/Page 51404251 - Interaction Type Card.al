page 51404251 "Interaction Type Card"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New form created for Complaint Category

    Caption = 'Client Interaction Type Card';
    PageType = Card;
    RefreshOnActivate = true;
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
                field(Status; Status)
                {
                }
                field("Day Start Time"; "Day Start Time")
                {
                }
                field("Day End Time"; "Day End Time")
                {
                    Caption = 'Day End Time';
                }
                field("Escalation Expiration -Hrs"; "Escalation Expiration -Hrs")
                {
                }
                field("Assigned to Business Unit"; "Assigned to Business Unit")
                {
                }
                field("Business Unit Email"; "Business Unit Email")
                {
                    Editable = false;
                }
                field("Assigned to Business Name"; "Assigned to Business Name")
                {
                    Caption = 'Assigned to Business Unit Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Import Complaint Types")
                {
                    Caption = 'Import Complaint Types';
                    Ellipsis = true;
                }
                action("Import New Interaction Types")
                {
                    Caption = 'Import New Interaction Types';

                    trigger OnAction()
                    begin

                        /*
                        IF Status<>Status::Released THEN
                        ERROR ('The Satement Category must be fully Approved before Importing the Addresses');
                        */

                        ImportTypes.RUN;

                    end;
                }
                action("Modify Interaction Types")
                {
                    Caption = 'Modify Interaction Types';

                    trigger OnAction()
                    begin

                        /*
                        IF Status<>Status::Released THEN
                        ERROR ('The Satement Category must be fully Approved before Importing the Addresses');
                        */

                        ModifyTypes.RUN;

                    end;
                }
            }
        }
    }

    var
        ImportTypes: XMLport 51404102;
        ModifyTypes: XMLport 51405087;
}

