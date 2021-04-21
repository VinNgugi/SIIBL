table 51513072 "SACCO Routes"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "SACCO ID"; Code[20])
        {
            TableRelation = Customer;
        }
        field(2; "Route ID"; Code[20])
        {
            TableRelation = "Vehicle Routes";

            trigger OnValidate();
            begin
                IF vehicleRoutes.GET("Route ID") THEN BEGIN
                    "Route Name" := vehicleRoutes.Description;
                END;
            end;
        }
        field(3; "Route Name"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "SACCO ID", "Route ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        vehicleRoutes: Record "Vehicle Routes";
}

