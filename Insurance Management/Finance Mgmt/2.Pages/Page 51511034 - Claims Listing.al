page 51511034 "Claims Listing"
{
    // version FINANCE

    //CardPageID = "Claim Header";
    Editable = false;
    PageType = List;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST("Claim-Accounting"));

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
    }

    trigger OnOpenPage()
    begin
        /*//SETRANGE("User ID",USERID);
        IF UserSetup.GET(USERID) THEN BEGIN
        SETRANGE("Employee No",UserSetup."Employee No.");
        END;
        SETFILTER(Posted,'%1',FALSE);
        */
        //Rec.SETRANGE("User ID",USERID);

    end;

    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        UserSetup: Record "User Setup";
        ApprovalSetup: Record "G/L Account";
        UserSetupRec: Record "User Setup";
        Filterstring: Text[250];
}

