page 51513491 "Judgment Card"
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
                field("Judgement Decision"; "Judgement Decision")
                {
                }
                field("Amount awarded"; "Amount awarded")
                {
                }
                field("Payment Period"; "Payment Period")
                {
                }
                field("Payment Expiry date"; "Payment Expiry date")
                {
                }
                field("Grounds for Repudiation"; "Grounds for Repudiation")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Judgement Decision-Payment")
            {

                trigger OnAction();
                begin
                    "Judgement Decision" := "Judgement Decision"::Liable;
                    MODIFY;
                end;
            }
            action("Judgement Decision-Repudiated")
            {

                trigger OnAction();
                begin
                    "Judgement Decision" := "Judgement Decision"::Dismissed;
                    MODIFY;
                end;
            }
        }
    }
}

