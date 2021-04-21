page 51513237 "Maturity Instalment Ratio"
{
   
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Instalment Ratio";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Instalment No"; "Instalment No")
                {
                }
                field(Percentage; Percentage)
                {
                }
                field("Period Length"; "Period Length")
                {
                }
            }
        }
    }

    actions
    {
    }
}

