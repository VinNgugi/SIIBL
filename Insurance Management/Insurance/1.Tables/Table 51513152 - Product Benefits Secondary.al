table 51513152 "Product Benefits Secondary"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Product Code"; Code[20])
        {
            TableRelation = "Policy Type";
        }
        field(2; "Benefit Code"; Code[20])
        {
            TableRelation = "Life Benefits";

            trigger OnValidate();
            begin
                IF RiderRec.GET("Benefit Code") THEN
                    "Benefit Name" := RiderRec.Description;
            end;
        }
        field(3; "Benefit Name"; Text[50])
        {
        }
        field(4; "Number of Payouts"; Integer)
        {
        }
        field(5; "Payout Interval"; DateFormula)
        {
        }
        field(6; "Payout Start Period"; DateFormula)
        {
        }
        field(7; "Payout Type"; Option)
        {
            OptionCaption = '" ,Full,Partial+Maturity,Partial"';
            OptionMembers = " ",Full,"Partial+Maturity",Partial;
        }
        field(8; "Payout Calculation"; Option)
        {
            OptionCaption = '" ,% age of Sum Assured, Payout Instalment Table"';
            OptionMembers = " ","% age of Sum Assured"," Payout Instalment Table";
        }
        field(9; "Payout Instalment Table"; Code[20])
        {
        }
        field(10; "Secondary Code"; Code[20])
        {
            TableRelation = "Life Benefits" WHERE("Benefit Type"=CONST(Rider));

            trigger OnValidate();
            begin
                IF RiderRec.GET("Secondary Code") THEN
                    "Secondary Name" := RiderRec.Description;
            end;
        }
        field(11; "Secondary Name"; Text[50])
        {
        }
        field(12; "Impact on Premium"; Option)
        {
            OptionCaption = '" ,Waive,Continue,Stop"';
            OptionMembers = " ",Waive,Continue,Stop;
        }
        field(13; "%"; Decimal)
        {
        }
        field(14; "Critical Illness"; Boolean)
        {
        }
        field(15; "Subject to Waiting Period"; Boolean)
        {
        }
        field(16; "Benefits Waiting Period"; DateFormula)
        {
        }
        field(17; "Waiting Period table"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Product Code", "Benefit Code", "Secondary Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        RiderRec: Record "Life Benefits";
}

