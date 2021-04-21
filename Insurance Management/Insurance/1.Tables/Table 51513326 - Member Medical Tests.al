table 51513326 "Member Medical Tests"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Policy Code"; Code[30])
        {
            TableRelation = "LF Grp Scheme Members"."Policy Code";
        }
        field(2; "Member No"; Code[30])
        {
            TableRelation = "LF Grp Scheme Members"."Member No";
        }
        field(3; "Treaty Code"; Code[30])
        {
            TableRelation = "LF Grp Scheme Members"."Treaty Code";
        }
        field(4; "Addendum Code"; Integer)
        {
            TableRelation = "LF Grp Scheme Members"."Addendum Code";
        }
        field(5; "Product Code"; Code[30])
        {
            TableRelation = "LF Grp Scheme Members"."Product Code";
        }
        field(6; "Lot No."; Code[10])
        {
            TableRelation = "LF Grp Scheme Members"."Lot No.";
        }
        field(7; Cedant; Code[30])
        {
            TableRelation = "LF Grp Scheme Members".Cedant;
        }
        field(8; "Inception Date"; Date)
        {
            TableRelation = "LF Grp Scheme Members"."Inception Date";
        }
        field(9; "Test Code"; Code[30])
        {
            TableRelation = "Medical Tests"."Treaty Code";
        }
        field(10; Complied; Boolean)
        {

            trigger OnValidate();
            begin
                MODIFY;

                MemberMedicalTests.RESET;
                MemberMedicalTests.SETRANGE(MemberMedicalTests."Policy Code", "Policy Code");
                MemberMedicalTests.SETRANGE(MemberMedicalTests."Member No", "Member No");
                MemberMedicalTests.SETRANGE(MemberMedicalTests."Treaty Code", "Treaty Code");
                MemberMedicalTests.SETRANGE(MemberMedicalTests."Addendum Code", "Addendum Code");
                MemberMedicalTests.SETRANGE(MemberMedicalTests."Product Code", "Product Code");
                MemberMedicalTests.SETRANGE(MemberMedicalTests."Lot No.", "Lot No.");
                MemberMedicalTests.SETRANGE(MemberMedicalTests.Cedant, Cedant);
                MemberMedicalTests.SETRANGE(MemberMedicalTests."Inception Date", "Inception Date");
                MemberMedicalTests.SETRANGE(MemberMedicalTests.Complied, FALSE);


                IF MemberMedicalTests.FINDFIRST = TRUE THEN BEGIN
                    // Policy Code,Cedant,Lot No.,Product Code,Treaty Code,Addendum Code,Member No,Inception Date
                    IF GroupMembers.GET("Policy Code", Cedant, "Lot No.", "Product Code", "Treaty Code", "Addendum Code", "Member No",
                     "Inception Date") THEN BEGIN
                        GroupMembers."Medical Compliant" := FALSE;
                        GroupMembers.MODIFY;
                    END;

                END ELSE BEGIN
                    // IF   GroupMembers.GET("Policy Code","Member No","Treaty Code","Addendum Code","Product Code","Lot No.",Cedant) THEN  BEGIN
                    IF GroupMembers.GET("Policy Code", Cedant, "Lot No.", "Product Code", "Treaty Code", "Addendum Code", "Member No",
                    "Inception Date") THEN BEGIN


                        GroupMembers."Medical Compliant" := TRUE;
                        GroupMembers.MODIFY;

                    END;

                END;
            end;
        }
        field(11; "Date Done"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Policy Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GroupMembers: Record "LF Grp Scheme Members";
        MemberMedicalTests: Record "Member Medical Tests";
}

