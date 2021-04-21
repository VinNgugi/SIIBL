page 51513235 "Client Classificaton"
{
    
    Caption = 'Client Classificaton';
    PageType = List;
    SourceTable = "Insured Classification";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field("Insured Type"; Rec."Insured Type")
                {
                    ToolTip = 'Specifies the value of the Code field';
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
