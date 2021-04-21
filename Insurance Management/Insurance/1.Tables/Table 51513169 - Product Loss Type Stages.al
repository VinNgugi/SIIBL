table 51513169 "Product Loss Type Stages"
{
    Caption = 'Product Loss Type Stages';
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
        field(3; "Loss Type Code"; Code[20])
        {
            Caption = 'Loss Type Code';
            DataClassification = ToBeClassified;
        }
        field(4; Stage; Code[20])
        {
            Caption = 'Stage';
            DataClassification = ToBeClassified;
        }
        field(5; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(6; Priority; Integer)
        {
            Caption = 'Priority';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Underwriter Code","Product Code","Loss Type Code",Stage)
        {
            Clustered = true;
        }
    }
    
}
