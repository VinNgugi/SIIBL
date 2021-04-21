codeunit 50100 "Approvals Mgmt. Ext"
{
    //*************************************Insurance Quote Fxns
    [IntegrationEvent(false, false)]
    procedure OnSendInsureHeaderApprovalRequest(Var ObjInsureH: Record "Insure Header")
    var
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelInsureHeaderApprovalRequest(Var ObjInsureH: Record "Insure Header")
    var
    begin

    end;

    procedure CheckInsureHeaderApprovalWFEnabled(Var ObjInsureH: Record "Insure Header"): Boolean
    var
    begin
        if not IsInsureheaderApprovalWFEnabled(ObjInsureH) then
            Error(NoworkflowEnb);

        exit(true);
    end;

    procedure IsInsureheaderApprovalWFEnabled(Var ObjInsureH: Record "Insure Header"): Boolean
    var
    begin
        exit(WorkflowManagement.CanExecuteWorkflow(ObjInsureH, WorkflowEventHandlingExt.RunWorkflowOnsendInsureHeaderApprovalRequestCode()))
    end;
    //*************************************Insurance Quote Fxns
    //*************************************Payments Header Fxns
    [IntegrationEvent(false, false)]
    procedure OnSendPaymentsHeaderApprovalRequest(Var ObjPaymentsH: Record Payments1)
    var
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPaymentsHeaderApprovalRequest(Var ObjPaymentsH: Record Payments1)
    var
    begin

    end;

    procedure CheckPaymentsHeaderApprovalWFEnabled(Var ObjPaymentsH: Record Payments1): Boolean
    var
    begin
        if not IsPaymentsHeaderApprovalWFEnabled(ObjPaymentsH) then
            Error(NoworkflowEnb);

        exit(true);
    end;

    procedure IsPaymentsHeaderApprovalWFEnabled(Var ObjPaymentsH: Record Payments1): Boolean
    var
    begin
        exit(WorkflowManagement.CanExecuteWorkflow(ObjPaymentsH, WorkflowEventHandlingExt.RunWorkflowOnsendInsureHeaderApprovalRequestCode()))
    end;
    //*************************************Payments Header Fxns

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    procedure "Approvals Mgmt._OnPopulateApprovalEntryArgument"(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ObjCust: Record Customer;
        ObjInsureH: Record "Insure Header";
        ObjPaymentsH: Record Payments1;
        EnumAssignmentMgt: Codeunit "Enum Assignment Mgmt";
    begin
        case RecRef.Number of
            Database::Customer:
                begin
                    RecRef.SetTable(ObjCust);
                    //CalcSalesDocAmount(ObjCust, ApprovalAmount, ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := EnumAssignmentMgt.GetCustomerApprovalDocumentType(ObjCust."Document Type");
                    ApprovalEntryArgument."Document No." := ObjCust."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := ObjCust."Salesperson Code";
                    //ApprovalEntryArgument.Amount := ApprovalAmount;
                    //ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := ObjCust."Currency Code";
                    //ApprovalEntryArgument."Available Credit Limit (LCY)" := GetAvailableCreditLimit(SalesHeader);

                end;
            Database::"Insure Header":
                begin
                    RecRef.SetTable(ObjInsureH);
                    //CalcSalesDocAmount(ObjInsureH, ApprovalAmount, ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := EnumAssignmentMgt.FnGetInsureHApprovalDocumentType(ObjInsureH."Approval Document Type");
                    ApprovalEntryArgument."Document No." := ObjInsureH."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := ObjInsureH."Salesperson Code";
                    //ApprovalEntryArgument.Amount := ApprovalAmount;
                    //ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := ObjInsureH."Currency Code";
                    //ApprovalEntryArgument."Available Credit Limit (LCY)" := GetAvailableCreditLimit(SalesHeader);
                end;
            Database::Payments1:
                begin
                    RecRef.SetTable(ObjPaymentsH);
                    //CalcSalesDocAmount(ObjPaymentsH, ApprovalAmount, ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := EnumAssignmentMgt.FnGetInsureHApprovalDocumentType(ObjPaymentsH."Approval Document Type");
                    ApprovalEntryArgument."Document No." := ObjPaymentsH.No;
                    //ApprovalEntryArgument."Salespers./Purch. Code" := ObjPaymentsH."Salesperson Code";
                    //ApprovalEntryArgument.Amount := ApprovalAmount;
                    //ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := ObjPaymentsH.Currency;
                    //ApprovalEntryArgument."Available Credit Limit (LCY)" := GetAvailableCreditLimit(SalesHeader);
                end;

        end
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    procedure "Approvals Mgmt._OnSetStatusToPendingApproval"(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        ObjCust: Record Customer;
        ObjInsureH: Record "Insure Header";
        ObjPaymentsH: Record Payments1;
    begin
        case RecRef.Number of
            Database::Customer:
                begin
                    RecRef.SetTable(ObjCust);
                    ObjCust.VALIDATE("Approval Status", ObjCust."Approval Status"::"Pending Approval");
                    ObjCust.MODIFY(TRUE);
                    Variant := ObjCust;
                    IsHandled := true;
                end;
            Database::"Insure Header":
                begin
                    RecRef.SetTable(ObjInsureH);
                    ObjInsureH.Validate(Status, ObjInsureH.Status::"Pending Approval");
                    ObjInsureH.Modify(true);
                    Variant := ObjInsureH;
                    IsHandled := true;
                end;
            Database::Payments1:
                begin
                    RecRef.SetTable(ObjPaymentsH);
                    ObjPaymentsH.Validate(Status, ObjPaymentsH.Status::"Pending Approval");
                    ObjPaymentsH.Modify(true);
                    Variant := ObjPaymentsH;
                    IsHandled := true;
                end;
        end;
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext";
        NoworkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';


}
