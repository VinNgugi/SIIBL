page 51513216 "Product Age Eligibility"
{
    
    ApplicationArea = All;
    Caption = 'Product Age Eligibility';
    PageType = List;
    SourceTable = "Product Age Range";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Relationship Code"; Rec."Relationship Code")
                {
                    ToolTip = 'Specifies the value of the Relationship Code field';
                    ApplicationArea = All;
                }
                field("Min Age"; Rec."Min Age")
                {
                    ToolTip = 'Specifies the value of the Min Age field';
                    ApplicationArea = All;
                }
                field("Max Age"; Rec."Max Age")
                {
                    ToolTip = 'Specifies the value of the Max Age field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
