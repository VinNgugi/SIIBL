table 51513327 Commissions
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Treaty Code";Code[30])
        {
        }
        field(2;"Addendum Code";Integer)
        {
        }
        field(3;"Lower Limit";Decimal)
        {
        }
        field(4;"Upper Limit";Decimal)
        {
        }
        field(5;"Commission Type";Option)
        {
            OptionCaption = '" ,Main Benefit,Rider"';
            OptionMembers = " ","Main Benefit",Rider;
        }
        field(6;"New business Commission";Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
        field(7;"Renewal Commission";Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1;"Treaty Code","Addendum Code","Lower Limit","Upper Limit","Commission Type")
        {
        }
    }

    fieldgroups
    {
    }
}

