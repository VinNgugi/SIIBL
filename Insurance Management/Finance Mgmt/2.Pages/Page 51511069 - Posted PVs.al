page 51511069 "Posted PVs"
{
    // version FINANCE

    CardPageID = "Payment Voucher";
    Editable = false;
    PageType = List;
    SourceTable = Payments1;
    SourceTableView = WHERE(Posted = FILTER(true));

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
                /* SNN 03302021 field("Bord PV No"; "Bord PV No")
                {
                }
                field("Claim No."; "Claim No.")
                {
                }*/
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
                        PV: Record Payments1;
                    begin

                        IF CONFIRM(Text000, FALSE) THEN BEGIN
                            CurrPage.SETSELECTIONFILTER(PV);
                            IF PV.FIND('-') THEN
                                REPEAT
                                    PVPost.PostBatch(PV);
                                UNTIL
                                 PV.NEXT = 0;
                        END;
                    end;
                }
            }
        }
    }

    var
        PVPost: Codeunit 51511014
        ;
        Text000: Label 'Are you sure you want to post the selected PV''s';
}

