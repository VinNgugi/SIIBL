table 51513026 "Risk Database"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513018;
    LookupPageID = 51513018;

    fields
    {
        field(1; RiskDatabaseID; Code[20])
        {
        }
        field(2; Make; Code[10])
        {
            TableRelation = "Car Makers";
        }
        field(3; Model; Code[10])
        {
            TableRelation = "Car Models".Model WHERE("Car Maker" = FIELD(Make));
        }
        field(4; "Engine No."; Code[20])
        {
        }
        field(5; "Chassis No."; Code[20])
        {
        }
        field(6; Colour; Code[10])
        {
            TableRelation = "Vehicle Colour";
        }
        field(7; "Body Type"; Code[10])
        {
            TableRelation = "Vehicle Body Type";
        }
        field(8; Usage; Code[10])
        {
            TableRelation = "Vehicle Usage";
        }
        field(9; Trailer; Boolean)
        {
        }
        field(10; "Associated Vehicle"; Code[20])
        {
            TableRelation = IF (Trailer = CONST(true)) "Risk Database".RiskDatabaseID;
        }
        field(11; "License Class"; Code[10])
        {
            TableRelation = "Motor Classification";
        }
        field(12; Tonnage; Code[10])
        {
            TableRelation = Tonnage;
        }
        field(13; "Year of Manufacture"; Integer)
        {
        }
        field(16; Route; Code[20])
        {
            TableRelation = "Vehicle Routes";
        }
        field(17; "Route Description"; Text[30])
        {
        }
        field(18; Valuation; Decimal)
        {
        }
        field(19; "Cubic Centimeter"; Integer)
        {
        }
        field(20; "Registration No."; Code[30])
        {
        }
        field(21; "No of Passengers"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; RiskDatabaseID)
        {
        }
    }

    fieldgroups
    {
    }
}

