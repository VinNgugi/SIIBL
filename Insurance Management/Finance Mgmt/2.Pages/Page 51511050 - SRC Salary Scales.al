page 51511050 "SRC Salary Scales"
{
    // version FINANCE

    PageType = List;
    SourceTable = "SRC Scales Local";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Salary Scale"; "Salary Scale")
                {
                    Caption = '<Allowance Scale>';
                }
                field("SRC Cluster"; "SRC Cluster")
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

