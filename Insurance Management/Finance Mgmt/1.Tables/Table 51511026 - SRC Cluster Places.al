table 51511026 "SRC Cluster Places"
{
    // version FINANCE


    fields
    {
        field(1;"Cluster Code";Code[50])
        {
        }
        field(2;"Cluster Place";Code[250])
        {
        }
    }

    keys
    {
        key(Key1;"Cluster Code","Cluster Place")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Cluster Place")
        {
        }
    }
}

