table 51513039 "Premium Table Entry"
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
                IF Ageband.GET("Age Band", UnderWriter, "Client Type") THEN BEGIN
                    "Minimum Age" := Ageband."Minimum Age";
                    "Maximum Age" := Ageband."Maximum Age";
                END;
            end;
        }
        field(3; "Cover Selected"; Code[20])
        {
            NotBlank = true;
        }
        field(4; "Area of Cover"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Area of coverage"."Area Code";
        }
        field(5; Excess; Code[20])
        {
            NotBlank = true;
        }
        field(6; "Premium Amount"; Decimal)
        {
        }
        field(7; "Premium Currency"; Code[10])
        {
            TableRelation = Currency;
        }
        field(8; "Policy Type"; Code[20])
        {
        }
        field(9; "Minimum Age"; Integer)
        {
        }
        field(10; "Maximum Age"; Integer)
        {
        }
        field(11; "Payment Frequency"; Code[20])
        {
            TableRelation = "Payment Terms";
        }
        field(12; "Entry No"; Integer)
        {
        }
        field(13; UnderWriter; Code[20])
        {
            TableRelation = Vendor;
        }
        field(14; "Client Type"; Code[10])
        {
        }
        field(15; "Employee Range"; Code[20])
        {
        }
        field(16; "Period Range"; Code[10])
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
        Ageband: Record "Age Group";
}

