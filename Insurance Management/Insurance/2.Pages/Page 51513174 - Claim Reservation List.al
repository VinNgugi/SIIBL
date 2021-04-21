page 51513174 "Claim Reservation List"
{
    // version AES-INS 1.0

    CardPageID = "Claim Reservation Header";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim Reservation Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("Creation Time"; "Creation Time")
                {
                }
                field("Reserve Amount"; "Reserve Amount")
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
                field("Claimant ID"; "Claimant ID")
                {
                }
                field(Posted; Posted)
                {
                }
                field("Posted By"; "Posted By")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Currency Factor"; "Currency Factor")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field(Status; Status)
                {
                }
                field("No. Of Approvers"; "No. Of Approvers")
                {
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
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
                            //IF ApprovalsMgmt.CheckClaimReserveApprovalsWorkflowEnabled(Rec) THEN
                            //    ApprovalsMgmt.OnSendClaimReserveDocForApproval(Rec);
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
                            //ApprovalsMgmt.OnCancelClaimReserveApprovalRequest(Rec);
                        end;
                    }
                }
            }
        }

    }

    var
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

}

