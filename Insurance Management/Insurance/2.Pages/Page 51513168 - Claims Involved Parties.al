page 51513168 "Claims Involved Parties"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Claim Involved Parties";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Involvement type"; "Involvement type")
                {
                }
                field(Title; Title)
                {
                }
                field(Surname; Surname)
                {
                    Caption = 'Name';
                }
                field("ID/Passport No."; "ID/Passport No.")
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
                field("Claim Currency Code"; "Claim Currency Code")
                {
                    Visible = false;
                }
                field("Claim Amount"; "Claim Amount")
                {
                    Visible = false;
                }
                field("Case No."; "Case No.")
                {
                }
                field("Loss Type selection";
                    "Loss Type selection")
                {
                }
                field(Description; Description)
                {
                }
                field("Excess Amount Required"; "Excess Amount Required")
                {
                }
                field("Loss Type";
                "Loss Type")
                {
                }
                field("Minimum Reserve Amount"; "Minimum Reserve Amount")
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
                RunObject = Page 51513170;
                RunPageLink = "Claim No."=FIELD("Claim No."),
                              "Claimant ID"=FIELD("Claim Line No.");
            }
            action("Appointed Service Providers ")
            {
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "Service Provider Appointments";
                                RunPageLink = "Claim No."=FIELD("Claim No."),
                             "Claimant ID"=FIELD("Claim Line No.");
            }
            action("Claim Reservations")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 51513174;
                                RunPageLink = "Claim No."=FIELD("Claim No."),
                              "Claimant ID"=FIELD("Claim Line No.");
            }
        }
    }
}

