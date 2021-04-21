page 51513069 "Quote List-Endorsements"
{
    // version AES-INS 1.0

    CardPageID = "Endorsement Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type"=CONST(Endorsement));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Action Type"; "Action Type")
                {
                    Caption = 'Endorsement Type';
                }
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

