table 51513095 "Claim Witnesses"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Claim No."; Code[20])
        {
        }
        field(2; "Claim Line No."; Integer)
        {
        }
        field(3; Title; Code[10])
        {
            TableRelation = Salutation;
        }
        field(4; Surname; Text[30])
        {
        }
        field(5; "Other Name(s)"; Text[30])
        {
        }
        field(6; "Phone No."; Code[20])
        {
        }
        field(7; Address; Text[250])
        {
        }
        field(8; "Post Code"; Code[10])
        {
        }
        field(9; "Town/City"; Code[10])
        {
        }
        field(10; Passenger; Boolean)
        {
        }
        field(11; "Location during incident"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Claim No.", "Claim Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        Claimants3rdParty.RESET;
        Claimants3rdParty.SETRANGE(Claimants3rdParty."Claim No.", "Claim No.");
        IF Claimants3rdParty.FINDLAST THEN
            "Claim Line No." := Claimants3rdParty."Claim Line No." + 1;
    end;

    var
        Claimants3rdParty: Record "Claim Witnesses";
}

