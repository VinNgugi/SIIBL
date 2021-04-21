table 51511006 "Pay Modes"
{

    
    // version FINANCE
    LookupPageId="Pay Mode";
    DrillDownPageId="Pay Mode";


    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Account Affected"; Option)
        {
            OptionMembers = Cashier,Predefined,Postdefined;
        }
        field(4; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(5; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
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

            trigger OnValidate();
            begin
                IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner"] THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No.");
                                //"Account Name":=GLAcc.Name;
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                //"Account Name":=Cust.Name;
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                //"Account Name":=Vend.Name;
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                //"Account Name":=BankAcc.Name;
                            END;
                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No.");
                                //"Account Name":=FA.Description;
                            END;
                    end;
            end;
                     
              
        }
        field(6; Electronic; Boolean)
        {
        }
        field(7; "Print Receipt"; Boolean)
        {
        }
        field(8; "Requires Bank Deatils"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Type; Option)
        {
            OptionMembers = "",EFT,RTGS;
        }
        field(10;"Mobile Money";Boolean)
        {

        }
        field(11;"Send Receipt Notification";Boolean)
        {

        }
        field(12;"Send Payment notification";Boolean)
        {

        }
        field(13;"Amount Limit";Decimal)
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
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";

    
}

