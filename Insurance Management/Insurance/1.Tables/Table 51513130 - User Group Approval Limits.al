table 51513130 "User Group Approval Limits"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "User Group Code"; Code[20])
        {
            TableRelation = "User Group";
        }
        field(2; "Workflow Code"; Code[20])
        {
            TableRelation = Workflow WHERE(Enabled = CONST(true));
        }
        field(3; "Approval Amount Limit"; Decimal)
        {
        }
        field(4; "Rate Discount % Limit"; Decimal)
        {
        }
        field(5; "TPO Premium Discount % Limit"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "User Group Code", "Workflow Code")
        {
        }
    }

    fieldgroups
    {
    }
}

