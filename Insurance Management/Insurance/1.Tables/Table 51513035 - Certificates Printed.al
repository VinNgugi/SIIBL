table 51513035 "Certificates Printed"
{
    // version AES-INS 1.0


    fields
    {
        field(1;Insurer;Code[20])
        {
            TableRelation = Vendor;
        }
        field(2;"Policy No";Code[20])
        {
            TableRelation = "Insure Header";
        }
        field(3;"Client No.";Code[20])
        {
            TableRelation = Customer;
        }
        field(4;"Certificate No";Code[20])
        {
        }
        field(5;"Printed By";Code[70])
        {
        }
        field(6;Spoiled;Boolean)
        {
        }
        field(7;"Reg No.";Code[30])
        {
        }
        field(8;Premium;Decimal)
        {
        }
        field(9;"From Date";Date)
        {
        }
        field(10;"To Date";Date)
        {
        }
        field(11;"Time Printed";Time)
        {
        }
    }

    keys
    {
        key(Key1;"Certificate No")
        {
        }
    }

    fieldgroups
    {
    }
}

