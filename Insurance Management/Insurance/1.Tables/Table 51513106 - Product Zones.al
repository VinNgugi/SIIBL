table 51513106 "Product Zones"
{
    Caption = 'Product Zones';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Zone ID"; Code[20])
        {
            Caption = 'Zone ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Underwriter Code"; Code[20])
        {
            Caption = 'Underwriter Code';
            DataClassification = ToBeClassified;
        }
        field(3; "Policy Type"; Code[20])
        {
            Caption = 'Policy Type';
            DataClassification = ToBeClassified;
        }
        field(4; "Zone Name"; Text[30])
        {
            Caption = 'Zone Name';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Zone ID","Underwriter Code","Policy Type")
        {
            Clustered = true;
        }
    }
    
}
