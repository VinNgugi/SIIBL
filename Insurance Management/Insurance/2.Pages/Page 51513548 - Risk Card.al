page 51513548 "Risk Card"
{
    
    Caption = 'Risk Card';
    PageType = Card;
    SourceTable = "Insure Lines";
    
    layout
    {
        area(content)
        {
            group(General)
            {
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field';
                    ApplicationArea = All;
                    Visible=TitleVisible;
                }
                    
                field("Family Name"; Rec."Family Name")
                {
                    ToolTip = 'Specifies the value of the Family Name field';
                    ApplicationArea = All;
                    Visible=FamilyNameVisible;
                }
                field("First Name(s)"; Rec."First Name(s)")
                {
                    ToolTip = 'Specifies the value of the First Name(s) field';
                    ApplicationArea = All;
                    Visible=FirstNameVisible;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the value of the Date of Birth field';
                    ApplicationArea = All;
                    Visible=DateofBirthVisible;
                }
                field(Sex; Rec.Sex)
                {
                    ToolTip = 'Specifies the value of the Sex field';
                    ApplicationArea = All;
                    Visible=SexVisible;
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the value of the Age field';
                    ApplicationArea = All;
                    Visible=AgeVisible;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ToolTip = 'Specifies the value of the Registration No. field';
                    ApplicationArea = All;
                    visible=RegistrationNoVisible;
                }
                field(Make; Rec.Make)
                {
                    ToolTip = 'Specifies the value of the Make field';
                    ApplicationArea = All;
                    Visible=MakeVisible;
                }
                field(Model; Rec.Model)
                {
                    ToolTip = 'Specifies the value of the Model field';
                    ApplicationArea = All;
                    visible=ModelVisible;
                }
                field(Colour; Rec.Colour)
                {
                    ToolTip = 'Specifies the value of the Colour field';
                    ApplicationArea = All;
                    Visible=ColourVisible;
                }
                field("Chassis No."; Rec."Chassis No.")
                {
                    ToolTip = 'Specifies the value of the Chassis No. field';
                    ApplicationArea = All;
                    Visible=ChassisNoVisible;
                }
                field("Engine No."; Rec."Engine No.")
                {
                    ToolTip = 'Specifies the value of the Engine No. field';
                    ApplicationArea = All;
                    visible=EngineNoVisible;
                }
                field("Cubic Capacity (cc)"; Rec."Cubic Capacity (cc)")
                {
                    ToolTip = 'Specifies the value of the Cubic Capacity (cc) field';
                    ApplicationArea = All;
                    Visible=CubicCapacityVisible;
                }
                field("Carrying Capacity"; Rec."Carrying Capacity")
                {
                    ToolTip = 'Specifies the value of the Carrying Capacity field';
                    ApplicationArea = All;
                    Visible=carryingCapacitycvisible;
                }
                field(Nationality; Rec.Nationality)
                {
                    ToolTip = 'Specifies the value of the Nationality field';
                    ApplicationArea = All;
                    Visible=NationalityVisible;
                }
                field("Nationality Description"; Rec."Nationality Description")
                {
                   ToolTip = 'Specifies the value of the Nationality Description field';
                    ApplicationArea = All;
                    visible=NationalityVisible;
                }
                field("Radio Cassette"; Rec."Radio Cassette")
                {
                    ToolTip = 'Specifies the value of the Radio Cassette field';
                    ApplicationArea = All;
                    Visible=RadioCassetteRateVisible;
                }
                field("Radio Cassette % Rate"; Rec."Radio Cassette % Rate")
                {
                    ToolTip = 'Specifies the value of the Radio Cassette % Rate field';
                    ApplicationArea = All;
                    Visible=RadioCassetteRateVisible;
                }
                
                field("Relationship to Applicant"; Rec."Relationship to Applicant")
                {
                    ToolTip = 'Specifies the value of the Relationship to Applicant field';
                    ApplicationArea = All;
                    visible=Relationship2AppVisible;
                }
                field("TPO Premium"; Rec."TPO Premium")
                {
                    ToolTip = 'Specifies the value of the TPO Premium field';
                    ApplicationArea = All;
                    
                }
                field("TPO Discount %"; Rec."TPO Discount %")
                {
                    ToolTip = 'Specifies the value of the TPO Discount % field';
                    ApplicationArea = All;
                }
                field("Vehicle License Class"; Rec."Vehicle License Class")
                {
                    ToolTip = 'Specifies the value of the Vehicle License Class field';
                    ApplicationArea = All;
                    Visible=VehicleUsageVisible;
                }
                field("Vehicle Usage"; Rec."Vehicle Usage")
                {
                    ToolTip = 'Specifies the value of the Vehicle Usage field';
                    ApplicationArea = All;
                    Visible=VehicleUsageVisible;
                }
                field("Vehicle Tonnage"; Rec."Vehicle Tonnage")
                {
                    ToolTip = 'Specifies the value of the Vehicle Tonnage field';
                    ApplicationArea = All;
                    visible=VehicleTonnageVisible;
                }
                field("Windscreen % Rate"; Rec."Windscreen % Rate")
                {
                    ToolTip = 'Specifies the value of the Windscreen % Rate field';
                    ApplicationArea = All;
                    Visible=WindScreenRateVisible;
                }
                field(Windscreen; Rec.Windscreen)
                {
                    ToolTip = 'Specifies the value of the Windscreen field';
                    ApplicationArea = All;
                    Visible=WindScreenRateVisible;
                }
                field(Weight; Rec.Weight)
                {
                    ToolTip = 'Specifies the value of the Weight field';
                    ApplicationArea = All;
                    visible=WeightVisible;
                }
                field("Weight Unit"; Rec."Weight Unit")
                {
                    ToolTip = 'Specifies the value of the Weight Unit field';
                    ApplicationArea = All;
                    Visible=WeightVisible;
                }
                field("Weight(Kg)"; Rec."Weight(Kg)")
                {
                    ToolTip = 'Specifies the value of the Weight(Kg) field';
                    ApplicationArea = All;
                    Visible=WeightVisible;
                }
                field("Country of Residence"; Rec."Country of Residence")
                {
                    ToolTip = 'Specifies the value of the Country of Residence field';
                    ApplicationArea = All;
                    Visible=NationalityVisible;
                }
                field(BMI; Rec.BMI)
                {
                    ToolTip = 'Specifies the value of the BMI field';
                    ApplicationArea = All;
                    Visible=BMIvisible;
                }
                field("Area of Cover"; Rec."Area of Cover")
                {
                    ToolTip = 'Specifies the value of the Area of Cover field';
                    ApplicationArea = All;
                    visible=AreaofCoverVisible;
                }
                field("Cover Description"; Rec."Cover Description")
                {
                    ToolTip = 'Specifies the value of the Cover Description field';
                    ApplicationArea = All;
                    Visible=CoverDescVisible;
                }
                field("Cover Type"; Rec."Cover Type")
                {
                    ToolTip = 'Specifies the value of the Cover Type field';
                    ApplicationArea = All;
                    Visible=CovertType;
                }
                field(Death; Rec.Death)
                {
                    ToolTip = 'Specifies the value of the Death field';
                    ApplicationArea = All;
                    Visible=DeathVisible;
                }
                field("Death Rate"; Rec."Death Rate")
                {
                    ToolTip = 'Specifies the value of the Death Rate field';
                    ApplicationArea = All;
                    Visible=DeathVisible;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field';
                    ApplicationArea = All;
                    Visible=EmployeeNameVisible;
                }
                field("Endorsement Date"; Rec."Endorsement Date")
                {
                    ToolTip = 'Specifies the value of the Endorsement Date field';
                    ApplicationArea = All;
                    Visible=EndorsementDateVisible;
                }
                field("Estimated Annual Earnings"; Rec."Estimated Annual Earnings")
                {
                    ToolTip = 'Specifies the value of the Estimated Annual Earnings field';
                    ApplicationArea = All;
                    Visible=EstAnnualEarningsVisible;
                }
                field("Extra Premium"; Rec."Extra Premium")
                {
                    ToolTip = 'Specifies the value of the Extra Premium field';
                    ApplicationArea = All;
                    Visible=XpremiumVisible;
                }
                field(Height; Rec.Height)
                {
                    ToolTip = 'Specifies the value of the Height field';
                    ApplicationArea = All;
                    visible=HeightVisible;
                }
                field("Height (ft)"; Rec."Height (ft)")
                {
                    ToolTip = 'Specifies the value of the Height (ft) field';
                    ApplicationArea = All;
                    Visible=HeightVisible;
                }
                field("Height Unit"; Rec."Height Unit")
                {
                    ToolTip = 'Specifies the value of the Height Unit field';
                    ApplicationArea = All;
                    Visible=HeightVisible;
                }
                field("Height(m)"; Rec."Height(m)")
                {
                    ToolTip = 'Specifies the value of the Height(m) field';
                    ApplicationArea = All;
                    Visible=HeightVisible;
                }
                field("Gross Premium"; Rec."Gross Premium")
                {
                    ToolTip = 'Specifies the value of the Gross Premium field';
                    ApplicationArea = All;
                    Visible=GrossPremiumVisible;
                }
                field("Seating Capacity"; Rec."Seating Capacity")
                {
                    ToolTip = 'Specifies the value of the Seating Capacity field';
                    ApplicationArea = All;
                    visible=SeatingCapacityVisible;
                }
                field("Serial No"; Rec."Serial No")
                {
                    ToolTip = 'Specifies the value of the Serial No field';
                    ApplicationArea = All;
                    Visible=serialNoVisible;
                }
                field("Sum Insured"; Rec."Sum Insured")
                {
                    ToolTip = 'Specifies the value of the Sum Insured field';
                    ApplicationArea = All;
                    visible=SumInsuredVisible;
                    
                }
                field("Rate %age"; Rec."Rate %age")
                {
                    ToolTip = 'Specifies the value of the Rate %age field';
                    ApplicationArea = All;
                    Visible=RatePercentVisible;
                }
                field("Rate Type"; Rec."Rate Type")
                {
                    ToolTip = 'Specifies the value of the Rate Type field';
                    ApplicationArea = All;
                    Visible=RateTypeVisible;
                }
                field("Rate Discount %"; Rec."Rate Discount %")
                {
                    ToolTip = 'Specifies the value of the Rate Discount % field';
                    ApplicationArea = All;
                    Visible=RatePercentVisible;
                }
                field("T.D Rate"; Rec."T.D Rate")
                {
                    ToolTip = 'Specifies the value of the T.D Rate field';
                    ApplicationArea = All;
                    Visible=TDRateVisible;
                }
                field("TVA Rate"; Rec."TVA Rate")
                {
                    ToolTip = 'Specifies the value of the TVA Rate field';
                    ApplicationArea = All;
                    Visible=TDRateVisible;
                }
                field("Temporary Disability"; Rec."Temporary Disability")
                {
                    ToolTip = 'Specifies the value of the Temporary Disability field';
                    ApplicationArea = All;
                    Visible=TDVisible;
                }
                field("Total Value at Risk"; Rec."Total Value at Risk")
                {
                    ToolTip = 'Specifies the value of the Total Value at Risk field';
                    ApplicationArea = All;
                    Visible=TVatRiskVisible;
                }
                field("Type of Body"; Rec."Type of Body")
                {
                    ToolTip = 'Specifies the value of the Type of Body field';
                    ApplicationArea = All;
                    Visible=VehicleUsageVisible;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            action("Additional Covers")
            {
                RunObject = Page 51513029;
                RunPageLink = "Document Type"=FIELD("Document Type"),
                "Document No."=field("Document No."),
                "Risk Id"=field("Risk ID");
                              
            }
        }
    }



    trigger OnNewRecord(BelowxRec : Boolean);
    begin
          "Description Type":="Description Type"::"Schedule of Insured";
          InsureLines.reset;
          InsureLines.setrange(Insurelines."Document Type","Document Type");
          InsureLines.setrange(InsureLines."Document No.","Document No.");
          If insurelines.Findlast() then
          begin
          "Line No.":=insurelines."Line No."+1;          
          "Risk Id":=InsureLines."Risk ID"+1;
          end;

    end;

          // "Business Type":="Business Type"::General;
    

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
        TitleVisible:Boolean;
        DateofBirthVisible:Boolean;
        RegistrationNoVisible: Boolean;
        ColourVisible:Boolean;
        NationalityVisible:Boolean;

        VehicleTonnageVisible:Boolean;
        WeightVisible:Boolean;
        HeightVisible:Boolean;
        serialNoVisible:Boolean;
        XpremiumVisible:Boolean;
        EndorsementDateVisible:Boolean;
        CoverDescVisible:Boolean;
        AreaofCoverVisible:Boolean;
        CovertType:Boolean;
        BMIvisible:Boolean;
        InsureLines: Record "Insure Lines";







}

