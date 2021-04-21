page 51513137 "Posted Credit Note Lines"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Credit Note Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Registration No."; "Registration No.")
                {
                }
                field("Description Type";
                "Description Type")
                {
                }
                field(Description; Description)
                {
                }
                field("Sum Insured"; "Sum Insured")
                {
                }
                field("Gross Premium"; "Gross Premium")
                {
                }
                field(Amount; Amount)
                {
                }
                field(Tax; Tax)
                {
                }
            }
        }
    }

    actions
    {
    }
}

