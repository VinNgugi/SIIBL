page 51404258 "Resolutions List"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New list form created for Resolution

    CardPageID = "Interaction Resolutions";
    Editable = false;
    PageType = List;
    SourceTable = "Interaction Resolution";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field(Descriptionx;Descriptionx)
                {
                }
                field(Cause;Cause)
                {
                }
                field("Interaction No.";"Interaction No.")
                {
                }
                field("Cause No.";"Cause No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

