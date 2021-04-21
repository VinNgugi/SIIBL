page 51513068 "SACCO List"
{
    // version AES-INS 1.0

    CardPageID = "SACCO Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = Customer;
    SourceTableView = WHERE("Customer Type" = CONST(SACCO));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field(Mobile; Mobile)
                {
                }
                field(PIN; PIN)
                {
                }
                field("ID/Passport No."; "ID/Passport No.")
                {
                }
                field("No. Of Vehicles"; "No. Of Vehicles")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Routes)
            {
                RunObject = Page 51513066;
                RunPageLink = "SACCO ID" = FIELD("No.");
            }
        }
    }
}

