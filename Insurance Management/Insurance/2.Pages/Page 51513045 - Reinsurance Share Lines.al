page 51513045 "Reinsurance Share Lines"
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Treaty Reinsurance Share";
    UsageCategory=Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Re-insurer code"; "Re-insurer code")
                {
                }
                field("Re-insurer Name"; "Re-insurer Name")
                {
                }
                field("Percentage %"; "Percentage %")
                {
                }
                field(Surplus; Surplus)
                {
                }
                field(Facultative; Facultative)
                {
                }
                field("Quota Share"; "Quota Share")
                {
                }
                field("Excess of loss"; "Excess of loss")
                {
                }
                field("Treaty Code"; "Treaty Code")
                {
                }
                field("Addendum Code"; "Addendum Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Surplus := TRUE;
    end;
}

