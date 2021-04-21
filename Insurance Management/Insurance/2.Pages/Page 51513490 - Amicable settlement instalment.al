page 51513490 "Amicable settlement instalment"
{
    // version AES-INS 1.0

    PageType = ListPart;
    SourceTable = "Instalment Payment Plan";
    SourceTableView = WHERE("Document Type" = CONST("Amicable Settlements"));

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
            }
        }
    }

    actions
    {
    }
}

