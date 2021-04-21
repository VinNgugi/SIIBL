table 51513171 "Copy Insurance Product Buffer"
{
    Caption = 'Copy Insurance Product Buffer';
    DataClassification = ToBeClassified;
    fields{

    field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Source Insurer No."; Code[20])
        {
            Caption = 'Source Insurer No.';
            TableRelation = "Underwriter Policy Types"."Underwriter Code";
            DataClassification = SystemMetadata;
        }
        field(3; "Target Insurer No."; Code[20])
        {
            Caption = 'Target Insurer No.';
            DataClassification = SystemMetadata;
        }

        field(4; "Source Product Code"; Code[20])
        {
            Caption = 'Source Product Code';
            DataClassification = SystemMetadata;
        }



        field(5; "Target Product Code"; Code[20])
        {
            Caption = 'Target No. Series';
            DataClassification = SystemMetadata;
        }
        
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
    }
    


