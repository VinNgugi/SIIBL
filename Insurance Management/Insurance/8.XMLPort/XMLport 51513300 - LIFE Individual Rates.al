xmlport 51513300 "LIFE Individual Rates"
{
    // version AES-INS 1.0

    Direction = Import;
    FileName = 'E:\Life System\NAV205LSystem\IndividualTable.csv';
    Format = VariableText;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(IndividualRatesPort)
        {
            /*tableelement("LIFE Individual Rates"; "LIFE Individual Rates")
            {
                XmlName = 'IndividualRates';
                fieldelement(tablename; "LIFE Individual Rates"."Column No.")
                {
                }
                fieldelement(age; "LIFE Individual Rates".RateTableName)
                {
                }
                fieldelement(term; "LIFE Individual Rates".Age)
                {
                }
                fieldelement(rate; "LIFE Individual Rates".Term)
                {
                }
                fieldelement(denominator; "LIFE Individual Rates".Rate)
                {
                }
                fieldelement(interest; "LIFE Individual Rates".Denominator)
                {
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

