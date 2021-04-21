page 51404254 "Client Interactions Header"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New form created for Complaint Incedent Header
    // C002-RW 300810  : New funtion created SendMail to send an email to the assigned user
    // C003-RW 300810  : Code added on Status - OnValidate() to make form uneditable
    // +--------------------------------------------------------------------------------------------------------------------+
    // | Creator/Modifier Date Code Mark Purpose/Description/Ref. |
    // +--------------------------------------------------------------------------------------------------------------------+
    // | Rupali Walke 28-09-10 01 New Menu Item added in Function - Contact Card
    //   Rupali Walke 28-09-10 01 Changes made in Code for Escalate All Interactions by SLA
    // +---------------------------------------------------------------------------------------------------------------------+

    DelayedInsert = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Client Interaction Header";
    SourceTableView = WHERE("Current Status" = FILTER(<> Closed));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group("Add Interaction Line")
                {
                    Caption = 'Add Interaction Line';
                }
                field(obxActionType; optAction)
                {
                    Editable = obxActionTypeEditable;
                }
                field(tbxDescription; txtDescription)
                {
                    Editable = tbxDescriptionEditable;
                }
                field("Interact Code"; "Interact Code")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Date and Time"; "Date and Time")
                {
                    Editable = false;
                }
                field("Client No."; "Client No.")
                {
                    Editable = "Client No.Editable";
                }
                field("Client Name"; "Client Name")
                {
                    Editable = false;
                }
                field("Interaction Channel"; "Interaction Channel")
                {
                    Editable = "Interaction ChannelEditable";
                }
                field("Interaction Type"; "Interaction Type")
                {
                    Editable = "Interaction TypeEditable";
                }
                field("Interaction Type No."; "Interaction Type No.")
                {
                    Editable = "Interaction Type No.Editable";

                    trigger OnValidate()
                    begin
                        //InteractionTypeNoOnAfterValidate;
                    end;
                }
                field("Interaction Type Desc."; "Interaction Type Desc.")
                {
                    Editable = false;
                }
                field("Interaction Cause No."; "Interaction Cause No.")
                {
                    Editable = "Interaction Cause No.Editable";

                    trigger OnValidate()
                    begin
                        //InteractionCauseNoOnAfterValidate;
                    end;
                }
                field("Interaction Cause Desc."; "Interaction Cause Desc.")
                {
                    Editable = false;
                }
                field("Interaction Resolution No."; "Interaction Resolution No.")
                {
                    Editable = InteractionResolutionNoEditabl;

                    trigger OnValidate()
                    begin
                        //InteractionResolutionNoOnAfterValidate;
                    end;
                }
                field("User ID"; "User ID")
                {
                }
                field("Current Status"; "Current Status")
                {
                    Editable = false;
                }
                field("Assigned to User"; "Assigned to User")
                {
                    Editable = "Assigned to UserEditable";
                }
                field("Last Updated Date and Time"; "Last Updated Date and Time")
                {
                    Editable = false;
                }
                field("Escalation Level Name"; "Escalation Level Name")
                {
                    Caption = 'Escalation Level';
                    Editable = false;
                }
                field(Notes; Notes)
                {
                    MultiLine = true;
                }
            }
            part(ComplaintLines; 51404255)
            {
                Editable = true;
                SubPageLink = "Client Interaction No." = FIELD("Interact Code");
            }

        }
    }

    actions
    {
        area(navigation)
        {
            group("GeneralCo&mments")
            {
                Caption = 'Co&mments';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    // RunObject = Page 124;
                    //RunPageLink = No.=FIELD(Interact Code);
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Escalate All Interactions by SLA")
                {
                    Caption = 'Escalate All Interactions by SLA';

                    trigger OnAction()
                    begin
                        //cduInteractions.EscalateComplaintToNextLevel;
                    end;
                }
                action("Contact Card")
                {
                    Caption = 'Contact Card';
                    RunObject = Page 5050;
                    // RunPageLink = "No."=FIELD("Client No.");
                    //  ShortCutKey = 'Shift+F7';
                }
            }
            action(btnClearLine)
            {
                Caption = 'Clear';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CLEAR(optAction);
                    CLEAR(txtDescription);
                end;
            }
            action(btnAddAction)
            {
                Caption = 'Add';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    txtLineType := 'Manual';
                    txtAction := FORMAT(optAction);
                    IF (txtAction = '')
                    OR (txtDescription = '') THEN
                        ERROR(Txt006);
                    InsertDetailLine(txtLineType, txtAction, txtDescription);
                    CLEAR(optAction);
                    CLEAR(txtDescription);
                end;
            }
            action(Comment)
            {
                Caption = 'Comment';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 124;
                // RunPageLink = "Table Name"=CONST(17),
                //              "No."=FIELD("Interact Code");
                // ToolTip = 'Comment';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        optActionOnFormat;
        txtDescriptionOnFormat;
        ClientNoOnFormat;
        InteractionTypeNoOnFormat;
        InteractionChannelOnFormat;
        InteractionCauseNoOnFormat;
        //InteractionResolutionNoOnFormat;
        AssignedtoUserOnFormat;
        InteractionTypeOnFormat;
    end;

    trigger OnInit()
    begin
        "Interaction TypeEditable" := TRUE;
        "Assigned to UserEditable" := TRUE;
        InteractionResolutionNoEditabl := TRUE;
        "Interaction Cause No.Editable" := TRUE;
        "Interaction ChannelEditable" := TRUE;
        "Interaction Type No.Editable" := TRUE;
        "Client No.Editable" := TRUE;
        tbxDescriptionEditable := TRUE;
        obxActionTypeEditable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        //IF Status = Status::Closed THEN
        //  CurrForm.EDITABLE(FALSE);

        UpdateStatusFlag := FALSE;
        ActivateForm;
    end;

    var
        Txt001: Label 'Do you want to Re-open the status of this complaint';
        CompHeader: Record "Client Interaction Header";
        UpdateStatusFlag: Boolean;
        Txt002: Label 'Microsoft Dynamics NAV: Assigned Complaint  No. %1';
        Txt003: Label 'The Microsoft Dynamics NAV Complaint Incident No. %1 is assigned to you';
        txtLineType: Text[10];
        optAction: Option " ","Response Out","Reply In",Comment,Closed;
        txtAction: Text[30];
        txtDescription: Text[250];
        Txt004: Label 'Interaction successfully escalated';
        Txt005: Label 'Escalation failed.  No further levels available';
        Txt006: Label 'Cannot add blank line';
        [InDataSet]
        obxActionTypeEditable: Boolean;
        [InDataSet]
        tbxDescriptionEditable: Boolean;
        [InDataSet]
        "Client No.Editable": Boolean;
        [InDataSet]
        "Interaction Type No.Editable": Boolean;
        [InDataSet]
        "Interaction ChannelEditable": Boolean;
        [InDataSet]
        "Interaction Cause No.Editable": Boolean;
        [InDataSet]
        InteractionResolutionNoEditabl: Boolean;
        [InDataSet]
        "Assigned to UserEditable": Boolean;
        [InDataSet]
        "Interaction TypeEditable": Boolean;

    procedure ActivateForm()
    begin
        /*
        IF Status = Status::Escalated THEN BEGIN
          CurrForm.EDITABLE := FALSE;
        END ELSE
          CurrForm.EDITABLE := TRUE;
        */

    end;

    procedure SendMail()
    var
        SMTPEmail: Codeunit "SMTP Mail";
        SenderName: Text[100];
        SenderAddress: Text[50];
        Recipients: Text[1024];
        Subject: Text[200];
        Body: Text[1024];
        HtmlFormatted: Boolean;
        UserSetup: Record 91;
        //Txt001: ;
    begin
        //C002
        IF UserSetup.GET(USERID) THEN BEGIN
            UserSetup.TESTFIELD(UserSetup."E-Mail");
            SenderName := USERID;
            SenderAddress := UserSetup."E-Mail";
        END;
        UserSetup.RESET;
        IF UserSetup.GET("Assigned to User") THEN BEGIN
            UserSetup.TESTFIELD(UserSetup."E-Mail");
            Recipients := UserSetup."E-Mail"
        END;

        Subject := STRSUBSTNO(Txt002, "Interact Code");
        Body := STRSUBSTNO(Txt003, "Interact Code");

        SMTPEmail.CreateMessage(SenderName, SenderAddress, Recipients, Subject, Body, TRUE);
        SMTPEmail.Send();
        //C002
    end;

    local procedure InteractionTypeNoOnAfterValida()
    begin
        CurrPage.UPDATE;
    end;

    local procedure InteractionCauseNoOnAfterValid()
    begin
        CurrPage.UPDATE;
    end;

    local procedure InteractionResolutionNoOnAfter()
    begin
        CurrPage.UPDATE;
    end;

    local procedure optActionOnFormat()
    begin
        IF "Current Status" = "Current Status"::Closed THEN
            obxActionTypeEditable := FALSE;
    end;

    local procedure txtDescriptionOnFormat()
    begin
        IF "Current Status" = "Current Status"::Closed THEN
            tbxDescriptionEditable := FALSE;
    end;

    local procedure ClientNoOnFormat()
    begin
        IF "Current Status" > "Current Status"::Logged THEN
            "Client No.Editable" := FALSE
        ELSE
            "Client No.Editable" := TRUE;
    end;

    local procedure InteractionTypeNoOnFormat()
    begin
        IF "Current Status" > "Current Status"::Logged THEN
            "Interaction Type No.Editable" := FALSE
        ELSE
            "Interaction Type No.Editable" := TRUE;
    end;

    local procedure InteractionChannelOnFormat()
    begin
        IF "Current Status" > "Current Status"::Logged THEN
            "Interaction ChannelEditable" := FALSE
        ELSE
            "Interaction ChannelEditable" := TRUE;
    end;

    local procedure InteractionCauseNoOnFormat()
    begin
        IF "Current Status" > "Current Status"::Logged THEN
            "Interaction Cause No.Editable" := FALSE
        ELSE
            "Interaction Cause No.Editable" := TRUE;
    end;

    local procedure InteractionResolutionNoOnForma()
    begin
        IF "Current Status" > "Current Status"::Logged THEN
            InteractionResolutionNoEditabl := FALSE
        ELSE
            InteractionResolutionNoEditabl := TRUE;
    end;

    local procedure AssignedtoUserOnFormat()
    begin
        IF "Assigned Flag" THEN
            "Assigned to UserEditable" := FALSE
        ELSE
            "Assigned to UserEditable" := TRUE;
    end;

    local procedure InteractionTypeOnFormat()
    begin
        IF "Current Status" > "Current Status"::Logged THEN
            "Interaction TypeEditable" := FALSE
        ELSE
            "Interaction TypeEditable" := TRUE;
    end;
}

