page 51513467 "IBNR Setup"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "IBNR Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sub Class"; "Sub Class")
                {
                }
                field("Product Name"; "Product Name")
                {
                    Caption = 'Sub Class Name';
                }
                field(Class; Class)
                {
                }
                field("Year No."; "Year No.")
                {
                }
                field("Net Premium Sub Class"; "Net Premium Sub Class")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("IBNR Setup Lines")
            {
                RunObject = Page 51513468;
                RunPageLink = "Sub Class"=FIELD("Sub Class"),
                              "Year No."=FIELD("Year No.");
            }
        }
    }
}

