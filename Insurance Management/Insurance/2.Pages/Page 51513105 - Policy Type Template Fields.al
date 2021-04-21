page 51513105 "Policy Type Template Fields"
{

    ApplicationArea = All;
    Caption = 'Policy Type Template Fields';
    PageType = List;
    SourceTable = Field;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
