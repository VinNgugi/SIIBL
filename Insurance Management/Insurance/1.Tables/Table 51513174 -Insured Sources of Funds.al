table 51513174 "Insured Sources of Funds"
{
    Caption = 'Insured Sources of Funds';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Insured No."; Code[20])
        {
            Caption = 'Insured No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Source of Funds"; Code[20])
        {
            Caption = 'Source of Funds';
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
        key(PK; "Insured No.","Source of funds")
        {
            Clustered = true;
        }
    }
    
}
