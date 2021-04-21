table 51513447 "Online AccountTypes"
{
    // version AES-INS 1.0

    LookupPageID = 51513455;

    fields
    {
        field(1;AccountTypeID;Integer)
        {
            AutoIncrement = true;
        }
        field(2;AccountTypeName;Text[30])
        {
        }
        field(3;IsContact;Boolean)
        {
        }
        field(4;IsIntermidiary;Boolean)
        {
        }
        field(5;IsNew;Boolean)
        {
        }
        field(6;"Customer Type";Option)
        {
            OptionCaption = '" ,Insured,Agent/Broker,Re-Insurance Company,Insurer,SACCO,Client,Employer"';
            OptionMembers = " ",Insured,"Agent/Broker","Re-Insurance Company",Insurer,SACCO,Client,Employer;
        }
    }

    keys
    {
        key(Key1;AccountTypeID)
        {
        }
    }

    fieldgroups
    {
    }
}

