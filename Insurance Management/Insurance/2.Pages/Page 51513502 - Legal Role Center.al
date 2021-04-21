page 51513502 "Legal Role Center"
{
    // version AES-INS 1.0

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group("Legal Activity")
            {
                part("Legal Activities"; "Legal Activities")
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
            action("Demand Letters")
            {
                Caption = 'Demand Letters';
                Image = Customer;
                RunObject = Page 51513479;
            }
            action("Demand letter List-Responded")
            {
                Caption = 'Demand letter List-Responded';
                RunObject = Page 51513482;
            }
            action("Demand Letters-Ignored")
            {
                Caption = 'Demand Letters-Ignored';
                RunObject = Page 51513483;
            }
            action(Summons)
            {
                Caption = 'Summons';
                RunObject = Page 51513485;
            }
            action("Legal Cases")
            {
                Caption = 'Legal Cases';
                RunObject = Page 51513085;
            }
            action("Legal Diary")
            {
                Caption = 'Legal Diary';
                RunObject = Page 51513492;
            }
            action("Law Firms")
            {
                Caption = 'Law Firms';
                RunObject = Page 51513448;
            }
            action("Legal cases Liable")
            {
                Caption = 'Legal cases Liable';
                RunObject = Page 51513493;
            }
            action("Legal cases Repudiated")
            {
                Caption = 'Legal cases Repudiated';
                RunObject = Page 51513494;
            }
            action("Appealed cases")
            {
                Caption = 'Appealed cases';
                RunObject = Page 51513497;
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

