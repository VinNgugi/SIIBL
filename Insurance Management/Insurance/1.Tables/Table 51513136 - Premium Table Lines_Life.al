table 51513136 "Premium Table Lines_Life"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Table Code";Code[20])
        {
            TableRelation = "Premium Tables";
        }
        field(2;"SA From";Decimal)
        {
        }
        field(3;"SA To";Decimal)
        {
        }
        field(4;"Age From";Integer)
        {
        }
        field(5;"Age To";Integer)
        {
        }
        field(6;"Standard Rate";Decimal)
        {
        }
        field(7;Per;Decimal)
        {
        }
        field(8;"Male Ratio";Decimal)
        {
        }
        field(9;"Female Ratio";Decimal)
        {
        }
        field(10;"Term From";DateFormula)
        {
        }
        field(11;"Term To";DateFormula)
        {
        }
        field(12;Premium;Decimal)
        {
        }
        field(13;"Rate type";Code[20])
        {
        }
        field(14;"Product Code";Code[20])
        {
        }
        field(15;"SA Band";Code[20])
        {
            TableRelation = "Age Group";
        }
        field(16;"Age Band";Code[20])
        {
            TableRelation = "SA Band";
        }
        field(17;"Term Band";Code[20])
        {
            TableRelation = Term;
        }
    }

    keys
    {
        key(Key1;"Table Code","SA Band","Term Band","Age Band")
        {
        }
    }

    fieldgroups
    {
    }
}

