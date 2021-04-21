table 51513313 "Member Prem Apportionment"
{

    fields
    {
        field(1; "Member No."; Code[30])
        {
        }
        field(2; "Insurer/Reassurer Code"; Code[10])
        {

            trigger OnValidate();
            begin
                IF Cedants.GET("Insurer/Reassurer Code") THEN
                    "Insurer/Reassurer Name" := Cedants.Name
                ELSE
                    IF Reinsurers.GET("Insurer/Reassurer Code") THEN
                        "Insurer/Reassurer Name" := Reinsurers.Name
                    ELSE
                        "Insurer/Reassurer Name" := '';
            end;
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
        field(18; "Member Name"; Text[200])
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
                VALIDATE("Premium (LCY)");
                VALIDATE("Sums Assured (LCY)");

                VALIDATE("Cedant Commission");
                VALIDATE("Broker Commission");
            end;
        }
        field(25; "Entry No."; Integer)
        {
            AutoIncrement = false;
        }
        field(26; "Cedant Commission"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Cedant Commission (LCY)" := "Cedant Commission"
                ELSE
                    "Cedant Commission (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Cedant Commission", "Currency Factor"));
            end;
        }
        field(27; "Broker Commission"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Broker Commission (LCY)" := "Broker Commission"
                ELSE
                    "Broker Commission (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Broker Commission", "Currency Factor"));
            end;
        }
        field(28; "Cedant Commission %"; Decimal)
        {
        }
        field(29; "Broker Commission %"; Decimal)
        {
        }
        field(30; "Cedant Commission (LCY)"; Decimal)
        {
        }
        field(31; "Broker Commission (LCY)"; Decimal)
        {
        }
        field(32; "Entry No2"; Integer)
        {
            AutoIncrement = false;
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
        Cedants: Record Customer;
        Reinsurers: Record Vendor;
        Text002: Label 'cannot be specified without %1';

    procedure GetCurrency();
    begin
    end;
}

