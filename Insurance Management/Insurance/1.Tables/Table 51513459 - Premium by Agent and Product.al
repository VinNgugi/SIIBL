table 51513459 "Premium by Agent and Product"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Customer Code"; Code[20])
        {
            TableRelation = Customer;
        }
        field(2; "Policy Type"; Code[20])
        {
            TableRelation = "Policy Type";

            trigger OnValidate();
            begin
                IF PolicyType.GET("Policy Type") THEN BEGIN

                    Description := PolicyType.Description;


                END;
            end;
        }
        field(3; "Premium Written"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Policy Type" = FIELD("Policy Type"),
                                                                         "Customer No." = FIELD("Customer Code"),
                                                                         "Document Type" = CONST(" "),
                                                                         "Insurance Trans Type" = CONST("Net Premium")));
            FieldClass = FlowField;
        }
        field(4; Description; Text[250])
        {
        }
        field(5; "No. Of Active Policies"; Integer)
        {
        }
        field(6; "No. of Vehicles"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Customer Code", "Policy Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PolicyType: Record "Policy Type";
}

