page 51511285 "Imprest Transaction Types"
{
    // version FINANCE

    PageType = List;
    SourceTable = "Transaction Types";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field("Transaction Name"; "Transaction Name")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Default Amount"; "Default Amount")
                {
                }
                field("Per Diem"; "Per Diem")
                {
                }
            }
        }
    }

    actions
    {
    }
}

