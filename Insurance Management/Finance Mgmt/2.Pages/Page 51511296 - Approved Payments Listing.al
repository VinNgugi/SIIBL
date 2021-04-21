page 51511296 "Approved Payments Listing"
{
    // version AES-INS 1.0

    CardPageID = "Payment Voucher";
    Editable = false;
    PageType = List;
    SourceTable = 51511000;
    SourceTableView = WHERE(Posted = CONST(false), Status = FILTER(Released));

    layout
    {
        area(content)
        {
            repeater(Listing)
            {
                field(No; No)
                {
                }
                field(Date; Date)
                {
                }
                field("Date Posted"; "Date Posted")
                {
                }
                field(Type; Type)
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
                field("Cheque Type"; "Cheque Type")
                {
                }
                field("KBA Bank Code"; "KBA Bank Code")
                {
                }
                field(Payee; Payee)
                {
                }
                field(Status; Status)
                {
                }
                field("Paying Bank Account"; "Paying Bank Account")
                {
                }
                field("Net Amount"; "Net Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

