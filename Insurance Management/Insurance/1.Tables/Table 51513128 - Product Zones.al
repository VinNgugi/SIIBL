page 51513128 "Product Zones"
{
    
    Caption = 'Product Zones';
    PageType = List;
    SourceTable = "Product Zones";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Zone ID"; Rec."Zone ID")
                {
                    ApplicationArea = All;
                }
                field("Zone Name"; Rec."Zone Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            action("Countries")
            {
                RunObject = Page "Countries in Zone";
                RunPageLink ="Policy Type"=field("Policy Type"), "Underwriter Code"=FIELD("Underwriter Code"),"Zone ID"=FIELD("Zone ID");
            }
            
        }
    } 
    
}
