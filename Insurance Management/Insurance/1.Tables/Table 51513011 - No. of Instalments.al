table 51513011 "No. of Instalments"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513033;
    LookupPageID = 51513033;

    fields
    {
        field(1;"No. Of Instalments";Integer)
        {
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Period Length";DateFormula)
        {
        }
        field(4;"Last Instalment Period Length";DateFormula)
        {
        }
    }

    keys
    {
        key(Key1;"No. Of Instalments")
        {
        }
    }

    fieldgroups
    {
    }
}

