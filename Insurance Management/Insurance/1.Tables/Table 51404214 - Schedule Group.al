table 51404214 "Schedule Group"
{
    // version Scheduler

    Caption = 'Schedule Group';
    DrillDownPageID = 51404224;
    LookupPageID = 51404224;

    fields
    {
        field(10;"No.";Code[20])
        {
            Caption = 'No.';
        }
        field(20;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(30;"Run on Monday";Boolean)
        {
            Caption = 'Run on Monday';

            trigger OnValidate()
            begin
                setNextScheduledDateTime;
            end;
        }
        field(40;"Run on Tuesday";Boolean)
        {
            Caption = 'Run on Tuesday';

            trigger OnValidate()
            begin
                setNextScheduledDateTime;
            end;
        }
        field(50;"Run on Wednesday";Boolean)
        {
            Caption = 'Run on Wednesday';

            trigger OnValidate()
            begin
                setNextScheduledDateTime;
            end;
        }
        field(60;"Run on Thursday";Boolean)
        {
            Caption = 'Run on Thursday';

            trigger OnValidate()
            begin
                setNextScheduledDateTime;
            end;
        }
        field(70;"Run on Friday";Boolean)
        {
            Caption = 'Run on Friday';

            trigger OnValidate()
            begin
                setNextScheduledDateTime;
            end;
        }
        field(80;"Run on Saturday";Boolean)
        {
            Caption = 'Run on Saturday';

            trigger OnValidate()
            begin
                setNextScheduledDateTime;
            end;
        }
        field(90;"Run on Sunday";Boolean)
        {
            Caption = 'Run on Sunday';

            trigger OnValidate()
            begin
                setNextScheduledDateTime;
            end;
        }
        field(100;"Interval (secs)";Integer)
        {
            Caption = 'Interval (secs)';
            InitValue = 60;
            MinValue = 60;

            trigger OnValidate()
            begin
                setNextScheduledDateTime;
            end;
        }
        field(110;Enabled;Boolean)
        {
            Caption = 'Enabled';

            trigger OnValidate()
            begin
                setNextScheduledDateTime;
            end;
        }
        field(120;"Next Scheduled Date Time";DateTime)
        {
            Caption = 'Next Scheduled Date Time';
        }
        field(130;"Last Date Time Executed";DateTime)
        {
            Caption = 'Last Date Time Executed';
        }
        field(140;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        lrecSchedSetup: Record "Scheduler Setup";
        lcuNoSeriesMgt: Codeunit 396;
    begin
        IF ("No." = '') THEN
        BEGIN
           lrecSchedSetup.GET;
           lrecSchedSetup.TESTFIELD("Schedule Group Nos.");
           lcuNoSeriesMgt.InitSeries(lrecSchedSetup."Schedule Group Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;
    end;

    procedure AssistEdit(): Boolean
    var
        lrecSchedSetup: Record "Scheduler Setup";
        lcuNoSeriesMgt: Codeunit 396;
    begin
        lrecSchedSetup.GET;
        lrecSchedSetup.TESTFIELD("Schedule Group Nos.");
        IF lcuNoSeriesMgt.SelectSeries(lrecSchedSetup."Schedule Group Nos.",xRec."No. Series","No. Series") THEN
        BEGIN
           lcuNoSeriesMgt.SetSeries("No.");
           EXIT(TRUE);
        END;
        //
    end;

    procedure setNextScheduledDateTime()
    begin
        ///(27.03.08 SS) !setNextScheduledDateTime
        IF NOT ("Run on Monday" OR "Run on Tuesday" OR "Run on Wednesday" OR
            "Run on Thursday" OR "Run on Friday" OR "Run on Saturday" OR "Run on Sunday") THEN
        BEGIN
           "Next Scheduled Date Time" := CURRENTDATETIME;
           EXIT;
        END;

        IF ("Next Scheduled Date Time" = 0DT) THEN
           "Next Scheduled Date Time" := CURRENTDATETIME;

        WHILE (NOT isValidDateTime) DO
           "Next Scheduled Date Time" += ("Interval (secs)" * 1000);
    end;

    procedure isValidDateTime(): Boolean
    var
        aDate: Date;
    begin
        ///(27.03.08 SS) !isValidDateTime
        ///              Returns true if the "Next Scheduled Date Time" field is valid otherwise returns false.
        ///              To be valid it must be.
        ///              a) On a day of the week it can run on.
        ///              b) After the current date time
        ///              c) After the last date time executed

        IF ("Next Scheduled Date Time" < CURRENTDATETIME) THEN EXIT(FALSE);           ///Rule B
        IF ("Next Scheduled Date Time" < "Last Date Time Executed") THEN EXIT(FALSE); ///Rule C

        aDate := DT2DATE("Next Scheduled Date Time");                                 ///Rule A
        CASE DATE2DWY(aDate,1) OF                                                     ///Rule A
           1 : EXIT("Run on Monday");                                                 ///Rule A
           2 : EXIT("Run on Tuesday");                                                ///Rule A
           3 : EXIT("Run on Wednesday");                                              ///Rule A
           4 : EXIT("Run on Thursday");                                               ///Rule A
           5 : EXIT("Run on Friday");                                                 ///Rule A
           6 : EXIT("Run on Saturday");                                               ///Rule A
           7 : EXIT("Run on Sunday");                                                 ///Rule A
        END;                                                                          ///Rule A

        EXIT(TRUE);             ///Get our clause just in case
    end;
}

