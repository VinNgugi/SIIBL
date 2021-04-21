table 51513056 "Exclusion per Claim"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Claim No.";Code[20])
        {
        }
        field(2;"Line No.";Integer)
        {
        }
        field(3;Reason;Code[20])
        {
            NotBlank = false;

            trigger OnValidate();
            begin
                /*IF Reasoncodes.GET(Reason) THEN
                BEGIN
                Description:=Reasoncodes."Exclusion No";
                Exclusions.RESET;
                Exclusions.SETRANGE(Exclusions."Exclusion No",Reason);
                IF Exclusions.FIND('-') THEN
                BEGIN
                REPEAT
                
                
                ExclusionPerClaim.INIT;
                ExclusionPerClaim."Claim No.":="Claim No.";
                ExclusionPerClaim.Reason:=Reason;
                ExclusionPerClaim."Line No.":=Exclusions."Line No";
                ExclusionPerClaim.Description:=Exclusions.Description;
                
                IF NOT ExclusionPerClaim.GET(ExclusionPerClaim."Claim No.",ExclusionPerClaim.Reason,
                ExclusionPerClaim."Line No.") THEN
                ExclusionPerClaim.INSERT;
                
                UNTIL Exclusions.NEXT=0;
                END;
                END;*/

            end;
        }
        field(4;Description;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Claim No.")
        {
        }
    }

    fieldgroups
    {
    }
}

