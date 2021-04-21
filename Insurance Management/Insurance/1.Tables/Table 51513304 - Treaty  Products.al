table 51513304 "Treaty  Products"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Product Code";Code[30])
        {
            TableRelation = "Product Types";

            trigger OnValidate();
            begin
                    /* IF TreatyVal.GET("Treaty Code","Addendum Code") THEN BEGIN
                     IF TreatyVal.Blocked =TRUE THEN
                    ERROR('This treaty cannot be modified, it is blocked');
                    END;
                    */
                    IF Blocked =TRUE THEN
                    ERROR('This treaty cannot be modified, it is blocked');

            end;
        }
        field(2;"Treaty Code";Code[30])
        {
            TableRelation = "LIFE Treaty";
        }
        field(3;"Product Decription";Text[30])
        {
        }
        field(4;Rider;Boolean)
        {
        }
        field(5;"Addendum Code";Integer)
        {
        }
        field(6;Blocked;Boolean)
        {
        }
        field(7;"Quota Share";Boolean)
        {
        }
        field(8;Surplus;Boolean)
        {
        }
        field(9;Facultative;Boolean)
        {
        }
        field(10;"Exess of loss";Boolean)
        {
        }
        field(11;"Quota share Retention";Decimal)
        {
        }
        field(12;"Surplus Retention";Decimal)
        {
        }
        field(13;"Cedant quota percentage";Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                /*QuotaTotalPercent:=0;
                
                //Quota Share.
                
                
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Qouta Share",TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                QuotaTotalPercent:=QuotaTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF "Cedant quota percentage"+QuotaTotalPercent>100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                */

            end;
        }
    }

    keys
    {
        key(Key1;"Product Code","Treaty Code",Rider,"Addendum Code")
        {
        }
    }

    fieldgroups
    {
    }
}

