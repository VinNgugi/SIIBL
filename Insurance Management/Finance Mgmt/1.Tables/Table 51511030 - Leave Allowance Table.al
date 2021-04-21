table 51511030 "Leave Allowance Table"
{
    // version FINANCE

    //DrillDownPageID = 51511710;
    //LookupPageID = 51511710;

    fields
    {
        field(1;"Cluster Code";Code[50])
        {
        }
        field(2;Description;Text[250])
        {
        }
        field(3;"Pay Type";Option)
        {
            OptionCaption = ',Flat Amount,Percentage';
            OptionMembers = ,"Flat Amount",Percentage;
        }
        field(4;"Flat Amount";Decimal)
        {
        }
        field(5;Percentage;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Cluster Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Cluster Code",Description)
        {
        }
    }
}

