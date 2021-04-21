xmlport 50123 vend
{
    // version AES-INS 1.0

    Format = VariableText;

    schema
    {
        textelement(cust)
        {
            tableelement(Vendor; Vendor)
            {
                XmlName = 'Vendor';
                fieldelement(no; Vendor."No.")
                {
                }
                fieldelement(name; Vendor.Name)
                {
                }
                fieldelement(searchname; Vendor."Search Name")
                {
                }
                fieldelement(name2; Vendor."Name 2")
                {
                }
                fieldelement(address; Vendor.Address)
                {
                }
                fieldelement(address1; Vendor."Address 2")
                {
                }
                fieldelement(city; Vendor.City)
                {
                }
                fieldelement(contact; Vendor.Contact)
                {
                }
                fieldelement(TelNo; Vendor."Phone No.")
                {
                }
                fieldelement(CustPg; Vendor."Vendor Posting Group")
                {
                }
                fieldelement(PayTerms; Vendor."Payment Terms Code")
                {
                }
                fieldelement(invdisc; Vendor."Invoice Disc. Code")
                {
                }
                fieldelement(blocked; Vendor.Blocked)
                {
                }
                fieldelement(paytovend; Vendor."Pay-to Vendor No.")
                {
                    FieldValidate = No;
                }
                fieldelement(appmethod; Vendor."Application Method")
                {
                }
                textelement(underwriter)
                {
                    XmlName = 'type';
                }
                fieldelement(contact1; Vendor."Telex No.")
                {
                }
                fieldelement(faxno; Vendor."Fax No.")
                {
                }
                fieldelement(GenBusPG; Vendor."Gen. Bus. Posting Group")
                {
                }
                fieldelement(post_code; Vendor."Post Code")
                {
                }
                fieldelement(email; Vendor."E-Mail")
                {
                }
                fieldelement(no_series; Vendor."No. Series")
                {
                }
                fieldelement(VAT_BusPG; Vendor."VAT Bus. Posting Group")
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

