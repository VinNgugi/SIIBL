table 51513463 "Payment Signatories selection"
{
    // version AES-INS 1.0


    fields
    {
        field(1; PV; Code[20])
        {
        }
        field(2; "Employee No."; Code[20])
        {
            //TableRelation = "Payment Signatories"."Signatory No.";

            trigger OnValidate();
            begin
                IF Emp.GET("Employee No.") THEN BEGIN
                    "Signatory Name" := Emp."First Name" + '' + Emp."Middle Name" + '' + Emp."Last Name";
                    Title := Emp."Job Title";

                END;
            end;
        }
        field(3; "Signatory Name"; Text[80])
        {
        }
        field(4; Title; Text[40])
        {
        }
    }

    keys
    {
        key(Key1; PV, "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Emp: Record Employee;
}

