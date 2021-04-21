page 51511031 "Employee Bank List"
{
    // version FINANCE

    CardPageID = "Employee Bank Account Card";
    PageType = List;
    SourceTable = "Staff  Bank Account";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("Employee No."; "Employee No.")
                {
                    Visible = false;
                }
                field(Code; Code)
                {
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Name 2"; "Name 2")
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field(City; City)
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(Contact; Contact)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Telex No."; "Telex No.")
                {
                }
                field("Bank Account No."; "Bank Account No.")
                {
                }
                field("Transit No."; "Transit No.")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Country Code"; "Country Code")
                {
                }
                field(County; County)
                {
                }
                field("Fax No."; "Fax No.")
                {
                }
                field("Telex Answer Back"; "Telex Answer Back")
                {
                }
                field("Language Code"; "Language Code")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field("Home Page"; "Home Page")
                {
                }
            }
        }
    }

    actions
    {
    }
}

