page 51513470 "Cashier Activities"
{
    // version AES-INS 1.0

    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Finance Cue";

    layout
    {
        area(content)
        {
            cuegroup(Receipts)
            {
                Caption = 'Receipts';
               /*  field("Un Posted Receipts"; "Un Posted Receipts")
                {
                    Caption = 'Receipts awaiting posting';
                    DrillDownPageID = "Receipt List";
                }
                field("Expected Intalment Receipts"; "Expected Intalment Receipts")
                {
                    DrillDownPageID = "MDP payment schedule";
                } */

                actions
                {
                    action(Receipt)
                    {
                       /*  Caption = 'Receipt';
                        RunObject = Page 51513126;
                        RunPageMode = Create; */
                    }
                    action("Posted Receipt")
                    {
                       /*  Caption = 'Posted Receipt';
                        RunObject = Page 51513129;
                        RunPageMode = View; */
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;

        SETFILTER("Overdue Date Filter", '<%1', WORKDATE);
    end;
}

