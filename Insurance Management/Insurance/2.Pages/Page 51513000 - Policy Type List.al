page 51513000 "Policy Type List"
{
    // version AES-INS 1.0

    CardPageID = "Policy Type Card";
    Editable = false;
    PageType = List;
    SourceTable = "Policy Type";
    UsageCategory = Lists;

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
        }
    }
}

