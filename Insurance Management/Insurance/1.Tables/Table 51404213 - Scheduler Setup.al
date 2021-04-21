table 51404213 "Scheduler Setup"
{
    // version Scheduler

    Caption = 'Scheduler Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2;"Schedule Group Nos.";Code[10])
        {
            Caption = 'Schedule Group Nos.';
            TableRelation = "No. Series";
        }
        field(3;"Send E-Mail Alerts";Boolean)
        {
            Caption = 'Send E-Mail Alerts';
        }
        field(4;"Primary E-Mail";Text[80])
        {
            Caption = 'Primary E-Mail';
        }
        field(5;"Secondary E-Mail";Text[80])
        {
            Caption = 'Secondary E-Mail';
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

