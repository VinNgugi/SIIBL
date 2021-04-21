table 51513075 Litigations
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Case No."; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            NotBlank = true;
        }
        field(3; "Law Firm"; Code[20])
        {
            NotBlank = false;
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law firms"));

            trigger OnValidate();
            begin

                IF vend.GET("Law Firm") THEN
                    "Law Firm Name" := vend.Name;
            end;
        }
        field(4; "Law Firm Name"; Text[100])
        {
        }
        field(5; Schedules; Integer)
        {
            CalcFormula = Count("Litigation schedule" WHERE("Litigation Code" = FIELD("Case No.")));
            FieldClass = FlowField;
        }
        field(6; "Employee ID"; Code[10])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF empl.GET("Employee ID") THEN;
                "Employee name" := empl."First Name" + ' ' + empl."Last Name";
            end;
        }
        field(7; "Employee name"; Text[80])
        {
        }
        field(8; "Property ID"; Code[10])
        {
            TableRelation = "Fixed Asset" WHERE("FA Subclass Code" = const('PROPERTY'));

            trigger OnValidate();
            begin
                IF FA.GET("Property ID") THEN
                    "Property Name" := FA.Description
                ELSE
                    "Property Name" := '';
            end;
        }
        field(9; "Property Name"; Text[30])
        {
        }
        field(10; "Property Case"; Boolean)
        {
        }
        field(11; "Language Code (Default)"; Code[10])
        {
        }
        field(12; Attachement; Option)
        {
            OptionMembers = No,Yes;
        }
        field(13; "Insurance Case"; Boolean)
        {
        }
        field(14; "Claim No."; Code[20])
        {
            TableRelation = Claim;
        }
        field(15; "Law Court"; Code[10])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law courts"));
        }
        field(16; "Third Party Lawyer"; Text[80])
        {
        }
        field(17; "Claimant ID"; Integer)
        {
            TableRelation = "Claim Involved Parties"."Claim Line No." WHERE("Claim No." = FIELD("Claim No."));

            trigger OnValidate();
            begin
                IF Claimants.GET("Claim No.", "Claimant ID") THEN
                    "Claimant Name" := Claimants.Surname;
            end;
        }
        field(18; "Claimant Name"; Text[80])
        {
            Editable = false;
        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(20; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(21; Plaintiff; Text[80])
        {
        }
        field(22; Defendant; Text[80])
        {
        }
        field(23; "Court Decision"; Option)
        {
            OptionCaption = '" ,Liable,Repudiated"';
            OptionMembers = " ",Liable,Repudiated;
        }
    }

    keys
    {
        key(Key1; "Case No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        vend: Record Vendor;
        empl: Record Employee;
        FA: Record "Fixed Asset";
        Claimants: Record "Claim Involved Parties";
}

