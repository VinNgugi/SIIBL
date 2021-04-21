page 51513063 "Claim Linesx"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Claimant ID"; "Claimant ID")
                {
                }
                field("Claimant Name"; "Claimant Name")
                {
                }
                field("Claimant Attorney ID"; "Claimant Attorney ID")
                {
                }
                field("Claimant Attorney"; "Claimant Attorney")
                {
                }
                field("Our Attorney"; "Our Attorney")
                {
                }
                field("Our Attorney Name"; "Our Attorney Name")
                {
                }
                field("Law Court No."; "Law Court No.")
                {
                }
                field("Law Court Name"; "Law Court Name")
                {
                }
                field("Medical Expenses"; "Medical Expenses")
                {
                }
                field(TDD; TDD)
                {
                }
                field(PTD; PTD)
                {
                }
                field(Property; Property)
                {
                }
                field("Reserve Amounts"; "Reserve Amounts")
                {
                }
                field("Amount Paid"; "Amount Paid")
                {
                }
                field(Currency; Currency)
                {
                }
                field("Claim Amount"; "Claim Amount")
                {
                }
                field("Shortcut  Dimension 1 Code"; "Shortcut  Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Claim Reservation lines")
            {
                RunObject = Page "Claim reservation lines";
                RunPageLink = "Claim No"=FIELD("Claim No"),
                              "Line No."=FIELD("Line No");
            }
        }
    }
}

