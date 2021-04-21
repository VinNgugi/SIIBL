table 51513170 "Product Options"
{
    Caption = 'Product Options';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Underwriter Code"; Code[20])
        {
            Caption = 'Underwriter Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Product Code"; Code[20])
        {
            Caption = 'Product Code';
            DataClassification = ToBeClassified;
        }
        field(3; "Product Option"; Code[20])
        {
            Caption = 'Product Option';
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Underwriter Code","Product Code","Product Option")
        {
            Clustered = true;
        }
    }
    
}
