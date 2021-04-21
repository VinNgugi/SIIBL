table 51513114 PSV_SMS
{
    // version AES-INS 1.0


    fields
    {
        field(1;SmsID;Integer)
        {
        }
        field(2;V_phone;Code[20])
        {
        }
        field(3;V_message;Text[250])
        {
        }
        field(4;V_response;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;SmsID)
        {
        }
    }

    fieldgroups
    {
    }
}

