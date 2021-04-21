table 51511010 "Staff  Bank Account"
{
    // version FINANCE

    DrillDownPageID = 51511031;
    LookupPageID = 51511031;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(3; Name; Text[100])
        {
        }
        field(5; "Name 2"; Text[100])
        {
        }
        field(6; Address; Text[30])
        {
        }
        field(7; "Address 2"; Text[30])
        {
        }
        field(8; City; Text[30])
        {
        }
        field(9; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF PostCode.GET("Post Code") THEN
                    City := PostCode.City;
            end;
        }
        field(10; Contact; Text[30])
        {
        }
        field(11; "Phone No."; Text[30])
        {
        }
        field(12; "Telex No."; Text[20])
        {
        }
        field(13; "Bank Branch No."; Text[20])
        {
            NotBlank = false;
        }
        field(14; "Bank Account No."; Text[30])
        {
        }
        field(15; "Transit No."; Text[20])
        {
        }
        field(16; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(17; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(18; County; Text[30])
        {
        }
        field(19; "Fax No."; Text[30])
        {
        }
        field(20; "Telex Answer Back"; Text[20])
        {
        }
        field(21; "Language Code"; Code[10])
        {
            TableRelation = Language;
        }
        field(22; "E-Mail"; Text[80])
        {
        }
        field(23; "Home Page"; Text[80])
        {
        }
        field(24; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            //TableRelation = "Payroll Period";
        }
    }

    keys
    {
        key(Key1; "Code", "Bank Branch No.")
        {
        }
        key(Key2; Name)
        {
        }
        key(Key3; "Name 2")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Name, "Name 2", "Bank Branch No.")
        {
        }
    }

    var
        PostCode: Record 225;
}

