table 51513441 "Reinsurance Treaty Loadings"
{

    fields
    {
        field(1;"Treaty Code";Code[30])
        {
        }
        field(2;Addendum;Integer)
        {
        }
        field(3;"Loading_Discount Code";Code[10])
        {
            TableRelation = "Loading and Discounts Setup";
        }
        field(4;Type;Option)
        {
            OptionMembers = " ",Loading,Discount;
        }
        field(5;"Loading Amount";Decimal)
        {
        }
        field(7;"Loading Percentage";Decimal)
        {
        }
        field(8;"Discount Amount";Decimal)
        {
        }
        field(9;"Discount Percentage";Decimal)
        {
        }
        field(10;"Calculation Method";Option)
        {
            OptionMembers = "% of Sum Insured","Flat Amount","% of commission","% of Gross Premium","% of MDPs";
        }
        field(11;"Applicable to";Option)
        {
            OptionMembers = All,New,"Renewals ";
        }
        field(12;"Option Applicable to";Option)
        {
            OptionMembers = " ",Individual,Group,Both;
        }
        field(13;"Account Type";Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(14;"Account No.";Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type"=CONST("G/L Account")) "G/L Account" WHERE ("Account Type"=CONST(Posting),
                                                                                      Blocked=CONST(false))
                                                                                      ELSE IF ("Account Type"=CONST(Customer)) Customer
                                                                                      ELSE IF ("Account Type"=CONST(Vendor)) Vendor
                                                                                      ELSE IF ("Account Type"=CONST("Bank Account")) "Bank Account"
                                                                                      ELSE IF ("Account Type"=CONST("Fixed Asset")) "Fixed Asset"
                                                                                      ELSE IF ("Account Type"=CONST("IC Partner")) "IC Partner";
        }
        field(15;Tax;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Treaty Code")
        {
        }
    }

    fieldgroups
    {
    }
}

