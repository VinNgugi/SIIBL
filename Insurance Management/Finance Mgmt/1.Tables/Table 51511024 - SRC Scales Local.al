table 51511024 "SRC Scales Local"
{
    // version FINANCE


    fields
    {
        field(1;"Salary Scale";Code[20])
        {
            //TableRelation = "Salary Scales";
        }
        field(2;"SRC Cluster";Code[50])
        {
            TableRelation = "SRC Cluster Places";
        }
        field(3;Amount;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Salary Scale","SRC Cluster")
        {
        }
    }

    fieldgroups
    {
    }
}

