page 51511054 "Budget Approvals"
{
    // version FINANCE

    Caption = 'Budget Transfers';
    CardPageID = "Budget Approval Card";
    PageType = List;
    SourceTable = "Budget Approval";
    SourceTableView = WHERE(Status = FILTER(<> Released));

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

