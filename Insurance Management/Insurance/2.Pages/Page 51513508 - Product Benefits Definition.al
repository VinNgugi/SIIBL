page 51513508 "Product Benefits Definition"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Product Benefits & Riders";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Benefit Code"; "Benefit Code")
                {
                }
                field("Benefit Name"; "Benefit Name")
                {
                }
                field("Product Option";"Product Option Code")
                {

                }
                field("Benefit Type"; "Benefit Type")
                {
                }
                field("Premium Calculation Method"; "Premium Calculation Method")
                {
                }
                field("Premium % Rate"; "Premium % Rate")
                {
                }
                field("Premium Rate"; "Premium Rate")
                {
                }
                field("Unit Amount"; "Unit Amount")
                {
                }
                field("Payout Type"; "Payout Type")
                {
                }
                field("Payout Calculation"; "Payout Calculation")
                {
                }
                field("Payout %"; "Payout %")
                {
                }
                field("Amount Per Person"; "Amount Per Person")
                {
                }
                field(Multiple; Multiple)
                {
                }
                field("Payout Interval"; "Payout Interval")
                {
                }
                field("Payout Start Period"; "Payout Start Period")
                {
                }
                field("Number of Payouts"; "Number of Payouts")
                {
                }
                field("Payout Instalment Table"; "Payout Instalment Table")
                {
                }
                field("Impact on Premium"; "Impact on Premium")
                {
                }
                field("Subject to Waiting Period"; "Subject to Waiting Period")
                {
                }
                field("Benefits Waiting Period"; "Benefits Waiting Period")
                {
                }
                field("Waiting Period table"; "Waiting Period table")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Related Riders")
            {
                RunObject = Page "Product Benefits Definition 2";
                RunPageLink = "Product Code" = FIELD("Product Code"), "Benefit Code" = FIELD("Benefit Code");
            }
        }
    }
}

