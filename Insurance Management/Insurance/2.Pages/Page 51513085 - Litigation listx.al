page 51513085 "Litigation listx"
{
    // version AES-INS 1.0

    CardPageID = "Litigation cardx";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = Litigations;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Case No."; "Case No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Law Firm"; "Law Firm")
                {
                }
                field("Law Firm Name"; "Law Firm Name")
                {
                }
                field(Schedules; Schedules)
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Create litigation schedule")
            {
                RunObject = Page "Litigation schedule listx";
                RunPageLink = "Litigation Code" = FIELD("Case No.");
            }
        }
    }
}

