table 51513103 "Commission Types"
{
    Caption = 'Commission Types';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Commission Types List";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
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
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}
