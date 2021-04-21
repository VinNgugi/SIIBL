table 51513141 "Endowment Assurance Types"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Premium Calculation based on";Option)
        {
            OptionCaption = '" ,Term,Age"';
            OptionMembers = " ",Term,Age;
        }
        field(4;"Medical Underwriting";Option)
        {
            OptionCaption = 'None,Full,Limited';
            OptionMembers = "None",Full,Limited;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

