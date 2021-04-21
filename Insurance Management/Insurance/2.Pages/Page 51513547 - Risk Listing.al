page 51513547 "Risk Listing"
{
    
    Caption = 'Risk Listing';
    PageType = List;
    SourceTable = "Insure Lines";
    CardPageId="Risk card";
    Editable=false;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Registration No.";"Registration No.")
                {
                    Visible = RiskIdVisible;
                }
                field(Make;Make)
                {
                    Visible = MakeVisible;
                }
                field(Model;Model)
                {
                    Visible = ModelVisible;
                }
                field("Year of Manufacture";"Year of Manufacture")
                {
                    Visible = YOMVisible;
                }
                field("Type of Body";"Type of Body")
                {
                    //DrillDownPageID = "Car Models2";
                   // LookupPageID = "Car Models2";
                    Visible = BodyTypeVisible;
                }
                field("Cubic Capacity (cc)";"Cubic Capacity (cc)")
                {
                    Visible = CubicCapacityVisible;
                }
                field("Engine No.";"Engine No.")
                {
                    Visible = EngineNoVisible;
                }
                field("Radio Cassette";"Radio Cassette")
                {
                    Visible = RadioCassetteVisible;
                }
                field(Windscreen;Windscreen)
                {
                    Visible = WindScreenVisible;
                }
                field("Chassis No.";"Chassis No.")
                {
                    Visible = ChassisNoVisible;
                }
                field("Vehicle Tonnage";"Vehicle Tonnage")
                {
                    Visible = TonnageVisible;
                }
                field("Vehicle Usage";"Vehicle Usage")
                {
                   // DrillDownPageID = "Vehicle usage2";
                   // LookupPageID = "Vehicle usage2";
                    Visible = VehicleUsageVisible;
                }
                field("No. of Employees";"No. of Employees")
                {
                    Visible = NoOfEmployeesVisible;
                }
                field("Per Capita";"Per Capita")
                {
                    Visible = PerCapitaVisible;
                }
                field("Employee Name";"Employee Name")
                {
                    Visible = EmployeeNameVisible;
                }
                field(Category;Category)
                {
                    Visible = CategoryVisible;
                }
                field("Estimated Annual Earnings";"Estimated Annual Earnings")
                {
                    Visible = EstAnnualEarningsVisible;
                }
                field(Occupation;Occupation)
                {
                    Visible = OccupationVisible;
                }
                field("Limit of Liability";"Limit of Liability")
                {
                    Visible = LimitOfLiabilityVisible;
                }
                field("Relationship to Applicant";"Relationship to Applicant")
                {
                    Visible = Relationship2AppVisible;
                }
                field("Family Name";"Family Name")
                {
                    Visible = FamilyNameVisible;
                }
                field("First Name(s)";"First Name(s)")
                {
                    Visible = FirstNameVisible;
                }
                field(Sex;Sex)
                {
                    Visible = SexVisible;
                }
                field("Date of Birth";"Date of Birth")
                {
                    Visible = DOBVisible;
                }
                field(Age;Age)
                {
                    Visible = AgeVisible;
                }
                field(Death;Death)
                {
                    Visible = DeathVisible;
                }
                field("Death Rate";"Death Rate")
                {
                    Visible = DeathRate;
                }
                field("Permanent Disability";"Permanent Disability")
                {
                    Visible = PDVisible;
                }
                field("P.D Rate";"P.D Rate")
                {
                    Visible = PDRateVisible;
                }
                field("Temporary Disability";"Temporary Disability")
                {
                    Visible = TDVisible;
                }
                field("T.D Rate";"T.D Rate")
                {
                    Visible = TDRateVisible;
                }
                field("Medical expenses";"Medical expenses")
                {
                    Visible = MEVisible;
                }
                field("M.E Rate";"M.E Rate")
                {
                    Visible = MERateVisible;
                }
                field("Total Value at Risk";"Total Value at Risk")
                {
                    Visible = TVatRiskVisible;
                }
                field("First Loss Sum Insured";"First Loss Sum Insured")
                {
                    Visible = FirstLossSIVisible;
                }
                field(Description;Description)
                {
                    Visible = DescriptionVisible;
                }
                field("Rate Type";"Rate Type")
                {
                    Visible = RateTypeVisible;
                }
                field("Vehicle License Class";"Vehicle License Class")
                {
                    Visible = LicenseTypeVisible;
                }
                field("Seating Capacity";"Seating Capacity")
                {
                    Visible = SeatingCapacityVisible;
                }
                field("Carrying Capacity";"Carrying Capacity")
                {
                    Visible = carryingCapacitycvisible;
                }
                field("TPO Premium";"TPO Premium")
                {
                    Visible = TPOPremiumVisible;
                }
                field("Rate %age";"Rate %age")
                {
                    Visible = RatePercentVisible;
                }
                field("Sum Insured";"Sum Insured")
                {
                    Visible = SumInsuredVisible;
                   // Caption=SumAssInsureTxt;
                    
            

                
                }
                field("Gross Premium";"Gross Premium")
                {
                    Visible = GrossPremiumVisible;
                }
                field("Extra Premium";"Extra Premium")
                {
                    Visible = ExtraPremiumVisible;
                }
                field("SACCO ID";"SACCO ID")
                {
                    Visible = SaccoIDVisible;
                }
                field("Route ID";"Route ID")
                {
                    Visible = RouteIDVisible;
                }
                field("Endorsement Date";"Endorsement Date")
                {
                }
                field(Amount;Amount)
                {
                    Visible = AmountVisible;
                }
                //field("First Loss";"First Loss")
               // {
                    //Visible = firstlossvisible;
               // }
                field("Mark for Deletion";"Mark for Deletion")
                {
                    Visible = Markfordeletionvisible;
                }
                field("Deletion Date";"Deletion Date")
                {
                    Visible = deletiondatevisible;
                }
                //field("Max Sum Insured";"Max Sum Insured")
                //{
            }
        }
    }
    trigger OnNewRecord(BelowxRec : Boolean);
    begin
          "Description Type":="Description Type"::"Schedule of Insured";
          // "Business Type":="Business Type"::General;
    end;

    trigger OnOpenPage();
    begin
        RiskIdVisible:=FALSE;
        MakeVisible:=FALSE;
        ModelVisible:=FALSE;
        YOMVisible:=FALSE;
        BodyTypeVisible:=FALSE;
        carryingCapacitycvisible:=FALSE;
        SeatingCapacityVisible:=FALSE;
        CubicCapacityVisible:=FALSE;
        VehicleUsageVisible:=FALSE;
        WindScreenVisible:=FALSE;
        SumInsuredVisible:=FALSE;
        RadioCassetteVisible:=FALSE;
        WindScreenRateVisible:=FALSE;
        RadioCassetteRateVisible:=FALSE;
        RateTypeVisible:=FALSE;
        RatePercentVisible:=FALSE;
        DescriptionVisible:=FALSE;
        NoOfEmployeesVisible:=FALSE;
        CategoryVisible:=FALSE;
        EstAnnualEarningsVisible:=FALSE;
        OccupationVisible:=FALSE;
        LimitOfLiabilityVisible:=FALSE;
        PositionVisible:=FALSE;
        PerCapitaVisible:=FALSE;
        Relationship2AppVisible:=FALSE;
        FamilyNameVisible:=FALSE;
        FirstNameVisible:=FALSE;
        SexVisible:=FALSE;
        DOBVisible:=FALSE;
        AgeVisible:=FALSE;
        DeathVisible:=FALSE;
        DeathRate:=FALSE;
        PDVisible:=FALSE;
        PDRateVisible:=FALSE;
        TDVisible:=FALSE;
        TDRateVisible:=FALSE;
        MEVisible:=FALSE;
        MERateVisible:=FALSE;
        EmployeeNameVisible:=FALSE;
        TVatRiskVisible:=FALSE;
        FirstLossSIVisible:=FALSE;
        FirstLossRateVisible:=FALSE;
        GrossPremiumVisible:=FALSE;
        TPOPremiumVisible:=FALSE;
        EngineNoVisible:=FALSE;
        ChassisNoVisible:=FALSE;
        TonnageVisible:=FALSE;
        LicenseTypeVisible:=FALSE;
        ExtraPremiumVisible:=FALSE;
        SaccoIDVisible:=FALSE;
        RouteIDVisible:=FALSE;
        AmountVisible:=FALSE;
        firstlossvisible:=FALSE;
        IF InsureHeader.GET("Document Type","Document No.") THEN
        BEGIN

        // Message('khkjkk2');
               PolicyType.RESET;
               PolicyType.SETFILTER(PolicyType.Code,InsureHeader."Policy Type");

         IF PolicyType.FINDSET THEN    BEGIN
        // Message('khkjkk');
         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::Vehicle THEN
         BEGIN



              RiskIdVisible:=TRUE;
              MakeVisible:=TRUE;
              ModelVisible:=TRUE;
              YOMVisible:=TRUE;
              BodyTypeVisible:=TRUE;
              carryingCapacitycvisible:=TRUE;
              SeatingCapacityVisible:=TRUE;
              CubicCapacityVisible:=TRUE;
              VehicleUsageVisible:=TRUE;
              WindScreenVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RadioCassetteVisible:=TRUE;
              WindScreenRateVisible:=TRUE;
              RadioCassetteRateVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;

              RadioCassetteVisible:=TRUE;
              RadioCassetteRateVisible:=TRUE;
              WindScreenRateVisible:=TRUE;
              GrossPremiumVisible:=TRUE;
              TPOPremiumVisible:=TRUE;
              EngineNoVisible:=TRUE;
              ChassisNoVisible:=TRUE;
              TonnageVisible:=TRUE;
              LicenseTypeVisible:=TRUE;
              ExtraPremiumVisible:=TRUE;
              SaccoIDVisible:=TRUE;
              RouteIDVisible:=TRUE;
              AmountVisible:=TRUE;


         END;

         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::Other THEN
         BEGIN

              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              GrossPremiumVisible:=TRUE;
             // firstlossvisible:=TRUE;

         END;

        IF (PolicyType.Code='24')  THEN BEGIN
            firstlossvisible:=TRUE;
        END;

         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::Workmen THEN
         BEGIN
              NoOfEmployeesVisible:=TRUE;
              EstAnnualEarningsVisible:=TRUE;
              OccupationVisible:=TRUE;

              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              GrossPremiumVisible:=TRUE;


         END;

         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::Money THEN
         BEGIN


              LimitOfLiabilityVisible:=TRUE;
              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              GrossPremiumVisible:=TRUE;


         END;

         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::"Group Personal" THEN
         BEGIN
              EmployeeNameVisible:=TRUE;
              EstAnnualEarningsVisible:=TRUE;
              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              GrossPremiumVisible:=TRUE;


         END;

         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::Fidelity THEN
         BEGIN
              NoOfEmployeesVisible:=TRUE;
              PositionVisible:=TRUE;
              OccupationVisible:=TRUE;
              PerCapitaVisible:=TRUE;
              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              GrossPremiumVisible:=TRUE;


         END;

         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::Medical THEN
         BEGIN

              Relationship2AppVisible:=TRUE;
              FamilyNameVisible:=TRUE;
              FirstNameVisible:=TRUE;
              SexVisible:=TRUE;
              DOBVisible:=TRUE;
              AgeVisible:=TRUE;
              OccupationVisible:=TRUE;
              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              GrossPremiumVisible:=TRUE;


         END;

         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::"Personal Accident" THEN
         BEGIN

              DeathVisible:=TRUE;
              DeathRate:=TRUE;
              PDVisible:=TRUE;
              PDRateVisible:=TRUE;
              TDVisible:=TRUE;
              TDRateVisible:=TRUE;
              MEVisible:=TRUE;
              MERateVisible:=TRUE;
              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              GrossPremiumVisible:=TRUE;


         END;

         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::"Employers Liability" THEN
         BEGIN

              CategoryVisible:=TRUE;
              EstAnnualEarningsVisible:=TRUE;
              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              GrossPremiumVisible:=TRUE;

         END;

         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::Burglary THEN
         BEGIN
              TVatRiskVisible:=TRUE;
              FirstLossSIVisible:=TRUE;
              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              GrossPremiumVisible:=TRUE;

         END;

         IF PolicyType."Schedule Subform"=PolicyType."Schedule Subform"::Bond THEN
         BEGIN
              EmployeeNameVisible:=TRUE;

              DescriptionVisible:=TRUE;
              SumInsuredVisible:=TRUE;
              RateTypeVisible:=TRUE;
              RatePercentVisible:=TRUE;
              GrossPremiumVisible:=TRUE;

         END;

         IF "Document Type"="Document Type"::Policy THEN BEGIN
             markfordeletionvisible:=TRUE;
             deletiondatevisible:=TRUE;
         END;


        END;
        END;
    end;

    var
        RiskIdVisible : Boolean;
        MakeVisible : Boolean;
        ModelVisible : Boolean;
        YOMVisible : Boolean;
        BodyTypeVisible : Boolean;
        carryingCapacitycvisible : Boolean;
        SeatingCapacityVisible : Boolean;
        CubicCapacityVisible : Boolean;
        VehicleUsageVisible : Boolean;
        WindScreenVisible : Boolean;
        SumInsuredVisible : Boolean;
        RadioCassetteVisible : Boolean;
        WindScreenRateVisible : Boolean;
        RadioCassetteRateVisible : Boolean;
        RateTypeVisible : Boolean;
        RatePercentVisible : Boolean;
        DescriptionVisible : Boolean;
        NoOfEmployeesVisible : Boolean;
        CategoryVisible : Boolean;
        EstAnnualEarningsVisible : Boolean;
        OccupationVisible : Boolean;
        LimitOfLiabilityVisible : Boolean;
        PositionVisible : Boolean;
        PerCapitaVisible : Boolean;
        Relationship2AppVisible : Boolean;
        FamilyNameVisible : Boolean;
        FirstNameVisible : Boolean;
        SexVisible : Boolean;
        DOBVisible : Boolean;
        AgeVisible : Boolean;
        DeathVisible : Boolean;
        DeathRate : Boolean;
        PDVisible : Boolean;
        PDRateVisible : Boolean;
        TDVisible : Boolean;
        TDRateVisible : Boolean;
        MEVisible : Boolean;
        MERateVisible : Boolean;
        EmployeeNameVisible : Boolean;
        TVatRiskVisible : Boolean;
        FirstLossSIVisible : Boolean;
        FirstLossRateVisible : Boolean;
        GrossPremiumVisible : Boolean;
        TPOPremiumVisible : Boolean;
        InsureHeader : Record 51513016;
        PolicyType : Record "Underwriter Policy Types";
        EngineNoVisible : Boolean;
        ChassisNoVisible : Boolean;
        TonnageVisible : Boolean;
        LicenseTypeVisible : Boolean;
        ExtraPremiumVisible : Boolean;
        SaccoIDVisible : Boolean;
        RouteIDVisible : Boolean;
        AmountVisible : Boolean;
        firstlossvisible : Boolean;
        markfordeletionvisible : Boolean;
        deletiondatevisible : Boolean;
        SumAssInsureTxt:Text[30];
}


    

