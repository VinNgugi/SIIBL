report 51513336 "Insure Quotation"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Insure Quotation.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            RequestFilterFields = "Document Type", "No.";
            column(No_InsureHeader; "Insure Header"."No.")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            dataitem("Insure Lines"; "Insure Lines")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.")
                                    WHERE("Description Type" = CONST(Interest));
                column(RiskID_InsureLines; "Insure Lines"."Risk ID")
                {
                }
                column(FamilyName_InsureLines; "Insure Lines"."Family Name")
                {
                }
                column(FirstNames_InsureLines; "Insure Lines"."First Name(s)")
                {
                }
                column(Title_InsureLines; "Insure Lines".Title)
                {
                }
                column(Sex_InsureLines; "Insure Lines".Sex)
                {
                }
                column(DateofBirth_InsureLines; "Insure Lines"."Date of Birth")
                {
                }
                column(RelationshiptoApplicant_InsureLines; "Insure Lines"."Relationship to Applicant")
                {
                }
                column(Occupation_InsureLines; "Insure Lines".Occupation)
                {
                }
                column(Age_InsureLines; "Insure Lines".Age)
                {
                }
                column(BMI_InsureLines; "Insure Lines".BMI)
                {
                }
                column(PremiumAmount_InsureLines; "Insure Lines"."Premium Amount")
                {
                }
                column(PolicyNo_InsureLines; "Insure Lines"."Policy No")
                {
                }
                column(SumInsured_InsureLines; "Insure Lines"."Sum Insured")
                {
                }
                column(Rateage_InsureLines; "Insure Lines"."Rate %age")
                {
                }
                column(RegistrationNo_InsureLines; "Insure Lines"."Registration No.")
                {
                }
                column(Make_InsureLines; "Insure Lines".Make)
                {
                }
                column(YearofManufacture_InsureLines; "Insure Lines"."Year of Manufacture")
                {
                }
                column(TypeofBody_InsureLines; "Insure Lines"."Type of Body")
                {
                }
                column(CubicCapacitycc_InsureLines; "Insure Lines"."Cubic Capacity (cc)")
                {
                }
                column(SeatingCapacity_InsureLines; "Insure Lines"."Seating Capacity")
                {
                }
                column(CarryingCapacity_InsureLines; "Insure Lines"."Carrying Capacity")
                {
                }
                column(NoofEmployees_InsureLines; "Insure Lines"."No. of Employees")
                {
                }
                column(DescriptionType_InsureLines; "Insure Lines"."Description Type")
                {
                }
                column(EstimatedAnnualEarnings_InsureLines; "Insure Lines"."Estimated Annual Earnings")
                {
                }
                column(SerialNo_InsureLines; "Insure Lines"."Serial No")
                {
                }
                column(LimitofLiability_InsureLines; "Insure Lines"."Limit of Liability")
                {
                }
                column(Position_InsureLines; "Insure Lines".Position)
                {
                }
                column(Category_InsureLines; "Insure Lines".Category)
                {
                }
                column(EmployeeName_InsureLines; "Insure Lines"."Employee Name")
                {
                }
                column(Windscreen_InsureLines; "Insure Lines".Windscreen)
                {
                }
                column(RadioCassette_InsureLines; "Insure Lines"."Radio Cassette")
                {
                }
                column(WindscreenRate_InsureLines; "Insure Lines"."Windscreen % Rate")
                {
                }
                column(RadioCassetteRate_InsureLines; "Insure Lines"."Radio Cassette % Rate")
                {
                }
                column(EngineNo_InsureLines; "Insure Lines"."Engine No.")
                {
                }
                column(ChassisNo_InsureLines; "Insure Lines"."Chassis No.")
                {
                }
                column(Death_InsureLines; "Insure Lines".Death)
                {
                }
                column(PermanentDisability_InsureLines; "Insure Lines"."Permanent Disability")
                {
                }
                column(TemporaryDisability_InsureLines; "Insure Lines"."Temporary Disability")
                {
                }
                column(Medicalexpenses_InsureLines; "Insure Lines"."Medical expenses")
                {
                }
                column(DeathRate_InsureLines; "Insure Lines"."Death Rate")
                {
                }
                column(PDRate_InsureLines; "Insure Lines"."P.D Rate")
                {
                }
                column(TDRate_InsureLines; "Insure Lines"."T.D Rate")
                {
                }
                column(MERate_InsureLines; "Insure Lines"."M.E Rate")
                {
                }
                column(FirstLossSumInsured_InsureLines; "Insure Lines"."First Loss Sum Insured")
                {
                }
                column(TotalValueatRisk_InsureLines; "Insure Lines"."Total Value at Risk")
                {
                }
                column(FirstLossRate_InsureLines; "Insure Lines"."First Loss Rate")
                {
                }
                column(TVARate_InsureLines; "Insure Lines"."TVA Rate")
                {
                }
                column(PerCapita_InsureLines; "Insure Lines"."Per Capita")
                {
                }
                column(RateType_InsureLines; "Insure Lines"."Rate Type")
                {
                }
                column(PLL_InsureLines; "Insure Lines".PLL)
                {
                }
                column(Description_InsureLines; "Insure Lines".Description)
                {
                }
                column(ActualValue_InsureLines; "Insure Lines"."Actual Value")
                {
                }
                column(DescriptionType; "Insure Lines"."Description Type")
                {
                }
            }
            dataitem(Cover; "Insure Lines")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.")
                                    WHERE("Description Type" = CONST(Cover));
                column(CoverLines; Cover.Description)
                {
                }
            }
            dataitem(Geographical; "Insure Lines")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Description Type" = CONST(Geographic));
                column(GeographicalDesc; Geographical.Description)
                {
                }
            }
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
    }
}

