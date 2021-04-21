xmlport 50107 cust
{
    // version AES-INS 1.0

    FieldSeparator = '@';
    Format = VariableText;

    schema
    {
        textelement(cust)
        {
            tableelement(Customer; Customer)
            {
                XmlName = 'customer';
                fieldelement(no; Customer."No.")
                {
                }
                fieldelement(name; Customer.Name)
                {
                }
                fieldelement(searchname; Customer."Search Name")
                {
                }
                fieldelement(address; Customer.Address)
                {
                }
                fieldelement(address1; Customer."Address 2")
                {
                }
                fieldelement(city; Customer.City)
                {
                }
                fieldelement(contact; Customer.Contact)
                {
                }
                fieldelement(TelNo; Customer."Phone No.")
                {
                }
                fieldelement(CustPg; Customer."Customer Posting Group")
                {
                }
                fieldelement(PayTerms; Customer."Payment Terms Code")
                {
                }
                fieldelement(invdisc; Customer."Invoice Disc. Code")
                {
                }
                fieldelement(Country; Customer."Country/Region Code")
                {
                }
                fieldelement(blocked; Customer.Blocked)
                {
                }
                fieldelement(appmethod; Customer."Application Method")
                {
                }
                fieldelement(faxno; Customer."Fax No.")
                {
                }
                fieldelement(GenBusPG; Customer."Gen. Bus. Posting Group")
                {
                }
                fieldelement(post_code; Customer."Post Code")
                {
                }
                fieldelement(email; Customer."E-Mail")
                {
                }
                fieldelement(no_series; Customer."No. Series")
                {
                }
                fieldelement(VAT_BusPG; Customer."VAT Bus. Posting Group")
                {
                }
                fieldelement(Reserve; Customer.Reserve)
                {
                }
                fieldelement(shipping_advice; Customer."Shipping Advice")
                {
                }
                fieldelement(AllowLineDisc; Customer."Allow Line Disc.")
                {
                }
                fieldelement(copyselltoaddr; Customer."Copy Sell-to Addr. to Qte From")
                {
                }
                fieldelement(CustomerType; Customer."Insured Type")
                {
                }
                fieldelement(sex; Customer.Sex)
                {
                }
                fieldelement(title; Customer.Title)
                {
                }
                fieldelement(maritalstatus; Customer."Marital Status")
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

