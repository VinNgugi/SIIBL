table 51513315 "Grp Members Retro"
{

    fields
    {
        field(1; "Policy Code"; Code[30])
        {
        }
        field(2; "Member No"; Code[30])
        {
        }
        field(3; Name; Text[100])
        {
        }
        field(4; DOB; Date)
        {
        }
        field(5; Age; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(6; Sex; Option)
        {
            OptionCaption = '" ,Male,Female "';
            OptionMembers = " ",Male,Female;
        }
        field(7; "Sum Assured"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    "Sums Assured (LCY)" := "Sum Assured"
                ELSE
                    "Sums Assured (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Sum Assured", "Currency Factor"));
            end;
        }
        field(8; Premium; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    "Premium (LCY)" := Premium
                ELSE
                    "Premium (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        Premium, "Currency Factor"));
            end;
        }
        field(9; "Premium Rate"; Decimal)
        {
        }
        field(10; "No. of Months"; Decimal)
        {
        }
        field(11; "Treaty Code"; Code[30])
        {
            TableRelation = Treaty."Treaty Code";
        }
        field(12; "Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code";
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
        field(17; "Inception Date"; Date)
        {
        }
        field(18; "Currency Code"; Code[10])
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
                    /*
                     IF "Claim Period Ended"<>0D THEN
                     "Currency Factor1" :=
                      CurrExchRate.ExchangeRate("Claim Period Ended","Currency Code");
                     */
                END ELSE BEGIN
                    "Currency Factor" := 0;
                    // "Currency Factor1" := 0;
                    //MESSAGE('%1',"Currency Factor");
                    VALIDATE("Currency Factor");

                END;

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
        field(19; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin

                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                //VALIDATE(Premium,"Sum Assured");
                VALIDATE(Premium);
                VALIDATE("Sum Assured");
            end;
        }
        field(22; "Sums Assured (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    "Sums Assured (LCY)" := "Sum Assured"
                ELSE
                    "Sum Assured" := ROUND(
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
                    "Premium (LCY)" := Premium
                ELSE
                    Premium := ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Period Ended", "Currency Code",
                        "Premium (LCY)", "Currency Factor"));
            end;
        }
        field(24; "Retro No."; Code[50])
        {
        }
        field(25; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = true;
            TableRelation = "No. Series";
        }
        field(26; "Orig Treaty Code"; Code[30])
        {
            TableRelation = Treaty."Treaty Code";
        }
        field(27; "Orig Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code";
        }
        field(28; "Claim Amount"; Decimal)
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
        field(29; "Claim Amount (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin

                /*
                GetCurrency;
                
                IF "Currency Code" = '' THEN
                  "Sums Assured (LCY)" := "Sum Assured"
                ELSE
                  "Sum Assured" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Period Ended","Currency Code",
                      "Sums Assured (LCY)","Currency Factor"));
                
                */

            end;
        }
        field(30; "Claim Period Ended"; Date)
        {
        }
        field(31; "Currency Factor1"; Decimal)
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
        field(32; "Sum Reassured"; Decimal)
        {
        }
        field(33; "Commission Rate"; Decimal)
        {
            /*CalcFormula = Max("Grp Prem Apportionment".Field17320452 WHERE ("Policy Code"=FIELD("Policy Code"),
                                                                            "Product Code"=FIELD("Product Code"),
                                                                            "Lot No."=FIELD("Lot No."),
                                                                            Cedant=FIELD(Cedant),
                                                                            "Inception Date"=FIELD("Inception Date")));
            FieldClass = FlowField;*/
        }
        field(34; Commission; Decimal)
        {
        }
        field(35; "Commision (LCY)"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Policy Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        CurrExchRate: Record "Currency Exchange Rate";
        Cedants: Record Customer;
        Text002: Label 'cannot be specified without %1';
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure GetCurrency();
    begin
    end;
}

