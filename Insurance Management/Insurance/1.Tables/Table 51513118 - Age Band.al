table 51513118 "Age Band"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Age Band"; Code[10])
        {
        }
        field(2; "Minimum Age"; Integer)
        {
        }
        field(3; "Maximum Age"; Integer)
        {
        }
        field(4; "Applicable to"; Option)
        {
            OptionMembers = "New & Renewal",Renewal;
        }
        field(5; "Excess Filter"; Code[10])
        {
            //FieldClass = FlowFilter;
            //TableRelation = Excess;
        }
        field(6; "Effective Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(7; "Policy Type Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Policy Type";
        }
        field(8; "Insurance Type Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Insurance Types".Code WHERE("Policy Type" = FIELD("Policy Type Filter"));
        }
        field(9; "Area Of Cover Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Area of Coverage"."Area Code";
        }
        field(10; "Premium Amount"; Decimal)
        {
            CalcFormula = Sum("Premium Table Entry"."Premium Amount" WHERE("Age Band" = FIELD("Age Band"),
                                                                        "Cover Selected" = FIELD("Insurance Type Filter"),
                                                                        "Policy Type" = FIELD("Policy Type Filter"),
                                                                        "Area of Cover" = FIELD("Area Of Cover Filter"),
                                                                        Excess = FIELD("Excess Filter"),
                                                                        "Effective Start Date" = FIELD("Effective Date Filter"),
                                                                        "Premium Currency" = FIELD("Currency Filter")));//"Premium Payment" = FIELD("Premium Payment Filter"),
            FieldClass = FlowField;
        }
        field(11; "Premium Payment Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payment Terms";
        }
        field(12; "Currency Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1; "Age Band")
        {
        }
    }

    fieldgroups
    {
    }
}

