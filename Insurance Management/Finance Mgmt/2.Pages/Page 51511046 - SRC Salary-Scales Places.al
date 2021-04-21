page 51511046 "SRC Salary-Scales Places"
{
    // version FINANCE

    Caption = 'SRC Salary-Scales Cluster Places';
    PageType = ListPart;
    SourceTable = "SRC Cluster Places";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cluster Code"; "Cluster Code")
                {
                }
                field("Cluster Place"; "Cluster Place")
                {
                }
            }
        }
    }

    actions
    {
    }
}

