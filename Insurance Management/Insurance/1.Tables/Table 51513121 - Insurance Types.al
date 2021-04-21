table 51513121 "Insurance Types"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Description; Text[130])
        {
        }
        field(3; "Insurance Class"; Code[10])
        {
            TableRelation = "Insurance Class";
        }
        field(4; "Account Type"; Option)
        {
            OptionMembers = " ","G/L Account",Vendor;
        }
        field(5; "Account No"; Code[10])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor;
            ValidateTableRelation = false;
        }
        field(6; Commission; Boolean)
        {
        }
        field(7; "Refund A/C"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Policy Type"; Code[10])
        {
            TableRelation = "Policy Type";

            trigger OnValidate();
            begin
                IF policytype.GET("Policy Type") THEN
                    "Insurance Class" := policytype.Class;
            end;
        }
        field(9; "Refund % age"; Decimal)
        {
        }
        field(10; "Calculation Method"; Option)
        {
            OptionMembers = "% of Sum Insured","% age of Premium ";
        }
        field(11; "Discount %"; Decimal)
        {
        }
        field(12; "Discount Amount"; Decimal)
        {
        }
        field(13; "Sum Insured Required"; Boolean)
        {
        }
        field(14; "Age Required"; Boolean)
        {
        }
        field(15; "Payment Frequency Required"; Boolean)
        {
        }
        field(16; "Area Required"; Boolean)
        {
        }
        field(17; "Total Premium"; Decimal)
        {
            Editable = false;
        }
        field(18; "Our Premium Share"; Decimal)
        {
            Editable = false;
        }
        field(19; "Total Claims"; Decimal)
        {
            Editable = false;
        }
        field(20; "Our Claim Share"; Decimal)
        {
            Editable = false;
        }
        field(21; Type; Option)
        {
            OptionMembers = Mandatory,Optional;
        }
        field(22; "Loading %"; Decimal)
        {
        }
        field(23; "Loading Amount"; Decimal)
        {
        }
        field(24; "Option Applicable to"; Option)
        {
            OptionMembers = " ",Individual,Group,Both;
        }
        field(25; "Related to"; Code[10])
        {
            TableRelation = "Insurance Types" WHERE("Policy Type" = FIELD("Policy Type"),
                                                     Type = CONST(Mandatory));
        }
        field(26; Tax; Boolean)
        {
        }
        field(27; "Default Area"; Code[10])
        {
            TableRelation = "Area of coverage";
        }
        field(28; "Default Product Type"; Code[10])
        {
            TableRelation = "Insurance Types".Code WHERE(Type = CONST(Mandatory));
        }
        field(29; "Default Excess"; Code[10])
        {
            TableRelation = "Policy Excess";
        }
        field(30; "Default Premium Payment"; Code[10])
        {
            TableRelation = "Payment Terms".Code;
        }
        field(31; "Default Option"; Code[10])
        {
            TableRelation = "Insurance Types".Code;
        }
        field(32; "Include Description Nos"; Integer)
        {
            TableRelation = "Policy Details"."Line No" WHERE("Policy Type" = FIELD("Policy Type"));
        }
        field(33; "Exclude  Description Nos"; Integer)
        {
            TableRelation = "Policy Details"."Line No" WHERE("Policy Type" = FIELD("Policy Type"));
        }
        field(34; Priority; Integer)
        {
        }
        field(35; "Exlude for product type"; Code[10])
        {
            TableRelation = "Insurance Types".Code WHERE(Type = CONST(Mandatory));
        }
        field(36; Pregancy; Boolean)
        {
        }
        field(37; "Include multiple Nos"; Text[30])
        {
            TableRelation = "Policy Details"."Line No" WHERE("Policy Type" = FIELD("Policy Type"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(38; "Maximum Limit"; Text[30])
        {
        }
        field(39; FullDescription; Text[250])
        {
        }
        field(40; desc; Code[10])
        {
        }
        field(41; "Discount loaded"; Decimal)
        {
        }
        field(42; Loading; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        policytype: Record "Policy Type";
}

