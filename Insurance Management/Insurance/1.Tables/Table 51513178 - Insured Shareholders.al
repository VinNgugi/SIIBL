table 51513178 "Insured Shareholders"
{
    Caption = 'Insured Shareholders';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Insured No."; Code[20])
        {
            Caption = 'Insured No.';
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[80])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Shareholder % "; Decimal)
        {
            Caption = 'Shareholder % ';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Insured No.",Name)
        {
            Clustered = true;
        }
    }
    
}
