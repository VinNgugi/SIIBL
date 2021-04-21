page 51513315 "Life Death Causes"
{

    ApplicationArea = All;
    Caption = 'Life Death Causes';
    PageType = List;
    SourceTable = "Death Causes";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Death Code"; Rec."Death Code")
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
