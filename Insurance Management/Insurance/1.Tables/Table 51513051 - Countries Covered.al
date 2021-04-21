table 51513051 "Countries Covered"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Policy Type";Code[12])
        {
            TableRelation = "Policy Type";
        }
        field(2;"Area";Code[10])
        {
            TableRelation = "Area of coverage";
        }
        field(3;Country;Code[10])
        {
            TableRelation = "Country/Region";

            trigger OnValidate();
            begin
                 // IF Countries.GET(Country) THEN
                 // "Country Name":=Countries.Name;
            end;
        }
        field(4;"Country Name";Text[30])
        {
        }
        field(5;UnderWriter;Code[20])
        {
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1;"Policy Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Countries : Record "Country/Region";
}

