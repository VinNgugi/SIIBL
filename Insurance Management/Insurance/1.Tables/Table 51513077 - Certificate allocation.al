table 51513077 "Certificate allocation"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Allocation No."; Code[20])
        {
        }
        field(2; "Allocation Date"; Date)
        {
        }
        field(3; "Batch No"; Code[10])
        {
            TableRelation = Certificates;
        }
        field(4; "From Cert No."; Code[20])
        {
        }
        field(5; "To Cert No."; Code[20])
        {
        }
        field(6; "Allocate to User"; Code[80])
        {
            TableRelation = "User Setup";
        }
        field(7; "Allocate to Branch"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(8; "Certificate Category"; Code[20])
        {
            TableRelation = "Motor Cetificate Categories";
        }
    }

    keys
    {
        key(Key1; "Allocation No.")
        {
        }
    }

    fieldgroups
    {
    }
}

