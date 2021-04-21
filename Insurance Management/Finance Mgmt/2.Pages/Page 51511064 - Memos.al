page 51511064 Memos
{
    // version FINANCE

    CardPageID = "Memo Card-Fin";
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
}

