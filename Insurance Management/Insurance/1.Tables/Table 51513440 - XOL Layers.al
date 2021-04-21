table 51513440 "XOL Layers"
{

    fields
    {
        field(1; Layer; Code[20])
        {
            TableRelation = "Cover Layer";
        }
        field(2; Cover; Decimal)
        {
        }
        field(3; Deductible; Decimal)
        {

            trigger OnValidate();
            begin

                "Line Total" := Deductible + Cover;
            end;
        }
        field(4; Reinstatement; Decimal)
        {
        }
        field(5; "Min. Rate"; Decimal)
        {
            DecimalPlaces = 2 : 4;
        }
        field(6; "Max. Rate"; Decimal)
        {
            DecimalPlaces = 2 : 4;
        }
        field(7; "Minimum Deposit Premium"; Decimal)
        {

            trigger OnValidate();
            begin
                IF Cover <> 0 THEN
                    ROL := ("Minimum Deposit Premium" / Cover) * 100;
            end;
        }
        field(8; Earnings; Decimal)
        {
        }
        field(9; ROL; Decimal)
        {
        }
        field(10; GNPI; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = FILTER(Premium | "Reinsurance Premium"),
                                                        "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(11; "Treaty Code"; Code[30])
        {
            TableRelation = Treaty."Treaty Code";
        }
        field(12; "Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code";
        }
        field(13; "Line Total"; Decimal)
        {
        }
        field(14; "Claim Chargeable"; Decimal)
        {
            CalcFormula = Sum("Coinsurance Reinsurance Lines"."Claims Payment Amount" WHERE(TreatyLineID = FIELD(Layer)));
            FieldClass = FlowField;
        }
        field(15; "Reinstatement Premium"; Decimal)
        {
        }
        field(16; "No. of Reinstatements"; Integer)
        {
        }
        field(17; "Deposit Premium Paid"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Insurance Trans Type" = CONST("Deposit Premium"),
                                                                         "Lot No" = FIELD(Layer),
                                                                         "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(18; "Accrued Monthly Premium"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Insurance Trans Type" = CONST("Accrued Reinsurance Premium"),
                                                                         "Lot No" = FIELD(Layer),
                                                                         "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(19; "Total Gross Premium Income"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = CONST(Premium),
                                                        "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(20; "Premium Ceded Proportional"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = CONST("Reinsurance Premium"),
                                                        "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(22; "Applied Adjustment Method"; Option)
        {
            OptionMembers = " ","Burning Cost","Fixed Rate";
        }
        field(23; "Applied Adjustment Rate"; Decimal)
        {
        }
        field(24; "Actual Annual Premium"; Decimal)
        {
        }
        field(25; "Adjustment Due"; Decimal)
        {
        }
        field(26; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(27; "Burning Cost Loading"; Decimal)
        {
        }
        field(28; "Premium Calculation Method"; Option)
        {
            OptionCaption = '" ,Fixed Amount,Fixed Premium Rate,variable Premium Rate"';
            OptionMembers = " ","Fixed Amount","Fixed Premium Rate","variable Premium Rate";
        }
        field(29; "Reinstatement Premium Method"; Option)
        {
            OptionCaption = '" ,Pro-rata temporis,Pro-rata capita"';
            OptionMembers = " ","Pro-rata temporis","Pro-rata capita";
        }
        field(30; "Annual Aggregate Limit"; Decimal)
        {
        }
        field(31; "XL Paid Losses"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Treaty Code" = FIELD("Treaty Code"),
                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                        "Lot No" = FIELD(Layer),
                                                        "Insurance Trans Type" = CONST("Reinsurance Claim Reserve"),
                                                        "Document Type" = CONST(Payment)));
            FieldClass = FlowField;
        }
        field(32; "XL Outstanding Claims"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Treaty Code" = FIELD("Treaty Code"),
                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                        "Lot No" = FIELD(Layer),
                                                        "Insurance Trans Type" = CONST("Reinsurance Claim Reserve")));
            FieldClass = FlowField;
        }
        field(33; "Ceded Premium"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = CONST("Reinsurance Premium"),
                                                        "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(34; "Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "Accounting Period"."Starting Date";
        }
    }

    keys
    {
        key(Key1; "Treaty Code", "Addendum Code", Layer)
        {
        }
    }

    fieldgroups
    {
    }
}

