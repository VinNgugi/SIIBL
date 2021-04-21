page 51513099 "Underwriter Policy Type"
{
    // version AES-INS 1.0
    CardPageId="Underwriter Policy Type Card";

    PageType = List;
    Editable=false;
    UsageCategory=Lists;
    SourceTable = "Underwriter Policy Types";

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
                //field("Insurer's Name"; "Insurer's Name")
                
                
            
        }
    }
    }

    actions
    {
    }
}

