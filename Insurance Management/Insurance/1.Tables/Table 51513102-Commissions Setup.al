table 51513102 "Commissions Setup"

{

    Caption = 'Agent Commission Setup';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; Underwriter; Code[20])
        {
            Tablerelation = Vendor;
        }
        field(2; "Policy Type"; Code[20])
        {
            Tablerelation = "Underwriter Policy Types" where("Underwriter code" = FIELD(Underwriter));
        }
        field(3; "Commission Type"; Code[20])
        {
            TableRelation = "Commission Types".Code;
        }
        field(4; "% age"; Decimal)
        {

        }
        Field(5; "Fixed Amount"; Decimal)
        {

        }
        field(6; "Target Premium"; Decimal)
        {

        }
        field(7; "Agent Code"; Code[20])
        {

        }
        field(8; "Commission Calculation Type"; Enum "Commission Calculation Method")
        {

        }
        field(9; "Endorsement Types"; Code[20])
        {
            TableRelation = "Endorsement Types";
        }
        field(10; "Target Period"; DateFormula)
        {

        }

    }

    keys
    {
        key(PK; Underwriter, "Policy Type", "Commission Type", "Agent Code")
        {
            Clustered = true;
        }
    }
}