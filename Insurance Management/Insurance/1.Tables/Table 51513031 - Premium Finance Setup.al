table 51513031 "Premium Finance Setup"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Premium Financier";Code[20])
        {
            TableRelation = Customer;
        }
        field(2;"Effective Date";Date)
        {
        }
        field(3;"Minimum Interest";Decimal)
        {
        }
        field(4;"Minimum amount Financed";Decimal)
        {
        }
        field(5;"Cash Required";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Premium Financier")
        {
        }
    }

    fieldgroups
    {
    }
}

