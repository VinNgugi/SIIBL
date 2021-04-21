xmlport 50118 BankPG
{
    // version AES-INS 1.0

    Format = VariableText;

    schema
    {
        textelement(BanKPG)
        {
            tableelement("Bank Account Posting Group"; "Bank Account Posting Group")
            {
                XmlName = 'BankAccPG';
                fieldelement(code; "Bank Account Posting Group".Code)
                {
                }
                fieldelement(gl; "Bank Account Posting Group"."G/L Bank Account No.")
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

