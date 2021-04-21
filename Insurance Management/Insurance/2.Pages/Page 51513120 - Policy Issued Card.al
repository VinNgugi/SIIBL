page 51513120 "Policy Issued Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Policies Issued";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Registration No."; "Registration No.")
                {
                }
                field("Policy No."; "Policy No.")
                {
                    Editable = false;
                }
                field("Name of Person picking"; "Name of Person picking")
                {
                }
                field("Issued Date"; "Issued Date")
                {
                    Editable = false;
                }
                field("Issued Time"; "Issued Time")
                {
                    Editable = false;
                }
                field("Issued by"; "Issued by")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

