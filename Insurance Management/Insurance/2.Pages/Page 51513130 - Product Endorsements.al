page 51513130 "Product Endorsements"
{
    
    Caption = 'Product Endorsements';
    PageType = List;
    SourceTable = "Product Endorsements";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Endorsement Type"; Rec."Endorsement Type")
                {
                    ToolTip = 'Specifies the value of the Endorserment Type field';
                    ApplicationArea = All;
                }
                field("Endorsement Description"; Rec."Endorsement Description")
                {
                    ToolTip = 'Specifies the value of the Endorsement Description field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
