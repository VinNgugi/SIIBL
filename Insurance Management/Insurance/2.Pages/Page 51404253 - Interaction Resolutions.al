page 51404253 "Interaction Resolutions"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New form created for Resolution

    PageType = Card;
    SourceTable = "Interaction Resolution";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                }
                field("Interaction No.";"Interaction No.")
                {
                }
                field(Descriptionx;Descriptionx)
                {
                }
                field("Cause No.";"Cause No.")
                {
                }
                field(Cause;Cause)
                {
                }
            }
            part("Resolution steps";"Resolution Steps List")
            {
                SubPageLink = IRCode=FIELD("No.");
                SubPageView = SORTING(IRCode,"Step Number")
                              ORDER(Ascending);
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
                action("Import Resolution")
                {
                    Caption = 'Import Resolution';
                    Ellipsis = true;
                }
                action("Import Steps")
                {
                    Caption = 'Import Steps';
                }
            }
        }
    }
}

