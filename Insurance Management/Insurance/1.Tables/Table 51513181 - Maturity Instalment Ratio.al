table 51513181 "Maturity Instalment Ratio"
{
    
    // version AES-INS 1.0


    fields
    {
        field(1;"No. Of Instalments";Integer)
        {
            TableRelation = "No. of Instalments"."No. Of Instalments";
        }
        field(2;"Instalment No";Integer)
        {
        }
        field(3;Percentage;Decimal)
        {
        }
        field(4;"Policy Type";Code[20])
        {
            //TableRelation = "Policy Type";
        }
        field(5;"Period Length";DateFormula)
        {
        }
        field(6;"Underwriter code";Code[20])
        {
            
        }
    }

    keys
    {
        key(Key1;"Policy Type","No. Of Instalments","Instalment No")
        {
        }
    }

    fieldgroups
    {
    }
}
