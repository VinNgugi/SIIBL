table 51513177 "Insured PEP Status"
{
    Caption = 'Insured PEP Status';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Insured No."; Code[20])
        {
            Caption = 'Insured No.';
            DataClassification = ToBeClassified;
        }
        field(2; Relationship; Code[20])
        {
            Caption = 'Relationship';
            DataClassification = ToBeClassified;
        }
        field(3; "PEP Status"; Option)
        {
            Caption = 'PEP Status';
#pragma warning disable AL0107
#pragma warning disable AL0153
            OptionMembers="No","Yes";
#pragma warning restore AL0153
#pragma warning restore AL0107
        }
    }
    keys
    {
        key(PK; "Insured No.",Relationship)
        {
            Clustered = true;
        }
    }
    
}
