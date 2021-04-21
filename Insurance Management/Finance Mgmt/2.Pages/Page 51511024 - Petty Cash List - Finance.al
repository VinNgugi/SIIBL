page 51511024 "Petty Cash List - Finance"
{
    // version FINANCE

    CardPageID = "Finance Petty Cash Header";
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    PageType = List;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST(PettyCash),
                            Posted = CONST(False));

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("Petty Cash Serials"; "Petty Cash Serials")
                {
                    Caption = 'Petty Cash No.';
                }
                field("Imprest/Advance No"; "Imprest/Advance No")
                {
                    Caption = 'Imprest Source No.';
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
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
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
                    Visible = false;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    Visible = false;
                }
                field("Customer A/C"; "Customer A/C")
                {
                }
                field("Imprest Amount"; "Imprest Amount")
                {
                }
                field(Balance; Balance)
                {
                }
                field(Posted; Posted)
                {
                }
                field(Surrendered; Surrendered)
                {
                }
                field(Partial; Partial)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = true;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //SETFILTER(Posted,'%1',TRUE);
        //SETFILTER(Partial,'%1',TRUE);
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;
}

