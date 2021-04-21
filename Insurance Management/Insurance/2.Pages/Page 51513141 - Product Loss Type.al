page 51513141 "Product Loss Type"
{
    
    ApplicationArea = All;
    Caption = 'Product Loss Type';
    PageType = List;
    SourceTable = "Product Loss Type";
    UsageCategory = Lists;
    
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
                //field("Cover Type"; Rec."Cover Type")
               // {
                 //   ToolTip = 'Specifies the value of the Cover Type field';
                   // ApplicationArea = All;
                //}
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field("Excess Required"; Rec."Excess Required")
                {
                    ToolTip = 'Specifies the value of the Excess Required field';
                    ApplicationArea = All;
                }
                field("Minimum Reserve"; Rec."Minimum Reserve")
                {
                    ToolTip = 'Specifies the value of the Minimum Reserve field';
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field';
                    ApplicationArea = All;
                }
                field("Reserve calculation type"; Rec."Reserve calculation type")
                {
                    ToolTip = 'Specifies the value of the Reserve calculation type field';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            action(Stages)
            {
                RunObject = Page "Product Loss Type Stages";
                RunPageLink = "Product Code" = FIELD("Cover Type"),"Underwriter Code"=field("Underwriter Code"),"Loss Type Code"=field("Code");
            }
        }
    }
    
}
