table 51511041 "Receipts Investment"
{
    // version FINANCE


    fields
    {
        field(1; No; Code[20])
        {

            trigger OnValidate()
            begin

                IF No <> xRec.No THEN BEGIN
                    GenLedgerSetup.GET;
                    NoSeriesMgt.TestManual(GenLedgerSetup."Receipts No");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Date; Date)
        {

            trigger OnValidate()
            begin
                VALIDATE(Amount);
            end;
        }
        field(3; Type; Code[20])
        {
            TableRelation = "Receipts and Payment Types".Code WHERE(Type = FILTER(Receipt));

            trigger OnValidate()
            begin
                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code, Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Receipt);

                IF RecPayTypes.FIND('-') THEN BEGIN
                    "Account Type" := RecPayTypes."Account Type";
                    "Transaction Name" := RecPayTypes.Description;
                    Grouping := RecPayTypes."Default Grouping";
                    //"Investment Type" := RecPayTypes."Investment Type";
                    //"Investment Transcation Type" := RecPayTypes."Investment Transaction Type";
                    //"No. Of Units Required" := RecPayTypes."No. Of Units Required";
                    //"Calculate Interest" := RecPayTypes."Calculate Interest";
                    //"Schedule Mandatory" := RecPayTypes."Schedule Mandatory";

                    IF RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" THEN BEGIN
                        //RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                        IF RecPayTypes."G/L Account" <> '' THEN BEGIN
                            "Account No." := RecPayTypes."G/L Account";
                            VALIDATE("Account No.");
                        END;
                    END;
                END;
            end;
        }
        field(4; "Pay Mode"; Code[20])
        {
            TableRelation = "Pay Modes".Code;
        }
        field(5; "Cheque No"; Code[20])
        {
        }
        field(6; "Cheque Date"; Date)
        {

            trigger OnValidate()
            begin
                GenLedgerSetup.GET;
                IF CALCDATE(GenLedgerSetup."Normal Payments No", "Cheque Date") <= TODAY THEN BEGIN
                    ERROR('The cheque date is not within the allowed range.');
                END;

                IF "Cheque Date" > TODAY THEN BEGIN
                    ERROR('The cheque date is not within the allowed range.');
                END;
            end;
        }
        field(7; "Cheque Type"; Code[20])
        {
            TableRelation = "Cheque Types";
        }
        field(8; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                IF BankAcc.GET("Bank Code") THEN
                    Currency := BankAc."Currency Code";
                /*
                IF "Investment Payment Type"="Investment Payment Type"::"unit trust" THEN BEGIN
                BankAcc.GET("Bank Code");

               "Global Dimension 1 Code":=BankAcc."Global Dimension 1 Code";
               END;
               */

            end;
        }
        field(9; "Received From"; Text[100])
        {
        }
        field(10; "On Behalf Of"; Text[100])
        {
        }
        field(11; Cashier; Code[20])
        {
        }
        field(12; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer WHERE("Customer Posting Group" = FIELD(Grouping))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin
                "Account Name" := '';

                IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer,
                "Account Type"::Vendor, "Account Type"::"IC Partner"] THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No.");
                                "Account Name" := GLAcc.Name;
                                "Global Dimension 6 Code" := '';
                                "Control Ac" := "Account No.";
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                "Account Name" := Cust.Name;
                                "Global Dimension 6 Code" := Cust."Global Dimension 1 Code";
                                "Control Ac" := Cust."Customer Posting Group";

                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                "Account Name" := Vend.Name;
                                "Global Dimension 6 Code" := Vend."Global Dimension 1 Code";
                                "Control Ac" := Vend."Vendor Posting Group";
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                "Account Name" := BankAcc.Name;
                                "Global Dimension 6 Code" := BankAcc."Global Dimension 1 Code";
                                "Control Ac" := BankAcc."Bank Acc. Posting Group";
                            END;
                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No.");
                                //      "Account Name":=FA.Description;
                                //    "Global Dimension 6 Code":=FA."Global Dimension 1 Code";
                            END;
                    END;
            end;
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Account Name"; Text[150])
        {
        }
        field(16; Posted; Boolean)
        {
        }
        field(17; "Date Posted"; Date)
        {
        }
        field(18; "Time Posted"; Time)
        {
        }
        field(19; "Posted By"; Code[20])
        {
        }
        field(20; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                /*
                IF "Calculate Interest" THEN
                  BEGIN
                  "Interest Amount":=CalculateInterest;
                  "Interest On Arrears":=CalculateInterestOnArrears;
                END;
                IF "Interest On Arrears"=0 THEN
                "Capital Amount":=Amount-"Interest Amount";
                //Calculate Revaluation release and Gain/Loss
                  IF "Investment Transcation Type"="Investment Transcation Type"::Disposal THEN
                  BEGIN
                  IF InvestmentRec.GET("Investment No") THEN
                  BEGIN
                IF InvestmentRec."Asset Type"=InvestmentRec."Asset Type"::Equity    THEN
                 BEGIN
                  //InvestmentRec.SETRANGE(InvestmentRec."Date Filter",0D,EndYear(Date));
                  //InvestmentRec.SETRANGE(InvestmentRec."Date Filter",0D,Date-1);
                   InvestmentRec.SETRANGE(InvestmentRec."Date Filter",0D,Date);
                  InvestmentRec.CALCFIELDS(InvestmentRec."No.Of Units",InvestmentRec.Revaluations,InvestmentRec."Acquisition Cost",
                  InvestmentRec.Cost,InvestmentRec."Acquisition Cost (FCY)",InvestmentRec."Revaluations (FCY)");
                
                IF Currency='' THEN BEGIN
                  "Revaluation Release Amount":=ROUND(("No. Of Units"/InvestmentRec."No.Of Units")*InvestmentRec.Revaluations,0.01);
                END ELSE BEGIN
                  "Revaluation Release Amount":=ROUND(("No. Of Units"/InvestmentRec."No.Of Units")*InvestmentRec."Revaluations (FCY)",0.01);
                  "Revaluation Release Amount LCY":=ROUND(("No. Of Units"/InvestmentRec."No.Of Units")*InvestmentRec.Revaluations,0.01);
                
                END;
                  //InvestmentRec.SETRANGE(InvestmentRec."Date Filter",0D,Date-1);
                
                  //kugun
                 InvestmentRec.SETRANGE(InvestmentRec."Date Filter",0D,Date);
                  //end
                  InvestmentRec.CALCFIELDS(InvestmentRec."No.Of Units",InvestmentRec.Revaluations,InvestmentRec."Acquisition Cost",
                  InvestmentRec."Acquisition Cost (FCY)",InvestmentRec."Revaluations (FCY)");
                
                IF Currency='' THEN BEGIN
                  "Cost Reduced":=ROUND(("No. Of Units"/InvestmentRec."No.Of Units")*InvestmentRec.Cost,0.01);
                END ELSE BEGIN
                  "Cost Reduced":=ROUND(("No. Of Units"/InvestmentRec."No.Of Units")*InvestmentRec."Acquisition Cost (FCY)",0.01);
                  "Cost Reduced LCY":=ROUND(("No. Of Units"/InvestmentRec."No.Of Units")*InvestmentRec.Cost,0.01);
                
                END;
                  // MESSAGE('%1',"Cost Reduced");
                  "Gain/Loss on Disposal":="Cost Reduced"-Amount;
                 // "Gain/(Loss) on Disposal LCY":="Cost Reduced LCY"-Amount;
                
                  //MESSAGE('%1',"Gain/Loss on Disposal");
                
                
                  END;
                
                  {
                
                  IF InvestmentRec."Asset Type"=InvestmentRec."Asset Type"::"Unit Trust"    THEN
                  BEGIN
                UnitHolder.GET("Unit Trust Member No");
                UnitHolder.SETRANGE(UnitHolder."Date Filter",0D,Date);
                UnitHolder.CALCFIELDS(UnitHolder."Pension Type",UnitHolder."Pensionable Service",UnitHolder."Employer Normal",UnitHolder.
                Wrong Expression
                  //MESSAGE('%1',UnitHolder.Revaluations);
                  "Revaluation Release Amount":=ROUND(("No. Of Units"/UnitHolder."Pension Type")*UnitHolder."Employer Normal",0.01);
                    "Cost Reduced":=ROUND(("No. Of Units"/UnitHolder."Pension Type")*UnitHolder."Employer additional",0.01);
                     "Gain/Loss on Disposal":="Cost Reduced"-Amount;
                 //MESSAGE('%1',"Revaluation Release Amount");
                 //MESSAGE('%1',"Cost Reduced");
                
                  END;
                
                //end kugun
                 }
                
                
                
                  IF InvestmentRec."Asset Type"=InvestmentRec."Asset Type"::Property THEN
                  BEGIN
                   InvestmentRec.CALCFIELDS(InvestmentRec."No.Of Units",InvestmentRec.Revaluations,InvestmentRec."Acquisition Cost");
                  "Revaluation Release Amount":=InvestmentRec.Revaluations;
                  "Cost Reduced":=InvestmentRec."Acquisition Cost";
                  "Gain/Loss on Disposal":="Cost Reduced"-Amount;
                
                
                  END;
                  END;
                  END;
                
                  IF InvestmentRec.GET("Investment No") THEN
                  BEGIN
                  IF InvestmentRec."Asset Type"=InvestmentRec."Asset Type"::Mortgage THEN
                  BEGIN
                  InvestmentRec.CALCFIELDS(InvestmentRec."Principal Amount",InvestmentRec."Arrears Principal Amount");
                
                  IF InvestmentRec."Arrears Principal Amount">0 THEN
                
                  BEGIN
                  "Repayment Arrears":=Amount-InvestmentRec."Expected Repayment";
                  "Capital Amount":=InvestmentRec."Expected Repayment";
                
                
                   IF PrincipalRepaid(Date,"Investment No") THEN
                   BEGIN
                   "Repayment Arrears":=Amount-"Interest On Arrears";
                  "Capital Amount":=0;
                   "Interest Amount":=0;
                
                
                   END;
                
                
                  END;
                
                
                
                
                  END;
                 END;
                
                  IF RecPayTypes.GET(Type,RecPayTypes.Type::Receipt) THEN
                  //BEGIN
                   IF Vend.GET(Broker) THEN
                   //"Broker Fees":=(Vend."Commision Percentage"/100)*"Gross Amount";
                 // END;
                 */

            end;
        }
        field(21; Rates; Decimal)
        {

            trigger OnValidate()
            begin
                Dividend := Rates * "No. Of Units";
                //Amount:="Price Per Share"*Dividend;
            end;
        }
        field(22; "Transaction Name"; Text[100])
        {
        }
        field(23; "Branch Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(24; "Agent Code"; Code[20])
        {
        }
        field(25; Grouping; Code[20])
        {
            TableRelation = "Customer Posting Group".Code;

            trigger OnLookup()
            begin
                //    "Investment No":=FA."No."
            end;
        }
        field(26; "Global Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Global Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                /*
                  IF "Investment No"=FA."No." THEN
                 "Global Dimension 6 Code":=FA."Global Dimension 1 Code";
                 */

            end;
        }
        field(27; "No. Of Units"; Decimal)
        {

            trigger OnValidate()
            begin
                /*
                 IF "Receipt Payment Type"="Receipt Payment Type"::"Unit Trust" THEN BEGIN
                 IF Brokers.GET("Unit Trust Member No") THEN BEGIN
                
                 Brokers.CALCFIELDS("No.Of Units","Acquisition Cost","Current Value",Revaluations);
                 IF "No. Of Units">Brokers."No.Of Units" THEN
                  ERROR('You cannot redeem more units than you have!!');
                
                
                   IF  Brokers."No.Of Units" >0 THEN
                // "Current unit price":=Brokers."Current Value"/Brokers."No.Of Units" ;
                 //"Price Per Share":="Current unit price";
                VALIDATE("Price Per Share");
                VALIDATE(Amount);
                  END;
                
                 END ELSE BEGIN
                  IF "No. Of Units"<0 THEN
                  ERROR('You Cannot Sale Negative No. of Shares!!');
                
                   VALIDATE(Amount);
                 END;
                
                
                IF FA.GET("Investment No") THEN BEGIN
                FA.CALCFIELDS(FA."No.Of Units");
                //MESSAGE('%1',FA."No.Of Units");
                IF "No. Of Units">FA."No.Of Units" THEN
                  ERROR('You cannot redeem more units than you have!!');
                
                
                END;
                //END;
                IF GLAcc."Investment A/C Type"=GLAcc."Investment A/C Type"::Dividend THEN
                //Amount:="Price Per Share"*Dividend;
                */

            end;
        }
        field(28; "Investment No"; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                  IF FA.GET("Investment No") THEN BEGIN
                   "Global Dimension 6 Code":=FA."Global Dimension 1 Code";
                   "Branch Code":=FA."Global Dimension 2 Code";
                   Broker:=FA.Broker;
                
                IF "Receipt Payment Type"="Receipt Payment Type"::"Unit Trust" THEN BEGIN
                //"No. Of Units":=FA."Minimum Amount"/FA."Initial Unit Price";
                FA.CALCFIELDS("Current Value","No.Of Units");
                IF FA."Current Value"=0 THEN
                "Price Per Share":=FA."Initial Unit Price"
                ELSE
                "Price Per Share":=FA."Current Value"/FA."No.Of Units";
                END;
                
                 IF FA."Asset Type"=FA."Asset Type"::Mortgage THEN BEGIN
                 "Gross Amount":=FA."Expected Repayment";
                 VALIDATE("Gross Amount");
                 END;
                END;
                
                  //VALIDATE(Amount);
                */

            end;
        }
        field(29; "Investment Type"; Option)
        {
            OptionMembers = " ","Money Market",Property,Equity,Mortgage,"Unit Trust";
        }
        field(30; "Schedule Date"; Date)
        {

            trigger OnValidate()
            begin
                /*
                Amount:=0;
                
                Schedule.SETRANGE(Schedule."Investment No","Investment No");
                Schedule.SETRANGE(Schedule."Expected Interest Date",0D,"Schedule Date");
                Schedule.SETRANGE(Schedule.Type,Schedule.Type::Interest);
                Schedule.SETFILTER(Schedule.Received,'%1',FALSE);
                IF Schedule.FIND('-') THEN BEGIN REPEAT
                MyAmount:=MyAmount+Schedule."Expected Interest Amount";
                UNTIL Schedule.NEXT = 0;
                END;
                Amount := MyAmount;
                VALIDATE("Withholding Tax %");
                */

            end;
        }
        field(31; "Investment Transcation Type"; Option)
        {
            OptionMembers = ,Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,"Share-split",Premium,Discounts,"Other Income",Expenses,Principal;
        }
        field(32; "No. Of Units Required"; Boolean)
        {
        }
        field(33; Multiple; Boolean)
        {
        }
        field(34; "Interest Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Interest On Arrears" = 0 THEN
                    "Capital Amount" := Amount - "Interest Amount"
                ELSE
                    "Capital Amount" := Amount - "Repayment Arrears";
            end;
        }
        field(35; "No. of Days"; Integer)
        {
        }
        field(36; "Interest Subsidy"; Decimal)
        {
        }
        field(37; "Tax Benefit"; Decimal)
        {
        }
        field(38; "Capital Amount"; Decimal)
        {
        }
        field(39; "Revaluation Release Amount"; Decimal)
        {
        }
        field(40; "Gain/Loss on Disposal"; Decimal)
        {
        }
        field(41; "Cost Reduced"; Decimal)
        {
        }
        field(42; "Bank Codes"; Code[20])
        {
            // TableRelation = Table0;
        }
        field(43; "Interest On Arrears"; Decimal)
        {
        }
        field(44; "Repayment Arrears"; Decimal)
        {
        }
        field(45; "Calculate Interest"; Boolean)
        {
        }
        field(46; "Receipt No"; Code[20])
        {
            Editable = true;

            trigger OnValidate()
            begin
                /*
                IF "Receipt No" = '' THEN BEGIN
                  GenLedgerSetup.GET;
                  GenLedgerSetup.TESTFIELD(GenLedgerSetup."Posted Receipts No");
                  NoSeriesMgt.InitSeries(GenLedgerSetup."Posted Receipts No",xRec."No. Series",0D,No,"No. Series");
                END;
                */

            end;
        }
        field(47; "Schedule Mandatory"; Boolean)
        {
        }
        field(48; "Control Ac"; Code[20])
        {
        }
        field(49; "FA Posting Type"; Option)
        {
            OptionMembers = " ","Acquisition Cost",Depreciation,"Write-Down",Appreciation,"Custom 1","Custom 2",Disposal,Maintenance;
        }
        field(50; Broker; Code[20])
        {
        }
        field(51; Currency; Code[20])
        {
            TableRelation = Currency;
        }
        field(52; "Commission %"; Decimal)
        {
        }
        field(53; "Withholding Tax %"; Decimal)
        {

            trigger OnValidate()
            begin
                "Whtax Amount" := Amount * "Withholding Tax %" / 100;
                Amount := Amount - "Whtax Amount";
            end;
        }
        field(54; "Broker Fees"; Decimal)
        {

            trigger OnValidate()
            begin
                /* IF "Gross Amount"<>0 THEN
                
                 Amount:="Gross Amount"-"Broker Fees"-"Withholding Tax %"-"Other Charges"-"Revenue Stamp Fees";
                 VALIDATE(Amount);*/

            end;
        }
        field(55; "Gross Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                /*
                 IF "Investment Type"="Investment Type"::Equity THEN
                "Price Per Share" := "Gross Amount"/"No. Of Units";
                IF Brokers1.GET(Broker) THEN
                 "Broker Fees" := ROUND("Gross Amount"*(Brokers1."Fees Percentage"/100),0.01);
                 InvestmentSetup.GET;
                IF InvestmentSetup.GET THEN
                "Other Charges":="Gross Amount"*InvestmentSetup."Other Commission Percentage"/100;
                  IF RecPayTypes.GET(Type,RecPayTypes.Type::Receipt) THEN
                 IF RecPayTypes."Calculate Withholding Tax" THEN
                  IF "Branch Code"<>'FUND01' THEN
                 "Whtax Amount":=(InvestmentSetup."Withholding Tax Percentage"/100)*"Gross Amount"
                  ELSE
                 "Whtax Amount":=0;
                // MESSAGE(FORMAT("Whtax Amount"));
                 //VOO
                 //Amount:= "Gross Amount"-"Whtax Amount";
                Amount:="Gross Amount"-"Broker Fees"-"Whtax Amount"-"Other Charges"-"Revenue Stamp Fees";
                 VALIDATE(Amount);
                {
                IF
                FA.GET("Investment No") THEN BEGIN
                IF
                 FA."Asset Type"= FA."Asset Type"::"Unit Trust" THEN BEGIN
                
                IF Vend.GET("Unit Trust Member No") THEN BEGIN
                     Vend.CALCFIELDS("Balance (LCY)","Acquisition Cost","Acquisition Cost1","Acquisition Cost2");
                       Uninvamt:= Vend."Balance (LCY)"- ( Vend."Acquisition Cost"+ Vend."Acquisition Cost1"+ Vend."Acquisition Cost2");
                  IF Uninvamt<"Gross Amount" THEN BEGIN
                
                
                      ERROR('The Max amount available for Investment is ',Uninvamt);
                     END;
                  END;
                 END;
                END; }
                */

            end;
        }
        field(56; "Price Per Share"; Decimal)
        {
            DecimalPlaces = 1 : 4;

            trigger OnValidate()
            begin
                //VOO
                /*
                InvestmentSetup.GET;
                 "Gross Amount":="No. Of Units"*"Price Per Share";
                 IF RecPayTypes.GET(Type,RecPayTypes.Type::Receipt) THEN
                 IF RecPayTypes."Calculate Withholding Tax" THEN
                 "Whtax Amount":=(InvestmentSetup."Withholding Tax Percentage"/"Gross Amount")*"Gross Amount";
                 Amount:= "Gross Amount"- "Whtax Amount";
                //VALIDATE("Gross Amount");
                VALIDATE(Amount);
                
                FA.GET("Investment No");
                IF FA.UnitTrust=FALSE THEN BEGIN
                    InvestmentSetup.GET;
                 IF RecPayTypes.GET(Type,RecPayTypes.Type::Receipt) THEN
                 IF RecPayTypes."Calculate Withholding Tax" THEN
                 "Whtax Amount":=(InvestmentSetup."Withholding Tax Percentage"/"Gross Amount")*"Gross Amount";
                 Amount:= "Gross Amount"- "Whtax Amount";
                VALIDATE("Gross Amount");
                VALIDATE(Amount);
                END;
                
                IF FA.UnitTrust=TRUE THEN BEGIN
                IF InvestmentRec.GET(FA."Unit Trust") THEN BEGIN
                InvestmentRec.CALCFIELDS("Acquisition Cost");
                FA2.RESET;
                //WHERE(Asset Type=CONST(Equity),UnitTrust=CONST(True))
                //FA.SETRANGE(FA2."Asset Type",FA2."Asset Type"::Equity);
                FA2.SETRANGE(FA2.UnitTrust,TRUE);
                FA2.SETRANGE(FA2."Unit Trust",InvestmentRec."No.");
                IF FA2.FIND('-') THEN BEGIN
                REPEAT
                FA2.CALCFIELDS(FA2."Acquisition Cost","Current Value");
                AmountInvested:=AmountInvested+FA2."Acquisition Cost";
                //"Investments Current Value":="Investments Current Value"+FA."Current Value";
                UNTIL FA2.NEXT=0;
                END;
                END;
                RemainingAmt:=InvestmentRec."Acquisition Cost"-AmountInvested;
                END;
                */

            end;
        }
        field(57; "Whtax Amount"; Decimal)
        {
        }
        field(58; "Other Charges"; Decimal)
        {
            DecimalPlaces = 1 : 4;

            trigger OnValidate()
            begin
                /* IF "Gross Amount"<>0 THEN
                 Amount:="Gross Amount"-"Broker Fees"-"Withholding Tax %"-"Other Charges";
                  VALIDATE(Amount);*/

            end;
        }
        field(59; "Share unit price"; Decimal)
        {
            DecimalPlaces = 1 : 4;
        }
        field(62; Institution; Code[20])
        {

            trigger OnValidate()
            begin
                IF Institutions.GET(Institution) THEN
                    "Intitution Name" := Institutions.Description;
                MODIFY;
            end;
        }
        field(63; "Intitution Name"; Text[100])
        {
        }
        field(64; "Receipt Payment Type"; Option)
        {
            OptionCaption = ',Equity,Money Market,Mortgage,property,Unit Trust';
            OptionMembers = ,Equity,"Money Market",Mortgage,property,"Unit Trust";
        }
        field(65; "Unit Trust Member No"; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                 IF Brokers.GET("Unit Trust Member No") THEN BEGIN
                 "Unit Trust Member Name":=Brokers.Name;
                 Brokers.CALCFIELDS("No.Of Units","Acquisition Cost","Current Value",Revaluations);
                 END ELSE BEGIN
                 "Unit Trust Member Name":='';
                
                 END;
                 */

            end;
        }
        field(66; "Unit Trust Member Name"; Text[100])
        {
        }
        field(67; UnitTrust; Boolean)
        {
        }
        field(68; "Revenue Stamp Fees"; Decimal)
        {

            trigger OnValidate()
            begin
                Amount := "Gross Amount" - "Broker Fees" - "Whtax Amount" - "Other Charges" - "Revenue Stamp Fees";
                VALIDATE(Amount);
            end;
        }
        field(69; "Announcement Date"; Date)
        {

            trigger OnValidate()
            begin
                //PrincipalRepaid("Announcement Date","Investment No");
            end;
        }
        field(70; "Book Clossure Date"; Date)
        {
        }
        field(71; "Dividend Types"; Option)
        {
            OptionMembers = ,"Final Dividend","Interim Dividend","Special Interim","1st & Final";
        }
        field(72; Dividend; Decimal)
        {

            trigger OnValidate()
            begin
                /*GenLedgerSetup.GET;
                IF DimValue.GET(GenLedgerSetup."Shortcut Dimension 7 Code","Branch Code") THEN BEGIN
                 IF DimValue.Taxable THEN BEGIN
                  InvestmentSetup.GET;
                  InvestmentSetup.TESTFIELD("Withholding Tax Percentage");
                   "Whtax Amount":=(InvestmentSetup."Withholding Tax Percentage"/100)*Dividend;
                   "Net Dividend":= Dividend-"Whtax Amount";
                 END
                  ELSE BEGIN
                   "Net Dividend":=Dividend;
                   "Whtax Amount":=0;
                  END;
                END;*/
                /*
                IF InvestmentSetup.GET THEN
                 IF RecPayTypes.GET(Type,RecPayTypes.Type::Receipt) THEN
                  IF RecPayTypes."Calculate Withholding Tax" THEN
                  //MESSAGE('Yes!');
                  IF "Branch Code"<>'FUND01' THEN
                 "Whtax Amount":=(InvestmentSetup."Withholding Tax Percentage"/100)*Dividend
                  ELSE BEGIN
                 "Whtax Amount":=0;
                  END;
                  "Net Dividend":= Dividend-"Whtax Amount";
                */

            end;
        }
        field(73; Remarks; Text[30])
        {
        }
        field(76; "CIFM ID"; Code[10])
        {
        }
        field(77; "CIFM  Email"; Text[60])
        {
        }
        field(78; "CIFM Approval Time"; Time)
        {
        }
        field(79; "CIFM Approval Date"; Date)
        {
        }
        field(80; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(81; Received; Boolean)
        {
        }
        field(82; Scheduled; Boolean)
        {
        }
        field(83; "FIAM Approval Date"; Date)
        {
        }
        field(84; "FIAM Email"; Text[60])
        {
        }
        field(85; Status; Option)
        {
            OptionCaption = 'Pending,1st Approval,2nd Approval,Cheque Printing,Rejected,Approved';
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Rejected,Approved;
        }
        field(86; Select; Boolean)
        {
        }
        field(87; Yield; Decimal)
        {
        }
        field(88; "FIAM ID"; Code[10])
        {
        }
        field(89; "FIAM Approval Time"; Time)
        {
        }
        field(90; "Percentage Redeem"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                //IF ("Percentage Redeem">0) AND  ("Percentage Redeem">=100)   THEN BEGIN
                /*
                IF InvestmentRec.GET("Investment No") THEN BEGIN
                InvestmentRec.CALCFIELDS(InvestmentRec."Current Value",InvestmentRec."Face Value",InvestmentRec."Premium/Discount",
                InvestmentRec."Acquisition Cost",InvestmentRec."Interest Received");
                IF InvestmentRec."Premium/Discount"=0 THEN BEGIN
                "Premium/Discount":="Percentage Redeem"/100*InvestmentRec."Interest Received";
                END ELSE
                "Premium/Discount":="Percentage Redeem"/100*InvestmentRec."Premium/Discount";
                "Gross Amount":="Percentage Redeem"/100*InvestmentRec."Current Value";
                IF InvestmentRec."Face Value"=0 THEN
                "Face Value":="Percentage Redeem"/100*InvestmentRec."Acquisition Cost"-"Premium/Discount"
                ELSE
                "Face Value":="Percentage Redeem"/100*InvestmentRec."Acquisition Cost"-"Premium/Discount";
                //VOO
                //"Face Value":="Percentage Redeem"/100*InvestmentRec."Acquisition Cost";
                "Disposal Amount":=AmortizedValue+ Amount;
                "Gain/Loss on Disposal":= "Face Value"-"Gross Amount";
                MODIFY;
                END;
                //END;
                */

            end;
        }
        field(91; "Clean Price"; Decimal)
        {
        }
        field(92; "Cum-Interest Purchase"; Decimal)
        {
        }
        field(93; "Revaluation Gain/(Loss)"; Decimal)
        {
        }
        field(94; "Cost-Temp"; Decimal)
        {
        }
        field(95; "Revaluation-Temp"; Decimal)
        {
        }
        field(96; "Disposal Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                "Gain/Loss on Disposal" := -("Disposal Amount" - (Amount + "Revaluation Gain/(Loss)" +
               "Accrued Interest"));
            end;
        }
        field(97; "Accrued Interest"; Decimal)
        {
        }
        field(98; "Accrued Interest-Temp"; Decimal)
        {
        }
        field(99; "Capital Amount LCY"; Decimal)
        {
        }
        field(100; "Revaluation Release Amount LCY"; Decimal)
        {
        }
        field(101; "Gain/(Loss) on Disposal LCY"; Decimal)
        {
        }
        field(102; "Cost Reduced LCY"; Decimal)
        {
        }
        field(103; "Premium/Discount"; Decimal)
        {
        }
        field(104; "Face Value"; Decimal)
        {
        }
        field(105; "Net Dividend"; Decimal)
        {
        }
        field(106; Capitalize; Boolean)
        {

            trigger OnValidate()
            begin
                IF Capitalize THEN BEGIN
                    IF "Price Per Share" <> 0 THEN BEGIN
                        IF "Net Dividend" <> 0 THEN BEGIN
                            "Capitalized Units" := "Net Dividend" DIV "Price Per Share";
                            "Non Capitalized Units" := "Net Dividend" / "Price Per Share" - "Capitalized Units";
                        END;
                    END;
                END ELSE BEGIN
                    "Capitalized Units" := 0;
                    "Non Capitalized Units" := "Net Dividend" / "Price Per Share";
                END;
            end;
        }
        field(107; "Capitalized Units"; Decimal)
        {
        }
        field(108; "Non Capitalized Units"; Decimal)
        {
        }
        field(109; "Dividend Capitalized"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Price Per Share" <> 0 THEN BEGIN
                    IF "Net Dividend" <> 0 THEN BEGIN
                        "Capitalized Units" := "Dividend Capitalized" DIV "Price Per Share";
                        "Non Capitalized Units" := "Net Dividend" / "Price Per Share" - "Capitalized Units";
                    END;
                END;
            end;
        }
        field(110; "Transfer Agent"; Code[20])
        {
        }
        field(111; "1st Approver"; Code[20])
        {
        }
        field(112; "1st Approval Date"; Date)
        {
        }
        field(113; "2nd Approver"; Code[20])
        {
        }
        field(114; "2nd Approval Date"; Date)
        {
        }
        field(115; "Negotiated Exch. Rate"; Decimal)
        {
        }
        field(116; "Percentage Provision"; Decimal)
        {

            trigger OnValidate()
            begin
                "Provision Amount" := ("Percentage Provision" / 100) * ("Carrying Value" - "Recoverable Amount");
                MODIFY;
            end;
        }
        field(117; "Recoverable Amount"; Decimal)
        {
        }
        field(118; "Carrying Value"; Decimal)
        {
        }
        field(119; "Received Interest"; Decimal)
        {
        }
        field(120; "Provision Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    var
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Trip Advances Setup";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenLedgerSetup: Record "Cash Management Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        CashierLinks: Record "Cash Management Setup";
        MortgageRec: Record "Trip Advances Setup";
        LastInterestCalcDate: Date;
        NoOfDays4Calc: Integer;
        InterestCalcDate: Date;
        InterestAmount: Decimal;
        NextmonthStartdate: Date;
        MonthInt: Integer;
        YearInt: Integer;
        InterestSubsidy: Decimal;
        MarketRateInterest: Decimal;
        Invsetup: Record "Staff Posting Group";
        InvestmentRec: Record "Trip Advances Setup";
        InterestOnArrears: Decimal;
        BankAc: Record "Bank Account";
        InvestmentSetup: Record "Staff Posting Group";
        Institutions: Record Institutions;
        Brokers: Record Vendor;
        "Current unit price": Decimal;
        UnitHolder: Record Vendor;
        X: Decimal;
        Uninvamt: Decimal;
        AmountInvested: Decimal;
        FA2: Record "Trip Advances Setup";
        RemainingAmt: Decimal;
        Payments: Record "Tarriff Codes";
        AmortizedValue: Decimal;
        Brokers1: Record Institutions;
        DimValue: Record "Dimension Value";
        Schedule: Record Payments1;
        MyAmount: Decimal;
        NoOfDays: Integer;
        InterestRate: Integer;
        UnearnedInterest: Decimal;
}

