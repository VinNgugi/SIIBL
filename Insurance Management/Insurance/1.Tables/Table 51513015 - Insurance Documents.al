table 51513015 "Insurance Documents"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"Entry No.";Integer)
        {
        }
        field(2;"Document Type";Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement,claim"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement,claim;
        }
        field(3;"Document Name";Text[250])
        {
        }
        field(4;"Document Path";Text[250])
        {
        }
        field(5;"Date Required";Date)
        {
        }
        field(6;"Date Received";Date)
        {
        }
        field(7;"Date Sent";Date)
        {
        }
        field(8;"Source Type";Option)
        {
            OptionMembers = " ",Client,Insurer,Broker;
        }
        field(9;"Source No";Code[10])
        {
        }
        field(10;"Destination Type";Option)
        {
            OptionMembers = " ",Client,Insurer,Broker;
        }
        field(11;"Destination No";Code[10])
        {
        }
        field(12;"Document No";Code[30])
        {
        }
        field(13;"To Address";Text[80])
        {
            Caption = 'To Address';
        }
        field(14;"Copy-to Address";Text[80])
        {
            Caption = 'Copy-to Address';
        }
        field(15;"Subject Line";Text[250])
        {
            Caption = 'Subject Line';
        }
        field(16;"Body Line";Text[250])
        {
            Caption = 'Body Line';
        }
        field(17;"Attachment Filename";Text[80])
        {
            Caption = 'Attachment Filename';
        }
        field(18;"Sending Date";Date)
        {
            Caption = 'Sending Date';
        }
        field(19;"Sending Time";Time)
        {
            Caption = 'Sending Time';
        }
        field(20;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = '" ,Processed,Error"';
            OptionMembers = " ",Processed,Error;
        }
        field(21;Direction;Option)
        {
            OptionMembers = Incoming,Outgoing;
        }
        field(22;Received;Boolean)
        {
        }
        field(23;"Sent/Dispatched";Boolean)
        {
        }
        field(24;Enclosed;Boolean)
        {
        }
        field(25;"To Follow";Boolean)
        {
        }
        field(26;Required;Boolean)
        {
        }
        field(27;"Email Attachments";Boolean)
        {
        }
        field(28;Comment;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No","Document Name")
        {
        }
    }

    fieldgroups
    {
    }
}

