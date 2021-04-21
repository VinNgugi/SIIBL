xmlport 51513001 policyDetails
{
    // version AES-INS 1.0

    FieldDelimiter = '#';
    FieldSeparator = '$';
    Format = VariableText;

    schema
    {
        textelement(PolicyDetImport)
        {
            tableelement("Policy Details"; "Policy Details")
            {
                XmlName = 'PolicyDetails';
                fieldelement(Code; "Policy Details"."Policy Type")
                {
                }
                fieldelement(DescType; "Policy Details"."Description Type")
                {
                }
                fieldelement(No; "Policy Details"."No.")
                {
                }
                fieldelement(Line_No; "Policy Details"."Line No")
                {
                }
                fieldelement(Desc; "Policy Details".Description)
                {
                }
                fieldelement(sect; "Policy Details".Section)
                {
                }
                fieldelement(actval; "Policy Details"."Actual Value")
                {
                }
                fieldelement(val; "Policy Details".Value)
                {
                }
                fieldelement(txtType; "Policy Details"."Text Type")
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

