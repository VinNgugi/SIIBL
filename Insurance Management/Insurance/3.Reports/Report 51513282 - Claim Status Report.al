report 51513282 "Claim Status Report"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Claim Status Report.rdl';

    dataset
    {
        dataitem("Claim"; "Claim")
        {
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
            column(ClaimNo_Claim; Claim."Claim No")
            {
            }
            column(PolicyNo_Claim; Claim."Policy No")
            {
            }
            column(NameofInsured_Claim; Claim."Name of Insured")
            {
            }
            column(RenewalDate_Claim; Claim."Renewal Date")
            {
            }
            column(AgentBroker_Claim; Claim."Agent/Broker")
            {
            }
            column(InsuredAddress_Claim; Claim."Insured Address")
            {
            }
            column(InsuredTelephoneNo_Claim; Claim."Insured Telephone No.")
            {
            }
            column(District_Claim; Claim.District)
            {
            }
            column(Occupation_Claim; Claim.Occupation)
            {
            }
            column(Make_Claim; Claim.Make)
            {
            }
            column(RegistrationNo_Claim; Claim."Registration No.")
            {
            }
            column(YearofManufacture_Claim; Claim."Year of Manufacture")
            {
            }
            column(CubicCapacitycc_Claim; Claim."Cubic Capacity c.c")
            {
            }
            column(PurposeattimeofAccident_Claim; Claim."Purpose at time of Accident")
            {
            }
            column(DriversName_Claim; Claim."Driver's Name")
            {
            }
            column(DriversAge_Claim; Claim."Driver's Age")
            {
            }
            column(DriversAddress_Claim; Claim."Drivers Address")
            {
            }
            column(DriversOccupation_Claim; Claim."Driver's Occupation")
            {
            }
            column(OtherDetails_Claim; Claim."Other Details")
            {
            }
            column(DateofOccurence_Claim; Claim."Date of Occurence")
            {
            }
            column(WhenReported_Claim; Claim."When Reported")
            {
            }
            column(Time_Claim; Claim.Time)
            {
            }
            column(Place_Claim; Claim.Place)
            {
            }
            column(EstCostofRepairs_Claim; Claim."Est. Cost of Repairs")
            {
            }
            column(AmountSettled_Claim; Claim."Amount Settled")
            {
            }
            column(NatureandCauseofAccident_Claim; Claim."Nature and Cause of Accident")
            {
            }
            column(ReportedtoPolice_Claim; Claim."Reported to Police")
            {
            }
            column(DateReported_Claim; Claim."Date Reported")
            {
            }
            column(ReportReferenceNo_Claim; Claim."Report Reference No")
            {
            }
            column(ActionTakenbyPolice_Claim; Claim."Action Taken by Police")
            {
            }
            column(LocationofInspection_Claim; Claim."Location of Inspection")
            {
            }
            column(NameofPoliceStation_Claim; Claim."Name of Police Station")
            {
            }
            column(Detailsofdamage_Claim; Claim."Details of damage")
            {
            }
            column(AppointedAssessor_Claim; Claim."Appointed Assessor")
            {
            }
            column(AnyThirdPartyClaims_Claim; Claim."Any Third Party Claims")
            {
            }
            column(DetailsofThirdPartyClaims_Claim; Claim."Details of Third Party Claims")
            {
            }
            column(Nameofthirdparty_Claim; Claim."Name of third party")
            {
            }
            column(Addressof3rdParty_Claim; Claim."Address of 3rd Party")
            {
            }
            column(CertificateNo_Claim; Claim."Certificate No.")
            {
            }
            column(V3rdPartyPolicyNo_Claim; Claim."3rd Party Policy No.")
            {
            }
            column(DriverName_Claim; Claim."Driver Name")
            {
            }
            column(InsuranceCompany_Claim; Claim."Insurance Company")
            {
            }
            column(VehicleRegistrationNo_Claim; Claim."Vehicle Registration No.")
            {
            }
            column(NoSeries_Claim; Claim."No. Series")
            {
            }
            column(InsurerPolicyNo_Claim; Claim."Insurer Policy No")
            {
            }
            column(AgentBrokerName_Claim; Claim."Agent/Broker Name")
            {
            }
            column(LineNo_Claim; Claim.RiskID)
            {
            }
            column(Class_Claim; Claim.Class)
            {
            }
            column(PlotNo_Claim; Claim."Plot No.")
            {
            }
            column(Street_Claim; Claim.Street)
            {
            }
            column(MethodofEntrytoPremises_Claim; Claim."Method of Entry to Premises")
            {
            }
            column(WasAlarmFittedWorking_Claim; Claim."Was Alarm Fitted Working")
            {
            }
            column(IfNotReasons_Claim; Claim."If Not Reasons")
            {
            }
            column(AreGuardsEmployed_Claim; Claim."Are Guards Employed")
            {
            }
            column(NameofGuardFirm_Claim; Claim."Name of Guard Firm")
            {
            }
            column(ClaimType_Claim; Claim."Claim Type")
            {
            }
            column(CustomerNo_Claim; Claim."Customer No.")
            {
            }
            column(Garage_Claim; Claim.Garage)
            {
            }
            column(NameofGarage_Claim; Claim."Name of Garage")
            {
            }
            column(DatetakentoGarage_Claim; Claim."Date taken to Garage")
            {
            }
            column(AssessorsNotificationDate_Claim; Claim."Assessors Notification Date")
            {
            }
            column(Thirdpartytype_Claim; Claim."Third party type")
            {
            }
            column(DateofNotification_Claim; Claim."Date of Notification")
            {
            }
            column(MedicalExpenses_Claim; Claim."Medical Expenses")
            {
            }
            column(Particulars_Claim; Claim.Particulars)
            {
            }
            column(InsurersClaimNo_Claim; Claim."Insurer's Claim No.")
            {
            }
            column(CurrentStatus_Claim; Claim."Current Status")
            {
            }
            column(ClaimAmount_Claim; Claim."Claim Amount")
            {
            }
            column(PolicyType_Claim; Claim."Policy Type")
            {
            }
            column(PoliceComments_Claim; Claim."Police Comments")
            {
            }
            column(Country_Claim; Claim.Country)
            {
            }
            column(Death_Claim; Claim.Death)
            {
            }
            column(ReserveAmount_Claim; Claim."Reserve Amount")
            {
            }
            column(Excess_Claim; Claim.Excess)
            {
            }
            column(ClassDescription_Claim; Claim."Class Description")
            {
            }
            column(OutstandingClaimAmount_Claim; Claim."Outstanding Claim Amount")
            {
            }
            column(Insured_Claim; Claim.Insured)
            {
            }
            column(ClaimStatus_Claim; Claim."Claim Status")
            {
            }
            column(PaymentStatus_Claim; Claim."Payment Status")
            {
            }
            column(MemorandumAddress_Claim; Claim."Memorandum Address")
            {
            }
            column(Name_Claim; Claim.Name)
            {
            }
            column(IDNumber_Claim; Claim."ID Number")
            {
            }
            column(EmploymetNo_Claim; Claim."Employment No")
            {
            }
            column(PatientName_Claim; Claim."Patient Name")
            {
            }
            column(MembershipNo_Claim; Claim."Membership No")
            {
            }
            column(DateofBirth_Claim; Claim."Date of Birth")
            {
            }
            column(Sex_Claim; Claim.Sex)
            {
            }
            column(Relationship_Claim; Claim.Relationship)
            {
            }
            column(Deductible_Claim; Claim.Deductible)
            {
            }
            column(CoInsurers_Claim; Claim."Co-Insurers")
            {
            }
            column(Classcode_Claim; Claim.MainClasscode)
            {
            }
            column(CoInsurerName_Claim; Claim."Co- Insurer Name")
            {
            }
            column(CustomerPostingGroup_Claim; Claim."Closure Reason")
            {
            }
            column(GrossAmount_Claim; Claim."Premium Balance")
            {
            }
            column(ExcessAmount_Claim; Claim."Excess Amount")
            {
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

    trigger OnPreReport();
    begin
        CompInfor.GET;
        CompInfor.CALCFIELDS(Picture);
    end;

    var
        CompInfor: Record 79;
}

