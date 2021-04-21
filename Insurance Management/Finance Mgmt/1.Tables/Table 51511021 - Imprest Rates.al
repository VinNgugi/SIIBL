table 51511021 "Imprest Rates"
{
    // version FINANCE

    //DrillDownPageID = 51511949;
    //LookupPageID = 51511949;

    fields
    {
        field(1;"County Code";Code[20])
        {
            Editable = false;
            TableRelation = Counties;
        }
        field(2;"Job Grade";Code[30])
        {
            //TableRelation = "Salary Scales";
        }
        field(3;Amount;Decimal)
        {
        }
        field(4;Description;Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"County Code","Job Grade")
        {
        }
    }

    fieldgroups
    {
    }
}

