xmlport 51513007 "PolicyType life"
{
    // version AES-INS 1.0

    Format = VariableText;

    schema
    {
        textelement(PolicyImportExport)
        {
            tableelement("Policy Type"; "Policy Type")
            {
                XmlName = 'PolicyType';
                fieldelement(Code; "Policy Type".Code)
                {
                }
                fieldelement(Desc; "Policy Type".Description)
                {
                }
                fieldelement(Type; "Policy Type"."Insurance Type")
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

