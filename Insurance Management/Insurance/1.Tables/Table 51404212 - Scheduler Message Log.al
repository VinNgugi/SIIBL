table 51404212 "Scheduler Message Log"
{
    // version Scheduler

    // ///(27.03.08 SS) !HandleErrorNotifications

    Caption = 'Scheduler Message Log';

    fields
    {
        field(10;ID;Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(20;"Date Recorded";Date)
        {
            Caption = 'Date Recorded';
        }
        field(30;"Time Recorded";Time)
        {
            Caption = 'Time Recorded';
        }
        field(40;Group;Code[20])
        {
            Caption = 'Group';
        }
        field(50;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(60;"Error Flag";Boolean)
        {
            Caption = 'Error Flag';
        }
        field(70;"Text 1";Text[250])
        {
            Caption = 'Text 1';
        }
        field(80;"Text 2";Text[250])
        {
            Caption = 'Text 2';
        }
        field(90;"Text 3";Text[250])
        {
            Caption = 'Text 3';
        }
        field(100;"Text 4";Text[250])
        {
            Caption = 'Text 4';
        }
        field(110;"Text 5";Text[250])
        {
            Caption = 'Text 5';
        }
        field(120;"Text 6";Text[250])
        {
            Caption = 'Text 6';
        }
        field(130;Indentation;Integer)
        {
            Caption = 'Indentation';
        }
    }

    keys
    {
        key(Key1;ID)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF ("Error Flag") THEN
           HandleErrorNotifications;
    end;

    procedure HandleErrorNotifications()
    var
        lrecSchedSetup: Record "Scheduler setup";
        lcuSMTPMail: Codeunit "SMTP Mail";
        NewLine: Char;
        EmailRecipients: List of [Text];
    begin
        ///(27.03.08 SS) !HandleErrorNotifications
        NewLine := 10;

        lrecSchedSetup.GET;
        IF (NOT lrecSchedSetup."Send E-Mail Alerts") THEN EXIT;
        IF ((lrecSchedSetup."Primary E-Mail" = '') AND (lrecSchedSetup."Secondary E-Mail" = '')) THEN EXIT;

        lcuSMTPMail.CreateMessage('MBS Dynamics NAV','NAV@NAV.COM','','Nav Scheduler Problem','',FALSE);

        //18.04.21 IF (lrecSchedSetup."Primary E-Mail" <> '') THEN lcuSMTPMail.AddRecipients(lrecSchedSetup."Primary E-Mail"));
        //IF (lrecSchedSetup."Secondary E-Mail" <> '') THEN lcuSMTPMail.AddRecipients(lrecSchedSetup."Secondary E-Mail");

        lcuSMTPMail.AppendBody('The scheduler has encountered a problem. Details as follows:' + FORMAT(NewLine));
        lcuSMTPMail.AppendBody(FORMAT(NewLine));
        lcuSMTPMail.AppendBody('Date Recorded   ' + FORMAT("Date Recorded") + FORMAT(NewLine));
        lcuSMTPMail.AppendBody('Time Recorded   ' + FORMAT("Time Recorded") + FORMAT(NewLine));
        lcuSMTPMail.AppendBody('Scheduler Group ' + Group + FORMAT(NewLine));

        lcuSMTPMail.AppendBody('Line No.        ' + FORMAT("Line No.") + FORMAT(NewLine));
        lcuSMTPMail.AppendBody(FORMAT(NewLine));
        lcuSMTPMail.AppendBody('The following detail is available' + FORMAT(NewLine));
        lcuSMTPMail.AppendBody('=================================' + FORMAT(NewLine));
        lcuSMTPMail.AppendBody("Text 1" + FORMAT(NewLine));
        lcuSMTPMail.AppendBody("Text 2" + "Text 3" + "Text 4" + FORMAT(NewLine));
        lcuSMTPMail.AppendBody("Text 5" + "Text 6" + FORMAT(NewLine));
        lcuSMTPMail.AppendBody(FORMAT(NewLine));
        lcuSMTPMail.AppendBody('Please investigate and resolve');

        lcuSMTPMail.Send()
    end;
}

