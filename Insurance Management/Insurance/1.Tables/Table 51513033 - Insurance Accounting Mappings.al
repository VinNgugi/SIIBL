table 51513033 "Insurance Accounting Mappings"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Class Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Policy Type".Code;

            trigger OnValidate();
            begin
                IF PolicyTypeRec.GET("Class Code") THEN BEGIN
                    "Main Class Code" := PolicyTypeRec.Class;
                END;
            end;
        }
        field(3; "Gross Premium Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(4; "PCF Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(5; "Levy  Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(6; "Stamp Duty Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(7; "Yellow Card Duty Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(8; "Gross Commission Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(9; "Withholding Tax Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(10; "Net Amount Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(11; "Mandatory Share -Premium Acc."; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(12; "Mandatory Share -Comm.Acc."; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(13; "Retention Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(14; "Group Premium Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(15; "Group Commission Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(16; "Quota Share-Premium Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(17; "Quata Share-Comm.Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(18; "1st Surplus Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(19; "1st Surplus Comm. Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(20; "2nd Surplus  Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(21; "2nd Surplus Comm. Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(22; "3rd Surplus  Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(23; "3rd Surplus Comm. Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(24; "Facultative Premium Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(25; "Facultative Commission Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(26; "FACOB  Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(27; "FACOB  Comm.Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(28; "Type Of Business"; Option)
        {
            OptionMembers = "1","2","Payment Terms",Currency,"5","6";
        }
        field(29; "Re-Insuarance Control"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(30; "Commision Receivable"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(31; "Debtors Facultative"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(32; Description; Text[200])
        {
        }
        field(33; "Import Document"; Option)
        {
            OptionCaption = 'Credit Note,Debit Note';
            OptionMembers = "Credit Note","Debit Note";
        }
        field(34; "Credit Note Commision Acc."; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(35; "Total Renewable Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(36; "Net Premium  Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(37; "Falcul.CRN Comm.Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(38; "Facul.CRN Nett Amount Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(39; "Business Source"; Option)
        {
            OptionCaption = '" ,Direct,Facultative"';
            OptionMembers = " ","1","2";
        }
        field(40; "Kenya Re Premium Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(41; "PLS Control Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(42; "Reinsurance Balances Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(43; "Un-earned Premium"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(44; "Un-earned Premium Reserve"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(45; "IBNR Expense"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(46; "IBNR Reserve"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(47; "Claim Reserve"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(48; "Claims Reserves OS"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(49; "XOL Premium Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50; "XOL Commission Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(51; "Reinsurer Share of Reserves-A"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(52; "Reinsurer Share of Reserves-L"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(53; "Main Class Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(54; "Reinsurance Recovery"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(55; "Un-earned Commission Allowable"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(56; "Un-earned Commission Allow. BS"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(57; "Claims Out. Posting Group"; Code[10])
        {
            TableRelation = "Vendor Posting Group";
        }
        field(58; "Claims Paid Account"; Code[20])
        {
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
    }

    keys
    {
        key(Key1; "Class Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PolicyTypeRec: Record "Policy Type";
}

