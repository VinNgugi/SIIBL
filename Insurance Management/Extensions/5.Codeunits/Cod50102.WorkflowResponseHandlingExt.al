codeunit 50102 "Workflow Response Handling Ext"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    procedure "Workflow Response Handling_OnAddWorkflowResponsesToLibrary"()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    procedure "Workflow Response Handling_OnAddWorkflowResponsePredecessorsToLibrary"(ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode():
                begin
                    //***********************Customer
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode());
                    //***********************Insure Header
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkflowEventHandlingExt.RunWorkflowOnsendInsureHeaderApprovalRequestCode());
                    //***********************Payments Header
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(), WorkflowEventHandlingExt.RunWorkflowOnsendPaymentsHeaderApprovalRequestCode());
                end;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
                begin
                    //***********************Insure Header
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkflowEventHandlingExt.RunWorkflowOnsendInsureHeaderApprovalRequestCode());
                    //***********************Payments Header
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(), WorkflowEventHandlingExt.RunWorkflowOnsendPaymentsHeaderApprovalRequestCode());
                end;
            WorkflowResponseHandling.ReleaseDocumentCode():
                begin
                    //***********************Insure Header
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), WorkflowEventHandlingExt.RunWorkflowOnsendInsureHeaderApprovalRequestCode());
                    //***********************Payments Header
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.ReleaseDocumentCode(), WorkflowEventHandlingExt.RunWorkflowOnsendPaymentsHeaderApprovalRequestCode());
                end;
            WorkflowResponseHandling.CancelAllApprovalRequestsCode():
                begin
                    //***********************Insure Header
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkflowEventHandlingExt.RunWorkflowOnCancelInsureHeaderApprovalRequestCode());
                    //***********************Payments Header
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(), WorkflowEventHandlingExt.RunWorkflowOnCancelPaymentsHeaderApprovalRequestCode());
                end;
            WorkflowResponseHandling.OpenDocumentCode():
                begin
                    //***********************Customer
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkflowEventHandling.RunWorkflowOnCancelCustomerApprovalRequestCode());
                    //***********************Insure Header
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkflowEventHandlingExt.RunWorkflowOnCancelInsureHeaderApprovalRequestCode());
                    //***********************Payments Header
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(), WorkflowEventHandlingExt.RunWorkflowOnCancelPaymentsHeaderApprovalRequestCode());
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure "Workflow Response Handling_OnOpenDocument"
    (
        RecRef: RecordRef;
        var Handled: Boolean
    )
    var
        ObjCust: Record Customer;
        ObjInsureH: Record "Insure Header";
        ObjPaymentH: Record Payments1;
    begin
        case RecRef.Number of
            Database::Customer:
                begin
                    RecRef.SetTable(ObjCust);
                    ObjCust."Approval Status" := ObjCust."Approval Status"::Open;
                    ObjCust.Modify(true);
                    Handled := true;
                end;
            Database::"Insure Header":
                begin
                    RecRef.SetTable(ObjInsureH);
                    ObjInsureH.Validate(Status, ObjInsureH.Status::Open);
                    ObjInsureH.Modify(true);
                    Handled := true;
                end;
            Database::Payments1:
                begin
                    RecRef.SetTable(ObjPaymentH);
                    ObjPaymentH.Validate(Status, ObjPaymentH.Status::Open);
                    ObjPaymentH.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure "Workflow Response Handling_OnReleaseDocument"
    (
        RecRef: RecordRef;
        var Handled: Boolean
    )
    var
        ObjCust: Record Customer;
        ObjInsureH: Record "Insure Header";
        ObjPaymentsH: Record Payments1;
    begin
        case RecRef.Number of
            Database::Customer:
                begin
                    RecRef.SetTable(ObjCust);
                    ObjCust."Approval Status" := ObjCust."Approval Status"::Approved;
                    ObjCust.Modify(true);
                    Handled := true;

                end;
            Database::"Insure Header":
                begin
                    RecRef.SetTable(ObjInsureH);
                    ObjInsureH.Validate(Status, ObjInsureH.Status::Released);
                    ObjInsureH.Modify(true);
                    Handled := true;
                end;
            Database::Payments1:
                begin
                    RecRef.SetTable(ObjPaymentsH);
                    ObjPaymentsH.Validate(Status, ObjPaymentsH.Status::Released);
                    ObjPaymentsH.Modify(true);
                    Handled := true;
                end;
        end;
    end;


    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext";
}
