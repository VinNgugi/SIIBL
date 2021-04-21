page 51513056 "Debit Note List"
{
    // version AES-INS 1.0

    CardPageID = "Debit Note Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST("Debit Note"));

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
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Date"; "Document Date")
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
                field("Copied from No."; "Copied from No.")
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
            }
        }
    }

    actions
    {
    }
}

