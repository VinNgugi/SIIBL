table 51513332 "Individual Claims"
{
    // version AES-INS 1.0


    fields
    {
        field(1; Cedant; Code[10])
        {
            TableRelation = Customer WHERE(Type = CONST(Cedant));

            trigger OnValidate();
            begin
                IF Cedants.GET(Cedant) THEN
                    "Cedant Name" := Cedants.Name
                ELSE
                    "Cedant Name" := '';
            end;
        }
        field(2; "Cedant Claim No"; Code[30])
        {
        }
        field(3; "Policy Number"; Code[30])
        {
            TableRelation = "Individual Life"."Policy Number" WHERE("Cedant Code" = FIELD(Cedant));

            trigger OnValidate();
            begin
                IF Individual.GET(Cedant, "Policy Number") THEN BEGIN
                    "Sir Name" := Individual.Surname;
                    "Other Names" := Individual."Other Names";

                END;
            end;
        }
        field(4; "Sir Name"; Code[30])
        {
        }
        field(5; "Other Names"; Text[100])
        {
        }
        field(6; "Scheme Name"; Text[100])
        {
        }
        field(7; "KRC Claim No"; Code[30])
        {
        }
        field(8; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        Amount, "Currency Factor"));
            end;
        }
        field(9; "Treaty Code"; Code[30])
        {
            TableRelation = Treaty."Treaty Code";
        }
        field(10; "Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code";
        }
        field(11; "Product Code"; Code[30])
        {
        }
        field(12; "Claim Date"; Date)
        {

            trigger OnValidate();
            begin
                TESTFIELD("Period Ended");
                TheYear := DATE2DMY("Claim Date", 3);
                Individual.GET(Cedant, "Policy Number");

                PremiumRisk.RESET;
                PremiumRisk.SETRANGE(PremiumRisk."Cedant Code", Cedant);
                PremiumRisk.SETRANGE(PremiumRisk."Policy No", "Policy Number");
                PremiumRisk.SETRANGE(PremiumRisk."Policy Type", "Policy Type");
                PremiumRisk.SETRANGE(PremiumRisk."Policy Code", "Policy Code");


                IF PremiumRisk.FIND('-') THEN BEGIN
                    REPEAT
                        IF (PremiumRisk.Year = TheYear) AND (PremiumRisk."Renewal Date" < "Claim Date") THEN BEGIN

                            Amount := PremiumRisk."Amount at Risk";

                            VALIDATE(Amount);
                            PremiumRisk.CALCFIELDS(PremiumRisk."Kenya Re Amount at Risk");
                            "Reassurance Amount" := PremiumRisk."Kenya Re Amount at Risk";
                            VALIDATE("Reassurance Amount");
                            "SA Retention" := PremiumRisk."SA Retention";
                            VALIDATE("SA Retention");
                            "Retroceeded SA" := PremiumRisk."Retroceeded SA";
                            VALIDATE("Retroceeded SA");
                            MODIFY;
                            MESSAGE('%1%2%3', 'Amount at Risk for the year ', PremiumRisk.Year, ' has been applied.Please Confirm!!');
                        END;

                        IF (PremiumRisk.Year = TheYear - 1) AND (PremiumRisk."Renewal Date" < "Claim Date") THEN BEGIN

                            Amount := PremiumRisk."Amount at Risk";

                            VALIDATE(Amount);
                            PremiumRisk.CALCFIELDS(PremiumRisk."Kenya Re Amount at Risk");
                            "Reassurance Amount" := PremiumRisk."Kenya Re Amount at Risk";
                            VALIDATE("Reassurance Amount");
                            "SA Retention" := PremiumRisk."SA Retention";
                            VALIDATE("SA Retention");
                            "Retroceeded SA" := PremiumRisk."Retroceeded SA";
                            VALIDATE("Retroceeded SA");


                            MODIFY;

                            MESSAGE('%1%2%3', 'Amount at Risk for the year ', PremiumRisk.Year, ' has been applied.Please Confirm!!');
                        END;


                    UNTIL PremiumRisk.NEXT = 0;
                END;
            end;
        }
        field(13; "Period Ended"; Date)
        {

            trigger OnValidate();
            begin
                /*
                
                ClaimRecordNumber:=0;
                TESTFIELD(Cedant);
                ClaimYear := DATE2DMY("Period Ended", 3);
                ClaimYearString:=FORMAT(ClaimYear);
                //MESSAGE('%1',ClaimYearString);
                DateTable.RESET;
                DateTable.SETRANGE(DateTable."Period Type",DateTable."Period Type"::Year);
                DateTable.SETRANGE(DateTable."Period Name",ClaimYearString);
                
                IF DateTable.FIND('-') THEN BEGIN
                REPEAT
                StartDate:=DateTable."Period Start";
                EndDate:=DateTable."Period End";
                //MESSAGE('%1',StartDate);
                
                
                EndDate:=NORMALDATE(EndDate);
                //MESSAGE('%1',EndDate);
                UNTIL DateTable.NEXT=0;
                END;
                
                Claim.RESET;
                Claim.SETRANGE(Claim."Period Ended",StartDate,EndDate);
                IF Claim.FIND('-') THEN BEGIN
                REPEAT
                ClaimRecordNumber:=ClaimRecordNumber+1;
                //ClaimNumber:=Claim."KRC Claim No";
                //MESSAGE('%1',ClaimNumber);
                UNTIL Claim.NEXT=0;
                ClaimRecordNumber:=ClaimRecordNumber+1;
                ClaimNumber:=FORMAT(ClaimRecordNumber);
                 "KRC Claim No":='KRL/'+ClaimYearString+'/'+Cedant+'/'+'T'+'/'+ClaimNumber;
                END ELSE BEGIN
                 "KRC Claim No":='KRL/'+ClaimYearString+'/'+Cedant+'/'+'T'+'/'+'1';
                
                END;
                
                
                
                */

            end;
        }
        field(14; "Cedant Name"; Text[100])
        {
        }
        field(15; "Cover Inception Date"; Date)
        {
        }
        field(16; "Cover End Date"; Date)
        {
        }
        field(17; "Submission Period End"; Date)
        {
        }
        field(18; "Apportionment Done"; Boolean)
        {
        }
        field(19; Posted; Boolean)
        {
        }
        field(20; "Posted By"; Code[10])
        {
        }
        field(21; "Posting Date"; Date)
        {
        }
        field(22; "Posting Time"; Time)
        {
        }
        field(23; Remarks; Text[200])
        {
        }
        field(24; "Retroceded Amount"; Decimal)
        {
        }
        field(25; "Currency Code"; Code[10])
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
                
                IF "Currency Code" <> '' THEN BEGIN
                  GetCurrency;
                  IF ("Currency Code" <> xRec."Currency Code") OR
                     ("Posting Date" <> xRec."Posting Date") OR
                     (CurrFieldNo = FIELDNO("Currency Code")) OR
                     ("Currency Factor" = 0)
                  THEN
                    "Currency Factor" :=
                      CurrExchRate.ExchangeRate("Posting Date","Currency Code");
                END ELSE
                  "Currency Factor" := 0;
                VALIDATE("Currency Factor");
                
                IF (("Currency Code" <> xRec."Currency Code") AND (Amount <> 0)) THEN
                  PaymentToleranceMgt.PmtTolGenJnl(Rec);
                */

                /*
                GroupMembers.RESET;
                GroupMembers.SETRANGE(GroupMembers."Policy Code","Policy Code");
                GroupMembers.SETRANGE(GroupMembers.Cedant,Cedant);
                GroupMembers.SETRANGE(GroupMembers."Lot No.","Lot No.");
                GroupMembers.SETRANGE(GroupMembers."Product Code","Product Code");
                GroupMembers.SETRANGE(GroupMembers."Treaty Code","Treaty Code");
                GroupMembers.SETRANGE(GroupMembers."Addendum Code","Addendum Code");
                GroupMembers.SETRANGE(GroupMembers."Inception Date","Inception Date");
                
                IF GroupMembers.FIND('-') THEN BEGIN
                REPEAT
                //MESSAGE('%1',GroupMembers."Member No");
                GroupMembers."Currency Code":="Currency Code";
                GroupMembers.VALIDATE(GroupMembers."Currency Code");
                GroupMembers.MODIFY;
                
                UNTIL GroupMembers.NEXT=0;
                END;
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

            end;
        }
        field(26; "Amount (LCY)"; Decimal)
        {
        }
        field(27; "Lot No."; Code[10])
        {
            TableRelation = "Group Scheme"."Lot No.";
        }
        field(28; "Retro Posted By"; Code[10])
        {
        }
        field(29; "Retro Posting Date"; Date)
        {
        }
        field(30; "Retro Posting Time"; Time)
        {
        }
        field(31; "Retro Posted"; Boolean)
        {
        }
        field(32; "Retro Treaty"; Code[30])
        {
        }
        field(33; "Retro Addendum"; Integer)
        {
        }
        field(34; "Free Cover Limit"; Decimal)
        {
        }
        field(35; "Currency Factor"; Decimal)
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
                VALIDATE(Amount);
                VALIDATE("Reassurance Amount");
                VALIDATE("SA Retention");
                VALIDATE("Retroceeded SA");
            end;
        }
        field(36; "Retro No."; Code[50])
        {
        }
        field(37; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = true;
            TableRelation = "No. Series";
        }
        field(38; "Proof Of Claim"; Boolean)
        {
        }
        field(39; "Discharge Form"; Boolean)
        {
        }
        field(40; "Advice Form"; Boolean)
        {
        }
        field(41; "Attachment 1"; Code[20])
        {
        }
        field(42; "Attachment 2"; Code[20])
        {
        }
        field(43; "Attachment 3"; Code[20])
        {
        }
        field(44; "Language Code (Default)"; Code[10])
        {
        }
        field(45; Attachement1; Option)
        {
            OptionMembers = No,Yes;
        }
        field(46; Attachement2; Option)
        {
            OptionMembers = No,Yes;
        }
        field(47; Attachement3; Option)
        {
            OptionMembers = No,Yes;
        }
        field(48; "Prepared By"; Code[10])
        {
            TableRelation = User;
        }
        field(49; "Reassurance Amount"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code" = '' THEN
                    "Reassurance Amount (LCY)" := "Reassurance Amount"
                ELSE
                    "Reassurance Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code",
                        "Reassurance Amount", "Currency Factor"));
            end;
        }
        field(50; "Reassurance Amount (LCY)"; Decimal)
        {
        }
        field(51; "SA Retention"; Decimal)
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
        field(52; "SA Retention (LCY)"; Decimal)
        {
        }
        field(53; "Retroceeded SA"; Decimal)
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
        field(54; "Retroceeded SA (LCY)"; Decimal)
        {
        }
        field(55; "Posted Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE(Individual = CONST(true),
                                                        "Cedant Code" = FIELD(Cedant),
                                                        "Policy Number" = FIELD("Policy Number"),
                                                        Reversed = CONST(false),
                                                        Amount = FILTER(> 0),
                                                        "Submission Type" = CONST(Claim),
                                                        Retro = CONST(false)));
            FieldClass = FlowField;
        }
        field(56; "Posted Retroceede Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE(Individual = CONST(true),
                                                        "Cedant Code" = FIELD(Cedant),
                                                        "Policy Number" = FIELD("Policy Number"),
                                                        Reversed = CONST(false),
                                                        Amount = FILTER(> 0),
                                                        "Submission Type" = CONST(Claim),
                                                        Retro = CONST(false)));
            FieldClass = FlowField;
        }
        field(57; "Policy Type"; Option)
        {
            OptionCaption = '" ,Main Policy,Supplimentary"';
            OptionMembers = " ","Main Policy",Supplimentary;

            trigger OnValidate();
            begin
                /*
                if "Policy Type"="Policy Type"::"main policy" then begin
                IF  Individual.GET(Cedant,"Policy Number") THEN BEGIN
                "Sir Name":=Individual.Surname;
                "Other Names":=Individual."Other Names";
                
                END;
                
                end;
                */

            end;
        }
        field(58; "Policy Code"; Code[10])
        {

            trigger OnValidate();
            begin
                INSERT(TRUE);
            end;
        }
        field(59; "Cause of Death"; Code[30])
        {
            //TableRelation = "Death Causes";
        }
        field(60; "Creation Date"; Date)
        {
        }
        field(61; "Creation Time"; Time)
        {
        }
        field(62; Compulsory; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; Cedant)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Cedants: Record Customer;
        Claim: Record Claim;
        ClaimYear: Integer;
        ClaimYearString: Text[30];
        DateTable: Record 2000000007;
        StartDate: Date;
        EndDate: Date;
        ClaimNumber: Code[50];
        ClaimRecordNumber: Integer;
        CurrExchRate: Record "Currency Exchange Rate";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LifeReSetup: Record "Reinsurance Setup";
        Individual: Record "Individual Life";
        PremiumRisk: Record "Prem Risk Schedule";
        TheYear: Integer;
        Text002: Label 'cannot be specified without %1';

    procedure GetCurrency();
    begin
    end;
}

