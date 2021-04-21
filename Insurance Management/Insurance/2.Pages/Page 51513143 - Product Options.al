page 51513143 "Product Options"
{
    
    ApplicationArea = All;
    Caption = 'Product Options';
    PageType = List;
    SourceTable = "Product Options";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Product Option"; Rec."Product Option")
                {
                    ToolTip = 'Specifies the value of the Product Option field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
