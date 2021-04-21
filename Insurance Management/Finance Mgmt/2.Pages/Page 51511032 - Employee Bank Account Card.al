page 51511032 "Employee Bank Account Card"
{
    // version FINANCE

    PageType = Card;
    SourceTable = "Staff  Bank Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Code)
                {
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                    Caption = 'Post Code/City';
                }
                field(City; City)
                {
                }
                field("Country Code"; "Country Code")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Contact; Contact)
                {
                }
                field(Name; Name)
                {
                }
                field("Name 2"; "Name 2")
                {
                    Caption = 'Branch Name';
                }
                field("Currency Code"; "Currency Code")
                {
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Fax No."; "Fax No.")
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

    var
        Mail: Codeunit 397;
}

