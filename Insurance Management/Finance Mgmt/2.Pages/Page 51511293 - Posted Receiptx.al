page 51511293 "Posted Receiptx"
{
    // version CSHBK

    Editable = true;
    PageType = Card;
    SourceTable = 51513110;
    SourceTableView = WHERE(Posted=CONST(true));

    layout
    {
        area(content)
        {
            group(Receipt)
            {
                Caption = 'Receipt';
                field("Receipt No.";"Receipt No.")
                {
                }
                field("No.";"No.")
                {
                    Editable = false;
                }
                field("Posting Date";"Posting Date")
                {
                    Editable = false;
                }
                field("Pay Mode";"Pay Mode")
                {
                    Editable = false;
                }
                field("Cheque No";"Cheque No")
                {
                    Editable = false;
                }
                field("Received From";"Received From")
                {
                    Editable = false;
                }
                field("On Behalf Of";"On Behalf Of")
                {
                    Caption = 'Payment For';
                    Editable = false;
                }
                field("Cheque Date";"Cheque Date")
                {
                    Editable = false;
                }
                field("Currency Code";"Currency Code")
                {
                    Editable = false;
                }
                field("Bank Code";"Bank Code")
                {
                }
                field(Cashier;Cashier)
                {
                    Editable = false;
                }
                field(Posted;Posted)
                {
                }
                field("Posted Date";"Posted Date")
                {
                }
                field("Posted Time";"Posted Time")
                {
                }
                field("Posted By";"Posted By")
                {
                }
                field("Total Amount";"Total Amount")
                {
                }
                field("Amount(LCY)";"Amount(LCY)")
                {
                    Editable = false;
                }
                field("Cancellation Reason";"Cancellation Reason")
                {
                    Editable = NoValue;
                }
            }
            part(receipTliNEs;51511291)
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
                action("Print Receipt")
                {
                    Caption = 'Print Receipt';

                    trigger OnAction()
                    begin

                        IF Posted=FALSE THEN
                         ERROR('Receipt No %1 has not been posted',"No.");
                        BankLedgerEntry.RESET;
                        BankLedgerEntry.SETRANGE(BankLedgerEntry."Document No.","Receipt No.");
                        REPORT.RUN(51511275,TRUE,TRUE,BankLedgerEntry);
                        BankLedgerEntry.RESET;
                    end;
                }
                action("&Navigate")
                {
                    Caption = '&Navigate';
                    Image = Navigate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Navigate.SetDoc("Receipt Date","Receipt No.");
                        Navigate.RUN;
                    end;
                }
                action("Cancel Receipt")
                {

                    trigger OnAction()
                    begin
                        ReceiptPost.CancelReceipt(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF "Cancellation Reason"='' THEN
          NoValue:=TRUE
        ELSE
          NoValue:=FALSE;
    end;

    var
        BankLedgerEntry: Record 271;
        Navigate: Page 344;
        ReceiptPost: Codeunit 51513113;
        NoValue: Boolean;
}

