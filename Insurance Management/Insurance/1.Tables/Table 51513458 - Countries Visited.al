table 51513458 "Countries Visited"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement;
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Country Code"; Code[20])
        {
            TableRelation = "Country/Region";

            trigger OnValidate();
            begin
                IF CountryRec.GET("Country Code") THEN
                  "Country Name":=CountryRec.Name;
            end;
        }
        field(4;"Country Name";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Country Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        CountryRec : Record "Country/Region";
}

