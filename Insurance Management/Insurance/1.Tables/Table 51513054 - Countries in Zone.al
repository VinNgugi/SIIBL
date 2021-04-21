table 51513107 "Countries in Zone"
{
    Caption = 'Countries in Zone';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Policy Type"; Code[20])
        {
            Caption = 'Policy Type';
            DataClassification = ToBeClassified;
        }
        field(2; "Underwriter Code"; Code[20])
        {
            Caption = 'Underwriter Code';
            DataClassification = ToBeClassified;
        }
        field(3; "Zone ID"; Code[20])
        {
            Caption = 'Zone ID';
            DataClassification = ToBeClassified;
        }
        field(4; "Country Code"; Code[20])
        {
            Caption = 'Country Code';
            DataClassification = ToBeClassified;
            TableRelation="Country/Region";
            
            trigger OnValidate()
            var
                CountryRec: Record "Country/Region";
            begin
                If CountryRec.GET("Country Code") then
                "Country Name":=CountryRec.Name;
            end;
        }
        field(5; "Country Name"; Text[80])
        {
            Caption = 'Country Name';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Policy Type","Underwriter Code","Zone ID","Country Code")
        {
            Clustered = true;
        }
    }
    
}
