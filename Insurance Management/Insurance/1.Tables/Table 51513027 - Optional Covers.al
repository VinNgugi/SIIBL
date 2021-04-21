table 51513027 "Optional Covers"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Free Limit Value";Decimal)
        {
        }
        field(4;Type;Option)
        {
            OptionMembers = " ",Loading,Discount,Tax;
        }
        field(5;"Rate Type";Option)
        {
            OptionMembers = " ","Per Cent","Per Mille";
        }
        field(6;Rate;Decimal)
        {
        }
        field(7;"Calculation Method";Option)
        {
            OptionCaption = '" ,Percentage of Sum Insured,based on table,Flat Amount"';
            OptionMembers = " ","Percentage of Sum Insured","based on table","Flat Amount";
        }
        field(8;"Premium Table Link";Code[10])
        {
        }
        field(9;"Value Allowed";Decimal)
        {
        }
        field(10;"Yellow Card";Boolean)
        {
        }
        field(11;"Medical Per Person";Decimal)
        {
        }
        field(12;"Loading Amount";Decimal)
        {
        }
        field(13;"Discount Amount";Decimal)
        {
        }
        field(14;"Policy Type";Code[20])
        {
            TableRelation = "Policy Type";
        }
        field(15;"Insurance Type";Option)
        {
            OptionCaption = '" ,General,Life"';
            OptionMembers = " ",General,Life;
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

