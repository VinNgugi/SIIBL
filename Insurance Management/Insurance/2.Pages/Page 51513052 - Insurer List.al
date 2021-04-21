page 51513052 "Insurer List"
{
    // version AES-INS 1.0

    CardPageID = "Insurer Card";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Customer;
    SourceTableView = WHERE("Customer Type" = CONST(Insurer));

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
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Visible = false;
                }
                field("Reminder Terms Code"; "Reminder Terms Code")
                {
                    Visible = false;
                }
                field("Fin. Charge Terms Code"; "Fin. Charge Terms Code")
                {
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field("Language Code"; "Language Code")
                {
                    Visible = false;
                }
                field("Search Name"; "Search Name")
                {
                }
                field("Credit Limit (LCY)"; "Credit Limit (LCY)")
                {
                    Visible = false;
                }
                field(Blocked; Blocked)
                {
                    Visible = false;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    Visible = false;
                }
                field("Application Method"; "Application Method")
                {
                    Visible = false;
                }
            }
        }
    }
    actions
    {

    }

}

