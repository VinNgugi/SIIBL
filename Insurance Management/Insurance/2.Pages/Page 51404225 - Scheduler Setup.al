page 51404225 "Scheduler Setup"
{
    // version Scheduler

    Caption = 'Scheduler Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Scheduler Setup";

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Schedule Group Nos.";"Schedule Group Nos.")
                {
                }
            }
            group("E-Mail")
            {
                Caption = 'E-Mail';
                field("Send E-Mail Alerts";"Send E-Mail Alerts")
                {
                }
                field("Primary E-Mail";"Primary E-Mail")
                {
                }
                field("Secondary E-Mail";"Secondary E-Mail")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
          INIT;
          INSERT;
        END;
    end;
}

