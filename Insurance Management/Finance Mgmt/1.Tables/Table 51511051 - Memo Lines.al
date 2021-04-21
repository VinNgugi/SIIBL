table 51511051 "Memo Lines"
{
    // version FINANCE


    fields
    {
        field(1; "Memo No"; Code[20])
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
        field(8; "G/L Account Name"; Text[250])
        {
        }
        field(9; Quantity; Integer)
        {

            trigger OnValidate()
            begin
                Amount := Quantity * "Unit Price";
            end;
        }
        field(10; "Unit of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure";
        }
        field(11; "Unit Price"; Decimal)
        {

            trigger OnValidate()
            begin
                Amount := Quantity * "Unit Price";
            end;
        }
        field(12; Description; Text[250])
        {
        }
        field(13; Member; Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                usersetup.RESET;
                usersetup.GET(Member);
                usersetup.TESTFIELD("Employee No.");
                emprec.RESET;
                emprec.GET(usersetup."Employee No.");
                emprec.TESTFIELD("Global Dimension 1 Code");
                Department := emprec."Global Dimension 1 Code";
                dimvalue.RESET;
                dimvalue.GET('DEPARTMENT', Department);
                "Department Name" := dimvalue.Name;
            end;
        }
        field(14; "Department Name"; Text[250])
        {
        }
        field(15; "Create Imprest"; Boolean)
        {
        }
        field(16; Combine; Boolean)
        {
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Memo No", "Budget Name", Department, "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        gl: Record "G/L Account";
        emprec: Record Employee;
        usersetup: Record "User Setup";
        dimvalue: Record "Dimension Value";
}

