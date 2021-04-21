table 51513163 "Medical test lines"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Test Code";Code[20])
        {
            TableRelation = "Underwriting Medical Tests";
        }
        field(3;Results;Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Document No.")
        {
        }
    }

    fieldgroups
    {
    }
}

