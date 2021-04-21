page 51404222 "Schedule Group Subform"
{
    // version Scheduler

    // ///(26.03.08 SS) !RunTask

    AutoSplitKey = true;
    Caption = 'Schedule Group Subform';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Schedule Task";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Object Type"; "Object Type")
                {
                }
                field("Object ID"; "Object ID")
                {
                }
                field(Description; Description)
                {
                }
                field(Enabled; Enabled)
                {
                }
                field("Parameter 1"; "Parameter 1")
                {
                    Visible = false;
                }
                field("Parameter 2"; "Parameter 2")
                {
                    Visible = false;
                }
                field("Parameter 3"; "Parameter 3")
                {
                    Visible = false;
                }
                field("Parameter 4"; "Parameter 4")
                {
                    Visible = false;
                }
                field("Parameter 5"; "Parameter 5")
                {
                    Visible = false;
                }
                field("Parameter 6"; "Parameter 6")
                {
                    Visible = false;
                }
                field("Parameter 7"; "Parameter 7")
                {
                    Visible = false;
                }
                field("Parameter 8"; "Parameter 8")
                {
                    Visible = false;
                }
                field("Parameter 9"; "Parameter 9")
                {
                    Visible = false;
                }
                field("Parameter 10"; "Parameter 10")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        Text001: Label 'Do you wish to run this task?';
        Text002: Label 'Task Completed';

    procedure RunTask()
    var
        lcuSchedTaskRun: Codeunit "Schedule - Automatic Runner";
    begin
        ///(26.03.08 SS) !RunTask
        TESTFIELD("Line No.");
        TESTFIELD("Object ID");
        IF NOT CONFIRM(Text001) THEN EXIT;
        lcuSchedTaskRun.RUN;
        MESSAGE(Text002);
    end;
}

