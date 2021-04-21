table 51513101 "Policy Type Template"
{
    Caption = 'Policy Type Template';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Underwriter; Code[20])
        {
            Caption = 'Underwriter';
            DataClassification = ToBeClassified;
        }
        field(2; "Policy Type"; Code[20])
        {
            Caption = 'Policy Type';
            DataClassification = ToBeClassified;
        }
        field(3; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table));

            DataClassification = ToBeClassified;
        }
        field(4; "Field No."; Integer)
        {

            Caption = 'Field No.';
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table No."));

            DataClassification = ToBeClassified;
        }
        field(5; "Table Name"; Text[80])
        {
            Caption = 'Table Name';
            DataClassification = ToBeClassified;
        }
        field(6; "Field Name"; Text[80])
        {
            Caption = 'Field Name';
            fieldclass = Flowfield;
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("Table No."), "No." = FIELD("Field No.")));

        }
        field(7; "Column Order"; Integer)
        {
            Caption = 'Column Order';

        }
    }
    keys
    {
        key(PK; Underwriter, "Policy Type", "Table No.", "Field No.", "Table Name")
        {
            Clustered = true;
        }
        Key(Key2; "Column Order")
        {

        }

    }

}
