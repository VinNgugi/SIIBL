table 51513073 "Short Term Cover"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;"Starting No. of Period";Integer)
        {
        }
        field(3;"Ending No. of  Period";Integer)
        {
        }
        field(4;"Percentage Of Prem. Applicable";Decimal)
        {
        }
        field(5;"Period Length";DateFormula)
        {
        }
        field(6;"Table Type";Option)
        {
            OptionCaption = '" ,Daily,Monthly"';
            OptionMembers = " ",Daily,Monthly;
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

