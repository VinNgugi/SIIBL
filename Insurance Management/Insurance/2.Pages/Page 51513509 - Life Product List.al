page 51513509 "Life Product List"
{
    // version AES-INS 1.0

    CardPageID = "Life Product Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Policy Type";
    SourceTableView = WHERE("Insurance Type"=CONST(Life));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Class; Class)
                {
                }
                field("short code"; "short code")
                {
                }
                field("Short Name"; "Short Name")
                {
                }
                field(Type; Type)
                {
                }
                field(Rating; Rating)
                {
                }
                field("Insurance Type"; "Insurance Type")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Documents Required")
            {
                RunObject = Page "Documents Required";
                RunPageLink = "Policy Type" = FIELD(Code);
            }
            action("Product Benefits")
            {
                RunObject = Page "Product Benefits Definition";
                RunPageLink = "Product Code" = FIELD(Code);
            }
        }
    }
}

