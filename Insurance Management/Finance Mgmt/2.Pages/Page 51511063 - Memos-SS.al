page 51511063 "Memos-SS"
{
    // version FINANCE

    Caption = 'ERC Memos';
    CardPageID = "Memo Card";
    PageType = List;
    SourceTable = "Memo";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Memo No"; "Memo No")
                {
                }
                field("Budget Name"; "Budget Name")
                {
                }
                field(Department; Department)
                {
                }
                field("Created By:"; "Created By:")
                {
                }
                field("Date Created"; "Date Created")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field(Status; Status)
                {
                }
                field("No. of Approvers"; "No. of Approvers")
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
        SETRANGE("Created By:", USERID);
    end;
}

