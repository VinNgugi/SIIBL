table 51513150 "Product Benefits & Riders"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Product Code"; Code[20])
        {
            //TableRelation = "Policy Type";
        }
        field(2; "Benefit Code"; Code[20])
        {
            TableRelation = "Optional Covers";

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
            OptionCaption = '" ,% age of Sum Assured, Payout Instalment Table,Multiple of the salary ,Agreed Sum,% of Main Benefit,% age of Sum Assured+Bonus Balance"';
            OptionMembers = " ","% age of Sum Assured"," Payout Instalment Table","Multiple of the Salary ","Agreed Sum","% of Main Benefit","% age of Sum Assured+Bonus Balance";
        }
        field(9; "Payout Instalment Table"; Code[20])
        {
        }
        field(10; "Impact on Premium"; Option)
        {
            OptionCaption = '" ,Waive,Continue,Stop"';
            OptionMembers = " ",Waive,Continue,Stop;
        }
        field(11; "Payout %"; Decimal)
        {
        }
        field(12; "Critical Illness"; Boolean)
        {
        }
        field(13; "Subject to Waiting Period"; Boolean)
        {
        }
        field(14; "Benefits Waiting Period"; DateFormula)
        {
        }
        field(15; "Waiting Period table"; Code[20])
        {
        }
        field(16; Multiple; Decimal)
        {
        }
        field(17; "Benefit Type"; Option)
        {
            OptionCaption = ' ,Main,Rider';
            OptionMembers = " ",Main,Rider;
        }
        field(18; "Amount Per Person"; Decimal)
        {
        }
        field(19; "Premium Calculation Method"; Option)
        {
            OptionCaption = ' ,Percentage of Sum Assured,Per Mille of Sum Assured,Age and Term Based,Defined Sum Assured,Unit Rate"';
            OptionMembers = " ","Percentage of Sum Assured","Per Mille of Sum Assured","Age and Term Based","Defined Sum Assured","Unit Rate";

            trigger OnValidate();
            begin
                IF "Premium Calculation Method" = "Premium Calculation Method"::"Percentage of Sum Assured" THEN
                    Denominator := 100;

                IF "Premium Calculation Method" = "Premium Calculation Method"::"Per Mille of Sum Assured" THEN
                    Denominator := 1000;
            end;
        }
        field(20; "Premium Table"; Code[20])
        {
            TableRelation = "Premium Tables";
        }
        field(21; "Premium Rate"; Decimal)
        {
        }
        field(22; Denominator; Decimal)
        {
        }
        field(23; "Premium % Rate"; Decimal)
        {

            trigger OnValidate();
            begin
                IF Denominator <> 0 THEN
                    "Premium Rate" := "Premium % Rate" / Denominator;
            end;
        }
        field(24; "Unit Amount"; Decimal)
        {
        }
        field(25;"Underwriter Code";Code[20])
        {

        }
        field(26;"Product Option Code";Code[20])
        {
            TableRelation="Product Options" where ("Underwriter Code"=field("Underwriter Code"),"Product Code"=field("Product Option Code"));

        }

    }

    keys
    {
        key(Key1; "Product Code","UnderWriter Code", "Benefit Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        RiderRec: Record "Optional Covers";
}

