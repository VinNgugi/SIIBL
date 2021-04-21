page 51513046 "Financial Lines"
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Insure Lines";
    UsageCategory=Lists;
    SourceTableView = WHERE(Amount = FILTER(<> 0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Type"; "Account Type")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field(Name; Name)
                {
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
    }
}

