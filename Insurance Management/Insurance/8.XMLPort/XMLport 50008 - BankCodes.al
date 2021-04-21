xmlport 50108 BankCodes
{
    // version AES-INS 1.0

    Format = VariableText;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(cust)
        {
            /*tableelement(Table51507250;Table51507250)
            {
                XmlName = 'customer';
                fieldelement(no;"Bank Codes"."Bank Code")
                {
                    Width = 6;
                }
                fieldelement(name;"Bank Codes"."Bank Name and Branch")
                {
                    Width = 250;
                }
            }*/
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

