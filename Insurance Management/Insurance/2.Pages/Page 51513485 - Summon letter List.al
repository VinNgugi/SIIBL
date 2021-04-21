page 51513485 "Summon letter List"
{
    // version AES-INS 1.0

    CardPageID = "Summon card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim Letters";
    SourceTableView = WHERE("Letter Type" = CONST(Summons));

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
                field("Case No."; "Case No.")
                {
                }
                field("Demand Letter No."; "Demand Letter No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

