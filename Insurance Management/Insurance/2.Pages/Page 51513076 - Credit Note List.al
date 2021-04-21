page 51513076 "Credit Note List"
{
    // version AES-INS 1.0

    CardPageID = "Credit Note Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST("Credit Note"));

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
                field("Agent/Broker"; "Agent/Broker")
                {
                }
                field("Policy Description"; "Policy Description")
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
                field("Quotation No."; "Quotation No.")
                {
                }
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
                {
                }
                field("Total Premium Amount"; "Total Premium Amount")
                {
                }
                field("Total Tax"; "Total Tax")
                {
                }
                field("Total Net Premium"; "Total Net Premium")
                {
                }
                field("Endorsement Policy No."; "Endorsement Policy No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

