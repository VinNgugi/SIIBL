page 51513203 "Claim Vehicles Listing"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Lines";
    SourceTableView = WHERE("Document Type"=CONST(Policy),
                            "Description Type"=CONST("Schedule of Insured"),
                            "Registration No."=FILTER(<>''),
                            "Action Type"=FILTER(New|Renewal));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Registration No.";"Registration No.")
                {
                }
                field("Certificate No.";"Certificate No.")
                {
                }
                field(Make;Make)
                {
                }
                field("Year of Manufacture";"Year of Manufacture")
                {
                }
                field("Type of Body";"Type of Body")
                {
                }
                field("Cubic Capacity (cc)";"Cubic Capacity (cc)")
                {
                }
                field("Seating Capacity";"Seating Capacity")
                {
                }
                field("Chassis No.";"Chassis No.")
                {
                }
                field("Engine No.";"Engine No.")
                {
                }
                field("Document No.";"Document No.")
                {
                    Caption = 'Policy No.';
                }
                field("Insured No.";"Insured No.")
                {
                }
                field("Insured Name";"Insured Name")
                {
                }
                field("Start Date";"Start Date")
                {
                    Caption = 'Cover Start Date';
                }
                field("End Date";"End Date")
                {
                    Caption = 'Cover End Date';
                }
                field(Selected;Selected)
                {
                }
                field(Status;Status)
                {
                }
                field("Action Type";"Action Type")
                {
                    Caption = 'Endorsement Type';
                }
                field("Posted Premium Amount";"Posted Premium Amount")
                {
                }
                field("Posted Receipted Amount";"Posted Receipted Amount")
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
                RunObject = Page 51513058;
                                RunPageLink = "Document Type"=FIELD("Document Type"),
                              "No."=FIELD("Policy No");
            }
            action(Endorsements)
            {
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page 51513208;
                                RunPageLink = "Registration No."=FIELD("Registration No.");
            }
            action("Debit Notes")
            {
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 51513133;
                                RunPageLink = "Policy No"=FIELD("Document No.");
            }
            action("Credit Notes")
            {
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 51513135;
                                RunPageLink = "Policy No"=FIELD("Document No.");
            }
            action(Receipts)
            {
            }
            action(Claims)
            {
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page "Claim Register List";
                                RunPageLink = "Policy No"=FIELD("Document No."),
                              "Registration No."=FIELD("Registration No.");
            }
            action("New Claim")
            {
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page 51513021;
                                RunPageLink = "Policy No"=FIELD("Policy No"),
                              RiskID=FIELD("Line No.");
            }
        }
    }

    var
        ClaimsRec : Record Claim;
}

