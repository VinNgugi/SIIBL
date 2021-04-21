table 51513080 "Insure Header Archive"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy;
        }
        field(2; "No."; Code[20])
        {
        }
        field(3; "Insured No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate();
            begin
                IF Cust.GET("Insured No.") THEN BEGIN
                    "Insured Name" := Cust.Name;
                    "Agent/Broker" := Cust."Intermediary No.";
                    VALIDATE("Agent/Broker");
                END;
                //MESSAGE('%1',Cust.Name)
            end;
        }
        field(4; "Family Name"; Text[20])
        {

            trigger OnValidate();
            begin
                //"Family Name":= insmangmt.StandardizeNames("Family Name");

                //"Sell-to Customer Name":=FORMAT(Title)+' '+"First Names(s)"+ ' ' +"Family Name";


                /*IF Insetup.GET THEN
                BEGIN
                IF "Sell-to Customer No."='' THEN
                "Sell-to Customer Template Code":=Insetup."Sell-to Customer Template Code";
                END;*/

            end;
        }
        field(5; "First Names(s)"; Text[20])
        {

            trigger OnValidate();
            begin
                //"First Names(s)":= insmangmt.StandardizeNames("First Names(s)");
                //"Sell-to Customer Name":=FORMAT(Title)+' '+"First Names(s)"+ ' ' +"Family Name";
            end;
        }
        field(6; Title; Option)
        {
            OptionMembers = Mr,Mrs,Ms,Dr,Prof;

            trigger OnValidate();
            begin
                //"Sell-to Customer Name":=FORMAT(Title)+' '+"First Names(s)"+ ' ' +"Family Name";
            end;
        }
        field(7; "Marital Status"; Option)
        {
            OptionMembers = Single,Married,Divorced,"Widowed ";
        }
        field(8; Sex; Option)
        {
            OptionMembers = Male,Female;
        }
        field(9; "Date of Birth"; Date)
        {

            trigger OnValidate();
            begin

                //Age:=insmangmt.AgeCalculator("Date of Birth","Document Date");
                //Test if age is valid
                //insmangmt.TestValidAge(Rec);
                //VALIDATE(Age);
            end;
        }
        field(10; "Height Unit"; Option)
        {
            OptionMembers = m,ft,inches,cm;
        }
        field(11; Height; Decimal)
        {
            DecimalPlaces = 1 : 2;

            trigger OnValidate();
            begin
                /*IF "Height Unit"="Height Unit"::ft THEN
                 "Height (m)":=Height*0.3048;
                 IF "Height Unit"="Height Unit"::inches THEN
                 "Height (m)":=Height*0.0254;
                 IF "Height Unit"="Height Unit"::cm THEN
                 "Height (m)":=Height*0.01;
                 IF "Height Unit"="Height Unit"::m THEN
                 "Height (m)":=Height;*/

            end;
        }
        field(12; "Weight Unit"; Option)
        {
            OptionMembers = Kg,Lbs,Stone;
        }
        field(13; Weight; Decimal)
        {

            trigger OnValidate();
            begin

                /*IF "Weight Unit" = "Weight Unit"::Lbs THEN
                  "Weight (Kg)":=Weight*0.45;
                
                  IF "Weight Unit"="Weight Unit"::Kg THEN
                  "Weight (Kg)":=Weight;
                
                   IF "Weight Unit"="Weight Unit"::Stone THEN
                  "Weight (Kg)":=Weight*6.35;
                
                
                
                  //BMI:=insmangmt.CalculateBMIenglish(Weight,Height);
                
                  //IF "Weight Unit"="Weight Unit"::Kg THEN
                   BMI:=insmangmt.CalculateBMImetric("Weight (Kg)","Height (m)");  */

            end;
        }
        field(14; Industry; Text[20])
        {
            TableRelation = "Industry Group";
        }
        field(15; Occupation; Text[130])
        {
        }
        field(16; Nationality; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(17; "Country of Residence"; Code[10])
        {
            TableRelation = "Country/Region";

            trigger OnValidate();
            begin
                /* IF Country.GET("Country of Residence") THEN
                 // "Country of Residence Desc":=Country.Name;

                  IF Nationality="Country of Residence" THEN

                  //Test validity
                  BEGIN
                  Insetup.GET;

                  IF ZonedCountries.GET(Insetup."Default Zone","Country of Residence") THEN
                  BEGIN
                  IF NOT ZonedCountries."Allowed for Nationals" THEN
                  ERROR ('Sorry a %1 National living in %2 is not allowed to take this policy',"Nationality Description",
                  "Country of Residence Desc");
                  END;
                  END;

                  {//Fill area based on availability of
                   CountriesPerArea.RESET;
                   CountriesPerArea.SETRANGE(CountriesPerArea.Country,"Country of Residence");
                   IF CountriesPerArea.FIND('+') THEN
                   "Area of Cover":=CountriesPerArea.Area;}*/

            end;
        }
        field(18; Mobile; Code[14])
        {
        }
        field(19; "Premium Payment Frequency"; Option)
        {
            OptionMembers = " ","Annual Payment","Bi-Annual Payment","Quarterly Payment","Monthy Payment";
        }
        field(20; Forms; Text[130])
        {

            trigger OnValidate();
            begin
                /* IF AreaofCover.GET("Area of Cover","Policy Type") THEN
                 BEGIN

                 OptionsSelected.RESET;
                 OptionsSelected.SETRANGE(OptionsSelected."Document Type","Document Type");
                 OptionsSelected.SETRANGE(OptionsSelected."No.","No.");
                 OptionsSelected.SETRANGE(OptionsSelected.Code,AreaofCover."Default Option");
                 IF OptionsSelected.FIND('-') THEN
                 BEGIN

                 OptionsSelected.Selected:=TRUE
                 END
                 ELSE
                 OptionsSelected.Selected:=FALSE;
                 OptionsSelected.MODIFY;
                 END;   */

            end;
        }
        field(21; "Policy Type"; Code[10])
        {
            TableRelation = "Policy Type".Code;

            trigger OnValidate();
            begin



                OptionsSelected.RESET;
                OptionsSelected.SETRANGE(OptionsSelected."Document Type", "Document Type");
                OptionsSelected.SETRANGE(OptionsSelected."No.", "No.");
                OptionsSelected.DELETEALL;



                InsuranceType.RESET;

                IF "Cover Type" = "Cover Type"::Individual THEN
                    InsuranceType.SETFILTER(InsuranceType."Option Applicable to", '<>%1', InsuranceType."Option Applicable to"::Group);

                IF "Cover Type" = "Cover Type"::Group THEN
                    InsuranceType.SETFILTER(InsuranceType."Option Applicable to", '<>%1', InsuranceType."Option Applicable to"::Individual);


                IF InsuranceType.FIND('-') THEN BEGIN

                    REPEAT
                        OptionsSelected.INIT;
                        OptionsSelected."Document Type" := "Document Type";
                        OptionsSelected."No." := "No.";
                        OptionsSelected.Code := InsuranceType.Code;
                        OptionsSelected.VALIDATE(OptionsSelected.Code);
                        OptionsSelected.Description := InsuranceType.Description;
                        OptionsSelected."Discount %" := InsuranceType."Discount Percentage";
                        OptionsSelected."Loading %" := InsuranceType."Loading Percentage";
                        OptionsSelected."Discount Amount" := InsuranceType."Discount Amount";
                        OptionsSelected."Loading Amount" := InsuranceType."Loading Amount";


                        OptionsSelected.INSERT;
                    UNTIL InsuranceType.NEXT = 0;
                END;


                IF PolicyRecs.GET("Policy Type") THEN BEGIN
                    "Policy Description" := COPYSTR(PolicyRecs.Description, 1, 50);
                    "Commission Due" := PolicyRecs."Commision % age(SIIBL)";
                    "Mode of Conveyance" := PolicyRecs.Conveyance;
                END
                ELSE
                    ERROR('Policy is non-existent');



                saleslinerec.RESET;
                saleslinerec.SETRANGE(saleslinerec."Document Type", "Document Type");
                saleslinerec.SETRANGE(saleslinerec."Document No.", "No.");
                IF saleslinerec.FIND('+') THEN
                    LastNo := saleslinerec."Line No.";

                //Delete if already exists

                InsurerPolicyDetails.RESET;
                InsurerPolicyDetails.SETRANGE(InsurerPolicyDetails.Insurer, "Agent/Broker");
                InsurerPolicyDetails.SETRANGE(InsurerPolicyDetails."Policy Type", "Policy Type");
                IF InsurerPolicyDetails.FIND('-') THEN BEGIN
                    REPEAT

                        saleslinerec.INIT;
                        saleslinerec."Document Type" := "Document Type";
                        saleslinerec."Document No." := "No.";
                        LastNo := LastNo + 10000;
                        saleslinerec."Line No." := LastNo;
                        saleslinerec.Description := InsurerPolicyDetails.Description;
                        saleslinerec."Actual Value" := InsurerPolicyDetails."Actual Value";
                        saleslinerec."Description Type" := InsurerPolicyDetails."Description Type";
                        saleslinerec."Text Type" := InsurerPolicyDetails."Text Type";
                        saleslinerec.INSERT;

                    UNTIL InsurerPolicyDetails.NEXT = 0;
                END
                ELSE BEGIN
                    PolicyDetails.RESET;
                    PolicyDetails.SETRANGE(PolicyDetails."Policy Type", "Policy Type");
                    IF PolicyDetails.FIND('-') THEN BEGIN
                        REPEAT
                            saleslinerec.INIT;
                            saleslinerec."Document Type" := "Document Type";
                            saleslinerec."Document No." := "No.";
                            LastNo := LastNo + 10000;
                            saleslinerec."Line No." := LastNo;
                            saleslinerec.Description := PolicyDetails.Description;
                            saleslinerec."Description Type" := PolicyDetails."Description Type";
                            saleslinerec."Actual Value" := PolicyDetails."Actual Value";
                            saleslinerec."Text Type" := PolicyDetails."Text Type";
                            saleslinerec.INSERT;


                        UNTIL PolicyDetails.NEXT = 0;
                    END;
                END;
            end;
        }
        field(22; "Agent/Broker"; Code[10])
        {
            TableRelation = Customer WHERE("Customer Type" = CONST("Agent/Broker"));

            trigger OnValidate();
            begin
                IF Cust.GET("Agent/Broker") THEN BEGIN
                    "Brokers Name" := Cust.Name;
                    /*commissionTab.RESET;
                    commissionTab.SETRANGE(commissionTab.UnderWriter,"Agent/Broker");
                    commissionTab.SETRANGE(commissionTab.Code,"Policy Type");
                    IF commissionTab.FIND('-') THEN
                    BEGIN
                    //IF commissionTab."Commision Calculation"=commissionTab."Commision Calculation"::"% age of Premium" THEN
                    "Commission Payable 1":=commissionTab."Commission %age"
                    //ELSE
                     // "Commission Payable 1":=commissionTab.Amount;
                    //
                    END
                    ELSE
                    ERROR('Please Setup Commission Due from %1', Vendor.Name);*/
                END;

            end;
        }
        field(23; Underwriter; Code[10])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate();
            begin
                IF vendor.GET("Agent/Broker") THEN BEGIN
                    //"Agent/Broker  Name":=Vendor.Name;

                END;

                saleslinerec.RESET;
                saleslinerec.SETRANGE(saleslinerec."Document Type", "Document Type");
                saleslinerec.SETRANGE(saleslinerec."Document No.", "No.");
                IF saleslinerec.FIND('+') THEN
                    LastNo := saleslinerec."Line No.";

                //Delete if already exists

                /*InsurerPolicyDetails.RESET;
                InsurerPolicyDetails.SETRANGE(InsurerPolicyDetails.Insurer,"Agent/Broker");
                InsurerPolicyDetails.SETRANGE(InsurerPolicyDetails."Policy Type","Policy Type");
                IF InsurerPolicyDetails.FIND('-') THEN
                BEGIN
                REPEAT

                 saleslinerec.INIT;
                 saleslinerec."Document Type":="Document Type";
                 saleslinerec."Document No.":="No.";
                 LastNo:=LastNo+10000;
                 saleslinerec."Line No.":= LastNo;
                 saleslinerec.Description:=InsurerPolicyDetails.Description;
                 saleslinerec."Actual Value":=InsurerPolicyDetails."Actual Value";
                 saleslinerec."Description Type":=InsurerPolicyDetails."Description Type";
                 saleslinerec."Text Type":=InsurerPolicyDetails."Text Type";
                 saleslinerec.INSERT;

                UNTIL InsurerPolicyDetails.NEXT=0;
                END
                ELSE
                BEGIN
                PolicyDetails.RESET;
                PolicyDetails.SETRANGE(PolicyDetails."Policy Type","Policy Type");
                IF PolicyDetails.FIND('-') THEN
                BEGIN
                REPEAT
                 saleslinerec.INIT;
                 saleslinerec."Document Type":="Document Type";
                 saleslinerec."Document No.":="No.";
                 LastNo:=LastNo+10000;
                 saleslinerec."Line No.":= LastNo;
                 saleslinerec.Description:=PolicyDetails.Description;
                 saleslinerec."Description Type":=PolicyDetails."Description Type";
                 saleslinerec."Actual Value":=PolicyDetails."Actual Value";
                 saleslinerec."Text Type":=PolicyDetails."Text Type";
                 saleslinerec.INSERT;


                UNTIL PolicyDetails.NEXT=0;
                END;
                END; */

            end;
        }
        field(24; "Exclude from Renewal"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(25; "Brokers Name"; Text[50])
        {
            Editable = false;
        }
        field(26; "Undewriter Name"; Text[60])
        {
            Editable = false;
        }
        field(27; "Discount %"; Decimal)
        {
            Editable = true;

            trigger OnValidate();
            begin
                /*SalesLine.RESET;
                SalesLine.SETRANGE(SalesLine."Document Type","Document Type");
                SalesLine.SETRANGE(SalesLine."Document No.","No.");
                SalesLine.SETRANGE(SalesLine."Description Type",SalesLine."Description Type"::"Schedule of Insured");
                IF SalesLine.FIND('-') THEN
                REPEAT
                    IF SalesLine."Gross Premium"<>0 THEN
                    BEGIN
                     SalesLine."Reduction %":="Discount %";

                     SalesLine.VALIDATE(SalesLine."Reduction %");
                     SalesLine.MODIFY;
                    END;
                UNTIL SalesLine.NEXT=0; */

            end;
        }
        field(28; "Insurance Type"; Code[10])
        {

            trigger OnValidate();
            begin
                //"Premium Amount" := insmangmt.CalculatePremium(Age,"Policy Type","Insurance Type","Order Date","Payment Terms Code",
                //"Area of Cover","Excess Level");

                //Update Cover Details


                /*QuoteCoverDetails.RESET;
                //QuoteCoverDetails.SETRANGE(QuoteCoverDetails."Insurance Type","Insurance Type");
                QuoteCoverDetails.SETRANGE(QuoteCoverDetails."Document No.","No.");
                IF QuoteCoverDetails.FIND('-') THEN
                QuoteCoverDetails.DELETEALL;
                
                
                CoverDetails.RESET;
                CoverDetails.SETRANGE(CoverDetails."Insurance Type","Insurance Type");
                IF CoverDetails.FIND('-') THEN
                REPEAT
                
                   QuoteCoverDetails.INIT;
                   QuoteCoverDetails."Document No.":="No.";
                   QuoteCoverDetails."No.":=CoverDetails."Cover Id";
                   QuoteCoverDetails."Insurance Type":=CoverDetails."Insurance Type";
                   QuoteCoverDetails.Type:=CoverDetails.Type;
                   QuoteCoverDetails."Policy Type":=CoverDetails."Policy Type";
                   QuoteCoverDetails.Description:=CoverDetails.Description;
                   QuoteCoverDetails."Type Description":=CoverDetails."Type Description";
                   QuoteCoverDetails."Text Type":=CoverDetails."Text Type";
                   QuoteCoverDetails.INSERT;
                
                
                UNTIL CoverDetails.NEXT=0;
                
                
                   IF InsuranceType.GET("Insurance Type","Policy Type","Policy Class") THEN
                   BEGIN
                    "Cover Type Description":=InsuranceType.Description;
                
                   OptionsSelected.RESET;
                   OptionsSelected.SETRANGE(OptionsSelected."Document Type","Document Type");
                   OptionsSelected.SETRANGE(OptionsSelected."No.","No.");
                   OptionsSelected.SETRANGE(OptionsSelected.Code,InsuranceType."Default Option");
                   IF OptionsSelected.FIND('-') THEN
                   BEGIN
                
                   OptionsSelected.Selected:=TRUE;
                   OptionsSelected.MODIFY;
                   END
                
                   END; */

            end;
        }
        field(29; "Premium Amount"; Decimal)
        {
        }
        field(30; "Effective Start date"; Date)
        {
        }
        field(31; "Group Name"; Text[30])
        {
        }
        field(32; "Excess Level"; Code[10])
        {

            trigger OnValidate();
            begin
                /*IF "Cover Type"="Cover Type"::Individual THEN
                "Premium Amount" := insmangmt.CalculatePremium(Age,"Policy Type","Insurance Type","Document Date","Payment Terms Code",
                "Area of Cover","Excess Level");
                
                { saleslinerec.RESET;
                 saleslinerec.SETRANGE(saleslinerec."Document Type","Document Type");
                 saleslinerec.SETRANGE(saleslinerec."Document No.","No.");
                 saleslinerec.SETRANGE(saleslinerec."Cover Type",saleslinerec."Cover Type"::Dependant);
                 IF saleslinerec.FIND('-') THEN
                 REPEAT
                   saleslinerec."Sell-to Customer No.":="Sell-to Customer No.";
                   saleslinerec."Area of Cover":="Area of Cover";
                   saleslinerec."Policy Type":="Policy Type";
                   saleslinerec."Insurance Type":="Insurance Type";
                   saleslinerec.VALIDATE(saleslinerec."Insurance Type");
                
                   saleslinerec.VALIDATE(saleslinerec.Age);
                   saleslinerec.Quantity:=1;
                   saleslinerec."Unit Price":=saleslinerec."Gross Premium";
                   saleslinerec.VALIDATE(saleslinerec."Unit Price");
                   saleslinerec."Gen. Bus. Posting Group":="Gen. Bus. Posting Group";
                   saleslinerec."VAT Bus. Posting Group":="VAT Bus. Posting Group";
                   IF Insetup.GET THEN BEGIN
                   saleslinerec."VAT Bus. Posting Group":=Insetup."Default VAT Bus. Posting Group";
                   SalesLine."VAT Prod. Posting Group":=Insetup."Default VAT Pro. Posting Group";
                
                
                   END;
                
                   saleslinerec.VALIDATE(saleslinerec.Quantity);
                
                   saleslinerec.MODIFY;
                
                UNTIL saleslinerec.NEXT=0; }
                
                   {IF PolicyExcess.GET("Policy Type","Insurance Type","Excess Level") THEN
                   BEGIN
                
                   OptionsSelected.RESET;
                   OptionsSelected.SETRANGE(OptionsSelected."Document Type","Document Type");
                   OptionsSelected.SETRANGE(OptionsSelected."No.","No.");
                   OptionsSelected.SETRANGE(OptionsSelected.Code,PolicyExcess."Default Option");
                   IF OptionsSelected.FIND('-') THEN
                   BEGIN
                
                   OptionsSelected.Selected:=TRUE
                   END
                   ELSE
                   OptionsSelected.Selected:=FALSE;
                   OptionsSelected.MODIFY;
                   END;   } */

            end;
        }
        field(33; "Policy No"; Code[30])
        {
            TableRelation = "Insure Header"."No." WHERE("Document Type" = CONST(Policy));

            trigger OnValidate();
            begin
                //"Posting Description":=COPYSTR(STRSUBSTNO('POLICY %1-%2',"Policy No","Policy Type"),1,50);
            end;
        }
        field(34; "Quote Type"; Option)
        {
            Editable = true;
            InitValue = New;
            OptionMembers = " ",New,Modification,Renewal;
        }
        field(35; "No. of Lives"; Integer)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(36; "No. of Members"; Integer)
        {
            FieldClass = Normal;
        }
        field(37; "No. of Dependants"; Integer)
        {
            FieldClass = Normal;
        }
        field(38; "Broker #2"; Code[10])
        {

            trigger OnValidate();
            begin
                /*IF  Vendor.GET("Broker #2") THEN
                 BEGIN
                 "Broker #2 Name":=Vendor.Name;
                  commissionTab.RESET;
                  commissionTab.SETRANGE(commissionTab."UnderWriter/Broker","Broker #2");
                  commissionTab.SETRANGE(commissionTab."Policy Type","Policy Type");
                  IF commissionTab.FIND('-') THEN
                  BEGIN
                  IF commissionTab."Commision Calculation"=commissionTab."Commision Calculation"::"% age of Premium" THEN
                  "Commission Payable 1":=commissionTab."% age"
                  ELSE
                    "Commission Payable 1":=commissionTab.Amount;

                  END
                  ELSE
                  ERROR('Please Setup Commission Due from %1', Vendor.Name);
                 END; */

            end;
        }
        field(39; "Broker #3"; Code[10])
        {

            trigger OnValidate();
            begin
                /* IF  Vendor.GET("Broker #3") THEN
                  BEGIN
                  "Broker #3 Name":=Vendor.Name;
                   commissionTab.RESET;
                   commissionTab.SETRANGE(commissionTab."UnderWriter/Broker","Broker #3");
                   commissionTab.SETRANGE(commissionTab."Policy Type","Policy Type");
                   IF commissionTab.FIND('-') THEN
                   BEGIN
                   IF commissionTab."Commision Calculation"=commissionTab."Commision Calculation"::"% age of Premium" THEN
                   "Commission Payable 1":=commissionTab."% age"
                   ELSE
                     "Commission Payable 1":=commissionTab.Amount;
                
                   END
                   ELSE
                   ERROR('Please Setup Commission Due from %1', Vendor.Name);
                  END; */

            end;
        }
        field(40; "Broker #2 Name"; Text[20])
        {
            Editable = false;
        }
        field(41; "Broker #3 Name"; Text[20])
        {
            Editable = false;
        }
        field(42; "Commission Due"; Decimal)
        {
        }
        field(43; "Commission Payable 1"; Decimal)
        {
        }
        field(44; "Commission Payable 2"; Decimal)
        {
        }
        field(45; "Commission Payable 3"; Decimal)
        {
        }
        field(46; "Correspondence Country/State"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(47; "Phone No."; Text[20])
        {
        }
        field(48; "Fax No"; Text[20])
        {
        }
        field(49; "E-mail"; Text[30])
        {
        }
        field(50; "Payment Method"; Option)
        {
            OptionMembers = Annual,"Bi-Annual",Quarterly,Monthly;
        }
        field(51; "Cover Type"; Option)
        {
            OptionMembers = " ",Individual,Group;
        }
        field(52; "Total Premium Amount"; Decimal)
        {
            CalcFormula = Sum("Insure Lines".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                           "Document No." = FIELD("No."),
                                                           "Description Type" = CONST("Schedule of Insured")));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Total  Discount Amount"; Decimal)
        {
            CalcFormula = Sum("Insure Lines".Amount WHERE("Description Type" = CONST(Deductible)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Total Commission Due"; Decimal)
        {
            Editable = false;
        }
        field(55; "Total Commission Owed"; Decimal)
        {
            Editable = false;
        }
        field(56; "Total Training Levy"; Decimal)
        {
            Editable = false;
        }
        field(57; "Total Stamp Duty"; Decimal)
        {
            Editable = false;
        }
        field(58; "Total Tax"; Decimal)
        {
            FieldClass = Normal;
        }
        field(59; "From Date"; Date)
        {

            trigger OnValidate();
            begin
                IF PolicyRecs.GET("Policy Type") THEN BEGIN
                    IF FORMAT(PolicyRecs.Period) = '1Y' THEN BEGIN
                        "To Date" := CALCDATE('1Y', "From Date");
                        "Expected Renewal Date" := CALCDATE('1Y', "From Date");
                        "From Time" := PolicyRecs."Start Time";
                        "To Time" := PolicyRecs."End Time";
                    END
                    ELSE BEGIN
                        "To Date" := CALCDATE('1Y', "From Date") - 1;
                        "Expected Renewal Date" := CALCDATE('1Y', "From Date");
                    END;
                END;
            end;
        }
        field(60; "To Date"; Date)
        {
        }
        field(61; "From Time"; Text[4])
        {
        }
        field(62; "To Time"; Text[4])
        {
        }
        field(63; "Policy Status"; Option)
        {
            Editable = true;
            OptionMembers = " ",Live,Expired,Lapsed,Cancelled,Renewed;
        }
        field(64; "Expected Renewal Date"; Date)
        {
        }
        field(65; "Expected Renewal Time"; Time)
        {
        }
        field(66; "Modification Type"; Option)
        {
            OptionMembers = " ",Addition,Deletion;
        }
        field(67; "Policy Class"; Code[10])
        {
            TableRelation = "Insurance Class";
        }
        field(68; "Cover Period"; Code[10])
        {
            TableRelation = "Payment Terms";
        }
        field(69; "Mid Term Adjustment Factor"; Decimal)
        {
            Editable = false;
        }
        field(70; "Copied from No."; Code[20])
        {
        }
        field(71; "Payment Mode"; Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(72; "Total Net Premium"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Line Amount" WHERE("Document No." = FIELD("No."),
                                                                "Document Type" = FIELD("Document Type")));
            FieldClass = FlowField;
        }
        field(73; "EHS Policy No"; Code[20])
        {
        }
        field(74; "Created By"; Code[80])
        {
            Editable = false;
            TableRelation = User;
        }
        field(75; "Follow Up Person"; Code[80])
        {
            TableRelation = User;
        }
        field(76; "Follow Up Date"; Date)
        {
        }
        field(77; "Renewal Date"; Date)
        {
        }
        field(78; "Vessel Name"; Text[30])
        {
        }
        field(79; "Mode of Conveyance"; Text[150])
        {
        }
        field(80; "Response Period"; DateTime)
        {
        }
        field(81; "Policy Description"; Text[50])
        {
            Editable = false;
        }
        field(82; "Cover Type Description"; Text[50])
        {
            Editable = false;
        }
        field(83; "Total Sum Insured"; Decimal)
        {
            CalcFormula = Sum("Insure Lines"."Sum Insured" WHERE("Document Type" = FIELD("Document Type"),
                                                                  "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(84; "Order Hereon"; Decimal)
        {
        }
        field(85; "Insured Name"; Text[80])
        {
        }
        field(86; "ID/Passport No."; Code[20])
        {
        }
        field(87; "PIN No."; Code[20])
        {
        }
        field(88; "No. Series"; Code[10])
        {
        }
        field(89; "Posting Date"; Date)
        {
        }
        field(90; "Document Date"; Date)
        {
        }
        field(91; "No. Of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments";
        }
        field(92; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
        }
        field(93; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                /*IF "Currency Factor" <> xRec."Currency Factor" THEN
                  UpdateSalesLines(FIELDCAPTION("Currency Factor"),FALSE);*/

            end;
        }
        field(94; "Premium Financier"; Code[20])
        {
            TableRelation = Customer;
        }
        field(95; "Premium Financier Name"; Text[50])
        {
        }
        field(96; "Sales Rep. ID"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(97; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(98; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(99; "Dimension Set ID"; Integer)
        {
        }
        field(100; "Insured Address"; Text[80])
        {
        }
        field(101; "Insured Address 2"; Text[80])
        {
        }
        field(102; "Post Code"; Code[10])
        {
            TableRelation = "Post Code";
        }
        field(103; "Quotation No."; Code[20])
        {
        }
        field(104; "Cover Start Date"; Date)
        {
        }
        field(105; "Cover End Date"; Date)
        {

            trigger OnValidate();
            begin
                shortCover.RESET;
                shortCover.SETRANGE(shortCover."Ending No. of  Period", InsMngt.GetNoOfMonths("Cover Start Date", "Cover End Date"));
                IF shortCover.FINDLAST THEN BEGIN
                    "Short Term Cover" := shortCover.Code;
                    "No. Of Months" := shortCover."Ending No. of  Period";
                    "Short term Cover Percent" := shortCover."Percentage Of Prem. Applicable";
                END;
                //VALIDATE("Short Term Cover");
                //MESSAGE('doing it');
            end;
        }
        field(106; Posted; Boolean)
        {
        }
        field(107; "Posted By"; Code[80])
        {
        }
        field(108; "Posted DateTime"; DateTime)
        {
        }
        field(109; "Short Term Cover"; Code[20])
        {
            TableRelation = "Short Term Cover";

            trigger OnValidate();
            begin
                IF shortCover.GET("Short Term Cover") THEN BEGIN

                    "Cover Start Date" := "From Date";
                    "Cover End Date" := CALCDATE(shortCover."Period Length", "Cover Start Date") - 1;
                    "No. Of Months" := shortCover."Ending No. of  Period";
                    "Short term Cover Percent" := shortCover."Percentage Of Prem. Applicable";
                END;
            end;
        }
        field(110; "No. Of Months"; Integer)
        {
        }
        field(111; "Short term Cover Percent"; Decimal)
        {
        }
        field(112; Status; Option)
        {
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(113; "Language Code"; Code[10])
        {
        }
        field(114; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";
        }
        field(115; "Bill To Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(5043; "Interaction Exist"; Boolean)
        {
            Caption = 'Interaction Exist';
        }
        field(5044; "Time Archived"; Time)
        {
            Caption = 'Time Archived';
        }
        field(5045; "Date Archived"; Date)
        {
            Caption = 'Date Archived';
        }
        field(5046; "Archived By"; Code[50])
        {
            Caption = 'Archived By';
        }
        field(5047; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "Created By" := USERID;
        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;

        IF "Document Type" = "Document Type"::Quote THEN BEGIN //Quote


            IF "Quote Type" = "Quote Type"::New THEN BEGIN
                IF "No." = '' THEN BEGIN
                    TestNoSeries;
                    NoSeriesMgt.InitSeries(InsSetup."New Quotation Nos", xRec."No. Series", "Posting Date", "No.", "No. Series");
                END;
            END;

            IF "Quote Type" = "Quote Type"::Renewal THEN BEGIN
                IF "No." = '' THEN BEGIN
                    TestNoSeries;
                    NoSeriesMgt.InitSeries(InsSetup."Renewal Quote Nos", xRec."No. Series", "Posting Date", "No.", "No. Series");
                END;
            END;

            IF "Quote Type" = "Quote Type"::Modification THEN BEGIN
                IF "No." = '' THEN BEGIN
                    //MESSAGE('Attempting to create an additional quote');
                    TestNoSeries;
                    NoSeriesMgt.InitSeries(InsSetup."Modification Quote Nos", xRec."No. Series", "Posting Date", "No.", "No. Series");
                END;
            END;
        END;

        IF "Document Type" = "Document Type"::"Debit Note" THEN BEGIN //Debit
            TestNoSeries;
            NoSeriesMgt.InitSeries(InsSetup."Debit Note", xRec."No. Series", "Posting Date", "No.", "No. Series");
        END;

        IF "Document Type" = "Document Type"::"Credit Note" THEN BEGIN //Debit
            TestNoSeries;
            NoSeriesMgt.InitSeries(InsSetup."Credit Note", xRec."No. Series", "Posting Date", "No.", "No. Series");
        END;

        /*IF "Document Type"="Document Type"::Policy THEN
        BEGIN //Debit
        "No.":=InsMngt.GeneratePolicyNos(Rec);
        END;*/

        IF GetFilterCustNo <> '' THEN
            VALIDATE("Insured No.", GetFilterCustNo);

    end;

    var
        saleslinerec: Record "Insure Lines";
        InsSetup: Record "Insurance setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Cust: Record Customer;
        PolicyRecs: Record "Policy Type";
        OptionsSelected: Record "Insure Header Loading_Discount";
        InsuranceType: Record "Loading and Discounts Setup";
        LastNo: Integer;
        InsurerPolicyDetails: Record "Insurer Policy Details";
        PolicyDetails: Record "Policy Details";
        DimMgt: Codeunit 408;
        vendor: Record Vendor;
        InsMngt: Codeunit "Insurance Management";
        shortCover: Record "Short Term Cover";
        InsureLines: Record "Insure Lines";

    local procedure TestNoSeries(): Boolean;
    begin
        InsSetup.GET;

        CASE "Document Type" OF
            "Document Type"::Quote:
                BEGIN
                    InsSetup.TESTFIELD(InsSetup."New Quotation Nos");
                    InsSetup.TESTFIELD(InsSetup."Renewal Quote Nos");
                    InsSetup.TESTFIELD(InsSetup."Modification Quote Nos");
                END;
            "Document Type"::"Debit Note":
                BEGIN
                    //SalesSetup.TESTFIELD("Invoice Nos.");
                    //SalesSetup.TESTFIELD("Posted Invoice Nos.");
                END;

            // SalesSetup.TESTFIELD("Return Order Nos.");
            "Document Type"::"Credit Note":
                BEGIN
                    // SalesSetup.TESTFIELD("Credit Memo Nos.");
                    // SalesSetup.TESTFIELD("Posted Credit Memo Nos.");
                END;
        // "Document Type"::policy:
        // InsSetup.TESTFIELD(InsSetup."Policy Nos");
        END;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        OldDimSetID: Integer;
    begin
        //OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "No." <> '' THEN
            MODIFY;

        /*IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          MODIFY;
          IF SalesLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;*/

    end;

    procedure InsureLinesExist(): Boolean;
    begin
        InsureLines.RESET;
        InsureLines.SETRANGE("Document Type", "Document Type");
        InsureLines.SETRANGE("Document No.", "No.");
        EXIT(InsureLines.FINDFIRST);
    end;

    local procedure GetFilterCustNo(): Code[20];
    begin
        IF GETFILTER("Insured No.") <> '' THEN
            IF GETRANGEMIN("Insured No.") = GETRANGEMAX("Insured No.") THEN
                EXIT(GETRANGEMAX("Insured No."));
    end;

    local procedure GetFilterContNo(): Code[20];
    begin
        /*IF GETFILTER("Sell-to Contact No.") <> '' THEN
          IF GETRANGEMIN("Sell-to Contact No.") = GETRANGEMAX("Sell-to Contact No.") THEN
            EXIT(GETRANGEMAX("Sell-to Contact No."));*/

    end;

    procedure CreateTodo();
    var
        TempTodo: Record "To-do" temporary;
    begin
        /*TESTFIELD("Sell-to Contact No.");
        TempTodo.CreateToDoFromSalesHeader(Rec);*/

    end;
}

