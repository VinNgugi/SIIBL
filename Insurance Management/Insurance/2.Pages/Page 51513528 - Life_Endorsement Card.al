page 51513528 "Life_Endorsement Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST(Endorsement));

    layout
    {
        area(content)
        {
            group(Insured)
            {
                field("No."; "No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Currency Code"; "Currency Code")
                {

                    trigger OnAssistEdit();
                    begin
                        CLEAR(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WORKDATE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Endorsement Type"; "Endorsement Type")
                {
                }
                field("Action Type"; "Action Type")
                {
                }
                field("Policy No"; "Policy No")
                {
                }
                field("Cancellation Reason"; "Cancellation Reason")
                {
                }
                field("Cancellation Reason Desc"; "Cancellation Reason Desc")
                {
                }
                field("Instalment No."; "Instalment No.")
                {
                }
                field("Insured No."; "Insured No.")
                {
                }
                field("Insured Name"; "Insured Name")
                {
                }
                field("Agent/Broker"; "Agent/Broker")
                {
                }
                field("Brokers Name"; "Brokers Name")
                {
                }
                field("Applies-to Doc. Type"; "Applies-to Doc. Type")
                {
                }
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                }
            }
            group(Cover)
            {
                field("Policy Type"; "Policy Type")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                }
                field("No. Of Cover Periods"; "No. Of Cover Periods")
                {
                }
                field("Original Cover Start Date"; "Original Cover Start Date")
                {
                    Editable = false;
                }
                field("Country of Residence"; "Country of Residence")
                {
                    Caption = 'Country of Visit';
                    Visible = false;
                }
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
                {
                    Editable = AllowEditingCoverEndDate;
                }
                field("No. Of Days"; "No. Of Days")
                {
                }
                field("Short Term Cover"; "Short Term Cover")
                {
                }
                field("Short term Cover Percent"; "Short term Cover Percent")
                {
                }
                field("Mid Term Adjustment Factor"; "Mid Term Adjustment Factor")
                {
                }
                field("Premium Calculation Basis"; "Premium Calculation Basis")
                {
                }
                field("Payment Mode"; "Payment Mode")
                {
                }
                field("Premium Financier"; "Premium Financier")
                {
                }
                field("Premium Financier Name"; "Premium Financier Name")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Total Sum Insured"; "Total Sum Insured")
                {
                }
                field("Total Premium Amount"; "Total Premium Amount")
                {
                }
                field("Total Net Premium"; "Total Net Premium")
                {
                }
            }
            part("Schedule of Insured List Edit"; "Schedule of Insured List Edit")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Documents Required")
            {
                RunObject = Page "Insurance Documents";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No" = FIELD("No.");
            }
            action("Additional/Extra Covers")
            {
                RunObject = Page "Additional Benefits";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
            action("Policy Wordings")
            {
                RunObject = Page "Policy Wordings";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Description Type" = FILTER(<> "Schedule of Insured");
                RunPageView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.");
            }
            action("Add Vehicles")
            {
                RunObject = Page "Schedule of Insured List";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
            action("Loadings and Discounts")
            {
                RunObject = Page "Loadings and Discounts";
                RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
            }
            action("Countries to be Visited")
            {
                RunObject = Page "Countries Visited";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
            action("Co-insurance")
            {
                RunObject = Page "Co-insurance";
                RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
            }
            action("Re-insurance")
            {
                RunObject = Page Reinsurance;
                RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
            }
            action("Calculate Premium")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.InsertTaxesReinsurance(Rec);
                end;
            }
            action("View calculations")
            {
                RunObject = Page "Financial Lines";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
            action(Quote)
            {

                trigger OnAction();
                begin
                    Quotation.GetQuote(Rec);
                    Quotation.RUN;
                end;
            }
            action("Payment Schedule")
            {
                RunObject = Page "Payment Schedule";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(ApprovalEntries)
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                    end;
                }
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

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
                    Visible = OpenApprovalEntriesExistForCurrUser;

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
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var

                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page 660;
                    RunPageLink = "Table ID" = CONST(36), "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    Visible = OpenApprovalEntriesExistForCurrUser;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction();
                    var
                    begin
                        //IF ApprovalsMgmt.CheckInsureApprovalsWorkflowEnabled(Rec) THEN
                        //   ApprovalsMgmt.OnSendInsureDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction();
                    var

                    begin
                        //ApprovalsMgmt.OnCancelInsureApprovalRequest(Rec);
                    end;
                }
            }
            action("Post Endorsement")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.PostEndorsement(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        SetControlAppearance;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Document Type" := "Document Type"::Endorsement;
        EndorsementTypeRec.RESET;
        EndorsementTypeRec.SETRANGE(EndorsementTypeRec."Action Type", EndorsementTypeRec."Action Type"::Extension);
        IF EndorsementTypeRec.FINDLAST THEN BEGIN
            "Endorsement Type" := EndorsementTypeRec.Code;
            VALIDATE("Endorsement Type");
        END;

        "Quote Type" := "Quote Type"::New;
        "Cover Type" := "Cover Type"::Individual;
        //MESSAGE('%1',"Quote Type");
    end;

    trigger OnOpenPage();
    begin
        IF "Action Type" = "Action Type"::"Yellow Card" THEN
            AllowEditingCoverEndDate := TRUE;
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        InsuranceMgnt: Codeunit "Insurance management";
        Quotation: Report "Insurance Quote1";
        EndorsementTypeRec: Record "Endorsement Types";
        AllowEditingCoverEndDate: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;

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

