tableextension 50122 "Workflows Entries Buffer Ext" extends "Workflows Entries Buffer"
{
    fields
    {

    }
    procedure RunWorkflowEntriesPageNew(RecordIDInput: RecordID; TableId: Integer; DocumentType: Enum "Approval Document Type"; DocumentNo: Code[20])
    var
        ApprovalEntry: Record "Approval Entry";
        WorkflowWebhookEntry: Record "Workflow Webhook Entry";
        Approvals: Page Approvals;
        WorkflowWebhookEntries: Page "Workflow Webhook Entries";
        ApprovalEntries: Page "Approval Entries";
    begin
        // if we are looking at a particular record, we want to see only record related workflow entries
        if DocumentNo <> '' then begin
            ApprovalEntry.SetRange("Record ID to Approve", RecordIDInput);
            WorkflowWebhookEntry.SetRange("Record ID", RecordIDInput);
            // if we have flows created by multiple applications, start generic page filtered for this RecordID
            if ApprovalEntry.FindFirst and WorkflowWebhookEntry.FindFirst then begin
                Approvals.Setfilters(RecordIDInput);
                Approvals.Run;
            end else begin
                // otherwise, open the page filtered for this record that corresponds to the type of the flow
                if WorkflowWebhookEntry.FindFirst then begin
                    WorkflowWebhookEntries.Setfilters(RecordIDInput);
                    WorkflowWebhookEntries.Run;
                    exit;
                end;

                if ApprovalEntry.FindFirst then begin
                    ApprovalEntries.SetfiltersNew(TableId, DocumentType, DocumentNo);
                    ApprovalEntries.Run;
                    exit;
                end;

                // if no workflow exist, show (empty) joint workflows page
                Approvals.Setfilters(RecordIDInput);
                Approvals.Run;
            end
        end else
            // otherwise, open the page with all workflow entries
            Approvals.Run;
    end;
}
