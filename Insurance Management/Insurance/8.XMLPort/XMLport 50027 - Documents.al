xmlport 50127 Documents
{
    // version AES-INS 1.0

    Format = VariableText;

    schema
    {
        textelement(Docs)
        {
            tableelement("Document Setup"; "Document Setup")
            {
                XmlName = 'Doc';
                fieldelement(Docname; "Document Setup"."Document Name")
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

