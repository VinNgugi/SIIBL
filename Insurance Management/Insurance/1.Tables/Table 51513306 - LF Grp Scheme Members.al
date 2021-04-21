table 51513306 "LF Grp Scheme Members"
{

    fields
    {
        field(1; "Policy Code"; Code[30])
        {
        }
        field(2; "Member No"; Code[30])
        {
        }
        field(3; Name; Text[200])
        {
        }
        field(4; DOB; Date)
        {
        }
        field(5; Age; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate();
            begin
                IF GroupScheme.GET("Policy Code", Cedant, "Lot No.", "Product Code", "Treaty Code", "Addendum Code", "Inception Date") THEN BEGIN
                    IF TreatyVal.GET(GroupScheme."Treaty Code", GroupScheme."Addendum Code") THEN BEGIN
                        IF TreatyVal."Max Age Limit" > 0 THEN BEGIN
                            IF TreatyVal."Max Age Limit" > Age THEN
                                ERROR('%1%2%3', 'Member No ', "Member No", ' Has exceeded the normal retirement age.Please Check!!');
                        END;
                    END;
                END;
            end;
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
                ExcessSumsAssured := 0;

                IF "Currency Code" = '' THEN BEGIN
                    "Sums Assured (LCY)" := "Sum Assured"
                END ELSE BEGIN
                    "Sums Assured (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Sum Assured", "Currency Factor"));
                END;


                IF GroupScheme.GET("Policy Code", Cedant, "Lot No.", "Product Code", "Treaty Code", "Addendum Code", "Inception Date") THEN BEGIN

                    IF GroupScheme."Apply FCL" = TRUE THEN BEGIN

                        IF "Sum Assured" > GroupScheme."Free Cover Limit" THEN BEGIN
                            "Above FCL" := TRUE;
                            MODIFY;
                            //MESSAGE('%1%2%3%4%5',"Member No",'=',"Above FCL",'=',' ');

                            ExcessSumsAssured := "Sum Assured" - GroupScheme."Free Cover Limit";

                            //MESSAGE('%1%2%3%4%5',"Member No",'=',ExcessSumsAssured,'=',Tests."Test Code");

                            Tests.RESET;
                            Tests.SETRANGE(Tests."Treaty Code", "Treaty Code");
                            Tests.SETRANGE(Tests."Addendum Code", "Addendum Code");
                            //Tests.SETFILTER(Tests."Lower Limit",'>=%1',ExcessSumsAssured);
                            //Tests.SETFILTER(Tests."Upper Limit",'<=%1',ExcessSumsAssured);

                            IF Tests.FIND('-') THEN BEGIN

                                REPEAT


                                    IF Age IN [Tests."Age Lower Limit" .. Tests."Age Upper Limit"] THEN BEGIN

                                        IF ExcessSumsAssured IN [Tests."Lower Limit" .. Tests."Upper Limit"] THEN BEGIN
                                            //IF ((Tests."Lower Limit">=ExcessSumsAssured) OR (Tests."Upper Limit"<=ExcessSumsAssured))
                                            ///THEN  BEGIN
                                            //MESSAGE('%1%2%3%4%5',"Member No",' ',ExcessSumsAssured,' ',Tests."Test Code");
                                            //MESSAGE('%1',Tests."Lower Limit");
                                            //MESSAGE('%1',Tests."Upper Limit");
                                            //IF Age IN [Tests."Age Lower Limit"..Tests."Age Upper Limit"] THEN BEGIN
                                            //MESSAGE('%1',Tests."Test Code");
                                            //if MemberMedical.GET();
                                            IF MemberMedical.GET("Policy Code", "Member No", "Treaty Code", "Addendum Code",
                                            "Product Code", "Lot No.", Cedant, "Inception Date", Tests."Test Code") = TRUE THEN BEGIN
                                            END ELSE BEGIN
                                                MemberMedical.INIT;
                                                MemberMedical."Policy Code" := "Policy Code";
                                                MemberMedical."Member No" := "Member No";
                                                MemberMedical."Treaty Code" := "Treaty Code";
                                                MemberMedical."Addendum Code" := "Addendum Code";
                                                MemberMedical."Product Code" := "Product Code";
                                                MemberMedical."Lot No." := "Lot No.";
                                                MemberMedical.Cedant := Cedant;
                                                MemberMedical."Inception Date" := "Inception Date";
                                                MemberMedical."Test Code" := Tests."Test Code";
                                                MemberMedical.INSERT;
                                            END;



                                        END;

                                    END;
                                //ExcessSumsAssured:=0;
                                UNTIL Tests.NEXT = 0;


                            END;

                            //test
                        END;
                    END;
                END;
            end;
        }
        field(8; Premium; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN BEGIN
                    "Premium (LCY)" := Premium
                END ELSE BEGIN
                    "Premium (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        Premium, "Currency Factor"));
                END;

                IF "Sum Assured" > 0 THEN
                    "Premium Rate" := (1000 / "Sum Assured") * Premium;
            end;
        }
        field(9; "Premium Rate"; Decimal)
        {

            trigger OnValidate();
            begin
                Premium := ("Sum Assured" / 1000) * "Premium Rate";
                VALIDATE(Premium);
            end;
        }
        field(10; "No. of Months"; Decimal)
        {
            DecimalPlaces = 0 : 0;
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

            trigger OnValidate();
            begin
                // TESTFIELD(Cedant);
                /*
               TreatyVal.RESET;
               TreatyVal.SETRANGE(TreatyVal."Ceding office",Cedant);
               TreatyVal.SETRANGE(TreatyVal."Treaty Type",TreatyVal."Treaty Type"::Cession);
               TreatyVal.SETRANGE(TreatyVal.Type,TreatyVal.Type::"Group Life");
               TreatyVal.SETRANGE(TreatyVal."Treaty Status",TreatyVal."Treaty Status"::Accepted);
               TreatyVal.SETFILTER(TreatyVal."Effective date",'<=%1',"Inception Date");
               TreatyVal.SETFILTER(TreatyVal."Expiry Date",'>=%1',"Inception Date");

               IF TreatyVal.FIND('-') THEN BEGIN
               REPEAT
               IF ("Inception Date" IN [TreatyVal."Effective date"..TreatyVal."Expiry Date"]) //OR
               //("Period Ended" IN [TreatyVal."Effective date"..0D])
               THEN BEGIN
               //MESSAGE('%1',TreatyVal."Treaty Code");
               "Treaty Code":=TreatyVal."Treaty Code";
               "Addendum Code":=TreatyVal."Addendum Code";
               //MODIFY;
               END;
               UNTIL TreatyVal.NEXT=0;
               END ELSE BEGIN
               ERROR('%1%2%3','There is No group life treaty for cedant ',Cedant,' for this period.Please Confirm!!');
               END;
               */

            end;
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
                END ELSE
                    "Currency Factor" := 0;
                //MESSAGE('%1',"Currency Factor");
                VALIDATE("Currency Factor");


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
                VALIDATE("Premium Loading");
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
        field(24; Claimed; Boolean)
        {
        }
        field(25; "Above FCL"; Boolean)
        {
            Editable = false;
        }
        field(26; "Medical Compliant"; Boolean)
        {
        }
        field(27; "Premium Loading"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    "Premium Loading (LCY)" := "Premium Loading"
                ELSE
                    "Premium Loading (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Premium Loading", "Currency Factor"));
            end;
        }
        field(28; "Premium Loading (LCY)"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    "Premium Loading (LCY)" := "Premium Loading"

                ELSE
                    Premium := ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Period Ended", "Currency Code",
                        "Premium Loading (LCY)", "Currency Factor"));
            end;
        }
        field(29; "Acceptance Terms"; Text[250])
        {
        }
        field(30; "Premium Loading Percentage"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin

                IF "Premium Loading Percentage" > 0 THEN BEGIN
                    "Premium Loading" := ("Premium Loading Percentage" / 100) * Premium;
                    // MODIFY;
                    VALIDATE("Premium Loading");
                END;
            end;
        }
        field(31; "Submission Start Date"; Date)
        {
            TableRelation = "Accounting Period";
        }
        field(32; Addittion; Boolean)
        {
        }
        field(33; Apportioned; Boolean)
        {
        }
        field(34; Posted; Boolean)
        {
        }
        field(35; "Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(36; "Posting Date"; Date)
        {
        }
        field(37; "Posting Time"; Time)
        {
        }
        field(38; "Retro Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(39; "Retro Posting Date"; Date)
        {
        }
        field(40; "Retro Posting Time"; Time)
        {
        }
        field(41; "Retro Apportionment"; Boolean)
        {
        }
        field(42; "Retro Posted"; Boolean)
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
        GroupScheme: Record "Group Scheme";
        TreatyVal: Record "LIFE Treaty";
        MemberMedical: Record "Member Medical Tests";
        ExcessSumsAssured: Decimal;
        Tests: Record "Age Test Allocation";
        Text002: Label 'cannot be specified without %1';

    procedure GetCurrency();
    begin
    end;
}

