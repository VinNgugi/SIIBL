page 51511039 "Partial Imprest Issues"
{
    // version FINANCE

    CardPageID = "Partial Imprest Issues";
    Editable = true;
    PageType = List;
    SourceTable = "Partial Imprest Issue";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Imprest No"; "Imprest No")
                {
                    Editable = false;
                }
                field("Employee No"; "Employee No")
                {
                    Editable = false;
                }
                field(Date; Date)
                {
                }
                field("Approved Amount"; "Approved Amount")
                {
                    Editable = false;
                }
                field("Amount Already Issued"; "Amount Already Issued")
                {
                    Editable = false;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    Editable = false;
                }
                field("Pay Mode"; "Pay Mode")
                {
                }
                field("Amount to Issue"; "Amount to Issue")
                {
                }
                field(Posted; Posted)
                {
                }
                field("Select to Surrender"; "Select to Surrender")
                {
                }
            }
        }
    }

    actions
    {
    }
}

