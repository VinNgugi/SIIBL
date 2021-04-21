table 51513003 "Insurer Policy Details"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Policy Type"; Code[20])
        {
            TableRelation = "Underwriter Policy Types".Code;
        }
        field(2; "Description Type"; Option)
        {
            OptionMembers = " ",Cover,Interest,Deductible,Clauses,Limits,Warranty,"Basis of Settlement",Excess,Geographic;
        }
        field(3; "No."; Code[10])
        {
        }
        field(4; "Line No"; Integer)
        {
        }
        field(5; Description; Text[90])
        {
        }
        field(6; Insurer; Code[10])
        {
        }
        field(7; "Actual Value"; Text[60])
        {
        }
        field(8; Value; Decimal)
        {
        }
        field(9; "Text Type"; Option)
        {
            OptionMembers = Normal,Bold,Underline;
        }
    }

    keys
    {
        key(Key1; "Policy Type",Insurer,"Description Type","Line No")
        {
        }
    }

    fieldgroups
    {
    }
}

