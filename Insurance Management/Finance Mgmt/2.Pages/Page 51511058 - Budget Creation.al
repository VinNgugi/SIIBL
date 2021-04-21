page 51511058 "Budget Creation"
{
    // version FINANCE

    CardPageID = "Budget Creation Card";
    PageType = List;
    SourceTable = "Budget Creation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Creation No"; "Creation No")
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

