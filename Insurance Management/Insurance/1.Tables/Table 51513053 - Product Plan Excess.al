table 51513053 "Product Plan Excess"
{
    // version AES-INS 1.0


    fields
    {
        field(1; Excess; Code[10])
        {
            NotBlank = true;
            TableRelation = "Policy Excess";

            trigger OnValidate();
            begin
                // IF ExcessRec.GET(Excess) THEN
                // Description:=ExcessRec.Description;
            end;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Policy Type"; Code[12])
        {
        }
        field(4; "Insurance Type"; Code[10])
        {
        }
        field(5; "Area"; Code[10])
        {
            TableRelation = "Area of coverage"."Area Code" WHERE(UnderWriter = FIELD(UnderWriter));
        }
        field(6; "Default Option"; Code[10])
        {
        }
        field(7; UnderWriter; Code[20])
        {
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1; Excess)
        {
        }
    }

    fieldgroups
    {
    }

    var
        ExcessRec: Record "Policy Excess";
}

