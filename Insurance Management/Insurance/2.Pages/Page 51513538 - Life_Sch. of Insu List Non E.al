page 51513538 "Life_Sch. of Insu List Non E"
{
    // version AES-INS 1.0

    CardPageID = "Add_Edit Vehicle";
    Editable = true;
    PageType = ListPart;
    SourceTable = "Insure Lines";
    SourceTableView = WHERE("Description Type" = CONST("Schedule of Insured"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Registration No."; "Registration No.")
                {
                    Editable = false;
                    Visible = RiskIdVisible;
                }
                field(Make; Make)
                {
                    Editable = false;
                    Visible = MakeVisible;
                }
                field(Model; Model)
                {
                    Editable = false;
                    Visible = YOMVisible;
                }
                field("Year of Manufacture"; "Year of Manufacture")
                {
                    Editable = false;
                    Visible = YOMVisible;
                }
                field("Type of Body"; "Type of Body")
                {
                    Editable = false;
                    Visible = BodyTypeVisible;
                }
                field("Cubic Capacity (cc)"; "Cubic Capacity (cc)")
                {
                    Editable = false;
                    Visible = CubicCapacityVisible;
                }
                field("Vehicle Usage"; "Vehicle Usage")
                {
                    Editable = false;
                    Visible = VehicleUsageVisible;
                }
                field("Vehicle License Class"; "Vehicle License Class")
                {
                    Editable = false;
                }
                field("Policy Type"; "Policy Type")
                {
                    Editable = false;
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                    Editable = false;
                }
                field("Seating Capacity"; "Seating Capacity")
                {
                    Editable = false;
                    Visible = SeatingCapacityVisible;
                }
                field("Carrying Capacity"; "Carrying Capacity")
                {
                    Editable = false;
                    Visible = carryingCapacitycvisible;
                }
                field(Windscreen; Windscreen)
                {
                    Editable = false;
                    Visible = WindScreenVisible;
                }
                field("Sum Insured"; "Sum Insured")
                {
                    Editable = false;
                    Visible = SumInsuredVisible;
                }
                field("Radio Cassette"; "Radio Cassette")
                {
                    Editable = false;
                    Visible = RadioCassetteVisible;
                }
                field("Windscreen % Rate"; "Windscreen % Rate")
                {
                    Enabled = false;
                    Visible = WindScreenRateVisible;
                }
                field("Radio Cassette % Rate"; "Radio Cassette % Rate")
                {
                    Editable = false;
                    Visible = RadioCassetteRateVisible;
                }
                field("Rate Type"; "Rate Type")
                {
                    Editable = false;
                    Visible = RateTypeVisible;
                }
                field("Rate %age"; "Rate %age")
                {
                    Editable = false;
                    Visible = RatePercentVisible;
                }
                field(Description; Description)
                {
                    Visible = DescriptionVisible;
                }
                field("No. of Employees"; "No. of Employees")
                {
                    Visible = NoOfEmployeesVisible;
                }
                field(Category; Category)
                {
                    Visible = CategoryVisible;
                }
                field("Estimated Annual Earnings"; "Estimated Annual Earnings")
                {
                    Visible = EstAnnualEarningsVisible;
                }
                field(Occupation; Occupation)
                {
                    Visible = OccupationVisible;
                }
                field("Limit of Liability"; "Limit of Liability")
                {
                    Visible = LimitOfLiabilityVisible;
                }
                field(Position; Position)
                {
                    Visible = PositionVisible;
                }
                field("Per Capita"; "Per Capita")
                {
                    Visible = PerCapitaVisible;
                }
                field("Relationship to Applicant"; "Relationship to Applicant")
                {
                    Visible = Relationship2AppVisible;
                }
                field("Family Name"; "Family Name")
                {
                    Visible = FamilyNameVisible;
                }
                field("First Name(s)"; "First Name(s)")
                {
                    Visible = FirstNameVisible;
                }
                field(Sex; Sex)
                {
                    Visible = SexVisible;
                }
                field("Date of Birth"; "Date of Birth")
                {
                    Visible = DOBVisible;
                }
                field(Age; Age)
                {
                    Visible = AgeVisible;
                }
                field(Death; Death)
                {
                    Visible = DeathVisible;
                }
                field("Death Rate"; "Death Rate")
                {
                    Visible = DeathRate;
                }
                field("Permanent Disability"; "Permanent Disability")
                {
                    Visible = PDVisible;
                }
                field("P.D Rate"; "P.D Rate")
                {
                    Visible = PDRateVisible;
                }
                field("Temporary Disability"; "Temporary Disability")
                {
                    Visible = TDVisible;
                }
                field("T.D Rate"; "T.D Rate")
                {
                    Visible = TDRateVisible;
                }
                field("Medical expenses"; "Medical expenses")
                {
                    Visible = MEVisible;
                }
                field("M.E Rate"; "M.E Rate")
                {
                    Visible = MERateVisible;
                }
                field(EmployeeNameVisible; EmployeeNameVisible)
                {
                    Visible = EmployeeNameVisible;
                }
                field("Total Value at Risk"; "Total Value at Risk")
                {
                    Visible = TVatRiskVisible;
                }
                field("First Loss Sum Insured"; "First Loss Sum Insured")
                {
                    Visible = FirstLossSIVisible;
                }
                field("First Loss Rate"; "First Loss Rate")
                {
                    Visible = FirstLossRateVisible;
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("Chassis No."; "Chassis No.")
                {
                }
                field("Certificate No."; "Certificate No.")
                {
                }
                field(Status; Status)
                {
                }
                field("Gross Premium"; "Gross Premium")
                {
                    Caption = 'Comp. Premium';
                    Editable = false;
                    Visible = GrossPremiumVisible;
                }
                field("TPO Premium"; "TPO Premium")
                {
                    Editable = false;
                    Visible = TPOPremiumVisible;
                }
                field(Selected; Selected)
                {
                }
                field("Substituted Vehicle Reg. No"; "Substituted Vehicle Reg. No")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        RiskIdVisible := FALSE;
        MakeVisible := FALSE;
        ModelVisible := FALSE;
        YOMVisible := FALSE;
        BodyTypeVisible := FALSE;
        carryingCapacitycvisible := FALSE;
        SeatingCapacityVisible := FALSE;
        CubicCapacityVisible := FALSE;
        VehicleUsageVisible := FALSE;
        WindScreenVisible := FALSE;
        SumInsuredVisible := FALSE;
        RadioCassetteVisible := FALSE;
        WindScreenRateVisible := FALSE;
        RadioCassetteRateVisible := FALSE;
        RateTypeVisible := FALSE;
        RatePercentVisible := FALSE;
        DescriptionVisible := FALSE;
        NoOfEmployeesVisible := FALSE;
        CategoryVisible := FALSE;
        EstAnnualEarningsVisible := FALSE;
        OccupationVisible := FALSE;
        LimitOfLiabilityVisible := FALSE;
        PositionVisible := FALSE;
        PerCapitaVisible := FALSE;
        Relationship2AppVisible := FALSE;
        FamilyNameVisible := FALSE;
        FirstNameVisible := FALSE;
        SexVisible := FALSE;
        DOBVisible := FALSE;
        AgeVisible := FALSE;
        DeathVisible := FALSE;
        DeathRate := FALSE;
        PDVisible := FALSE;
        PDRateVisible := FALSE;
        TDVisible := FALSE;
        TDRateVisible := FALSE;
        MEVisible := FALSE;
        MERateVisible := FALSE;
        EmployeeNameVisible := FALSE;
        TVatRiskVisible := FALSE;
        FirstLossSIVisible := FALSE;
        FirstLossRateVisible := FALSE;
        GrossPremiumVisible := FALSE;
        TPOPremiumVisible := FALSE;

        RiskIdVisible := TRUE;
        MakeVisible := TRUE;
        ModelVisible := TRUE;
        YOMVisible := TRUE;
        BodyTypeVisible := TRUE;
        carryingCapacitycvisible := TRUE;
        SeatingCapacityVisible := TRUE;
        CubicCapacityVisible := TRUE;
        VehicleUsageVisible := TRUE;
        WindScreenVisible := TRUE;
        SumInsuredVisible := TRUE;
        RadioCassetteVisible := TRUE;
        WindScreenRateVisible := TRUE;
        RadioCassetteRateVisible := TRUE;
        RateTypeVisible := TRUE;
        RatePercentVisible := TRUE;
        DescriptionVisible := TRUE;
        SumInsuredVisible := TRUE;

        RadioCassetteVisible := TRUE;
        RadioCassetteRateVisible := TRUE;
        WindScreenRateVisible := TRUE;
        GrossPremiumVisible := TRUE;
        TPOPremiumVisible := TRUE;

        IF InsureHeader.GET("Document Type", "Document No.") THEN BEGIN


            IF PolicyType.GET(InsureHeader."Policy Type") THEN BEGIN
                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Vehicle THEN BEGIN

                    //MESSAGE('!!!!!!!!');

                    RiskIdVisible := TRUE;
                    MakeVisible := TRUE;
                    ModelVisible := TRUE;
                    YOMVisible := TRUE;
                    BodyTypeVisible := TRUE;
                    carryingCapacitycvisible := TRUE;
                    SeatingCapacityVisible := TRUE;
                    CubicCapacityVisible := TRUE;
                    VehicleUsageVisible := TRUE;
                    WindScreenVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RadioCassetteVisible := TRUE;
                    WindScreenRateVisible := TRUE;
                    RadioCassetteRateVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    carryingCapacitycvisible := FALSE;
                    RadioCassetteVisible := TRUE;
                    RadioCassetteRateVisible := TRUE;
                    WindScreenRateVisible := TRUE;
                    GrossPremiumVisible := TRUE;
                    TPOPremiumVisible := TRUE;

                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Other THEN BEGIN

                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Workmen THEN BEGIN
                    NoOfEmployeesVisible := TRUE;
                    EstAnnualEarningsVisible := TRUE;
                    OccupationVisible := TRUE;

                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Money THEN BEGIN


                    LimitOfLiabilityVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::"Group Personal" THEN BEGIN
                    EmployeeNameVisible := TRUE;
                    EstAnnualEarningsVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Fidelity THEN BEGIN
                    NoOfEmployeesVisible := TRUE;
                    PositionVisible := TRUE;
                    OccupationVisible := TRUE;
                    PerCapitaVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Medical THEN BEGIN

                    Relationship2AppVisible := TRUE;
                    FamilyNameVisible := TRUE;
                    FirstNameVisible := TRUE;
                    SexVisible := TRUE;
                    DOBVisible := TRUE;
                    AgeVisible := TRUE;
                    OccupationVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;
                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Life THEN BEGIN

                    Relationship2AppVisible := TRUE;
                    FamilyNameVisible := TRUE;
                    FirstNameVisible := TRUE;
                    SexVisible := TRUE;
                    DOBVisible := TRUE;
                    AgeVisible := TRUE;
                    OccupationVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::"Personal Accident" THEN BEGIN

                    DeathVisible := TRUE;
                    DeathRate := TRUE;
                    PDVisible := TRUE;
                    PDRateVisible := TRUE;
                    TDVisible := TRUE;
                    TDRateVisible := TRUE;
                    MEVisible := TRUE;
                    MERateVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::"Employers Liability" THEN BEGIN

                    CategoryVisible := TRUE;
                    EstAnnualEarningsVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;

                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Burglary THEN BEGIN
                    TVatRiskVisible := TRUE;
                    FirstLossSIVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;

                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Bond THEN BEGIN
                    EmployeeNameVisible := TRUE;

                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;

                END;


            END;
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Description Type" := "Description Type"::"Schedule of Insured";
    end;

    trigger OnOpenPage();
    begin

        RiskIdVisible := FALSE;
        MakeVisible := FALSE;
        ModelVisible := FALSE;
        YOMVisible := FALSE;
        BodyTypeVisible := FALSE;
        carryingCapacitycvisible := FALSE;
        SeatingCapacityVisible := FALSE;
        CubicCapacityVisible := FALSE;
        VehicleUsageVisible := FALSE;
        WindScreenVisible := FALSE;
        SumInsuredVisible := FALSE;
        RadioCassetteVisible := FALSE;
        WindScreenRateVisible := FALSE;
        RadioCassetteRateVisible := FALSE;
        RateTypeVisible := FALSE;
        RatePercentVisible := FALSE;
        DescriptionVisible := FALSE;
        NoOfEmployeesVisible := FALSE;
        CategoryVisible := FALSE;
        EstAnnualEarningsVisible := FALSE;
        OccupationVisible := FALSE;
        LimitOfLiabilityVisible := FALSE;
        PositionVisible := FALSE;
        PerCapitaVisible := FALSE;
        Relationship2AppVisible := FALSE;
        FamilyNameVisible := FALSE;
        FirstNameVisible := FALSE;
        SexVisible := FALSE;
        DOBVisible := FALSE;
        AgeVisible := FALSE;
        DeathVisible := FALSE;
        DeathRate := FALSE;
        PDVisible := FALSE;
        PDRateVisible := FALSE;
        TDVisible := FALSE;
        TDRateVisible := FALSE;
        MEVisible := FALSE;
        MERateVisible := FALSE;
        EmployeeNameVisible := FALSE;
        TVatRiskVisible := FALSE;
        FirstLossSIVisible := FALSE;
        FirstLossRateVisible := FALSE;
        GrossPremiumVisible := FALSE;
        TPOPremiumVisible := FALSE;

        RiskIdVisible := TRUE;
        MakeVisible := TRUE;
        ModelVisible := TRUE;
        YOMVisible := TRUE;
        BodyTypeVisible := TRUE;
        carryingCapacitycvisible := TRUE;
        SeatingCapacityVisible := TRUE;
        CubicCapacityVisible := TRUE;
        VehicleUsageVisible := TRUE;
        WindScreenVisible := TRUE;
        SumInsuredVisible := TRUE;
        RadioCassetteVisible := TRUE;
        WindScreenRateVisible := TRUE;
        RadioCassetteRateVisible := TRUE;
        RateTypeVisible := TRUE;
        RatePercentVisible := TRUE;
        DescriptionVisible := TRUE;
        SumInsuredVisible := TRUE;

        RadioCassetteVisible := TRUE;
        RadioCassetteRateVisible := TRUE;
        WindScreenRateVisible := TRUE;
        GrossPremiumVisible := TRUE;
        TPOPremiumVisible := TRUE;

        IF InsureHeader.GET("Document Type", "Document No.") THEN BEGIN


            IF PolicyType.GET(InsureHeader."Policy Type") THEN BEGIN
                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Vehicle THEN BEGIN

                    MESSAGE('!!!!!!!!');

                    RiskIdVisible := TRUE;
                    MakeVisible := TRUE;
                    ModelVisible := TRUE;
                    YOMVisible := TRUE;
                    BodyTypeVisible := TRUE;
                    carryingCapacitycvisible := TRUE;
                    SeatingCapacityVisible := TRUE;
                    CubicCapacityVisible := TRUE;
                    VehicleUsageVisible := TRUE;
                    WindScreenVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RadioCassetteVisible := TRUE;
                    WindScreenRateVisible := TRUE;
                    RadioCassetteRateVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;

                    RadioCassetteVisible := TRUE;
                    RadioCassetteRateVisible := TRUE;
                    WindScreenRateVisible := TRUE;
                    GrossPremiumVisible := TRUE;
                    TPOPremiumVisible := TRUE;

                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Other THEN BEGIN

                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Workmen THEN BEGIN
                    NoOfEmployeesVisible := TRUE;
                    EstAnnualEarningsVisible := TRUE;
                    OccupationVisible := TRUE;

                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Money THEN BEGIN


                    LimitOfLiabilityVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::"Group Personal" THEN BEGIN
                    EmployeeNameVisible := TRUE;
                    EstAnnualEarningsVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Fidelity THEN BEGIN
                    NoOfEmployeesVisible := TRUE;
                    PositionVisible := TRUE;
                    OccupationVisible := TRUE;
                    PerCapitaVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Medical THEN BEGIN

                    Relationship2AppVisible := TRUE;
                    FamilyNameVisible := TRUE;
                    FirstNameVisible := TRUE;
                    SexVisible := TRUE;
                    DOBVisible := TRUE;
                    AgeVisible := TRUE;
                    OccupationVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::"Personal Accident" THEN BEGIN

                    DeathVisible := TRUE;
                    DeathRate := TRUE;
                    PDVisible := TRUE;
                    PDRateVisible := TRUE;
                    TDVisible := TRUE;
                    TDRateVisible := TRUE;
                    MEVisible := TRUE;
                    MERateVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;


                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::"Employers Liability" THEN BEGIN

                    CategoryVisible := TRUE;
                    EstAnnualEarningsVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;

                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Burglary THEN BEGIN
                    TVatRiskVisible := TRUE;
                    FirstLossSIVisible := TRUE;
                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;

                END;

                IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Bond THEN BEGIN
                    EmployeeNameVisible := TRUE;

                    DescriptionVisible := TRUE;
                    SumInsuredVisible := TRUE;
                    RateTypeVisible := TRUE;
                    RatePercentVisible := TRUE;
                    GrossPremiumVisible := TRUE;

                END;


            END;
        END;
    end;

    var
        RiskIdVisible: Boolean;
        MakeVisible: Boolean;
        ModelVisible: Boolean;
        YOMVisible: Boolean;
        BodyTypeVisible: Boolean;
        carryingCapacitycvisible: Boolean;
        SeatingCapacityVisible: Boolean;
        CubicCapacityVisible: Boolean;
        VehicleUsageVisible: Boolean;
        WindScreenVisible: Boolean;
        SumInsuredVisible: Boolean;
        RadioCassetteVisible: Boolean;
        WindScreenRateVisible: Boolean;
        RadioCassetteRateVisible: Boolean;
        RateTypeVisible: Boolean;
        RatePercentVisible: Boolean;
        DescriptionVisible: Boolean;
        NoOfEmployeesVisible: Boolean;
        CategoryVisible: Boolean;
        EstAnnualEarningsVisible: Boolean;
        OccupationVisible: Boolean;
        LimitOfLiabilityVisible: Boolean;
        PositionVisible: Boolean;
        PerCapitaVisible: Boolean;
        Relationship2AppVisible: Boolean;
        FamilyNameVisible: Boolean;
        FirstNameVisible: Boolean;
        SexVisible: Boolean;
        DOBVisible: Boolean;
        AgeVisible: Boolean;
        DeathVisible: Boolean;
        DeathRate: Boolean;
        PDVisible: Boolean;
        PDRateVisible: Boolean;
        TDVisible: Boolean;
        TDRateVisible: Boolean;
        MEVisible: Boolean;
        MERateVisible: Boolean;
        EmployeeNameVisible: Boolean;
        TVatRiskVisible: Boolean;
        FirstLossSIVisible: Boolean;
        FirstLossRateVisible: Boolean;
        GrossPremiumVisible: Boolean;
        TPOPremiumVisible: Boolean;
        InsureHeader: Record "Insure Header";
        PolicyType: Record "Policy Type";
}

