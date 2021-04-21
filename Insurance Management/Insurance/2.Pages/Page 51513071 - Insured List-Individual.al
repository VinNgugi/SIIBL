page 51513071 "Insured List-Individual"
{
    // version AES-INS 1.0

    CardPageID = "Insured Card-Individual";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = Customer;
    SourceTableView = WHERE("Customer Type" = CONST(Insured),
                            "Insured Type" = CONST(Individual));

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
            }
        }
    }

    actions
    {
    }
}

