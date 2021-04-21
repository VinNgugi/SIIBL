table 51513063 "Claim Types"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Code";Code[20])
        {
            NotBlank = true;
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Claim Amount";Decimal)
        {
        }
        field(4;"Paid Amount";Decimal)
        {
        }
        field(5;"Female Restriction";Boolean)
        {
        }
        field(6;"Module Type";Option)
        {
            OptionMembers = Medical,"Medical Brokerage",Travel,"Life and Investment","Amini Data","Medical AWS","Medical AWSIHS",Funded,"General Business";
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

