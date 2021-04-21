page 51404257 "Interaction Cause List"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New list form created for Complaint Sub-Category

    CardPageID = "Interaction Cause Card";
    Editable = true;
    PageType = List;
    SourceTable = "Interaction Cause";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("Interaction No.";"Interaction No.")
                {
                }
                field(Description;Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

