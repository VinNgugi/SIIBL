table 51513158 "Interest Rate Tables"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Table Code";Code[20])
        {
            TableRelation = "Premium Tables";
        }
        field(2;"Effective Date";Date)
        {
        }
        field(3;"Rate Type";Option)
        {
            OptionCaption = '" ,Percentage,Flat amount,Per Mille"';
            OptionMembers = " ",Percentage,"Flat amount","Per Mille";
        }
        field(4;"Table Name";Text[50])
        {
        }
        field(5;"Interest Rate";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Table Code")
        {
        }
    }

    fieldgroups
    {
    }
}

