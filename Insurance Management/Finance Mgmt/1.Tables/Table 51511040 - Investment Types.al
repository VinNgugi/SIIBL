table 51511040 "Investment Types"
{
    // version FINANCE

    //DrillDownPageID = 51515524;
    //LookupPageID = 51515524;

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "General Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Asset Types";
        }
        field(4; "Investment Revaluation Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(5; "Investment Income Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(6; "Ledger Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; Portfolio; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Corporate Bonds/Debentures,Ordinary Shares,Fed. Govt. Securities,Hybrid Funds,Money Market-Banks,State Govt. Securities,Treasury Bills';
            OptionMembers = " ","Corporate Bonds/Debentures","Ordinary Shares","Fed. Govt. Securities","Hybrid Funds","Money Market-Banks","State Govt. Securities","Treasury Bills";

            trigger OnValidate()
            begin
                /*Assets.RESET;
                Assets.SETCURRENTKEY("Investment Type",Offshore);
                Assets.SETRANGE("Investment Type",Code);
                IF Assets.FIND('-') THEN BEGIN REPEAT
                Assets.Portfolio := Portfolio;
                Assets.MODIFY;
                UNTIL Assets.NEXT = 0;
                END;*/

            end;
        }
        field(8; "Capital Reserve Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(9; "Mortgage Arrears Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(10; "Revaluation Gain/Loss"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(11; "Commissions Ac"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(12; "Security Cost Ac"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(13; "Other Cost Ac"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(14; "Dividend Receivable AC"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(15; "Dividend Income AC"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(16; "Withholding Tax Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(17; "Unit Trust Members A/c"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(18; "Bonus Income AC"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(19; "Interest Receivable Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(20; "Other Charges A/C"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(21; "Gain/Loss on Disposal Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(22; "Investment Cost Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(23; "Specific Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Ordinary shares Listed,Preference shares Listed,Preference shares Unlisted,Private Sector deposit,Government Security,Treasury Bonds,Commercial paper,Commercial mortgages,Staff mortgages,Ordinary shares unlisted,Irredemeable Stock,Call Deposit,Fixed Deposit,Forex,Tresury Bills,Corporate Bonds,Unit Trust Money Market,Unit Trust Equity,Property';
            OptionMembers = " ","Ordinary shares Listed","Preference shares Listed","Preference shares Unlisted","Private Sector deposit","Government Security","Treasury Bonds","Commercial paper","Commercial mortgages","Staff mortgages","Ordinary shares unlisted","Irredemeable Stock","Call Deposit","Fixed Deposit",Forex,"Tresury Bills","Corporate Bonds","Unit Trust Money Market","Unit Trust Equity",Property;
        }
        field(24; "G/L Asset Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(25; "VAT on Purchase"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "VAT on Sale"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "WHT On Purchase"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "WHT on Sale"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "VAT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tarriff Codes";
        }
        field(30; "WHT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tarriff Codes";
        }
        field(31; "Calculate Interest-Payments"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Calculate Broker Commission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Calculate Interest-Receipts"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Interest Income Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(35; "Calculate Withholding Tax"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Regulator Limit Link"; Code[10])
        {
            DataClassification = ToBeClassified;
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

