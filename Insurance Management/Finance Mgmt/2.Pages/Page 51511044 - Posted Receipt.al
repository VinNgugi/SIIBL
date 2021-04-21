page 51511044 "Posted Receipt"
{
    // version FINANCE

    DeleteAllowed = false;
    Editable = false;
    PageType = Card;
    SourceTable = "Receipts Header";
    SourceTableView = WHERE(Posted = CONST(True));

    layout
    {
        area(content)
        {
            group(Receipt)
            {
                Caption = 'Receipt';
                field("No."; "No.")
                {
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
                field("Received From"; "Received From")
                {
                }
                field("On Behalf Of"; "On Behalf Of")
                {
                    Caption = 'Payment For';
                }
                field("Cheque Date"; "Cheque Date")
                {
                    Editable = false;
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Bank Code"; "Bank Code")
                {
                    Caption = 'Bank Account';
                }
                field(Cashier; Cashier)
                {
                    Editable = false;
                }
                field(Posted; Posted)
                {
                }
                field("Posted Date"; "Posted Date")
                {
                }
                field("Posted Time"; "Posted Time")
                {
                }
                field("Posted By"; "Posted By")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Amount(LCY)"; "Amount(LCY)")
                {
                }
                field("Record From SMS"; "Record From SMS")
                {
                }
            }
            part("Receipts Line";"Receipts Line")
            {
                Editable = false;
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
                            //BankLedgerEntry.RESET;
                        END;
                    end;
                }
            }
        }
    }

    var
        BankLedgerEntry: Record 271;
        receiptrec: Record 51511027;
}

