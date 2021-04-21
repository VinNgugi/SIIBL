page 51513476 "Sales & Marketing Role Center"
{
    // version AES-INS 1.0

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group("Sales Activities")
            {
                part("My Customers"; "My Customers")
                {
                }
            }
            group(" ")
            {
                part("Sales Performance"; "Sales Performance")
                {
                }
                part("My Job Queue"; "My Job Queue")
                {
                    Visible = false;
                }
                part("My Vendors"; "My Vendors")
                {
                    Visible = false;
                }
                part("Report Inbox Part"; "Report Inbox Part")
                {
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
            action("Customer - &Order Summary")
            {
                Caption = 'Customer - &Order Summary';
                Image = "Report";
                RunObject = Report 107;
            }
            action("Customer - &Top 10 List")
            {
                Caption = 'Customer - &Top 10 List';
                Image = "Report";
                RunObject = Report 111;
            }

            action("S&ales Statistics")
            {
                Caption = 'S&ales Statistics';
                Image = "Report";
                RunObject = Report 112;
            }
            action("Salesperson - Sales &Statistics")
            {
                Caption = 'Salesperson - Sales &Statistics';
                Image = "Report";
                RunObject = Report 114;
            }
            action("Salesperson - &Commission")
            {
                Caption = 'Salesperson - &Commission';
                Image = "Report";
                RunObject = Report 115;
            }

            action("Campaign - &Details")
            {
                Caption = 'Campaign - &Details';
                Image = "Report";
                RunObject = Report 5060;
            }
        }
        area(embedding)
        {
            action("Sales Analysis Reports")
            {
                Caption = 'Sales Analysis Reports';
                RunObject = Page 9376;
            }
            action("Sales Analysis by Dimensions")
            {
                Caption = 'Sales Analysis by Dimensions';
                RunObject = Page 9371;
            }
            action("Sales Budgets")
            {
                Caption = 'Sales Budgets';
                RunObject = Page 9374;
            }
            action(Quotations)
            {
                Caption = 'Quotations';
                Image = Quote;
                RunObject = Page 51513023;
            }
            action(Contacts)
            {
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = Page 5052;
            }
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page 22;
            }
            action(Campaigns)
            {
                Caption = 'Campaigns';
                Image = Campaign;
                RunObject = Page 5087;
            }
            action(Segments)
            {
                Caption = 'Segments';
                Image = Segment;
                RunObject = Page 5093;
            }
            action("To-dos")
            {
                Caption = 'To-dos';
                Image = TaskList;
                RunObject = Page 5096;
            }
            action(Teams)
            {
                Caption = 'Teams';
                Image = TeamSales;
                RunObject = Page 5105;
            }
        }
        area(sections)
        {
            group("Administration Sales/Purchase")
            {
                Caption = 'Administration Sales/Purchase';
                Image = AdministrationSalesPurchases;
                action("Salespeople/Purchasers")
                {
                    Caption = 'Salespeople/Purchasers';
                    RunObject = Page 14;
                }
                action("Insured List ")
                {
                    RunObject = Page 51513113;
                }
                action("Vehicle List")
                {
                    RunObject = Page 51513190;
                }
            }
        }
        area(creation)
        {
            //Caption = 'Intermediaries';
            action("Agent List")
            {
                RunObject = Page 51513047;
            }
            action("Broker List")
            {
                RunObject = Page 51513051;
            }
            action("Direct Intermediary List")
            {
                RunObject = Page 51513201;
            }
            action("Bank Assurance List")
            {
                RunObject = Page 51513200;
            }
        }
        area(processing)
        {
            /* action("Birthday Notification")
            {
                RunObject = Report 51403014;
            }
            action("Renewal Notification")
            {
                RunObject = Report 51403015;
            }
            action("Missing Documentation Notification")
            {
                Caption = 'Missing Documentation';
                RunObject = Report 51403016;
            }
            action("Holiday Notification")
            {
                RunObject = Report 51403017;
            }
 */            action(sms)
            {
                RunObject = Page 51513209;
            }
            action("Notfication Templates")
            {
                //RunObject = Page "Notification Templates";
            }
            action("SMS Setup")
            {
                //RunObject = Page 51404022;
            }
        }
    }
}

