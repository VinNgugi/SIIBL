table 51513455 "Cheque Register"
{

    fields
    {
        field(1;PVNo;Code[20])
        {
        }
        field(2;"Cheque No.";Code[20])
        {
        }
        field(3;"Cheque Printing Date";Date)
        {
        }
        field(4;"Notification Alert Date";Date)
        {
        }
        field(5;Payee;Text[80])
        {
        }
        field(6;"Date Collected";Date)
        {
        }
        field(7;"Name of Collector";Text[30])
        {
        }
        field(8;Status;Option)
        {
            OptionMembers = " ",Collected,"Not Collected",Cancelled;
        }
    }

    keys
    {
        key(Key1;PVNo)
        {
        }
    }

    fieldgroups
    {
    }
}

