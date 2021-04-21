page 51513111 "Treaty List Proportional"
{
    // version AES-INS 1.0

    CardPageID = "Proportional Treaty";
    PageType = List;
    UsageCategory=Lists;
    SourceTable = Treaty;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Treaty Code"; "Treaty Code")
                {
                }
                field("Treaty description"; "Treaty description")
                {
                }
                field("Addendum Code"; "Addendum Code")
                {
                }
                field(Broker; Broker)
                {
                }
                field("Broker Name"; "Broker Name")
                {
                }
                field("Broker Commision"; "Broker Commision")
                {
                }
                field("Quota Share"; "Quota Share")
                {
                }
                field(Surplus; Surplus)
                {
                }
                field(Facultative; Facultative)
                {
                }
                field("Exess of loss"; "Exess of loss")
                {
                }
                field("Quota share Retention"; "Quota share Retention")
                {
                }
                field("Surplus Retention"; "Surplus Retention")
                {
                }
                field("Insurer quota percentage"; "Insurer quota percentage")
                {
                }
            }
        }
    }

    actions
    {
    }
}

