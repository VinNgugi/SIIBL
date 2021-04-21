table 51513012 "Premium table Lines"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Policy Type";Code[10])
        {
            TableRelation = "Policy Type";
        }
        field(2;"Seating Capacity";Integer)
        {
            TableRelation = "Vehicle Capacity";
        }
        field(3;Instalments;Integer)
        {
            TableRelation = "No. of Instalments";
        }
        field(4;"Premium Amount";Decimal)
        {
        }
        field(5;"Effective Date";Date)
        {
        }
        field(6;"Vehicle Type";Code[10])
        {
            TableRelation = "Motor Classification";
        }
        field(7;"Vehicle Usage";Code[10])
        {
            TableRelation = "Vehicle Usage";
        }
        field(8;"PPL Cost Per PAX";Decimal)
        {
        }
        field(9;"Currency Code";Code[10])
        {
        }
        field(10;"Premium Rate %";Decimal)
        {
        }
        field(11;Tonnage;Code[10])
        {
            TableRelation = Tonnage;
        }
        field(12;"Premium Table";Code[20])
        {
            TableRelation = "Premium Table";
        }
    }

    keys
    {
        key(Key1;"Premium Table","Seating Capacity",Instalments,"Policy Type")
        {
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    var
        mypremiumtable: Record "Premium Table";

    begin
       IF mypremiumtable.GET("Premium Table") then
       IF mypremiumtable."Policy Type"='' then
       Error('Please select Policy type before inserting premium lines')
       else
       begin
       "Policy Type":=mypremiumtable."Policy Type";
       "Vehicle Usage":=mypremiumtable."Vehicle Usage";
       "Vehicle Type":=mypremiumtable."Vehicle Class";
       end;
    end;
}

