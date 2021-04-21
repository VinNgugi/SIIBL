page 51513124 "Commission Types List"
{

    Caption = 'Commission Types List';
    PageType = List;
    SourceTable = "Commission Types";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
