table 51513145 "Product Age Selections"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Product Code";Code[20])
        {
        }
        field(2;Age;Code[20])
        {
            TableRelation = "Age limit";
        }
        field(3;"Underwriter Code";Code[20])
        {
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1;"Product Code","Underwriter Code")
        {
        }
    }

    fieldgroups
    {
    }
}

