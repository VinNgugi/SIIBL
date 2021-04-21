page 51513488 "Case schedule Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Legal Diary";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Case No."; "Case No.")
                {
                }
                field("Legal Stage Code"; "Legal Stage Code")
                {
                }
                field("Stage Description"; "Stage Description")
                {
                }
                field(Date; Date)
                {
                }
                field("Start Time"; "Start Time")
                {
                }
                field("End time"; "End time")
                {
                }
                field("Court No."; "Court No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Witnesses)
            {
                RunObject = Page "Legal Witnesses";
                RunPageLink = "Case No." = FIELD("Case No."),
                              "Legal Stage" = FIELD("Legal Stage Code"),
                              "Event date" = FIELD(Date);
            }
        }
    }
}

