table 51513168 "Product Age Range"
{
    Caption = 'Product Age Range';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; Prod_Code; Code[20])
        {
            Caption = 'Prod_Code';
            DataClassification = ToBeClassified;
        }
        field(2; UnderWriter; Code[20])
        {
            Caption = 'UnderWriter';
            DataClassification = ToBeClassified;
        }
        field(3; "Relationship Code"; Code[20])
        {
            Caption = 'Relationship Code';
            DataClassification = ToBeClassified;
            TableRelation=Relationship;
        }
        field(4; "Min Age"; Integer)
        {
            Caption = 'Min Age';
            DataClassification = ToBeClassified;
        }
        field(5; "Max Age"; Integer)
        {
            Caption = 'Max Age';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Prod_Code,UnderWriter,"Relationship Code")
        {
            Clustered = true;
        }
    }
    
}
