page 51513219 "Insured Classification"
{
    
    Caption = 'Insured Classification';
    PageType = ListPart;
    SourceTable = "Insured Class";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Class; Rec.Class)
                {
                    ToolTip = 'Specifies the value of the Class field';
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
