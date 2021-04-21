table 51511046 "Budget Creation Lines"
{
    // version FINANCE


    fields
    {
        field(1; "Creation No"; Code[20])
        {
        }
        field(2; "Budget Name"; Code[20])
        {
        }
        field(3; Department; Code[20])
        {
        }
        field(4; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(5; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                gl.RESET;
                gl.GET("G/L Account");
                "G/L Account Name" := gl.Name;
            end;
        }
        field(6; Amount; Decimal)
        {
        }
        field(7; "No of Budget Periods"; Option)
        {
            OptionMembers = "1","2","4","12";
        }
        field(8; "G/L Account Name"; Text[250])
        {
        }
        field(9; Description; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Creation No", "Budget Name", Department, "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        gl: Record "G/L Account";
}

