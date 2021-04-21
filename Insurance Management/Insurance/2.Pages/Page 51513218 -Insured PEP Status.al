page 51513218 "Insured PEP Status"
{
    
    Caption = 'Insured PEP Status';
    PageType = ListPart;
    SourceTable = "Insured PEP Status";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Relationship; Rec.Relationship)
                {
                    ToolTip = 'Specifies the value of the Relationship field';
                    ApplicationArea = All;
                }
                field("PEP Status"; Rec."PEP Status")
                {
                    ToolTip = 'Specifies the value of the PEP Status field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
