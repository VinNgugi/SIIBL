page 51513090 "Certificate Allocation list"
{
    // version AES-INS 1.0

    CardPageID = "Certificate allocation card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Certificate allocation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Allocation No."; "Allocation No.")
                {
                }
                field("Allocation Date"; "Allocation Date")
                {
                }
                field("Batch No"; "Batch No")
                {
                }
                field("From Cert No."; "From Cert No.")
                {
                }
                field("To Cert No."; "To Cert No.")
                {
                }
                field("Allocate to User"; "Allocate to User")
                {
                }
                field("Allocate to Branch"; "Allocate to Branch")
                {
                }
            }
        }
    }

    actions
    {
    }
}

