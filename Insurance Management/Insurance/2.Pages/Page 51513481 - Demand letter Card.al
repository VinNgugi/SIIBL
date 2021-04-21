page 51513481 "Demand letter Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Claim Letters";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("External Reference No."; "External Reference No.")
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
                field("Claimant ID"; "Claimant ID")
                {
                }
                field("Claimant Name"; "Claimant Name")
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Respond ")
            {
                Image = Answers;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    IF CONFIRM('You have chosen to respond to this demand letter proceed?') THEN BEGIN
                        "Demand Letter Action" := "Demand Letter Action"::Respond;
                        MODIFY;
                    END;
                end;
            }
            action(Ignore)
            {
                Image = Answers;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    IF CONFIRM('You have chosen to Ignore this demand letter proceed?') THEN BEGIN
                        "Demand Letter Action" := "Demand Letter Action"::Ignore;
                        MODIFY;
                    END;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Letter Type" := "Letter Type"::"Demand Letter";
    end;
}

