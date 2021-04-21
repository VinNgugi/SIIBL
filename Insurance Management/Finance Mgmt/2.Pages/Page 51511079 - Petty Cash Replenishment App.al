page 51511079 "Petty Cash Replenishment App"
{
    // version FINANCE

    Caption = 'Petty Cash Replenishment App';
    CardPageID = "Petty Cash Replenishment Heade";
    Editable = false;
    PageType = List;
    SourceTable = "Payments1";
    //SourceTableView = WHERE("Transaction Type"=CONST(InterBank),Status=CONST(Released),Posted=CONST(False));

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field(No; No)
                {
                }
                field(Date; Date)
                {
                }
                field(Payee; Payee)
                {
                }
                field(Status; Status)
                {
                }
                field("Pay Mode"; "Pay Mode")
                {
                }
                field("Paying Bank Account"; "Paying Bank Account")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Cheque No"; "Cheque No")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                }
                field(Posted; Posted)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = true;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Post Batch")
                {
                    Caption = 'Post Batch';

                    trigger OnAction()
                    var
                        PV: Record "Request Header";
                    begin
                        /*
                         IF CONFIRM (Text000,FALSE) THEN BEGIN
                           CurrPage.SETSELECTIONFILTER(PV);
                            IF PV.FIND('-') THEN
                             REPEAT
                              PVPost.PostBatch(PV);
                             UNTIL
                              PV.NEXT=0;
                         END;
                         */

                    end;
                }
            }
        }
    }

    var
        Text000: Label 'Are you sure you want to post the selected PV''s';
}

