table 51513132 Warrants
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Case No.";Code[50])
        {
        }
        field(2;"Warrant No.";Code[10])
        {
        }
        field(3;"Warrant Type";Option)
        {
            OptionCaption = '" ,Primary,Declaratory"';
            OptionMembers = " ",Primary,Declaratory;
        }
        field(4;"Date of Service";Date)
        {
        }
        field(5;"Person receiving";Text[30])
        {
        }
        field(6;"Date Forwarded";Date)
        {
        }
        field(7;"Receiving Officer";Text[30])
        {
        }
        field(8;Remarks;Text[250])
        {
        }
        field(9;"Decretal Sum";Decimal)
        {
        }
        field(10;"Taxed Cost";Decimal)
        {
        }
        field(11;Interest;Decimal)
        {
        }
        field(12;"Further Court Fees";Decimal)
        {
        }
        field(13;"Court Collection Charges";Decimal)
        {
        }
        field(14;Total;Decimal)
        {
        }
        field(16;Auctioneer;Text[30])
        {
        }
        field(17;"Auctioneer Invoice No.";Code[20])
        {
        }
        field(18;"Auctioneer Amount";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Case No.")
        {
        }
    }

    fieldgroups
    {
    }
}

