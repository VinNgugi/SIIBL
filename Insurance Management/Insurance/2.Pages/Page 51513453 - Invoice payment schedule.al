page 51513453 "Invoice payment schedule"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Instalment Payment Plan";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                }
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
            }
        }
    }

    actions
    {
    }
}

