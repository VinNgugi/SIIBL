page 51513473 "Assistant Acc. pay activities"
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
               /*  field("MDP's Due for Payment"; "MDP's Due for Payment")
                {
                    DrillDownPageID = "MDP payment schedule";
                }
                field("Requests to Approve"; "Requests to Approve")
                {
                }
                field("Requests Sent for Approval"; "Requests Sent for Approval")
                {
                }
                field("Cheques awaiting collection"; "Cheques awaiting collection")
                {
                } */

                actions
                {
                  /*   action("Cheque Printing List")
                    {
                        Caption = 'Cheque Printing List';
                        RunObject = Page 51513215;
                        RunPageMode = View;
                    }
                    action("EFT List")
                    {
                        Caption = 'EFT List';
                        RunObject = Page 51513216;
                    }
                    action("RTGS List")
                    {
                        Caption = 'RTGS List';
                        RunObject = Page 51513217;
                    }
                    action("Posted Payments")
                    {
                        Caption = 'Posted Payments';
                        RunObject = Page 51513103; 
                    {*/
                    action("Cheques Collection")
                    {
                        RunObject = Page 51513466;
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

