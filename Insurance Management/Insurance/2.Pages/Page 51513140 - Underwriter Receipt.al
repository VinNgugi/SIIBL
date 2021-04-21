page 51513140 "Underwriter Receipt"
{

    Caption = 'Underwriter Receipt';
    PageType = Card;
    SourceTable = "Underwriter Receipt";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Date Receipted"; "Date Receipted")
                {
                    ApplicationArea = All;
                }
                field("Insurer Receipt No."; "Insurer Receipt No.")
                {
                    ApplicationArea = All;
                }
                field("Insured No."; "Insured No.")
                {
                    ApplicationArea = All;
                }
                field("Insured Name"; "Insured Name")
                {
                    ApplicationArea = All;
                }
                field("Debit Note No."; "Debit Note No.")
                {
                    ApplicationArea = All;
                }
                field("Instalment No."; "Instalment No.")
                {
                    ApplicationArea = All;
                }
                field("Instalment Due Date"; "Instalment Due Date")
                {
                    ApplicationArea = All;
                }
                field("Amount Due"; "Amount Due")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }






            }
        }



    }
    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PostRcpt.PostUnderwriterRec(Rec);
                    end;
                }


            }
        }
    }
    var
        PostRcpt: Codeunit "Receipt-Post";
}


