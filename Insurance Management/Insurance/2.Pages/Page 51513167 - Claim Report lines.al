page 51513167 "Claim Report lines"
{
    // version AES-INS 1.0

    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Claim Report lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Claim Report No."; "Claim Report No.")
                {
                    Visible = false;
                }
                field("Claim No."; "Claim No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Estimated Value"; "Estimated Value")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    var
        ClaimReportLines: Record "Claim Report lines";
    begin
        /*MESSAGE('B4 inserting line no=%1 Claim No %2',"Line No.","Claim No.");
        
        
        ClaimReportLines.RESET;
        ClaimReportLines.SETRANGE(ClaimReportLines."Claim Report No.","Claim Report No.");
        ClaimReportLines.SETRANGE(ClaimReportLines."Claim No.","Claim No.");
        IF ClaimReportLines.FINDLAST THEN
          BEGIN
        "Line No.":=ClaimReportLines."Line No."+1;
        MESSAGE('inserting line no=%1 Claim No %2',"Line No.","Claim No.");
        END;*/

    end;
}

