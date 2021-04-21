xmlport 50105 Coa
{
    // version AES-INS 1.0

    Format = VariableText;

    schema
    {
        textelement(GL)
        {
            tableelement("G/L Account"; "G/L Account")
            {
                XmlName = 'GLaccount';
                fieldelement(No; "G/L Account"."No.")
                {
                }
                fieldelement(Name; "G/L Account".Name)
                {
                }
                fieldelement(Income_BalanceSheet; "G/L Account"."Income/Balance")
                {
                }
                fieldelement(AccType; "G/L Account"."Account Type")
                {
                }
                fieldelement(Totaling; "G/L Account".Totaling)
                {
                    FieldValidate = No;
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

