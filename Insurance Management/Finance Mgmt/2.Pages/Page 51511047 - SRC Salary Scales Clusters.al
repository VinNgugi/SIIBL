page 51511047 "SRC Salary Scales Clusters"
{
    // version FINANCE

    PageType = List;
    SourceTable = "Leave Allowance Table";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cluster Code"; "Cluster Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Pay Type"; "Pay Type")
                {
                }
                field("Flat Amount"; "Flat Amount")
                {
                }
                field(Percentage; Percentage)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Cluster Place")
            {
                Image = CountryRegion;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 51511048;
                RunPageLink = "Cluster Code"=FIELD("Cluster Code");
            }
        }
    }
}

