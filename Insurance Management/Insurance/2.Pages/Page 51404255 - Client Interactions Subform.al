page 51404255 "Client Interactions Subform"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New subform created for Complaint Incedent Line

    AutoSplitKey = true;
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = Card;
    SourceTable ="Client Interaction Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Action Type";"Action Type")
                {
                }
                field("User ID-";"User ID-")
                {
                }
                field("Date and Time";"Date and Time")
                {
                }
                field(Description;Description)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnModifyRecord(): Boolean
    begin
        IF CompHeader.GET("Client Interaction No.") THEN BEGIN
          IF CompHeader."Current Status" = CompHeader."Current Status"::Escalated THEN BEGIN
            ERROR(Text001);
          END;
        END;
    end;

    var
        CompHeader: Record "Client Interaction Header";
        Text001: Label 'You can not modified the record. Status is Closed.';

    procedure ShowLineComments()
    begin
        //Rec.ShowLineComments;
    end;

    procedure RecGet(var RecClientLine: Record "Client Interaction Line")
    begin
    end;
}

