codeunit 50103 "Page Management Ext"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', true, true)]
    local procedure "Page Management_OnAfterGetPageID"
    (
        RecordRef: RecordRef;
        var PageID: Integer
    )
    begin

    end;

    local procedure GetConditionalCardPageID(RecordRef: RecordRef): Integer
    var

    begin
        case RecordRef.Number of
        //database::Insurance:
        //exit();
        end;
    end;

    local procedure MyProcedure()
    var
        myInt:
            Integer;
    begin

    end;

}
