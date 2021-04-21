table 51513323 "Period Table"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Code";Code[20])
        {
            TableRelation = "Product Policy Codes".Code;
        }
        field(2;Type;Code[20])
        {
            TableRelation = "Table Types".Type WHERE ("Table Type"=CONST("Amount At Risk"));
        }
        field(3;Age;Integer)
        {
        }
        field(4;Term;Integer)
        {
        }
        field(5;Year;Integer)
        {
        }
        field(6;Rate;Decimal)
        {
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

