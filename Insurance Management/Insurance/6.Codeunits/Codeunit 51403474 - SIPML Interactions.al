codeunit 51403474 "SIPML Interactions"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New codeunit created for Complaint Escalation To Next Level
    // +--------------------------------------------------------------------------------------------------------------------+
    // | Creator/Modifier Date Code Mark Purpose/Description/Ref. |
    // +--------------------------------------------------------------------------------------------------------------------+
    // | Rupali Walke 28-09-10 01 New Function Added funGetEscalationHoursFromSetup
    //   Rupali Walke 28-09-10 01 Changes Done in function EscalateComplaintToNextLevel()
    //   Rupali Walke 04-10-10 01 Changes Done in function EscalateComplaintToNextLevel() comment //RW-041010
    // +---------------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
        EscalateComplaintToNextLevel();
    end;

    var
        ComplaintCode: Code[10];
        EscLevel: Integer;
        txtEscalationName: array [6] of Text[10];
        txtOldLevelName: Text[10];
        txtNewLevelName: Text[10];
        intOldLevelNo: Integer;
        intNewLevelNo: Integer;
        NewExpire: DateTime;
        CompInfo: Record 79;

    procedure EscalateComplaintToNextLevel()
    var
        TotEscHrs: Duration;
        TotExpHrs: Duration;
        EscDateTime: DateTime;
        CurrentDayRemDuration: Duration;
        NextWorkingDate: Date;
        TotWorkingHrs: Duration;
        CompInceHdr: Record "Client Interaction Header";
        precInteractionHeader: Record "Client Interaction Header";
        EscSetup: Record "Interaction Channel";
        EscalationHrs: Integer;
        EscalateHrs: Integer;
        CompInceDate: Date;
        CompInceTime: Time;
        SerMgtSetup: Record 5911;
        Description: Text[100];
        WorkingDay: Boolean;
        CalendarMgmt: Codeunit 7600;
        ComplaintInceCode: Code[10];
        CompChangeLevel: Record "Client Interaction Header";
        CurrComInceLevel: Integer;
        txtEscalationName: array [6] of Text[10];
        ltxtLineType: Text[10];
        ltxtActionType: Text[30];
        ltxtDescription: Text[250];
        lTC1000: Label 'Interaction successfully escalated.';
        ldttmCurrentDateAndEndTime: DateTime;
        Chsetup: Record 51404201;
        EscExpiration: DateTime;
        CompInceDates: Date;
        CompInceTimes: Time;
        CurrentDayRemDurations: Duration;
        ldttmCurrentDateAndEndTimes: DateTime;
    begin
        //Get escalation hours as per the escalation setup for each channel
        CompInceHdr.RESET;
        CompInceHdr.SETCURRENTKEY(CompInceHdr."Interact Code");
        //CompInceHdr.SETFILTER(CompInceHdr."Current Status",'<>Closed');
        //18.04.21 CompInceHdr.SETFILTER(CompInceHdr."Interaction Status",'=%1',CompInceHdr."Interaction Status"::New);
         CompInceHdr.SETFILTER(CompInceHdr."Current Status",'=%1',CompInceHdr."Current Status"::Assigned);
        //CompInceHdr.SETFILTER(CompInceHdr."Escalation Clock",'<>%1',0DT);
        //CompInceHdr.SETFILTER(CompInceHdr."Date and Time",'<>%1',0DT);
        //CompInceHdr.SETFILTER(CompInceHdr."Interaction Channel",'<>%1','');
        //CompInceHdr.SETFILTER(CompInceHdr."Interaction Type No.",'<>%1','');////added for interaction Type no.


        IF CompInceHdr.FIND('-') THEN REPEAT
          IF CompInceHdr."Escalation Level No." < 3 THEN BEGIN
            funEscalationNames;
            intOldLevelNo := CompInceHdr."Escalation Level No.";
            intNewLevelNo := CompInceHdr."Escalation Level No." + 1;

            //Captured complaint registered date time, working hours
            ComplaintCode := CompInceHdr."Interact Code";
            CompInceDate :=  DT2DATE(CompInceHdr."Date and Time");
            CompInceTime :=  DT2TIME(CompInceHdr."Date and Time");

            EscalationHrs := 0;
            IF Chsetup.GET(CompInceHdr."Interaction Type No.")=TRUE THEN BEGIN

              //Get escalation hours as per the escalation setup for each channel
              EscalationHrs:= funGetEscalationHoursFromSetup(CompInceHdr,0);
              TotWorkingHrs:= Chsetup."Day End Time" - Chsetup."Day Start Time";


              //Need to define base calendar code in Service management setup to find working/non working day
              SerMgtSetup.GET();
              //WorkingDay := NOT CalendarMgmt.CheckDateStatus(SerMgtSetup."Base Calendar Code",CompInceDate,Description);


              IF WorkingDay THEN BEGIN
              IF EscalationHrs>0 THEN BEGIN
                //Capture values in required variables
                TotEscHrs := (EscalationHrs * 60 * 60 * 1000);
                CompInceDate :=  DT2DATE(CompInceHdr."Date and Time");
                CompInceTime :=  DT2TIME(CompInceHdr."Date and Time");
                CurrentDayRemDuration :=  Chsetup."Day End Time" - CompInceTime;
                //RW-041010
                IF CurrentDayRemDuration >= TotEscHrs THEN BEGIN
                  ldttmCurrentDateAndEndTime:= CREATEDATETIME(CompInceDate,Chsetup."Day End Time");

                  EscDateTime :=ldttmCurrentDateAndEndTime - (CurrentDayRemDuration - TotEscHrs);
                END ELSE BEGIN
                  EscDateTime := CompInceHdr."Date and Time" +  CurrentDayRemDuration;
                END;
                END;
                //RW-041010
                TotEscHrs := TotEscHrs - CurrentDayRemDuration;

                NextWorkingDate := CompInceDate;

                //Calculation to find escalation date and time
                IF TotEscHrs > 0  THEN REPEAT
                  NextWorkingDate := CALCDATE('+1D',NextWorkingDate);
                  EscDateTime := CREATEDATETIME(NextWorkingDate,Chsetup."Day Start Time");

                  //18.04.21 WorkingDay :=NOT CalendarMgmt.CheckDateStatus(SerMgtSetup."Base Calendar Code",NextWorkingDate,Description);
                  IF WorkingDay THEN BEGIN
                    IF TotEscHrs >= TotWorkingHrs THEN
                      CurrentDayRemDuration := Chsetup."Day End Time" - Chsetup."Day Start Time"

                    ELSE
                      CurrentDayRemDuration := TotEscHrs;

                      EscDateTime := EscDateTime +  CurrentDayRemDuration;

                      TotEscHrs := TotEscHrs - CurrentDayRemDuration;

                  END;
                  UNTIL TotEscHrs <=0;

                 //Added
              //Get escalation hours as per the escalation setup for each channel

            //Captured complaint registered date time, working hours
            ComplaintCode := CompInceHdr."Interact Code";
            CompInceDates :=  DT2DATE(CompInceHdr."Date and Time");
            CompInceTimes :=  DT2TIME(CompInceHdr."Date and Time");

            EscalateHrs := 0;
            IF Chsetup.GET(CompInceHdr."Interaction Type No.")=TRUE THEN BEGIN

              EscalateHrs:= CompInceHdr."Overall Level Duration";
              TotWorkingHrs:= Chsetup."Day End Time" - Chsetup."Day Start Time";


              //Need to define base calendar code in Service management setup to find working/non working day
              SerMgtSetup.GET();
              //18.04.21 WorkingDay := NOT CalendarMgmt.CheckDateStatus(SerMgtSetup."Base Calendar Code",CompInceDates,Description);


              IF WorkingDay THEN BEGIN
              IF EscalateHrs>0 THEN BEGIN
                //Capture values in required variables
                TotExpHrs := (EscalateHrs * 60 * 60 * 1000);
                CompInceDates :=  DT2DATE(CompInceHdr."Date and Time");
                CompInceTimes :=  DT2TIME(CompInceHdr."Date and Time");
                CurrentDayRemDurations :=  Chsetup."Day End Time" - CompInceTimes;
                //RW-041010
                IF CurrentDayRemDurations >= TotExpHrs THEN BEGIN
                  ldttmCurrentDateAndEndTimes:= CREATEDATETIME(CompInceDates,Chsetup."Day End Time");

                  EscExpiration :=ldttmCurrentDateAndEndTimes - (CurrentDayRemDurations - TotExpHrs);
                END ELSE BEGIN
                   EscExpiration := CompInceHdr."Date and Time" +  CurrentDayRemDurations;
                END;
                END;
                //RW-041010
                TotExpHrs := TotExpHrs - CurrentDayRemDurations;

                NextWorkingDate := CompInceDates;

                //Calculation to find escalation date and time
                IF TotExpHrs > 0  THEN REPEAT
                  NextWorkingDate := CALCDATE('+1D',NextWorkingDate);
                  EscExpiration := CREATEDATETIME(NextWorkingDate,Chsetup."Day Start Time");

                  //WorkingDay :=NOT CalendarMgmt.CheckDateStatus(SerMgtSetup."Base Calendar Code",NextWorkingDate,Description);
                  IF WorkingDay THEN BEGIN
                    IF TotExpHrs >= TotWorkingHrs THEN
                      CurrentDayRemDurations := Chsetup."Day End Time" - Chsetup."Day Start Time"

                    ELSE
                      CurrentDayRemDurations := TotExpHrs;

                      EscExpiration := EscExpiration +  CurrentDayRemDurations;

                      TotExpHrs := TotExpHrs - CurrentDayRemDurations;

                  END;
                  UNTIL TotExpHrs <=0;

                   CompInceHdr."Escalation Expiration":=EscExpiration;
                   CompInceHdr.MODIFY;

                 //End Added


                //Update Escalation date and time(Last Updated Date and Time) in Complaint Incedent Header table
                IF (EscDateTime <= CURRENTDATETIME) AND (CompInceHdr."Escalation Level No." <> 4 )  THEN BEGIN
                  //CompChangeLevel.RESET;
                  CompChangeLevel.SETCURRENTKEY(CompChangeLevel."Interact Code");
                  CompChangeLevel.SETRANGE(CompChangeLevel."Interact Code",CompInceHdr."Interact Code");
                  IF CompChangeLevel.FINDFIRST THEN BEGIN
                    CompChangeLevel."Escalation Level No." := CompInceHdr."Escalation Level No." +1;
                    //CompChangeLevel."Escalation Clock" := EscDateTime;
                    CompChangeLevel."Escalation Clock" := CURRENTDATETIME;
                    CompChangeLevel."Escalation Expiration":=EscExpiration;
                    CompChangeLevel."Last Updated Date and Time" := CURRENTDATETIME;
                    CompChangeLevel."Escalation Level Name" := funGetEscalationName(CompInceHdr."Escalation Level No." + 1);
                    //AES
                    CompChangeLevel."Major Category":=CompChangeLevel."Major Category"::"Complaints Bureau";
                    //AES
                    CompChangeLevel.MODIFY;
                    ltxtLineType := 'System';
                    ltxtActionType := 'Escalated';
                    ltxtDescription := 'Escalated to level ' + CompChangeLevel."Escalation Level Name";
                    InsertDetailLine(CompInceHdr,ltxtLineType,ltxtActionType,ltxtDescription);
                    txtNewLevelName:=FORMAT(CompChangeLevel."Escalation Level No.");
                    //txtNewLevelName := CompChangeLevel."Escalation Level Name";
                   funSendEscalationMail(CompInceHdr);
                  END;
                END;
              END;
            END;
          END;
         END;
         END;
        UNTIL CompInceHdr.NEXT =0;
        //MESSAGE(lTC1000);
    end;

    procedure InsertDetailLine(precInteractHeader: Record "Client Interaction Header";ptxtLineType: Text[10];ptxtActionType: Text[30];ptxtDescription: Text[250])
    var
        lrecClientInteractLine: Record "Client Interaction Line";
        lintLineNo: Integer;
    begin

        //C004
        lrecClientInteractLine.RESET;
        lrecClientInteractLine.SETRANGE("Client Interaction No.",precInteractHeader."Interact Code");
        IF lrecClientInteractLine.FINDLAST THEN
          lintLineNo := lrecClientInteractLine."Line No." + 10000
        ELSE lintLineNo := 10000;

        lrecClientInteractLine.INIT;
        lrecClientInteractLine."Client Interaction No." := precInteractHeader."Interact Code";
        lrecClientInteractLine."Line No." := lintLineNo;
        EVALUATE(lrecClientInteractLine."Line Type",ptxtLineType);
        EVALUATE(lrecClientInteractLine."Action Type",ptxtActionType);
        //lrecClientInteractLine."User ID" := USERID;
        lrecClientInteractLine."Date and Time" := CURRENTDATETIME;
        lrecClientInteractLine.Description := ptxtDescription;
        lrecClientInteractLine."Expiration Time":=precInteractHeader."Escalation Expiration";
        lrecClientInteractLine.INSERT;
        //C004
    end;

    procedure GetNextLineNo(CompLine: Record "Client Interaction Line";BelowxRec: Boolean): Integer
    var
        CompLine2: Record "Client Interaction line";
        LoLineNo: Integer;
        HiLineNo: Integer;
        NextLineNo: Integer;
        LineStep: Integer;
    begin
        NextLineNo := 0;
        LineStep := 10000;
        CompLine2.RESET;
        CompLine2.SETRANGE("Client Interaction No.",ComplaintCode);
        IF CompLine2.FINDLAST THEN
          NextLineNo := CompLine2."Line No." + LineStep
        ELSE
          NextLineNo := LineStep;

        EXIT(NextLineNo);
    end;

    procedure funEscalateIgnoreSLA(var precInteractionHeader: Record "Client Interaction Header"): Boolean
    var
        lrecInteractionLine: Record "Client Interaction Line";
        intNextLineNo: Integer;
        ltxtLineType: Text[10];
        ltxtActionType: Text[30];
        ltxtDescription: Text[250];
        lintOldLevelNo: Integer;
    begin
        funEscalationNames;

        IF precInteractionHeader."Escalation Level No." = 3 THEN
        //  precInteractionHeader."SLA Status":=precInteractionHeader."SLA Status"::"1";
          precInteractionHeader.MODIFY;
          EXIT(FALSE);

        intOldLevelNo := precInteractionHeader."Escalation Level No.";
        intNewLevelNo := precInteractionHeader."Escalation Level No." + 1;


        precInteractionHeader."Escalation Level No." += 1;
        lrecInteractionLine.RESET;
        precInteractionHeader."Escalation Level Name" := txtEscalationName[precInteractionHeader."Escalation Level No." + 1];
        precInteractionHeader."Escalation Clock" := CURRENTDATETIME;
        precInteractionHeader."Last Updated Date and Time" := CURRENTDATETIME;

        ltxtLineType := 'System';
        ltxtActionType := 'Escalated';
        ltxtDescription := 'Manually escalated to level ' + precInteractionHeader."Escalation Level Name";
        InsertDetailLine(precInteractionHeader,ltxtLineType,ltxtActionType,ltxtDescription);

        txtNewLevelName := precInteractionHeader."Escalation Level Name";
        funSendEscalationMail(precInteractionHeader);

        EXIT(TRUE);
    end;

    procedure funEscalationNames()
    begin
        txtEscalationName[1] := 'ZERO';
        txtEscalationName[2] := 'ONE';
        txtEscalationName[3] := 'TWO';
        txtEscalationName[4] := 'THREE';
        txtEscalationName[5] := 'FOUR';
        txtEscalationName[6] := 'FIVE';
    end;

    procedure funGetEscalationName(pintEscalationLevel: Integer): Text[30]
    begin
        funEscalationNames;
        EXIT(txtEscalationName[pintEscalationLevel + 1]);
    end;

    procedure funGetEscalationHoursFromSetup(irecClientInterHdr: Record "Client Interaction Header";EscalationSteps: Integer): Integer
    var
        lrecEscalationSetup: Record 51404206;
        lintEscalationHr: Integer;
        recEscalationSteps: Record 51404207;
        TypeEscalationSetup: Record 51404201;
    begin

        ////IF lrecEscalationSetup.GET(irecClientInterHdr."Interaction Channel") THEN BEGIN
        IF TypeEscalationSetup.GET(irecClientInterHdr."Interaction Type No.") THEN BEGIN

        //AES CODE
            EscalationSteps:=irecClientInterHdr."Escalation Level No.";
            recEscalationSteps.RESET;
              ////recEscalationSteps.SETRANGE(recEscalationSteps."Channel No.",irecClientInterHdr."Interaction Channel");
              recEscalationSteps.SETRANGE(recEscalationSteps."Channel No.",irecClientInterHdr."Interaction Type No.");

              recEscalationSteps.SETRANGE(recEscalationSteps."Level Code",FORMAT(EscalationSteps));
          IF recEscalationSteps.FIND('-') THEN BEGIN
          lintEscalationHr :=recEscalationSteps."Level Duration - Hours";
          IF lintEscalationHr>0 THEN BEGIN
           END;
         END;
         END;
        EXIT(lintEscalationHr);
        //AES CODE





        //  IF irecClientInterHdr."Escalation Level No." = 0 THEN BEGIN
        //    lintEscalationHr := lrecEscalationSetup."Level 0";
        //  END ELSE IF irecClientInterHdr."Escalation Level No." = 1 THEN BEGIN
        //   lintEscalationHr := lrecEscalationSetup."Level 1";
        //  END ELSE IF irecClientInterHdr."Escalation Level No." = 2 THEN BEGIN
        //    lintEscalationHr := lrecEscalationSetup."Level 2";
        //  END ELSE IF irecClientInterHdr."Escalation Level No." = 3 THEN BEGIN
        //    lintEscalationHr := lrecEscalationSetup."Level 3";
        //  END ELSE IF irecClientInterHdr."Escalation Level No." = 4 THEN BEGIN
        //    lintEscalationHr := lrecEscalationSetup."Level 4";
        //  END ELSE IF irecClientInterHdr."Escalation Level No." = 5 THEN BEGIN
        //    lintEscalationHr  := lrecEscalationSetup."Level 5";
        //  END;
        //END;
        //EXIT(lintEscalationHr);
    end;

    procedure funSendEscalationMail(precInteractionHeader: Record "Client Interaction Header")
    var
        lcduSMTPEmail: Codeunit "SMTP Mail";
        ltxtSenderName: Text[100];
        ltxtSenderAddress: Text[100];
        ltxtRecipients: List of [Text];
        ltxtSubject: Text[200];
        ltxtBody: Text[1024];
        lrecUserSetup: Record 91;
        lTC1000: Label '''%1 is escalated to new level %2'' ';
        ltxtCCRecipients:List of [Text];
        lTC1001: Label '  is now for your attention. Please check this and carry out the appropriate actions. The Details of this Interaction are as follows : ';
        lTC1002: Label 'Interaction Type : ';
        lTC1003: Label 'Interaction Type No :  ';
        lTC1004: Label 'nteraction Type Description : ';
        lTC1005: Label 'RSA PIN : ';
        lTC1006: Label 'Note : ';
        lTC1007: Label 'Additional Note : ';
        lTC1008: Label 'SLA Hours : ';
        lTC1009: Label 'Requester Name : ';
        lrecInteractionLine: Record "Client Interaction Line";
        lchar13: Char;
        lchar10: Char;
        lTC1010: Label 'Logged Date : ';
        lTC1011: Label 'Due Date : ';
        ExpirationEscalation: DateTime;
        lTC1012: Label 'Regards : ';
    begin
        //C002
           CompInfo.GET();

           ltxtSenderName :='SIIBL Escalation';
           ltxtSenderAddress :=CompInfo."E-mail";

          ltxtCCRecipients.Add(precInteractionHeader."Logged By Email");
          ltxtRecipients.Add(funGetEscalationEmailID(precInteractionHeader,intNewLevelNo));


          IF (ltxtRecipients.Count() <> 0) AND (ltxtCCRecipients.count <> 0) THEN BEGIN
          ltxtSubject :='NAV Escalation Notification Level '+''+txtNewLevelName;

          IF txtNewLevelName='1' THEN BEGIN
          ltxtBody := '50% of the SLA has passed, and your team is yet to resolve the interaction with the following details:';
          END;
          IF txtNewLevelName='2' THEN BEGIN
          ltxtBody := '75% of the SLA has passed, and your team is yet to resolve the interaction with the following details:';
          END;
          IF txtNewLevelName='3' THEN BEGIN
          ltxtBody := '100% of the SLA has passed, and your team is yet to resolve the interaction with the following details:'
          END;
          IF txtNewLevelName >'3' THEN BEGIN
          ltxtBody := 'Level '+''+txtNewLevelName + '-'+'of the SLA has passed, and your team is yet to resolve the interaction with the following details:';
          END;

          lcduSMTPEmail.CreateMessage(ltxtSenderName,ltxtSenderAddress,ltxtRecipients,ltxtSubject,ltxtBody,FALSE);
          lchar13 := 13;
          lchar10 := 10;
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody('Interaction No:');
          lcduSMTPEmail.AppendBody(precInteractionHeader."Interact Code");

          lcduSMTPEmail.AppendBody(lTC1001);
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));

          lcduSMTPEmail.AppendBody(lTC1002);
          lcduSMTPEmail.AppendBody(FORMAT(precInteractionHeader."Interaction Type"));

          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(lTC1003);
          lcduSMTPEmail.AppendBody(precInteractionHeader."Interaction Type No.");
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(lTC1004);
          lcduSMTPEmail.AppendBody(precInteractionHeader."Interaction Type Desc.");
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));

          lrecInteractionLine.RESET;
          lrecInteractionLine.SETRANGE(lrecInteractionLine."Client Interaction No.",precInteractionHeader."Interact Code");
          IF lrecInteractionLine.FINDLAST THEN BEGIN
            lcduSMTPEmail.AppendBody(lTC1005);
            lcduSMTPEmail.AppendBody(FORMAT(precInteractionHeader.PIN));
            lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
            lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
            lcduSMTPEmail.AppendBody(lTC1006);
            lcduSMTPEmail.AppendBody(FORMAT(precInteractionHeader.Notes));
            lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
            lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
            lcduSMTPEmail.AppendBody(lTC1007);
            lcduSMTPEmail.AppendBody(precInteractionHeader."Additional Notes");
            lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
            lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
            lcduSMTPEmail.AppendBody(lTC1008);
            lcduSMTPEmail.AppendBody(FORMAT(precInteractionHeader."Overall Level Duration"));
            lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
            lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
            lcduSMTPEmail.AppendBody(lTC1009);
            lcduSMTPEmail.AppendBody(FORMAT(precInteractionHeader."User Name"));
          END;

          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(lTC1010);
          lcduSMTPEmail.AppendBody(FORMAT(precInteractionHeader."Date and Time"));

          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(lTC1011);
          lcduSMTPEmail.AppendBody(FORMAT(precInteractionHeader."Escalation Expiration"));


          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
          lcduSMTPEmail.AppendBody(lTC1012);

          lcduSMTPEmail.AddCC(ltxtCCRecipients);
          lcduSMTPEmail.Send();
           END;

        //C002
    end;

    procedure funGetEscalationEmailID(precClientInterHdr: Record "Client Interaction Header";pintLevelNo: Integer): Text[100]
    var
        lrecEscalationSetup: Record 51404206;
        ltxtEscalationEmailId: Text[100];
        recEscalActualSetup: Record 51404207;
        lrecEscalationSetups: Record 51404201;
    begin


        //AES CODE
           ////recEscalActualSetup.SETRANGE(recEscalActualSetup."Channel No.", precClientInterHdr."Interaction Channel");
           recEscalActualSetup.SETRANGE(recEscalActualSetup."Channel No.", precClientInterHdr."Interaction Type No.");

           recEscalActualSetup.SETRANGE(recEscalActualSetup."Level Code",FORMAT(precClientInterHdr."Escalation Level No."));
           IF  recEscalActualSetup.FINDFIRST THEN
            ltxtEscalationEmailId :=recEscalActualSetup."Distribution E-mail for Level";
           EXIT(ltxtEscalationEmailId);


        //AES CODE

        //IF lrecEscalationSetup.GET(precClientInterHdr."Interaction Channel") THEN BEGIN
        //  IF pintLevelNo = 0 THEN BEGIN
        //    //lrecEscalationSetup.TESTFIELD(lrecEscalationSetup."Distribution E-mail Level 0");
        //
        //    ltxtEscalationEmailId := lrecEscalationSetup."Distribution E-mail Level 0";
        //  END ELSE IF pintLevelNo = 1 THEN BEGIN
        //    //lrecEscalationSetup.TESTFIELD(lrecEscalationSetup."Distribution E-mail Level 1");
        //    ltxtEscalationEmailId := lrecEscalationSetup."Distribution E-mail Level 1";
        //  END ELSE IF pintLevelNo = 2 THEN BEGIN
        //    //lrecEscalationSetup.TESTFIELD(lrecEscalationSetup."Distribution E-mail Level 2");
        //    ltxtEscalationEmailId := lrecEscalationSetup."Distribution E-mail Level 2";
        //  END ELSE IF pintLevelNo = 3 THEN BEGIN
        //    //lrecEscalationSetup.TESTFIELD(lrecEscalationSetup."Distribution E-mail Level 3");
        //    ltxtEscalationEmailId := lrecEscalationSetup."Distribution E-mail Level 3";
        //  END ELSE IF pintLevelNo = 4 THEN BEGIN
        //    //lrecEscalationSetup.TESTFIELD(lrecEscalationSetup."Distribution E-mail Level 4");
        //    ltxtEscalationEmailId  := lrecEscalationSetup."Distribution E-mail Level 4";
        //  END ELSE IF pintLevelNo = 5 THEN BEGIN
        //    //lrecEscalationSetup.TESTFIELD(lrecEscalationSetup."Distribution E-mail Level 5");
        //    ltxtEscalationEmailId := lrecEscalationSetup."Distribution E-mail Level 5";
        //  END;
        //END;
        //EXIT(ltxtEscalationEmailId);
    end;

    procedure funGetEscalationExpirationFromInteraction(irecClientInterHdr: Record "Client Interaction Header";EscalationLevelDuration: DateTime): DateTime
    var
        lrecEscalationSetup: Record 51404206;
        lintEscalationHr: Integer;
        recEscalationSteps: Record 51404207;
        TypeEscalationSetup: Record 51404201;
    begin
        
        IF TypeEscalationSetup.GET(irecClientInterHdr."Interaction Type No.") THEN BEGIN
        
        //AES CODE
        
            EscalationLevelDuration:=irecClientInterHdr."Escalation Expiration";
            END;
        
        
            /*
            recEscalationSteps.RESET;
              recEscalationSteps.SETRANGE(recEscalationSteps."Channel No.",irecClientInterHdr."Interaction Type No.");
              recEscalationSteps.SETRANGE(recEscalationSteps."Level Code",FORMAT(EscalationSteps));
          IF recEscalationSteps.FIND('-') THEN BEGIN
          lintEscalationHr :=recEscalationSteps."Level Duration - Hours";
          IF lintEscalationHr>0 THEN BEGIN
           END;
         END;
         END;
        EXIT(lintEscalationHr);
        //AES CODE
        */
        
        
        
        
        //  IF irecClientInterHdr."Escalation Level No." = 0 THEN BEGIN
        //    lintEscalationHr := lrecEscalationSetup."Level 0";
        //  END ELSE IF irecClientInterHdr."Escalation Level No." = 1 THEN BEGIN
        //   lintEscalationHr := lrecEscalationSetup."Level 1";
        //  END ELSE IF irecClientInterHdr."Escalation Level No." = 2 THEN BEGIN
        //    lintEscalationHr := lrecEscalationSetup."Level 2";
        //  END ELSE IF irecClientInterHdr."Escalation Level No." = 3 THEN BEGIN
        //    lintEscalationHr := lrecEscalationSetup."Level 3";
        //  END ELSE IF irecClientInterHdr."Escalation Level No." = 4 THEN BEGIN
        //    lintEscalationHr := lrecEscalationSetup."Level 4";
        //  END ELSE IF irecClientInterHdr."Escalation Level No." = 5 THEN BEGIN
        //    lintEscalationHr  := lrecEscalationSetup."Level 5";
        //  END;
        //END;
        //EXIT(lintEscalationHr);

    end;
}

