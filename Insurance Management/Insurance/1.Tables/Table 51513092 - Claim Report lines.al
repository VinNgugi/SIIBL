table 51513092 "Claim Report lines"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Claim Report No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = false;
        }
        field(3; Description; Text[250])
        {
        }
        field(4; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(5; Quantity; Decimal)
        {

            trigger OnValidate();
            begin
                "Estimated Value" := Quantity * "Unit Price";
            end;
        }
        field(6; "Unit Price"; Decimal)
        {

            trigger OnValidate();
            begin
                "Estimated Value" := Quantity * "Unit Price";
            end;
        }
        field(7; "Estimated Value"; Decimal)
        {
        }
        field(8; "Claim No."; Code[20])
        {
        }
        field(9; "Claim Amount"; Decimal)
        {
        }
        field(10; "Agreed Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Claim Report No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ClaimReportLines: Record "Claim Report lines";
}

