table 51513017 "Insure Lines"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = ' ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement,Insurer Quotes';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement,"Insurer Quotes";
        }
        field(2; "Document No."; Code[30])
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
                    Age := Insmanagement.AgeCalculator("Date of Birth", InsQuote."Posting Date");
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
                        /*IF "Relationship to Applicant"="Relationship to Applicant"::Employee THEN
                        ERROR('This Relationship type is only valid for Group Quotes');*/
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
                        //"Family Name" := InsQuote."Family Name";
                        ;

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

            trigger OnValidate();
            begin
                IF InsHeader.GET("Document Type", "Document No.") THEN BEGIN
                    ProductBen_Riders.RESET;
                    ProductBen_Riders.SETRANGE(ProductBen_Riders."Product Code", InsHeader."Policy Type");
                    ProductBen_Riders.SETRANGE(ProductBen_Riders."Benefit Type", ProductBen_Riders."Benefit Type"::Main);
                    IF ProductBen_Riders.FINDLAST THEN
                        "Gross Premium" := ProductBen_Riders."Premium Rate" * "Sum Insured";
                END;
            end;
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
        field(21; "Area of Cover"; Code[20])
        {
        }
        field(22; "Policy Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Policy Type";

            trigger OnValidate();
            begin
                IF PolicyType.GET("Policy Type") THEN BEGIN
                    "Commision %" := PolicyType."Commision % age(SIIBL)";
                    VALIDATE("Commision %");
                END;
            end;
        }
        field(23; "Insurance Type"; Code[20])
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
        field(28; "Premium Payment"; Code[20])
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
        field(31; Class; Code[20])
        {
            TableRelation = "Insurance Class";
        }
        field(32; "Loading %"; Decimal)
        {
        }
        field(33; "Rate Discount %"; Decimal)
        {

            trigger OnValidate();
            begin
                /* VALIDATE("Rate %age");
                 "reduction amt":=ROUND("Gross Premium"*("Reduction %"/100),1);
                 "Net Premium":=ROUND("Gross Premium"*((100-"Reduction %")/100),1);
                 "Unit Price":=ROUND("Gross Premium"*((100-"Reduction %")/100),1);
                  VALIDATE("Unit Price");*/

                UserGroupMember.RESET;
                UserGroupMember.SETRANGE(UserGroupMember."User Security ID", USERSECURITYID);
                UserGroupMember.SETRANGE(UserGroupMember."Company Name", COMPANYNAME);
                IF UserGroupMember.FINDFIRST THEN BEGIN
                    // MESSAGE('The group=%1',UserGroupMember."User Group Code");

                    UserGroupApprovalLimits.RESET;
                    UserGroupApprovalLimits.SETRANGE("User Group Code", UserGroupMember."User Group Code");
                    IF UserGroupApprovalLimits.FINDFIRST THEN BEGIN
                        IF "Rate Discount %" > UserGroupApprovalLimits."Rate Discount % Limit" THEN
                            ERROR('You cannot give a discount exceeding %1 contact your Manager', UserGroupApprovalLimits."Rate Discount % Limit");
                    END;

                END;

                "Gross Premium" := "Gross Premium" * ((100 - "Rate Discount %") / 100);

            end;
        }
        field(34; "Loading amt"; Decimal)
        {
        }
        field(35; "TPO Discount %"; Decimal)
        {

            trigger OnValidate();
            begin
                UserGroupMember.RESET;
                UserGroupMember.SETRANGE(UserGroupMember."User Security ID", USERSECURITYID);
                UserGroupMember.SETRANGE(UserGroupMember."Company Name", COMPANYNAME);
                IF UserGroupMember.FINDFIRST THEN BEGIN
                    // MESSAGE('The group=%1',UserGroupMember."User Group Code");

                    UserGroupApprovalLimits.RESET;
                    UserGroupApprovalLimits.SETRANGE("User Group Code", UserGroupMember."User Group Code");
                    IF UserGroupApprovalLimits.FINDFIRST THEN BEGIN
                        IF "TPO Discount %" > UserGroupApprovalLimits."TPO Premium Discount % Limit" THEN
                            ERROR('You cannot give a TPO discount exceeding %1 contact your Manager', UserGroupApprovalLimits."TPO Premium Discount % Limit");
                    END;

                END;

                "TPO Premium" := "TPO Premium" * ((100 - "TPO Discount %") / 100);
            end;
        }
        field(36; Tax; Boolean)
        {
        }
        field(37; "Endorsement Date"; Date)
        {

            trigger OnValidate();
            begin
                IF InsHeader.GET("Document Type", "Document No.") THEN BEGIN
                    IF "Document Type" <> "Document Type"::Policy THEN BEGIN
                        IF InsHeader."Document Date" <> InsHeader."Cover Start Date" THEN
                            "Mid-Term Adjustment Factor" := Insmanagement.CalculateMidTermFactor(InsHeader);
                        "Net Premium" := "Gross Premium" * "Mid-Term Adjustment Factor";
                        "Gross Premium" := "Gross Premium" * "Mid-Term Adjustment Factor";
                        //"Unit Price":= "Net Premium";

                        //  VALIDATE("Unit Price");
                    END;
                END;

                //GetSalesHeader;
                IF PolicyType.GET(InsHeader."Policy Type") THEN BEGIN
                    IF "Rate Type" = "Rate Type"::" " THEN
                        "Rate Type" := PolicyType.Rating;
                    CALCFIELDS("Extra Premium");
                    IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                        "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                    IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                        "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");



                END;

                // Type:=Type::Vendor;


                IF InsHeader.GET("Document Type", "Document No.") THEN BEGIN

                    IF InsHeader."Document Date" <> InsHeader."From Date" THEN
                        "Mid-Term Adjustment Factor" := Insmanagement.CalculateMidTermFactor(InsHeader);
                    IF "Mid-Term Adjustment Factor" <> 0 THEN
                        "Gross Premium" := "Gross Premium" * "Mid-Term Adjustment Factor";
                END;


                //"Unit Price":="Gross Premium";
                //VALIDATE("Unit Price");
                VALIDATE("Gross Premium");
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
        field(40; "Country of Residence"; Code[20])
        {
            TableRelation = "Country/Region";
        }
        field(41; "Sum Insured"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate();
            begin

                "Rate Type" := "Rate Type"::"Per Cent";

                CALCFIELDS("Extra Premium");
                IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                    "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                    "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                Amount := "Gross Premium" + "TPO Premium" + "Extra Premium";
                // MESSAGE('%1',Amount);
                IF InsHeader.GET("Document Type", InsHeader."No.") THEN BEGIN
                    IF PolicyType.GET(InsHeader."Policy Type") THEN BEGIN
                        IF "Sum Insured" > PolicyType."Free Cover Limit" THEN
                            "Check Mark" := TRUE;
                    END;
                END;
            end;
        }
        field(42; "Rate %age"; Decimal)
        {
            DecimalPlaces = 0 : 8;

            trigger OnValidate();
            begin
                IF InsHeader.GET("Document Type", InsHeader."No.") THEN BEGIN
                    IF PolicyType.GET(InsHeader."Policy Type") THEN BEGIN

                        IF "Rate Type" = "Rate Type"::" " THEN
                            "Rate Type" := PolicyType.Rating;

                        "Rate Type" := "Rate Type"::"Per Cent";

                        CALCFIELDS("Extra Premium");
                        IF "Rate Type" = "Rate Type"::"Per Cent" THEN
                            "Gross Premium" := ("Rate %age" / 100 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                        IF "Rate Type" = "Rate Type"::"Per Mille" THEN
                            "Gross Premium" := ("Rate %age" / 1000 * "Sum Insured") + "Extra Premium" + ("No. of Employees" * "Per Capita");

                        Amount := "Gross Premium" + "TPO Premium" + "Extra Premium" + PLL + Medical;
                        //MESSAGE('Premium=%1',Amount);
                    END;


                    // Type:=Type::Vendor;



                    IF "Mid-Term Adjustment Factor" <> 0 THEN
                        "Gross Premium" := "Gross Premium" * "Mid-Term Adjustment Factor";


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
            OptionMembers = " ",Live,Expired,Lapsed,Cancelled,Renewed,Suspended;
        }
        field(49; "Cover Description"; Text[250])
        {
        }
        field(50; "Registration No."; Code[10])
        {

            trigger OnValidate();
            begin
                IF "Line No." = 0 THEN BEGIN
                    InsQuoteLines.RESET;
                    InsQuoteLines.SETRANGE(InsQuoteLines."Document Type", "Document Type");
                    InsQuoteLines.SETRANGE(InsQuoteLines."Document No.", "Document No.");
                    IF InsQuoteLines.FINDLAST THEN
                        "Line No." := InsQuoteLines."Line No." + 10000;
                    //MESSAGE('Line No %1',InsQuoteLines."Line No."+10000);
                END;

                IF InsHeader.GET("Document Type", "Document No.") THEN BEGIN

                    "Policy Type" := InsHeader."Policy Type";
                    "No. Of Instalments" := InsHeader."No. Of Instalments";
                    IF InsHeader."Policy No" <> '' THEN
                        "Policy No" := InsHeader."Policy No";
                    "Insured No." := InsHeader."Insured No.";
                    "Insured Name" := InsHeader."Insured Name";
                    "Endorsement Type" := InsHeader."Endorsement Type";
                    "Action Type" := InsHeader."Action Type";
                    PremiumTab.RESET;
                    PremiumTab.SETRANGE(PremiumTab."Policy Type", InsHeader."Policy Type");
                    IF PremiumTab.FINDFIRST THEN BEGIN
                        "Vehicle License Class" := PremiumTab."Vehicle Class";
                        "Vehicle Usage" := PremiumTab."Vehicle Usage";

                    END;
                END;







                IF "Registration No." <> '' THEN BEGIN
                    PolicyLines.RESET;
                    PolicyLines.SETRANGE(PolicyLines."Document Type", PolicyLines."Document Type"::Policy);
                    PolicyLines.SETRANGE(PolicyLines."Registration No.", "Registration No.");
                    IF PolicyLines.FIND('-') THEN BEGIN
                        REPEAT
                            IF SalesHeader.GET(PolicyLines."Document Type", PolicyLines."Document No.") THEN
                                IF SalesHeader."Policy Status" = SalesHeader."Policy Status"::Live THEN
                                    IF NOT CONFIRM('Vehicle with same registration details %1 already exists in policy No %2 Do you want to continue?',
                                    FALSE, PolicyLines."Registration No.", SalesHeader."Policy No") THEN
                                        "Registration No." := '';

                        UNTIL PolicyLines.NEXT = 0;


                    END;
                END;
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
                IF "Line No." = 0 THEN BEGIN
                    InsQuoteLines.RESET;
                    InsQuoteLines.SETRANGE(InsQuoteLines."Document Type", "Document Type");
                    InsQuoteLines.SETRANGE(InsQuoteLines."Document No.", "Document No.");
                    IF InsQuoteLines.FINDLAST THEN
                        "Line No." := InsQuoteLines."Line No." + 10000;
                    //MESSAGE('Line No %1',InsQuoteLines."Line No."+10000);
                END;

                SalesHeader.Reset();
                SalesHeader.SetRange("No.", "Document No.");
                if SalesHeader.FindFirst() then begin
                    case SalesHeader."Business Type" of
                        "Business Type"::Brokerage:
                            begin
                                IF "Policy Type" = '' THEN
                                    //ERROR('Select policy type');
                                    "Policy Type" := SalesHeader."Policy Type";


                                IF "No. Of Instalments" = 0 THEN
                                    ERROR('Select No. of Instalments');
                                UnderwriterPolicyType.Reset();
                                UnderwriterPolicyType.SetRange(Code, SalesHeader."Policy Type");
                                UnderwriterPolicyType.SetRange("Underwriter Code", SalesHeader.Underwriter);
                                if UnderwriterPolicyType.FindFirst() then begin
                                    //IF UnderwriterPolicyType.GET("Policy Type") THEN
                                    IF UnderwriterPolicyType."Premium Table" <> '' THEN BEGIN //Premium table is linked

                                        PremiumTab.RESET;
                                        PremiumTab.SETRANGE(PremiumTab."Policy Type", "Policy Type");
                                        IF PremiumTab.FINDFIRST THEN
                                            PremiumTableLines.RESET;
                                        PremiumTableLines.SETRANGE(PremiumTableLines."Premium Table", PremiumTab.Code);
                                        PremiumTableLines.SETRANGE(PremiumTableLines."Policy Type", "Policy Type");
                                        PremiumTableLines.SETRANGE(PremiumTableLines."Seating Capacity", "Seating Capacity");
                                        //IF UnderwriterPolicyType.GET("Policy Type") THEN
                                        IF UnderwriterPolicyType.Comprehensive THEN
                                            PremiumTableLines.SETRANGE(PremiumTableLines.Instalments, 1)
                                        ELSE
                                            PremiumTableLines.SETRANGE(PremiumTableLines.Instalments, "No. Of Instalments");
                                        PremiumTableLines.SETRANGE(PremiumTableLines."Vehicle Usage", "Vehicle Usage");
                                        PremiumTableLines.SETRANGE(PremiumTableLines."Vehicle Type", "Vehicle License Class");

                                        //MESSAGE('Policy Type =%1 Seating Capacity=%2 No. of instalments=%3 Veh usage=%4 vehicle lic class %5',
                                        //"Policy Type","Seating Capacity","No. Of Instalments","Vehicle Usage","Vehicle License Class" );
                                        IF PremiumTableLines.FINDFIRST THEN BEGIN //find table
                                                                                  //MESSAGE('Premium =%1',PremiumTableLines."Premium Amount");
                                            IF InsQuote.GET("Document Type", "Document No.") THEN
                                                "TPO Premium" := InsQuote."No. Of Cover Periods" * PremiumTableLines."Premium Amount";


                                            IF PremiumTab."Inclusive of Taxes" THEN BEGIN //taxes
                                                TPOTaxPercentage := 0;
                                                TPOFlatAmtTax := 0;
                                                TPOLessTax := 0;
                                                TaxesRec.RESET;
                                                TaxesRec.SETRANGE(TaxesRec.Tax, TRUE);
                                                IF InsQuote.GET("Document Type", "Document No.") THEN
                                                    IF InsQuote."Action Type" <> InsQuote."Action Type"::New THEN
                                                        TaxesRec.SETRANGE(TaxesRec."Applicable to", TaxesRec."Applicable to"::All);
                                                IF TaxesRec.FINDFIRST THEN
                                                    REPEAT
                                                        IF TaxesRec."Calculation Method" = TaxesRec."Calculation Method"::"% of Gross Premium" THEN
                                                            TPOTaxPercentage := TPOTaxPercentage + TaxesRec."Loading Percentage";
                                                        IF TaxesRec."Calculation Method" = TaxesRec."Calculation Method"::"Flat Amount" THEN
                                                            TPOFlatAmtTax := TPOFlatAmtTax + TaxesRec."Loading Amount";
                                                    UNTIL TaxesRec.NEXT = 0;
                                                //MESSAGE('TotalPercentage=%1 Stamp=%2',TPOTaxPercentage,TPOFlatAmtTax);
                                                TPOLessTax := (100 / (100 + TPOTaxPercentage)) * ("TPO Premium");
                                                "TPO Premium" := TPOLessTax;
                                            END;  //taxes
                                        END//find table

                                        ELSE
                                            MESSAGE('Please setup the Premium table');
                                    END;

                                    //IF UnderwriterPolicyType.GET("Policy Type") THEN
                                    PLL := UnderwriterPolicyType."PPL Cost Per PAX" * "Seating Capacity";
                                    IF InsQuote."Action Type" = InsQuote."Action Type"::"Yellow Card" THEN BEGIN
                                        OptionalCovers.RESET;
                                        OptionalCovers.SETRANGE(OptionalCovers."Yellow Card", TRUE);
                                        IF OptionalCovers.FINDFIRST THEN BEGIN
                                            "TPO Premium" := 0;
                                            "Gross Premium" := 0;
                                            PLL := 0;
                                            Medical := "Seating Capacity" * OptionalCovers."Medical Per Person";

                                        END;

                                    END;

                                    IF InsQuote."Action Type" = InsQuote."Action Type"::"Additional Riders" THEN BEGIN

                                        "TPO Premium" := 0;
                                        "Gross Premium" := 0;
                                        PLL := 0;
                                        Medical := 0;
                                    END;
                                end;

                            end;
                        "Business Type"::"Insurance Company":
                            begin
                                IF "Policy Type" = '' THEN
                                    ERROR('Select policy type');

                                IF "No. Of Instalments" = 0 THEN
                                    ERROR('Select No. of Instalments');

                                IF PolicyType.GET("Policy Type") THEN
                                    IF PolicyType."Premium Table" <> '' THEN BEGIN //Premium table is linked

                                        PremiumTab.RESET;
                                        PremiumTab.SETRANGE(PremiumTab."Policy Type", "Policy Type");
                                        IF PremiumTab.FINDFIRST THEN
                                            PremiumTableLines.RESET;
                                        PremiumTableLines.SETRANGE(PremiumTableLines."Premium Table", PremiumTab.Code);
                                        PremiumTableLines.SETRANGE(PremiumTableLines."Policy Type", "Policy Type");
                                        PremiumTableLines.SETRANGE(PremiumTableLines."Seating Capacity", "Seating Capacity");
                                        IF PolicyType.GET("Policy Type") THEN
                                            IF PolicyType.Comprehensive THEN
                                                PremiumTableLines.SETRANGE(PremiumTableLines.Instalments, 1)
                                            ELSE
                                                PremiumTableLines.SETRANGE(PremiumTableLines.Instalments, "No. Of Instalments");
                                        PremiumTableLines.SETRANGE(PremiumTableLines."Vehicle Usage", "Vehicle Usage");
                                        PremiumTableLines.SETRANGE(PremiumTableLines."Vehicle Type", "Vehicle License Class");

                                        //MESSAGE('Policy Type =%1 Seating Capacity=%2 No. of instalments=%3 Veh usage=%4 vehicle lic class %5',
                                        //"Policy Type","Seating Capacity","No. Of Instalments","Vehicle Usage","Vehicle License Class" );
                                        IF PremiumTableLines.FINDFIRST THEN BEGIN //find table
                                                                                  //MESSAGE('Premium =%1',PremiumTableLines."Premium Amount");
                                            IF InsQuote.GET("Document Type", "Document No.") THEN
                                                "TPO Premium" := InsQuote."No. Of Cover Periods" * PremiumTableLines."Premium Amount";


                                            IF PremiumTab."Inclusive of Taxes" THEN BEGIN //taxes
                                                TPOTaxPercentage := 0;
                                                TPOFlatAmtTax := 0;
                                                TPOLessTax := 0;
                                                TaxesRec.RESET;
                                                TaxesRec.SETRANGE(TaxesRec.Tax, TRUE);
                                                IF InsQuote.GET("Document Type", "Document No.") THEN
                                                    IF InsQuote."Action Type" <> InsQuote."Action Type"::New THEN
                                                        TaxesRec.SETRANGE(TaxesRec."Applicable to", TaxesRec."Applicable to"::All);
                                                IF TaxesRec.FINDFIRST THEN
                                                    REPEAT
                                                        IF TaxesRec."Calculation Method" = TaxesRec."Calculation Method"::"% of Gross Premium" THEN
                                                            TPOTaxPercentage := TPOTaxPercentage + TaxesRec."Loading Percentage";
                                                        IF TaxesRec."Calculation Method" = TaxesRec."Calculation Method"::"Flat Amount" THEN
                                                            TPOFlatAmtTax := TPOFlatAmtTax + TaxesRec."Loading Amount";
                                                    UNTIL TaxesRec.NEXT = 0;
                                                //MESSAGE('TotalPercentage=%1 Stamp=%2',TPOTaxPercentage,TPOFlatAmtTax);
                                                TPOLessTax := (100 / (100 + TPOTaxPercentage)) * ("TPO Premium");
                                                "TPO Premium" := TPOLessTax;
                                            END;  //taxes
                                        END//find table

                                        ELSE
                                            MESSAGE('Please setup the Premium table');
                                    END;

                                IF PolicyType.GET("Policy Type") THEN
                                    PLL := PolicyType."PPL Cost Per PAX" * "Seating Capacity";
                                IF InsQuote."Action Type" = InsQuote."Action Type"::"Yellow Card" THEN BEGIN
                                    OptionalCovers.RESET;
                                    OptionalCovers.SETRANGE(OptionalCovers."Yellow Card", TRUE);
                                    IF OptionalCovers.FINDFIRST THEN BEGIN
                                        "TPO Premium" := 0;
                                        "Gross Premium" := 0;
                                        PLL := 0;
                                        Medical := "Seating Capacity" * OptionalCovers."Medical Per Person";

                                    END;

                                END;

                                IF InsQuote."Action Type" = InsQuote."Action Type"::"Additional Riders" THEN BEGIN

                                    "TPO Premium" := 0;
                                    "Gross Premium" := 0;
                                    PLL := 0;
                                    Medical := 0;
                                END;
                            end;
                    end
                end;


                CALCFIELDS("Extra Premium");
                Amount := "Gross Premium" + "TPO Premium" + PLL + "Extra Premium" + Medical;
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
            OptionMembers = "0","1","2","Payment Terms",Currency,"5","6","7","8","Country/Region","10","11";

            trigger OnValidate();
            begin
                CASE ft OF
                    ft::"0":
                        Height := "Height (ft)";
                    ft::"1":
                        Height := "Height (ft)" + (1 / 12);
                    ft::"2":
                        Height := "Height (ft)" + (2 / 12);
                    ft::"Payment Terms":
                        Height := "Height (ft)" + (3 / 12);
                    ft::Currency:
                        Height := "Height (ft)" + (4 / 12);
                    ft::"5":
                        Height := "Height (ft)" + (5 / 12);
                    ft::"6":
                        Height := "Height (ft)" + (6 / 12);
                    ft::"7":
                        Height := "Height (ft)" + (7 / 12);
                    ft::"8":
                        Height := "Height (ft)" + (8 / 12);
                    ft::"Country/Region":
                        Height := "Height (ft)" + (9 / 12);
                    ft::"10":
                        Height := "Height (ft)" + (10 / 12);
                    ft::"11":
                        Height := "Height (ft)" + (11 / 12);
                END;
                VALIDATE(Height);

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

            trigger OnValidate();
            begin
                Insetup.GET;
                Insetup.TESTFIELD(Insetup."Rounding Precision");

                IF Insetup."Rounding Type" = Insetup."Rounding Type"::Up THEN
                    Direction := '>'
                ELSE
                    IF Insetup."Rounding Type" = Insetup."Rounding Type"::Nearest THEN
                        Direction := '='
                    ELSE
                        IF Insetup."Rounding Type" = Insetup."Rounding Type"::Down THEN
                            Direction := '<';



                Amount := ROUND(Amount, Insetup."Rounding Precision", Direction);
            end;
        }
        field(107; "Extra Premium"; Decimal)
        {
            CalcFormula = Sum("Additional Benefits".Premium WHERE("Document Type" = FIELD("Document Type"),
                                                                   "Document No." = FIELD("Document No."),
                                                                   "Risk ID" = FIELD("Line No.")));
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
        field(110; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
        }
        field(111; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false))
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
            TableRelation = "SACCO Routes"."Route ID";
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
                                                             "Document No." = FIELD("Policy No"),
                                                             "Description Type" = CONST("Schedule of Insured"));

            trigger OnValidate();
            begin
                IF Policyline.GET(Policyline."Document Type"::Policy, "Policy No", "Select Risk ID") THEN
                    "Substituted Vehicle Reg. No" := Policyline."Registration No.";
            end;
        }
        field(120; "Endorsement Type"; Code[20])
        {
            TableRelation = "Endorsement Types";

            trigger OnValidate();
            begin
                IF EndorsmentType.GET("Endorsement Type") THEN
                    "Action Type" := EndorsmentType."Action Type";
            end;
        }
        field(121; "Action Type"; Option)
        {
            OptionCaption = '"  ,Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,Yellow Card,Additional Riders"';
            OptionMembers = "  ",Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,"Yellow Card","Additional Riders";
        }
        field(122; Selected; Boolean)
        {
        }
        field(123; "No. Of Instalments"; Integer)
        {
            Editable = false;
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
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(126; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
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
        field(141; "Posted Premium Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = CONST("Net Premium"),
                                                        "Endorsement No." = FIELD("Document No."),
                                                        "Document Type" = CONST(" ")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(142; "Posted Receipted Amount"; Decimal)
        {
            CalcFormula = - Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = CONST("Net Premium"),
                                                         "Endorsement No." = FIELD("Document No."),
                                                         "Document Type" = CONST(Payment)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(143;Relationship;Code[20])
        {
            Tablerelation=Relationship;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.", "Risk ID")
        {
        }
        key(Key2; "Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        IF "Document Type" = "Document Type"::Policy THEN
            ERROR('You cannot delete records on the policy');
    end;

    trigger OnInsert();
    begin

        IF "Line No." = 0 THEN BEGIN
            InsQuoteLines.RESET;
            InsQuoteLines.SETRANGE(InsQuoteLines."Document Type", "Document Type");
            InsQuoteLines.SETRANGE(InsQuoteLines."Document No.", "Document No.");
            IF InsQuoteLines.FINDLAST THEN
                "Line No." := InsQuoteLines."Line No." + 10000;
            //MESSAGE('Line No %1',InsQuoteLines."Line No."+10000);
        END;

        IF InsHeader.GET("Document Type", "Document No.") THEN BEGIN

            "Policy Type" := InsHeader."Policy Type";
            "No. Of Instalments" := InsHeader."No. Of Instalments";
            IF InsHeader."Policy No" <> '' THEN
                "Policy No" := InsHeader."Policy No";
            "Insured No." := InsHeader."Insured No.";
            "Insured Name" := InsHeader."Insured Name";
            "Endorsement Type" := InsHeader."Endorsement Type";
            "Action Type" := InsHeader."Action Type";
            PremiumTab.RESET;
            PremiumTab.SETRANGE(PremiumTab."Policy Type", InsHeader."Policy Type");
            IF PremiumTab.FINDFIRST THEN BEGIN
                "Vehicle License Class" := PremiumTab."Vehicle Class";
                "Vehicle Usage" := PremiumTab."Vehicle Usage";

            END;
            IF PolicyType.GET(InsHeader."Policy Type",InsHeader.Underwriter) THEN BEGIN

                "Rate Type" := PolicyType.Rating;
                "Rate %age" := PolicyType."Premium Rate";

            END;
        END;
    end;

    var
        InsQuote: Record "Insure Header";
        InsQuoteLines: Record "Insure Lines";
        RiskData: Record "Risk Database";
        InsHeader: Record "Insure Header";
        PolicyType: Record "Underwriter Policy Types";
        UnderwriterPolicyType: Record "Underwriter Policy Types";
        Insmanagement: Codeunit "Insurance management";
        PremiumTableLines: Record "Premium table Lines";
        PremiumTab: Record "Premium Table";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        EndorsmentType: Record "Endorsement Types";
        TaxesRec: Record "Loading and Discounts Setup";
        TPOLessTax: Decimal;
        TPOTaxPercentage: Decimal;
        TPOFlatAmtTax: Decimal;
        Policyline: Record "Insure Lines";
        PolicyLines: Record "Insure Lines";
        SalesHeader: Record "Insure Header";
        DimMgt: Codeunit 408;
        Insetup: Record "Insurance setup";
        Direction: Text;
        ItemEntryRelation: Record "Item Entry Relation";
        CancelReasonRec: Record "Cancellation Reasons";
        OptionalCovers: Record "Optional Covers";
        UserGroupMember: Record "User Group Member";
        UserGroupApprovalLimits: Record "User Group Approval Limits";
        ProductBen_Riders: Record "Product Benefits & Riders";

    local procedure GetInsureHeader();
    begin
    end;

    local procedure CheckGLAcc();
    begin
        GLAcc.CheckGLAcc;
        GLAcc.TESTFIELD("Direct Posting", TRUE);
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]);
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetInsureHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID, No, SourceCodeSetup.Sales,
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            InsHeader."Dimension Set ID", DATABASE::Customer);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        //ATOLink.UpdateAsmDimFromSalesLine(Rec);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}

