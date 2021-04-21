table 51513083 "Insure Comment Line Archive"
{
    // version AES-INS 1.0

    Caption = 'Sales Comment Line Archive';
    DrillDownPageID = 68;
    LookupPageID = 68;

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
        field(8; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(9; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Doc. No. Occurrence", "Version No.", "Document Line No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine();
    var
        SalesCommentLine: Record "Sales Comment Line Archive";
    begin
        SalesCommentLine.SETRANGE("Document Type", "Document Type");
        SalesCommentLine.SETRANGE("No.", "No.");
        SalesCommentLine.SETRANGE("Doc. No. Occurrence", "Doc. No. Occurrence");
        SalesCommentLine.SETRANGE("Version No.", "Version No.");
        SalesCommentLine.SETRANGE("Document Line No.", "Line No.");
        SalesCommentLine.SETRANGE(Date, WORKDATE);
        IF NOT SalesCommentLine.FINDFIRST THEN
            Date := WORKDATE;
    end;
}

