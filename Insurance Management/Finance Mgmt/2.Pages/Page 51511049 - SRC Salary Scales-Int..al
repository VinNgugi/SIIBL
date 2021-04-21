page 51511049 "SRC Salary Scales-Int."
{
    // version FINANCE

    Caption = 'SRC Salary Scales-International';
    PageType = List;
    SourceTable = "SRC Scales-International";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Salary Scale"; "Salary Scale")
                {
                }
                field(Country; Country)
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
    }
}

