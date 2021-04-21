page 51511000 "Payment Listing"
{
    CardPageID = 51511001;
    Editable = false;
    PageType = List;
    SourceTable = 51511000;
    ;
    SourceTableView = WHERE(Posted = CONST(false), Status = FILTER(Open | "Pending Approval"));

    layout
    {
        area(content)
        {
            repeater(group)
            {
                field(No; No)
                {
                }
                field(Date; Date)
                {
                }
                field("Date Posted"; "Date Posted")
                {
                }
                field(Type; Type)
                {
                }
                field("Pay Mode"; "Pay Mode")
                {
                }
                field("Cheque No"; "Cheque No")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Cheque Type"; "Cheque Type")
                {
                }
                field("KBA Bank Code"; "KBA Bank Code")
                {
                }
                field(Payee; Payee)
                {
                }
                field(Status; Status)
                {
                }
                field("Paying Bank Account"; "Paying Bank Account")
                {
                }
                field("Net Amount"; "Net Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Generate Commission payments")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report 51513533;
            }
            action("DMS Link")
            {
                Image = Web;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    IF CashSetup.GET THEN BEGIN
                        Link := CashSetup."DMS PV Link" + No;
                        HYPERLINK(Link);
                    END;
                end;
            }
        }
    }

    var
        CashSetup: Record "Cash management setup";
        Link: Text;
}

