table 51513085 PolicyProposalRisk
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Line No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;CustomerContactType;Option)
        {
            OptionCaption = 'Contact,Customer';
            OptionMembers = Contact,Customer;
        }
        field(3;PolicyProposalNo;Text[30])
        {
        }
        field(4;RiskDatabaseID;Code[10])
        {
            TableRelation = "Risk Database".RiskDatabaseID;
        }
        field(5;"Registration No.";Code[30])
        {
        }
        field(6;"No of Passangers";Integer)
        {
        }
        field(7;PolicyType;Code[10])
        {
            TableRelation = "Policy Type".Code;
        }
        field(8;PolicyTypeName;Text[30])
        {
        }
        field(9;"Estimated Value";Decimal)
        {
        }
        field(10;"Valuers Value";Decimal)
        {
        }
        field(11;RiskTableID;Code[20])
        {
        }
        field(12;NoofInstalments;Integer)
        {
            TableRelation = "No. of Instalments"."No. Of Instalments";
        }
    }

    keys
    {
        key(Key1;"Line No.",PolicyProposalNo)
        {
        }
    }

    fieldgroups
    {
    }
}

