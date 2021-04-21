page 51511118 "Pay Modes"
{
    
    Caption = 'Pay Mode';
    PageType = List;
    SourceTable = "Pay Modes";
    
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Electronic; Rec.Electronic)
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
            }
        }
    }
    
}
