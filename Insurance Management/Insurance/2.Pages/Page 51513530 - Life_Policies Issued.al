page 51513530 "Life_Policies Issued"
{
    // version AES-INS 1.0

    CardPageID = "Policy Issued Card";
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Policies Issued";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Policy No."; "Policy No.")
                {
                }
                field("Issued Date"; "Issued Date")
                {
                }
                field("Issued Time"; "Issued Time")
                {
                }
                field("Issued by"; "Issued by")
                {
                }
                field("Name of Person picking"; "Name of Person picking")
                {
                }
                field("Registration No."; "Registration No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

