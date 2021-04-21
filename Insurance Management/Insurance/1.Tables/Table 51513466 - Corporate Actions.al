table 51513466 "Corporate Actions"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Institution Code"; Code[20])
        {
            /*TableRelation = "Investment Institutions".Code;

            trigger OnValidate();
            begin
                IF InstRec.GET("Institution Code") THEN
                  Name:=InstRec.Description;
            end;*/
        }
        field(2; Name; Text[50])
        {
            Editable = false;
        }
        field(3; Date; Date)
        {
        }
        field(4; "Transaction Type"; Option)
        {
            OptionCaption = '" ,Share Price,Dividend,Share split,Bonus,Merger,Acquisition,Rights Issue,Spin off"';
            OptionMembers = " ","Share Price",Dividend,"Share split",Bonus,Merger,Acquisition,"Rights Issue","Spin off";
        }
        field(5; Value; Decimal)
        {
        }
        field(6; "Old Ratio"; Decimal)
        {
        }
        field(7; "New Ratio"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Institution Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
    //InstRec : Record "51405311";
}

