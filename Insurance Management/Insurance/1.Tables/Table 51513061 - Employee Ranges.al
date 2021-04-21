table 51513061 "Employee Ranges"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Employee No. Range";Code[10])
        {
            NotBlank = true;
        }
        field(2;Minimum;Integer)
        {
        }
        field(3;Maximum;Integer)
        {
        }
        field(4;Underwriter;Code[20])
        {
            TableRelation = Vendor;
        }
        field(5;"Product Plan";Code[12])
        {
        }
        field(6;"Client Type";Code[10])
        {
        }
    }

    keys
    {
        key(Key1;"Employee No. Range",Underwriter,"Product Plan")
        {
        }
    }

    fieldgroups
    {
    }
}

