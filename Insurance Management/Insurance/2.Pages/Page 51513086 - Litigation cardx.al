page 51513086 "Litigation cardx"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = Litigations;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Case No."; "Case No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Law Firm"; "Law Firm")
                {
                }
                field("Law Firm Name"; "Law Firm Name")
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
                field("Claimant ID"; "Claimant ID")
                {
                }
                field("Claimant Name"; "Claimant Name")
                {
                }
                field("Law Court"; "Law Court")
                {
                }
                field("Third Party Lawyer"; "Third Party Lawyer")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
            }
            part("Case Schedule"; "Case Schedule")
            {
                SubPageLink = "Case No." = FIELD("Case No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Create Schedule")
            {
                RunObject = Page "Case schedule Card";
                RunPageLink = "Case No." = FIELD("Case No.");
            }
        }
    }
}

