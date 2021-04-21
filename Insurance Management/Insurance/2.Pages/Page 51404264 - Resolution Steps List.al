page 51404264 "Resolution Steps List"
{
    // version AES-PAS 1.0

    PageType = ListPart;
    SourceTable = "Resolution Steps";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(IRCode; IRCode)
                {
                }
                field("Step Number"; "Step Number")
                {
                }
                field("Resolution Description"; "Resolution Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}

