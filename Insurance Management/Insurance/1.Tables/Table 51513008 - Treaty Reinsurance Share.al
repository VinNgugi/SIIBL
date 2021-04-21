table 51513008 "Treaty Reinsurance Share"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Treaty Code"; Code[30])
        {
            TableRelation = Treaty."Treaty Code";
        }
        field(2; "Quota Share"; Boolean)
        {
        }
        field(3; Surplus; Boolean)
        {
        }
        field(4; Facultative; Boolean)
        {
        }
        field(5; "Excess of loss"; Boolean)
        {
        }
        field(6; "Re-insurer code"; Code[20])
        {
            /*TableRelation = Customer WHERE ("Customer Type"=CONST("Re-Insurance Company"));

            trigger OnValidate();
            begin
                 IF Reinsurer.GET("Re-insurer code") THEN
                 "Re-insurer Name":=Reinsurer.Name
                 ELSE
                 "Re-insurer Name":='';
            end;*/
        }
        field(7; "Re-insurer Name"; Text[100])
        {
        }
        field(8; "Percentage %"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                /*
                QuotaTotalPercent:=0;
                SurplusTotalPercent:=0;
                FuclultativeTotalPercent:=0;
                
                //Quota Share.
                IF "Qouta Share"=TRUE THEN BEGIN
                
                TreatyVal.GET("Treaty Code","Addendum Code");
                
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Qouta Share",TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                //ReassurerShare.SETRANGE(ReassurerShare.Rider,Rider);
                
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                QuotaTotalPercent:=QuotaTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF TreatyVal."Cedant quota percentage"+QuotaTotalPercent+"Percentage %">100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                END;
                
                
                //Surplus
                IF Surplus=TRUE THEN BEGIN
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare.Surplus,TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                //ReassurerShare.SETRANGE(ReassurerShare.Rider,Rider);
                
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                SurplusTotalPercent:=SurplusTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF SurplusTotalPercent+"Percentage %">100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                END;
                
                //Fucultative
                IF Facultative=TRUE THEN BEGIN
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare.Facultative,TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                //ReassurerShare.SETRANGE(ReassurerShare.Rider,Rider);
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                FuclultativeTotalPercent:=FuclultativeTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF FuclultativeTotalPercent+"Percentage %">100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                END;
                
                
                //Fucultative
                IF "Excess of loss"=TRUE THEN BEGIN
                TreatyVal.GET("Treaty Code","Addendum Code");
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Excess of loss",TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                //ReassurerShare.SETRANGE(ReassurerShare.Rider,Rider);
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                ExcessTotalPercent:=ExcessTotalPercent+ReassurerShare."Percentage %";
                
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF ExcessTotalPercent+"Percentage %">100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                
                //MESSAGE('%1',ExcessTotalPercent);
                
                Amount:=("Percentage %"/100)*TreatyVal."Minimum Premium Deposit(MDP)";
                "Currency Code":=TreatyVal."Currency Code";
                MODIFY;
                END;
                */

            end;
        }
        field(9; "Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code";
        }
        field(10; Blocked; Boolean)
        {
        }
        field(11; "QS Amount"; Decimal)
        {
        }
        field(12; "Surplus Amount"; Decimal)
        {
        }
        field(13; "Facultative Amount"; Decimal)
        {
        }
        field(14; Rider; Boolean)
        {
        }
        field(15; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                /*GetCurrency;
                IF "Currency Code" = '' THEN
                  "Premium (LCY)" := Amount
                ELSE
                  "Premium (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Period Ended","Currency Code",
                      Amount,"Currency Factor"));
                */

            end;
        }
        field(16; "Period Ended"; Date)
        {

            trigger OnValidate();
            begin
                //VALIDATE("Currency Code");
                //VALIDATE("Currency Factor");
            end;
        }
        field(19; "Sums Assured"; Decimal)
        {

            trigger OnValidate();
            begin
                /*GetCurrency;
                
                IF "Currency Code" = '' THEN
                  "Sums Assured (LCY)" := "Sums Assured"
                ELSE
                  "Sums Assured (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Period Ended","Currency Code",
                      "Sums Assured","Currency Factor"));
                */

            end;
        }
        field(21; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            begin
                /*
                
                IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
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
                /*
                IF "Currency Code" <> '' THEN BEGIN
                  GetCurrency;
                  IF ("Currency Code" <> xRec."Currency Code") OR
                     ("Period Ended" <> xRec."Period Ended") OR
                     (CurrFieldNo = FIELDNO("Currency Code")) OR
                     ("Currency Factor" = 0)
                  THEN
                    "Currency Factor" :=
                      CurrExchRate.ExchangeRate("Period Ended","Currency Code");
                END ELSE
                  "Currency Factor" := 0;
                VALIDATE("Currency Factor");
                
                
                 */
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
                /*
                
                GetCurrency;
                
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
                /*
                
                GetCurrency;
                
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
        field(24; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                /*IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                  FIELDERROR("Currency Factor",STRSUBSTNO(Text002,FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
                VALIDATE("Sums Assured");
                //VALIDATE("Premium (LCY)");
                //VALIDATE("Sums Assured (LCY)");
                */

            end;
        }
        field(25; Posted; Boolean)
        {
        }
        field(26; "Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(27; "Posting Date"; Date)
        {
        }
        field(28; "Posting Time"; Time)
        {
        }
        field(29; "% Of Remainder"; Decimal)
        {

            trigger OnValidate();
            begin
                /*
                //Quota Share.
                IF "Qouta Share"=TRUE THEN BEGIN
                
                TreatyVal.GET("Treaty Code","Addendum Code");
                
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Qouta Share",TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                //ReassurerShare.SETRANGE(ReassurerShare.Rider,Rider);
                
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                QuotaTotalPercent:=QuotaTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF QuotaTotalPercent+"Percentage %">100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                END;
                
                "Percentage %":=("% Of Remainder"/100)*(100-TreatyVal."Cedant quota percentage");
                VALIDATE("Percentage %");
                 */

            end;
        }
        field(30; "Indiv refund"; Decimal)
        {
        }
        field(31; "Indiv  cedant Commission"; Decimal)
        {
        }
        field(32; "Ind Broker Commision"; Decimal)
        {
        }
        field(33; "Reinsurance Ceded"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Re-insurer code"),
                                                                                 "Insurance Trans Type" = FILTER("Reinsurance Premium" | "Deposit Premium" | "XOL Adjustment Premium"),
                                                                                 "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(34; "Sums Insured"; Decimal)
        {
        }
        field(35; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(36; "Direct Premium"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = CONST(Premium),
                                                        "Posting Date" = FIELD("Date Filter")));

        }
        field(37; "Reinsurance Premium Tax"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = CONST("Reinsurance Premium Taxes"),
                                                        "Posting Date" = FIELD("Date Filter")));

        }
        field(38; "Commission Net of Taxes"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Re-insurer code"),
                                                                                 "Insurance Trans Type" = FILTER("Reinsurance Commission" | "Reinsurance Commission Taxes"),
                                                                                 "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Treaty Code", "Addendum Code", "Quota Share", Facultative, "Excess of loss", Surplus, "Re-insurer code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Reinsurer: Record Customer;
}

