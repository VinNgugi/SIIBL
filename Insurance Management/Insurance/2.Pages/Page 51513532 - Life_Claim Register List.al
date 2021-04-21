page 51513532 "Life_Claim Register List"
{
    // version AES-INS 1.0

    CardPageID = Claim;
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Claim No"; "Claim No")
                {
                }
                field("Policy No"; "Policy No")
                {
                }
                field("Name of Insured"; "Name of Insured")
                {
                }
                field("Renewal Date"; "Renewal Date")
                {
                }
                field("Agent/Broker"; "Agent/Broker")
                {
                }
                field("Insured Telephone No."; "Insured Telephone No.")
                {
                }
                field(Make; Make)
                {
                }
                field("Registration No."; "Registration No.")
                {
                }
                field("Driver's Name"; "Driver's Name")
                {
                }
                field("Creation DateTime"; "Creation DateTime")
                {
                }
                field("Created By"; "Created By")
                {
                }
                field("Claim Closure Date"; "Claim Closure Date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Insurance Comment Sheet";
                RunPageLink = "Table Name" = CONST(Claim), "No." = FIELD("Claim No");
            }
            action("Involved Parties")
            {
                RunObject = Page "Claim involved parties List";
                RunPageLink = "Claim No." = FIELD("Claim No");
            }
            action("Dispatch Service/Towing")
            {
            }
            action("Online Map")
            {
                Caption = 'Online Map';
                Image = Map;

                trigger OnAction();
                begin
                    DisplayMap;
                end;
            }
            action("View Policy")
            {
                RunObject = Page 51513115;
                RunPageLink = "No." = FIELD("Policy No"), "Document Type" = CONST(Policy);
            }
            action("Service Provider Reports")
            {
                RunObject = Page 51513171;
                RunPageLink = "Claim No." = FIELD("Claim No");
            }
            action("Assigned Service Providers")
            {
                RunObject = Page "Service Provider Appointments";
                RunPageLink = "Claim No." = FIELD("Claim No");
            }
            action("Documents Required")
            {
                RunObject = Page "Claim Documents";
                RunPageLink = "Document Type" = CONST(claim), "Document No" = FIELD("Claim No");
            }
            action("Claim Memorandum")
            {

                trigger OnAction();
                begin
                    //ClaimMemo.GetClaimID("Claim No");
                    //ClaimMemo.RUN;
                end;
            }
            action("Claim Reservation")
            {
                RunObject = Page "Claim Reservation List";
                RunPageLink = "Claim No." = FIELD("Claim No");
            }
            action("DMS Link")
            {
                Caption = 'DMS Link';
                Image = Web;

                trigger OnAction();
                begin
                    CashMgtSetup.GET;
                    //Link := CashMgtSetup."DMS Claims Link" + "Claim No";
                    HYPERLINK(Link);
                end;
            }
            group(Letters)
            {
                Caption = 'Letters';
                action("Refferal letter")
                {
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    begin
                        ClaimRec.RESET;
                        ClaimRec.SETRANGE(ClaimRec."Claim No", "Claim No");
                        REPORT.RUN(51513557, TRUE, TRUE, ClaimRec);
                    end;
                }
                action("Authority Letter")
                {
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    begin
                        ClaimRec.RESET;
                        ClaimRec.SETRANGE(ClaimRec."Claim No", "Claim No");
                        REPORT.RUN(51513558, TRUE, TRUE, ClaimRec);
                    end;
                }
                action("Release Letter")
                {
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    begin
                        ClaimRec.RESET;
                        ClaimRec.SETRANGE(ClaimRec."Claim No", "Claim No");
                        REPORT.RUN(51513559, TRUE, TRUE, ClaimRec);
                    end;
                }
                action("Investigation Instructions")
                {
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    begin
                        ClaimRec.RESET;
                        ClaimRec.SETRANGE(ClaimRec."Claim No", "Claim No");
                        REPORT.RUN(51513565, TRUE, TRUE, ClaimRec);
                    end;
                }
            }
        }
    }

    var
        //ClaimMemo: Report "Loading and Discounts Setup";
        ClaimRec: Record Claim;
        CashMgtSetup: Record "Cash Management Setup";
        Link: Text;
}

