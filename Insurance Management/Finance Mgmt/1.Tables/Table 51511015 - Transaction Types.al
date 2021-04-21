table 51511015 "Transaction Types"
{
    // version FINANCE


    fields
    {
        field(1; "Code"; Code[50])
        {
        }
        field(2; "Transaction Name"; Text[70])
        {
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            //OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            //OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(5; "Warm Clothing Allowance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Subsistence; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Other; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Restricted Days"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Default Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Per Diem"; Boolean)
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
        fieldgroup(DropDown; "Code", "Transaction Name")
        {
        }
    }
}

