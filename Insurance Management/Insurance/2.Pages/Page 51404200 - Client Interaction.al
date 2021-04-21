page 51404200 "Client Interaction"
{
    // version AES-PAS 1.0

    DeleteAllowed = true;
    InsertAllowed = true;
    PageType = Card;
    SourceTable = "Client Interaction Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Client No."; "Client No.")
                {
                    Editable = true;
                }
                field(PIN; PIN)
                {
                }
                field("Client Name"; "Client Name")
                {
                    Editable = false;
                }
                field("Region Code"; "Region Code")
                {
                    Editable = true;
                }
                field("Region Name"; "Region Name")
                {
                    Editable = false;
                }
                field("State Code"; "State Code")
                {
                    Editable = true;
                }
                field("State Name"; "State Name")
                {
                    Editable = false;
                }
                field("LGA Code"; "LGA Code")
                {
                    Editable = true;
                }
                field("LGA Name"; "LGA Name")
                {
                    Editable = false;
                }
                field("Branch Code"; "Branch Code")
                {
                    Editable = true;
                }
                field("Branch Description"; "Branch Description")
                {
                    Editable = false;
                }
                field("Interact Code"; "Interact Code")
                {
                    Editable = false;
                }
                field("Date and Time"; "Date and Time")
                {
                    Editable = false;
                }
                field("Interaction Channel"; "Interaction Channel")
                {
                }
                field("Interaction Type"; "Interaction Type")
                {
                }
                field("Interaction Type No."; "Interaction Type No.")
                {
                    TableRelation = "Interaction Type".Status WHERE(Status = CONST(Active));

                    trigger OnValidate()
                    begin
                        //VALIDATE("User ID")
                    end;
                }
                field("Interaction Type Desc."; "Interaction Type Desc.")
                {
                    Editable = false;
                }
                field("Interaction Cause No."; "Interaction Cause No.")
                {
                }
                field("Interaction Cause Desc."; "Interaction Cause Desc.")
                {
                }
                field("Interaction Resolution No."; "Interaction Resolution No.")
                {
                }
                field("Interaction Resol. Desc."; "Interaction Resol. Desc.")
                {
                }
                field("User ID"; "User ID")
                {
                    Editable = false;
                }
                field("Logged By Name"; "Logged By Name")
                {
                    Editable = false;
                }
                field("Current Status"; "Current Status")
                {
                    OptionCaption = 'Logged,Assigned,Escalated,Awaiting 3rd Party,Closed,Pending,Awaiting Client,Reopened,ReAssigned,Resolved';

                    trigger OnValidate()
                    begin
                        /*IF "Current Status"="Current Status"::Assigned THEN
                        ERROR('You are not allowed to select Assigned');
                        */

                        /*
                        IF "Current Status"="Current Status"::"Awaiting Client" THEN BEGIN
                        ERROR('You are not allowed to select this Status')
                        END;
                        */

                    end;
                }
                field("Assigned to User"; "Assigned to User")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        /*IF "Current Status"<>"Current Status"::ReAssigned THEN
                        ERROR('Status must be ReAssigned');
                          */
                        CurrUser.RESET;
                        CurrUser.SETRANGE(CurrUser.Company, COMPANYNAME);
                        IF PAGE.RUNMODAL(51404529, CurrUser) = ACTION::LookupOK THEN BEGIN
                            CurrUser.CALCFIELDS("User ID");
                            "Assigned to User" := CurrUser."User ID";
                            //"Assigned To User Name":=CurrUser."Full Name";
                        END

                    end;

                    trigger OnValidate()
                    begin
                        CurrUser.RESET;
                        CurrUser.SETRANGE(CurrUser.Company, COMPANYNAME);
                        IF PAGE.RUNMODAL(51404529, CurrUser) = ACTION::LookupOK THEN BEGIN
                            CurrUser.CALCFIELDS("User ID");
                            "Assigned to User" := CurrUser."User ID";
                            // "Assigned To User Name":=CurrUser."Full Name";
                        END;
                    end;
                }
                field("Assigned To User Name"; "Assigned To User Name")
                {
                    Editable = false;
                }
                field("Assign Remarks"; "Assign Remarks")
                {
                }
                field("Last Updated Date and Time"; "Last Updated Date and Time")
                {
                }
                field("Escalation Level No."; "Escalation Level No.")
                {
                    Editable = false;
                }
                field("Escalation Level Name"; "Escalation Level Name")
                {
                    Editable = false;
                }
                field("Escalation Expiration"; "Escalation Expiration")
                {
                    Caption = 'Intercation Expiration>';
                    Editable = false;
                    Visible = false;
                }
                field("Escalation Clock"; "Escalation Clock")
                {
                    Editable = true;
                }
                field("Overall Level Duration"; "Overall Level Duration")
                {
                    Editable = false;
                }
                field(Notes; Notes)
                {
                    MultiLine = true;
                }
                field("Additional Notes"; "Additional Notes")
                {
                    MultiLine = true;
                }
                field("Client Feedback"; "Client Feedback")
                {
                    MultiLine = true;
                }
                field("Satisfaction Level"; "Satisfaction Level")
                {
                }
                field("Reviewing Officer Remarks"; "Reviewing Officer Remarks")
                {
                    Caption = 'Resolution Remarks';
                    MultiLine = true;
                }
                field("Reopening Remarks"; "Reopening Remarks")
                {
                    Caption = 'Re-opening Remarks';
                    MultiLine = true;
                }
                field("Interaction Modified DateTime"; "Interaction Modified DateTime")
                {
                    Editable = false;
                }
                field("Interaction Status Modified By"; "Interaction Status Modified By")
                {
                    Editable = false;
                }
                field("Root Cause Analysis"; "Root Cause Analysis")
                {
                    MultiLine = true;
                }
            }
            group(Remarks)
            {
            }
            part("<Resolution Subform>"; "Resolution subform")
            {
                Editable = false;
                SubPageLink = IRCode = FIELD("Interaction Resolution No.");
            }
            part("Client Interactions List"; "Client Interactions list")
            {
                SubPageLink = "Client No." = FIELD("Client No.");
            }
            systempart(SysNotes; Notes)
            {
            }
            systempart(Outlook; Outlook)
            {
            }
            systempart(MyNotes; MyNotes)
            {
            }
            systempart(Links; Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000041>")
            {
                Caption = 'C&lient';
                action(Create)
                {
                    Caption = 'Create';
                    Image = MachineCenterLoad;
                    Promoted = true;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to create this interaction,' + "Interact Code" + '?') = TRUE THEN BEGIN
                            VALIDATE("Assign Remarks");
                            MODIFY;
                            MESSAGE('Interaction Created');
                        END;
                    end;
                }
                action("Upload Resolution Remarks")
                {
                    Caption = 'Upload Resolution Remarks';
                    Image = MachineCenterLoad;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        IF "User ID" = USERID THEN
                            ERROR('You are not allowed upload  this file');
                        IF CONFIRM('Are you sure you want to upload Resolution Remarks into the system?') = TRUE THEN
                            ImportResolution.RUN;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*
        UserRec.RESET;
        UserRec.SETRANGE(UserRec."User Name","User ID");
         IF UserRec.FIND('-') THEN
           LoggedByName:=UserRec."Full Name";
        
        UserRec.RESET;
        UserRec.SETRANGE(UserRec."User Name","Assigned to User");
         IF UserRec.FIND('-') THEN
           AssignedUsername:=UserRec."Full Name";
        */

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Date and Time" := CURRENTDATETIME;
        "Last Updated Date and Time" := CURRENTDATETIME;
        "Escalation Clock" := CURRENTDATETIME;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //interaction type complaint-status resolved
        IF ("Interaction Type" = "Interaction Type"::Complaint) AND ("Current Status" = "Current Status"::Resolved) THEN BEGIN
            IF "Root Cause Analysis" = '' THEN
                ERROR('Root cause analysis must have a value for resolved complaints');
            IF "Reviewing Officer Remarks" = '' THEN
                ERROR('Resolution remarks must have a value for resolved complaints');


            IF rec."Client  Notified" = FALSE THEN BEGIN

                //IF "Reviewing Officer Remarks"<>'' THEN BEGIN
                //ERROR('This interaction has not been resolved by the user');
                ////IF "Assigned to User"=USERID THEN
                ////ERROR('You are not allowed to change this status');
                ////IF CONFIRM('Has this interaction been Resolved,'+"Interact Code"+'?')=TRUE THEN BEGIN

                UsersRecs.RESET;
                IF UsersRecs.GET("Assigned to User") THEN BEGIN
                    CCTo := UsersRecs."E-Mail";
                END;
                // message('test');
                //IF recUserSetup.GET("User ID") THEN
                // BEGIN
                Vendor.GET("Client No.");
                IF Vendor."E-Mail" <> '' THEN BEGIN
                    //MESSAGE( Vendor."E-Mail");
                    txtLineDescription := 'Assigned to User ' + "Assigned to User";
                    InsertDetailLine('System', 'Assigned', txtLineDescription);
                    CompanyInformation.GET();
                    ToName := CompanyInformation."E-Mail";
                    Subject := STRSUBSTNO('Client Interaction %1', "Interact Code");
                    Body := "Assign Remarks";
                    SenderName := '';
                    IF "Assign Remarks" <> '' THEN
                        Body := "Assign Remarks"
                    ELSE
                        Body := 'The Interaction has been Resolved';
                    Body1 := 'Should you have further enquiries, please do not hesitate to contact us.';
                    Body2 := FORMAT("Interaction Type Desc.");
                    Body3 := 'We thank you for giving us the opportunity to be of service to you.';
                    Body4 := Notes;
                    Body5 := EscExpiration;
                    Body6 := "Client No.";
                    Body7 := "Client Name";

                END;
                AttachFileName := '';
                OpenDialog := TRUE;
                CRMSetup.GET;
                CRMSetup.TESTFIELD(CRMSetup."Client Interactions Notifier");
                SMPTPMail.CreateMessage(CompanyInformation.Name, CRMSetup."Client Interactions Notifier", Vendor."E-Mail", Subject, Body7, FALSE);

                // SMPTPMail.AddCC(recUserSetup."E-Mail");
                lchar13 := 13;
                lchar10 := 10;
                //SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                // SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                SMPTPMail.AppendBody('Your complaint on :');
                // SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                SMPTPMail.AppendBody(Body2);
                //SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                // SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                //SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                SMPTPMail.AppendBody(' has been resolved.');
                SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                //SMPTPMail.AppendBody(Body2);
                // SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                // SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                // SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                //SMPTPMail.AppendBody('Interaction Type No.:');
                SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                SMPTPMail.AppendBody(Body1);
                //SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                //SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                //SMPTPMail.AppendBody('Client No.:');
                SMPTPMail.AppendBody(FORMAT(lchar13) + FORMAT(lchar10));
                SMPTPMail.AppendBody(Body3);
                /*
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
                */
                SMPTPMail.Send();
                //  END
                "Client  Notified" := TRUE;
                MODIFY;
            END
        END;
        //Resolution remarks is amust for resolved


        IF "Current Status" = "Current Status"::Resolved THEN BEGIN
            IF "Reviewing Officer Remarks" = '' THEN
                ERROR('Resolution remarks must have a value for resolved interactions');

        END;

        IF Notes = '' THEN BEGIN
            IF CONFIRM(Text000, FALSE) THEN
                DELETE
            ELSE
                EXIT(FALSE);
        END;

        /*IF "Reviewing Officer Remarks"='' THEN  BEGIN
        IF "Current Status"="Current Status"::Resolved THEN
        IF CONFIRM(Text001,FALSE) THEN
        EXIT(FALSE)
        ELSE
        TESTFIELD("Reviewing Officer Remarks")
        //EXIT(FALSE);
        //VALIDATE("Current Status");
        END;
        */

        IF "Reopening Remarks" = '' THEN BEGIN
            IF "Current Status" = "Current Status"::Reopened THEN
                IF CONFIRM(Text002, FALSE) THEN
                    EXIT(FALSE)
                ELSE
                    EXIT(TRUE);
        END

    end;

    var
        CurrUser: Record "User Personalization";
        UserRec: Record User;
        UserFilter: Text;
        Length: Integer;
        LoggedByName: Text;
        AssignedUsername: Text;
        Text000: Label 'Notes are blank are you sure you want to close page? \Your changes will be discarded';
        AssignedName: Text[50];
        Text001: Label 'Do you want to enter the Resolution Remarks for  this Interaction?';
        Text002: Label 'Do you want to enter the Reopening Remarks for  this Interaction?';
        ImportResolution: XMLport 51405085;
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
        txtLineDescription: Text[250];
        recClient: Record 18;
        CRMResolutionSteps: Record "Resolution Steps";
        CRMResolutionTaskStatus: Record "Resolution of tasks status";
        //NavMail: Codeunit 397;
        SMPTPMail: Codeunit "SMTP Mail";
        ToName: Text[200];
        CCName: Text[60];
        Subject: Text[250];
        Body: Text[250];
        Body1: Text[250];
        Body2: Text[250];
        Body3: Text[250];
        Body4: Text[250];
        Body5: DateTime;
        Body6: Text[250];
        Body7: Text[250];
        AttachFileName: Text[250];
        OpenDialog: Boolean;
        recDimension: Record 349;
        CompanyInformation: Record 79;
        Mailing: Text[50];
        SenderName: Text[50];
        Recipients: Text[50];
        SenderAddress: Text[50];
        AddToEmail: Text[50];
        UsersRecs: Record 91;
        CCTo: Text[50];
        lchar13: Char;
        lchar10: Char;
        Test: Text[30];
        EscExpiration: DateTime;
        TotEscHrs: Duration;
        TotExpHrs: Duration;
        EscDateTime: DateTime;
        EscSetup: Record "Interaction Channel";
        EscalationHrs: Integer;
        EscalateHrs: Integer;
        Vendor: Record 18;
        CRMSetup: Record "Interactions Setup";

    procedure InsertDetailLine(ptxtLineType: Text[30]; ptxtActionType: Text[30]; ptxtDescription: Text[250])
    var
        lintLineNo: Integer;
        lClIntHdr: Record "Client Interaction Header";
    begin
        //C004
        recClientInteractLine.RESET;
        recClientInteractLine.SETRANGE("Client Interaction No.", "Interact Code");
        IF recClientInteractLine.FINDLAST THEN
            lintLineNo := recClientInteractLine."Line No." + 10000
        ELSE
            lintLineNo := 10000;

        recClientInteractLine.INIT;
        recClientInteractLine."Client Interaction No." := "Interact Code";
        recClientInteractLine."Line No." := lintLineNo;
        EVALUATE(recClientInteractLine."Line Type", ptxtLineType);
        EVALUATE(recClientInteractLine."Action Type", ptxtActionType);
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
}

