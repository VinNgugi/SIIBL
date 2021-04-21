page 51513081 "Accepte Quote List Group"
{
    // version AES-INS 1.0

    CardPageID = "Accepted Quote card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST("Accepted Quote"),
                            "Quote Type" = CONST(Modification),
                            "Cover Type" = CONST(Group));

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
                field("Policy No"; "Policy No")
                {
                }
            }
        }
    }

    actions
    {
    }
}

