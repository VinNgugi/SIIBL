table 51513175 "Insured Classification"
{
    Caption = 'Insured Classification';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Insured Type"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    
}
