report 51513010 "Insurance Quote1"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Insurance Quote1.rdl';
    PaperSourceFirstPage = Upper;

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            PrintOnlyIfDetail = true;
            column(PolicyNo_SalesInsuranceHeader; "Insure Header"."Policy No")
            {
            }
            column(PremiumAmount_SalesInsuranceHeader; "Insure Header"."Total Premium Amount")
            {
            }
            column(Underwriter_SalesInsuranceHeader; "Insure Header".Underwriter)
            {
            }
            column(Occupation_SalesInsuranceHeader; "Insure Header".Occupation)
            {
            }
            column(DocumentType_SalesInsuranceHeader; "Insure Header"."Document Type")
            {
            }
            column(PolicyType_SalesInsuranceHeader; "Insure Header"."Policy Type")
            {
            }
            column(SelltoCustomerName_SalesInsuranceHeader; "Insure Header"."Insured Name")
            {
            }
            column(No_SalesInsuranceHeader; "Insure Header"."No.")
            {
            }
            column(FromDate_SalesInsuranceHeader; "Insure Header"."From Date")
            {
            }
            column(PostingDate_SalesInsuranceHeader; "Insure Header"."Posting Date")
            {
            }
            column(UndewriterName_SalesInsuranceHeader; "Insure Header"."Underwriter Name")
            {
            }
            column(ToDate_SalesInsuranceHeader; "Insure Header"."To Date")
            {
            }
            column(CoverTypeDescription_SalesInsuranceHeader; "Insure Header"."Cover Type Description")
            {
            }
            column(SelltoAddress_SalesInsuranceHeader; "Insure Header"."Vessel Name")
            {
            }
            column(TotalPremiumAmount_SalesInsuranceHeader; "Insure Header"."Total Premium Amount")
            {
            }
            column(TotalDiscountAmount_SalesInsuranceHeader; "Insure Header"."Total  Discount Amount")
            {
            }
            column(SelltoCity_SalesInsuranceHeader; "Insure Header"."Vessel Name")
            {
            }
            column(Amount_SalesInsuranceHeader; "Insure Header"."Premium Amount")
            {
            }
            column(TotalCommissionOwed_SalesInsuranceHeader; "Insure Header"."Total Commission Owed")
            {
            }
            column(TotalTrainingLevy_SalesInsuranceHeader; "Insure Header"."Total Training Levy")
            {
            }
            column(TotalPHCF_SalesInsuranceHeader; "Insure Header"."Total Training Levy")
            {
            }
            column(CoverSummary_SalesInsuranceHeader; "Insure Header"."Premium Financier Name")
            {
            }
            column(ShortcutDimension1Code_SalesInsuranceHeader; "Insure Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_SalesInsuranceHeader; "Insure Header"."Shortcut Dimension 2 Code")
            {
            }
            column(Address; STRSUBSTNO('P.0. BOX %1', "Insure Header"."Family Name"))
            {
            }
            column(PrintingDate; DatePrinted)
            {
            }
            column(username; UserName)
            {
            }
            column(Commission; Commission)
            {
            }
            column(TrainingLevy; TrainingLevy)
            {
            }
            column(Stamp; Stamp)
            {
            }
            column(PhcfAmount; PhcfAmount)
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(PolicyPeriod; STRSUBSTNO('%1 -%2', "Insure Header"."From Date", "Insure Header"."To Date"))
            {
            }
            column(SelltoCustomerNo_SalesInsuranceHeader; "Insure Header"."Insured No.")
            {
            }
            column(PolicyDescription_SalesInsuranceHeader; "Insure Header"."Policy Description")
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyPhone2; CompanyInfo."Phone No. 2")
            {
            }
            dataitem("Insure Lines"; "Insure Lines")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                column(ActualValue_SalesInsuranceLine; "Insure Lines"."Actual Value")
                {
                }
                column(Value_SalesInsuranceLine; "Insure Lines".Value)
                {
                }
                column(DescriptionType_SalesInsuranceLine; "Insure Lines"."Description Type")
                {
                }
                column(Description_SalesInsuranceLine; "Insure Lines".Description)
                {
                }
                column(RegistrationNo_SalesInsuranceLine; "Insure Lines"."Registration No.")
                {
                }
                column(Make_SalesInsuranceLine; "Insure Lines".Make)
                {
                }
                column(SumInsured_SalesInsuranceLine; "Insure Lines"."Sum Insured")
                {
                }
                column(YearofManufacture_SalesInsuranceLine; "Insure Lines"."Year of Manufacture")
                {
                }
                column(TypeofBody_SalesInsuranceLine; "Insure Lines"."Type of Body")
                {
                }
                column(CubicCapacitycc_SalesInsuranceLine; "Insure Lines"."Cubic Capacity (cc)")
                {
                }
                column(SeatingCapacity_SalesInsuranceLine; "Insure Lines"."Seating Capacity")
                {
                }
                column(CarryingCapacity_SalesInsuranceLine; "Insure Lines"."Carrying Capacity")
                {
                }
                column(PremiumAmount_SalesInsuranceLine; "Insure Lines"."Premium Amount")
                {
                }
                column(PHCF_SalesInsuranceLine; "Insure Lines".Tax)
                {
                }
                column(StampDuty_SalesInsuranceLine; "Insure Lines".Tax)
                {
                }
                column(Model_SalesInsuranceLine; "Insure Lines".Model)
                {
                }
                column(WHTAmount_SalesInsuranceLine; "Insure Lines".Tax)
                {
                }
                column(TrainingLevy_SalesInsuranceLine; "Insure Lines".Amount)
                {
                }
                column(WHTCode_SalesInsuranceLine; "Insure Lines"."TVA Rate")
                {
                }
                column(NetCommission_SalesInsuranceLine; "Insure Lines".Amount)
                {
                }
                column(ChassisNo_SalesInsuranceLine; "Insure Lines"."Chassis No.")
                {
                }
                column(EngineNo_SalesInsuranceLine; "Insure Lines"."Engine No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                DatePrinted := 'Date Printed: ' + FORMAT(TODAY);
                Users.RESET;
                Users.SETRANGE(Users."Windows Security ID", USERID);
                IF Users.FIND('-') THEN BEGIN
                    UserName := Users."Full Name";
                END;
                CompanyInfo.GET;
                InsuranceSetup.GET;
                //Stamp:=InsuranceSetup."Stamp Duty";
                //TotalAmount:="Insure Header"."Total Premium Amount"+"Insure Header"."Total Commission"+"Insure Header"."Total Commission Owed"+"Insure Header"."Total Training Levy"+Stamp;
            end;

            trigger OnPreDataItem();
            begin
                "Insure Header".SETRANGE("Insure Header"."Document Type", QuoteRecGlobal."Document Type");
                "Insure Header".SETRANGE("Insure Header"."No.", QuoteRecGlobal."No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        Company_Name = 'Chase Insurance Agencies LTD'; Address_1 = 'Prudential Building, 6th Floor,'; Address_2 = 'Wabera Street.'; Address_3 = 'P.0 BOX 607-00621'; Address_4 = 'NAIROBI'; Address_5 = 'BRANCH:  Head Office'; Tel = 'TEL:  020-2774770/1/2'; Fax = 'FAX: 020-2246334'; Email = 'insurance@winton-investments.com'; DebitNot_Caption = 'DEBIT NOTE'; Description_Lable = 'Your account has been debited in accordance with the debit not as below for'; Date_Lable = 'DATE'; Account_Lable = 'ACCOUNT'; Insured_Lable = 'INSURED'; Occupation_Lable = 'OCCUPATION'; sumInsured = 'INTEREST AND SUM INSURED'; RegNo = 'REG NO.'; ChassisNo = 'CHASIS NO'; Make = 'MAKE'; Model = 'MODEL'; SittingCapacity = 'S. CAPA.'; Tonnage = 'TANNAGE'; cc = 'C.C.'; Year = 'YEAR'; Value = 'VALUE'; limits = 'LIMITS'; excess = 'EXCESS'; SpecialExtensiveClauses = 'SPECIAL/EXTENSIVE CLAUSES'; Insurer = 'INSURER'; Premium = 'PREMIUM'; TraniningLevy = 'TRAINING LEVY'; phcf = 'P.H.C.F.'; stampduty = 'STAMP DUTY'; pc = 'P.H.C.F.'; Total = 'TOTAL'; Note = 'IN ACCORDANCE WITH THE INSURANCE ACT, FULL PREMIUM MUST BE PAID BEFORE COVER ATTACHES. INDLY THERFORE, ARRANGE TO SETTLE PREMIUM BEFORE RENEWAL / INCEPTION DATE'; preparedby = 'PREPARED BY:'; dateprinted = 'Date Printed'; Authorisation = 'AUTHORISED SIGNATORY'; cover = 'COVER'; Period1 = 'PERIOD'; DnoteNo = 'D/NOTE NO.'; PolicyNo = 'POLICY NO.'; Ref = 'OUR REF.'; CoverSummary = 'COVER SUMMARY'; Branch = 'BRANCH';
    }

    var
        DatePrinted: Text[100];
        UserName: Text[100];
        UserSetup: Record "User Setup";
        Users: Record 2000000120;
        NoOfLives: Integer;
        AreaOfCoverage: Record "Insurer Policy Details";
        FoundationDescription: Text[130];
        LevelofCover: Text[250];
        ProductDesc: Text[130];
        PolicyTypeRec: Record "Policy Details";
        QuoteNo: Code[20];
        TotalPremium: Decimal;
        GenJnlLine: Record "Gen. Journal Line";
        ExcessDesc: Text[250];
        SalesLineRec: Record "Insure Lines";
        optionselected: Record "Insure Lines";
        Namesdesc: Text[230];
        CompanyAddr: array[8] of Text[130];
        CompanyInfo: Record 79;
        FormatAddr: Codeunit 365;
        slipdesc: Text[80];
        PolicyType: Record 51513009;
        DocumentType: Integer;
        InsuranceTypeRec: Record "Policy Type";
        CustAddr: array[8] of Text[230];
        Numberdescr: Text[30];
        proposerclient: Text[230];
        Counter: Integer;
        CoverHeader: Text[30];
        InterestHeader: Text[30];
        ExcessHeader: Text[30];
        LiabilityHeader: Text[30];
        ConditionsHeader: Text[30];
        LiabilityHeader2: Text[30];
        ConditionsHeader2: Text[30];
        WarrantyHeader: Text[30];
        BasisHeader: Text[30];
        TimeDescription: Text[50];
        GeographicHeader: Text[30];
        PeriodDescription: Text[120];
        Rating: Decimal;
        RatingDescription: Text[50];
        kurrency: Code[10];
        GLSetup: Record "General Ledger Setup";
        OrderHereon: Text[30];
        OrderHereonCaption: Text[30];
        InformationHeader: Text[30];
        InformationHeader2: Text[30];
        ProductDesc2: Text[130];
        SumsInsuredHeader: Text[30];
        ExclusionHeader: Text[30];
        ConveyanceHeader: Text[30];
        OrderHereonDesc: Text[30];
        policynum: Code[20];
        NatureOfBusinessHeader: Text[30];
        DiscountHeader: Text[30];
        RatingHeader: Text[30];
        NoOfLoops: Integer;
        Counter1: Integer;
        Commission: Decimal;
        TrainingLevy: Decimal;
        Stamp: Decimal;
        PhcfAmount: Decimal;
        InsuranceSetup: Record "Insurance setup";
        TotalAmount: Integer;
        QuoteRecGlobal: Record "Insure Header";

    procedure GetQuote(var Quoterec: Record "Insure Header");
    begin
        QuoteRecGlobal.COPY(Quoterec);
    end;

    procedure GetRating(var SalesHeader: Record "Insure Header") RatingDesc: Text[50];
    var
        RatingTable: Record "Insurer Policy Details";
        RatingPermanent: Text[250];
    begin
        /*RatingTable.RESET;
        RatingTable.SETRANGE(RatingTable."Policy Type",SalesHeader.Tonnage);
        RatingTable.SETRANGE(RatingTable."Description Type",SalesHeader."No.");
        RatingTable.SETRANGE(RatingTable."Actual Value",RatingTable."Actual Value"::"2");
        IF NOT RatingTable.FIND('+') THEN
        BEGIN
        
         SalesLineRec.RESET;
         SalesLineRec.SETRANGE(SalesLineRec."Document Type",SalesHeader.Tonnage);
         SalesLineRec.SETRANGE(SalesLineRec."Document No.",SalesHeader."No.");
         SalesLineRec.SETRANGE(SalesLineRec."Description Type",SalesLineRec."Description Type"::"10");
         IF SalesLineRec.FIND('-') THEN
         REPEAT
         IF SalesLineRec."Rate %age"<>0 THEN
         RatingDescription:=FORMAT(SalesLineRec."Rate %age")+ ' ' +FORMAT(SalesLineRec."Rate Type");
         IF SalesLineRec."Per Capita"<>0 THEN
         RatingDescription:=RatingDescription+ '+'+  kurrency + ' '+FORMAT(SalesLineRec."Per Capita") +' '+'per capita' ;
        
         IF SalesLineRec.PLL<>0 THEN
         RatingDescription:=RatingDescription+ ' + PLL '+  kurrency + ' '+FORMAT(SalesLineRec.PLL) +' '+'Per Person' ;
        
        
        
        RatingTable.INIT;
        RatingTable."Policy Type":=SalesHeader.Tonnage;
        RatingTable."Description Type":=SalesHeader."No.";
        RatingTable."Actual Value":=RatingTable."Actual Value"::"2";
        RatingTable.Description:=RatingDescription;
        RatingTable."No.":=RatingTable."No."+10000;
        RatingTable.INSERT;
        
         UNTIL SalesLineRec.NEXT=0;
         EXIT(RatingDescription);
        END;
               */

    end;

    procedure CoinsuranceTest(var QuoteHeadr: Record "Insure Header") Coinsure: Boolean;
    var
        CoinsureRec: Record 51513023;
    begin
        /*Coinsure:=FALSE;
        CoinsureRec.RESET;
        CoinsureRec.SETRANGE(CoinsureRec."Document Type",QuoteHeadr.Tonnage);
        CoinsureRec.SETRANGE(CoinsureRec."Document No",QuoteHeadr."No.");
         IF  CoinsureRec.FIND('+') THEN
         BEGIN
         Coinsure:=TRUE;
         EXIT(Coinsure);
         END;  */

    end;

    procedure FillRatingsTable(var SalesHeader: Record "Insure Header");
    begin
    end;
}

