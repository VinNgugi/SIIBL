page 51513110 "Product term"
{
    
    Caption = 'Product term';
    PageType = ListPart;
    SourceTable = "Product Terms";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Term Code"; Rec."Term Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
