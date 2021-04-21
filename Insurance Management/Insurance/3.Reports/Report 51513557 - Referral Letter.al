report 51513557 "Referral Letter"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Referral Letter.rdl';

    dataset
    {
        dataitem("Claim"; "Claim")
        {
            RequestFilterFields = "Registration No.", "Claim No";
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
            column(AgentBroker_Claim; Claim."Agent/Broker")
            {
            }
            column(InsuredAddress_Claim; Claim."Insured Address")
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
            column(DriversName_Claim; Claim."Driver's Name")
            {
            }
            column(DriversAge_Claim; Claim."Driver's Age")
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
            column(VehicleRegistrationNo_Claim; Claim."Vehicle Registration No.")
            {
            }
            column(AgentBrokerName_Claim; Claim."Agent/Broker Name")
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
            column(ReserveAmount_Claim; Claim."Reserve Amount")
            {
            }
            column(ClassDescription_Claim; Claim."Class Description")
            {
            }
            column(CreatedBy_Claim; Claim."Created By")
            {
            }
            column(AppointedAssessor_Claim; Claim."Appointed Assessor")
            {
            }
            column(VendAddress; VendAddress)
            {
            }
            column(VendPhone; VendPhone)
            {
            }
            column(EmployeeFullName; EmployeeFullName)
            {
            }
            column(EmpTitle; EmpTitle)
            {
            }
            column(VendPostalAddress; VendPostalAddress)
            {
            }
            column(VendName; VendName)
            {
            }
            column(VendCity; VendCity)
            {
            }
            column(VendPhysicalAddress; VendPhysicalAddress)
            {
            }
            column(ClaimantName; ClaimantName)
            {
            }
            column(DrVendName; DrVendName)
            {
            }
            column(DrVendPostalAddress; DrVendPostalAddress)
            {
            }
            column(DrVendPhone; DrVendPhone)
            {
            }
            column(DrVendCity; DrVendCity)
            {
            }
            column(DrVendPhysicalAddress; DrVendPhysicalAddress)
            {
            }
            column(DrVendAddress; DrVendAddress)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.CALCFIELDS(Picture);
                ClaimServiceAppointments.SETRANGE(ClaimServiceAppointments."Claim No.", Claim."Claim No");

                //Doctor
                ClaimServiceAppointments.SETRANGE(ClaimServiceAppointments."Service Provider Type", ClaimServiceAppointments."Service Provider Type"::Assessor);
                IF ClaimServiceAppointments.FINDFIRST THEN BEGIN
                    IF Vend.GET(ClaimServiceAppointments."No.") THEN BEGIN
                        DrVendAddress := Vend.Name + ' ' + Vend."Address 2" + ', ' + 'P.O BOX ' + Vend.Address + '-' + Vend."Post Code" + ', ' + Vend.City;
                        DrVendPostalAddress := 'P.O BOX ' + Vend.Address + '-' + Vend."Post Code";
                        DrVendPhone := Vend."Phone No." + ', ' + Vend."Telex No." + ', ' + Vend."Fax No.";
                        DrVendName := Vend.Name;
                        DrVendCity := Vend.City;
                        DrVendPhysicalAddress := Vend."Address 2";
                    END;
                END;
                ClaimServiceAppointments.RESET;

                //Lawyer
                ClaimServiceAppointments.SETRANGE(ClaimServiceAppointments."Claim No.", Claim."Claim No");
                ClaimServiceAppointments.SETRANGE(ClaimServiceAppointments."Service Provider Type", ClaimServiceAppointments."Service Provider Type"::Lawyer);
                IF ClaimServiceAppointments.FINDFIRST THEN BEGIN
                    IF Vend.GET(ClaimServiceAppointments."No.") THEN BEGIN
                        VendAddress := Vend.Name + ' ' + Vend."Address 2" + ', ' + 'P.O BOX ' + Vend.Address + '-' + Vend."Post Code" + ', ' + Vend.City;
                        VendPostalAddress := 'P.O BOX ' + Vend.Address + '-' + Vend."Post Code";
                        VendPhone := Vend."Phone No." + ', ' + Vend."Telex No." + ', ' + Vend."Fax No.";
                        VendName := Vend.Name;
                        VendCity := Vend.City;
                        VendPhysicalAddress := Vend."Address 2";
                    END;
                END;

                //MESSAGE('%1', USERID);

                UserSetupDetails.SETRANGE(UserSetupDetails."User ID", USERID);
                IF UserSetupDetails.FINDLAST THEN BEGIN
                    IF Emp.GET(UserSetupDetails.Employee) THEN BEGIN
                        EmployeeFullName := Emp.FullName;
                        EmpTitle := Emp."Job Title";
                    END;
                END;

                ClaimInvolvedParties.SETRANGE(ClaimInvolvedParties."Claim No.", Claim."Claim No");
                IF ClaimInvolvedParties.FINDLAST THEN
                    ClaimantName := ClaimInvolvedParties.Surname;
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

    var
        CompInfor: Record 79;
        Vend: Record Vendor;
        ClaimServiceAppointments: Record "Claim Service Appointments";
        VendNo: Code[20];
        VendAddress: Text;
        VendPhone: Text;
        UserSetupDetails: Record "User Setup Details";
        Emp: Record Employee;
        EmpTitle: Text;
        EmployeeFullName: Text;
        VendName: Text;
        VendPostalAddress: Text;
        VendPhysicalAddress: Text;
        VendCity: Text;
        ClaimInvolvedParties: Record "Claim Involved Parties";
        ClaimantName: Text;
        usersetup: Record "User Setup";
        DrVendName: Text;
        DrVendPostalAddress: Text;
        DrVendPhysicalAddress: Text;
        DrVendCity: Text;
        DrVendAddress: Text;
        DrVendPhone: Text;
}

