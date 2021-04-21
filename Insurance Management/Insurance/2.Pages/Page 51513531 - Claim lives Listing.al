page 51513531 "Claim lives Listing"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Lines";
    SourceTableView = WHERE("Document Type" = CONST(Policy),
                            "Description Type" = CONST("Schedule of Insured"),
                            "Family Name" = FILTER(<> ''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("First Name(s)"; "First Name(s)")
                {
                }
                field(Title; Title)
                {
                }
                field(Sex; Sex)
                {
                }
                field("Height Unit"; "Height Unit")
                {
                }
                field(Height; Height)
                {
                }
                field("Weight Unit"; "Weight Unit")
                {
                }
                field(Weight; Weight)
                {
                }
                field("Date of Birth"; "Date of Birth")
                {
                }
                field("Relationship to Applicant"; "Relationship to Applicant")
                {
                }
                field(Occupation; Occupation)
                {
                }
                field(Nationality; Nationality)
                {
                }
                field("Action Type"; "Action Type")
                {
                    Caption = 'Endorsement Type';
                }
                field("Posted Premium Amount"; "Posted Premium Amount")
                {
                }
                field("Posted Receipted Amount"; "Posted Receipted Amount")
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
                RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("Policy No");
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
            action("New Claim")
            {
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page Claim;
                RunPageLink = "Policy No" = FIELD("Policy No"), RiskID = FIELD("Line No.");
            }
        }
    }

    var
        ClaimsRec: Record Claim;
}

