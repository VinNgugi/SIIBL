table 51513166 "Product Loading and Discounts"
{
    Caption = 'Product Loading and Discounts';
    DataClassification = ToBeClassified;
   // version AES-INS 1.0


    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; Type; Option)
        {
            OptionMembers = " ",Loading,Discount;
        }
        field(4; "Loading Amount"; Decimal)
        {
        }
        field(5; "Loading Percentage"; Decimal)
        {
        }
        field(6; "Discount Amount"; Decimal)
        {
        }
        field(7; "Discount Percentage"; Decimal)
        {
        }
        field(8; "Calculation Method"; Option)
        {
            OptionCaption = '% of Sum Insured,Flat Amount,% of commission,% of Gross Premium';
            OptionMembers = "% of Sum Insured","Flat Amount","% of commission","% of Gross Premium";
        }
        field(9; "Applicable to"; Option)
        {
            OptionCaption = 'All,New,Renewals,Certificate Charge,COMESA';
            OptionMembers = All,New,Renewals,"Certificate Charge",COMESA;
        }
        field(10; "Option Applicable to"; Option)
        {
            OptionCaption = '" ,Individual,Group,Both"';
            OptionMembers = " ",Individual,Group,Both;
        }
        field(11; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(12; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = const(true))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(13; Tax; Boolean)
        {
        }
        field(14;"Underwriter Code";Code[20])
        {

        }
        field(15;"Product Code";Code[20])
        {

        }
    }

    keys
    {
        key(Key1;"Underwriter Code","Product Code", "Code")
        {
        }
    }

    fieldgroups
    {
    } 

}
