page 51513129 "Countries In Zone"
{
    
    Caption = 'Countries In Zone';
    PageType = List;
    SourceTable = "Countries in Zone";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Country Code"; "Country Code")
                {
                    ApplicationArea = All;
                }
                field("Country Name"; Rec."Country Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

   
}
