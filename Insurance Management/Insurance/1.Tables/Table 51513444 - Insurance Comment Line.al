table 51513444 "Insurance Comment Line"
{
    // version AES-INS 1.0

    Caption = 'Rlshp. Mgt. Comment Line';
    DrillDownPageID = 5118;
    LookupPageID = 5118;

    fields
    {
        field(1; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'Quote,Accepted Quote,Policy,Debit Note,Credit Note,Claim,Claim Report,Claim Reservation,Service Appointments';
            OptionMembers = Quote,"Accepted Quote",Policy,"Debit Note","Credit Note",Claim,"Claim Report","Claim Reservation","Service Appointments";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Table Name" = CONST(Claim)) Claim
            ELSE
            IF ("Table Name" = CONST("Claim Report")) "Claim Report Header"
            ELSE
            IF ("Table Name" = CONST(Quote)) "Insure Header"
            ELSE
            IF ("Table Name" = CONST("Claim Reservation")) "Claim Reservation Header";
        }
        field(3; "Sub No."; Integer)
        {
            Caption = 'Sub No.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Date; Date)
        {
            Caption = 'Date';
        }
        field(6; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(7; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(8; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Table Name", "No.", "Sub No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
    end;

    procedure SetUpNewLine();
    var
        RMCommentLine: Record "Rlshp. Mgt. Comment Line";
    begin
        RMCommentLine.SETRANGE("Table Name", "Table Name");
        RMCommentLine.SETRANGE("No.", "No.");
        RMCommentLine.SETRANGE("Sub No.", "Sub No.");
        RMCommentLine.SETRANGE(Date, WORKDATE);
        IF NOT RMCommentLine.FINDFIRST THEN
            Date := WORKDATE;
    end;
}

