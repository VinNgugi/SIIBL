table 51513082 "Insure Comment Line"
{
    // version AES-INS 1.0

    Caption = 'Sales Comment Line';
    DrillDownPageID = 69;
    LookupPageID = 69;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Document Line No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine();
    var
        SalesCommentLine: Record "Insure Comment Line";
    begin
        SalesCommentLine.SETRANGE("Document Type", "Document Type");
        SalesCommentLine.SETRANGE("No.", "No.");
        SalesCommentLine.SETRANGE("Document Line No.", "Document Line No.");
        SalesCommentLine.SETRANGE(Date, WORKDATE);
        IF NOT SalesCommentLine.FINDFIRST THEN
            Date := WORKDATE;
    end;
}

