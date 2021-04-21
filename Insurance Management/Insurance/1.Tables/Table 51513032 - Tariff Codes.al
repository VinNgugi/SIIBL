table 51513032 "Tariff Codes"
{
    // version AES-INS 1.0

    //DrillDownPageID = 51513131;
    //LookupPageID = 51513131;

    fields
    {
        field(1;"Code";Code[20])
        {
            NotBlank = true;
        }
        field(2;Description;Text[50])
        {
        }
        field(3;Percentage;Decimal)
        {
        }
        field(4;"G/L Account";Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

