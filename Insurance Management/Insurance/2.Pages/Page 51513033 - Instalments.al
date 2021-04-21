page 51513033 Instalments
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "No. of Instalments";
    UsageCategory=Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Of Instalments"; "No. Of Instalments")
                {
                }
                field(Description; Description)
                {
                }
                field("Period Length"; "Period Length")
                {
                }
                field("Last Instalment Period Length"; "Last Instalment Period Length")
                {
                }
            }
        }
    }

    actions
    {
    }
}

