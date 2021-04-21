page 51513175 "Claim Reservation Header"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Claim Reservation Header";

    layout
    {
        area(content)
        {
            group(General)
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
                field("Claimant Name"; "Claimant Name")
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
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                }
                field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code")
                {
                }
                field("Insurance Class"; "Insurance Class")
                {
                }
                field("Revised Reserve Link"; "Revised Reserve Link")
                {
                }
                field("Previous Reserve Amount"; "Previous Reserve Amount")
                {
                }
                field(Difference; Difference)
                {
                }
                field(Status; Status)
                {
                }
                field("No. Of Approvers"; "No. Of Approvers")
                {
                }
                field("Service Provider Type"; "Service Provider Type")
                {
                }
                field("Service Provider Code"; "Service Provider Code")
                {
                }
                field("Service Provider Name"; "Service Provider Name")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
            }
            part("Claim Reservation line"; "Claim Reservation line")
            {
                SubPageLink = "Claim Reservation No."=FIELD("No.");
                    UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Post Claim Reserve")
            {

                trigger OnAction();
                begin
                    InsMgt.PostClaimsReserve(Rec);
                end;
            }
            action("Transfer to Payment Voucher")
            {

                trigger OnAction();
                begin
                    InsMgt.TransferReserve2Payment(Rec);
                end;
            }
            action("Create Reinsurace Entries")
            {

                trigger OnAction();
                begin
                    InsMgt.CreateReservationReinsEntries(Rec);
                end;
            }
            action("View Reinsurance")
            {
                RunObject = Page Reinsurance;
                RunPageLink = "No."=FIELD("No.");
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
                        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
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
                        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
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
                        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
                group("Request Approval")
                {
                    Caption = 'Request Approval';
                    Image = SendApprovalRequest;
                }
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var
                        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                    begin
                        /* IF ApprovalsMgmt.CheckClaimReserveApprovalsWorkflowEnabled(Rec) THEN
                          ApprovalsMgmt.OnSendClaimReserveDocForApproval(Rec); */
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
                        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                    begin
                      //  ApprovalsMgmt.OnCancelClaimReserveApprovalRequest(Rec);
                    end;
                }
            }
        }
    }

    var
        InsMgt : Codeunit "Insurance management";
        OpenApprovalEntriesExistCurrUser : Boolean;
        OpenApprovalEntriesExist : Boolean;
        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
}

