table 51511038 "Levy Types"
{
    // version FINANCE

    //LookupPageID = 51511627;

    fields
    {
        field(1; "Levy Code"; Code[30])
        {
        }
        field(2; Description; Text[250])
        {
        }
        field(3; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Transaction Type"; Option)
        {
            OptionCaption = 'Registration Fee,Penalty,Levy,Refund,Arrears';
            OptionMembers = "Registration Fee",Penalty,Levy,Refund,Arrears;
        }
        field(5; IsApplicationFee; Boolean)
        {
        }
        field(6; IsCertificateFee; Boolean)
        {
        }
        field(7; IsPenalty; Boolean)
        {
        }
        field(8; ModuleID; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Levy Code")
        {
        }
    }

    fieldgroups
    {
    }
}

