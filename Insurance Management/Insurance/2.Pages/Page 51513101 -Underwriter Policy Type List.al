page 51513101 "Underwriter Policy Type List"
{
    // version AES-INS 1.0

    CardPageID = "Underwriter Policy Type Card";
    Editable = false;
    PageType = List;
    SourceTable = "Underwriter Policy Types";
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

