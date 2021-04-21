table 51513322 "Prem Risk Schedule"
{
    // version AES-INS 1.0


    fields
    {
        field(1; Year; Integer)
        {
        }
        field(2; "Amount at Risk"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Amount at Risk (LCY)" := "Amount at Risk"
                ELSE
                    "Amount at Risk (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Amount at Risk", "Currency Factor"));
            end;
        }
        field(3; Age; Integer)
        {
        }
        field(4; "Basic Premium"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Basic Premium (LCY)" := "Basic Premium"
                ELSE
                    "Basic Premium (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Basic Premium", "Currency Factor"));
            end;
        }
        field(5; "Additional Premium"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Additional Premium (LCY)" := "Additional Premium"
                ELSE
                    "Additional Premium (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Additional Premium", "Currency Factor"));
            end;
        }
        field(6; "Policy No"; Code[30])
        {
        }
        field(7; "Cedant Code"; Code[10])
        {
            TableRelation = Customer WHERE(Type = CONST(Cedant));

            trigger OnValidate();
            begin
                /* IF Cedants.GET("Cedant Code") THEN
                     "Cedant Name":=Cedants.Name;
                 */

            end;
        }
        field(8; "Apportioned Premium"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details".Amount WHERE(Year = FIELD(Year),
                                                                      Cedant = FIELD("Cedant Code"),
                                                                      "Policy Number" = FIELD("Policy No"),
                                                                      "Policy Type" = FIELD("Policy Type"),
                                                                      "Policy Code" = FIELD("Policy Code"),
                                                                      Retro = CONST(false)));
            FieldClass = FlowField;
        }
        field(9; "Renewal Date"; Date)
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
        field(11; "Amount at Risk (LCY)"; Decimal)
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
        field(12; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE("Basic Premium");
                VALIDATE("Amount at Risk");
                VALIDATE("Additional Premium");
                VALIDATE("SA Retention");
                VALIDATE("Premium Retention");
                VALIDATE("Retroceeded SA");
                VALIDATE("Retroceeded Premium");
                VALIDATE("Premium Refund");
                VALIDATE("Kenya Re Premium Refund");
            end;
        }
        field(13; "Basic Premium (LCY)"; Decimal)
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
        field(14; "Additional Premium (LCY)"; Decimal)
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
                      "Premium (LCY)","Currency Factor"));*/

            end;
        }
        field(15; "Period Ended"; Date)
        {
        }
        field(16; "Apportioned Premium (LCY)"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Premium (LCY)" WHERE(Year = FIELD(Year),
                                                                               Cedant = FIELD("Cedant Code"),
                                                                               "Policy Number" = FIELD("Policy No"),
                                                                               "Policy Type" = FIELD("Policy Type"),
                                                                               "Policy Code" = FIELD("Policy Code"),
                                                                               Retro = CONST(false)));
            FieldClass = FlowField;
        }
        field(17; Status; Option)
        {
            OptionCaption = 'Active,Lapsed,Cancelled,Claimed';
            OptionMembers = Active,Lapsed,Cancelled,Claimed;
        }
        field(18; "Status Date"; Date)
        {
        }
        field(19; Select; Boolean)
        {
        }
        field(20; Posted; Boolean)
        {
        }
        field(21; "Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(22; "Posting Date"; Date)
        {
        }
        field(23; "Posting Time"; Time)
        {
        }
        field(24; "Reinsurance Code"; Code[10])
        {
        }
        field(25; "Kenya Re Premium"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details".Amount WHERE(Year = FIELD(Year),
                                                                      Cedant = FIELD("Cedant Code"),
                                                                      "Policy Number" = FIELD("Policy No"),
                                                                      "Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                      "Policy Type" = FIELD("Policy Type"),
                                                                      "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(26; "Kenya Re Premium (LCY)"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Premium (LCY)" WHERE(Year = FIELD(Year),
                                                                               Cedant = FIELD("Cedant Code"),
                                                                               "Policy Number" = FIELD("Policy No"),
                                                                               "Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                               "Policy Type" = FIELD("Policy Type"),
                                                                               "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(27; "Posted Premium"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE(Year = FIELD(Year),
                                                        Individual = CONST(true),
                                                        "Policy Number" = FIELD("Policy No"),
                                                        Reversed = CONST(false),
                                                        Amount = FILTER(> 0),
                                                        "Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Premium),
                                                        Retro = CONST(false)));
            FieldClass = FlowField;
        }
        field(28; "Apportioned Amount at Risk"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Sums Assured" WHERE(Year = FIELD(Year),
                                                                              Cedant = FIELD("Cedant Code"),
                                                                              "Policy Number" = FIELD("Policy No"),
                                                                              "Policy Type" = FIELD("Policy Type"),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              Retro = CONST(false)));
            FieldClass = FlowField;
        }
        field(29; "Aportioned Amount at Risk(LCY)"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Sums Assured (LCY)" WHERE(Year = FIELD(Year),
                                                                                    Cedant = FIELD("Cedant Code"),
                                                                                    "Policy Number" = FIELD("Policy No"),
                                                                                    "Policy Type" = FIELD("Policy Type"),
                                                                                    "Policy Code" = FIELD("Policy Code"),
                                                                                    Retro = CONST(false)));
            FieldClass = FlowField;
        }
        field(30; "Kenya Re Amount at Risk"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Sums Assured" WHERE(Year = FIELD(Year),
                                                                              Cedant = FIELD("Cedant Code"),
                                                                              "Policy Number" = FIELD("Policy No"),
                                                                              "Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                              "Policy Type" = FIELD("Policy Type"),
                                                                              "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(31; "Kenya Re Amount at Risk (LCY)"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Sums Assured (LCY)" WHERE(Year = FIELD(Year),
                                                                                    Cedant = FIELD("Cedant Code"),
                                                                                    "Policy Number" = FIELD("Policy No"),
                                                                                    "Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                    "Policy Type" = FIELD("Policy Type"),
                                                                                    "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(32; "SA Retention"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "SA Retention (LCY)" := "SA Retention"
                ELSE
                    "SA Retention (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "SA Retention", "Currency Factor"));
            end;
        }
        field(33; "SA Retention (LCY)"; Decimal)
        {
        }
        field(34; "Premium Retention"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Premium Retention (LCY)" := "Premium Retention"
                ELSE
                    "Premium Retention (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Premium Retention", "Currency Factor"));
            end;
        }
        field(35; "Premium Retention (LCY)"; Decimal)
        {
        }
        field(36; "Retroceeded SA"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Retroceeded SA (LCY)" := "Retroceeded SA"
                ELSE
                    "Retroceeded SA (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Retroceeded SA", "Currency Factor"));
            end;
        }
        field(37; "Retroceeded SA (LCY)"; Decimal)
        {
        }
        field(38; "Retroceeded Premium"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Retroceeded Premium (LCY)" := "Retroceeded Premium"
                ELSE
                    "Retroceeded Premium (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Retroceeded Premium", "Currency Factor"));
            end;
        }
        field(39; "Retroceeded Premium (LCY)"; Decimal)
        {
        }
        field(40; "Retro Posted"; Boolean)
        {
        }
        field(41; "Retro Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(42; "Retro Posting Date"; Date)
        {
        }
        field(43; "Retro Posting Time"; Time)
        {
        }
        field(44; Retroceeded; Boolean)
        {
        }
        field(46; "Premium Refund"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Premium Refund  (LCY)" := "Premium Refund"
                ELSE
                    "Premium Refund  (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Premium Refund", "Currency Factor"));
            end;
        }
        field(47; "Premium Refund  (LCY)"; Decimal)
        {
        }
        field(48; "Lapse Date"; Date)
        {
        }
        field(49; "Date Cancelled"; Date)
        {
        }
        field(50; "Claim Date"; Date)
        {
        }
        field(51; "Status Period Ended"; Date)
        {
        }
        field(52; "Kenya Re Premium Refund"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details".Refund WHERE(Year = FIELD(Year),
                                                                      Cedant = FIELD("Cedant Code"),
                                                                      "Policy Number" = FIELD("Policy No"),
                                                                      "Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                      "Policy Type" = FIELD("Policy Type"),
                                                                      "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Kenya Re Premium Refund  (LCY)" := "Kenya Re Premium Refund"
                ELSE
                    "Premium Refund  (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Kenya Re Premium Refund", "Currency Factor"));
            end;
        }
        field(53; "Kenya Re Premium Refund  (LCY)"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Refund (LCY)" WHERE(Year = FIELD(Year),
                                                                              Cedant = FIELD("Cedant Code"),
                                                                              "Policy Number" = FIELD("Policy No"),
                                                                              "Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                              "Policy Type" = FIELD("Policy Type"),
                                                                             "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(54; "Apportioned Refund"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details".Refund WHERE(Year = FIELD(Year),
                                                                      Cedant = FIELD("Cedant Code"),
                                                                      "Policy Number" = FIELD("Policy No"),
                                                                      "Policy Type" = FIELD("Policy Type"),
                                                                      "Policy Code" = FIELD("Policy Code"),
                                                                      Retro = CONST(false)));
            FieldClass = FlowField;
        }
        field(55; "Apportioned Refund (LCY)"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Refund (LCY)" WHERE(Year = FIELD(Year),
                                                                              Cedant = FIELD("Cedant Code"),
                                                                              "Policy Number" = FIELD("Policy No"),
                                                                              "Policy Type" = FIELD("Policy Type"),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              Retro = CONST(false)));
            FieldClass = FlowField;
        }
        field(56; "Refund Posted"; Boolean)
        {
        }
        field(57; "Refund Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(58; "Refund Posting Date"; Date)
        {
        }
        field(59; "Refund Posting Time"; Time)
        {
        }
        field(60; "Premium Year"; Integer)
        {
        }
        field(61; "Risk Rate"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(62; "Premium Rate"; Decimal)
        {
        }
        field(63; "Policy Type"; Option)
        {
            OptionCaption = '" ,Main Policy,Supplimentary"';
            OptionMembers = " ","Main Policy",Supplimentary;
        }
        field(64; "Policy Code"; Code[10])
        {
        }
        field(65; "New/Renewal"; Option)
        {
            OptionCaption = '" ,N,R"';
            OptionMembers = " ",New,Renewal;
        }
        field(66; "Cover Year End Date"; Date)
        {
        }
        field(67; "KRE Cedant Commission"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Cedant Commission" WHERE(Year = FIELD(Year),
                                                                                   Cedant = FIELD("Cedant Code"),
                                                                                   "Policy Number" = FIELD("Policy No"),
                                                                                   "Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                   "Policy Type" = FIELD("Policy Type"),
                                                                                   "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(69; "KRE Broker Commission"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Broker Commission" WHERE(Year = FIELD(Year),
                                                                                   Cedant = FIELD("Cedant Code"),
                                                                                   "Policy Number" = FIELD("Policy No"),
                                                                                   "Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                   "Policy Type" = FIELD("Policy Type"),
                                                                                   "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(70; "KRE Cedant  Refund Commission"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Cedant Refund Commission" WHERE(Year = FIELD(Year),
                                                                                          Cedant = FIELD("Cedant Code"),
                                                                                          "Policy Number" = FIELD("Policy No"),
                                                                                          "Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                          "Policy Type" = FIELD("Policy Type"),
                                                                                          "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(71; "KRE Broker  Refund Commission"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Broker Refund Commission" WHERE(Year = FIELD(Year),
                                                                                          Cedant = FIELD("Cedant Code"),
                                                                                          "Policy Number" = FIELD("Policy No"),
                                                                                          "Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                          "Policy Type" = FIELD("Policy Type"),
                                                                                          "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(72; "Posted Commission"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE(Year = FIELD(Year),
                                                        Individual = CONST(true),
                                                        "Policy Number" = FIELD("Policy No"),
                                                        Reversed = CONST(false),
                                                        Amount = FILTER(> 0),
                                                        "Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Commission),
                                                        Retro = CONST(false)));
            FieldClass = FlowField;
        }
        field(73; "Retro Refund Posted"; Boolean)
        {
        }
        field(74; "Retro Refund Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(75; "Retro Refund Posting Date"; Date)
        {
        }
        field(76; "Retro Refund Posting Time"; Time)
        {
        }
        field(77; "Retro Refund Premium"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details".Refund WHERE(Year = FIELD(Year),
                                                                      Cedant = FIELD("Cedant Code"),
                                                                      "Policy Number" = FIELD("Policy No"),
                                                                      "Policy Type" = FIELD("Policy Type"),
                                                                      "Policy Code" = FIELD("Policy Code"),
                                                                      Retro = CONST(true)));
            FieldClass = FlowField;
        }
        field(78; "Retro Refund Premium (LCY)"; Decimal)
        {
        }
        field(79; "Retro Refund Comm"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Cedant Refund Commission" WHERE(Year = FIELD(Year),
                                                                                          Cedant = FIELD("Cedant Code"),
                                                                                          "Policy Number" = FIELD("Policy No"),
                                                                                          "Policy Type" = FIELD("Policy Type"),
                                                                                          "Policy Code" = FIELD("Policy Code"),
                                                                                          Retro = CONST(true)));
            FieldClass = FlowField;
        }
        field(80; "Retro Refund Comm (LCY)"; Decimal)
        {
        }
        field(81; "KRE Retro Commission"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Cedant Commission" WHERE(Year = FIELD(Year),
                                                                                   Cedant = FIELD("Cedant Code"),
                                                                                   "Policy Number" = FIELD("Policy No"),
                                                                                   "Policy Type" = FIELD("Policy Type"),
                                                                                   "Policy Code" = FIELD("Policy Code"),
                                                                                   Retro = CONST(true)));
            FieldClass = FlowField;
        }
        field(82; "Posted Retro Premium"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE(Year = FIELD(Year),
                                                        Individual = CONST(true),
                                                        "Policy Number" = FIELD("Policy No"),
                                                        Reversed = CONST(false),
                                                        Amount = FILTER(> 0),
                                                        "Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Premium),
                                                        Retro = CONST(true)));
            FieldClass = FlowField;
        }
        field(83; "Posted Retro Commission"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE(Year = FIELD(Year),
                                                        Individual = CONST(true),
                                                        "Policy Number" = FIELD("Policy No"),
                                                        Reversed = CONST(false),
                                                        Amount = FILTER(> 0),
                                                        "Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Commission),
                                                        Retro = CONST(true)));
            FieldClass = FlowField;
        }
        field(84; "Treaty Code"; Code[30])
        {
            TableRelation = Treaty;

            trigger OnValidate();
            begin
                /*
                 IF TreatyDetails.GET("Treaty Code","Cedant Code") THEN
                "Treaty Description":=TreatyDetails."Short Name";
                "Current Retention":=(TreatyDetails."Reinsurance Commission (%)"/100)*"Sum Assured";
                "Sum reinsured":="Sum Assured"-"Current Retention";
                "Annual Premium":="Sum Assured"*(TreatyDetails."Premium Rate (%)"/100);
                "Retention Premium":="Annual Premium"*((100-TreatyDetails."Reinsurance Commission (%)")/100);
                "Reinsurance Premium":="Annual Premium"*(TreatyDetails."Reinsurance Commission (%)"/100);
                "Ret. add. benefits premium":="Additional Benefits Premium"*((100-TreatyDetails."Reinsurance Commission (%)")/100);
                "Ceded add. Ben. Premium":="Additional Benefits Premium"* (TreatyDetails."Reinsurance Commission (%)"/100);
               */

            end;
        }
        field(85; "Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code";
        }
        field(86; "Reinstatement Premium"; Decimal)
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
        field(87; "Reinstatement Premium (LCY)"; Decimal)
        {
        }
        field(88; "Reinstatement Date"; Date)
        {
        }
        field(89; Reinstated; Boolean)
        {
        }
        field(90; "Reinstatement Period Ended"; Date)
        {
        }
        field(91; "Cedant Commission"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Cedant Commission" WHERE(Year = FIELD(Year),
                                                                                   Cedant = FIELD("Cedant Code"),
                                                                                   "Policy Number" = FIELD("Policy No"),
                                                                                   "Policy Type" = FIELD("Policy Type"),
                                                                                   "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(92; "Broker Commission"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Broker Commission" WHERE(Year = FIELD(Year),
                                                                                   Cedant = FIELD("Cedant Code"),
                                                                                   "Policy Number" = FIELD("Policy No"),
                                                                                   "Policy Type" = FIELD("Policy Type"),
                                                                                   "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(93; "Cedant  Refund Commission"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Cedant Refund Commission" WHERE(Year = FIELD(Year),
                                                                                          Cedant = FIELD("Cedant Code"),
                                                                                          "Policy Number" = FIELD("Policy No"),
                                                                                          "Policy Type" = FIELD("Policy Type"),
                                                                                          "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(94; "Broker  Refund Commission"; Decimal)
        {
            CalcFormula = Sum("Reassurance App Details"."Broker Refund Commission" WHERE(Year = FIELD(Year),
                                                                                          Cedant = FIELD("Cedant Code"),
                                                                                          "Policy Number" = FIELD("Policy No"),
                                                                                          "Policy Type" = FIELD("Policy Type"),
                                                                                          "Policy Code" = FIELD("Policy Code")));
            FieldClass = FlowField;
        }
        field(95; Compulsory; Boolean)
        {
        }
        field(97; "Cedant Commission1"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Cedant Commission1 (LCY)" := "Cedant Commission1"
                ELSE
                    "Cedant Commission1 (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Cedant Commission1", "Currency Factor"));
            end;
        }
        field(98; "Cedant Commission1 %"; Decimal)
        {
        }
        field(99; "Cedant Commission1 (LCY)"; Decimal)
        {
        }
        field(100; "Renewal Treaty Code"; Code[30])
        {
            TableRelation = Treaty;

            trigger OnValidate();
            begin
                /*
                 IF TreatyDetails.GET("Treaty Code","Cedant Code") THEN
                "Treaty Description":=TreatyDetails."Short Name";
                "Current Retention":=(TreatyDetails."Reinsurance Commission (%)"/100)*"Sum Assured";
                "Sum reinsured":="Sum Assured"-"Current Retention";
                "Annual Premium":="Sum Assured"*(TreatyDetails."Premium Rate (%)"/100);
                "Retention Premium":="Annual Premium"*((100-TreatyDetails."Reinsurance Commission (%)")/100);
                "Reinsurance Premium":="Annual Premium"*(TreatyDetails."Reinsurance Commission (%)"/100);
                "Ret. add. benefits premium":="Additional Benefits Premium"*((100-TreatyDetails."Reinsurance Commission (%)")/100);
                "Ceded add. Ben. Premium":="Additional Benefits Premium"* (TreatyDetails."Reinsurance Commission (%)"/100);
               */

            end;
        }
        field(101; "Renewal Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code";
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
        LifeReSetup: Record "Reinsurance Setup";
        Text002: Label 'cannot be specified without %1';

    procedure GetCurrency();
    begin
    end;
}

