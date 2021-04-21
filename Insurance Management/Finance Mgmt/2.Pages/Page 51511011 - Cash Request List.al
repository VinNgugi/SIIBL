page 51511011 "Cash Request List"
{
    // version FINANCE

    CardPageID = Claims_Refund;
    Editable = false;
    PageType = List;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST("Claim/Refund"),
                            Status=FILTER(<>Released));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No.";"No.")
                {
                }
                field("Employee No";"Employee No")
                {
                }
                field("Employee Name";"Employee Name")
                {
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                }
                field("Customer A/C";"Customer A/C")
                {
                }
                field("Imprest Amount";"Imprest Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Visible = false;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Visible = false;
            }
            action(Post)
            {
                Caption = 'Post';
                Visible = false;

                trigger OnAction()
                begin
                    // PostPayments;
                end;
            }
        }
    }
}

