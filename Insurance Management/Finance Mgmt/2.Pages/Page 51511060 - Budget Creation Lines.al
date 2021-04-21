page 51511060 "Budget Creation Lines"
{
    // version FINANCE

    PageType = ListPart;
    SourceTable = "Budget Creation Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Creation No"; "Creation No")
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
                field("G/L Account"; "G/L Account")
                {
                }
                field("G/L Account Name"; "G/L Account Name")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {
                }
                field("No of Budget Periods"; "No of Budget Periods")
                {
                }
            }
        }
    }

    actions
    {
    }
}

