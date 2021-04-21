page 51513042 "Credit Request"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Credit Request";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Request No."; "Request No.")
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Request Time"; "Request Time")
                {
                }
                field("Recommended By"; "Recommended By")
                {
                }
                field("Customer ID"; "Customer ID")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Credit Amount"; "Credit Amount")
                {
                }
                field("Credit Start Date"; "Credit Start Date")
                {
                }
                field("Credit Period"; "Credit Period")
                {
                }
                field("Credit End Date"; "Credit End Date")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Customer Balance"; "Customer Balance")
                {
                }
                field("Branch Balance"; "Branch Balance")
                {
                }
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
                action(ApprovalEntries)
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var
                    begin
                        /*IF  ApprovalsMgmt.CheckCRApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmt.OnSendCRDocForApproval(Rec) */


                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var
                    begin
                        //ApprovalsMgmt.OnCancelCRApprovalRequest(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        SetControlAppearance;
    end;

    var
        CertPrint: Codeunit "CertPrint";
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

    local procedure SetControlAppearance();
    var
    begin
        //JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        //HasIncomingDocument := "Incoming Document Entry No." <> 0;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        //MESSAGE('OpenApprovalEntriesExistForCurrUser for current user=%1',OpenApprovalEntriesExistForCurrUser);
        //MESSAGE('OpenApprovalEntriesExist',OpenApprovalEntriesExist);
    end;
}

