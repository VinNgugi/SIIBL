table 51513329 "Reassurance App Details"
{
    // version AES-INS 1.0


    fields
    {
        field(1; Year; Integer)
        {
        }
        field(2; "Insurer/Reassurer Code"; Code[10])
        {

            trigger OnValidate();
            begin
                /*    IF Cedants.GET("Insurer/Reassurer Code") THEN
                   "Insurer/Reassurer Name":=Cedants.Name
                   ELSE IF Reinsurers.GET("Insurer/Reassurer Code") THEN
                   "Insurer/Reassurer Name":=Reinsurers.Name
                   ELSE
                   "Insurer/Reassurer Name":='';
                */

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
            end;
        }
        field(25; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(26; "Policy Number"; Code[30])
        {
            //TableRelation = "Individual Life"."Policy Number";
        }
        field(27; Posted; Boolean)
        {
        }
        field(28; "Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(29; "Posting Date"; Date)
        {
        }
        field(30; "Posting Time"; Time)
        {
        }
        field(31; Retro; Boolean)
        {
        }
        field(32; Refund; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Refund (LCY)" := Refund
                ELSE
                    "Premium (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Status Period Ended", "Currency Code",
                        Refund, "Currency Factor"));
            end;
        }
        field(33; "Refund (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin
                /*GetCurrency;
                
                IF "Currency Code" = '' THEN
                 Amount:=  "Premium (LCY)"
                ELSE
                  Amount := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Period Ended","Currency Code",
                      "Premium (LCY)","Currency Factor"));
                
                */

            end;
        }
        field(34; "Refund Posted"; Boolean)
        {
        }
        field(35; "Refund Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(36; "Refund Posting Date"; Date)
        {
        }
        field(37; "Refund Posting Time"; Time)
        {
        }
        field(38; "Policy Type"; Option)
        {
            OptionCaption = '" ,Main Policy,Supplimentary"';
            OptionMembers = " ","Main Policy",Supplimentary;
        }
        field(39; "Cedant Commission"; Decimal)
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
        field(40; "Broker Commission"; Decimal)
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
        field(41; "Cedant Commission %"; Decimal)
        {
        }
        field(42; "Broker Commission %"; Decimal)
        {
        }
        field(43; "Cedant Commission (LCY)"; Decimal)
        {
        }
        field(44; "Broker Commission (LCY)"; Decimal)
        {
        }
        field(45; "Cedant Refund Commission"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Cedant Refund Commission (LCY)" := "Cedant Refund Commission"
                ELSE
                    "Cedant Refund Commission (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Status Period Ended", "Currency Code",
                        "Cedant Refund Commission", "Currency Factor"));
            end;
        }
        field(46; "Broker Refund Commission"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Broker Refund Commission (LCY)" := "Broker Refund Commission"
                ELSE
                    "Broker Refund Commission (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Status Period Ended", "Currency Code",
                        "Broker Refund Commission", "Currency Factor"));
            end;
        }
        field(47; "Cedant Refund Commission (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin
                /*GetCurrency;
                IF "Currency Code" = '' THEN
                  "Cedant Commission (LCY)" := "Cedant Commission"
                ELSE
                  "Cedant Commission (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Period Ended","Currency Code",
                      "Cedant Commission","Currency Factor"));
                 */

            end;
        }
        field(48; "Broker Refund Commission (LCY)"; Decimal)
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
        field(49; "Status Period Ended"; Date)
        {
        }
        field(50; "Reinstatement Premium"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Reinstatement Premium (LCY)" := "Reinstatement Premium"
                ELSE
                    "Reinstatement Premium (LCY)" := ROUND(
                       CurrExchRate.ExchangeAmtFCYToLCY(
                         "Period Ended", "Currency Code",
                         "Reinstatement Premium", "Currency Factor"));
            end;
        }
        field(51; "Reinstatement Premium (LCY)"; Decimal)
        {
        }
        field(52; "Reinstatement Date"; Date)
        {
        }
        field(53; Reinstated; Boolean)
        {
        }
        field(54; "Reinstatement Period Ended"; Date)
        {
        }
        field(55; "Cedant Reinst Commission"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Cedant Reinst Commission (LCY)" := "Cedant Reinst Commission"
                ELSE
                    "Cedant Reinst Commission (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Reinstatement Period Ended", "Currency Code",
                        "Cedant Reinst Commission", "Currency Factor"));
            end;
        }
        field(56; "Broker Reinst Commission"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Broker Reinst Commission (LCY)" := "Broker Reinst Commission"
                ELSE
                    "Broker Reinst Commission (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Reinstatement Period Ended", "Currency Code",
                        "Broker Reinst Commission", "Currency Factor"));
            end;
        }
        field(57; "Cedant Reinst Commission (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin
                /*GetCurrency;
                IF "Currency Code" = '' THEN
                  "Cedant Commission (LCY)" := "Cedant Commission"
                ELSE
                  "Cedant Commission (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Period Ended","Currency Code",
                      "Cedant Commission","Currency Factor"));
                 */

            end;
        }
        field(58; "Broker Reinst Commission (LCY)"; Decimal)
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
        field(59; Compulsory; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; Year)
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

