table 51404205 "Client Interaction Line"
{
    // version AES-PAS 1.0


    fields
    {
        field(10;"Client Interaction No.";Code[20])
        {
        }
        field(20;"Line No.";Integer)
        {
        }
        field(30;"Line Type";Option)
        {
            OptionMembers = Manual,System;
        }
        field(40;"Action Type";Option)
        {
            OptionMembers = Logged,Assigned,Escalated,"Response Out","Reply In",Comment,Resolution,Closed;
        }
        field(50;"User ID-";Code[30])
        {
        }
        field(60;"Date and Time";DateTime)
        {
        }
        field(70;Description;Text[250])
        {
        }
        field(71;"Expiration Time";DateTime)
        {
        }
    }

    keys
    {
        key(Key1;"Client Interaction No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

