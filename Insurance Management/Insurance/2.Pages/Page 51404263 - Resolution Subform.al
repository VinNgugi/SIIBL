page 51404263 "Resolution Subform"
{
    // version AES-PAS 1.0

    PageType = ListPart;
    SourceTable = "Resolution of tasks Status";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Resolution Code"; "Resolution Code")
                {
                }
                field(IRCode; IRCode)
                {
                }
                field("Step Number"; "Step Number")
                {
                }
                field("Resolution Description"; "Resolution Description")
                {
                }
                field("Resolution Status"; "Resolution Status")
                {
                }
            }
        }
    }

    actions
    {
    }
}

