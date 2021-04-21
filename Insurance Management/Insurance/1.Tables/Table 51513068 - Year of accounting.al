table 51513068 "Year of accounting"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Year Of Accounting ID";Code[20])
        {
            NotBlank = true;
        }
        field(2;"Year Start Date";Date)
        {
        }
        field(3;"Year End Date";Date)
        {
        }
        field(4;Underwriter;Code[20])
        {
            TableRelation = Vendor;
        }
        field(5;"Binder Number";Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Year Of Accounting ID")
        {
        }
    }

    fieldgroups
    {
    }
}

