table 51513096 "Loss Type"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513193;
    LookupPageID = 51513193;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Minimum Reserve"; Decimal)
        {
        }
        field(4; "Reserve calculation type"; Option)
        {
            OptionMembers = " ","Flat Amount","Full Value","% of Full Value";
        }
        field(5; Percentage; Decimal)
        {
        }
        field(6; Type; Option)
        {
            OptionCaption = '" ,Accident+Third Party,Theft,Fire,Own Damage"';
            OptionMembers = " ","Accident+Third Party",Theft,Fire,"Own Damage";
        }
        field(7; "Excess Required"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

