page 51513032 "Premium table lines"
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Premium table Lines";
    UsageCategory=lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Seating Capacity"; "Seating Capacity")
                {
                }
                field(Instalments; Instalments)
                {
                }
                field("Premium Amount"; "Premium Amount")
                {
                }
                field("Vehicle Type"; "Vehicle Type")
                {
                }
                field("Vehicle Usage"; "Vehicle Usage")
                {
                }
                field("PPL Cost Per PAX"; "PPL Cost Per PAX")
                {
                }
                field("Premium Rate %"; "Premium Rate %")
                {
                }
            }
        }
    }

    actions
    {
    }
}

