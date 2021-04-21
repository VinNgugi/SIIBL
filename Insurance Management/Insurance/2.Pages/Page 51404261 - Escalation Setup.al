page 51404261 "Escalation Setup"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New form created for Complaint Setup
    // RW  201010  : New button added to open form in List Format(F5).

    PageType = Card;
    SourceTable ="Interactions Escalation Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Channel No.";"Channel No.")
                {
                }
                field("Channel Name";"Channel Name")
                {
                }
                
                field("Level Code";"Level Code")
                {
                }
                
            }
            group(Notification)
            {
                Caption = 'Notification';
                
                
                field("Distribution E-mail for Level";"Distribution E-mail for Level")
                {
                }
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
                    
                      /*
                      IF Status<>Status::Released THEN
                      ERROR ('The Satement Category must be fully Approved before Importing the Addresses');
                      */
                    
                    ImportEscalationLevels.RUN;

                end;
            }
        }
    }

    var
        Text19061664: Label 'Distribution Email Address';
        Text19007943: Label 'Escalation Time in (Hrs.)';
        Text19010630: Label 'Working Hours';
        ImportEscalationLevels: XMLport "Modify Interaction Escalation";
}

