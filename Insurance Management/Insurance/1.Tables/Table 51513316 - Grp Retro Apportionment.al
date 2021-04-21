table 51513316 "Grp Retro Apportionment"
{

    fields
    {
        field(2; "Insurer/Reassurer Code"; Code[10])
        {
        }
        field(3; "Insurer/Reassurer Name"; Text[100])
        {
        }
        field(4; Percentage; Decimal)
        {
        }
        field(5; Amount; Decimal)
        {
            CalcFormula = Sum("Member Prem Retro".Amount WHERE("Insurer/Reassurer Code" = FIELD("Insurer/Reassurer Code"),
                                                                "Qouta Share" = FIELD("Qouta Share"),
                                                                Surplus = FIELD(Surplus),
                                                                Facultative = FIELD(Facultative),
                                                                "Policy Code" = FIELD("Policy Code"),
                                                                "Treaty Code" = FIELD("Treaty Code"),
                                                                "Product Code" = FIELD("Product Code"),
                                                                "Lot No." = FIELD("Lot No."),
                                                                Cedant = FIELD(Cedant),
                                                                "Addendum Code" = FIELD("Addendum Code")));
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
            CalcFormula = Sum("Member Prem Retro"."Sums Assured" WHERE("Insurer/Reassurer Code" = FIELD("Insurer/Reassurer Code"),
                                                                        "Qouta Share" = FIELD("Qouta Share"),
                                                                        Surplus = FIELD(Surplus),
                                                                        Facultative = FIELD(Facultative),
                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                        "Product Code" = FIELD("Product Code"),
                                                                        "Lot No." = FIELD("Lot No."),
                                                                        Cedant = FIELD(Cedant),
                                                                        "Addendum Code" = FIELD("Addendum Code")));
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
                 */

                IF "Currency Code" <> '' THEN BEGIN
                    GetCurrency;
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       ("Period Ended" <> xRec."Period Ended") OR
                       (CurrFieldNo = FIELDNO("Currency Code")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate("Period Ended", "Currency Code");
                END ELSE
                    "Currency Factor" := 0;
                VALIDATE("Currency Factor");
                /*
                IF (("Currency Code" <> xRec."Currency Code") AND (Amount <> 0)) THEN
                  PaymentToleranceMgt.PmtTolGenJnl(Rec);
                */

            end;
        }
        field(21; "Sums Assured (LCY)"; Decimal)
        {
            CalcFormula = Sum("Member Prem Retro"."Sums Assured (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Insurer/Reassurer Code"),
                                                                              "Qouta Share" = FIELD("Qouta Share"),
                                                                              Surplus = FIELD(Surplus),
                                                                              Facultative = FIELD(Facultative),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                              "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              Cedant = FIELD(Cedant),
                                                                              "Addendum Code" = FIELD("Addendum Code")));
            FieldClass = FlowField;
        }
        field(22; "Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Member Prem Retro"."Premium (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Insurer/Reassurer Code"),
                                                                         "Qouta Share" = FIELD("Qouta Share"),
                                                                         Surplus = FIELD(Surplus),
                                                                         Facultative = FIELD(Facultative),
                                                                         "Policy Code" = FIELD("Policy Code"),
                                                                         "Treaty Code" = FIELD("Treaty Code"),
                                                                         "Product Code" = FIELD("Product Code"),
                                                                         "Lot No." = FIELD("Lot No."),
                                                                         Cedant = FIELD(Cedant),
                                                                         "Addendum Code" = FIELD("Addendum Code")));
            FieldClass = FlowField;
        }
        field(29; Commission; Decimal)
        {

            trigger OnValidate();
            begin

                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Commission (LCY)" := Commission
                ELSE
                    "Commission (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        Commission, "Currency Factor"));
            end;
        }
        field(30; "Broker Commission"; Decimal)
        {

            trigger OnValidate();
            begin
                /*GetCurrency;
                IF "Currency Code" = '' THEN
                  "Broker Commission (LCY)" := "Broker Commission"
                ELSE
                  "Broker Commission (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Period Ended","Currency Code",
                      "Broker Commission","Currency Factor"));
                 */

            end;
        }
        field(31; "Commission %"; Decimal)
        {
        }
        field(32; "Broker Commission %"; Decimal)
        {
        }
        field(33; "Commission (LCY)"; Decimal)
        {
        }
        field(34; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));

                //VALIDATE(Amount);
                //VALIDATE("Sums Assured");
                VALIDATE(Commission);
                //VALIDATE("Sums Assured1");
            end;
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

    var
        CurrExchRate: Record "Currency Exchange Rate";
        Text002: Label 'cannot be specified without %1';

    procedure GetCurrency();
    begin
    end;
}

