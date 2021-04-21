table 51404210 "Interactions Sub Channel"
{
    // DrillDownPageID = 51404244;
    // LookupPageID = 51404244;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Channel Code"; Code[20])
        {
            TableRelation = "Interaction Channel";
        }
        field(4; "Total Number of Interactions"; Integer)
        {
            CalcFormula = Count("Client Interaction Header" WHERE("Channel Sub Type" = FIELD(Code),
                                                                   "Date of Interaction" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(5; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(6; "Total Employer Interactions"; Integer)
        {
            // CalcFormula = Count("Employer Interaction Header" WHERE ("Channel Sub Type"=FIELD(Code)));
            //FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code", "Channel Code")
        {
        }
    }

    fieldgroups
    {
    }
}

