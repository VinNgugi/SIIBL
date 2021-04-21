page 51511012 Claims_Refund
{
    // version FINANCE

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST("Claim/Refund"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Request Date"; "Request Date")
                {
                    Caption = 'Claim Date';
                }
                field("Trip No"; "Trip No")
                {
                    Visible = true;
                }
                field("Employee No"; "Employee No")
                {
                    Editable = false;
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                }
                field("Trip Start Date"; "Trip Start Date")
                {
                }
                field("Trip Expected End Date"; "Trip Expected End Date")
                {
                }
                field("No. of Days"; "No. of Days")
                {
                    Editable = false;
                    Visible = true;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Caption = 'Directorate';
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Caption = 'Department';
                    Editable = false;
                }
                field("Purpose of Imprest"; "Purpose of Imprest")
                {
                    Visible = true;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Total Amount Requested"; "Total Amount Requested")
                {
                    Caption = 'Claim Amount';
                    Editable = false;
                }
                field(Balance; Balance)
                {
                    Caption = 'Customer Balance';
                    Editable = false;
                }
                field("Activity Date"; "Activity Date")
                {
                    Visible = false;
                }
                field(External; External)
                {
                    Caption = 'External Application';
                }
                field("Customer A/C"; "Customer A/C")
                {
                }
                field("Job Group"; "Job Group")
                {
                    Visible = false;
                }
                field("No of Approvals"; "No of Approvals")
                {
                    Caption = 'Approval Status';
                    Editable = false;
                }
                field("CBK Website Address"; "CBK Website Address")
                {
                    Editable = false;
                    ExtendedDatatype = URL;
                }
                field("Imprest Type"; "Imprest Type")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        IF "Imprest Type" = "Imprest Type"::Group THEN
                            GroupImprest := TRUE
                        ELSE
                            GroupImprest := FALSE;
                    end;
                }
                field("Imprest Purpose"; "Imprest Purpose")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        /*ImprestLines.RESET;
                        ImprestLines.SETRANGE("Document No","No.");
                        IF ImprestLines.FIND('-') THEN BEGIN
                        REPEAT
                        ImprestLines."Imprest Purpose":="Imprest Purpose";
                        ImprestLines.MODIFY;
                        UNTIL ImprestLines.NEXT=0;
                        END;
                        
                        
                        GroupLines.RESET;
                        GroupLines.SETRANGE("Imprest No","No.");
                        IF GroupLines.FIND('-') THEN BEGIN
                        REPEAT
                        GroupLines."Imprest Purpose":="Imprest Purpose";
                        GroupLines.MODIFY;
                        UNTIL GroupLines.NEXT=0;
                        END;
                        */

                    end;
                }
                field(Attachement; Attachement)
                {
                    Visible = false;
                }
                field("Attached to PV No"; "Attached to PV No")
                {
                    Editable = false;
                }
            }
            part("Imprest_claim Lines"; "Imprest_claim Lines")
            {
                SubPageLink = "Document No" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    RESET;
                    SETFILTER("No.", "No.");
                    REPORT.RUN(51511028, TRUE, TRUE, Rec);
                    RESET;
                end;
            }
            group(Functions)
            {
                Caption = 'Functions';
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        TESTFIELD("Customer A/C");
                        ERROR("Customer A/C");
                        IF "Customer A/C" = '' THEN BEGIN
                            ERROR('Please Select Customer No.');
                        END;
                        IF "Customer A/C" = ' ' THEN BEGIN
                            ERROR('Please Select Customer No.');
                        END;
                        IF "Purpose of Imprest" = '' THEN
                            //ERROR('You must enter Purpose of imprest');

                            //Check Empty Lines
                            ImprestLines.RESET;
                        ImprestLines.SETRANGE("Document No", "No.");
                        IF NOT ImprestLines.FIND('-') THEN
                            ERROR('The Imprest Has NO Lines');

                        //Check Details
                        ImprestLines.RESET;
                        ImprestLines.SETRANGE("Document No", "No.");
                        IF ImprestLines.FIND('-') THEN BEGIN
                            ImprestLines.TESTFIELD(Activity);
                            ImprestLines.TESTFIELD(Quantity);
                            ImprestLines.TESTFIELD("Unit Price");
                        END;

                        //BKK
                        IF Status <> Status::Open THEN
                            ERROR('This request has been sent for approval');
                        //IF ApprovalMgt.CheckImprestAdvanceClaimApprovalsWorkflowEnabled(Rec) THEN
                        //  ApprovalMgt.OnSendImprestAdvanceClaimDocForApproval(Rec);
                        //IF ApprovalMgt.SendImprestApprovalRequest(Rec) THEN;
                        //CurrPage.CLOSE;
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //  IF ApprovalMgt.CancelImprestApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                action(Submit)
                {
                    Caption = 'Submit';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CreatePV(Rec);
                    end;
                }
                action("Payroll Recovery")
                {
                    Caption = 'Payroll Recovery';
                    Visible = false;

                    trigger OnAction()
                    begin
                        /* loanapplication.INIT;
                        loanapplication."Loan No" := '';
                        loanapplication."Loan Product Type" := "Transaction Type";
                        loanapplication."Application Date" := TODAY;
                        loanapplication."Amount Requested" := Balance;
                        loanapplication."Approved Amount" := Balance;
                        loanapplication."Employee No" := "Employee No";
                        loanapplication."Loan Status" := loanapplication."Loan Status"::Approved;
                        //loanapplication."Issued Date":=
                        loanapplication.INSERT(TRUE); */
                    end;
                }
                action("Update Approval")
                {

                    trigger OnAction()
                    begin
                        RESET;
                        CALCFIELDS("Imprest Amount");
                        approvalentries.SETRANGE("Document No.", "No.");
                        IF approvalentries.FINDFIRST THEN BEGIN
                            REPEAT
                                // IF ApprovalEntries."Amount (LCY)"=0 THEN
                                approvalentries."Amount (LCY)" := "Imprest Amount";
                                approvalentries.MODIFY;
                                MESSAGE('Successfully Updated')
UNTIL approvalentries.NEXT = 0;
                        END;
                    end;
                }
                action(Post)
                {
                    Visible = true;

                    trigger OnAction()
                    begin
                        CreatePV(Rec);
                    end;
                }
            }
            group(Attachment)
            {
                Caption = 'Attachment';
                Image = Attachments;
                action(Open)
                {
                    Caption = 'Open';
                    Image = Edit;
                    Promoted = true;
                    ShortCutKey = 'Return';
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Interaction Template Code" := "No." + '-' + FORMAT(Type);
                        OpenAttachment;
                    end;
                }
                action(Create)
                {
                    Caption = 'Create';
                    Image = New;
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Interaction Template Code" := "No." + '-' + FORMAT(Type);
                        CreateAttachment;
                    end;
                }
                action(Import)
                {
                    Caption = 'Import';
                    Image = Import;
                    Promoted = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Interaction Template Code" := "No." + '-' + FORMAT(Type);
                        ImportAttachment;
                    end;
                }
                action(Export)
                {
                    Caption = 'Export';
                    Image = Export;
                    Promoted = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Interaction Template Code" := "No." + '-' + FORMAT(Type);
                        ExportAttachment;
                    end;
                }
                action(Remove)
                {
                    Caption = 'Remove';
                    Image = Cancel;
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Interaction Template Code" := "No." + '-' + FORMAT(Type);
                        RemoveAttachment(FALSE);
                    end;
                }
                action("E&xport File2")
                {
                    Caption = 'E&xport File2';
                    Image = ExportFile;
                    Visible = false;

                    trigger OnAction()
                    var
                        SegLineLocal: Record 5077;
                    begin
                        SegLineLocal.SETRANGE("Segment No.", "No.");
                        XMLPORT.RUN(XMLPORT::"Export Segment Contact", FALSE, FALSE, SegLineLocal);
                    end;
                }
            }
        }
        area(creation)
        {
            action("Send Approval Request.")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    /*TESTFIELD("Customer A/C");
                    IF "Request Date"<TODAY
                      THEN BEGIN
                      ERROR('Please ensure the request date is the same as todays date');
                      END;
                    CUST.RESET;
                    CUST.GET("Customer A/C");
                    CUST.CALCFIELDS(CUST.Balance);
                    
                    IF CUST.Balance>0 THEN BEGIN
                       //ERROR('Customer %1 has an Outstanding Balance of %2\You cannot Raise new Imprest till the oustanding Amount is Surrendered!!!',"Customer A/C",CUST.Balance);
                    END;
                    
                    IF "Customer A/C"='' THEN BEGIN
                       ERROR('Please Select Customer No.');
                    END;
                    IF "Customer A/C"=' ' THEN BEGIN
                       ERROR('Please Select Customer No.');
                    END;
                    
                    IF "Purpose of Imprest"='' THEN
                    //ERROR('You must enter Purpose of imprest');
                    
                    //Check Empty Lines
                    ImprestLines.RESET;
                    ImprestLines.SETRANGE("Document No","No.");
                    IF NOT ImprestLines.FIND('-') THEN
                    ERROR('The Claim Has NO Lines');
                    
                    //Check Details
                    i:=0;
                    ImprestLines.RESET;
                    ImprestLines.SETRANGE("Document No","No.");
                    IF ImprestLines.FIND('-') THEN REPEAT
                      i:=i+1;
                    //ImprestLines.TESTFIELD(Activity);
                    ImprestLines.TESTFIELD(Quantity);
                    ImprestLines.TESTFIELD("Unit Price");
                    IF ImprestLines."Account No"='' THEN BEGIN
                       ERROR('Claim No. %1 is Missing  Account No. in  Line %2',"No.",i);
                    END;
                    UNTIL ImprestLines.NEXT=0;
                    
                    */
                    /* IF ApprovalMgt.CheckImprestRequestApprovalPossible(Rec) THEN
                        ApprovalMgt.OnSendImprestRequestDocForApproval(Rec); //ApprovalMgt.CheckLEAVEApprovalPossible(Rec);
 */
                end;
            }
            action("Cancel Approval Request.")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = OpenApprovalEntriesExistForCurrUser2;

                trigger OnAction()
                begin
                    /*IF Status<>Status::Released THEN
                    approvalsmgmt.GetApprovalCommentERC(Rec,0,"No.");
                    */

                end;
            }
            action("DMS Link")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    /*
                    GLSetup.GET();
                    Link:=GLSetup."DMS Imprest Claim Link"+"No.";
                    HYPERLINK(Link);
                    */

                end;
            }
            action("Approval Entries")
            {
                Image = Approvals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunPageMode = View;
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                        //CurrPage.CLOSE;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                        //CurrPage.CLOSE;
                        //ApprovalsMgmt.GetApprovalCommentERC(Rec,1,"No.");
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                        //CurrPage.CLOSE;
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF "Imprest Type" = "Imprest Type"::Group THEN
            GroupImprest := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF Status <> Status::Open THEN
            //ERROR('You cannot make changes at this stage')
            ;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::"Claim/Refund";
        //ERROR('...');
    end;

    trigger OnOpenPage()
    begin
        /*
        approvalentry.RESET;
        approvalentry.SETFILTER(approvalentry.Status,'%1',approvalentry.Status::Open);
        approvalentry.SETFILTER(approvalentry."Document Type",'%1',approvalentry."Document Type"::"Claim Refunds");
        approvalentry.SETFILTER(approvalentry."Approver ID",'%1',USERID);
        approvalentry.SETFILTER(approvalentry."Document No.","No.");
        IF approvalentry.FINDSET THEN BEGIN
           OpenApprovalEntriesExistForCurrUser:=TRUE;
          //MESSAGE('Approver...');
        END;
        IF NOT approvalentry.FINDSET THEN BEGIN
           OpenApprovalEntriesExistForCurrUser2:=TRUE;
          // MESSAGE('Not an Approver...');
        END;
        IF OpenApprovalEntriesExistForCurrUser=TRUE THEN BEGIN
           OpenApprovalEntriesExistForCurrUser2:=FALSE;
        END;
        */

    end;

    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        PV: Record "Request Header";
        PVlines: Record 51511001;
        //loanapplication: Record 51511113;
        D: Date;
        UserSetup: Record "User Setup";
        ApprovalSetup: Record 39;
        UserSetupRec: Record "User Setup";
        RequestHeader: Record "Request Header";
        GLSetup: Record "General Ledger Setup";
        Link: Text[250];
        [InDataSet]
        GroupImprest: Boolean;
        PartialImprest: Record 51511023;
        Path: Text;
        ServerFileName: Text;
        [RunOnClient]
        FileInfo: DotNet FileInfo;
        ImprestLines: Record 51511004;
        [InDataSet]
        JobQueueVisible: Boolean;
        approvalsmgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        approvalentry: Record 454;
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        i: Integer;
        approvalentries: Record 454;
        CUST: Record Customer;

    procedure GetPartialImprestNo(var ImpNo: Code[20]) LineNo: Integer
    var
        Partial: Record 51511023;
    begin
        /*Partial.RESET;
        Partial.SETCURRENTKEY("Imprest No","Line No");
        Partial.SETRANGE("Imprest No",ImpNo);
        IF Partial.FINDLAST THEN
        LineNo := Partial."Line No"+1
        ELSE
        LineNo := 1;
        */

    end;

    procedure GetAmountIssued(var ImpNo: Code[20]) AmountIssued: Decimal
    var
        Partial: Record 51511023;
    begin
        Partial.RESET;
        Partial.SETCURRENTKEY("Imprest No", "Line No");
        Partial.SETRANGE("Imprest No", ImpNo);
        Partial.SETRANGE(Posted, TRUE);
        IF Partial.FIND('-') THEN BEGIN
            REPEAT
                AmountIssued := AmountIssued + Partial."Amount Already Issued";
            UNTIL Partial.NEXT = 0;
        END ELSE
            AmountIssued := 0;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        /*
        JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND ("No." <> '');
        SetExtDocNoMandatoryCondition;
        
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
        */

    end;
}

