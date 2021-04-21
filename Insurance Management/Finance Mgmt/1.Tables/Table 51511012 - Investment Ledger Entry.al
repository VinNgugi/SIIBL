table 51511012 "Investment Ledger Entry"
{
    // version FINANCE

    /* DrillDownPageID = 51515527;
    LookupPageID = 51515527; */

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Descreption; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Investment No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
        }
        field(5; "Investment Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Money Market",Property,Equity,Mortgage;
        }
        field(6; "Investment Transcation Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,"Share-split",Premium,Discounts,"Other Income",Expenses,Principal,Rollover;
        }
        field(7; "No. of Units"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Amout (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Custodian Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Fund Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Price per Share"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Reversed By Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Entry Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Initial Entry,Amortized,Final Entry';
            OptionMembers = "Initial Entry",Amortized,"Final Entry";
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
        key(Key2; "Investment No", "Investment Transcation Type")
        {
            SumIndexFields = Amount, "Amout (LCY)";
        }
        key(Key3; "Investment No", "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Mails: Record "Receipts Header";
        Doc: Record "Partial Imprest Issue";
        Employees: Record Employee;
        SalesSetup: Record "Imprest Rates";
        CommentLine: Record 97;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Vend: Record Vendor;
        Cust: Record Customer;
}

