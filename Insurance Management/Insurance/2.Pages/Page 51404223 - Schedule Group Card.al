page 51404223 "Schedule Group Card"
{
    // version Scheduler

    // //(27.03.08 SS) !RunAllTasks

    Caption = 'Schedule Group Card';
    PageType = Card;
    SourceTable = "Schedule Group";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; Description)
                {
                }
                field(Enabled; Enabled)
                {
                }
                field("Next Scheduled Date Time"; "Next Scheduled Date Time")
                {
                }
                field("Last Date Time Executed"; "Last Date Time Executed")
                {
                }
                field("Interval (secs)"; "Interval (secs)")
                {
                }
                field("Run on Monday"; "Run on Monday")
                {
                }
                field("Run on Tuesday"; "Run on Tuesday")
                {
                }
                field("Run on Wednesday"; "Run on Wednesday")
                {
                }
                field("Run on Thursday"; "Run on Thursday")
                {
                }
                field("Run on Friday"; "Run on Friday")
                {
                }
                field("Run on Saturday"; "Run on Saturday")
                {
                }
                field("Run on Sunday"; "Run on Sunday")
                {
                }
            }
            part(subform; "Schedule Group subform")
            {
                SubPageLink ="Schedule Group No."=FIELD("No.");
                    SubPageView = SORTING("Schedule Group No.","Line No.")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Schedule Group")
            {
                Caption = '&Schedule Group';
                
                action("Run All Tasks")
                {
                    Caption = 'Run All Tasks';

                    trigger OnAction()
                    begin
                        RunAllTasks;
                    end;
                }
            }
        }
    }

    var
        Text001: Label 'There are no tasks to run.';
        Text002: Label 'Do you want to run the tasks for this group?';
        Text003: Label 'Processing complete';

    procedure RunAllTasks()
    var
        lrecSchedTask: Record "Schedule Task";
        lcuSchedGroupRun: Codeunit "Schedule - Automatic Runner";
    begin
        ///(27.03.08 SS) !RunAllTasks
        IF (NOT CONFIRM(Text002)) THEN EXIT;

        lrecSchedTask.SETRANGE("Schedule Group No.","No.");    ///Check that we have something to try and run
        lrecSchedTask.SETRANGE(Enabled,TRUE);                  ///Check that we have something to try and run
        IF (lrecSchedTask.COUNT = 0) THEN ERROR(Text001);      ///Check that we have something to try and run

        "Last Date Time Executed" := CURRENTDATETIME;          ///Make sure the date/time of execution is recorded
        CurrPage.SAVERECORD;                                   ///Make sure the date/time of execution is recorded
        COMMIT;                                                ///Make sure the date/time of execution is recorded

        //lcuSchedGroupRun.setRunManually;                       ///Note that we are running this group manually
        lcuSchedGroupRun.RUN;
        //lcuSchedGroupRun.RUN(Rec);                             ///Run the group
        MESSAGE(Text003);
    end;
}

