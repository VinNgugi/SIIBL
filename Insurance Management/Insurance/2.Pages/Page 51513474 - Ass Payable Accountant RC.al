page 51513474 "Ass Payable Accountant RC"
{
    // version AES-INS 1.0

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(" ")
            {
                part("Ass. Payables Acc. Activities"; "Ass. Payables Acc. Activities")
                {
                }
            }
            group("2")
            {
                part("Report Inbox Part"; "Report Inbox Part")
                {
                }
                part("My Job Queue"; "My Job Queue")
                {
                    Visible = false;
                }
                /* part("Connect Online"; "Connect Online")
                {
                    Visible = false;
                } */
                systempart(MyNotes; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Payments on Hold")
            {
                Caption = 'Payments on Hold';
                RunObject = Report "Payments on Hold";
            }
        }
        area(creation)
        {
            action("Payment List")
            {
                Caption = 'Payment List';
                RunObject = Page 51511001;
                RunPageMode = Create;
            }
            action("Cheque Printing List")
            {
                /* Caption = 'Cheque Printing List';
                RunObject = Page 51513215;
                RunPageMode = View; */
            }
            action("EFT List")
            {
                /* Caption = 'EFT List';
                RunObject = Page 51513216; */
            }
            action("RTGS List")
            {
                /* Caption = 'RTGS List';
                RunObject = Page 51513217; */
            }
            action("Approved Payments")
            {
                Caption = 'Approved Payments';
                //RunObject = Page 51513224;
            }
            action("Posted Payments")
            {
                /* Caption = 'Posted Payments';
                RunObject = Page 51513103; */
            }
            action("Cheques Collection")
            {
                RunObject = Page 51513466;
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
            }
        }

        area(processing)
        {
            action(Receipts)
            {
                /* Caption = 'Receipts';
                RunObject = Page 51513129; */
            }
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

