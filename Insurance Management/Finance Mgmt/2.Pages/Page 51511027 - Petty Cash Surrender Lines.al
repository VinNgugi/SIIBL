page 51511027 "Petty Cash Surrender Lines"
{
    // version FINANCE

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Petty Cash Lines";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("Activity Type"; "Activity Type")
                {
                }
                field(Activity; Activity)
                {
                }
                field("Account Type"; "Account Type")
                {
                    Editable = false;
                }
                field("Account No"; "Account No")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {
                    Caption = 'Approved Amount';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        /*
        RequestHeader.SETRANGE(RequestHeader."No.","Document No");
         IF RequestHeader.Status<>RequestHeader.Status::Open THEN
         ERROR('You cannot modify this document at this stage');
        */

    end;

    trigger OnModifyRecord(): Boolean
    begin
        /*
          RequestHeader.SETRANGE(RequestHeader."No.","Document No");
          IF RequestHeader.Status<>RequestHeader.Status::Open THEN
          ERROR('You cannot modify this document at this stage');
          */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //  Surrender:=TRUE;
    end;

    var
        RequestHeader: Record "Request Header";
        ReceiptHeader: Record "Receipts Header";
}

