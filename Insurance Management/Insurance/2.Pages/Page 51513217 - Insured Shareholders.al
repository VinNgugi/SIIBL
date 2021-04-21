page 51513217 "Insured Shareholders"
{
    
    Caption = 'Insured Shareholders';
    PageType = ListPart;
    SourceTable = "Insured Shareholders";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("Shareholder % "; Rec."Shareholder % ")
                {
                    ToolTip = 'Specifies the value of the Shareholder %  field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
