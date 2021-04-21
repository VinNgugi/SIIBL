codeunit 50101 "Workflow Event Handling Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure "Workflow Event Handling_OnAddWorkflowEventPredecessorsToLibrary"(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    //********************************Insure Header
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnsendInsureHeaderApprovalRequestCode());
                    //********************************Payment Header
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnsendPaymentsHeaderApprovalRequestCode());
                end;
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                begin
                    //********************************Insure Header
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode(), RunWorkflowOnsendInsureHeaderApprovalRequestCode());
                    //********************************Payment Header
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode(), RunWorkflowOnsendPaymentsHeaderApprovalRequestCode());
                end;
            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                begin
                    //********************************Insure Header
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunWorkflowOnsendInsureHeaderApprovalRequestCode());
                    //********************************Payment Header
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunWorkflowOnsendPaymentsHeaderApprovalRequestCode());
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowTableRelationsToLibrary', '', true, true)]
    local procedure "Workflow Event Handling_OnAddWorkflowTableRelationsToLibrary"()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure "Workflow Event Handling_OnAddWorkflowEventsToLibrary"()
    begin
        //********************************Insure Header
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnsendInsureHeaderApprovalRequestCode(), Database::"Insure Header", SendInsureHForApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelInsureHeaderApprovalRequestCode(), Database::"Insure Header", CancelInsureHForApprovalTxt, 0, false);
        //********************************Payments Header
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnsendPaymentsHeaderApprovalRequestCode(), Database::"Insure Header", SendPaymentsHForApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnsendPaymentsHeaderApprovalRequestCode(), Database::"Insure Header", CancelPaymentsHForApprovalTxt, 0, false);
    end;


    //**********************************************Insure Header Fxns********************************************************//
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Ext", 'OnSendInsureHeaderApprovalRequest', '', true, true)]
    procedure RunWorkflowOnsendInsureHeaderApprovalRequest(ObjInsureH: Record "Insure Header")
    begin
        WFMgmt.HandleEvent(RunWorkflowOnsendInsureHeaderApprovalRequestCode(), ObjInsureH);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Ext", 'OnCancelInsureHeaderApprovalRequest', '', true, true)]
    procedure RunWorkflowOnCancelInsureHeaderApprovalRequest(ObjInsureH: Record "Insure Header")
    begin
        WFMgmt.HandleEvent(RunWorkflowOnCancelInsureHeaderApprovalRequestCode(), ObjInsureH);
    end;

    procedure RunWorkflowOnsendInsureHeaderApprovalRequestCode(): Code[128];
    var

    begin
        exit(UpperCase('RunWorkflowOnsendInsureHeaderApprovalRequest'))
    end;

    procedure RunWorkflowOnCancelInsureHeaderApprovalRequestCode(): Code[128]
    var

    begin
        exit(UpperCase('RunWorkflowOnCancelInsureHeaderApprovalRequest'))
    end;
    //**********************************************Insure Header Fxns********************************************************//
    //**********************************************Payments Header Fxns********************************************************//
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Ext", 'OnSendPaymentsHeaderApprovalRequest', '', true, true)]
    procedure RunWorkflowOnsendPaymentsHeaderApprovalRequest(ObjPaymentsH: Record Payments1)
    begin
        WFMgmt.HandleEvent(RunWorkflowOnsendPaymentsHeaderApprovalRequestCode(), ObjPaymentsH);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt. Ext", 'OnCancelPaymentsHeaderApprovalRequest', '', true, true)]
    procedure RunWorkflowOnCancelPaymentsHeaderApprovalRequest(ObjPaymentsH: Record Payments1)
    begin
        WFMgmt.HandleEvent(RunWorkflowOnCancelPaymentsHeaderApprovalRequestCode(), ObjPaymentsH);
    end;

    procedure RunWorkflowOnsendPaymentsHeaderApprovalRequestCode(): Code[128];
    var

    begin
        exit(UpperCase('RunWorkflowOnsendPaymentsHeaderApprovalRequest'))
    end;

    procedure RunWorkflowOnCancelPaymentsHeaderApprovalRequestCode(): Code[128]
    var

    begin
        exit(UpperCase('RunWorkflowOnCancelPaymentsHeaderApprovalRequest'))
    end;
    //**********************************************Payments Header Fxns********************************************************//
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WFMgmt: Codeunit "Workflow Management";
        SendInsureHForApprovalTxt: TextConst ENU = 'Insure Header Application is sent for Approval', ENG = 'Insure Header Application is sent for Approval';
        CancelInsureHForApprovalTxt: TextConst ENU = 'Insure Header Application Request is Cancelled', ENG = 'Insure Header Application Request is Cancelled';
        SendPaymentsHForApprovalTxt: TextConst ENU = 'Payments Header Application is sent for Approval', ENG = 'Payments Header Application is sent for Approval';
        CancelPaymentsHForApprovalTxt: TextConst ENU = 'Payments Header Application Request is Cancelled', ENG = 'Payments Header Application Request is Cancelled';
}
