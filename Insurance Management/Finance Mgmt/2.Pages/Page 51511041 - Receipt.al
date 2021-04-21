page 51511041 Receipt
{
    // version FINANCE

    PageType = Card;
    SourceTable = "Receipts Header";
    SourceTableView = WHERE(Posted = CONST(False));

    layout
    {
        area(content)
        {
            group(Receipt)
            {
                Caption = 'Receipt';
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(Date; Date)
                {
                }
                field("Pay Mode"; "Pay Mode")
                {
                }
                field("Cheque No"; "Cheque No")
                {
                }
                field("Customer Category"; "Customer Category")
                {
                    Visible = false;
                }
                field("Received From No"; "Received From No")
                {
                }
                field("Received From"; "Received From")
                {
                }
                field("On Behalf Of"; "On Behalf Of")
                {
                    Caption = 'Payment For';
                }
                field("Cheque Date"; "Cheque Date")
                {
                    Editable = true;
                }
                field("Bank Code"; "Bank Code")
                {
                    Caption = 'Bank Account';
                }
                field(Cashier; Cashier)
                {
                    Editable = false;
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Amount(LCY)"; "Amount(LCY)")
                {
                    Editable = false;
                }
                field("Record From SMS"; "Record From SMS")
                {
                }
                field(Status; Status)
                {
                }
            }
            part("Receipts Line";"Receipts Line")
            {
                SubPageLink = "Receipt No."=FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        VALIDATE("Global Dimension 1 Code");
                        VALIDATE("Global Dimension 2 Code");
                        TESTFIELD("On Behalf Of");
                        PostRcpt.PostReceipt(Rec);
                    end;
                }
               
                action("Print Receipt")
                {
                    Caption = 'Print Receipt';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        receiptrec.RESET;
                        receiptrec.SETFILTER("No.", "No.");
                        IF receiptrec.FINDSET THEN BEGIN
                            REPORT.RUN(51511004, TRUE, TRUE, receiptrec);
                        END;
                    end;
                }
            }
        }
    }

    var
        BankLedgerEntry: Record 271;
        receiptrec: Record 51511027;
        PostRcpt: Codeunit 51511002;
}

