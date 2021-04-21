table 51513120 "Product Plans"
{
    // version AES-INS 1.0


    fields
    {
        field(1; Code; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[60])
        {
        }
        field(3; UnderWriter; Code[10])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST(Insurer));
        }
        field(4; "Quote Report ID"; Integer)
        {
            TableRelation = Object.ID WHERE(Type = CONST(Report));
        }
        field(5; "Policy Report ID"; Integer)
        {
            TableRelation = Object.ID WHERE(Type = CONST(Report));
        }
        field(6; Class; Code[10])
        {
            TableRelation = "Insurance Class".Code;
        }
        field(7; "Default Insurance Type"; Code[10])
        {
            //TableRelation = Options.Code WHERE(Type = CONST(Mandatory), "Policy Type" = FIELD(Code));
        }
        field(8; "Default Area Code"; Code[10])
        {
            TableRelation = "Area of Coverage"."Area Code" WHERE("Policy Type" = FIELD(Code));
        }
        field(9; "Default Premium Payment"; Code[10])
        {
            TableRelation = "Payment Terms".Code;
        }
        field(10; "Default Excess"; Code[10])
        {
            //TableRelation = Excess;
        }
        field(11; "Country Determines Area"; Boolean)
        {
        }
        field(12; "Premium Debits"; Decimal)
        {
            CalcFormula = Sum("Cust. Ledger Entry"."Sales (LCY)" WHERE("Policy Type" = FIELD(Code), "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(13; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(14; "Premium Credits"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Policy Type" = FIELD(Code), "Posting Date" = FIELD("Date Filter"), "Document Type" = CONST("Credit Memo")));
            FieldClass = FlowField;
        }
        field(15; "Description Small"; Text[60])
        {
        }
        field(16; Claims; Decimal)
        {
            CalcFormula = Sum("Claim Lines"."Claim Amount(LCY)");
            FieldClass = FlowField;
        }
        field(17; "Paid Claims"; Decimal)
        {
            CalcFormula = Sum("Claim Lines"."Amount Paid");
            FieldClass = FlowField;
        }
        field(18; "Rejected Claims"; Decimal)
        {
            //CalcFormula = Sum("Claim Lines".r);
            //FieldClass = FlowField;
        }
        field(19; "Premium Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(20; "Claims Reserve A/C"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(21; "Commission A/C"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(22; "Policy Numbering"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(23; "Create Policy Numbers?"; Boolean)
        {
        }
        field(24; "Claim Validity Period"; DateFormula)
        {
        }
        field(25; "Module Type"; Option)
        {
            OptionMembers = Medical,"Medical Brokerage",Travel,"Life and Investment","Amini Data","Medical AWS","Medical AWSIHS",Funded;
        }
        field(26; "Policy Category"; Option)
        {
            OptionMembers = " ","Whole Life","Savings Plan",Bonds,"Pension Plan","Group Personal Accident","Personal Accident";
        }
        field(27; "Main Category"; Option)
        {
            OptionMembers = " ",Life,Investment,"Personal Accident";
        }
        field(28; "Type Of Cover"; Option)
        {
            OptionMembers = "Inpatient Cover only","Outpatient Cover only","In & Outpatient Cover","In & Outpatient Cover with addons","Life and Investment",Travel;
        }
        field(29; "Product code"; Text[30])
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
}

