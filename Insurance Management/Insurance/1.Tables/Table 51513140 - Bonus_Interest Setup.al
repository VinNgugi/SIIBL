table 51513140 "Bonus_Interest Setup"
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
        field(3;"Bonus Type";Option)
        {
            OptionCaption = ',Annual (Reversionary),Terminal';
            OptionMembers = ,"Annual (Reversionary)",Terminal;
        }
        field(4;Interval;DateFormula)
        {
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

