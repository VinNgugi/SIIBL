table 51513446 "Online Profiles"
{
    // version AES-INS 1.0


    fields
    {
        field(1;ProfileID;Integer)
        {
            AutoIncrement = true;
        }
        field(2;AccountTypeID;Integer)
        {
            TableRelation = "Online AccountTypes".AccountTypeID;
        }
        field(3;CustomerID;Code[20])
        {
        }
        field(4;Name;Text[250])
        {
        }
        field(5;IDNumber;Text[250])
        {
        }
        field(6;UserName;Text[250])
        {
        }
        field(7;Password;Text[250])
        {
        }
        field(8;Status;Integer)
        {
        }
        field(9;Locked;Boolean)
        {
        }
        field(10;FailedAttempts;Integer)
        {
        }
        field(11;PasswordReset;Integer)
        {
        }
        field(12;CreatedDate;DateTime)
        {
        }
        field(13;ReferenceNo;Code[10])
        {
        }
        field(14;Salt;Text[128])
        {
        }
    }

    keys
    {
        key(Key1;ProfileID)
        {
        }
    }

    fieldgroups
    {
    }
}

