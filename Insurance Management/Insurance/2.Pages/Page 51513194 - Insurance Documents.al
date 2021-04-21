page 51513194 "Insurance Documents"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insurance Documents";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Name"; "Document Name")
                {
                }
                field(Required; Required)
                {
                }
                field(Received; Received)
                {
                }
                field("Attachment Filename"; "Attachment Filename")
                {
                }
            }
        }
    }

    actions
    {
    }
}

