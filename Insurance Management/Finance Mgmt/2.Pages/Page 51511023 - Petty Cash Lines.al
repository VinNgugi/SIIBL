page 51511023 "Petty Cash Lines"
{
    // version FINANCE

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Request Lines";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field(Type; Type)
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No"; "Account No")
                {
                    Caption = 'Account No.';
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Current Budget"; "Current Budget")
                {
                    Visible = false;
                }
                field("Available Amount"; "Available Amount")
                {
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 3 Code"; "Global Dimension 3 Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        GLSetup.GET;
        "Current Budget" := GLSetup."Current Budget";
    end;

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

    var
        RequestHeader: Record "Request Header";
        ReceiptHeader: Record 51511027;
        GLSetup: Record "Cash Management Setup";
}

