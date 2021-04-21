table 51513317 "Member Prem Retro"
{

    fields
    {
        field(1; "Member No."; Code[30])
        {
        }
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

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Premium (LCY)" := Amount
                ELSE
                    "Premium (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        Amount, "Currency Factor"));
            end;
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
        field(18; "Member Name"; Text[100])
        {
        }
        field(19; "Sums Assured"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    "Sums Assured (LCY)" := "Sums Assured"
                ELSE
                    "Sums Assured (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Sums Assured", "Currency Factor"));
            end;
        }
        field(20; "Inception date"; Date)
        {
        }
        field(21; "Currency Code"; Code[10])
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

                IF "Claim Period Ended" <> 0D THEN BEGIN

                    IF "Currency Code" <> '' THEN BEGIN
                        GetCurrency;
                        IF ("Currency Code" <> xRec."Currency Code") OR
                           ("Claim Period Ended" <> xRec."Claim Period Ended") OR
                           (CurrFieldNo = FIELDNO("Currency Code")) OR
                           ("Currency Factor1" = 0)
                        THEN
                            "Currency Factor1" :=
                             CurrExchRate.ExchangeRate("Claim Period Ended", "Currency Code");

                    END ELSE BEGIN

                        "Currency Factor1" := 0;
                        //MESSAGE('%1',"Currency Factor");
                        VALIDATE("Currency Factor");
                    END;
                END;



                /*
                IF (("Currency Code" <> xRec."Currency Code") AND (Amount <> 0)) THEN
                  PaymentToleranceMgt.PmtTolGenJnl(Rec);
                */

            end;
        }
        field(22; "Sums Assured (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    "Sums Assured" := "Sums Assured (LCY)"
                ELSE
                    "Sums Assured" := ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Period Ended", "Currency Code",
                        "Sums Assured (LCY)", "Currency Factor"));
            end;
        }
        field(23; "Premium (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    Amount := "Premium (LCY)"
                ELSE
                    Amount := ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Period Ended", "Currency Code",
                        "Premium (LCY)", "Currency Factor"));
            end;
        }
        field(24; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
                VALIDATE("Sums Assured");
                VALIDATE("Sums Assured (LCY)");
                VALIDATE("Premium (LCY)");
            end;
        }
        field(25; "Claim Amount"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    "Claim Amount (LCY)" := "Claim Amount"
                ELSE
                    "Claim Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Claim Period Ended", "Currency Code",
                        "Claim Amount", "Currency Factor"));
            end;
        }
        field(26; "Claim Amount (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin
                /*GetCurrency;
                
                IF "Currency Code" = '' THEN
                 "Sums Assured":=  "Sums Assured (LCY)"
                ELSE
                  "Sums Assured" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Period Ended","Currency Code",
                      "Sums Assured (LCY)","Currency Factor"));
                */

            end;
        }
        field(27; "Claim Period Ended"; Date)
        {
        }
        field(28; "Currency Factor1"; Decimal)
        {
            Caption = 'Currency Factor1';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin

                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                //VALIDATE(Premium,"Sum Assured");
                VALIDATE("Claim Amount");
            end;
        }
    }

    keys
    {
        key(Key1; "Member No.")
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

