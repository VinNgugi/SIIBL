page 51511042 "Receipts Line"
{
    // version FINANCE

    PageType = ListPart;
    SourceTable = "Receipt Lines";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("Receipt Transaction Type"; "Receipt Transaction Type")
                {
                    Visible = false;
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Account Name"; "Account Name")
                {
                }
                field(Description; Description)
                {
                }
                field("Customer Transaction type"; "Customer Transaction type")
                {
                    Visible = false;
                }
                field("Applies-to Doc. Type"; "Applies-to Doc. Type")
                {
                }
                field("Applies to Doc. No"; "Applies to Doc. No")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Net Amount"; "Net Amount")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

