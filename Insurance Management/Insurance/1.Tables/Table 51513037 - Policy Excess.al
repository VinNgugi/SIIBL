table 51513037 "Policy Excess"
{
    // version AES-INS 1.0


    fields
    {
        field(1;Excess;Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[30])
        {
        }
        field(3;Amount;Decimal)
        {
        }
        field(4;UnderWriter;Code[20])
        {
            TableRelation = Vendor;
        }
        field(5;"Product Plan";Code[20])
        {
            //TableRelation = "Policy Type";
        }
    }

    keys
    {
        key(Key1;Excess)
        {
        }
    }

    fieldgroups
    {
    }
}

