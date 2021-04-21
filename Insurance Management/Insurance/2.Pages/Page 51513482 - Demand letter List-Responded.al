page 51513482 "Demand letter List-Responded"
{
    // version AES-INS 1.0

    CardPageID = "Demand letter Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim Letters";
    SourceTableView = WHERE("Letter Type" = CONST("Demand Letter"),
                            "Demand Letter Action" = CONST(Respond));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("External Reference No."; "External Reference No.")
                {
                }
                field("Claimant Name"; "Claimant Name")
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
                field("Claimant ID"; "Claimant ID")
                {
                }
                field("Received by"; "Received by")
                {
                }
                field("Received Date"; "Received Date")
                {
                }
                field("Received Time"; "Received Time")
                {
                }
                field("Demand Amount"; "Demand Amount")
                {
                }
                field("Demand Letter Action"; "Demand Letter Action")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Amicable settlement")
            {
                RunObject = Page "Amicable settlement Card";
                RunPageLink = "No." = FIELD("No.");
            }
        }
    }
}

