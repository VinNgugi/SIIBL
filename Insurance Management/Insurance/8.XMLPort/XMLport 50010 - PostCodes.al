xmlport 50110 PostCodes
{
    // version AES-INS 1.0

    Format = VariableText;

    schema
    {
        textelement(cust)
        {
            tableelement("Post Code"; "Post Code")
            {
                XmlName = 'customer';
                fieldelement(RegionCodes; "Post Code"."Country/Region Code")
                {
                }
                fieldelement(Code; "Post Code".Code)
                {
                }
                fieldelement(City; "Post Code".County)
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

