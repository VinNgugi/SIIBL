page 51513095 "Archived Quote List Individual"
{
    // version AES-INS 1.0

    CardPageID = "Archived Quote-Individual Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Header Archive";

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

