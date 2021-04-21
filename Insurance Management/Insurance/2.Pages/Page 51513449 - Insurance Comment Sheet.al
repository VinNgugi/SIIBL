page 51513449 "Insurance Comment Sheet"
{
    // version AES-INS 1.0

    AutoSplitKey = true;
    Caption = 'Insurance Comment Sheet';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insurance Comment Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Date; Date)
                {
                }
                field(Comment; Comment)
                {
                }
                field(Code; Code)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SetUpNewLine;
    end;
}

