page 51513177 "XOL Layers setup"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Cover Layer";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Layer Code"; "Layer Code")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

