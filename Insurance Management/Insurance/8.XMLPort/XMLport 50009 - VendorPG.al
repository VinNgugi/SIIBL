xmlport 50109 VendorPG
{
    // version AES-INS 1.0

    Format = VariableText;

    schema
    {
        textelement(VendPGs)
        {
            tableelement("Vendor Posting Group"; "Vendor Posting Group")
            {
                XmlName = 'VendPG';
                fieldelement(Code; "Vendor Posting Group".Code)
                {
                }
                fieldelement(PayablesAC; "Vendor Posting Group"."Payables Account")
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

