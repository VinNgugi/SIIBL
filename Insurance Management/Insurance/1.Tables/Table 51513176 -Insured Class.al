table 51513176 "Insured Class"
{
    Caption = 'Insured Class';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Insured No."; Code[20])
        {
            Caption = 'Insured No.';
            DataClassification = ToBeClassified;
        }
        field(2; Class; Code[20])
        {
            Caption = 'Class';
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Insured No.",Class)
        {
            Clustered = true;
        }
    }
    
}
