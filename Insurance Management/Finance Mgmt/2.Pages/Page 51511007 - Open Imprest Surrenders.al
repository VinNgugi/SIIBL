page 51511007 "Open Imprest Surrenders"
{
    // version FINANCE

    CardPageID = "Finance Claim Header";
    Editable = false;
    PageType = List;
    SourceTable = "Request Header";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Type = CONST("Claim-Accounting"),
                            Status = FILTER(<> Released),
                            Posted = CONST(False));

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
                }
                field(City; City)
                {
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field("Trip Start Date"; "Trip Start Date")
                {
                }
                field("Trip Expected End Date"; "Trip Expected End Date")
                {
                }
                field("No. of Days"; "No. of Days")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("No. Series"; "No. Series")
                {
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
                }
                field("Customer A/C"; "Customer A/C")
                {
                    Editable = FALSE;
                }
                field("Imprest Amount"; "Imprest Amount")
                {
                }
                field(Balance; Balance)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
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

