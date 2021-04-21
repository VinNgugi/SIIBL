report 51513277 "Insure Quotations"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Insure Quotations.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            RequestFilterFields = "No.";
            column(Picture; CompInfor.Picture)
            {
            }
            column(CName; CompInfor.Name)
            {
            }
            column(CAddress; CompInfor.Address)
            {
            }
            column(CAdd2; CompInfor."Address 2")
            {
            }
            column(CCity; CompInfor.City)
            {
            }
            column(CPhoneNo; CompInfor."Phone No.")
            {
            }
            column(CEmail; CompInfor."E-Mail")
            {
            }
            column(CWeb; CompInfor."Home Page")
            {
            }
            column(CFaxno; CompInfor."Fax No.")
            {
            }
            column(InsuredAddress; Address1 + Address2 + City)
            {
            }
            column(No_InsureHeader; "Insure Header"."No.")
            {
            }
            column(InsuredNo_InsureHeader; "Insure Header"."Insured No.")
            {
            }
            column(CoverPeriod_InsureHeader; "Insure Header"."Cover Period")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(CoverType_InsureHeader; "Insure Header"."Cover Type")
            {
            }
            column(CoverTypeDescription_InsureHeader; "Insure Header"."Cover Type Description")
            {
            }
            column(PolicyClass_InsureHeader; "Insure Header"."Policy Class")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            column(TotalSumInsured_InsureHeader; "Insure Header"."Total Sum Insured")
            {
            }
            column(TotalPremiumAmount_InsureHeader; "Insure Header"."Total Premium Amount")
            {
            }
            column(TotalDiscountAmount_InsureHeader; "Insure Header"."Total  Discount Amount")
            {
            }
            column(TotalCommissionDue_InsureHeader; "Insure Header"."Total Commission Due")
            {
            }
            column(TotalCommissionOwed_InsureHeader; "Insure Header"."Total Commission Owed")
            {
            }
            column(TotalTrainingLevy_InsureHeader; "Insure Header"."Total Training Levy")
            {
            }
            column(TotalStampDuty_InsureHeader; "Insure Header"."Total Stamp Duty")
            {
            }
            column(TotalTax_InsureHeader; "Insure Header"."Total Tax")
            {
            }
            column(FamilyName_InsureHeader; "Insure Header"."Family Name")
            {
            }
            column(FirstNamess_InsureHeader; "Insure Header"."First Names(s)")
            {
            }
            column(Title_InsureHeader; "Insure Header".Title)
            {
            }
            dataitem("Insure Lines"; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(SumInsured_InsureLines; "Insure Lines"."Sum Insured")
                {
                }
                column(NetPremium_InsureLines; "Insure Lines"."Net Premium")
                {
                }
                column(StartDate_InsureLines; "Insure Lines"."Start Date")
                {
                }
                column(EndDate_InsureLines; "Insure Lines"."End Date")
                {
                }
                column(YearofManufacture_InsureLines; "Insure Lines"."Year of Manufacture")
                {
                }
                column(RiskID_InsureLines; "Insure Lines"."Risk ID")
                {
                }
                column(VehicleTonnage_InsureLines; "Insure Lines"."Vehicle Tonnage")
                {
                }
                column(VehicleLicenseClass_InsureLines; "Insure Lines"."Vehicle License Class")
                {
                }
                column(Model_InsureLines; "Insure Lines".Model)
                {
                }
                column(VehicleUsage_InsureLines; "Insure Lines"."Vehicle Usage")
                {
                }
                column(PremiumAmount_InsureLines; "Insure Lines"."Premium Amount")
                {
                }
                column(CoverDescription_InsureLines; "Insure Lines"."Cover Description")
                {
                }
                column(RegistrationNo_InsureLines; "Insure Lines"."Registration No.")
                {
                }
                column(Make_InsureLines; "Insure Lines".Make)
                {
                }
                column(RadioCassette_InsureLines; "Insure Lines"."Radio Cassette")
                {
                }
                column(Windscreen_InsureLines; "Insure Lines".Windscreen)
                {
                }
                column(Rateage_InsureLines; "Insure Lines"."Rate %age")
                {
                }
                column(RateType_InsureLines; "Insure Lines"."Rate Type")
                {
                }
                column(CoverType_InsureLines; "Insure Lines"."Cover Type")
                {
                }
                column(MemberCode_InsureLines; "Insure Lines".Colour)
                {
                }
                column(AreaofCover_InsureLines; "Insure Lines"."Area of Cover")
                {
                }
                column(PolicyType_InsureLines; "Insure Lines"."Policy Type")
                {
                }
                column(LimitofLiability_InsureLines; "Insure Lines"."Limit of Liability")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                IF Insured.GET("Insure Header"."Insured No.") THEN
                    Address1 := Insured.Address;
                Address2 := Insured."Address 2";
                City := Insured.City;
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
    }

    trigger OnPreReport();
    begin
        CompInfor.GET;
        CompInfor.CALCFIELDS(Picture);
    end;

    var
        CompInfor: Record 79;
        "Area": Record "Area of coverage";
        Excess: Record "Policy Excess";
        Insured: Record Vendor;
        Address1: Text;
        Address2: Text;
        City: Text;
}

