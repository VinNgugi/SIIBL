table 51513115 Certificates
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Batch No"; Code[10])
        {
        }
        field(2; Date; Date)
        {
        }
        field(3; "Type Code"; Code[10])
        {
            TableRelation = "Motor Cetificate Categories";

            trigger OnValidate();
            begin
                IF Categories.GET("Type Code") THEN
                    Type := Categories."Type Name";
            end;
        }
        field(4; Type; Text[30])
        {
        }
        field(5; "Serial No Form"; Code[20])
        {
        }
        field(6; "Serioa No To"; Code[20])
        {
        }
        field(7; Insurer; Code[10])
        {
            TableRelation = Vendor;
        }
        field(8; "Last Issued No"; Code[10])
        {
        }
        field(9; Finished; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Batch No", Insurer)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Categories: Record "Motor Cetificate Categories";
}

