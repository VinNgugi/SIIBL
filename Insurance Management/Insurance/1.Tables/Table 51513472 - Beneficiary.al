table 51513472 Beneficiary
{
    Caption = 'Beneficiary';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Means if Identification"; Code[20])
        {
            Caption = 'Means if Identification';
            DataClassification = ToBeClassified;
        }
        field(2; ID; Code[20])
        {

        }
        field(3; Name; Text[150])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Relationship to Applicant"; Code[20])
        {
            Caption = 'Relationship to Applicant';
            DataClassification = ToBeClassified;
        }
        field(5; "Date Of Birth"; Date)
        {
            Caption = 'Date Of Birth';
            DataClassification = ToBeClassified;
        }
        field(6; Gender; Enum Gender)
        {
            Caption = 'Gender';
            DataClassification = ToBeClassified;
        }
        field(7; "Percentage Benefit"; Decimal)
        {
            Caption = 'Percentage Benefit';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Means if Identification", ID)
        {
            Clustered = true;
        }
    }

}
