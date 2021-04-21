table 51513328 "Reassurer Apportionment"
{
    // version AES-INS 1.0


    fields
    {
        field(2; "Insurer/Reassurer Code"; Code[10])
        {
            //ValidateTableRelation = true;
        }
        field(3; "Insurer/Reassurer Name"; Text[100])
        {
        }
        field(4; Percentage; Decimal)
        {
        }
        field(5; Amount; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details".Amount WHERE(Cedant = FIELD(Cedant),
                                                                      "Policy Number" = FIELD("Policy Number"),
                                                                      "Qouta Share" = FIELD("Qouta Share"),
                                                                      Surplus = FIELD(Surplus),
                                                                      Facultative = FIELD(Facultative),
                                                                      "Insurer/Reassurer Code" = FIELD("Insurer/Reassurer Code"),
                                                                      Retro = FIELD(Retro),
                                                                      "Policy Type" = FIELD("Policy Type"),
                                                                      "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(6; "Qouta Share"; Boolean)
        {
        }
        field(7; Surplus; Boolean)
        {
        }
        field(8; Facultative; Boolean)
        {
        }
        field(9; "Excess Of Loss"; Boolean)
        {
        }
        field(10; "Group Scheme code"; Code[30])
        {
        }
        field(11; "Policy Code"; Code[30])
        {
        }
        field(12; "Treaty Code"; Code[30])
        {
        }
        field(13; "Product Code"; Code[30])
        {
            TableRelation = "Product Types";
        }
        field(14; "Lot No."; Code[10])
        {
        }
        field(15; Cedant; Code[30])
        {
            TableRelation = Customer WHERE(Type = CONST(Cedant));
        }
        field(16; "Period Ended"; Date)
        {
        }
        field(17; "Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code";
        }
        field(18; "Sums Assured"; Decimal)
        {
            CalcFormula = Average("Reassurance App Details"."Sums Assured" WHERE(Cedant = FIELD(Cedant),
                                                                                  "Policy Number" = FIELD("Policy Number"),
                                                                                  "Qouta Share" = FIELD("Qouta Share"),
                                                                                  Surplus = FIELD(Surplus),
                                                                                  Facultative = FIELD(Facultative),
                                                                                  "Insurer/Reassurer Code" = FIELD("Insurer/Reassurer Code"),
                                                                                  Retro = FIELD(Retro),
                                                                                  "Policy Type" = FIELD("Policy Type"),
                                                                                  "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(19; "Inception Date"; Date)
        {
        }
        field(20; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            begin
                /*IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
                  IF BankAcc3.GET("Bal. Account No.") AND (BankAcc3."Currency Code" <> '')THEN
                    BankAcc3.TESTFIELD("Currency Code","Currency Code");
                END;
                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                  IF BankAcc3.GET("Account No.") AND (BankAcc3."Currency Code" <> '') THEN
                    BankAcc3.TESTFIELD("Currency Code","Currency Code");
                END;
                IF ("Recurring Method" IN
                    ["Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance"]) AND
                   ("Currency Code" <> '')
                THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Currency Code"),FIELDCAPTION("Recurring Method"),"Recurring Method");
                
                IF "Currency Code" <> '' THEN BEGIN
                  GetCurrency;
                  IF ("Currency Code" <> xRec."Currency Code") OR
                     ("Posting Date" <> xRec."Posting Date") OR
                     (CurrFieldNo = FIELDNO("Currency Code")) OR
                     ("Currency Factor" = 0)
                  THEN
                    "Currency Factor" :=
                      CurrExchRate.ExchangeRate("Posting Date","Currency Code");
                END ELSE
                  "Currency Factor" := 0;
                VALIDATE("Currency Factor");
                
                IF (("Currency Code" <> xRec."Currency Code") AND (Amount <> 0)) THEN
                  PaymentToleranceMgt.PmtTolGenJnl(Rec);
                */

            end;
        }
        field(21; "Sums Assured (LCY)"; Decimal)
        {
            CalcFormula = Average("Reassurance App Details"."Sums Assured (LCY)" WHERE(Cedant = FIELD(Cedant),
                                                                                        "Policy Number" = FIELD("Policy Number"),
                                                                                        "Qouta Share" = FIELD("Qouta Share"),
                                                                                        Surplus = FIELD(Surplus),
                                                                                        Facultative = FIELD(Facultative),
                                                                                        "Insurer/Reassurer Code" = FIELD("Insurer/Reassurer Code"),
                                                                                        Retro = FIELD(Retro),
                                                                                        "Policy Type" = FIELD("Policy Type"),
                                                                                        "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(22; "Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Premium (LCY)" WHERE(Cedant = FIELD(Cedant),
                                                                               "Policy Number" = FIELD("Policy Number"),
                                                                               "Qouta Share" = FIELD("Qouta Share"),
                                                                               Surplus = FIELD(Surplus),
                                                                               Facultative = FIELD(Facultative),
                                                                               "Insurer/Reassurer Code" = FIELD("Insurer/Reassurer Code"),
                                                                               Retro = FIELD(Retro),
                                                                               "Policy Type" = FIELD("Policy Type"),
                                                                               "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(23; "Policy Number"; Code[30])
        {
            TableRelation = "Individual Life"."Policy Number";
        }
        field(24; Retro; Boolean)
        {
        }
        field(25; "Policy Type"; Option)
        {
            OptionCaption = '" ,Main Policy,Supplimentary"';
            OptionMembers = " ","Main Policy",Supplimentary;
        }
        field(26; Compulsory; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Insurer/Reassurer Code")
        {
        }
    }

    fieldgroups
    {
    }
}

