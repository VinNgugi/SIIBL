page 51511062 "Request Listing"
{
    // version FINANCE

    CardPageID = "Imprest Header";
    Editable = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST(Imprest));

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
                    Visible = false;
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
        SETRANGE("User ID", USERID);
        /*
        IF UserSetup.GET(USERID) THEN BEGIN
        SETRANGE("Employee No",UserSetup."Employee No.");
        END;
        */
        //SETFILTER(Status,'<>%1',Status::Released);

    end;

    var
        ApprovalMgt: Codeunit 40;
        UserSetup: Record "User Setup";
        ApprovalSetup: Record "G/L Account";
        UserSetupRec: Record "User Setup";
        Trash: Record "Request Header";
        Filterstring: Text[250];
}

