table 51511043 "Staff PGroups"
{
    // version FINANCE


    fields
    {
        field(1; "Posting Group"; Code[10])
        {
            TableRelation = "Staff Posting Group";
        }
        field(2; "Code"; Code[10])
        {
            //TableRelation = IF (Type=CONST(Earning)) Earnings
            //               ELSE IF (Type=CONST(Deduction)) Deductions;

            trigger OnValidate()
            begin
                /*IF Type=Type::Earning THEN
                BEGIN
                IF EarningRec.GET(Code) THEN
                BEGIN
                Description:=EarningRec.Description;
                END;
                END;

                IF Type=Type::Deduction THEN
                BEGIN
                IF Deduction.GET(Code) THEN
                BEGIN
                Description:=Deduction.Description;
                END;
                END;*/
            end;
        }
        field(3; "G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(4; Description; Text[30])
        {
        }
        field(5; Type; Option)
        {
            OptionMembers = Earning,Deduction;
        }
        field(6; "GL Account Employer"; Code[10])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Posting Group", "Code", Type)
        {
        }
    }

    fieldgroups
    {
    }

    var
    //EarningRec: Record "Earnings";
    //Deduction: Record "51511109";
}

