table 51404200 "Interactions Setup"
{
    // version AES-PAS 1.0

    // C001-RW 300810  : New table created for Complaint Setup

    //DrillDownPageID = 51404813;
    //LookupPageID = 51404813;

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2;"Client Interaction Type Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(3;"Client Interaction Cause Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(4;"Interaction Resolution Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(5;"Client Interaction Header Nos";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(6;"Client Record Change Nos.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7;"Employer Inter. Header Nos.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8;"RM Mapping";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9;"RM Grp Managers";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10;"Employer Record Change Nos.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11;"RM Managers Nos";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(12;"K2 Link";Code[250])
        {
        }
        field(13;"Client Interactions Notifier";Text[250])
        {
        }
        field(14;"Staff interactions Notifier";Text[250])
        {
        }
        field(15;"Management Report Path";Text[250])
        {
        }
        field(16;"BMU Team Email";Text[250])
        {
        }
        field(17;"ABU Status Hours";Integer)
        {
        }
        field(18;"ABU Auto Reminder duration";Integer)
        {
        }
        field(19;"BMU Escalations";Text[250])
        {
        }
        field(20;"BMU Resolution EMail";Text[250])
        {
        }
        field(21;"Quarterly Statement Nos";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(22;"RM Clients Benchmark";Decimal)
        {
        }
        field(23;"Standing Order Nos";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(24;"Standing Order Notification";Integer)
        {
            Caption = 'Standing Order Notification (Days)';
        }
        field(25;"Process Standing Order";Integer)
        {
            Caption = 'Process Standing Order (Days)';
        }
        field(26;"Fund Manager Email";Text[250])
        {
        }
        field(27;"RM Mail Group";Text[50])
        {
        }
        field(28;"Active Security Question";Boolean)
        {
            Caption = 'Activate Security Question Retrieval';
        }
        field(29;"Client IMA Nos";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(30;"Quarterly Statement Path";Text[90])
        {
        }
        field(31;"Fund Operations Email";Text[90])
        {
        }
        field(32;"MTN Linked Fund ID";Code[20])
        {
           // TableRelation = Fund;
        }
        field(33;"MTN Dividend Batch Nos";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(34;"MTN Dividend Template Path";Text[250])
        {
        }
        field(35;"Standalone Benchmark";Decimal)
        {
        }
        field(36;"WM Managers Nos";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(37;"WM Mapping";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(38;"WM Grp Managers";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
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

