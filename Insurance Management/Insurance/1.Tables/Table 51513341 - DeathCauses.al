table 51513341 "Death Causes"
{
    Caption = 'Death Causes';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Death Code"; Code[20])
        {
            Caption = 'Death Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Death Code")
        {
            Clustered = true;
        }
    }

}
