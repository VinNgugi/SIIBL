table 51513164 Beneficiaries
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement;
        }
        field(2;"Document No.";Code[30])
        {
        }
        field(3;"Line No.";Integer)
        {
        }
        field(4;"Beneficiary No";Integer)
        {
        }
        field(5;"Family name";Text[30])
        {
        }
        field(6;"First Name";Text[30])
        {
        }
        field(7;Relationship;Text[30])
        {
        }
        field(8;"Date of Birth";Date)
        {
        }
        field(9;"% share";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.","Beneficiary No")
        {
        }
    }

    fieldgroups
    {
    }
}

