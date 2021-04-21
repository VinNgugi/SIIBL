table 51511022 Counties
{
    // version FINANCE

    //DrillDownPageID = 51511567;
    //LookupPageID = 51511567;

    fields
    {
        field(1;"County Code";Code[30])
        {
        }
        field(2;"County Description";Text[80])
        {
        }
    }

    keys
    {
        key(Key1;"County Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"County Code","County Description")
        {
        }
    }
}

