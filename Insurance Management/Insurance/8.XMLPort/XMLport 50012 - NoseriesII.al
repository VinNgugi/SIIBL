xmlport 50112 NoseriesII
{
    // version AES-INS 1.0

    Format = VariableText;

    schema
    {
        textelement(Noseriesx)
        {
            tableelement("No. Series"; "No. Series")
            {
                XmlName = 'Noseries';
                fieldelement(Codes; "No. Series".Code)
                {
                }
                fieldelement(Description; "No. Series".Description)
                {
                }
                fieldelement(DefaultNos; "No. Series"."Default Nos.")
                {
                }
                fieldelement(ManualsNos; "No. Series"."Manual Nos.")
                {
                }
                fieldelement(DateOrder; "No. Series"."Date Order")
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

