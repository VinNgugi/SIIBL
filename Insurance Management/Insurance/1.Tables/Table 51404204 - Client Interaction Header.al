table 51404204 "Client Interaction Header" 
{
    // version AES-PAS 1.0

    // 
    // C001-RW 300810  : New table created for Complaint Incident
    // C002-RW 300810  : Code added On Insert and AssistEdit for No.series
    // C003-RW 300810  : Code added on validate triggers to update Complaint Category,Sub-Category,Resolution,Channel Names
    // C004-RW 300810  : New function created to insert record in Line table for history

   DrillDownPageID = 51404259;
   LookupPageID = 51404259;

    fields
    {
        field(1;"Interact Code";Code[20])
        {
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(2;"Date and Time";DateTime)
        {

            trigger OnValidate()
            begin

                "Last Updated Date and Time" :=  "Date and Time";
                MODIFY;
            end;
        }
        field(3;"Client No.";Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            begin

               recClient.GET("Client No.");
                "Client Name":=recClient.Name;
                //PIN:=recClient."P.I.N";
                IF recClient.Name='' THEN
                "Client Name" := recClient."First Name" + ' ' + recClient."Family Name";
               
            end;
        }
        field(4;"Interaction Type No.";Code[10])
        {
            TableRelation = "Interaction Type"."No." WHERE ("Interaction Type"=FIELD("Interaction Type"));

            trigger OnValidate()
            begin
                IF "Interaction Type No."<>'' THEN BEGIN
                    recInteractionType.SETRANGE(recInteractionType."No.","Interaction Type No.");
                    IF recInteractionType.FINDFIRST THEN
                    "Interaction Type Desc.":=recInteractionType.Description;
                     "Overall Level Duration":=recInteractionType."Escalation Expiration -Hrs";
                IF  recInteractionType."Escalation Expiration -Hrs"=0 THEN
                ERROR('Please Setup the Overall Level Duration hours in the Interaction Type List')
                END
                //ELSE
                //"Interaction Type Desc.":='';
            end;
        }
        field(5;"Interaction Cause No.";Code[10])
        {
            TableRelation = "Interaction Cause"."No." WHERE ("Interaction No."=FIELD("Interaction Type No."));

            trigger OnValidate()
            begin
                 IF "Interaction Cause No."<>'' THEN BEGIN
                    recInteractionCause.SETRANGE(recInteractionCause."No.","Interaction Cause No.");
                    IF recInteractionCause.FINDFIRST THEN
                      "Interaction Cause Desc.":=recInteractionCause.Description;
                      recResolution.SETRANGE(recResolution."Interaction No.","Interaction Type No.");
                      recResolution.SETRANGE(recResolution."Cause No.","Interaction Cause No.");
                        IF recResolution.FINDFIRST THEN
                        BEGIN
                          "Interaction Resolution No.":=recResolution."No.";
                          VALIDATE("Interaction Resolution No.");
                          recResolution.CALCFIELDS(recResolution.Descriptionx);
                          "Interaction Resol. Desc.":=recResolution.Descriptionx;
                          //MESSAGE('%1',recResolution.Description);
                        END;
                END ELSE
                "Interaction Cause Desc.":='';
            end;
        }
        field(7;"Interaction Resolution No.";Code[10])
        {
            Editable = true;
            TableRelation = "Interaction Resolution"."No." WHERE ("Interaction No."=FIELD("Interaction Type No."),
                                                                "Cause No."=FIELD("Interaction Cause No."));

            trigger OnValidate()
            begin
                 //Code for filling in the resolution steps for reference
                 IF "Interaction Resolution No."<>'' THEN
                   BEGIN
                    //CRMResolutionTaskStatus.SETCURRENTKEY(IRCode);
                   // CRMResolutionTaskStatus.SETRANGE(CRMResolutionTaskStatus.IRCode,"Interaction Resolution No.");
                    CRMResolutionTaskStatus.SETRANGE(CRMResolutionTaskStatus."Resolution Code","Interact Code");
                    CRMResolutionTaskStatus.DELETEALL;
                   END;
                //Add the steps for resolution.
                   BEGIN
                    CRMResolutionSteps.SETCURRENTKEY(IRCode);
                    CRMResolutionSteps.SETRANGE(CRMResolutionSteps.IRCode,"Interaction Resolution No.");
                        IF CRMResolutionSteps.FINDFIRST THEN
                          REPEAT
                          // process record
                          //MESSAGE('Goes through these steps');
                          CRMResolutionTaskStatus.INIT;
                          CRMResolutionTaskStatus."Resolution Code":="Interact Code";
                          CRMResolutionTaskStatus.IRCode:=CRMResolutionSteps.IRCode;
                          CRMResolutionTaskStatus."Step Number":=CRMResolutionSteps."Step Number";
                          CRMResolutionTaskStatus."Resolution Description":=CRMResolutionSteps."Resolution Description";
                         IF NOT  CRMResolutionTaskStatus.GET(CRMResolutionTaskStatus."Resolution Code",CRMResolutionTaskStatus.IRCode,
                         CRMResolutionTaskStatus."Step Number") THEN
                          CRMResolutionTaskStatus.INSERT;
                          UNTIL CRMResolutionSteps.NEXT = 0;
                   END;
            end;
        }
        field(8;Date;Date)
        {
        }
        field(10;Notes;Text[250])
        {
            TableRelation = "Interaction Type Nt".Notes WHERE ("Interaction Type No."=FIELD("Interaction Type No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                /*InteractionTypeNotes.RESET;
                InteractionTypeNotes.SETRANGE(InteractionTypeNotes."Interaction Type No.","Interaction Type No.");
                InteractionTypeNotes.SETRANGE(InteractionTypeNotes.Notes,Notes);
                IF InteractionTypeNotes.FINDFIRST THEN BEGIN
                 "Additional Notes" := InteractionTypeNotes."Additional Notes";
                 "Current Status" :=InteractionTypeNotes.Status;
                END;
                */

            end;
        }
        field(11;"User ID";Code[30])
        {
            Caption = 'Logged By';
            Editable = true;

            trigger OnValidate()
            begin
                  IF UserSetup.GET("User ID") THEN
                  BEGIN
                  // 18.04.21 "User Name":=UserSetup."Full Name";
                  //"Region Code" := UserSetup."Region Code";
                  VALIDATE("Region Code");
                  //"Branch Code" := UserSetup."Branch Code";
                  VALIDATE("Branch Code");
                 // "State Code" := UserSetup."State Code";
                  VALIDATE("State Code");
                 // "LGA Code" := UserSetup."LGA Code";
                  VALIDATE("LGA Code");
                  END
                  ELSE
                  BEGIN
                  LongUserCode:=FORMAT("User ID");
                  // UserShortCode:=LoginManagement.ShortUserID(LongUserCode);
                  IF UserSetup.GET(UserShortCode) THEN
                  BEGIN
                  //"User Name":=UserSetup."Full Name";
                  //"User Name":=UserSetup."Full Name";
                  //"Region Code" := UserSetup."Region Code";
                  VALIDATE("Region Code");
                  //"Branch Code" := UserSetup."Branch Code";
                  VALIDATE("Branch Code");
                  //"State Code" := UserSetup."State Code";
                  VALIDATE("State Code");
                  //"LGA Code" := UserSetup."LGA Code";
                  VALIDATE("LGA Code");
                  END


                  END;
            end;
        }
        field(12;"Current Status";Option)
        {
            Caption = 'Current Status';
            OptionCaption = 'Logged,Assigned,Escalated,Awaiting 3rd Party,Closed,Pending,Awaiting Client,Reopened,ReAssigned,Resolved';
            OptionMembers = Logged,Assigned,Escalated,"Awaiting 3rd Party",Closed,Pending,"Awaiting Client",Reopened,ReAssigned,Resolved;

            trigger OnValidate()
            begin
                Prevstatus:=xRec."Current Status";
                
                //interaction type complaint-status resolved
                IF ("Interaction Type"="Interaction Type"::Complaint) AND("Current Status"="Current Status"::Resolved) THEN BEGIN
                 IF "Root Cause Analysis"='' THEN
                    ERROR('Root cause analysis must have a value for you to mark the interaction as resolved');
                 IF "Reviewing Officer Remarks" ='' THEN
                    ERROR('Resolution remarks must have a value for you to mark the interaction as resolved');
                
                END;
                //Resolution remarks is amust for resolved
                IF "Current Status"="Current Status"::Resolved THEN BEGIN
                  IF "Reviewing Officer Remarks"='' THEN
                    ERROR('Resolution remarks must have a value for you to mark the interaction as resolved');
                
                END;
                
                //Get escalation hours as per the escalation setup for each channel
                CompInceHdr.RESET;
                CompInceHdr.SETFILTER(CompInceHdr."Current Status",'=%1|%2|%3',CompInceHdr."Current Status"::Assigned,CompInceHdr."Current Status"::Reopened,CompInceHdr."Current Status"::ReAssigned);
                CompInceHdr.SETFILTER(CompInceHdr."Escalation Clock",'<>%1',0DT);
                CompInceHdr.SETFILTER(CompInceHdr."Date and Time",'<>%1',0DT);
                CompInceHdr.SETFILTER(CompInceHdr."Interaction Channel",'<>%1','');
                CompInceHdr.SETFILTER(CompInceHdr."Interaction Type No.",'<>%1','');////added for interaction Type no}
                CompInceHdr.SETRANGE(CompInceHdr."Interact Code","Interact Code");
                IF CompInceHdr.FIND('-') THEN BEGIN
                IF CompInceHdr."Escalation Level No."< 3 THEN BEGIN
                    //Captured complaint registered date time, working hours
                    ComplaintCode := CompInceHdr."Interact Code";
                    CompInceDates :=  DT2DATE(CompInceHdr."Date and Time");
                    CompInceTimes :=  DT2TIME(CompInceHdr."Date and Time");
                    IF Chsetup.GET(CompInceHdr."Interaction Type No.")=TRUE THEN BEGIN
                      EscalateHrs:= CompInceHdr."Overall Level Duration";
                      IF EscalateHrs=0 THEN
                      ERROR('Please setup the Intercation Type hours inthe Intercation Setup');
                      TotWorkingHrs:= Chsetup."Day End Time" - Chsetup."Day Start Time";
                      //Need to define base calendar code in Service management setup to find working/non working day
                      SerMgtSetup.GET();
                     //18.04.21  WorkingDay := NOT CalendarMgmt.CheckDateStatus(SerMgtSetup."Base Calendar Code",CompInceDates,Description);
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
                         //18.04.21  WorkingDay :=NOT CalendarMgmt.CheckDateStatus(SerMgtSetup."Base Calendar Code",NextWorkingDate,Description);
                          IF WorkingDay THEN BEGIN
                            IF TotExpHrs >= TotWorkingHrs THEN
                              CurrentDayRemDurations := Chsetup."Day End Time"-Chsetup."Day Start Time"
                            ELSE
                              CurrentDayRemDurations := TotExpHrs;
                              EscExpiration := EscExpiration +  CurrentDayRemDurations;
                              TotExpHrs := TotExpHrs - CurrentDayRemDurations;
                           END;
                           UNTIL TotExpHrs <=0;
                           CompInceHdr."Escalation Expiration":=EscExpiration;
                           END;
                           END;
                           END;
                           END;
                
                         /*
                         IF "Current Status"="Current Status"::Resolved THEN BEGIN
                         IF "User ID"=USERID THEN
                         ERROR('You are not allowed to change this status');
                         END;
                         */
                         /*
                         IF "Current Status"="Current Status"::"Awaiting Client" THEN   BEGIN
                         IF USERID<>"User ID" THEN
                         ERROR('You are not allowed to change this status');
                         END;
                          */
                
                         IF "Current Status"="Current Status"::Reopened THEN   BEGIN
                         IF USERID<>"User ID" THEN
                         ERROR('You are not allowed to change this status');
                         END;
                
                         IF "Current Status"="Current Status"::Closed THEN  BEGIN
                         IF Created=TRUE THEN BEGIN
                
                         //IF "Reviewing Officer Remarks"<>'' THEN BEGIN
                         //ERROR('This interaction has not been resolved by the user');
                         ////IF "Assigned to User"=USERID THEN
                         ////ERROR('You are not allowed to change this status');
                         ////IF CONFIRM('Has this interaction been Resolved,'+"Interact Code"+'?')=TRUE THEN BEGIN
                
                         UsersRecs.RESET;
                         IF UsersRecs.GET("Assigned to User") THEN BEGIN
                         CCTo:=UsersRecs."E-Mail";
                          END;
                         IF recUserSetup.GET("User ID") THEN
                          BEGIN
                
                            txtLineDescription := 'Assigned to User ' + "Assigned to User";
                            InsertDetailLine('System','Assigned',txtLineDescription);
                            CompanyInformation.GET('');
                            ToName:=CCTo;
                            Subject:=STRSUBSTNO('Client Interaction %1',"Interact Code");
                            Body:="Assign Remarks";
                            SenderName:="Logged By Email";
                            IF "Assign Remarks"<>'' THEN
                              Body:="Assign Remarks"
                            ELSE
                            Body:='The Interaction has been Closed';
                            Body1:="Interact Code";
                            Body2:=FORMAT("Interaction Type");
                            Body3:="Interaction Type No.";
                            Body4:=Notes;
                            Body5:=EscExpiration;
                            Body6:="Client No." ;
                            Body7:="Client Name";
                
                            END;
                            AttachFileName:='';
                            OpenDialog:=TRUE;
                            SMPTPMail.CreateMessage(Recipients,SenderName,ToName,Subject,Body,TRUE);
                            //18.04.21 SMPTPMail.AddCC(recUserSetup."E-Mail");
                            lchar13 := 13;
                            lchar10 := 10;
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody('Interaction No.:');
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody(Body1);
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody('Interaction Type:');
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody(Body2);
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody('Interaction Type No.:');
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody(Body3);
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody('Client No.:');
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody(Body6);
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody('Client Name.:');
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody(Body7);
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                
                            SMPTPMail.AppendBody('Notes:');
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody(Body4);
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody('Interaction Expiration:');
                            SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                            SMPTPMail.AppendBody(FORMAT(Body5));
                            SMPTPMail.Send();
                          END;
                          /*
                          ELSE
                          ERROR('The Change has been Disregarded');
                          */
                          END;
                          ////END;
                          //END;
                
                
                         IF "Current Status"="Current Status"::ReAssigned THEN BEGIN
                         IF USERID<>"User ID" THEN
                         ERROR('You are not allowed to change this status');
                         IF CONFIRM('Do you want to Change the status of this interaction,'+"Interact Code"+'?')=TRUE THEN BEGIN
                         MESSAGE('Click on Create for the Validation of the Interaction ');
                          END
                          ELSE
                          ERROR('The Change has been Disregarded');
                           END;
                
                
                      /*   IF "Current Status"="Current Status"::Logged THEN BEGIN
                        ERROR('You are not allowed to select this Status')
                          END;
                
                         IF "Current Status"="Current Status"::Escalated THEN BEGIN
                         ERROR('You are not allowed to select this Status')
                          END;
                
                         IF "Current Status"="Current Status"::"Awaiting 3rd Party" THEN BEGIN
                         ERROR('You are not allowed to select this Status')
                          END;
                
                         IF "Current Status"="Current Status"::Pending THEN BEGIN
                         ERROR('You are not allowed to select this Status')
                          END;*/

            end;
        }
        field(13;"Assigned to User";Code[30])
        {
            TableRelation = User;

            trigger OnValidate()
            begin
                
                         IF Created=TRUE THEN BEGIN
                         IF "Current Status"="Current Status"::ReAssigned THEN BEGIN
                         //IF CONFIRM('Do you want to ReAssign this interaction,'+"Interact Code"+'?')=TRUE THEN BEGIN
                         UsersRecs.RESET;
                         IF UsersRecs.GET("Assigned to User") THEN BEGIN
                         CCTo:=UsersRecs."E-Mail";
                          END;
                         IF recUserSetup.GET("User ID") THEN
                          BEGIN
                          txtLineDescription := 'Assigned to User ' + "Assigned to User";
                          InsertDetailLine('System','Assigned',txtLineDescription);
                          CompanyInformation.GET('');
                          ToName:=CCTo;
                          Subject:=STRSUBSTNO('Client Interaction %1',"Interact Code");
                          Body:="Assign Remarks";
                          SenderName:="Logged By Email";
                          IF "Assign Remarks"<>'' THEN
                            Body:="Assign Remarks"
                          ELSE
                          Body:='The Interaction has been ReAssigned';
                          Body1:="Interact Code";
                          Body2:=FORMAT("Interaction Type");
                          Body3:="Interaction Type No.";
                          Body4:=Notes;
                          Body5:=EscExpiration;
                          Body6:="Client No." ;
                          Body7:="Client Name";
                
                          END;
                          AttachFileName:='';
                          OpenDialog:=TRUE;
                          SMPTPMail.CreateMessage(Recipients,SenderName,ToName,Subject,Body,TRUE);
                          //18.04.21 SMPTPMail.AddCC(recUserSetup."E-Mail");
                          lchar13 := 13;
                          lchar10 := 10;
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body1);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body2);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body3);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Client No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body6);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Client Name.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body7);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                
                          SMPTPMail.AppendBody('Notes:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body4);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Expiration:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(Body5));
                
                          SMPTPMail.Send();
                           END;
                           END;
                          //ELSE
                         // ERROR('The Change has been Disregarded');
                          // END;
                
                
                
                
                 /*
                 IF CONFIRM(STRSUBSTNO('Do you want to assign this interaction to %1?',"Assigned to User"), TRUE) THEN
                 BEGIN
                        //BEGIN
                        //IF "Assigned Flag" THEN
                        //  ERROR(Text002);
                        IF recUserSetup.GET("Assigned to User") THEN
                          BEGIN
                          txtLineDescription := 'Assigned to User ' + "Assigned to User";
                          InsertDetailLine('System','Assigned',txtLineDescription);
                          "Assigned Flag" := TRUE;
                          //Status := Status::Assigned;
                          //"Escalation Clock" := CURRENTDATETIME;
                          ToName:=recUserSetup."E-Mail";
                          CompanyInformation.GET('');
                          CCName:=CompanyInformation."E-Mail";
                          Subject:=STRSUBSTNO('Client Interaction %1',"Interact Code");
                          Body:="Assign Remarks";
                          IF "Assign Remarks"<>'' THEN
                            Body:="Assign Remarks"
                          ELSE
                          Body:='Please below is the Interaction Information';
                          Body1:="Interact Code";
                          Body2:=FORMAT("Interaction Type");
                          Body3:="Interaction Type No.";
                          Body4:=Notes;
                          Body5:=EscExpiration;
                          END;
                          AttachFileName:='';
                          OpenDialog:=TRUE;
                          SMPTPMail.CreateMessage(Recipients,SenderName,ToName,Subject,Body,TRUE);
                          SMPTPMail.AddCC(recUserSetup."E-Mail");
                          lchar13 := 13;
                          lchar10 := 10;
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body1);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body2);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body3);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Notes:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body4);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Expiration:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(Body5));
                          SMPTPMail.Send();
                
                  END;
                   */

            end;
        }
        field(14;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15;"Last Updated Date and Time";DateTime)
        {
            Editable = false;
        }
        field(16;"Escalation Level No.";Integer)
        {
            Editable = false;
        }
        field(17;"Interaction Channel";Code[20])
        {
            TableRelation = "Interaction Channel";

            trigger OnValidate()
            begin
                 /*
                Interactheader.SETRANGE("Interaction Channel","Interaction Channel");
                IF Interactheader.FIND('-') THEN
                ERROR('Interactheader already used');
                */

            end;
        }
        field(18;IsEscalated;Boolean)
        {
        }
        field(20;"Interaction Type Desc.";Text[100])
        {
            FieldClass = Normal;
        }
        field(30;"Interaction Cause Desc.";Text[200])
        {
        }
        field(50;"Interaction Type";Option)
        {
            OptionCaption = 'Request,Complaint,Enquiry,Observation,Outbound Calls';
            OptionMembers = Request,Complaint,Enquiry,Observation,"Outbound Calls";

            trigger OnValidate()
            begin

                IF xRec."Interaction Type"<>Rec."Interaction Type" THEN BEGIN
                "Interaction Type No.":='';
                //VALIDATE("Interaction Type No.");
                "Interaction Cause No.":='';
                VALIDATE("Interaction Cause No.");
                "Interaction Resolution No.":='';
                VALIDATE("Interaction Resolution No.");
                END;
            end;
        }
        field(60;"Assigned Flag";Boolean)
        {
        }
        field(61;"Escalation Level Name";Text[10])
        {
        }
        field(130;"Escalation Clock";DateTime)
        {
            Editable = false;
        }
        field(150;"Client Name";Text[100])
        {
        }
        field(155;"Client Feedback";Text[250])
        {

            trigger OnValidate()
            begin
                IF  USERID<>"User ID" THEN  BEGIN
                ERROR( 'You are not Allowed to edit the Client Feed Back information');
                END;
            end;
        }
        field(156;"Reviewing Officer Remarks";Text[250])
        {

            trigger OnValidate()
            begin
                IF "Current Status"="Current Status"::Resolved THEN BEGIN
                  IF "Reviewing Officer Remarks"='' THEN
                    ERROR('you cannot change resolution remarks to blank for resolved interaction');
                   END;
                //Get escalation hours as per the escalation setup for each channel
                CompInceHdr.RESET;
                ////CompInceHdr.SETFILTER(CompInceHdr."Current Status",'=%1|%2|%3',CompInceHdr."Current Status"::Assigned,CompInceHdr."Current Status"::Reopened,CompInceHdr."Current Status"::ReAssigned);
                CompInceHdr.SETFILTER(CompInceHdr."Escalation Clock",'<>%1',0DT);
                CompInceHdr.SETFILTER(CompInceHdr."Date and Time",'<>%1',0DT);
                CompInceHdr.SETFILTER(CompInceHdr."Interaction Channel",'<>%1','');
                CompInceHdr.SETFILTER(CompInceHdr."Interaction Type No.",'<>%1','');////added for interaction Type no
                CompInceHdr.SETRANGE(CompInceHdr."Interact Code","Interact Code");
                IF CompInceHdr.FIND('-') THEN BEGIN
                IF CompInceHdr."Escalation Level No."< 3 THEN BEGIN
                    //Captured complaint registered date time, working hours
                    ComplaintCode := CompInceHdr."Interact Code";
                    CompInceDates :=  DT2DATE(CompInceHdr."Date and Time");
                    CompInceTimes :=  DT2TIME(CompInceHdr."Date and Time");
                    IF Chsetup.GET(CompInceHdr."Interaction Type No.")=TRUE THEN BEGIN
                      EscalateHrs:= CompInceHdr."Overall Level Duration";
                      IF EscalateHrs=0 THEN
                      ERROR('Please setup the Intercation Type hours inthe Intercation Setup');
                      TotWorkingHrs:= Chsetup."Day End Time" - Chsetup."Day Start Time";
                      //Need to define base calendar code in Service management setup to find working/non working day
                      SerMgtSetup.GET();
                     //18.04.21  WorkingDay := NOT CalendarMgmt.CheckDateStatus(SerMgtSetup."Base Calendar Code",CompInceDates,Description);
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
                          //18.04.21 WorkingDay :=NOT CalendarMgmt.CheckDateStatus(SerMgtSetup."Base Calendar Code",NextWorkingDate,Description);
                          IF WorkingDay THEN BEGIN
                            IF TotExpHrs >= TotWorkingHrs THEN
                              CurrentDayRemDurations := Chsetup."Day End Time"-Chsetup."Day Start Time"
                            ELSE
                              CurrentDayRemDurations := TotExpHrs;
                              EscExpiration := EscExpiration +  CurrentDayRemDurations;
                              TotExpHrs := TotExpHrs - CurrentDayRemDurations;
                           END;
                           UNTIL TotExpHrs <=0;
                           CompInceHdr."Escalation Expiration":=EscExpiration;
                           END;
                           END;
                           END;
                           END;
                
                       /* IF "Current Status"<>"Current Status"::Resolved  THEN
                        ERROR('Status must be Resolved');
                        */
                       ////IF  USERID<>"Assigned to User" THEN  BEGIN
                       ////ERROR( 'You are not Allowed to edit the Reviewing Officer Remarks');
                       ////END;
                
                       /*  ResolutionStatus:='Resolved';
                         IF CONFIRM('Do you want to Change the status of this interaction,'+"Interact Code"+'?')=TRUE THEN BEGIN
                         UsersRecs.RESET;
                         IF UsersRecs.GET("Assigned to User") THEN BEGIN
                         CCTo:=UsersRecs."E-Mail";
                          END;
                         IF recUserSetup.GET("User ID") THEN
                          BEGIN
                          txtLineDescription := 'Assigned to User ' + "Assigned to User";
                          InsertDetailLine('System','Assigned',txtLineDescription);
                          CompanyInformation.GET('');
                          ToName:=CCTo;
                          Subject:=STRSUBSTNO('Client Interaction %1',"Interact Code");
                          Body:="Assign Remarks";
                          SenderName:="Logged By Email";
                          IF "Assign Remarks"<>'' THEN
                            Body:="Assign Remarks"
                          ELSE
                          Body:='The Interaction has been Resolved';
                          Body1:="Interact Code";
                          Body2:=FORMAT("Interaction Type");
                          Body3:="Interaction Type No.";
                          Body4:=Notes;
                          Body5:=EscExpiration;
                          Body6:="Client No." ;
                          Body7:="Client Name";
                
                          END;
                          AttachFileName:='';
                          OpenDialog:=TRUE;
                          SMPTPMail.CreateMessage(Recipients,SenderName,ToName,Subject,Body,TRUE);
                          SMPTPMail.AddCC(recUserSetup."E-Mail");
                          lchar13 := 13;
                          lchar10 := 10;
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body1);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body2);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body3);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Client No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body6);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Client Name.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body7);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                
                          SMPTPMail.AppendBody('Notes:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body4);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Expiration:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(Body5));
                          SMPTPMail.Send();
                          END
                          ELSE BEGIN
                          //"Current Status":=Prevstatus;
                          "Reviewing Officer Remarks":=xRec."Reviewing Officer Remarks";
                          MESSAGE('The Change has been Disregarded');
                          END
                          */
                          //END;
                          //MESSAGE(FORMAT(Body5));

            end;
        }
        field(157;"Major Category";Option)
        {
            OptionCaption = 'Client Services,Contact Centre,Complaints Bureau';
            OptionMembers = "Client Services","Contact Centre","Complaints Bureau";
        }
        field(158;"Interaction Resol. Desc.";Text[80])
        {
        }
        field(159;"Region Code";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FILTER('REGION'));

            trigger OnValidate()
            begin
                //recDimension.SETRANGE(recDimension.Code,'REGION');
                IF recDimension.GET('REGION',"Region Code") THEN
                  "Region Name":=recDimension.Name;
            end;
        }
        field(160;"Region Name";Text[50])
        {
        }
        field(161;"State Code";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FILTER('STATES'));

            trigger OnValidate()
            begin
                //recDimension.SETRANGE(recDimension.Code,'STATES');
                IF recDimension.GET('STATES',"State Code") THEN
                  "State Name":=recDimension.Name;
            end;
        }
        field(162;"State Name";Text[50])
        {
        }
        field(163;"LGA Code";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FILTER('LOCALGOVT'));

            trigger OnValidate()
            begin
                // recDimension.SETRANGE(recDimension.Code,'LOCALGOVT');
                 IF recDimension.GET('LOCALGOVT',"LGA Code") THEN
                  "LGA Name":=recDimension.Name;
            end;
        }
        field(164;"LGA Name";Text[50])
        {
        }
        field(165;"Branch Code";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('BRANCH'));

            trigger OnValidate()
            begin
                // recDimension.SETRANGE(recDimension.Code,'BRANCH');
                 IF recDimension.GET('BRANCH',"Branch Code") THEN
                 "Branch Description":=recDimension.Name;
            end;
        }
        field(166;"Branch Description";Text[50])
        {
        }
        field(167;"Assign Remarks";Text[250])
        {

            trigger OnValidate()
            begin
                //Get escalation hours as per the escalation setup for each channel
                CompInceHdr.RESET;
                CompInceHdr.SETFILTER(CompInceHdr."Current Status",'=%1|%2|%3',CompInceHdr."Current Status"::Assigned,CompInceHdr."Current Status"::Reopened,CompInceHdr."Current Status"::ReAssigned);
                CompInceHdr.SETFILTER(CompInceHdr."Escalation Clock",'<>%1',0DT);
                CompInceHdr.SETFILTER(CompInceHdr."Date and Time",'<>%1',0DT);
                CompInceHdr.SETFILTER(CompInceHdr."Interaction Channel",'<>%1','');
                CompInceHdr.SETFILTER(CompInceHdr."Interaction Type No.",'<>%1','');////added for interaction Type no}

                CompInceHdr.SETRANGE(CompInceHdr."Interact Code","Interact Code");
                IF CompInceHdr.FIND('-') THEN BEGIN
                IF CompInceHdr."Escalation Level No."< 3 THEN BEGIN
                    //Captured complaint registered date time, working hours
                    ComplaintCode := CompInceHdr."Interact Code";
                    CompInceDates :=  DT2DATE(CompInceHdr."Date and Time");
                    CompInceTimes :=  DT2TIME(CompInceHdr."Date and Time");
                    IF Chsetup.GET(CompInceHdr."Interaction Type No.")=TRUE THEN BEGIN
                      EscalateHrs:= CompInceHdr."Overall Level Duration";
                      IF EscalateHrs=0 THEN
                      ERROR('Please setup the Intercation Type hours inthe Intercation Setup');
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
                          //18.04.21 WorkingDay :=NOT CalendarMgmt.CheckDateStatus(SerMgtSetup."Base Calendar Code",NextWorkingDate,Description);
                          IF WorkingDay THEN BEGIN
                            IF TotExpHrs >= TotWorkingHrs THEN
                              CurrentDayRemDurations := Chsetup."Day End Time"-Chsetup."Day Start Time"
                            ELSE
                              CurrentDayRemDurations := TotExpHrs;
                              EscExpiration := EscExpiration +  CurrentDayRemDurations;
                              TotExpHrs := TotExpHrs - CurrentDayRemDurations;
                           END;
                           UNTIL TotExpHrs <=0;
                           CompInceHdr."Escalation Expiration":=EscExpiration;
                           END;
                           END;
                           END;
                           END;

                IF "Current Status" ="Current Status"::Closed THEN BEGIN
                IF ("Interaction Type" = "Interaction Type"::Request) AND ("Interaction Type No." = '')  THEN
                 ERROR('Interaction type and Interaction Type No. are compulsory, please select a value')
                 ELSE IF ("Interaction Type" <> "Interaction Type"::Request) AND ("Interaction Type No." = '') THEN
                 ERROR('Interaction type No is compulsory, please select a value');
                 //ELSE IF ("Interaction Type" = "Interaction Type"::Request) AND ("Interaction Type No." <> '') THEN
                 //ERROR('Interaction type is compulsory, please select a value');
                END;

                IF "Current Status" = "Current Status"::Assigned THEN BEGIN
                IF ("Interaction Type" = "Interaction Type"::Request) AND ("Interaction Type No." = '')  THEN
                 ERROR('Interaction type and Interaction Type No. are compulsory, please select a value')
                 ELSE IF ("Interaction Type" <> "Interaction Type"::Request) AND ("Interaction Type No." = '') THEN
                 ERROR('Interaction type No is compulsory, please select a value');
                 //ELSE IF ("Interaction Type" = "Interaction Type"::Request) AND ("Interaction Type No." <> '') THEN
                 //ERROR('Interaction type is compulsory, please select a value');
                END;
                        //IF Created=TRUE THEN BEGIN
                        IF "Current Status"="Current Status"::Assigned THEN BEGIN
                         UsersRecs.RESET;
                         IF UsersRecs.GET("Assigned to User") THEN
                         CCTo:=UsersRecs."E-Mail";
                         IF recUserSetup.GET("User ID") THEN
                          BEGIN
                          txtLineDescription := 'Assigned to User ' + "Assigned to User";
                          InsertDetailLine('System','Assigned',txtLineDescription);
                          CompanyInformation.GET('');
                          ToName:=(CCTo);
                          Subject:=STRSUBSTNO('Client Interaction %1',"Interact Code");
                          Body:="Assign Remarks";
                          SenderName:="Logged By Email";
                          IF "Assign Remarks"<>'' THEN
                            Body:="Assign Remarks"
                          ELSE
                          Body:='The Interaction has been Assigned';
                          Body1:="Interact Code";
                          Body2:=FORMAT("Interaction Type");
                          Body3:="Interaction Type No.";
                          Body4:=Notes;
                          Body5:=EscExpiration;
                          Body6:="Client No." ;
                          Body7:="Client Name";
                          END;
                          AttachFileName:='';
                          OpenDialog:=TRUE;
                          SMPTPMail.CreateMessage(Recipients,SenderName,ToName,Subject,Body,TRUE);
                          //18.04.21 SMPTPMail.AddCC(recUserSetup."E-Mail");
                          lchar13 := 13;
                          lchar10 := 10;
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body1);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body2);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body3);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));

                          SMPTPMail.AppendBody('Client No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body6);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Client Name.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body7);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));

                          SMPTPMail.AppendBody('Notes:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body4);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Expiration:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(Body5));
                          SMPTPMail.Send();
                           //END;
                           END;

                         IF Created=TRUE THEN BEGIN
                         IF "Current Status"="Current Status"::ReAssigned THEN BEGIN
                         UsersRecs.RESET;
                         IF UsersRecs.GET("Assigned to User") THEN
                         CCTo:=UsersRecs."E-Mail";
                         IF recUserSetup.GET("User ID") THEN
                          BEGIN
                          txtLineDescription := 'Assigned to User ' + "Assigned to User";
                          InsertDetailLine('System','Assigned',txtLineDescription);
                          CompanyInformation.GET('');
                          ToName:=(CCTo);
                          Subject:=STRSUBSTNO('Client Interaction %1',"Interact Code");
                          Body:="Assign Remarks";
                          SenderName:="Logged By Email";
                          IF "Assign Remarks"<>'' THEN
                            Body:="Assign Remarks"
                          ELSE
                          Body:='The Interaction has been ReAssigned';
                          Body1:="Interact Code";
                          Body2:=FORMAT("Interaction Type");
                          Body3:="Interaction Type No.";
                          Body4:=Notes;
                          Body5:=EscExpiration;
                          Body6:="Client No." ;
                          Body7:="Client Name";

                          END;
                          AttachFileName:='';
                          OpenDialog:=TRUE;
                          SMPTPMail.CreateMessage(Recipients,SenderName,ToName,Subject,Body,TRUE);
                          //18.04.21 SMPTPMail.AddCC(recUserSetup."E-Mail");
                          lchar13 := 13;
                          lchar10 := 10;
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body1);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body2);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body3);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));

                          SMPTPMail.AppendBody('Client No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body6);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Client Name.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body7);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));

                          SMPTPMail.AppendBody('Notes:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body4);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Expiration:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(Body5));
                          SMPTPMail.Send();
                           END;
                           END;

                         IF Created=TRUE THEN BEGIN
                         IF "Current Status"="Current Status"::Closed THEN BEGIN
                         UsersRecs.RESET;
                         IF UsersRecs.GET("Assigned to User") THEN BEGIN
                         CCTo:=UsersRecs."E-Mail";
                          END;
                         IF recUserSetup.GET("User ID") THEN
                          BEGIN
                          txtLineDescription := 'Assigned to User ' + "Assigned to User";
                          InsertDetailLine('System','Assigned',txtLineDescription);
                          CompanyInformation.GET('');
                          ToName:=CCTo;
                          Subject:=STRSUBSTNO('Client Interaction %1',"Interact Code");
                          Body:="Assign Remarks";
                          SenderName:="Logged By Email";
                          IF "Assign Remarks"<>'' THEN
                            Body:="Assign Remarks"
                          ELSE
                          Body:='The Interaction has been Closed';
                          Body1:="Interact Code";
                          Body2:=FORMAT("Interaction Type");
                          Body3:="Interaction Type No.";
                          Body4:=Notes;
                          Body5:=EscExpiration;
                          Body6:="Client No." ;
                          Body7:="Client Name";


                          END;
                          AttachFileName:='';
                          OpenDialog:=TRUE;
                          SMPTPMail.CreateMessage(Recipients,SenderName,ToName,Subject,Body,TRUE);
                          //18.04.21 SMPTPMail.AddCC(recUserSetup."E-Mail");
                          lchar13 := 13;
                          lchar10 := 10;
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body1);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body2);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body3);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Client No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body6);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Client Name.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body7);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));

                          SMPTPMail.AppendBody('Notes:');

                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body4);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Expiration:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(Body5));
                          SMPTPMail.Send();
                           END;
                           END;
            end;
        }
        field(168;"Unit Assigned";Code[10])
        {
        }
        field(169;"Date In Letter";Date)
        {
        }
        field(170;"Date of Interaction";Date)
        {
        }
        field(171;"Channel Sub Type";Code[20])
        {
            TableRelation = "Interactions Sub Channel".Code WHERE ("Channel Code"=FIELD("Interaction Channel"));
        }
        field(172;Category;Code[20])
        {
            TableRelation = "Interaction Category";
        }
        field(173;PIN;Code[40])
        {

            trigger OnValidate()
            begin
                //"Client No.":=PenCalc.GetClientID(PIN);
                //VALIDATE("Client No.");
            end;
        }
        field(174;"Action Date";Date)
        {
        }
        field(175;"Checked Date";Date)
        {
        }
        field(176;"Bulk Logged";Boolean)
        {
        }
        field(177;"Bulk Header No";Code[20])
        {
        }
        field(178;"Additional Notes";Text[250])
        {
        }
        field(179;"User Name";Text[150])
        {
        }
        field(180;"Overall Level Duration";Integer)
        {
        }
        field(181;"Assigned To User Name";Text[50])
        {
        }
        field(50000;"Escalation Expiration";DateTime)
        {
        }
        field(50001;"Logged By Name";Text[50])
        {
        }
        field(50002;"Reopening Remarks";Text[200])
        {

            trigger OnValidate()
            begin

                //Get escalation hours as per the escalation setup for each channel
                CompInceHdr.RESET;
                ////CompInceHdr.SETFILTER(CompInceHdr."Current Status",'=%1|%2|%3',CompInceHdr."Current Status"::Assigned,CompInceHdr."Current Status"::Reopened,CompInceHdr."Current Status"::ReAssigned);
                CompInceHdr.SETFILTER(CompInceHdr."Escalation Clock",'<>%1',0DT);
                CompInceHdr.SETFILTER(CompInceHdr."Date and Time",'<>%1',0DT);
                CompInceHdr.SETFILTER(CompInceHdr."Interaction Channel",'<>%1','');
                CompInceHdr.SETFILTER(CompInceHdr."Interaction Type No.",'<>%1','');////added for interaction Type no}

                CompInceHdr.SETRANGE(CompInceHdr."Interact Code","Interact Code");
                IF CompInceHdr.FIND('-') THEN BEGIN
                IF CompInceHdr."Escalation Level No."< 3 THEN BEGIN
                    //Captured complaint registered date time, working hours
                    ComplaintCode := CompInceHdr."Interact Code";
                    CompInceDates :=  DT2DATE(CompInceHdr."Date and Time");
                    CompInceTimes :=  DT2TIME(CompInceHdr."Date and Time");
                    IF Chsetup.GET(CompInceHdr."Interaction Type No.")=TRUE THEN BEGIN
                      EscalateHrs:= CompInceHdr."Overall Level Duration";
                      IF EscalateHrs=0 THEN
                      ERROR('Please setup the Intercation Type hours inthe Intercation Setup');
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
                          // 18.04.21 WorkingDay :=NOT CalendarMgmt.CheckDateStatus(SerMgtSetup."Base Calendar Code",NextWorkingDate,Description);
                          IF WorkingDay THEN BEGIN
                            IF TotExpHrs >= TotWorkingHrs THEN
                              CurrentDayRemDurations := Chsetup."Day End Time"-Chsetup."Day Start Time"
                            ELSE
                              CurrentDayRemDurations := TotExpHrs;
                              EscExpiration := EscExpiration +  CurrentDayRemDurations;
                              TotExpHrs := TotExpHrs - CurrentDayRemDurations;
                           END;
                           UNTIL TotExpHrs <=0;
                           CompInceHdr."Escalation Expiration":=EscExpiration;
                           END;
                           END;
                           END;
                           END;

                        IF "Current Status"<>"Current Status"::Reopened  THEN
                        ERROR('Status must be Reopened');

                        ////IF USERID<> "User ID" THEN BEGIN
                        ////ERROR('You are not allowed to edit this Remarks')
                        ////END;


                         IF Created=TRUE THEN BEGIN
                         IF "Current Status"="Current Status"::Reopened THEN   BEGIN
                         IF USERID<>"User ID" THEN
                         ERROR('You are not allowed to change this status');
                         IF CONFIRM('Do you want to Change the status of this interaction,'+"Interact Code"+'?')=TRUE THEN BEGIN
                         UsersRecs.RESET;
                         IF UsersRecs.GET("Assigned to User") THEN BEGIN
                         CCTo:=UsersRecs."E-Mail";
                          END;
                         IF recUserSetup.GET("User ID") THEN
                          BEGIN
                          txtLineDescription := 'Assigned to User ' + "Assigned to User";
                          InsertDetailLine('System','Assigned',txtLineDescription);
                          CompanyInformation.GET('');
                          ToName:=CCTo;
                          Subject:=STRSUBSTNO('Client Interaction %1',"Interact Code");
                          Body:="Assign Remarks";
                          SenderName:="Logged By Email";
                          IF "Assign Remarks"<>'' THEN
                            Body:="Assign Remarks"
                          ELSE
                          Body:='The Interaction has been Reopened';
                          Body1:="Interact Code";
                          Body2:=FORMAT("Interaction Type");
                          Body3:="Interaction Type No.";
                          Body4:=Notes;
                          Body5:=EscExpiration;
                          END;
                          AttachFileName:='';
                          OpenDialog:=TRUE;
                          SMPTPMail.CreateMessage(Recipients,SenderName,ToName,Subject,Body,TRUE);
                          //18.04.21 SMPTPMail.AddCC(recUserSetup."E-Mail");
                          lchar13 := 13;
                          lchar10 := 10;
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body1);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body2);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body3);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Notes:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body4);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Expiration:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(Body5));
                          SMPTPMail.Send();
                          END
                          ELSE
                          ERROR('The Change has been Disregarded');
                          END;
                          END;
            end;
        }
        field(50003;"Assign Remarks1";Text[50])
        {

            trigger OnValidate()
            begin
                /*
                IF "Current Status"="Current Status"::Assigned THEN
                 BEGIN
                        //BEGIN
                        //IF "Assigned Flag" THEN
                        //  ERROR(Text002);
                        IF recUserSetup.GET("User ID") THEN
                          BEGIN
                          txtLineDescription := 'Assigned to User ' + "Assigned to User";
                          InsertDetailLine('System','Assigned',txtLineDescription);
                          ////"Assigned Flag" := TRUE;
                         ////"Current Status" := "Current Status"::Assigned;
                          CompanyInformation.GET('');
                          CCName:=CompanyInformation."E-Mail";
                
                          ToName:=recUserSetup."E-Mail"+';'+CompanyInformation."E-Mail";
                
                          Subject:=STRSUBSTNO('Client Interaction %1',"Interact Code");
                          Body:="Assign Remarks";
                          SenderName:=recUserSetup."E-Mail";
                          Recipients:=CompanyInformation."E-Mail";
                
                          IF "Assign Remarks"<>'' THEN
                            Body:="Assign Remarks"
                          Body:='The Interaction has been Assigned';
                          Body1:="Interact Code";
                          Body2:=FORMAT("Interaction Type");
                          Body3:="Interaction Type No.";
                          Body4:=Notes;
                          Body5:=EscExpiration;
                          END;
                          AttachFileName:='';
                          OpenDialog:=TRUE;
                          SMPTPMail.CreateMessage(Recipients,SenderName,ToName,Subject,Body,TRUE);
                          SMPTPMail.AddCC(recUserSetup."E-Mail");
                          lchar13 := 13;
                          lchar10 := 10;
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body1);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body2);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Type No.:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body3);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Notes:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(Body4);
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody('Interaction Expiration:');
                          SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                          SMPTPMail.AppendBody(FORMAT(Body5));
                          SMPTPMail.Send();
                          ELSE
                
                  END;
                   */

            end;
        }
        field(50004;"Logged By Email";Text[50])
        {
        }
        field(50005;"Assigned By Email";Text[50])
        {
        }
        field(50006;"Interaction Expiration";DateTime)
        {
        }
        field(50007;ResolutionStatus;Text[30])
        {
        }
        field(50008;"Interaction Status Modified By";Text[30])
        {
        }
        field(50009;"Interaction Modified DateTime";DateTime)
        {
        }
        field(50010;Created;Boolean)
        {
        }
        field(50011;"Root Cause Analysis";Text[150])
        {

            trigger OnValidate()
            begin
                IF "Current Status"="Current Status"::Resolved THEN BEGIN
                  IF "Root Cause Analysis"='' THEN
                  ERROR('you cannot change root cause analysis to blank for resolved interaction');
                END;
            end;
        }
        field(50012;"Client  Notified";Boolean)
        {
            Editable = false;
        }
        field(50013;"Created by K2";Boolean)
        {
        }
        field(50014;"Risk Indicator";Option)
        {
            OptionCaption = ' ,GREEN,AMBER,RED';
            OptionMembers = " ",GREEN,AMBER,RED;
        }
        field(50015;"RM Group";Code[30])
        {
            Editable = false;
        }
        field(50016;"RM Code";Code[30])
        {
        }
        field(50017;NewDoc;Boolean)
        {
        }
        field(50018;"Satisfaction Level";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Very Satisfied,Satisfied,OK, Disatisfied,Very Disatisfied';
            OptionMembers = " ","Very Satisfied",Satisfied,OK," Disatisfied","Very Disatisfied";
        }
    }

    keys
    {
        key(Key1;"Interact Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //IF "Assigned Flag" THEN
        //  ERROR(Text002);

        ERROR('You cannot delete this record');

        CompInceLine.RESET;
        CompInceLine.SETRANGE(CompInceLine."Client Interaction No.","Interact Code");
        CompInceLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        //C002
        IF "Interact Code" = '' THEN BEGIN
          IF recInteractionsSetup.FINDFIRST THEN BEGIN
             recInteractionsSetup.TESTFIELD(recInteractionsSetup."Client Interaction Header Nos");
             NoSeriesMgt.InitSeries(recInteractionsSetup."Client Interaction Header Nos",xRec."No. Series",0D,"Interact Code","No. Series");
          END;
        END;

        IF GETFILTER("Client No.") <> '' THEN
          IF GETRANGEMIN("Client No.") = GETRANGEMAX("Client No.") THEN
            VALIDATE("Client No.",GETRANGEMIN("Client No."));


        "User ID" := USERID;
        VALIDATE("User ID");

        UserRec.RESET;
        UserRec.SETRANGE(UserRec."User Name","User ID");
         IF UserRec.FIND('-') THEN
           "Logged By Name":=UserRec."Full Name";
           "Logged By Email":=UserRec."Authentication Email";


        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID","User ID");
         IF UserSetup.FIND('-') THEN
           "Logged By Email":=UserSetup."E-Mail";


        "Date and Time" := CURRENTDATETIME;
        "Last Updated Date and Time" :=  CURRENTDATETIME;
        "Escalation Clock":=CURRENTDATETIME;
        //"Escalation Expiration":=CURRENTDATETIME;
        //C002
        Prevstatus:=Rec."Current Status";
    end;

    trigger OnModify()
    begin
        "Last Updated Date and Time" := CURRENTDATETIME;

        IF "Current Status"="Current Status"::Resolved THEN BEGIN
        IF "Satisfaction Level" = "Satisfaction Level"::" " THEN BEGIN
          ERROR('Please fill in the satisfaction level')
          END;
        "Interaction Status Modified By":=USERID;
        "Interaction Modified DateTime":=CURRENTDATETIME;
        END;
    end;

    var
        recInteractionsSetup: Record "Interactions Setup";
        NoSeriesMgt: Codeunit 396;
        recClientInteractLine: Record "Client Interaction Line";
        recInteractionType: Record "Interaction Type";
        recInteractionCause: Record "Interaction Cause";
        recResolution: Record "Interaction Resolution";
        recUserSetup: Record 91;
        ComplaintLine: Record "Client Interaction Line";
        CompChannel: Record "Interaction Channel";
        CompInceLine: Record "Client Interaction Line";
        Text001: Label 'Status cannot be manually changed to Escalated!';
        Text002: Label 'Assigned Interactions cannot be deleted';
        txtLineDescription: Text[250];
        recClient: Record 18;
        Text003: Label 'There is no Step %1 to be %2';
        CRMResolutionSteps: Record "Resolution Steps";
        CRMResolutionTaskStatus: Record "Resolution of tasks status";
        //NavMail: Codeunit 397;
        SMPTPMail: Codeunit "SMTP Mail";
        ToName: Text[200];
        CCName: Text[60];
        Subject: Text[250];
        Body: Text[250];
        Body1: Text[50];
        Body2: Text[50];
        Body3: Text[50];
        Body4: Text[250];
        Body5: DateTime;
        Body6: Text[250];
        Body7: Text[250];
        AttachFileName: Text[250];
        OpenDialog: Boolean;
        recDimension: Record 349;
        CompanyInformation: Record 79;
        //Smtp: Codeunit 400;
        //States: Record 51405214;
        //LGA: Record 51405213;
        //PenCalc: Codeunit "51403000";
        UserSetup: Record 91;
        LoginManagement: Codeunit 418;
        UserShortCode: Code[20];
        LongUserCode: Text[120];
        Interactheader: Record "Client Interaction Header";
        UserRec: Record User;
        AssignedName: Text[50];
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
        ldttmCurrentDateAndEndTime: DateTime;
        Chsetup: Record "Interaction Type";
        EscExpiration: DateTime;
        CompInceDates: Date;
        CompInceTimes: Time;
        CurrentDayRemDurations: Duration;
        ldttmCurrentDateAndEndTimes: DateTime;
        ComplaintCode: Code[10];
        Emalili: Text[50];
        Mailing: Text[50];
        SenderName: Text[50];
        Recipients: Text[50];
        SenderAddress: Text[50];
        AddToEmail: Text[50];
        UsersRecs: Record "User Setup";
        CCTo: Text[50];
        lchar13: Char;
        lchar10: Char;
        Test: Text[30];
        Prevstatus: Integer;
        vendor: Record 18;
        InteractionTypeNotes: Record "Interaction Type Nt";

    procedure AssistEdit(OldInce: Record "Client Interaction Header"): Boolean
    var
        Ince: Record "Client Interaction Header";
    begin
        //C002
        WITH Ince DO BEGIN
          Ince := Rec;
          IF recInteractionsSetup.FINDFIRST THEN BEGIN
          recInteractionsSetup.TESTFIELD(recInteractionsSetup."Client Interaction Header Nos");
          IF NoSeriesMgt.SelectSeries(recInteractionsSetup."Client Interaction Header Nos",OldInce."No. Series","No. Series") THEN BEGIN
            recInteractionsSetup.TESTFIELD(recInteractionsSetup."Client Interaction Header Nos");
            NoSeriesMgt.SetSeries("Interact Code");
            Rec := Ince;
            EXIT(TRUE);
          END;
          END;
        END;
        //C002
    end;

    procedure InsertDetailLine(ptxtLineType: Text[30];ptxtActionType: Text[30];ptxtDescription: Text[250])
    var
        lintLineNo: Integer;
        lClIntHdr: Record "Client Interaction Header";
    begin
        //C004
        recClientInteractLine.RESET;
        recClientInteractLine.SETRANGE("Client Interaction No.","Interact Code");
        IF recClientInteractLine.FINDLAST THEN
          lintLineNo := recClientInteractLine."Line No." + 10000
        ELSE lintLineNo := 10000;
        
        recClientInteractLine.INIT;
        recClientInteractLine."Client Interaction No." := "Interact Code";
        recClientInteractLine."Line No." := lintLineNo;
        EVALUATE(recClientInteractLine."Line Type",ptxtLineType);
        EVALUATE(recClientInteractLine."Action Type",ptxtActionType);
        recClientInteractLine."User ID-" := USERID;
        recClientInteractLine."Date and Time" := CURRENTDATETIME;
        recClientInteractLine.Description := ptxtDescription;
        recClientInteractLine.INSERT;
        
        IF (ptxtActionType = 'Assigned')
        OR (ptxtActionType = 'Escalated')
        OR (ptxtActionType = 'Response Out')
        OR (ptxtActionType = 'Reply In') THEN
         // "Escalation Clock" := CURRENTDATETIME;
        
        IF ptxtActionType = 'Response Out' THEN
          "Current Status" := "Current Status"::"Awaiting 3rd Party";
        
        IF ptxtActionType = 'Reply In' THEN
          IF "Escalation Level No." > 0 THEN
            "Current Status" := "Current Status"::Escalated
          ELSE
            "Current Status" := "Current Status"::Assigned;
        
        IF ptxtActionType = 'Closed' THEN
          "Current Status" := "Current Status"::Closed;
        
        "Last Updated Date and Time" := CURRENTDATETIME;
        
        MODIFY;
        
        
        
        
        /*
        ComplaintLine.RESET;
        ComplaintLine.INIT;
        ComplaintLine."Line No." := GetNextLineNo(ComplaintLine,FALSE);
        ComplaintLine."Client Interaction No." := "No.";
        ComplaintLine."Client Code" := "Client No.";
        ComplaintLine."User Id (Reg. By)" := "User ID";
        ComplaintLine."Assigned to User" := "Assigned to User";
        ComplaintLine.Status := Status;
        ComplaintLine."Escalation Level No." := "Escalation Level No.";
        ComplaintLine.Notes := Notes;
        ComplaintLine.INSERT;
        */
        //C004

    end;

    procedure GetNextLineNo(CompLine: Record "Client Interaction Line";BelowxRec: Boolean): Integer
    var
        CompLine2: Record "Client Interaction Line";
        LoLineNo: Integer;
        HiLineNo: Integer;
        NextLineNo: Integer;
        LineStep: Integer;
    begin
        NextLineNo := 0;
        LineStep := 10000;
        CompLine2.RESET;
        CompLine2.SETRANGE("Client Interaction No.","Interact Code");
        IF CompLine2.FINDLAST THEN
          NextLineNo := CompLine2."Line No." + LineStep
        ELSE
          NextLineNo := LineStep;

        EXIT(NextLineNo);
    end;
}

