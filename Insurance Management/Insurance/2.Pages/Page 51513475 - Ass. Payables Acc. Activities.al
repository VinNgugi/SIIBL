page 51513475 "Ass. Payables Acc. Activities"
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
                /* Caption = 'Receipts';
                field("MDP's Due for Payment"; "MDP's Due for Payment")
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
                    action("Payment List")
                    {
                        Caption = 'Payment List';
                        RunObject = Page 51511001;
                        RunPageMode = Create;
                    }
                    action("Approved Payments")
                    {
                        Caption = 'Approved Payments';
                       // RunObject = Page "Approved Payment";
                    }
                    action("Posted Payments")
                    {
                       /*  Caption = 'Posted Payments';
                        RunObject = Page 51513103; */
                    }
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

