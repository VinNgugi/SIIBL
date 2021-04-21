page 51511057 "Approved Budget Approvals"
{
    // version FINANCE

    CardPageID = "Budget Approval Card";
    PageType = List;
    SourceTable = "Budget Approval";
    SourceTableView = WHERE(Status = CONST(Released));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Approval No"; "Approval No")
                {
                }
                field("Destination Department"; "Destination Department")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Current Budget"; "Current Budget")
                {
                }
                field("Requesting User"; "Requesting User")
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
    }
}

