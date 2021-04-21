page 51513131 "Product Loading & Discounts"
{
    
    Caption = 'Product Loading & Discounts';
    PageType = List;
    SourceTable = "Product Loading and Discounts";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ToolTip = 'Specifies the value of the Calculation Method field';
                    ApplicationArea = All;
                }
                field("Loading Amount"; Rec."Loading Amount")
                {
                    ToolTip = 'Specifies the value of the Loading Amount field';
                    ApplicationArea = All;
                }
                field("Loading Percentage"; Rec."Loading Percentage")
                {
                    ToolTip = 'Specifies the value of the Loading Percentage field';
                    ApplicationArea = All;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ToolTip = 'Specifies the value of the Discount Amount field';
                    ApplicationArea = All;
                }
                field("Discount Percentage"; Rec."Discount Percentage")
                {
                    ToolTip = 'Specifies the value of the Discount Percentage field';
                    ApplicationArea = All;
                }
                field("Option Applicable to"; Rec."Option Applicable to")
                {
                    ToolTip = 'Specifies the value of the Option Applicable to field';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field';
                    ApplicationArea = All;
                }
                field(Tax; Rec.Tax)
                {
                    ToolTip = 'Specifies the value of the Tax field';
                    ApplicationArea = All;
                }
                field("Applicable to"; Rec."Applicable to")
                {
                    ToolTip = 'Specifies the value of the Applicable to field';
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field';
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
