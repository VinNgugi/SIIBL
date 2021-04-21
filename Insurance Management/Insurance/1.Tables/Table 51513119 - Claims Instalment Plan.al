table 51513119 "Claims Instalment Plan"
{
    Caption = 'Claims Instalment Plan';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Underwriter Code"; Code[20])
        {
            Caption = 'Underwriter Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Product Plan"; Code[20])
        {
            Caption = 'Product Plan';
            DataClassification = ToBeClassified;
        }
        field(3; "Benefit Code"; Code[20])
        {
            Caption = 'Benefit Code';
            DataClassification = ToBeClassified;
        }
        field(4; "Instalment No."; Integer)
        {
            Caption = 'Instalment No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = ToBeClassified;
        }
        field(6; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
    
    }
    keys
    {
        key(PK; "Underwriter Code","Product Plan","Benefit Code","Instalment No.")
        {
            Clustered = true;
        }
    }
    
}
