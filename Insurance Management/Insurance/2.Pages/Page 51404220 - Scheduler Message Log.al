page 51404220 "Scheduler Message Log"
{
    // version Scheduler

    Caption = 'Scheduler Message Log';
    Editable = false;
    PageType = Card;
    SourceTable = "Scheduler Message Log";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                IndentationColumn = "Text 1Indent";
                IndentationControls = Group;
                field(Group;Group)
                {
                }
                field("Line No.";"Line No.")
                {
                    BlankZero = true;
                    HideValue = "Line No.HideValue";
                }
                field("Text 1";"Text 1")
                {
                }
                field("Text 2";"Text 2")
                {
                }
                field("Text 3";"Text 3")
                {
                }
                field("Text 4";"Text 4")
                {
                }
                field("Text 5";"Text 5")
                {
                }
                field("Text 6";"Text 6")
                {
                }
                field("Date Recorded";"Date Recorded")
                {
                }
                field("Time Recorded";"Time Recorded")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        "Line No.HideValue" := FALSE;
        GroupIndent := 0;
        GroupOnFormat;
        LineNoOnFormat;
        Text1OnFormat;
        Text2OnFormat;
        Text3OnFormat;
        Text4OnFormat;
        Text5OnFormat;
        Text6OnFormat;
        DateRecordedOnFormat;
        TimeRecordedOnFormat;
    end;

    var
        [InDataSet]
        GroupIndent: Integer;
        [InDataSet]
        "Line No.HideValue": Boolean;
        [InDataSet]
        "Text 1Indent": Integer;

    local procedure GroupOnFormat()
    begin
        GroupIndent := Indentation;

        IF "Error Flag" THEN;
    end;

    local procedure LineNoOnFormat()
    begin
        IF ("Line No." < 0) THEN "Line No.HideValue" := TRUE;
        IF "Error Flag" THEN;
    end;

    local procedure Text1OnFormat()
    begin
        "Text 1Indent" := Indentation;

        IF "Error Flag" THEN;
    end;

    local procedure Text2OnFormat()
    begin
        IF "Error Flag" THEN;
    end;

    local procedure Text3OnFormat()
    begin
        IF "Error Flag" THEN;
    end;

    local procedure Text4OnFormat()
    begin
        IF "Error Flag" THEN;
    end;

    local procedure Text5OnFormat()
    begin
        IF "Error Flag" THEN;
    end;

    local procedure Text6OnFormat()
    begin
        IF "Error Flag" THEN;
    end;

    local procedure DateRecordedOnFormat()
    begin
        IF "Error Flag" THEN;
    end;

    local procedure TimeRecordedOnFormat()
    begin
        IF "Error Flag" THEN;
    end;
}

