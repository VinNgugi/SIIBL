page 51513238 "Maturity Payment Schedule"
{
    
     // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Payment Instalment Plan";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment No"; "Payment No")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Amount Due"; "Amount Due")
                {
                }
                field("Amount Paid"; "Amount Paid")
                {
                }
                field(Paid; Paid)
                {
                }
                field("Instalment Percentage"; "Instalment Percentage")
                {
                }
                field("Period Length"; "Period Length")
                {
                }
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                }
                field("Drawer/Payee Name"; "Drawer/Payee Name")
                {
                }
                field("Drawer/Payee Account No."; "Drawer/Payee Account No.")
                {
                }
                field("Cheque No."; "Cheque No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

