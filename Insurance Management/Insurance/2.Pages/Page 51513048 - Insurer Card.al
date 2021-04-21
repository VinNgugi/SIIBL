page 51513048 "Insurer Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = Customer;
    SourceTableView = WHERE("Customer Type" = CONST(Insurer));

    layout
    {
        area(content)
        {
            group(Biodata)
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
            }
            group(Communication)
            {
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field(City; City)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field(Mobile; Mobile)
                {
                }
                field("Approval Status"; "Approval Status")
                {

                }
            }
            group(Accounting)
            {
                field(Balance; Balance)
                {
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
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
                        IF ApprovalsMgmt.CheckCustomerApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmt.OnSendCustomerForApproval(Rec);
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
                        IF ApprovalsMgmt.CheckCustomerApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);
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

        }
    }


    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Document Type" := "Document Type"::"Insurer Reg";
        "Customer Type" := "Customer Type"::Insurer;
        IF "Customer Type" = "Customer Type"::Insurer THEN
            "Customer Posting Group" := InsSetup."Default Insurer PG";
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin

    end;

    var
        InsSetup: Record "Insurance setup";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
}

