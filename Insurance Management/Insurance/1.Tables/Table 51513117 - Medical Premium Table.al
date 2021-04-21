table 51513117 "Medical Premium Table"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Effective Start Date"; Date)
        {
            NotBlank = true;
        }
        field(2; "Age Band"; Code[10])
        {
            NotBlank = true;
            TableRelation = "Age Group";

            trigger OnValidate();
            begin
                IF AgeBand.GET("Age Band") THEN BEGIN
                    "Minimum Age" := AgeBand."Minimum Age";
                    "Maximum Age" := AgeBand."Maximum Age";
                END;
            end;
        }
        field(3; "Cover Selected"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Insurance Types";
        }
        field(4; "Area of Cover"; Code[10])
        {
            NotBlank = true;
            TableRelation = "Area of Coverage"."Area Code";
        }
        field(5; Excess; Code[10])
        {
            NotBlank = true;
            //TableRelation = Excess;
        }
        field(6; "Premium Amount"; Decimal)
        {
        }
        field(7; "Premium Currency"; Code[10])
        {
            TableRelation = Currency;
        }
        field(8; "Policy Type"; Code[10])
        {
            TableRelation = "Policy Type";
        }
        field(9; "Minimum Age"; Integer)
        {
        }
        field(10; "Maximum Age"; Integer)
        {
        }
        field(11; "Premium Payment"; Code[10])
        {
            TableRelation = "Payment Terms";
        }
        field(12; "Entry No"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Effective Start Date")
        {
        }
    }

    fieldgroups
    {
    }
    var
        AgeBand: Record "Age Band";
}

