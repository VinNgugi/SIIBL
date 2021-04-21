page 51404252 "Interaction Cause Card"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New form created for Complaint Sub-Category

    PageType = Card;
    SourceTable = "Interaction Cause";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                }
                field("Interaction No."; "Interaction No.")
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Import Complaint Causes")
                {
                    Caption = 'Import Complaint Causes';
                    Ellipsis = true;
                }
            }
        }
    }
}

