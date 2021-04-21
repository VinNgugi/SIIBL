page 51513477 "Underwriting Role Centre"
{
    // version AES-INS 1.0

    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(RoleCenter)
            {
                part("Amicable settlement Card"; "Amicable settlement Card")
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Production Report")
            {
                Caption = 'Production Report';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 51513288;
            }
            action("REport Expired Policies")
            {
                Caption = 'Expired Policies';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 51513503;
            }
            action("Renewal Policy")
            {
                Caption = 'Renewal Policy';
                RunObject = Report 51513506;
            }
            action("Renewal Notice Listing")
            {
                RunObject = Report 51513507;
            }
            action("Renewal Listing Per Intermediary")
            {
                RunObject = Report 51513508;
            }
            action("Certificate Printed")
            {
                Caption = 'Certificate Printed';
                RunObject = Report 51513505;
            }
            action("Cetificates Accountability")
            {
                Caption = 'Cetificates Accountability';
                RunObject = Report 51513512;
            }
            action("Certificate Audit")
            {
                Caption = 'Certificate Audit';
                RunObject = Report 51513513;
            }
            action("Cancelled Certificates")
            {
                Caption = 'Cancelled Certificates';
                RunObject = Report 51513515;
            }
        }
        area(creation)
        {
            action(Individual)
            {
                RunObject = Page 51513050;
            }
            action(Corporate)
            {
                RunObject = Page 51513077;
            }
            action("Create Policy")
            {
                Caption = 'Create Policy';
                RunObject = Page 51513080;
            }
            action("Underwriting Discounts")
            {
                Caption = 'Underwriting Discounts';
            }
            action(Policies)
            {
                Caption = 'Policies';
                RunObject = Page 51513058;
            }
            action(Endorsement)
            {
                Caption = 'Endorsement';
                RunObject = Page 51513069;
            }
            action("Policy List Per Risk")
            {
                Caption = 'Policy List Per Risk';
                RunObject = Page 51513190;
            }
            action("Policies Issued")
            {
               /*  Caption = 'Policies Issued';
                RunObject = Page 51404511; */
            }
            action("Certificate Printing")
            {
                Caption = 'Certificate Printing';
                RunObject = Page 51513060;
            }
            action("Certificate Printed 1")
            {
                Caption = 'Certificate Printed';
                RunObject = Page 51513062;
            }
        }
    }
}

