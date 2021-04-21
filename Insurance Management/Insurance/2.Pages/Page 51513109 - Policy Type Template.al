page 51513109 "Policy Type Template"
{

    ApplicationArea = All;
    Caption = 'Policy Type Template';
    PageType = List;
    SourceTable = "Policy Type Template";
    UsageCategory = Lists;
    SourceTableView = sorting("Column Order");

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;
                    LookupPageId = 51513105;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                }
                field("Column Order"; Rec."Column Order")
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Table No." := 51513017;
    end;

}
