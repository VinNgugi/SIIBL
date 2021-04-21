page 51513221 "Discounts Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST("Accepted Quote"));
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval,Posting,Prepare,Order,Request Approval,Print/Send,Navigate';

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
                    Caption = 'Inception Date';
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
                field("Instalment No."; "Instalment No.")
                {
                }
            }
            group(Cover)
            {
                field("Endorsement Type"; "Endorsement Type")
                {
                }
                field("Action Type"; "Action Type")
                {
                }
                field("Policy Type"; "Policy Type")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field("From Date"; "From Date")
                {
                    Caption = 'Policy Start Date';
                }
                field("To Date"; "To Date")
                {
                    Caption = 'Policy End Date';
                    Editable = false;
                }
                field("Payment Mode"; "Payment Mode")
                {
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                }
                field("No. Of Cover Periods"; "No. Of Cover Periods")
                {
                }
                field("Premium Financier"; "Premium Financier")
                {
                }
                field("Premium Financier Name"; "Premium Financier Name")
                {
                }
                field("Premium Finance %"; "Premium Finance %")
                {
                }
                field("Short Term Cover"; "Short Term Cover")
                {
                }
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
                {
                    Editable = false;
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
                field(Status; Status)
                {
                }
            }
            part("Schedule of Insured List Disc"; "Schedule of Insured List Disc")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData 348 = R;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = false;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = false;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction();
                begin
                    ShowDocDim;
                    CurrPage.SAVERECORD;
                end;
            }
            action("Add Vehicles")
            {
                RunObject = Page "Schedule of Insured List";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
            action("Policy Wordings")
            {
                RunObject = Page "Policy Wordings";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Description Type" = FILTER(<> "Schedule of Insured");
                RunPageView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.");
            }
            action("Additional/Extra Covers")
            {
                RunObject = Page "Additional Benefits";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
            action("Import Vehicles")
            {

                trigger OnAction();
                begin
                    ImportVehicles.GetRec(Rec);
                    ImportVehicles.RUN;
                end;
            }
            action("Loadings and Discounts")
            {
                RunObject = Page "Loadings and Discounts";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "No." = FIELD("No.");
            }
            action("Co-insurance")
            {
                RunObject = Page "Co-insurance";
                RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
            }
            action("Re-insurance")
            {
                RunObject = Page Reinsurance;
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "No." = FIELD("No.");
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
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action(Quote)
            {

                trigger OnAction();
                begin
                    /*Quotation.GetQuote(Rec);
                    Quotation.RUN;*/
                    RESET;
                    SETRANGE("Document Type", "Document Type");
                    SETFILTER("No.", "No.");
                    REPORT.RUN(51513514, TRUE, TRUE, Rec);
                    RESET;

                end;
            }
            action("Payment Schedule")
            {
                RunObject = Page "Payment Schedule";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action("Generate Policy ")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.InsertTaxesReinsurance(Rec);
                    InsuranceMgnt.ConvertQuote2Policy(Rec);
                    InsuranceMgnt.ConvertQuote2DebitNote(Rec);
                end;
            }
            action("Accept Quote")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.AcceptQuote(Rec);
                end;
            }

            action("Documents Required")
            {
                RunObject = Page "Insurance Documents";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No" = FIELD("No.");
            }
        }
        area(processing)
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
                    Caption = 'Approval Comments';
                    Image = Comment;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var

                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
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
                    Enabled = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var

                    begin
                        IF ApprovalsMgmtExt.CheckInsureHeaderApprovalWFEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendInsureHeaderApprovalRequest(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var

                    begin
                        IF ApprovalsMgmtExt.CheckInsureHeaderApprovalWFEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnCancelInsureHeaderApprovalRequest(Rec);
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approval Entries';
                    //Enabled = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var

                    begin
                        WorkflowsEntriesBuffer.RunWorkflowEntriesPageNew(RECORDID, DATABASE::Customer, "Document Type", "No.");

                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Apply Template")
                {
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        ConfigTemplateMgt: Codeunit 8612;
                        RecRef: RecordRef;
                    begin
                        RecRef.GETTABLE(Rec);
                        ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Document Type" := "Document Type"::"Accepted Quote";
        "Quote Type" := "Quote Type"::New;
        "Cover Type" := "Cover Type"::Individual;
        //MESSAGE('%1',"Quote Type");
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        InsuranceMgnt: Codeunit "Insurance management";
        //Quotation: Report "Insurance Quote-Broker";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approvals Mgmt. Ext";
        ImportVehicles: XMLport "Import Motor vehicles";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
        ShowWorkflowStatus: Boolean;
}


