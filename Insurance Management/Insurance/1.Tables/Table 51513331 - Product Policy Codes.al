table 51513331 "Product Policy Codes"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Table Type";Option)
        {
            OptionCaption = 'Premium,Amount At Risk';
            OptionMembers = Premium,"Amount At Risk";
            TableRelation = "Table Types"."Table Type" WHERE ("Table Type"=CONST("Amount At Risk"));
        }
        field(2;Type;Code[20])
        {
        }
        field(3;"Code";Code[20])
        {
        }
        field(4;Description;Text[100])
        {
        }
        field(5;"Product Type";Option)
        {
            OptionCaption = '" ,Risk Premium,Original Terms"';
            OptionMembers = " ","Risk Premium","Original Terms";
        }
    }

    keys
    {
        key(Key1;"Table Type")
        {
        }
    }

    fieldgroups
    {
    }
}

