page 51513169 "Claim involved parties List"
{
    // version AES-INS 1.0

    CardPageID = "Claims Involved Parties";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim Involved Parties";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Title; Title)
                {
                }
                field(Surname; Surname)
                {
                }
                field("Other Name(s)"; "Other Name(s)")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Address; Address)
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field("Town/City"; "Town/City")
                {
                }
                field("Third Party Vehicle Reg. No."; "Third Party Vehicle Reg. No.")
                {
                }
                field("Third Party Insurance Company"; "Third Party Insurance Company")
                {
                }
                field("Third Party Policy No."; "Third Party Policy No.")
                {
                }
                field("Details of damage"; "Details of damage")
                {
                }
                field(Passenger; Passenger)
                {
                }
                field("Location during incident"; "Location during incident")
                {
                }
                field("Involvement type"; "Involvement type")
                {
                }
                field("Loss Type";
                "Loss Type")
                {
                }
                field("Excess Amount Required"; "Excess Amount Required")
                {
                }
                field("Minimum Reserve Amount"; "Minimum Reserve Amount")
                {
                }
                field("Posted Reserve Amount"; "Posted Reserve Amount")
                {
                    Caption = 'Total Reserves';
                }
                field("Amount Paid"; "Amount Paid")
                {
                    Caption = 'Total Paid';
                }
                field("Exess Paid"; "Exess Paid")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Appoint Service Provider")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Appoint Service Provider card";
                RunPageLink = "Claim No." = FIELD("Claim No."),
                              "Claimant ID" = FIELD("Claim Line No.");
            }
            action("Appointed Service Providers ")
            {
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "Service Provider Appointments";
                RunPageLink = "Claim No." = FIELD("Claim No."),
                              "Claimant ID" = FIELD("Claim Line No.");
            }
            action("Claim Reservations")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Claim Reservation List";
                RunPageLink = "Claim No." = FIELD("Claim No."),
                              "Claimant ID" = FIELD("Claim Line No.");
            }
        }
    }

    var
        ServiceProviderPage: Page "Claim Involved parties List";
}

