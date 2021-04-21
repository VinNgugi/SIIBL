page 51511017 "Claim Accounting Lines"
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
                field("Transaction Type"; "Transaction Type")
                {
                    Editable = true;
                    Visible = false;
                }
                field("Expense Type"; "Expense Type")
                {
                    Editable = false;
                }
                field("Account Type"; "Account Type")
                {
                    Editable = false;
                }
                field("Account No"; "Account No")
                {
                    Editable = true;
                }
                field(Description; Description)
                {
                    Editable = true;
                }
                field(Quantity; Quantity)
                {
                    Editable = true;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Editable = true;
                }
                field("Unit Price"; "Unit Price")
                {
                    Editable = true;
                }
                field("USD Amount"; "USD Amount")
                {
                }
                field(Amount; Amount)
                {
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field(ReceiptNo; ReceiptNo)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // IF PAGE.RUNMODAL(51511705,ReceiptHeader)=ACTION::LookupOK THEN
                        // ReceiptNo:=ReceiptHeader."No.";
                    end;
                }
                field("Requested Amount"; "Requested Amount")
                {
                    Editable = false;
                    Visible = true;
                }
                field("Actual Spent"; "Actual Spent")
                {
                    Importance = Promoted;
                    Visible = true;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    Editable = false;
                    Enabled = true;
                    Visible = true;
                }
                field(Surrender; Surrender)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Exchange Rate"; "Exchange Rate")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Caption = 'Acitivity';
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
}

