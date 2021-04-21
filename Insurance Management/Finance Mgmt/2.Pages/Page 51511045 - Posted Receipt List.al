page 51511045 "Posted Receipt List"
{
    // version FINANCE

    CardPageID = "Posted Receipt";
    Editable = false;
    PageType = List;
    SourceTable = "Receipts Header";
    SourceTableView = WHERE(Posted = CONST(True));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(Date; Date)
                {
                    Editable = false;
                }
                field("Pay Mode"; "Pay Mode")
                {
                    Editable = false;
                }
                field("Cheque No"; "Cheque No")
                {
                    Editable = false;
                }
                field("Cheque Date"; "Cheque Date")
                {
                    Editable = false;
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Amount(LCY)"; "Amount(LCY)")
                {
                    Editable = false;
                }
                field("Bank Code"; "Bank Code")
                {
                    Editable = false;
                }
                field("Received From"; "Received From")
                {
                    Editable = false;
                }
                field("On Behalf Of"; "On Behalf Of")
                {
                    Editable = false;
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
                    Editable = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Procurement Method"; "Procurement Method")
                {
                    Editable = false;
                }
                field("Procurement Request"; "Procurement Request")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
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

