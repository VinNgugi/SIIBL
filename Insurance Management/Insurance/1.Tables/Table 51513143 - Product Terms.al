table 51513143 "Product Terms"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Product Code";Code[20])
        {
            //TableRelation = "Policy Type";
        }
        field(2;"Term Code";Code[20])
        {
            TableRelation = Term;
        }
        field(3;"Underwriter Code";Code[20])
        {
            TableRelation=Vendor;
        }
        field(4;"Deffered/Saving Period";Code[20])
        {

         TableRelation = Term;

        }
    }

    keys
    {
        key(Key1;"Product Code","Underwriter Code","Term Code")
        {
        }
    }

    fieldgroups
    {
    }
}

