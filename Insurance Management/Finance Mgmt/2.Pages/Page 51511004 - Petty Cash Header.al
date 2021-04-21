page 51511004 "Petty Cash Header"
{
    // version FINANCE

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST(PettyCash));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Petty Cash Serials"; "Petty Cash Serials")
                {
                    Caption = 'Petty Cash No.';
                    Editable = false;
                }
                field("Imprest/Advance No"; "Imprest/Advance No")
                {
                    Caption = 'Imprest Source';
                    Editable = false;
                }
                field("No."; "No.")
                {
                    Caption = 'Imprest Source1';
                    Editable = false;
                    Visible = false;
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Trip No"; "Trip No")
                {
                    Visible = false;
                }
                field("Employee No"; "Employee No")
                {
                    Editable = false;
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field("Trip Start Date"; "Trip Start Date")
                {
                    Visible = false;
                }
                field("Trip Expected End Date"; "Trip Expected End Date")
                {
                    Visible = false;
                }
                field("No. of Days"; "No. of Days")
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Caption = 'Directorate';
                    Editable = true;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Caption = 'Department';
                    Editable = false;
                }
                field("Purpose of Imprest"; "Purpose of Imprest")
                {
                    Caption = 'Purpose of Petty Cash';
                }
                field("Deadline for Return"; "Deadline for Return")
                {
                    Visible = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Imprest Amount"; "Imprest Amount")
                {
                    Caption = 'Amount';
                    Editable = false;
                }
                field("Total Amount Requested"; "Total Amount Requested")
                {
                    Editable = false;
                }
                field(Country; Country)
                {
                    Visible = false;
                }
                field("Activity Date"; "Activity Date")
                {
                }
                field("Customer A/C"; "Customer A/C")
                {
                    Editable = true;
                }
                field(City; City)
                {
                    Visible = false;
                }
                field("Job Group"; "Job Group")
                {
                    Visible = false;
                }
                field("External Application"; "External Application")
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
                    Visible = false;
                }
                field(Posted; Posted)
                {
                    Editable = true;
                }
            }
            part("Petty Cash Lines"; "Petty Cash Lines")
            {
                SubPageLink = "Document No" = FIELD("No.");
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = true;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
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
                    REPORT.RUN(51511015, TRUE, TRUE, Rec);
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

                    trigger OnAction()
                    begin
                        IF "Purpose of Imprest" = '' THEN
                            ERROR('You must enter Purpose of Petty Cash');

                        //Check Empty Lines
                        PettyLines.RESET;
                        PettyLines.SETRANGE("Document No", "No.");
                        IF NOT PettyLines.FIND('-') THEN
                            ERROR('The Imprest Has NO Lines');

                        //Check Details
                        PettyLines.RESET;
                        PettyLines.SETRANGE("Document No", "No.");
                        IF PettyLines.FIND('-') THEN BEGIN
                            PettyLines.TESTFIELD(Activity);
                            PettyLines.TESTFIELD(Quantity);
                            PettyLines.TESTFIELD("Unit Price");
                            PettyLines.TESTFIELD(Amount);
                            PettyLines.TESTFIELD(Description);
                            IF PettyLines.Activity = '' THEN BEGIN
                                ERROR('Please Select Activity Code First!!!');
                            END;
                        END;


                        CMSetup.GET;
                        CALCFIELDS("Total Amount Requested");
                        IF "Total Amount Requested" > CMSetup."Petty Cash Limit" THEN
                            ERROR(Text0001, "Total Amount Requested", CMSetup."Petty Cash Limit");

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

                    trigger OnAction()
                    begin
                        // IF ApprovalMgt.CancelImprestApprovalRequest(Rec,TRUE,TRUE) THEN;
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
                Visible = OpenApprovalEntriesExistForCurrUser2;

                trigger OnAction()
                begin
                    /*TESTFIELD("Customer A/C");
                    CUST.RESET;
                    CUST.GET("Customer A/C");
                    CUST.CALCFIELDS(CUST.Balance);
                    IF CUST.Balance>0 THEN BEGIN
                       ERROR('Customer %1 has an Outstanding Balance of %2\You cannot Raise new Petty Cash till the oustanding Amount is Surrendered!!!',"Customer A/C",CUST.Balance);
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
                    ERROR('The Petty Cash Has NO Lines');
                    
                    //Check Details
                    i:=0;
                    ImprestLines.RESET;
                    ImprestLines.SETRANGE("Document No","No.");
                    IF ImprestLines.FIND('-') THEN REPEAT
                      i:=i+1;
                    //ImprestLines.TESTFIELD(Activity);
                    ImprestLines.TESTFIELD(Quantity);
                    ImprestLines.TESTFIELD("Unit Price");
                    IF ImprestLines.Activity='' THEN BEGIN
                       ERROR('Petty Cash No. %1 is Missing  Account No. in  Line %2',"No.",i);
                    END;
                    UNTIL ImprestLines.NEXT=0;
                    
                    
                    IF approvalsmgmt.CheckERCImprestApprovalsWorkflowEnabled(Rec) THEN
                      approvalsmgmt.OnSendERCImprestForApproval(Rec);
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
                    /*//IF approvalsmgmt.CheckERCImprestApprovalsWorkflowEnabled(Rec) THEN
                      approvalsmgmt.OnCanelERCImprestForApproval(Rec);
                      //CurrPage.UPDATE;
                         approvalentries.RESET;
                         approvalentries.SETFILTER("Document Type",'%1',approvalentries."Document Type"::Imprest);
                         approvalentries.SETFILTER("Document No.","No.");
                         IF approvalentries.FINDSET THEN REPEAT
                            approvalentries.DELETE;
                         UNTIL approvalentries.NEXT=0;
                    
                         Status :=Status::Open;
                         //MODIFY;
                       //  CurrPage.UPDATE;
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
                    Link:=GLSetup."DMS Imprest Link"+"No.";
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
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PostPettyCash(Rec);
                end;
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
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                        CurrPage.CLOSE;
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
                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                        CurrPage.CLOSE;
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
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                        CurrPage.CLOSE;
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
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        /*IF Status<>Status::Open THEN
        ERROR('You cannot make changes at this stage');
        */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::PettyCash;
        //error('.......');
    end;

    var
        ApprovalMgt: Codeunit 1521;
        PV: Record 51511000;
        PVlines: Record 51511001;
        //loanapplication: Record 51511113;
        D: Date;
        UserSetup: Record "User Setup";
        ApprovalSetup: Record "User Setup";
        UserSetupRec: Record "User Setup";
        RequestHeader: Record "Request Header";
        GLSetup: Record 98;
        Link: Text[250];
        [InDataSet]
        GroupImprest: Boolean;
        PartialImprest: Record 51511023;
        CMSetup: Record "Cash Management Setup";
        Text0001: Label 'The total Requested Amount %1 Cannot be more than %2';
        PettyLines: Record 51511004;
        approvalsmgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        approvalentry: Record 454;
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        i: Integer;
        approvalentries: Record 454;
        CUST: Record 18;
        ImprestLines: Record 51511004;

    procedure GetPartialImprestNo(var ImpNo: Code[20]) LineNo: Integer
    var
        Partial: Record 51511023;
    begin
        Partial.RESET;
        Partial.SETCURRENTKEY("Imprest No", "Line No");
        Partial.SETRANGE("Imprest No", ImpNo);
        IF Partial.FINDLAST THEN
            LineNo := Partial."Line No" + 1
        ELSE
            LineNo := 1;
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
}

