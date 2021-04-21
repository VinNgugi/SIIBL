page 51513471 "Ass Accontant Payments Cente"
{
    // version AES-INS 1.0

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Activities)
            {
                part("Assistant Acc. pay activities";"Assistant Acc. pay activities")
                {
                }
            }
            group(Fasttabs)
            {
                part("Report Inbox Part"; "Report Inbox Part")
                {
                }
                part("My Job Queue"; "My Job Queue")
                {
                    Visible = false;
                }
                part("Copy Profile"; "Copy Profile")
                {
                    Visible = false;
                }
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
        area(processing)
        {
            action("Payment List")
            {
                Caption = 'Payment List';
                RunObject = Page 51511001;
                RunPageMode = Create;
            }
            action("Cheque Printing List")
            {
               /*  Caption = 'Cheque Printing List';
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
               /*  Caption = 'RTGS List';
                RunObject = Page 51513217; */
            }
            action("Approved Payments")
            {
                Caption = 'Approved Payments';
                //RunObject = Page 51513224;
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
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action(Receipts)
                {/* 
                    Caption = 'Receipts';
                    RunObject = Page 51513129; */
                }
            }
        }
        area(navigation)
        {
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page 344;
            }
        }
    }
}

