page 51513500 "Claims Role Center"
{
    // version AES-INS 1.0

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group("Claim Activities")
            {
                part("Claims Activities"; "Claims Activities")
                {
                }
            }
            group("")
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
            action("Claims Paid")
            {
                Caption = 'Claims Paid';
                RunObject = Report 51513501;
            }
            action("Claim Ratio")
            {
                Caption = 'Claim Ratio';
                RunObject = Report 51513502;
            }
            action("Outstanding Claims")
            {
                Caption = 'Outstanding Claims';
                RunObject = Report 51513509;
            }
            action("Reinsurance Recoveries")
            {
                Caption = 'Reinsurance Recoveries';
                RunObject = Report 51513510;
            }
            action("Close Claims")
            {
                Caption = 'Close Claims';
                RunObject = Report 51513001;
            }
        }
        area(creation)
        {
            action("Claim Vehicle Listing")
            {
                Caption = 'Claim Vehicle Listing';
                Image = Customer;
                RunObject = Page 51513203;
            }
            action("Claim Register")
            {
                Caption = 'Claim Register';
                RunObject = Page "Claim Register List";
            }
            action("Claim Report List")
            {
                Caption = 'Claim Report List';
            }
            action("Claim Reservation List")
            {
                Caption = 'Claim Reservation List';
                RunObject = Page 51513174;
            }
            action("Service Provider Appointments")
            {
                Caption = 'Service Provider Appointments';
                RunObject = Page "Service Provider Appointments";
            }
            action("Service Provider Invoices")
            {
                Caption = 'Service Provider Invoices';
                RunObject = Page 9308;
            }
            action("Service Provider List")
            {
                Caption = 'Service Provider List';
                RunObject = Page 27;
            }
            action("Payment Requisition")
            {
                Caption = 'Payment Requisition';
                RunObject = Page 51511001;
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action(Receipts)
                {
                   /*  Caption = 'Receipts';
                    RunObject = Page 51513129; */
                }
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
                RunObject = Page Navigate;
            }
        }
    }
}

