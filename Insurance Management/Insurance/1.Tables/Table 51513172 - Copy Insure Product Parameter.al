table 51513172 "Copy Insure Product Parameter"
{
    Caption = 'Copy Insure Product Parameter';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "User ID"; Code[80])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
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
            Caption = 'Target Product Code';
            DataClassification = SystemMetadata;
        }
        
    }
    
    keys
    {
        key(PK; "User ID")
        {
            Clustered = true;
        }
    }
    
}
