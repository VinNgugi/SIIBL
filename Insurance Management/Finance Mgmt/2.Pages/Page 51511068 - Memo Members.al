page 51511068 "Memo Members"
{
    // version FINANCE

    PageType = ListPart;
    SourceTable = "Memo Lines-Members";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Memo No"; "Memo No")
                {
                    Visible = false;
                }
                field("Budget Name"; "Budget Name")
                {
                    Visible = false;
                }
                field(Department; Department)
                {
                    Visible = false;
                }
                field("Line No"; "Line No")
                {
                    Visible = false;
                }
                field("Member ID"; "Member ID")
                {
                }
                field("Member Name"; "Member Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

