page 51513517 "Life-New Individual Quote List"
{
    // version AES-INS 1.0

    CardPageID = "Insurance Quote Contact";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST(Quote), "Quote Type" = CONST(New));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Insured No."; "Insured No.")
                {
                }
                field("Insured Name"; "Insured Name")
                {
                }
                field("Policy Type"; "Policy Type")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field("Agent/Broker"; "Agent/Broker")
                {
                }
                field("Brokers Name"; "Brokers Name")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field("Source of Business"; "Source of Business")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
    }
}

