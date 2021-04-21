page 51513233 "Pay Mode"
{
    
    ApplicationArea = All;
    Caption = 'Pay Mode';
    PageType = List;
    SourceTable = "Pay Modes";
    UsageCategory = Administration;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field(Electronic; Rec.Electronic)
                {
                    ApplicationArea = All;
                }
                field("Print Receipt"; Rec."Print Receipt")
                {
                    ApplicationArea = All;
                }
                field("Requires Bank Deatils"; Rec."Requires Bank Deatils")
                {
                    ApplicationArea = All;
                }
                field("Account Affected"; Rec."Account Affected")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
