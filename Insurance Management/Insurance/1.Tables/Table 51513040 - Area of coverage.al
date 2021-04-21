table 51513040 "Area of coverage"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Area Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[130])
        {
        }
        field(3;"Policy Type";Code[12])
        {
            TableRelation = "Policy Type";
        }
        field(4;"Default Option";Code[10])
        {
        }
        field(5;"Insurance Type";Code[10])
        {
        }
        field(6;UnderWriter;Code[20])
        {
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1;"Area Code")
        {
        }
    }

    fieldgroups
    {
    }
}

