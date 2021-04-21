table 51511025 "SRC Scales-International"
{
    // version FINANCE


    fields
    {
        field(1; "Salary Scale"; Code[20])
        {
            //TableRelation = "Salary Scales";
        }
        field(2; Country; Code[50])
        {
            TableRelation = "Country/Region";
        }
        field(3; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Salary Scale", Country)
        {
        }
    }

    fieldgroups
    {
    }
}

