pageextension 50101 "Approval Entries Ext" extends "Approval Entries"
{
    procedure SetfiltersNew(TableId: Integer; DocumentType: Enum "Approval Document Type"; DocumentNo: Code[20])
    begin
        if TableId <> 0 then begin
            FilterGroup(2);
            SetCurrentKey("Table ID", "Document Type", "Document No.", "Date-Time Sent for Approval");
            SetRange("Table ID", TableId);
            SetRange("Document Type", DocumentType);
            if DocumentNo <> '' then
                SetRange("Document No.", DocumentNo);
            FilterGroup(0);
        end;
    end;
}
