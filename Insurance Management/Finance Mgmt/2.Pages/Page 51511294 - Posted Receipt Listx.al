page 51511294 "Posted Receipt Listx"
{
    // version CSHBK

    CardPageID = "Posted Receiptx";
    Editable = false;
    PageType = List;
    SourceTable = 51513110;
    SourceTableView = WHERE(Posted = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Receipt No."; "Receipt No.")
                {
                }
                field("No."; "No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Pay Mode"; "Pay Mode")
                {
                }
                field("Cheque No"; "Cheque No")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Amount(LCY)"; "Amount(LCY)")
                {
                }
                field("Bank Code"; "Bank Code")
                {
                }
                field("Received From"; "Received From")
                {
                }
                field("On Behalf Of"; "On Behalf Of")
                {
                }
                field(Cashier; Cashier)
                {
                }
                field(Posted; Posted)
                {
                }
                field("Posted Date"; "Posted Date")
                {
                }
                field("Posted Time"; "Posted Time")
                {
                }
                field("Posted By"; "Posted By")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc("Receipt Date", "Receipt No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        Navigate: Page 344;
}

