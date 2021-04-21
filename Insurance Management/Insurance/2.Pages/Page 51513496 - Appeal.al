page 51513496 Appeal
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
                field(Date; Date)
                {
                }
                field("Case No."; "Case No.")
                {
                }
                field("Case Title"; "Case Title")
                {
                }
                field("Legal Stage Code"; "Legal Stage Code")
                {
                }
                field("Stage Description"; "Stage Description")
                {
                }
                field("Grounds for Appeal/Review"; "Grounds for Appeal/Review")
                {
                }
                field("Agreed Legal Fees"; "Agreed Legal Fees")
                {
                }
                field("Amount awarded"; "Amount awarded")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Court Deposit")
            {

                trigger OnAction();
                begin
                    Insmgt.TransferLegalDecision2Payment(Rec);
                end;
            }
        }
    }

    var
        Insmgt: Codeunit "Insurance management";
}

