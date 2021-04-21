table 51513457 "IBNR Lines"
{
    // version AES-INS 1.0


    fields
    {
        field(1; Class; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(2; "Year No."; Integer)
        {
        }
        field(3; "Year Look Up"; Integer)
        {
        }
        field(4; "% Age"; Decimal)
        {
        }
        field(5; "Period Comparison"; DateFormula)
        {
        }
        field(6; "Sub Class"; Code[10])
        {
            TableRelation = "Policy Type";

            trigger OnValidate();
            begin
                IF PolicyType.GET("Sub Class") THEN BEGIN

                    Class := PolicyType.Class;

                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Sub Class", "Year No.", "Year Look Up")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PolicyType: Record "Policy Type";
}

