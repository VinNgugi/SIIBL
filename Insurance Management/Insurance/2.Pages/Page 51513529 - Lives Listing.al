page 51513529 "Lives Listing"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Lines";
    SourceTableView = WHERE("Document Type" = CONST(Policy),
                            "Description Type" = CONST("Schedule of Insured"),
                           "Registration No." = FILTER(<> ''),
                            "Action Type" = FILTER(New | Renewal));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                    Caption = 'Policy No.';
                }
                field("Insured No."; "Insured No.")
                {
                }
                field("Insured Name"; "Insured Name")
                {
                }
                field("Registration No."; "Registration No.")
                {
                }
                field("Certificate No."; "Certificate No.")
                {
                }
                field(Status; Status)
                {
                }
                field(Make; Make)
                {
                }
                field("Year of Manufacture"; "Year of Manufacture")
                {
                }
                field("Type of Body"; "Type of Body")
                {
                }
                field("Cubic Capacity (cc)"; "Cubic Capacity (cc)")
                {
                }
                field("Chassis No."; "Chassis No.")
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("Action Type"; "Action Type")
                {
                    Caption = 'Endorsement Type';
                }
                field("Seating Capacity"; "Seating Capacity")
                {
                }
                field("Start Date"; "Start Date")
                {
                    Caption = 'Cover Start Date';
                }
                field("End Date"; "End Date")
                {
                    Caption = 'Cover End Date';
                }
                field("Posted Premium Amount"; "Posted Premium Amount")
                {
                }
                field("Posted Receipted Amount"; "Posted Receipted Amount")
                {
                }
                field(Selected; Selected)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Policy List")
            {
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page "Policy List";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "No." = FIELD("Policy No");
            }
            action(Endorsements)
            {
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page "Endorsement list -Risk";
                RunPageLink = "Registration No." = FIELD("Registration No.");
            }
            action("Debit Notes")
            {
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Debit Note List (Posted)";
                RunPageLink = "Policy No" = FIELD("Document No.");
            }
            action("Credit Notes")
            {
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Credit Note List (Posted)";
                RunPageLink = "Policy No" = FIELD("Document No.");
            }
            action(Receipts)
            {
            }
            action(Claims)
            {
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page "Claim Register List";
                RunPageLink = "Policy No" = FIELD("Document No."), "Registration No." = FIELD("Registration No.");
            }
        }
    }
}

