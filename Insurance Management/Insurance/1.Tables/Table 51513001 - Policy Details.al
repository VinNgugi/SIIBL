table 51513001 "Policy Details"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Policy Type"; Code[10])
        {
            TableRelation = "Policy Type";
        }
        field(2; "Description Type"; Enum PolicyDescriptionType)
        {
            //OptionMembers = " ",Cover,Interest,Deductible,Clauses,Limits,Warranty,"Basis of Settlement",Excess,Geographic,Exclusions;
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
        field(6; Section; Code[20])
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
            OptionCaption = 'Normal,Bold,Underline';
            OptionMembers = Normal,Bold,Underline;
        }
        field(10; "Loss Type"; Code[10])
        {
            TableRelation = "Loss Type";
        }
        field(11; "Underwriter No."; Code[10])
        {
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1; "Policy Type","Underwriter No." ,"Description Type", "No.", "Line No")
        {
        }
    }

    fieldgroups
    {
    }
}

