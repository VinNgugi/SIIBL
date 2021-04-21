page 51511043 "Receipt List"
{
    // version FINANCE

    CardPageID = Receipt;
    PageType = List;
    SourceTable = "Receipts Header";
    SourceTableView = WHERE(Posted = CONST(False));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Date; Date)
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
                field("Procurement Method"; "Procurement Method")
                {
                }
                field("Procurement Request"; "Procurement Request")
                {
                }
                field(Status; Status)
                {
                }
                field(Banked; Banked)
                {
                }
            }
        }
    }

    actions
    {
    }
}

