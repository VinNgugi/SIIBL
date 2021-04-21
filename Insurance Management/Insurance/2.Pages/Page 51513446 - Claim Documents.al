page 51513446 "Claim Documents"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insurance Documents";
    SourceTableView = WHERE("Document Type"=CONST(claim));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Name"; "Document Name")
                {
                }
                field("Document Path"; "Document Path")
                {
                }
                field(Enclosed; Enclosed)
                {
                }
                field("To Follow"; "To Follow")
                {
                }
                field(Required; Required)
                {
                }
                field(Received; Received)
                {
                }
                field("Date Required"; "Date Required")
                {
                }
                field("Date Received"; "Date Received")
                {
                }
            }
        }
    }

    actions
    {
    }
}

