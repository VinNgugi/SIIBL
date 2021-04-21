page 51513494 "legal cases Repudiated"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Legal Diary";
    SourceTableView = WHERE("Judgement Decision" = CONST(Dismissed));

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Judgement Decision"; "Judgement Decision")
                {
                }
                field("Judgement Decision Response"; "Judgement Decision Response")
                {
                }
                field("Amount awarded"; "Amount awarded")
                {
                }
                field("Date received"; "Date received")
                {
                }
                field("Reminder date"; "Reminder date")
                {
                }
                field("Payment Period"; "Payment Period")
                {
                }
                field("Payment Expiry date"; "Payment Expiry date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Judgement)
            {
                Caption = 'Judgement';
                RunObject = Page "Judgment Card";
                RunPageLink = "Case No." = FIELD("Case No."),
                              "Legal Stage Code" = FIELD("Legal Stage Code"),
                              Date = FIELD(Date);
            }
        }
    }
}

