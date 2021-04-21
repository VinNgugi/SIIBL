page 51404221 Scheduler
{
    // version Scheduler

    // ///(27.03.08 SS) Scheduler form. Set to process data every 10 seconds...

    Caption = 'Scheduler';
    Editable = false;
    PageType = Card;
    SourceTable = "Schedule Group";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //PAGE.RUN(PAGE::Page50003,Rec);
                    end;
                }
                field(Description;Description)
                {
                }
                field("Run on Monday";"Run on Monday")
                {
                    Visible = false;
                }
                field("Run on Tuesday";"Run on Tuesday")
                {
                    Visible = false;
                }
                field("Run on Wednesday";"Run on Wednesday")
                {
                    Visible = false;
                }
                field("Run on Thursday";"Run on Thursday")
                {
                    Visible = false;
                }
                field("Run on Friday";"Run on Friday")
                {
                    Visible = false;
                }
                field("Run on Saturday";"Run on Saturday")
                {
                    Visible = false;
                }
                field("Run on Sunday";"Run on Sunday")
                {
                    Visible = false;
                }
                field(Enabled;Enabled)
                {
                }
                field("Next Scheduled Date Time";"Next Scheduled Date Time")
                {
                }
                field("Last Date Time Executed";"Last Date Time Executed")
                {
                }
                field("Interval (secs)";"Interval (secs)")
                {
                }
            }
            field(statusLabel;statusLabel)
            {
                Style = Strong;
                StyleExpr = TRUE;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(START)
            {
                Caption = 'START';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    schedulerRunning := TRUE;
                    statusLabel      := Text001;
                end;
            }
            action(STOP)
            {
                Caption = 'STOP';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    schedulerRunning := FALSE;
                    statusLabel      := Text002;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        statusLabel := Text002;
    end;

    var
        schedulerRunning: Boolean;
        statusLabel: Text[250];
        Text001: Label 'The Scheduler Is Running';
        Text002: Label 'The Scheduler Is Stopped';

    local procedure OnTimer()
    var
        lcuSchedulerRunner: Codeunit "Schedule - Automatic Runner";
    begin
        IF schedulerRunning THEN     ///If the scheduler is active
           lcuSchedulerRunner.RUN;   ///Run it to start any overdue tasks

        CurrPage.UPDATE;             ///Refresh the form
    end;
}

