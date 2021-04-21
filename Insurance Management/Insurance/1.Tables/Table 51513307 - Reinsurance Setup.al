table 51513307 "Reinsurance Setup"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Pimary Key"; Code[10])
        {
        }
        field(2; "Premium Income Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(3; "Kenya Re Code"; Code[20])
        {
            TableRelation = Vendor WHERE(Type = CONST(Reinsurer));
        }
        field(4; "Claims Expense Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Commission Expense Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(6; "Retrocession Treaty Code"; Code[30])
        {
            TableRelation = Treaty."Treaty Code" WHERE("Treaty Type" = CONST(Retrocession));
        }
        field(7; "Retrocession Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code" WHERE("Treaty Type" = CONST(Retrocession));
        }
        field(8; "Retro Premium Expense A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Retro Claims Income A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(10; "Retro Commission A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(11; "Treaty Nos."; Code[10])
        {
            Caption = 'Treaty Nos.';
            TableRelation = "No. Series";
        }
        field(12; "Claim Attachment Nos."; Code[10])
        {
            Caption = 'Claim Attachment Nos.';
            TableRelation = "No. Series";
        }
        field(13; "Receipts Nos."; Code[10])
        {
            Caption = 'Receipts Nos.';
            TableRelation = "No. Series";
        }
        field(14; "IND Retrocession Treaty Code"; Code[30])
        {
            TableRelation = Treaty."Treaty Code" WHERE("Treaty Type" = CONST(Retrocession));
        }
        field(15; "IND Retrocession Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code" WHERE("Treaty Type" = CONST(Retrocession));
        }
        field(16; "Payments Nos."; Code[10])
        {
            Caption = 'Payments Nos.';
            TableRelation = "No. Series";
        }
        field(17; "Mortgage Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(18; "Car Loan Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(19; "Benefits Premium Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(20; Constant1; Decimal)
        {
            DecimalPlaces = 2 : 5;
        }
        field(21; Constant2; Decimal)
        {
            DecimalPlaces = 2 : 5;
        }
        field(22; Constant3; Decimal)
        {
            DecimalPlaces = 2 : 5;
        }
        field(23; Constant4; Decimal)
        {
            DecimalPlaces = 2 : 5;
        }
        field(24; "Underwriting Nos."; Code[10])
        {
            Caption = 'Underwriting Nos.';
            TableRelation = "No. Series";
        }
        field(25; "Underwriting Loading  Nos."; Code[10])
        {
            Caption = 'Underwriting Loading  Nos.';
            TableRelation = "No. Series";
        }
        field(26; "Credit Note  Nos."; Code[10])
        {
            Caption = 'Credit Note  Nos.';
            TableRelation = "No. Series";
        }
        field(38; "Language Code (Default)"; Code[10])
        {
        }
        field(39; Attachement; Option)
        {
            OptionMembers = No,Yes;
        }
        field(40; "Code"; Code[10])
        {
            Numeric = true;
        }
    }

    keys
    {
        key(Key1; "Pimary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

