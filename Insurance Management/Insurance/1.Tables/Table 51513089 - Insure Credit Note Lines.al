table 51513089 "Insure Credit Note Lines"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513137;
    LookupPageID = 51513137;

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement;
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Risk ID"; Integer)
        {
            TableRelation = "Risk Database";

            trigger OnValidate();
            begin
                IF RiskData.GET("Risk ID") THEN BEGIN
                    Make := RiskData.Make;
                    Model := RiskData.Model;
                    "Engine No." := RiskData."Engine No.";
                    "Chassis No." := RiskData."Chassis No.";
                    "Year of Manufacture" := RiskData."Year of Manufacture";
                    "Vehicle Tonnage" := RiskData.Tonnage;
                    "Vehicle License Class" := RiskData."License Class";
                    //"SACCO ID":=RiskData.Capacity;
                    "Route ID" := RiskData.Route;
                END;
            end;
        }
        field(4; "Family Name"; Text[30])
        {

            trigger OnValidate();
            begin
                //VALIDATE(Quantity);
            end;
        }
        field(5; "First Name(s)"; Text[15])
        {
        }
        field(6; Title; Option)
        {
            OptionMembers = Prof,Dr,Mr,Mrs,Ms;
        }
        field(7; Sex; Option)
        {
            OptionMembers = Male,Female;
        }
        field(8; "Height Unit"; Option)
        {
            OptionMembers = m,ft,inches,cm;
        }
        field(9; Height; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Height Unit" = "Height Unit"::ft THEN
                    "Height(m)" := Height * 0.3048;
                IF "Height Unit" = "Height Unit"::inches THEN
                    "Height(m)" := Height * 0.0254;
                IF "Height Unit" = "Height Unit"::cm THEN
                    "Height(m)" := Height * 0.01;

                IF "Height Unit" = "Height Unit"::m THEN
                    "Height(m)" := Height;
            end;
        }
        field(10; "Weight Unit"; Option)
        {
            OptionMembers = Kg,Lb;
        }
        field(11; Weight; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Weight Unit" = "Weight Unit"::Lb THEN
                    "Weight(Kg)" := Weight * 0.45;
                IF "Weight Unit" = "Weight Unit"::Kg THEN
                    "Weight(Kg)" := Weight;

                //BMI := Insmanagement.CalculateBMIenglish(Weight,Height);
                //IF "Weight Unit"="Weight Unit"::Kg THEN
                // BMI:=Insmanagement.CalculateBMImetric("Weight(Kg)","Height(m)");
            end;
        }
        field(12; "Date of Birth"; Date)
        {

            trigger OnValidate();
            begin
                IF InsQuote.GET("Document Type", "Document No.") THEN BEGIN
                    // Age:=Insmanagement.AgeCalculator("Date of Birth",InsQuote."Order Date");
                    //VALIDATE(Age);
                END;
            end;
        }
        field(13; "Relationship to Applicant"; Option)
        {
            OptionMembers = " ",Employee,Spouse,Son,Daughter,Relative,Applicant;

            trigger OnValidate();
            begin
                IF InsQuote.GET("Document Type", "Document No.") THEN BEGIN

                    //allow choosing of Employee at Group level only
                    IF InsQuote."Cover Type" <> InsQuote."Cover Type"::Group THEN BEGIN
                        IF "Relationship to Applicant" = "Relationship to Applicant"::Employee THEN
                            ERROR('This Relationship type is only valid for Group Quotes');
                        //Update Relationship of Wife,Husband and child through member code
                    END;

                    IF InsQuote."Cover Type" = InsQuote."Cover Type"::Group THEN BEGIN
                        IF "Relationship to Applicant" <> "Relationship to Applicant"::Employee THEN BEGIN
                            InsQuoteLines.RESET;
                            InsQuoteLines.SETRANGE(InsQuoteLines."Document Type", "Document Type");
                            InsQuoteLines.SETRANGE(InsQuoteLines."Document No.", "Document No.");
                            InsQuoteLines.SETRANGE(InsQuoteLines."Relationship to Applicant", InsQuoteLines."Relationship to Applicant"::Employee);
                            InsQuoteLines.SETFILTER(InsQuoteLines."Risk ID", '<=%1', "Risk ID");

                            IF InsQuoteLines.FIND('+') THEN BEGIN
                                //"Member Code":=InsQuoteLines."Risk ID";
                                "Family Name" := InsQuoteLines."Family Name";
                            END
                            ELSE
                                ERROR('You must define an Employee before specifying employee dependants');

                        END;
                    END;

                    IF InsQuote."Cover Type" = InsQuote."Cover Type"::Individual THEN
                        "Family Name" := InsQuote."Family Name";

                    //Update Family name using member name or applicant family name depending on individual/group

                END
                ELSE
                    ERROR('Header not defined');

                //Pre-define male/female

                IF "Relationship to Applicant" = "Relationship to Applicant"::Daughter THEN
                    Sex := Sex::Female;
                IF "Relationship to Applicant" = "Relationship to Applicant"::Son THEN
                    Sex := Sex::Male;
            end;
        }
        field(14; Occupation; Text[30])
        {
        }
        field(15; Nationality; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(16; "Gross Premium"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate();
            begin
                "Net Premium" := "Gross Premium";
                Amount := "Net Premium";
                VALIDATE("Net Premium");
            end;
        }
        field(17; Age; Integer)
        {
        }
        field(18; BMI; Decimal)
        {
        }
        field(19; "Cover Type"; Option)
        {
            OptionMembers = Member,Dependant;
        }
        field(20; Colour; Code[10])
        {
            TableRelation = "Vehicle Colour";
        }
        field(21; "Area of Cover"; Code[10])
        {
        }
        field(22; "Policy Type"; Code[10])
        {
            TableRelation = "Policy Type";

            trigger OnValidate();
            begin
                IF PolicyType.GET("Policy Type") THEN BEGIN
                    "Commision %" := PolicyType."Commision % age(SIIBL)";
                    VALIDATE("Commision %");
                END;
            end;
        }
        field(23; "Insurance Type"; Code[10])
        {
        }
        field(24; "Premium Amount"; Decimal)
        {
        }
        field(25; "Height(m)"; Decimal)
        {
        }
        field(26; "Weight(Kg)"; Decimal)
        {
        }
        field(27; "Policy No"; Text[30])
        {
        }
        field(28; "Premium Payment"; Code[10])
        {
        }
        field(29; Optional; Boolean)
        {
        }
        field(30; "Check Mark"; Boolean)
        {

            trigger OnValidate();
            begin
                /*IF "Check Mark"=TRUE THEN
                BEGIN
                TotalPremium:=0;
                 IF insurancetyperec.GET("Insurance Type","Policy Type",Class) THEN
                 IF InsQuote.GET("Document Type","Document No.") THEN
                 BEGIN
                 InsQuote.CALCFIELDS("Total Premium Amount");
                  TotalPremium:=InsQuote."Total Premium Amount"+InsQuote."Premium Amount";
                
                  IF insurancetyperec."Calculation Method"=insurancetyperec."Calculation Method"::"Flat Amount" THEN
                  BEGIN
                  IF insurancetyperec."Discount %"<>0 THEN
                  BEGIN
                  "Unit Price":=-(insurancetyperec."Discount %"/100)*TotalPremium;
                  "Reduction %":=insurancetyperec."Discount %";
                
                END;
                   IF insurancetyperec."Loading %"<>0 THEN BEGIN
                  "Unit Price":=(insurancetyperec."Loading %"/100)*TotalPremium;
                  "Loading %":=insurancetyperec."Loading %";
                  END;
                  END;
                
                  IF insurancetyperec."Loading Amount"<>0 THEN
                  "Unit Price":=insurancetyperec."Loading Amount";
                
                
                
                
                    "Line Amount":=Quantity*"Unit Price";
                  IF insurancetyperec.Tax THEN
                  Tax:=TRUE;
                
                
                 IF NOT insurancetyperec.Tax THEN
                 "Gross Premium":="Line Amount";
                   END;
                
                END;*/

            end;
        }
        field(31; Class; Code[10])
        {
            TableRelation = "Insurance Class";
        }
        field(32; "Loading %"; Decimal)
        {
        }
        field(33; "Reduction %"; Decimal)
        {

            trigger OnValidate();
            begin
                /* VALIDATE("Rate %age");
                 "reduction amt":=ROUND("Gross Premium"*("Reduction %"/100),1);
                 "Net Premium":=ROUND("Gross Premium"*((100-"Reduction %")/100),1);
                 "Unit Price":=ROUND("Gross Premium"*((100-"Reduction %")/100),1);
                  VALIDATE("Unit Price");*/

            end;
        }
        field(34; "Loading amt"; Decimal)
        {
        }
        field(35; "reduction amt"; Decimal)
        {
        }
        field(36; Tax; Boolean)
        {
        }
        field(37; "Endorsement Date"; Date)
        {

            trigger OnValidate();
            begin
                /*IF InsHeader.GET("Document Type","Document No.") THEN
                 BEGIN
                 IF "Document Type"<>"Document Type"::Policy THEN
                 BEGIN
                 IF InsHeader."Document Date"<>InsHeader."From Date" THEN
                 "Mid-Term Adjustment Factor":=Insmanagement.CalculateMidTermFactor(InsHeader."Policy No","Endorsement Date");
                 "Net Premium":="Gross Premium"*"Mid-Term Adjustment Factor";
                 "Gross Premium":="Gross Premium"*"Mid-Term Adjustment Factor";
                 //"Unit Price":= "Net Premium";

               //  VALIDATE("Unit Price");
                 END;
                 END;

                   //GetSalesHeader;
                   IF PolicyType.GET(InsHeader."Policy Type") THEN
                   BEGIN
                   IF "Rate Type"="Rate Type"::" " THEN
                   "Rate Type":=PolicyType.Rating;
                    CALCFIELDS("Extra Premium");
                   IF  "Rate Type"= "Rate Type"::"Per Cent" THEN
                   "Gross Premium":= ("Rate %age"/100*"Sum Insured")+"Extra Premium"+("No. of Employees"*"Per Capita");

                   IF "Rate Type"= "Rate Type"::"Per Mille" THEN
                   "Gross Premium":= ("Rate %age"/1000*"Sum Insured")+"Extra Premium"+("No. of Employees"*"Per Capita");



                   END;

                 // Type:=Type::Vendor;


                 IF InsHeader.GET("Document Type","Document No.") THEN
                 BEGIN

                 IF InsHeader."Document Date"<>InsHeader."From Date" THEN
                 "Mid-Term Adjustment Factor":=Insmanagement.CalculateMidTermFactor(InsHeader."EHS Policy No","Endorsement Date");
                 IF "Mid-Term Adjustment Factor"<>0 THEN
                 "Gross Premium":="Gross Premium"*"Mid-Term Adjustment Factor";
                 END;


                  //"Unit Price":="Gross Premium";
                  //VALIDATE("Unit Price");
                   VALIDATE("Gross Premium");*/

            end;
        }
        field(38; "Moratorium Date"; Date)
        {
        }
        field(39; "Deletion Date"; Date)
        {

            trigger OnValidate();
            begin
                /* IF SalesHeader.GET("Document Type","Document No.") THEN
                 BEGIN

                 IF "Deletion Date"<>SalesHeader."From Date" THEN
                 "Mid-Term Adjustment Factor":=Insmanagement.CalculateMidTermFactorMIC(SalesHeader."To Date","Deletion Date");

                 END; */

            end;
        }
        field(40; "Country of Residence"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(41; "Sum Insured"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate();
            begin
                /*GetSalesHeader;
                Type:=Type::Vendor;
                IF insurerPolicy.GET(SalesHeader."Policy Type",SalesHeader."Agent/Broker") THEN
                BEGIN
                "Rate %age":=insurerPolicy."Premium % age Rate";
                 IF insurerPolicy."Account Type"=insurerPolicy."Account Type"::Vendor THEN
                 Type:=Type::Vendor;
                 "No.":=SalesHeader."Agent/Broker";
                 "Gen. Bus. Posting Group":=SalesHeader."Gen. Bus. Posting Group";
                 "VAT Bus. Posting Group":=SalesHeader."VAT Bus. Posting Group";

                END;
                IF "Gross Premium"=0 THEN
                "Gross Premium":="Sum Insured"*("Rate %age"/100);

                VALIDATE( "Gross Premium");


                Quantity:=1;
                 "Qty. to Invoice":=1;
                VALIDATE(Quantity);
               IF "Document Type"="Document Type"::Invoice THEN
               BEGIN
               "Qty. to Ship":=1;
               END;


               IF "Document Type"="Document Type"::"Credit Memo" THEN
               BEGIN
               "Return Qty. to Receive":=1;
               END;



                "Unit Price":="Gross Premium";
                 IF "Unit Price"<>0 THEN
                   VALIDATE("Unit Price");*/
                "Rate Type" := "Rate Type"::"Per Cent";

                CALCFIELDS("Extra Premium");
                IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                    "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                    "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                Amount := "Gross Premium" + "TPO Premium" + "Extra Premium";
                MESSAGE('%1', Amount);

            end;
        }
        field(42; "Rate %age"; Decimal)
        {
            DecimalPlaces = 0 : 8;

            trigger OnValidate();
            begin
                IF InsHeader.GET(InsHeader."Document Type", InsHeader."No.") THEN BEGIN
                    IF PolicyType.GET(InsHeader."Policy Type") THEN BEGIN

                        IF "Rate Type" = "Rate Type"::" " THEN
                            "Rate Type" := PolicyType.Rating;

                        "Rate Type" := "Rate Type"::"Per Cent";

                        CALCFIELDS("Extra Premium");
                        IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                            "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                        IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                            "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                        Amount := "Gross Premium" + "TPO Premium" + "Extra Premium";
                        // MESSAGE('%1',Amount);
                    END;


                    // Type:=Type::Vendor;



                    IF "Mid-Term Adjustment Factor" <> 0 THEN
                        "Gross Premium" := "Gross Premium" * "Mid-Term Adjustment Factor";

                    //"Unit Price":="Gross Premium";
                    //VALIDATE("Unit Price");
                    VALIDATE("Gross Premium");

                END;
            end;
        }
        field(43; "Risk Covered"; Text[250])
        {
        }
        field(44; "Net Premium"; Decimal)
        {
        }
        field(45; "Adjustment %"; Decimal)
        {

            trigger OnValidate();
            begin


                /*"Unit Price":="Net Premium";
                VALIDATE("Unit Price");*/

            end;
        }
        field(46; "Mid-Term Adjustment Factor"; Decimal)
        {
        }
        field(47; "Copied from No."; Code[20])
        {
        }
        field(48; Status; Option)
        {
            OptionMembers = Active,Deleted;
        }
        field(49; "Cover Description"; Text[250])
        {
        }
        field(50; "Registration No."; Code[10])
        {

            trigger OnValidate();
            begin
                /*IF "Registration No."<>'' THEN
                BEGIN
                PolicyLines.RESET;
                PolicyLines.SETRANGE(PolicyLines."Document Type",PolicyLines."Document Type"::Policy);
                PolicyLines.SETRANGE(PolicyLines."Registration No.","Registration No.");
                IF PolicyLines.FIND('-') THEN
                BEGIN
                REPEAT
                IF SalesHeader.GET(PolicyLines."Document Type",PolicyLines."Document No.") THEN
                IF SalesHeader."Policy Status"=SalesHeader."Policy Status"::Live THEN
                IF NOT CONFIRM('Vehicle with same registration details %1 already exists in policy No %2 Do you want to continue?',
                FALSE,PolicyLines."Registration No.",SalesHeader."Policy No") THEN
                "Registration No.":='';

                UNTIL PolicyLines.NEXT=0;


                END;
                END; */

            end;
        }
        field(51; Make; Code[10])
        {
            TableRelation = "Car Makers";
        }
        field(52; "Year of Manufacture"; Integer)
        {
        }
        field(53; "Type of Body"; Code[20])
        {
            TableRelation = "Vehicle Body Type";
        }
        field(54; "Cubic Capacity (cc)"; Text[30])
        {
        }
        field(55; "Seating Capacity"; Integer)
        {
            TableRelation = "Vehicle Capacity";

            trigger OnValidate();
            begin
                /*IF "Policy Type"='' THEN
                  ERROR('Select policy type');

                IF "No. Of Instalments"=0 THEN
                  ERROR('Select No. of Instalments');

                PremiumTab.RESET;
                PremiumTab.SETRANGE(PremiumTab."Policy Type","Policy Type");
                IF PremiumTab.FINDFIRST THEN



                 PremiumTableLines.RESET;
                 PremiumTableLines.SETRANGE(PremiumTableLines."Premium Table",PremiumTab.Code);
                 //PremiumTableLines.SETRANGE(PremiumTableLines."Policy Type","Policy Type");
                 PremiumTableLines.SETRANGE(PremiumTableLines."Seating Capacity","Seating Capacity");
                 PremiumTableLines.SETRANGE(PremiumTableLines.Instalments,"No. Of Instalments");
                 PremiumTableLines.SETRANGE(PremiumTableLines."Vehicle Usage","Vehicle Usage");
                 PremiumTableLines.SETRANGE(PremiumTableLines."Vehicle Type","Vehicle License Class");

                 IF PremiumTableLines.FINDFIRST THEN
                 BEGIN

                 "TPO Premium":=PremiumTableLines."Premium Amount";
                 PLL:=PremiumTableLines."PPL Cost Per PAX"*"Carrying Capacity";
                 CALCFIELDS("Extra Premium");
                 Amount:="Gross Premium"+"TPO Premium"+PLL+"Extra Premium";
                 END
                 ELSE
                 MESSAGE('Please setup the Premium table');*/



            end;
        }
        field(56; "Carrying Capacity"; Integer)
        {
            TableRelation = "Vehicle Capacity";

            trigger OnValidate();
            begin

                /*
                 IF InsQuote.GET("Document Type","Document No.") THEN
                 BEGIN

                 IF PolicyType.GET(InsQuote."Policy Type") THEN
                 IF PolicyType."Premium Table"<>'' THEN
                 BEGIN
                  PremiumTableLines.RESET;
                  PremiumTableLines.SETRANGE(PremiumTableLines."Premium Table",PolicyType."Premium Table");
                  PremiumTableLines.SETRANGE(PremiumTableLines."Seating Capacity","Carrying Capacity");
                  PremiumTableLines.SETRANGE(PremiumTableLines.Instalments,InsQuote."No. Of Instalments");
                  PremiumTableLines.SETRANGE(PremiumTableLines."Vehicle Usage","Vehicle Usage");
                  PremiumTableLines.SETRANGE(PremiumTableLines."Vehicle Type","Vehicle License Class");

                  IF PremiumTableLines.FINDFIRST THEN
                  BEGIN

                  "TPO Premium":=PremiumTableLines."Premium Amount";
                  PLL:=PremiumTableLines."PPL Cost Per PAX"*"Carrying Capacity";
                  CALCFIELDS("Extra Premium");
                  Amount:="Gross Premium"+"TPO Premium"+PLL+"Extra Premium";
                  END
                  ELSE
                  MESSAGE('Please setup the Premium table');

                 END;




                END;*/

            end;
        }
        field(57; "No. of Employees"; Integer)
        {

            trigger OnValidate();
            begin
                IF PolicyType.GET(InsHeader."Policy Type") THEN BEGIN
                    "Rate Type" := PolicyType.Rating;

                    CALCFIELDS("Extra Premium");
                    IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                        "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                    IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                        "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");




                END;
            end;
        }
        field(58; "Description Type"; Option)
        {
            OptionMembers = " ",Cover,Interest,Deductible,Clauses,Limits,Warranty,"Basis of Settlement",Excess,Geographic,"Schedule of Insured",Tax,Exclusions;
        }
        field(59; ft; Option)
        {
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10","11";

            trigger OnValidate();
            begin
                /*CASE ft OF
                ft::"0"":
                Height:="Height (ft)";
                ft::"1"":
                Height:="Height (ft)"+(1/12);
                ft::"2"":
                Height:="Height (ft)"+(2/12);
                ft::"Payment Terms"":
                Height:="Height (ft)"+(3/12);
                ft::Currency":
                Height:="Height (ft)"+(4/12);
                ft::"5"":
                Height:="Height (ft)"+(5/12);
                ft::"6"":
                Height:="Height (ft)"+(6/12);
                ft::"7"":
                Height:="Height (ft)"+(7/12);
                ft::"8"":
                Height:="Height (ft)"+(8/12);
                ft::"Country/Region"":
                Height:="Height (ft)"+(9/12);
                ft::"10"":
                Height:="Height (ft)"+(10/12);
                ft::"11"":
                Height:="Height (ft)"+(11/12);
                END;
                VALIDATE(Height); */

            end;
        }
        field(60; "Height (ft)"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(61; "Country of Residence Desc"; Text[30])
        {
        }
        field(62; "Nationality Description"; Text[30])
        {
        }
        field(63; "Mark for Deletion"; Boolean)
        {
        }
        field(64; "Purchase Date of Current Benef"; Date)
        {
        }
        field(65; "Start Date"; Date)
        {
        }
        field(66; "End Date"; Date)
        {
        }
        field(67; "Estimated Annual Earnings"; Decimal)
        {

            trigger OnValidate();
            begin
                "Sum Insured" := "Estimated Annual Earnings";
                VALIDATE("Sum Insured");
                VALIDATE("Gross Premium");
            end;
        }
        field(68; "Serial No"; Text[30])
        {

            trigger OnValidate();
            begin
                /*IF "Serial No"<>'' THEN
                BEGIN
                PolicyLines.RESET;
                PolicyLines.SETRANGE(PolicyLines."Document Type",PolicyLines."Document Type"::Policy);
                PolicyLines.SETRANGE(PolicyLines."Serial No","Serial No");
                IF PolicyLines.FIND('-') THEN
                BEGIN
                REPEAT
                IF SalesHeader.GET(PolicyLines."Document Type",PolicyLines."Document No.") THEN
                IF SalesHeader."Policy Status"=SalesHeader."Policy Status"::Live THEN
                IF NOT CONFIRM('Item with same Serial No. already exists in policy No %1 Do you want to continue?',
                FALSE,PolicyLines."Document No.") THEN
                "Serial No":='';

                UNTIL PolicyLines.NEXT=0;


                END;
                END;*/

            end;
        }
        field(69; "Limit of Liability"; Decimal)
        {

            trigger OnValidate();
            begin
                "Sum Insured" := "Limit of Liability";
                VALIDATE("Sum Insured");
            end;
        }
        field(70; Position; Text[30])
        {
        }
        field(71; Category; Text[50])
        {
        }
        field(72; "Employee Name"; Text[30])
        {
        }
        field(73; Windscreen; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate();
            begin
                // VALIDATE("Rate %age");
                /* "Gross Premium":= ("Rate %age"/100*"Sum Insured")+(("Windscreen % Rate"/100)*Windscreen)+(
                 ("Radio Cassette % Rate"/100)*"Radio Cassette"); */
                CALCFIELDS("Extra Premium");
                IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                    "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                    "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

            end;
        }
        field(74; "Radio Cassette"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate();
            begin
                // "Gross Premium":= ("Rate %age"/100*"Sum Insured")+(("Windscreen % Rate"/100)*Windscreen)+(
                //  ("Radio Cassette % Rate"/100)*"Radio Cassette");
                //VALIDATE("Rate %age");
                CALCFIELDS("Extra Premium");
                IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                    "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                    "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");
            end;
        }
        field(75; "Windscreen % Rate"; Decimal)
        {
            DecimalPlaces = 0 : 4;

            trigger OnValidate();
            begin
                /* "Gross Premium":= ("Rate %age"/100*"Sum Insured")+(("Windscreen % Rate"/100)*Windscreen)+(
                 ("Radio Cassette % Rate"/100)*"Radio Cassette");*/

                CALCFIELDS("Extra Premium");
                IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                    "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                    "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

            end;
        }
        field(76; "Radio Cassette % Rate"; Decimal)
        {
            DecimalPlaces = 0 : 4;

            trigger OnValidate();
            begin
                /* "Gross Premium":= ("Rate %age"/100*"Sum Insured")+(("Windscreen % Rate"/100)*Windscreen)+(
                 ("Radio Cassette % Rate"/100)*"Radio Cassette");*/

                CALCFIELDS("Extra Premium");
                IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                    "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                    "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

            end;
        }
        field(77; "Engine No."; Code[20])
        {
        }
        field(78; "Chassis No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF "Registration No." = '' THEN
                    "Registration No." := "Chassis No.";
            end;
        }
        field(79; Death; Decimal)
        {
        }
        field(80; "Permanent Disability"; Decimal)
        {
        }
        field(81; "Temporary Disability"; Decimal)
        {
        }
        field(82; "Medical expenses"; Decimal)
        {
        }
        field(83; "Death Rate"; Decimal)
        {
        }
        field(84; "P.D Rate"; Decimal)
        {
        }
        field(85; "T.D Rate"; Decimal)
        {
        }
        field(86; "M.E Rate"; Decimal)
        {
        }
        field(87; Section; Code[20])
        {
        }
        field(88; "Text Type"; Option)
        {
            OptionMembers = Normal,Bold,Underline;
        }
        field(89; "Line Type"; Option)
        {
            OptionMembers = interest,Heading,"Begin-Total","End-Total",Total;
        }
        field(90; Totaling; Integer)
        {
            TableRelation = "Sales Line"."Line No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(91; "Actual Value"; Text[70])
        {
        }
        field(92; Value; Decimal)
        {
        }
        field(93; "Commision %"; Decimal)
        {

            trigger OnValidate();
            begin
                Commission := ("Commision %" / 100) * "Net Premium";
            end;
        }
        field(94; Commission; Decimal)
        {
        }
        field(95; "First Loss Sum Insured"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate();
            begin
                "Gross Premium" := (("TVA Rate" / 1000) * "Total Value at Risk") + (("First Loss Rate" / 1000) * "First Loss Sum Insured");
            end;
        }
        field(96; "Total Value at Risk"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate();
            begin



                /*IF insurerPolicy.GET(InsHeader."Policy Type",InsHeader."Agent/Broker") THEN
                BEGIN
                "Rate %age":=insurerPolicy."Premium % age Rate";

                END;



               IF PolicyType.GET(InsHeader."Policy Type") THEN
               BEGIN
               "First Loss Sum Insured":=(PolicyType."First Loss %"/1000)*"Total Value at Risk";
               END;
               "Gross Premium":= (("TVA Rate"/1000)*"Total Value at Risk")+(("First Loss Rate"/1000)*"First Loss Sum Insured");
                VALIDATE("Gross Premium"); */

            end;
        }
        field(97; "First Loss Rate"; Decimal)
        {

            trigger OnValidate();
            begin
                //Type:=Type::Vendor;
                "Gross Premium" := (("TVA Rate" / 1000) * "Total Value at Risk") + (("First Loss Rate" / 1000) * "First Loss Sum Insured");
            end;
        }
        field(98; "TVA Rate"; Decimal)
        {

            trigger OnValidate();
            begin
                "Gross Premium" := (("TVA Rate" / 1000) * "Total Value at Risk") + (("First Loss Rate" / 1000) * "First Loss Sum Insured");
                //Type:=Type::Vendor;
                VALIDATE("Gross Premium");
            end;
        }
        field(99; "Per Capita"; Decimal)
        {

            trigger OnValidate();
            begin


                IF PolicyType.GET(InsHeader."Policy Type") THEN BEGIN
                    CALCFIELDS("Extra Premium");
                    IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                        "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                    IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                        "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");
                    "Rate Type" := PolicyType.Rating;

                    VALIDATE("Gross Premium");

                END;
            end;
        }
        field(100; "Rate Type"; Option)
        {
            OptionMembers = " ","Per Cent","Per Mille";
        }
        field(101; PLL; Decimal)
        {

            trigger OnValidate();
            begin
                IF InsHeader.GET("Document Type", "Document No.") THEN BEGIN
                    IF PolicyType.GET(InsHeader."Policy Type") THEN BEGIN
                        "Rate Type" := PolicyType.Rating;

                        CALCFIELDS("Extra Premium");
                        IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                            "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                        IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                            "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");


                        VALIDATE("Gross Premium");

                    END;
                END;
            end;
        }
        field(102; "Valuation Currency"; Code[10])
        {
            TableRelation = Currency;
        }
        field(103; Model; Code[20])
        {
            TableRelation = "Car Models".Model WHERE("Car Maker" = FIELD(Make));
        }
        field(104; "Vehicle Usage"; Code[10])
        {
            TableRelation = "Vehicle Usage";
        }
        field(105; "Line No."; Integer)
        {
        }
        field(106; Amount; Decimal)
        {
        }
        field(107; "Extra Premium"; Decimal)
        {
            CalcFormula = Sum("Additional Benefits".Premium WHERE("Document Type" = FIELD("Document Type"),
                                                                   "Document No." = FIELD("Document No."),
                                                                   "Risk ID" = FIELD("Risk ID")));
            FieldClass = FlowField;
        }
        field(108; "Vehicle Tonnage"; Code[10])
        {
            TableRelation = Tonnage;
        }
        field(109; "Vehicle License Class"; Code[10])
        {
            TableRelation = "Motor Classification";
        }
        field(110; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(111; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                      Blocked = CONST(False))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate();
            begin
                IF "Account No." <> '' THEN BEGIN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                //MESSAGE('Risk ID=%1',"Risk ID");
                                GLAcc.GET("Account No.");
                                CheckGLAcc;
                                Name := GLAcc.Name;

                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                Cust.CheckBlockedCustOnJnls(Cust, "Document Type", FALSE);
                                Name := Cust.Name;
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                Vend.CheckBlockedVendOnJnls(Vend, "Document Type", FALSE);
                                Name := Vend.Name;
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                BankAcc.TESTFIELD(Blocked, FALSE);
                                Name := BankAcc.Name;
                            END;
                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No.");
                                FA.TESTFIELD(Blocked, FALSE);
                                FA.TESTFIELD(Inactive, FALSE);
                                FA.TESTFIELD("Budgeted Asset", FALSE);
                                Name := FA.Description;
                            END;
                        "Account Type"::"IC Partner":
                            BEGIN
                                ICPartner.GET("Account No.");
                                ICPartner.CheckICPartner;
                                Name := ICPartner.Name;
                            END;
                    END;
                END;
            end;
        }
        field(112; Name; Text[50])
        {
        }
        field(113; Description; Text[250])
        {
        }
        field(114; "TPO Premium"; Decimal)
        {
        }
        field(115; "SACCO ID"; Code[20])
        {
            TableRelation = Customer WHERE("Customer Type" = CONST(SACCO));
        }
        field(116; "Route ID"; Code[20])
        {
            TableRelation = "SACCO Routes";
        }
        field(117; "Dimension Set ID"; Integer)
        {
        }
        field(118; Quantity; Decimal)
        {
        }
        field(119; "Select Risk ID"; Integer)
        {
            TableRelation = "Insure Lines"."Line No." WHERE("Document Type" = CONST(Policy),
                                                             "Document No." = FIELD("Policy No"));
        }
        field(120; "Endorsement Type"; Code[20])
        {
            TableRelation = "Endorsement Types";

            trigger OnValidate();
            begin
                /*IF EndorsmentType.GET("Endorsement Type") THEN
                  "Action Type":=EndorsmentType."Action Type";*/

            end;
        }
        field(121; "Action Type"; Option)
        {
            OptionCaption = '" ,Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,Yellow Card,Additional Riders"';
            OptionMembers = " ",Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,"Yellow Card","Additional Riders";
        }
        field(122; Selected; Boolean)
        {
        }
        field(123; "No. Of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments";
        }
        field(124; "Substituted Vehicle Reg. No"; Code[20])
        {
        }
        field(125; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(126; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(127; "Insured No."; Code[20])
        {
        }
        field(128; "Certificate No."; Code[20])
        {
        }
        field(129; "Certificate Type"; Code[10])
        {
            TableRelation = Item;
        }
        field(130; "Date Printed"; Date)
        {
        }
        field(131; "Print Time"; Time)
        {
        }
        field(132; "Printed By"; Code[80])
        {
        }
        field(133; Printed; Boolean)
        {
        }
        field(134; "Item Entry No."; Integer)
        {
            TableRelation = "Item Ledger Entry"."Entry No." WHERE("Item No." = FIELD("Certificate Type"));

            trigger OnValidate();
            begin
                IF ItemEntryRelation.GET("Item Entry No.") THEN BEGIN
                    "Certificate No." := ItemEntryRelation."Serial No.";
                    //  MESSAGE('%1',ItemEntryRelation."Serial No.");
                END;
            end;
        }
        field(135; "date and time"; DateTime)
        {
        }
        field(136; "Insured Name"; Text[80])
        {
        }
        field(137; "cancellation Reason"; Code[20])
        {
            TableRelation = "Cancellation Reasons";

            trigger OnValidate();
            begin
                IF CancelReasonRec.GET("cancellation Reason") THEN
                    "cancellation Reason Desc" := CancelReasonRec.Description;
            end;
        }
        field(138; "cancellation Reason Desc"; Text[30])
        {
        }
        field(139; Medical; Decimal)
        {
        }
        field(140; "Cancellation Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        ERROR('Cannot delete this record');
    end;

    trigger OnModify();
    begin
        ERROR('Cannot modify this record');
    end;

    var
        InsQuote: Record "Insure Header";
        InsQuoteLines: Record "Insure Lines";
        RiskData: Record "Risk Database";
        InsHeader: Record "Insure Header";
        PolicyType: Record "Policy Type";
        Insmanagement: Codeunit "Insurance management";
        PremiumTableLines: Record "Premium table Lines";
        PremiumTab: Record "Premium Table";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        ItemEntryRelation: Record "Item Entry Relation";
        CancelReasonRec: Record "Cancellation Reasons";

    local procedure GetInsureHeader();
    begin
    end;

    local procedure CheckGLAcc();
    begin
    end;
}

