page 51513028 "Co-insurance"
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Coinsurance Reinsurance Lines";
    UsageCategory=Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Partner No."; "Partner No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Sum Insured"; "Sum Insured")
                {
                }
                field(Premium; Premium)
                {
                }
                field("Cedant Commission"; "Cedant Commission")
                {
                }
                field("Broker Commission"; "Broker Commission")
                {
                }
                field("Account Type";"Account Type")
                {
                    
                }
                field ("Transaction type";"Transaction Type")
                {
                    
                }
            }
        }
    }

    actions
    {
    }
}

