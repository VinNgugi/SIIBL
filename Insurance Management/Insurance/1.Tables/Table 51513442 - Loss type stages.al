table 51513442 "Loss Type stages"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513443;
    LookupPageID = 51513443;

    fields
    {
        field(1; "Loss Type"; Code[20])
        {
            TableRelation = "Loss Type";
        }
        field(2; "Claim Stage"; Code[20])
        {
            TableRelation = "Claim Stage Setup";

            trigger OnValidate();
            begin
                IF Claimstage.GET("Claim Stage") THEN BEGIN
                    "Stage Description" := Claimstage.Description;
                END;
            end;
        }
        field(3; Sequence; Integer)
        {
        }
        field(4; "Stage Description"; Text[30])
        {
        }
        field(5; "SLA Time"; Time)
        {
        }
    }

    keys
    {
        key(Key1; "Loss Type", "Claim Stage")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Claimstage: Record "Claim Stage Setup";
}

