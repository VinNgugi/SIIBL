table 51513135 "Surrender Rate Table"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Product Code";Code[20])
        {
        }
        field(2;"Age From";Integer)
        {
        }
        field(3;"Age To";Integer)
        {
        }
        field(4;Per;Decimal)
        {
        }
        field(5;"Term From";Integer)
        {
        }
        field(6;"Term to";Integer)
        {
        }
        field(7;Rate;Decimal)
        {
        }
        field(8;"Rate Type";Code[20])
        {
        }
        field(9;"Product Specific";Boolean)
        {
        }
        field(10;"Age Band";Code[20])
        {
            TableRelation = "Age Group";
        }
        field(11;"Term Band";Code[20])
        {
            TableRelation = "Term Band";
        }
    }

    keys
    {
        key(Key1;"Product Code")
        {
        }
    }

    fieldgroups
    {
    }
}

