table 51513052 "Premium Financiers Table"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Premium  Financier";Code[20])
        {
        }
        field(2;"Effective Date";Date)
        {
        }
        field(3;Range;Code[10])
        {
        }
        field(4;"Minimum Instalments";Integer)
        {
        }
        field(5;"Maximum Instalments";Integer)
        {
        }
        field(6;"Interest Rates";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Premium  Financier","Effective Date",Range)
        {
        }
    }

    fieldgroups
    {
    }
}

