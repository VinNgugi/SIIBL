report 51513558 "Authority Letter"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Authority Letter.rdl';

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

            trigger OnPreDataItem();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(Picture);
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
}

