page 51513142 "Product Loss Type Stages"
{
    
    ApplicationArea = All;
    Caption = 'Product Loss Type Stages';
    PageType = List;
    SourceTable = "Product Loss Type Stages";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Stage; Rec.Stage)
                {
                    ToolTip = 'Specifies the value of the Stage field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ToolTip = 'Specifies the value of the Priority field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
