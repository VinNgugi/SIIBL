xmlport 50126 bank
{
    // version AES-INS 1.0

    FieldDelimiter = '|';
    FieldSeparator = '*';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TransactionType = Update;

    schema
    {
        textelement(bank)
        {
            tableelement("Bank Account"; "Bank Account")
            {
                XmlName = 'Banks';
                fieldelement(no; "Bank Account"."No.")
                {
                    FieldValidate = No;
                }
                fieldelement(name; "Bank Account".Name)
                {
                }
                fieldelement(searchname; "Bank Account"."Search Name")
                {
                }
                fieldelement(name2; "Bank Account"."Name 2")
                {
                }
                fieldelement(address; "Bank Account".Address)
                {
                }
                fieldelement(address1; "Bank Account"."Address 2")
                {
                }
                fieldelement(city; "Bank Account".City)
                {
                }
                fieldelement(contact; "Bank Account".Contact)
                {
                }
                fieldelement(TelNo; "Bank Account"."Phone No.")
                {
                }
                fieldelement(CustPg; "Bank Account"."Telex No.")
                {
                }
                fieldelement(PayTerms; "Bank Account"."Bank Account No.")
                {
                }
                fieldelement(invdisc; "Bank Account"."Transit No.")
                {
                }
                fieldelement(blocked; "Bank Account"."Territory Code")
                {
                }
                fieldelement(paytovend; "Bank Account"."Global Dimension 1 Code")
                {
                    FieldValidate = No;
                }
                fieldelement(appmethod; "Bank Account"."Global Dimension 2 Code")
                {
                }
                fieldelement(type; "Bank Account"."Chain Name")
                {
                }
                fieldelement(contact1; "Bank Account"."Min. Balance")
                {
                }
                fieldelement(faxno; "Bank Account"."Bank Acc. Posting Group")
                {
                }
                fieldelement(GenBusPG; "Bank Account"."Currency Code")
                {
                }
                fieldelement(post_code; "Bank Account"."Language Code")
                {
                }
                fieldelement(email; "Bank Account"."Statistics Group")
                {
                }
                fieldelement(no_series; "Bank Account"."Our Contact Code")
                {
                }
                fieldelement(VAT_BusPG; "Bank Account"."Country/Region Code")
                {
                }
                fieldelement(amt; "Bank Account".Amount)
                {
                }
                fieldelement(Comment; "Bank Account".Comment)
                {
                }
                fieldelement(Blocked; "Bank Account".Blocked)
                {
                }
                fieldelement(LastStatementNo; "Bank Account"."Last Statement No.")
                {
                }
                fieldelement(LastDatemodified; "Bank Account"."Last Date Modified")
                {
                }
                fieldelement(Fax; "Bank Account"."Fax No.")
                {
                }
                fieldelement(TelexAnsBack; "Bank Account"."Telex Answer Back")
                {
                }
                fieldelement(postcode; "Bank Account"."Post Code")
                {
                }
                fieldelement(county; "Bank Account".County)
                {
                }
                fieldelement(lastcheckno; "Bank Account"."Last Check No.")
                {
                }
                fieldelement(branch; "Bank Account"."Bank Branch No.")
                {
                }
                fieldelement(email; "Bank Account"."E-Mail")
                {
                }
                fieldelement(Hmpage; "Bank Account"."Home Page")
                {
                }
                fieldelement(noseries; "Bank Account"."No. Series")
                {
                }
                fieldelement(checkreportID; "Bank Account"."Check Report ID")
                {
                }
                fieldelement(checkreportname; "Bank Account"."Check Report Name")
                {
                }
                fieldelement(IBAN; "Bank Account".IBAN)
                {
                }
                fieldelement(SWIFTCODE; "Bank Account"."SWIFT Code")
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

