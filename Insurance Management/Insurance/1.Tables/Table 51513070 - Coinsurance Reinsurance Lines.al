table 51513070 "Coinsurance Reinsurance Lines"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement,Claim Reserves,Claim payment"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement,"Claim Reserves","Claim payment";
        }
        field(2; "No."; Code[30])
        {
        }
        field(3; "Transaction Type"; Option)
        {
            OptionMembers = " ","Co-insurance","Re-insurance ","Broker ";
        }
        field(4; Name; Text[30])
        {
        }
        field(5; "Sum Insured"; Decimal)
        {
        }
        field(6; Premium; Decimal)
        {
        }
        field(7; "Cedant Commission"; Decimal)
        {
        }
        field(8; "Broker Commission"; Decimal)
        {
        }
        field(9; "Quota Share"; Boolean)
        {
        }
        field(10; Surplus; Boolean)
        {
        }
        field(11; Facultative; Boolean)
        {
        }
        field(12; "Excess Of Loss"; Boolean)
        {
        }
        field(13; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(14; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                      Blocked = CONST(false))
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
                /*
                CASE "Account Type" OF
                  "Account Type"::"G/L Account":
                    BEGIN
                
                      GLAcc.GET("Account No.");
                     // CheckGLAcc;
                      Name:=GLAcc.Name;
                
                    END;
                  "Account Type"::Customer:
                    BEGIN
                      Cust.GET("Account No.");
                      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
                      Name:=Cust.Name;
                    END;
                  "Account Type"::Vendor:
                    BEGIN
                      Vend.GET("Account No.");
                      Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
                      Name:=Vend.Name;
                    END;
                  "Account Type"::"Bank Account":
                    BEGIN
                      BankAcc.GET("Account No.");
                      BankAcc.TESTFIELD(Blocked,FALSE);
                      Name:=BankAcc.Name;
                    END;
                  "Account Type"::"Fixed Asset":
                    BEGIN
                      FA.GET("Account No.");
                      FA.TESTFIELD(Blocked,FALSE);
                      FA.TESTFIELD(Inactive,FALSE);
                      FA.TESTFIELD("Budgeted Asset",FALSE);
                      Name:=FA.Description;
                    END;
                  "Account Type"::"IC Partner":
                    BEGIN
                      ICPartner.GET("Account No.");
                      ICPartner.CheckICPartner;
                      Name:=ICPartner.Name;
                    END;
                END; */

            end;
        }
        field(15; "Partner No."; Code[20])
        {
            
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                      Blocked = CONST(false))
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
                IF Cust.GET("Partner No.") THEN
                    Name := Cust.Name;
                IF Vend.GET("Partner No.") THEN
                    Name := Cust.Name;
            end;
        }
        field(16; Amount; Decimal)
        {
        }
        field(17; "WHT Amount"; Decimal)
        {
        }
        field(18; "Claim Reserve Amount"; Decimal)
        {
        }
        field(19; "Claims Payment Amount"; Decimal)
        {
        }
        field(20; TreatyLineID; Code[20])
        {
        }
        field(21; Reversed; Boolean)
        {
        }
        field(22; Posted; Boolean)
        {
        }
        field(23; PolicyNo; Code[30])
        {
        }
        field(24; "DebitNote No"; Code[20])
        {
        }
        field(25; "CreditNote No"; Code[20])
        {
        }
        field(26; "Claim No."; Code[30])
        {
        }
        field(27; "Claimant ID"; Integer)
        {
        }
        field(28; "Reinstatement Premium"; Decimal)
        {
        }
        field(29; "Treaty Code"; Code[30])
        {
        }
        field(30; "Addendum Code"; Integer)
        {
        }
        field(31; "Transaction Date"; Date)
        {
        }
        field(32; "Reinstated Amount"; Decimal)
        {
        }
        field(33;"Coinsurance Percentage";Decimal)
        {
        }
        field(34;"Commission Type";enum CommissionType)
        {
          
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Transaction Type", "Partner No.", TreatyLineID)
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
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
}

