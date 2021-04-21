page 51513516 "Unit Linked allocation"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Unit Linked Allocation Percent";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Term Code"; "Term Code")
                {
                }
                field("Allocation %"; "Allocation %")
                {
                }
            }
        }
    }

    actions
    {
    }
}

