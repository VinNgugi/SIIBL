page 51404256 "Interaction Type List"
{
    // version AES-PAS 1.0

    CardPageID = "Interaction Type Card";
    Editable = true;
    PageType = List;
    SourceTable ="Interaction Type";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Status = CONST(Active));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Interaction Type"; "Interaction Type")
                {
                    OptionCaption = 'Request,Complaint,Enquiry,Observation,Outbound Calls';
                }
                field(Status; Status)
                {
                }
                field("Day Start Time"; "Day Start Time")
                {
                }
                field("Day End Time"; "Day End Time")
                {
                }
                field("Escalation Expiration -Hrs"; "Escalation Expiration -Hrs")
                {
                }
                field("Assigned to Business Unit"; "Assigned to Business Unit")
                {
                }
                field("Business Unit Email"; "Business Unit Email")
                {
                }
                field("Assigned to Business Name"; "Assigned to Business Name")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
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

    var
        ImportTypes: XMLport 51404102;
        ModifyTypes: XMLport 51405087;
}

