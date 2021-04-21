page 51513512 "Tables Setup List"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Premium Tables";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table Code"; "Table Code")
                {
                }
                field(Name; Name)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Premium Tables")
            {
                RunObject = Page "Premium Table Lines_life";
                RunPageLink = "Table Code" = FIELD("Table Code");
            }
            action("Premium Discount")
            {
                RunObject = Page "Premium Discount Rate";
                RunPageLink = "Table Code" = FIELD("Table Code");
            }
            action("Unit Linked allocation %")
            {
                RunObject = Page "Unit Linked allocation";
                RunPageLink = "Table Code" = FIELD("Table Code");
            }
        }
    }
}

