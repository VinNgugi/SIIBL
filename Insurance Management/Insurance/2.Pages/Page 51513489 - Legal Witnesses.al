page 51513489 "Legal Witnesses"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Legal Witnesses";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Witness ID"; "Witness ID")
                {
                }
                field("Witness Name"; "Witness Name")
                {
                }
                field(Required; Required)
                {
                }
                field(Attended; Attended)
                {
                }
                field("Summons Required"; "Summons Required")
                {
                }
            }
        }
    }

    actions
    {
    }
}

