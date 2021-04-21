page 51513089 "Credit Request List"
{
    // version AES-INS 1.0

    CardPageID = "Credit Request";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Credit Request";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request No."; "Request No.")
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Request Time"; "Request Time")
                {
                }
                field("Recommended By"; "Recommended By")
                {
                }
                field("Credit Amount"; "Credit Amount")
                {
                }
                field("Credit Period"; "Credit Period")
                {
                }
                field("Customer ID"; "Customer ID")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                }
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

