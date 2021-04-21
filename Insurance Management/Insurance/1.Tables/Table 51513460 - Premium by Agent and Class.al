table 51513460 "Premium by Agent and Class"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Customer Code"; Code[20])
        {
            TableRelation = Customer;
        }
        field(2; "Class Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(3));

            trigger OnValidate();
            begin
                IF GSetup.GET THEN
                    IF PolicyType.GET(GSetup."Shortcut Dimension 3 Code", "Class Code") THEN BEGIN

                        Description := PolicyType.Name;


                    END;
            end;
        }
        field(3; "Premium Written"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No."=FIELD("Customer Code"),
                                                                         "Shortcut Dimension 3 Code"=FIELD("Class Code"),
                                                                         "Insurance Trans Type"=CONST("Net Premium"),
                                                                         "Document Type"=CONST(" ")));
            FieldClass = FlowField;
        }
        field(4;Description;Text[250])
        {
        }
        field(5;"No. Of Active Policies";Integer)
        {
        }
        field(6;"No. of Vehicles";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Customer Code","Class Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PolicyType : Record "Dimension Value";
        GSetup : Record "General Ledger Setup";
}

