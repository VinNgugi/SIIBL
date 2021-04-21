table 51513321 "Individual Life"
{

    fields
    {
        field(1; "KRC No"; Code[30])
        {

            trigger OnValidate();
            begin
                /*
                
                
                IF "KRC No" <> xRec."KRC No" THEN BEGIN
                  SalesSetup.GET;
                  NoSeriesMgt.TestManual(SalesSetup."KRC Nos.");
                  "No. Series" := '';
                END;
                
                
                 */

            end;
        }
        field(2; "Policy Number"; Code[30])
        {

            trigger OnValidate();
            begin
                PremiumRiskSchedule.RESET;
                PremiumRiskSchedule.SETRANGE(PremiumRiskSchedule."Cedant Code", "Cedant Code");
                PremiumRiskSchedule.SETRANGE(PremiumRiskSchedule."Policy No", "Policy Number");
                //PremiumRiskSchedule.SETRANGE(PremiumRiskSchedule."Posted?",TRUE);

                IF PremiumRiskSchedule.FINDFIRST THEN
                    ERROR('You cannot modify this record because there are some entries in the premium risk schedule');
            end;
        }
        field(3; Surname; Text[100])
        {
        }
        field(4; "Other Names"; Text[100])
        {
        }
        field(5; "Lp no (Ref No)"; Code[30])
        {
        }
        field(6; "Other Policies"; Text[100])
        {
        }
        field(7; "Client No"; Code[30])
        {
        }
        field(8; "Policy Code"; Code[30])
        {
            TableRelation = "Period Table".Code;
        }
        field(9; "Term (Years)"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate();
            begin
                "No. of Premiums" := "Term (Years)";
            end;
        }
        field(10; "Date of Birth"; Date)
        {

            trigger OnValidate();
            begin


                /*IF "Date of Birth"<>0D THEN
                "Age Next Birthday":=DATE2DMY(WORKDATE,3)-DATE2DMY("Date of Birth",3);
                 */

            end;
        }
        field(11; "Commencement Date"; Date)
        {

            trigger OnValidate();
            begin
                "Cover Start Year" := DATE2DMY("Commencement Date", 3);

                IF Compulsory = FALSE THEN BEGIN

                    TESTFIELD("Cedant Code");


                    TreatyVal.RESET;
                    TreatyVal.SETRANGE(TreatyVal."Ceding office", "Cedant Code");
                    TreatyVal.SETRANGE(TreatyVal.Type, TreatyVal.Type::"Individual Life");
                    TreatyVal.SETRANGE(TreatyVal."Treaty Status", TreatyVal."Treaty Status"::Accepted);

                    TreatyVal.SETFILTER(TreatyVal."Effective date", '<=%1', "Commencement Date");
                    TreatyVal.SETFILTER(TreatyVal."Expiry Date", '>=%1', "Commencement Date");

                    IF TreatyVal.FIND('-') THEN BEGIN
                        REPEAT
                            IF ("Commencement Date" IN [TreatyVal."Effective date" .. TreatyVal."Expiry Date"]) //OR
                                                                                                                //("Period Ended" IN [TreatyVal."Effective date"..0D])
                            THEN BEGIN

                                //MESSAGE('%1',TreatyVal."Treaty Code");
                                "Treaty Code" := TreatyVal."Treaty Code";
                                "Addendum Code" := TreatyVal."Addendum Code";
                                //MODIFY;

                            END;
                        UNTIL TreatyVal.NEXT = 0;
                    END ELSE BEGIN

                        ERROR('%1%2%3', 'There is No individual life treaty for cedant ', "Cedant Code", ' for this period.Please Confirm!!');
                    END;
                    /*
                    TreatyVal.RESET;
                    TreatyVal.SETRANGE(TreatyVal."Treaty Type",TreatyVal."Treaty Type"::Retrocession);
                    TreatyVal.SETRANGE(TreatyVal.Type,TreatyVal.Type::"Individual Life");
                    TreatyVal.SETRANGE(TreatyVal."Treaty Status",TreatyVal."Treaty Status"::Accepted);

                    TreatyVal.SETFILTER(TreatyVal."Effective date",'<=%1',"Commencement Date");
                    TreatyVal.SETFILTER(TreatyVal."Expiry Date",'>=%1',"Commencement Date");

                    IF TreatyVal.FIND('-') THEN BEGIN
                    REPEAT
                    IF ("Commencement Date" IN [TreatyVal."Effective date"..TreatyVal."Expiry Date"]) //OR
                    //("Period Ended" IN [TreatyVal."Effective date"..0D])
                    THEN BEGIN

                    //MESSAGE('%1',TreatyVal."Treaty Code");
                    "Retro Treaty":=TreatyVal."Treaty Code";
                    "Retro Addendum":=TreatyVal."Addendum Code";
                    //MODIFY;

                    END;
                    UNTIL TreatyVal.NEXT=0;
                    END ELSE BEGIN

                    ERROR('%1%2%3','There is No individual life retrocession treaty for cedant ',
                    "Reinsurance Code",' for this period.Please Confirm!!');
                    END;
                    */

                END;


                IF Compulsory = TRUE THEN BEGIN
                    //TESTFIELD("Cedant Code");



                    TreatyVal.RESET;
                    //TreatyVal.SETRANGE(TreatyVal."Ceding office","Cedant Code");
                    TreatyVal.SETRANGE(TreatyVal.Type, TreatyVal.Type::"Compulsory Cession");
                    TreatyVal.SETFILTER(TreatyVal."Effective date", '<=%1', "Commencement Date");
                    TreatyVal.SETFILTER(TreatyVal."Expiry Date", '>=%1', "Commencement Date");

                    IF TreatyVal.FIND('-') THEN BEGIN
                        REPEAT
                            IF ("Commencement Date" IN [TreatyVal."Effective date" .. TreatyVal."Expiry Date"]) //OR
                                                                                                                //("Period Ended" IN [TreatyVal."Effective date"..0D])
                            THEN BEGIN

                                //MESSAGE('%1',TreatyVal."Treaty Code");
                                "Treaty Code" := TreatyVal."Treaty Code";
                                "Addendum Code" := TreatyVal."Addendum Code";
                                //MODIFY;

                            END;
                        UNTIL TreatyVal.NEXT = 0;
                    END ELSE BEGIN

                        ERROR('%1%2%3', 'There is No Compulsory cession treaty for this period.Please Confirm!!');
                    END;

                    IF "Age Next Birthday" = 0 THEN BEGIN

                        "Age Next Birthday" := DATE2DMY("Commencement Date", 3) - DATE2DMY("Date of Birth", 3) + 1;
                        //MESSAGE('%1',"Age Next Birthday");
                    END;

                END;

            end;
        }
        field(12; "Age Next Birthday"; Integer)
        {
        }
        field(13; "Sum Assured"; Decimal)
        {

            trigger OnValidate();
            begin
                //"Sum reinsured":="Sum Assured"-"Current Retention";

                GetCurrency;
                IF "Currency Code" = '' THEN BEGIN
                    "Sums Assured (LCY)" := "Sum Assured"
                END ELSE BEGIN
                    "Sum Reinsured (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                       "Sum Assured", "Currency Factor"));
                END;


                TESTFIELD("Treaty Code");
                //TESTFIELD("Addendum Code");

                IF Compulsory = FALSE THEN BEGIN

                    IF TreatyVal.GET("Treaty Code", "Addendum Code") THEN BEGIN

                        IF TreatyVal.Surplus = TRUE THEN BEGIN

                            //MESSAGE('hapo');
                            //IF "Sum Assured">TreatyVal."Quota share Retention" THEN BEGIN
                            "Sum reinsured" := "Sum Assured" - (TreatyVal."Quota share Retention" - "Previous Retention");
                            "Current Retention" := TreatyVal."Quota share Retention" - "Previous Retention";
                            // MODIFY;
                            IF "Sum reinsured" < 0 THEN
                                "Sum reinsured" := 0;
                            //MODIFY;
                            VALIDATE("Sum reinsured");
                            //END;
                        END;
                    END;

                END;



                IF Compulsory = TRUE THEN BEGIN


                    IF TreatyVal.GET("Treaty Code", "Addendum Code") THEN BEGIN

                        IF TreatyVal."Quota Share" = TRUE THEN BEGIN

                            //MESSAGE('hapo');
                            //IF "Sum Assured">TreatyVal."Quota share Retention" THEN BEGIN
                            "Current Retention" := TreatyVal."Cedant quota percentage" / 100 * "Sum Assured";

                            "Sum reinsured" := "Sum Assured" - "Current Retention";

                            IF "Sum reinsured" < 0 THEN
                                "Sum reinsured" := 0;
                            //MODIFY;
                            VALIDATE("Sum reinsured");
                            //END;
                        END;
                    END;

                END;
            end;
        }
        field(14; "Annual Premium"; Decimal)
        {
        }
        field(15; "Current Retention"; Decimal)
        {

            trigger OnValidate();
            begin
                //"Sum reinsured":="Sum Assured"-"Current Retention";
            end;
        }
        field(16; "Previous Retention"; Decimal)
        {

            trigger OnValidate();
            begin
                VALIDATE("Sum Assured");
            end;
        }
        field(17; "Treaty Limit"; Decimal)
        {
        }
        field(18; "Sum reinsured"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Sum Reinsured (LCY)" := "Sum reinsured"
                ELSE
                    "Sum Reinsured (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Sum reinsured", "Currency Factor"));
            end;
        }
        field(19; "Facultative Amount"; Decimal)
        {
        }
        field(20; "Sum reinsured (AI)"; Decimal)
        {
        }
        field(21; "Rate (AI)"; Decimal)
        {
        }
        field(22; "Sum Reinsured (AX)"; Decimal)
        {
        }
        field(23; "Rate (AX)"; Decimal)
        {
        }
        field(24; "Sum reinsured(WP)"; Decimal)
        {
        }
        field(25; "Rate (WP)"; Decimal)
        {
        }
        field(26; "Acceptance Terms"; Decimal)
        {
        }
        field(27; "ADB premium"; Decimal)
        {
        }
        field(28; "Policy Class"; Code[30])
        {
            TableRelation = "Table Types".Type WHERE("Table Type" = CONST("Amount At Risk"));
        }
        field(29; "Policy Class Description"; Text[100])
        {
        }
        field(30; "No. of Premiums"; Integer)
        {
        }
        field(31; "Basic Premium"; Decimal)
        {
        }
        field(32; "Initial Commission (%)"; Decimal)
        {
        }
        field(33; "Renewal Commission"; Decimal)
        {
        }
        field(34; "Term of Policy"; Integer)
        {
        }
        field(35; "Retention Premium"; Decimal)
        {
        }
        field(36; "Reinsurance Premium"; Decimal)
        {
        }
        field(37; "Treaty Code"; Code[30])
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
        field(38; "Treaty Description"; Text[100])
        {
        }
        field(39; "Additional Benefits Premium"; Decimal)
        {
        }
        field(40; "Ret. add. benefits premium"; Decimal)
        {
        }
        field(41; "Ceded add. Ben. Premium"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "Additional Benefit (LCY)" := "Ceded add. Ben. Premium"
                ELSE
                    "Additional Benefit (LCY)" := ROUND(
                       CurrExchRate.ExchangeAmtFCYToLCY(
                         "Period Ended", "Currency Code",
                         "Ceded add. Ben. Premium", "Currency Factor"));
            end;
        }
        field(42; "Cover Start Year"; Integer)
        {
        }
        field(43; "Transaction Date"; Date)
        {
        }
        field(44; "Renewal Month"; Code[10])
        {
        }
        field(45; "Company Code"; Code[20])
        {
            TableRelation = Customer;
        }
        field(46; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(47; "Cedant Code"; Code[10])
        {
            TableRelation = Customer WHERE(Type = CONST(Cedant));

            trigger OnValidate();
            begin
                IF Cedants.GET("Cedant Code") THEN
                    "Cedant Name" := Cedants.Name;
            end;
        }
        field(48; "Cedant Name"; Text[100])
        {

            trigger OnValidate();
            begin
                PremiumRiskSchedule.RESET;
                PremiumRiskSchedule.SETRANGE(PremiumRiskSchedule."Cedant Code", "Cedant Code");
                PremiumRiskSchedule.SETRANGE(PremiumRiskSchedule."Policy No", "Policy Number");
                //PremiumRiskSchedule.SETRANGE(PremiumRiskSchedule."Posted?",TRUE);

                IF PremiumRiskSchedule.FINDFIRST THEN
                    ERROR('You cannot modify this record because there are some entries in the premium risk schedule');
            end;
        }
        field(49; "New/Renewal Business"; Option)
        {
            OptionMembers = N,R;
        }
        field(50; "Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code";
        }
        field(51; "Premium Rate Code"; Code[20])
        {
            TableRelation = "Table Types".Type WHERE("Table Type" = CONST(Premium));
        }
        field(52; "New/Revewal"; Option)
        {
            OptionCaption = 'New,Renewal';
            OptionMembers = New,Renewal;
        }
        field(53; "Schedule Processed"; Boolean)
        {
        }
        field(54; "Period Ended"; Date)
        {

            trigger OnValidate();
            begin

                Months := DATE2DMY("Commencement Date", 2);

                IF (Months = 1) OR (Months = 2) OR (Months = 3) THEN BEGIN

                    //PeriodEnded:='3103'+FORMAT("Cover Start Year")+'D';

                    //"Period Ended":=format(PeriodEnded);

                    d := 31;
                    m := 3;
                    y := "Cover Start Year";


                    "Period Ended" := DMY2DATE(d, m, y);

                END;

                IF (Months = 4) OR (Months = 5) OR (Months = 6) THEN BEGIN

                    //PeriodEnded:='3103'+FORMAT("Cover Start Year")+'D';

                    //"Period Ended":=format(PeriodEnded);

                    d := 30;
                    m := 6;
                    y := "Cover Start Year";

                    "Period Ended" := DMY2DATE(d, m, y);

                END;

                IF (Months = 7) OR (Months = 8) OR (Months = 9) THEN BEGIN

                    //PeriodEnded:='3103'+FORMAT("Cover Start Year")+'D';

                    //"Period Ended":=format(PeriodEnded);

                    d := 30;
                    m := 9;
                    y := "Cover Start Year";

                    "Period Ended" := DMY2DATE(d, m, y);

                END;

                IF (Months = 10) OR (Months = 11) OR (Months = 12) THEN BEGIN

                    //PeriodEnded:='3103'+FORMAT("Cover Start Year")+'D';

                    //"Period Ended":=format(PeriodEnded);

                    d := 31;
                    m := 12;
                    y := "Cover Start Year";

                    "Period Ended" := DMY2DATE(d, m, y);

                END;



                /*
                
                TESTFIELD("Cedant Code");
                
                TreatyVal.RESET;
                TreatyVal.SETRANGE(TreatyVal."Ceding office","Cedant Code");
                TreatyVal.SETRANGE(TreatyVal.Type,TreatyVal.Type::"Individual Life");
                TreatyVal.SETFILTER(TreatyVal."Effective date",'<=%1',"Period Ended");
                TreatyVal.SETFILTER(TreatyVal."Expiry Date",'>=%1',"Period Ended");
                
                IF TreatyVal.FIND('-') THEN BEGIN
                REPEAT
                IF ("Period Ended" IN [TreatyVal."Effective date"..TreatyVal."Expiry Date"]) //OR
                //("Period Ended" IN [TreatyVal."Effective date"..0D])
                THEN BEGIN
                
                //MESSAGE('%1',TreatyVal."Treaty Code");
                "Treaty Code":=TreatyVal."Treaty Code";
                "Addendum Code":=TreatyVal."Addendum Code";
                //MODIFY;
                
                END;
                UNTIL TreatyVal.NEXT=0;
                
                {
                END ELSE BEGIN
                TreatyVal.RESET;
                TreatyVal.SETRANGE(TreatyVal."Ceding office","Cedant Code");
                TreatyVal.SETRANGE(TreatyVal.Type,TreatyVal.Type::"Individual Life");
                TreatyVal.SETFILTER(TreatyVal."Effective date",'<=%1',"Period Ended");
                //TreatyVal.SETFILTER(TreatyVal."Expiry Date",'>=%1',"Period Ended");
                
                
                IF TreatyVal.FIND('-') THEN BEGIN
                REPEAT
                IF ("Period Ended" IN [TreatyVal."Effective date"..TreatyVal."Expiry Date"]) //OR
                //("Period Ended" IN [TreatyVal."Effective date"..0D])
                THEN BEGIN
                
                //MESSAGE('%1',TreatyVal."Treaty Code");
                "Treaty Code":=TreatyVal."Treaty Code";
                "Addendum Code":=TreatyVal."Addendum Code";
                //MODIFY;
                
                END;
                UNTIL TreatyVal.NEXT=0;
                
                 }
                END ELSE BEGIN
                
                ERROR('%1%2%3','There is No individual life treaty for cedant ',"Cedant Code",' for this period.Please Confirm!!');
                END;
                //END;
                
                
                */

            end;
        }
        field(55; "Currency Code"; Code[10])
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
        field(56; "Sums Assured (LCY)"; Decimal)
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
        field(57; "Sum Reinsured (LCY)"; Decimal)
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
        field(58; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE("Sum Assured");
                VALIDATE("Sum reinsured");
                VALIDATE("Ceded add. Ben. Premium");
                //VALIDATE("Sums Assured (LCY)");
            end;
        }
        field(59; "Additional Benefit (LCY)"; Decimal)
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
        field(60; Status; Option)
        {
            OptionCaption = 'Active,Lapsed,Cancelled,Claimed';
            OptionMembers = Active,Lapsed,Cancelled,Claimed;
        }
        field(61; "Reinsurance Code"; Code[30])
        {
        }
        field(62; Apportioned; Boolean)
        {
        }
        field(63; "Created By"; Code[10])
        {
            TableRelation = User;
        }
        field(64; "Creation Date"; Date)
        {
        }
        field(65; "Creation Time"; Time)
        {
        }
        field(66; Posted; Boolean)
        {
        }
        field(67; "Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(68; "Posting Date"; Date)
        {
        }
        field(69; "Posting Time"; Time)
        {
        }
        field(70; "Lapse Date"; Date)
        {
        }
        field(71; "Date Cancelled"; Date)
        {
        }
        field(72; "Claim Date"; Date)
        {
        }
        field(73; "Status Period Ended"; Date)
        {
        }
        field(74; "Premium Rate"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Premium Rate" = 0 THEN BEGIN
                    "Premium Rate" := ("Basic Premium" * 1000) / "Sum Assured";
                END;
            end;
        }
        field(75; "Renewal Frequency"; Option)
        {
            OptionCaption = 'Annually';
            OptionMembers = Annually;
        }
        field(76; "ID/Passport Number"; Code[30])
        {
        }
        field(77; Compulsory; Boolean)
        {
        }
        field(78; Reinstated; Boolean)
        {
        }
        field(79; "Reinstatement Date"; Date)
        {
        }
        field(80; "Reinstatement Period Ended"; Date)
        {
        }
        field(81; "Business Type"; Option)
        {
            OptionCaption = '" ,Risk Premium,Original Terms"';
            OptionMembers = " ","Risk Premium","Original Terms";
        }
        field(82; "Retro Treaty"; Code[30])
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
        field(83; "Retro Addendum"; Integer)
        {
        }
        field(84; "Period Incepted"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "KRC No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Cedants: Record Customer;
        TreatyVal: Record "LIFE Treaty";
        CurrExchRate: Record "Currency Exchange Rate";
        Reassurer: Record Vendor;
        LifeReSetup: Record "Reinsurance Setup";
        Months: Integer;
        PeriodEnded: Text[30];
        d: Integer;
        m: Integer;
        y: Integer;
        PremiumRiskSchedule: Record "Prem Risk Schedule";
        ReassuranceApportionment: Record "Reassurer Apportionment";
        ReassuranceApportionmentDet: Record "Reassurance App Details";
        Riders: Record "Policy Riders";
        Text002: Label 'cannot be specified without %1';

    procedure GetCurrency();
    begin
    end;
}

