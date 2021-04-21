page 51513096 "Claim reservation lines"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim Reservation lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Reservation DateTime"; "Reservation DateTime")
                {
                }
                field("Reservation date"; "Reservation date")
                {
                }
                field(Type; Type)
                {
                }
                field(Amount; Amount)
                {
                }
                field(Posted; Posted)
                {
                }
            }
        }
    }

    actions
    {
    }
}

