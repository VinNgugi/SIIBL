table 51513165 "Product Endorsements"
{
    Caption = 'Product Endorsements';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "UnderWriter Code"; Code[20])
        {
            Caption = 'UnderWriter Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Product Code"; Code[20])
        {
            Caption = 'Product Code';
            DataClassification = ToBeClassified;
        }
        field(3; "Endorsement Type"; Code[20])
        {
            Caption = 'Endorserment Type';
            DataClassification = ToBeClassified;
            TableRelation="Endorsement Types";
            trigger OnValidate()
            var
                EndorsementTypeRec: Record "Endorsement Types";
            begin
                If EndorsementTypeRec.GET("Endorsement Type") then
                   "Endorsement Description":=EndorsementTypeRec.Description;

            end;
        }
        field(4; "Endorsement Description"; Text[80])
        {
            Caption = 'Endorsement Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "UnderWriter Code","Product Code","Endorsement Type")
        {
            Clustered = true;
        }
    }
    
}
