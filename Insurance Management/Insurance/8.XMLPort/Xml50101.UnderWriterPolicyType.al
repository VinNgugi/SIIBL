xmlport 50101 "UnderWriter Policy Type"
{
    Format = VariableText;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(UnderwriterPolicyTypes; "Underwriter Policy Types")
            {
                fieldelement(Code; UnderwriterPolicyTypes.Code)
                {
                }
                fieldelement(Description; UnderwriterPolicyTypes.Description)
                {
                }
                fieldelement(ClassofInsurance; UnderwriterPolicyTypes."Class of Insurance")
                {
                }
                fieldelement(CommisionageSIIBL; UnderwriterPolicyTypes."Commision % age(SIIBL)")
                {
                }
                fieldelement(NonRenewable; UnderwriterPolicyTypes."Non Renewable")
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
