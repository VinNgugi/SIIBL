page 51513469 "Cashier Role Center"
{
    // version AES-INS 1.0

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Cashier)
            {
                part("Cashier Activities"; "Cashier Activities")
                {
                }
            }
            group(Activities)
            {
                part("Report Inbox Part";"Report Inbox Part")
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
           /*  action("Receipt List")
            {
                Caption = 'Receipt List';
                RunObject = Report 51511275;
            } */
        }
        area(creation)
        {
           /*  action(Receipts1)
            {
                Caption = 'Receipts';
                Image = Customer;
                RunObject = Page 51513126;
            }/*  */
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                /* action(Receipts)
                {
                    Caption = 'Receipts';
                    RunObject = Page 51513129;
                } */
            }
        }
        area(processing)
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

