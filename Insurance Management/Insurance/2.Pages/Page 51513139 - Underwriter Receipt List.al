page 51513139 "Underwriter Receipts List"
{

    ApplicationArea = All;
    Caption = 'Underwriter Receipts List';
    PageType = List;
    SourceTable = 51513105;
    UsageCategory = Lists;
    CardPageId="Underwriter Receipt";
    editable=false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Date Receipted"; Rec."Date Receipted")
                {
                    ApplicationArea = All;
                }
                field("Insurer Receipt No."; Rec."Insurer Receipt No.")
                {
                    ApplicationArea = All;
                }
                field("Insured No."; Rec."Insured No.")
                {
                    ApplicationArea = All;
                }
                field("Insured Name"; Rec."Insured Name")
                {
                    ApplicationArea = All;
                }
                field("Debit Note No."; Rec."Debit Note No.")
                {
                    ApplicationArea = All;
                }
                field("Instalment No."; Rec."Instalment No.")
                {
                    ApplicationArea = All;
                }
                field("Instalment Due Date"; Rec."Instalment Due Date")
                {
                    ApplicationArea = All;
                }
                field("Amount Due"; Rec."Amount Due")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Acknowledged; Rec.Acknowledged)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
