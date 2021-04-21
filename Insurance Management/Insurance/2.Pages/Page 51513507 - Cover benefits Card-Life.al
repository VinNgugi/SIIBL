page 51513507 "Cover benefits Card-Life"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Life Benefits";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        //"Insurance Type":="Insurance Type"::Life
    end;
}

