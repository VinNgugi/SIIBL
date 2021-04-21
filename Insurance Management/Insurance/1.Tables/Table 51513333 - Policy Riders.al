table 51513333 "Policy Riders"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Cedant Code"; Code[10])
        {
            //TableRelation = "Individual Life"."Cedant Code";
        }
        field(2; "Policy Number"; Code[30])
        {
            //TableRelation = "Individual Life"."Policy Number";
        }
        field(3; "Rider Code"; Code[30])
        {
            TableRelation = "Product Types"."product code" WHERE(rider = CONST(true));

            trigger OnValidate();
            begin
                IF Product.GET("Rider Code") THEN BEGIN
                    Description := Product.description;
                END;
            end;
        }
        field(4; Description; Code[100])
        {
        }
        field(5; "Sum Reassured"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Sum Reassured (LCY)" := "Sum Reassured"
                ELSE
                    "Sum Reassured (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Sum Reassured", "Currency Factor"));
            end;
        }
        field(6; "Sum Reassured (LCY)"; Decimal)
        {
        }
        field(7; Premium; Decimal)
        {

            trigger OnValidate();
            begin
                IF Premium = 0 THEN BEGIN
                    TESTFIELD("Premium Rate");
                    Premium := "Premium Rate" / 1000 * "Sum Reassured";
                END;


                GetCurrency;
                IF "Currency Code" = '' THEN BEGIN
                    "Premium (LCY)" := Premium
                END ELSE BEGIN
                    "Premium (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                       Premium, "Currency Factor"));
                END;
            end;
        }
        field(8; "Premium (LCY)"; Decimal)
        {
        }
        field(9; "Period Ended"; Date)
        {
        }
        field(10; "Currency Code"; Code[10])
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
        field(11; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE("Sum Reassured");
                //VALIDATE("Sum reinsured");
                //VALIDATE("Ceded add. Ben. Premium");
                //VALIDATE("Sums Assured (LCY)");
            end;
        }
        field(12; "Premium Rate"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Premium Rate" = 0 THEN BEGIN
                    "Premium Rate" := (Premium * 1000) / "Sum Reassured";
                END;
                VALIDATE(Premium);
            end;
        }
    }

    keys
    {
        key(Key1; "Cedant Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Product: Record "Product Types";
        TreatyVal: Record "LIFE Treaty";
        CurrExchRate: Record "Currency Exchange Rate";
        Text002: Label 'cannot be specified without %1';

    procedure GetCurrency();
    begin
    end;
}

