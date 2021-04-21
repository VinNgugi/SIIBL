table 51513305 "Group Scheme"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Policy Code"; Code[30])
        {
        }
        field(2; "Scheme Name"; Text[100])
        {
        }
        field(3; Cedant; Code[30])
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
        field(4; "Treaty Code"; Code[30])
        {
            TableRelation = "LIFE Treaty"."Treaty Code";
        }
        field(5; "Folio No."; Code[10])
        {
        }
        field(6; "Lot No."; Code[10])
        {
        }
        field(7; "Period Ended"; Date)
        {

            trigger OnValidate();
            begin
                /* TESTFIELD(Cedant);
                
                TreatyVal.RESET;
                TreatyVal.SETRANGE(TreatyVal."Ceding office",Cedant);
                TreatyVal.SETRANGE(TreatyVal.Type,TreatyVal.Type::"Group Life");
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
                END ELSE BEGIN
                ERROR('%1%2%3','There is No group life treaty for cedant ',Cedant,' for this period.Please Confirm!!');
                END;
                */

            end;
        }
        field(8; "Inception Date"; Date)
        {

            trigger OnValidate();
            begin
                // TESTFIELD(Cedant);

                TreatyVal.RESET;
                TreatyVal.SETRANGE(TreatyVal."Ceding office", Cedant);
                TreatyVal.SETRANGE(TreatyVal."Treaty Type", TreatyVal."Treaty Type"::Cession);
                TreatyVal.SETRANGE(TreatyVal.Type, TreatyVal.Type::"Group Life");
                TreatyVal.SETRANGE(TreatyVal."Treaty Status", TreatyVal."Treaty Status"::Accepted);
                TreatyVal.SETFILTER(TreatyVal."Effective date", '<=%1', "Inception Date");
                TreatyVal.SETFILTER(TreatyVal."Expiry Date", '>=%1', "Inception Date");

                IF TreatyVal.FIND('-') THEN BEGIN
                    REPEAT
                        IF ("Inception Date" IN [TreatyVal."Effective date" .. TreatyVal."Expiry Date"]) //OR
                                                                                                         //("Period Ended" IN [TreatyVal."Effective date"..0D])
                        THEN BEGIN
                            //MESSAGE('%1',TreatyVal."Treaty Code");
                            "Treaty Code" := TreatyVal."Treaty Code";
                            "Addendum Code" := TreatyVal."Addendum Code";
                            //MODIFY;
                        END;
                    UNTIL TreatyVal.NEXT = 0;
                END ELSE BEGIN
                    ERROR('%1%2%3', 'There is No group life treaty for cedant ', Cedant, ' for this period.Please Confirm!!');
                END;


                TreatyVal.RESET;
                //TreatyVal.SETRANGE(TreatyVal."Ceding office",Cedant);
                TreatyVal.SETRANGE(TreatyVal."Treaty Type", TreatyVal."Treaty Type"::Retrocession);
                TreatyVal.SETRANGE(TreatyVal.Type, TreatyVal.Type::"Group Life");
                TreatyVal.SETRANGE(TreatyVal."Treaty Status", TreatyVal."Treaty Status"::Accepted);
                TreatyVal.SETFILTER(TreatyVal."Effective date", '<=%1', "Inception Date");
                TreatyVal.SETFILTER(TreatyVal."Expiry Date", '>=%1', "Inception Date");

                IF TreatyVal.FIND('-') THEN BEGIN
                    REPEAT
                        IF ("Inception Date" IN [TreatyVal."Effective date" .. TreatyVal."Expiry Date"]) //OR
                                                                                                         //("Period Ended" IN [TreatyVal."Effective date"..0D])
                        THEN BEGIN
                            //MESSAGE('%1',TreatyVal."Treaty Code");
                            "Retro Treaty" := TreatyVal."Treaty Code";
                            "Retro Addendum" := TreatyVal."Addendum Code";
                            //MODIFY;
                        END;
                    UNTIL TreatyVal.NEXT = 0;
                END ELSE BEGIN
                    ERROR('%1%2%3', 'There is No group life Retrocession treaty for this period.Please Confirm!!');
                END;

                /*

               GroupMembers.RESET;
               GroupMembers.SETRANGE(GroupMembers."Policy Code","Policy Code");
               GroupMembers.SETRANGE(GroupMembers.Cedant,Cedant);
               GroupMembers.SETRANGE(GroupMembers."Lot No.","Lot No.");
               GroupMembers.SETRANGE(GroupMembers."Product Code","Product Code");
               GroupMembers.SETRANGE(GroupMembers."Treaty Code","Treaty Code");
               GroupMembers.SETRANGE(GroupMembers."Addendum Code","Addendum Code");
               GroupMembers.SETRANGE(GroupMembers."Inception Date",xRec."Inception Date");

               IF GroupMembers.FIND('-') THEN BEGIN
               REPEAT
               //MESSAGE('%1',GroupMembers."Member No");
               //GroupMembers."Currency Code":="Currency Code";
               //GroupMembers.VALIDATE(GroupMembers."Currency Code");
               GroupMembers."Inception Date":="Inception Date";
               GroupMembers.MODIFY;

               UNTIL GroupMembers.NEXT=0;
               END;
                 */

            end;
        }
        field(9; "Renewal Date"; Date)
        {
        }
        field(10; "New/Renewal business"; Option)
        {
            OptionMembers = " ",N,R;
        }
        field(11; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(12; "Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code" WHERE("Treaty Code" = FIELD("Treaty Code"));
        }
        field(13; "Product Code"; Code[30])
        {
            TableRelation = "Product Types";
        }
        field(14; "Cedant Name"; Text[100])
        {
        }
        field(15; "Quota Share Premium"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Premium),
                                                        "Apportionment Type" = CONST("Quota Share"),
                                                        "Cedant Code" = FIELD(Cedant),
                                                        "Lot No" = FIELD("Lot No."),
                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                        "Product Code" = FIELD("Product Code"),
                                                        Amount = FILTER(> 0),
                                                        "Inception date" = FIELD("Inception Date"),
                                                        Reversed = CONST(false)));
            FieldClass = FlowField;
        }
        field(16; "Surplus Premium"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Premium),
                                                        "Apportionment Type" = CONST(Surplus),
                                                        "Cedant Code" = FIELD(Cedant),
                                                        "Lot No" = FIELD("Lot No."),
                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                        "Product Code" = FIELD("Product Code"),
                                                        Amount = FILTER(> 0),
                                                        "Inception date" = FIELD("Inception Date"),
                                                        Reversed = CONST(false)));
            FieldClass = FlowField;
        }
        field(17; "Facultative Premium"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Premium),
                                                        "Apportionment Type" = CONST(Fucultative),
                                                        "Cedant Code" = FIELD(Cedant),
                                                        "Lot No" = FIELD("Lot No."),
                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                        "Product Code" = FIELD("Product Code"),
                                                        Amount = FILTER(> 0),
                                                        "Inception date" = FIELD("Inception Date"),
                                                        Reversed = CONST(false)));
            FieldClass = FlowField;
        }
        field(18; "Sum Assured"; Decimal)
        {
            CalcFormula = Sum("LF Grp Scheme Members"."Sum Assured" WHERE("Policy Code" = FIELD("Policy Code"),
                                                                           "Treaty Code" = FIELD("Treaty Code"),
                                                                           "Addendum Code" = FIELD("Addendum Code"),
                                                                           "Product Code" = FIELD("Product Code"),
                                                                           "Lot No." = FIELD("Lot No."),
                                                                           Cedant = FIELD(Cedant),
                                                                           "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(19; Premium; Decimal)
        {
            CalcFormula = Sum("LF Grp Scheme Members".Premium WHERE("Policy Code" = FIELD("Policy Code"),
                                                                     "Treaty Code" = FIELD("Treaty Code"),
                                                                     "Addendum Code" = FIELD("Addendum Code"),
                                                                     "Product Code" = FIELD("Product Code"),
                                                                     "Lot No." = FIELD("Lot No."),
                                                                     Cedant = FIELD(Cedant),
                                                                     "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(20; "No. of Lives"; Integer)
        {
            CalcFormula = Count("LF Grp Scheme Members" WHERE("Policy Code" = FIELD("Policy Code"),
                                                               "Treaty Code" = FIELD("Treaty Code"),
                                                               "Addendum Code" = FIELD("Addendum Code"),
                                                               "Product Code" = FIELD("Product Code"),
                                                               "Lot No." = FIELD("Lot No."),
                                                               Cedant = FIELD(Cedant),
                                                               "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(21; "Quota Share Commission"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Commission),
                                                        "Apportionment Type" = CONST("Quota Share"),
                                                        "Cedant Code" = FIELD(Cedant),
                                                        "Lot No" = FIELD("Lot No."),
                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                        "Product Code" = FIELD("Product Code"),
                                                        Amount = FILTER(> 0),
                                                        "Inception date" = FIELD("Inception Date"),
                                                        Reversed = CONST(false)));
            FieldClass = FlowField;
        }
        field(22; "Surplus Commission"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Commission),
                                                        "Apportionment Type" = CONST(Surplus),
                                                        "Cedant Code" = FIELD(Cedant),
                                                        "Lot No" = FIELD("Lot No."),
                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                        "Product Code" = FIELD("Product Code"),
                                                        Amount = FILTER(> 0),
                                                        "Inception date" = FIELD("Inception Date"),
                                                        Reversed = CONST(false)));
            FieldClass = FlowField;
        }
        field(23; "Facultative Commission"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Commission),
                                                        "Apportionment Type" = CONST(Fucultative),
                                                        "Cedant Code" = FIELD(Cedant),
                                                        "Lot No" = FIELD("Lot No."),
                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                        "Product Code" = FIELD("Product Code"),
                                                        Amount = FILTER(> 0),
                                                        "Inception date" = FIELD("Inception Date"),
                                                        Reversed = CONST(false)));
            FieldClass = FlowField;
        }
        field(24; "Apportionment Done"; Boolean)
        {
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
        field(29; "Total Premium"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Code" = FIELD("Policy Code"),
                                                        "Submission Type" = CONST(Premium),
                                                        "Cedant Code" = FIELD(Cedant),
                                                        "Lot No" = FIELD("Lot No."),
                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                        "Product Code" = FIELD("Product Code"),
                                                        Amount = FILTER(> 0),
                                                        "Inception date" = FIELD("Inception Date"),
                                                        Reversed = CONST(false)));
            FieldClass = FlowField;
        }
        field(30; Retroceded; Boolean)
        {
        }
        field(31; "Retro Premium"; Decimal)
        {
            CalcFormula = Sum("Grp Members Retro".Premium WHERE("Policy Code" = FIELD("Policy Code"),
                                                                 "Treaty Code" = FIELD("Retro Treaty"),
                                                                 "Addendum Code" = FIELD("Retro Addendum"),
                                                                 "Product Code" = FIELD("Product Code"),
                                                                 "Lot No." = FIELD("Lot No."),
                                                                 Cedant = FIELD(Cedant),
                                                                 "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(32; "Retro Sums Assured"; Decimal)
        {
            CalcFormula = Sum("Grp Members Retro"."Sum Assured" WHERE("Policy Code" = FIELD("Policy Code"),
                                                                       "Treaty Code" = FIELD("Retro Treaty"),
                                                                       "Addendum Code" = FIELD("Retro Addendum"),
                                                                       "Product Code" = FIELD("Product Code"),
                                                                       "Lot No." = FIELD("Lot No."),
                                                                       Cedant = FIELD(Cedant),
                                                                       "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(33; "Retro No. Of Lives"; Integer)
        {
            CalcFormula = Count("Grp Members Retro" WHERE("Policy Code" = FIELD("Policy Code"),
                                                           "Treaty Code" = FIELD("Retro Treaty"),
                                                           "Addendum Code" = FIELD("Retro Addendum"),
                                                           "Product Code" = FIELD("Product Code"),
                                                           "Lot No." = FIELD("Lot No."),
                                                           Cedant = FIELD(Cedant),
                                                           "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(34; "Retro Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(35; "Retro Posting Date"; Date)
        {
        }
        field(36; "Retro Posting Time"; Time)
        {
        }
        field(37; "Retro Apportionment"; Boolean)
        {
        }
        field(38; "Retro Posted"; Boolean)
        {
        }
        field(39; "Retro Treaty"; Code[30])
        {
        }
        field(40; "Retro Addendum"; Integer)
        {
        }
        field(41; "Retroceded Premium"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Submission Type" = CONST(Premium),
                                                        "Treaty Code" = FIELD("Retro Treaty"),
                                                        "Addendum Code" = FIELD("Retro Addendum"),
                                                        "Product Code" = FIELD("Product Code"),
                                                        "Policy Code" = FIELD("Policy Code"),
                                                        "Lot No" = FIELD("Lot No."),
                                                        "Inception date" = FIELD("Inception Date"),
                                                        Amount = FILTER(> 0),
                                                        Retro = CONST(true),
                                                        Reversed = CONST(false)));
            FieldClass = FlowField;
        }
        field(42; "Retroceded Commission"; Decimal)
        {
            CalcFormula = - Sum("G/L Entry".Amount WHERE("Submission Type" = CONST(Commission),
                                                         "Treaty Code" = FIELD("Retro Treaty"),
                                                         "Addendum Code" = FIELD("Retro Addendum"),
                                                         "Product Code" = FIELD("Product Code"),
                                                         "Policy Code" = FIELD("Policy Code"),
                                                         "Lot No" = FIELD("Lot No."),
                                                         "Inception date" = FIELD("Inception Date"),
                                                         Amount = FILTER(< 0),
                                                         Retro = CONST(true),
                                                         Reversed = CONST(false)));
            FieldClass = FlowField;
        }
        field(43; "Currency Code"; Code[10])
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


                GroupMembers.RESET;
                GroupMembers.SETRANGE(GroupMembers."Policy Code", "Policy Code");
                GroupMembers.SETRANGE(GroupMembers.Cedant, Cedant);
                GroupMembers.SETRANGE(GroupMembers."Lot No.", "Lot No.");
                GroupMembers.SETRANGE(GroupMembers."Product Code", "Product Code");
                GroupMembers.SETRANGE(GroupMembers."Treaty Code", "Treaty Code");
                GroupMembers.SETRANGE(GroupMembers."Addendum Code", "Addendum Code");
                GroupMembers.SETRANGE(GroupMembers."Inception Date", "Inception Date");

                IF GroupMembers.FIND('-') THEN BEGIN
                    REPEAT
                        //MESSAGE('%1',GroupMembers."Member No");
                        GroupMembers."Currency Code" := "Currency Code";
                        GroupMembers.VALIDATE(GroupMembers."Currency Code");
                        GroupMembers.MODIFY;

                    UNTIL GroupMembers.NEXT = 0;
                END;

            end;
        }
        field(44; "Free Cover Limit"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Free Cover Limit" > 0 THEN
                    "Apply FCL" := TRUE
                ELSE
                    "Apply FCL" := FALSE;
            end;
        }
        field(45; "Apply FCL"; Boolean)
        {
        }
        field(46; "Prepared By"; Code[10])
        {
            TableRelation = User;
        }
        field(47; "Submission Start Date"; Date)
        {
            TableRelation = "Accounting Period";
        }
        field(48; "Reinsurance Code"; Code[10])
        {
            TableRelation = Vendor WHERE(Type = CONST(Reinsurer));
        }
        field(49; "Reinsurance Quota Share Prem"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment".Amount WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                        "Qouta Share" = CONST(true),
                                                                        Surplus = CONST(false),
                                                                        Facultative = CONST(false),
                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                        "Product Code" = FIELD("Product Code"),
                                                                        "Lot No." = FIELD("Lot No."),
                                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                                        "Inception date" = FIELD("Inception Date"),
                                                                        Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(50; "Reinsurance Surplus Prem"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment".Amount WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                        "Qouta Share" = CONST(false),
                                                                        Surplus = CONST(true),
                                                                        Facultative = CONST(false),
                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                        "Product Code" = FIELD("Product Code"),
                                                                        "Lot No." = FIELD("Lot No."),
                                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                                        "Inception date" = FIELD("Inception Date"),
                                                                        Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(51; "Reinsurance Facultative Prem"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment".Amount WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                        "Qouta Share" = CONST(false),
                                                                        Surplus = CONST(false),
                                                                        Facultative = CONST(true),
                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                        "Product Code" = FIELD("Product Code"),
                                                                        "Lot No." = FIELD("Lot No."),
                                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                                        "Inception date" = FIELD("Inception Date"),
                                                                        Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(52; "Reinsurance Quota Share SA"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment"."Sums Assured" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                "Qouta Share" = CONST(true),
                                                                                Surplus = CONST(false),
                                                                                Facultative = CONST(false),
                                                                                "Policy Code" = FIELD("Policy Code"),
                                                                                "Treaty Code" = FIELD("Treaty Code"),
                                                                                "Product Code" = FIELD("Product Code"),
                                                                                "Lot No." = FIELD("Lot No."),
                                                                                "Addendum Code" = FIELD("Addendum Code"),
                                                                                "Inception date" = FIELD("Inception Date"),
                                                                                Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(53; "Reinsurance Surplus SA"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment"."Sums Assured" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                "Qouta Share" = CONST(false),
                                                                                Surplus = CONST(true),
                                                                                Facultative = CONST(false),
                                                                                "Policy Code" = FIELD("Policy Code"),
                                                                                "Treaty Code" = FIELD("Treaty Code"),
                                                                                "Product Code" = FIELD("Product Code"),
                                                                                "Lot No." = FIELD("Lot No."),
                                                                                "Addendum Code" = FIELD("Addendum Code"),
                                                                                "Inception date" = FIELD("Inception Date"),
                                                                                Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(54; "Reinsurance Facultative SA"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment"."Sums Assured" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                "Qouta Share" = CONST(false),
                                                                                Surplus = CONST(false),
                                                                                Facultative = CONST(true),
                                                                                "Policy Code" = FIELD("Policy Code"),
                                                                                "Treaty Code" = FIELD("Treaty Code"),
                                                                                "Product Code" = FIELD("Product Code"),
                                                                                "Lot No." = FIELD("Lot No."),
                                                                                "Addendum Code" = FIELD("Addendum Code"),
                                                                                "Inception date" = FIELD("Inception Date"),
                                                                                Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(55; "Total Reisurance Premium"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment".Amount WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                        "Product Code" = FIELD("Product Code"),
                                                                        "Lot No." = FIELD("Lot No."),
                                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                                        "Inception date" = FIELD("Inception Date"),
                                                                        Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(56; "Total Reisurance SA"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment"."Sums Assured" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                "Policy Code" = FIELD("Policy Code"),
                                                                                "Treaty Code" = FIELD("Treaty Code"),
                                                                                "Product Code" = FIELD("Product Code"),
                                                                                "Lot No." = FIELD("Lot No."),
                                                                                "Addendum Code" = FIELD("Addendum Code"),
                                                                                "Inception date" = FIELD("Inception Date"),
                                                                                Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(57; "Quota Share Premium1"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code1" = '' THEN BEGIN
                    "Quota Share Premium1(LCY)" := "Quota Share Premium1"
                END ELSE BEGIN
                    "Quota Share Premium1(LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code1",
                        "Quota Share Premium1", "Currency Factor"));
                END;
            end;
        }
        field(58; "Surplus Premium1"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code1" = '' THEN BEGIN
                    "Surplus Premium1(LCY)" := "Surplus Premium1"
                END ELSE BEGIN
                    "Surplus Premium1(LCY)" := ROUND(
                       CurrExchRate.ExchangeAmtFCYToLCY(
                         "Period Ended", "Currency Code1",
                         "Surplus Premium1", "Currency Factor"));
                END;
            end;
        }
        field(59; "Facultative Premium1"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code1" = '' THEN BEGIN
                    "Facultative Premium1(LCY)" := "Facultative Premium1"
                END ELSE BEGIN
                    "Facultative Premium1(LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code1",
                        "Facultative Premium1", "Currency Factor"));
                END;
            end;
        }
        field(60; "Quota  Share Sum Assured"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code1" = '' THEN BEGIN
                    "Quota  Share Sum Assured(LCY)" := "Quota  Share Sum Assured"
                END ELSE BEGIN
                    "Quota  Share Sum Assured(LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code1",
                        "Quota  Share Sum Assured", "Currency Factor"));
                END;
            end;
        }
        field(61; "Surplus Sum Assured"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code1" = '' THEN BEGIN
                    "Surplus Sum Assured(LCY)" := "Surplus Sum Assured"
                END ELSE BEGIN
                    "Surplus Sum Assured(LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code1",
                        "Surplus Sum Assured", "Currency Factor"));
                END;
            end;
        }
        field(62; "Facultative Sum Assured"; Decimal)
        {

            trigger OnValidate();
            begin
                GetCurrency;

                IF "Currency Code1" = '' THEN BEGIN
                    "Facultative Sum Assured(LCY)" := "Facultative Sum Assured"
                END ELSE BEGIN
                    "Facultative Sum Assured(LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Period Ended", "Currency Code1",
                        "Facultative Sum Assured", "Currency Factor"));
                END;
            end;
        }
        field(63; "Quota Share Premium1(LCY)"; Decimal)
        {
        }
        field(64; "Surplus Premium1(LCY)"; Decimal)
        {
        }
        field(65; "Facultative Premium1(LCY)"; Decimal)
        {
        }
        field(66; "Quota  Share Sum Assured(LCY)"; Decimal)
        {
        }
        field(67; "Surplus Sum Assured(LCY)"; Decimal)
        {
        }
        field(68; "Facultative Sum Assured(LCY)"; Decimal)
        {
        }
        field(69; Summary; Boolean)
        {
        }
        field(70; "Currency Code1"; Code[10])
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



                IF "Currency Code1" <> '' THEN BEGIN
                    GetCurrency;
                    IF ("Currency Code1" <> xRec."Currency Code1") OR
                       ("Period Ended" <> xRec."Period Ended") OR
                       (CurrFieldNo = FIELDNO("Currency Code1")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate("Period Ended", "Currency Code1");
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
        field(71; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                IF ("Currency Code1" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code1")));
                //VALIDATE(Premium,"Sum Assured");
                VALIDATE("Quota Share Premium1");
                VALIDATE("Surplus Premium1");
                VALIDATE("Facultative Premium1");

                VALIDATE("Quota  Share Sum Assured");
                VALIDATE("Surplus Sum Assured");
                VALIDATE("Facultative Sum Assured");
            end;
        }
        field(72; "No. of Lives1"; Integer)
        {
        }
        field(73; "Reinsurance Quota Share Prem1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment".Premium WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                      "Qouta Share" = CONST(true),
                                                                      Surplus = CONST(false),
                                                                      Facultative = CONST(false),
                                                                      "Policy Code" = FIELD("Policy Code"),
                                                                      "Treaty Code" = FIELD("Treaty Code"),
                                                                      "Product Code" = FIELD("Product Code"),
                                                                      "Lot No." = FIELD("Lot No."),
                                                                      "Addendum Code" = FIELD("Addendum Code"),
                                                                      "Inception Date" = FIELD("Inception Date"),
                                                                      Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(74; "Reinsurance Surplus Prem1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment".Premium WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                      "Qouta Share" = CONST(false),
                                                                      Surplus = CONST(true),
                                                                      Facultative = CONST(false),
                                                                      "Policy Code" = FIELD("Policy Code"),
                                                                      "Treaty Code" = FIELD("Treaty Code"),
                                                                      "Product Code" = FIELD("Product Code"),
                                                                      "Lot No." = FIELD("Lot No."),
                                                                      "Addendum Code" = FIELD("Addendum Code"),
                                                                      "Inception Date" = FIELD("Inception Date"),
                                                                      Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(75; "Reinsurance Facultative Prem1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment".Premium WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                      "Qouta Share" = CONST(false),
                                                                      Surplus = CONST(false),
                                                                      Facultative = CONST(true),
                                                                      "Policy Code" = FIELD("Policy Code"),
                                                                      "Treaty Code" = FIELD("Treaty Code"),
                                                                      "Product Code" = FIELD("Product Code"),
                                                                      "Lot No." = FIELD("Lot No."),
                                                                      "Addendum Code" = FIELD("Addendum Code"),
                                                                      "Inception Date" = FIELD("Inception Date"),
                                                                      Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(76; "Reinsurance Quota Share SA1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Sums Assured1" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                              "Qouta Share" = CONST(true),
                                                                              Surplus = CONST(False),
                                                                              Facultative = CONST(False),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                              "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Addendum Code" = FIELD("Addendum Code"),
                                                                              "Inception Date" = FIELD("Inception Date"),
                                                                              Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(77; "Reinsurance Surplus SA1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Sums Assured1" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                              "Qouta Share" = CONST(False),
                                                                              Surplus = CONST(True),
                                                                              Facultative = CONST(False),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                              "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Addendum Code" = FIELD("Addendum Code"),
                                                                              "Inception Date" = FIELD("Inception Date"),
                                                                              Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(78; "Reinsurance Facultative SA1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Sums Assured1" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                              "Qouta Share" = CONST(False),
                                                                              Surplus = CONST(False),
                                                                              Facultative = CONST(True),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                              "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Addendum Code" = FIELD("Addendum Code"),
                                                                              "Inception Date" = FIELD("Inception Date"),
                                                                              Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(79; "Total Reisurance Premium1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment".Premium WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                      "Policy Code" = FIELD("Policy Code"),
                                                                      "Treaty Code" = FIELD("Treaty Code"),
                                                                      "Product Code" = FIELD("Product Code"),
                                                                      "Lot No." = FIELD("Lot No."),
                                                                      "Addendum Code" = FIELD("Addendum Code"),
                                                                      "Inception Date" = FIELD("Inception Date"),
                                                                      Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(80; "Total Reisurance SA1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Sums Assured1" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                             "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Addendum Code" = FIELD("Addendum Code"),
                                                                              "Inception Date" = FIELD("Inception Date"),
                                                                              Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(81; "Reinsurance QShare Prem(LCY)"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment"."Premium (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                 "Qouta Share" = CONST(True),
                                                                                 Surplus = CONST(False),
                                                                                 Facultative = CONST(False),
                                                                                 "Policy Code" = FIELD("Policy Code"),
                                                                                 "Treaty Code" = FIELD("Treaty Code"),
                                                                                 "Product Code" = FIELD("Product Code"),
                                                                                 "Lot No." = FIELD("Lot No."),
                                                                                 "Addendum Code" = FIELD("Addendum Code"),
                                                                                "Inception date" = FIELD("Inception Date"),
                                                                                 Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(82; "Reinsurance Surplus Prem(LCY)"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment"."Premium (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                 "Qouta Share" = CONST(False),
                                                                                 Surplus = CONST(True),
                                                                                 Facultative = CONST(False),
                                                                                 "Policy Code" = FIELD("Policy Code"),
                                                                                 "Treaty Code" = FIELD("Treaty Code"),
                                                                                 "Product Code" = FIELD("Product Code"),
                                                                                 "Lot No." = FIELD("Lot No."),
                                                                                 "Addendum Code" = FIELD("Addendum Code"),
                                                                                 "Inception date" = FIELD("Inception Date"),
                                                                                 Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(83; "Reinsurance Fac Prem(LCY)"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment"."Premium (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                 "Qouta Share" = CONST(False),
                                                                                 Surplus = CONST(False),
                                                                                 Facultative = CONST(True),
                                                                                 "Policy Code" = FIELD("Policy Code"),
                                                                                 "Treaty Code" = FIELD("Treaty Code"),
                                                                                 "Product Code" = FIELD("Product Code"),
                                                                                 "Lot No." = FIELD("Lot No."),
                                                                                "Addendum Code" = FIELD("Addendum Code"),
                                                                                 "Inception date" = FIELD("Inception Date"),
                                                                                 Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(84; "Reinsurance QShare Prem1(LCY)"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Premium (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                              "Qouta Share" = CONST(True),
                                                                              Surplus = CONST(False),
                                                                              Facultative = CONST(False),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                              "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Addendum Code" = FIELD("Addendum Code"),
                                                                              "Inception Date" = FIELD("Inception Date"),
                                                                              Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(85; "Reinsurance Surplus Prem1(LCY)"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Premium (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                              "Qouta Share" = CONST(False),
                                                                              Surplus = CONST(True),
                                                                              Facultative = CONST(False),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                              "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Addendum Code" = FIELD("Addendum Code"),
                                                                              "Inception Date" = FIELD("Inception Date"),
                                                                              Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(86; "Reinsurance Fac Prem1(LCY)"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Premium (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                              "Qouta Share" = CONST(False),
                                                                              Surplus = CONST(False),
                                                                              Facultative = CONST(True),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                              "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Addendum Code" = FIELD("Addendum Code"),
                                                                              "Inception Date" = FIELD("Inception Date"),
                                                                              Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(87; "Date Prepared"; Date)
        {
        }
        field(88; "Total Quota Share Prem"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment"."Premium (LCY)" WHERE("Qouta Share" = CONST(True),
                                                                                 Surplus = CONST(False),
                                                                                 Facultative = CONST(False),
                                                                                 "Policy Code" = FIELD("Policy Code"),
                                                                                 "Treaty Code" = FIELD("Treaty Code"),
                                                                                 "Product Code" = FIELD("Product Code"),
                                                                                 "Lot No." = FIELD("Lot No."),
                                                                                 "Addendum Code" = FIELD("Addendum Code"),
                                                                                 "Inception date" = FIELD("Inception Date"),
                                                                                 Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(89; "Total Quota ced Comm"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission (LCY)" WHERE("Qouta Share" = CONST(True),
                                                                                        Surplus = CONST(False),
                                                                                        Facultative = CONST(False),
                                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                                        "Product Code" = FIELD("Product Code"),
                                                                                        "Lot No." = FIELD("Lot No."),
                                                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                                                        "Inception Date" = FIELD("Inception Date"),
                                                                                        Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(90; "Total Quota Brok Comm"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Broker Commission (LCY)" WHERE("Qouta Share" = CONST(True),
                                                                                        Surplus = CONST(False),
                                                                                        Facultative = CONST(False),
                                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                                        "Product Code" = FIELD("Product Code"),
                                                                                        "Lot No." = FIELD("Lot No."),
                                                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                                                        "Inception Date" = FIELD("Inception Date"),
                                                                                        Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(91; "Total Surplus Prem"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment"."Premium (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                                 Surplus = CONST(True),
                                                                                 Facultative = CONST(False),
                                                                                 "Policy Code" = FIELD("Policy Code"),
                                                                                 "Treaty Code" = FIELD("Treaty Code"),
                                                                                 "Product Code" = FIELD("Product Code"),
                                                                                 "Lot No." = FIELD("Lot No."),
                                                                                 "Addendum Code" = FIELD("Addendum Code"),
                                                                                 "Inception date" = FIELD("Inception Date"),
                                                                                 Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(92; "Total Surplus ced Comm"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                                        Surplus = CONST(True),
                                                                                        Facultative = CONST(False),
                                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                                        "Product Code" = FIELD("Product Code"),
                                                                                        "Lot No." = FIELD("Lot No."),
                                                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                                                        "Inception Date" = FIELD("Inception Date"),
                                                                                        Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(93; "Total Surplus Brok Comm"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Broker Commission (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                                        Surplus = CONST(True),
                                                                                        Facultative = CONST(False),
                                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                                        "Product Code" = FIELD("Product Code"),
                                                                                        "Lot No." = FIELD("Lot No."),
                                                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                                                        "Inception Date" = FIELD("Inception Date"),
                                                                                        Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(94; "Total Facultative Prem"; Decimal)
        {
            CalcFormula = Sum("Member Prem Apportionment"."Premium (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                                 Surplus = CONST(False),
                                                                                 Facultative = CONST(True),
                                                                                 "Policy Code" = FIELD("Policy Code"),
                                                                                 "Treaty Code" = FIELD("Treaty Code"),
                                                                                 "Product Code" = FIELD("Product Code"),
                                                                                 "Lot No." = FIELD("Lot No."),
                                                                                 "Addendum Code" = FIELD("Addendum Code"),
                                                                                 "Inception date" = FIELD("Inception Date"),
                                                                                 Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(95; "Total Fac ced Comm"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                                        Surplus = CONST(False),
                                                                                        Facultative = CONST(True),
                                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                                        "Product Code" = FIELD("Product Code"),
                                                                                        "Lot No." = FIELD("Lot No."),
                                                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                                                        "Inception Date" = FIELD("Inception Date"),
                                                                                        Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(96; "Total Fac Brok Comm"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Broker Commission (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                                        Surplus = CONST(False),
                                                                                        Facultative = CONST(True),
                                                                                        "Policy Code" = FIELD("Policy Code"),
                                                                                        "Treaty Code" = FIELD("Treaty Code"),
                                                                                        "Product Code" = FIELD("Product Code"),
                                                                                        "Lot No." = FIELD("Lot No."),
                                                                                        "Addendum Code" = FIELD("Addendum Code"),
                                                                                        "Inception Date" = FIELD("Inception Date"),
                                                                                        Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(97; "Folio No"; Integer)
        {
        }
        field(98; "Original Commission%"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
        field(99; "Effective Date"; Date)
        {
        }
        field(100; "Reassurer Surplus Commission"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                  Surplus = CONST(True),
                                                                                  Cedant = FIELD(Cedant),
                                                                                  "Policy Code" = FIELD("Policy Code"),
                                                                                  "Treaty Code" = FIELD("Treaty Code"),
                                                                                  "Product Code" = FIELD("Product Code"),
                                                                                  "Lot No." = FIELD("Lot No."),
                                                                                  "Addendum Code" = FIELD("Addendum Code"),
                                                                                  "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(101; "Reassurer Quota Commission"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                  "Qouta Share" = CONST(True),
                                                                                  Cedant = FIELD(Cedant),
                                                                                  "Policy Code" = FIELD("Policy Code"),
                                                                                  "Treaty Code" = FIELD("Treaty Code"),
                                                                                  "Product Code" = FIELD("Product Code"),
                                                                                  "Lot No." = FIELD("Lot No."),
                                                                                  "Addendum Code" = FIELD("Addendum Code"),
                                                                                  "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(102; "Reassurer Fac Commission"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                  Facultative = CONST(True),
                                                                                  Cedant = FIELD(Cedant),
                                                                                  "Policy Code" = FIELD("Policy Code"),
                                                                                  "Treaty Code" = FIELD("Treaty Code"),
                                                                                  "Product Code" = FIELD("Product Code"),
                                                                                  "Lot No." = FIELD("Lot No."),
                                                                                  "Addendum Code" = FIELD("Addendum Code"),
                                                                                  "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(103; "Reassurer Surplus Commission1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission1 (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                         Surplus = CONST(True),
                                                                                         Cedant = FIELD(Cedant),
                                                                                         "Policy Code" = FIELD("Policy Code"),
                                                                                         "Treaty Code" = FIELD("Treaty Code"),
                                                                                         "Product Code" = FIELD("Product Code"),
                                                                                         "Lot No." = FIELD("Lot No."),
                                                                                         "Addendum Code" = FIELD("Addendum Code"),
                                                                                         "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(104; "Reassurer Quota Commission1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission1 (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                         "Qouta Share" = CONST(True),
                                                                                         Cedant = FIELD(Cedant),
                                                                                         "Policy Code" = FIELD("Policy Code"),
                                                                                         "Treaty Code" = FIELD("Treaty Code"),
                                                                                         "Product Code" = FIELD("Product Code"),
                                                                                         "Lot No." = FIELD("Lot No."),
                                                                                         "Addendum Code" = FIELD("Addendum Code"),
                                                                                         "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(105; "Reassurer Fac Commission1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission1 (LCY)" WHERE("Insurer/Reassurer Code" = FIELD("Reinsurance Code"),
                                                                                         Facultative = CONST(True),
                                                                                         Cedant = FIELD(Cedant),
                                                                                         "Policy Code" = FIELD("Policy Code"),
                                                                                         "Treaty Code" = FIELD("Treaty Code"),
                                                                                         "Product Code" = FIELD("Product Code"),
                                                                                         "Lot No." = FIELD("Lot No."),
                                                                                         "Addendum Code" = FIELD("Addendum Code"),
                                                                                         "Inception Date" = FIELD("Inception Date")));
            FieldClass = FlowField;
        }
        field(106; "Total Quota Share Prem1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Premium (LCY)" WHERE("Qouta Share" = CONST(True),
                                                                              Surplus = CONST(False),
                                                                              Facultative = CONST(False),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                              "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Addendum Code" = FIELD("Addendum Code"),
                                                                              "Inception Date" = FIELD("Inception Date"),
                                                                              Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(107; "Total Quota ced Comm1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission1 (LCY)" WHERE("Qouta Share" = CONST(True),
                                                                                         Surplus = CONST(False),
                                                                                         Facultative = CONST(False),
                                                                                         "Policy Code" = FIELD("Policy Code"),
                                                                                         "Treaty Code" = FIELD("Treaty Code"),
                                                                                         "Product Code" = FIELD("Product Code"),
                                                                                         "Lot No." = FIELD("Lot No."),
                                                                                         "Addendum Code" = FIELD("Addendum Code"),
                                                                                         "Inception Date" = FIELD("Inception Date"),
                                                                                         Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(108; "Total Quota Brok Comm1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Broker Commission1 (LCY)" WHERE("Qouta Share" = CONST(True),
                                                                                         Surplus = CONST(False),
                                                                                         Facultative = CONST(False),
                                                                                         "Policy Code" = FIELD("Policy Code"),
                                                                                         "Treaty Code" = FIELD("Treaty Code"),
                                                                                         "Product Code" = FIELD("Product Code"),
                                                                                         "Lot No." = FIELD("Lot No."),
                                                                                         "Addendum Code" = FIELD("Addendum Code"),
                                                                                         "Inception Date" = FIELD("Inception Date"),
                                                                                         Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(109; "Total Surplus Prem1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Premium (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                              Surplus = CONST(True),
                                                                              Facultative = CONST(False),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                              "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Addendum Code" = FIELD("Addendum Code"),
                                                                              "Inception Date" = FIELD("Inception Date"),
                                                                              Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(110; "Total Surplus ced Comm1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission1 (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                                         Surplus = CONST(True),
                                                                                         Facultative = CONST(False),
                                                                                         "Policy Code" = FIELD("Policy Code"),
                                                                                         "Treaty Code" = FIELD("Treaty Code"),
                                                                                         "Product Code" = FIELD("Product Code"),
                                                                                         "Lot No." = FIELD("Lot No."),
                                                                                         "Addendum Code" = FIELD("Addendum Code"),
                                                                                         "Inception Date" = FIELD("Inception Date"),
                                                                                         Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(111; "Total Surplus Brok Comm1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Broker Commission1 (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                                         Surplus = CONST(True),
                                                                                         Facultative = CONST(False),
                                                                                         "Policy Code" = FIELD("Policy Code"),
                                                                                         "Treaty Code" = FIELD("Treaty Code"),
                                                                                         "Product Code" = FIELD("Product Code"),
                                                                                         "Lot No." = FIELD("Lot No."),
                                                                                         "Addendum Code" = FIELD("Addendum Code"),
                                                                                         "Inception Date" = FIELD("Inception Date"),
                                                                                         Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(112; "Total Facultative Prem1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Premium (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                              Surplus = CONST(False),
                                                                              Facultative = CONST(True),
                                                                              "Policy Code" = FIELD("Policy Code"),
                                                                              "Treaty Code" = FIELD("Treaty Code"),
                                                                              "Product Code" = FIELD("Product Code"),
                                                                              "Lot No." = FIELD("Lot No."),
                                                                              "Addendum Code" = FIELD("Addendum Code"),
                                                                              "Inception Date" = FIELD("Inception Date"),
                                                                              Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(113; "Total Fac ced Comm1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Cedant Commission1 (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                                         Surplus = CONST(False),
                                                                                         Facultative = CONST(True),
                                                                                         "Policy Code" = FIELD("Policy Code"),
                                                                                         "Treaty Code" = FIELD("Treaty Code"),
                                                                                         "Product Code" = FIELD("Product Code"),
                                                                                         "Lot No." = FIELD("Lot No."),
                                                                                         "Addendum Code" = FIELD("Addendum Code"),
                                                                                         "Inception Date" = FIELD("Inception Date"),
                                                                                         Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
        field(114; "Total Fac Brok Comm1"; Decimal)
        {
            CalcFormula = Sum("Grp Prem Apportionment"."Broker Commission1 (LCY)" WHERE("Qouta Share" = CONST(False),
                                                                                         Surplus = CONST(False),
                                                                                         Facultative = CONST(True),
                                                                                         "Policy Code" = FIELD("Policy Code"),
                                                                                         "Treaty Code" = FIELD("Treaty Code"),
                                                                                         "Product Code" = FIELD("Product Code"),
                                                                                         "Lot No." = FIELD("Lot No."),
                                                                                         "Addendum Code" = FIELD("Addendum Code"),
                                                                                         "Inception Date" = FIELD("Inception Date"),
                                                                                         Cedant = FIELD(Cedant)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Policy Code", Cedant, "Lot No.", "Product Code", "Treaty Code", "Addendum Code", "Inception Date")
        {
        }
        key(Key2; "Period Ended", "Folio No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Cedants: Record Customer;
        GroupMembers: Record "LF Grp Scheme Members";
        TreatyVal: Record "LIFE Treaty";
        LifeReSetup: Record "Reinsurance Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        TreatyProd: Record "Treaty  Products";
        Text002: Label 'cannot be specified without %1';

    procedure GetCurrency();
    begin
    end;
}

