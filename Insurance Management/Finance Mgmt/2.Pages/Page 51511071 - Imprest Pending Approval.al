page 51511071 "Imprest Pending Approval"
{
    // version FINANCE

    CardPageID = "Imprest Header";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST(Imprest),
                            Status = CONST("Pending Approval"),
                            Archived=CONST(False),
                            "PV Posted"=CONST(False));

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("No."; "No.")
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Trip No"; "Trip No")
                {
                    Visible = false;
                }
                field("Employee No"; "Employee No")
                {
                }
                field(Country; Country)
                {
                    Visible = false;
                }
                field(City; City)
                {
                    Visible = false;
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field("Trip Start Date"; "Trip Start Date")
                {
                    Visible = false;
                }
                field("Trip Expected End Date"; "Trip Expected End Date")
                {
                    Visible = false;
                }
                field("No. of Days"; "No. of Days")
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("No. Series"; "No. Series")
                {
                    Visible = false;
                }
                field("Deadline for Return"; "Deadline for Return")
                {
                }
                field(Status; Status)
                {
                }
                field(Type; Type)
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Bank Account"; "Bank Account")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Transaction Type"; "Transaction Type")
                {
                    Visible = false;
                }
                field("Customer A/C"; "Customer A/C")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Imprest Amount"; "Imprest Amount")
                {
                }
                field(Balance; Balance)
                {
                }
                field("Activity Date"; "Activity Date")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Archive)
            {
                Image = Agreement;

                trigger OnAction()
                begin
                    Archived := TRUE;
                    MODIFY;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;
}

