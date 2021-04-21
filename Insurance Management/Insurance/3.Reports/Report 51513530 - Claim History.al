report 51513530 "Claim History"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Claim History.rdl';

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
            column(RegistrationNo_Claim; Claim."Registration No.")
            {
            }
            column(DateofOccurence_Claim; Claim."Date of Occurence")
            {
            }
            column(WhenReported_Claim; Claim."When Reported")
            {
            }
            column(AmountSettled_Claim; Claim."Amount Settled")
            {
            }
            column(DateReported_Claim; Claim."Date Reported")
            {
            }
            column(AgentBrokerName_ClaimS; Claim."Agent/Broker Name")
            {
            }
            column(CreatedBy_Claim; Claim."Created By")
            {
            }
            column(NameofGarage_Claim; Claim."Name of Garage")
            {
            }
            column(ReserveAmount_Claim; Claim."Reserve Amount")
            {
            }
            column(Excess_Claim; Claim.Excess)
            {
            }
            column(OutstandingClaimAmount_Claim; Claim."Outstanding Claim Amount")
            {
            }
            column(ClaimStatus_Claim; Claim."Claim Status")
            {
            }
            column(ExcessAmount_Claim; Claim."Excess Amount")
            {
            }
            column(Status_Claim; Claim.Status)
            {
            }
            column(CauseDescription_Claim; Claim."Cause Description")
            {
            }
            column(LossTypeDescription_Claim; Claim."Loss Type Description")
            {
            }
            column(CreationDateTime_Claim; Claim."Creation DateTime")
            {
            }
            column(ToDate; ToDate)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(AssignedUser_Claim; Claim."Assigned User")
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEndDate; PeriodEndDate)
            {
            }
            column(ServiceProviderName; ServiceProviderName)
            {
            }
            column(EmployeeFullName; EmployeeFullName)
            {
            }
            dataitem("Claim Service Appointments"; "Claim Service Appointments")
            {
                DataItemLink = "Claim No." = FIELD("Claim No");
                column(AppointedBy_ClaimServiceAppointments; "Claim Service Appointments"."Appointed By")
                {
                }
                column(ClaimNo_ClaimServiceAppointments; "Claim Service Appointments"."Claim No.")
                {
                }
                column(ServiceProviderType_ClaimServiceAppointments; "Claim Service Appointments"."Service Provider Type")
                {
                }
                column(Sourcingtype_ClaimServiceAppointments; "Claim Service Appointments"."Sourcing type")
                {
                }
                column(No_ClaimServiceAppointments; "Claim Service Appointments"."No.")
                {
                }
                column(ClaimantID_ClaimServiceAppointments; "Claim Service Appointments"."Claimant ID")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.CALCFIELDS(CompInfor.Picture);

                InsureHeader.SETRANGE(InsureHeader."Document Type", InsureHeader."Document Type"::Policy);
                InsureHeader.SETRANGE(InsureHeader."No.", Claim."Policy No");
                IF InsureHeader.FINDFIRST THEN BEGIN
                    ToDate := InsureHeader."To Date";
                    FromDate := InsureHeader."From Date";
                END;
                AppointedServiceProvider.SETRANGE(AppointedServiceProvider."Claim No.", Claim."Claim No");
                IF AppointedServiceProvider.FINDFIRST THEN
                    ServiceProviderName := AppointedServiceProvider."Service Provider Type";
                //calc fields flow fields

                Claim.CALCFIELDS(Claim."Excess Amount");
                Claim.CALCFIELDS(Claim."Reserve Amount");
                Claim.CALCFIELDS(Claim."Amount Settled");
                //Registered By Details
                EmployeeFullName := '';
                EmpTitle := '';
                UserSetupDetails.SETRANGE(UserSetupDetails."User ID", Claim."Created By");
                IF UserSetupDetails.FINDLAST THEN BEGIN
                    IF Emp.GET(UserSetupDetails.Employee) THEN BEGIN
                        EmployeeFullName := Emp.FullName;
                        EmpTitle := Emp."Job Title";
                    END;
                END;

            end;

            trigger OnPreDataItem();
            begin
                Claim.SETRANGE(Claim."Creation DateTime", PeriodStartDate, PeriodEndDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Starting Date"; PeriodStartDate)
                    {
                        Caption = 'Starting Date';
                    }
                    field("Ending Date"; PeriodEndDate)
                    {
                        Caption = 'Ending Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            PeriodStartDate := CURRENTDATETIME;
            PeriodEndDate := CURRENTDATETIME;
        end;
    }

    labels
    {
    }

    var
        CompInfor: Record 79;
        InsureHeader: Record "Insure Header";
        ToDate: Date;
        FromDate: Date;
        BranchCode: Code[30];
        DimValue: Record "Dimension Value";
        BranchName: Text;
        AppointedServiceProvider: Record "Claim Service Appointments";
        ServiceProviderName: Option;
        PeriodStartDate: DateTime;
        PeriodEndDate: DateTime;
        BlankStartDateErr: Label 'Start Date must have a value.';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';
        CreationDate: DateTime;
        UserSetupDetails: Record "User Setup Details";
        Emp: Record Employee;
        EmpTitle: Text;
        EmployeeFullName: Text;

    procedure InitializeRequest(StartDate: DateTime; EndDate: DateTime);
    begin
        PeriodStartDate := StartDate;
        PeriodEndDate := EndDate;
    end;

    local procedure VerifyDates();
    begin
        IF DT2DATE(PeriodStartDate) = 0D THEN
            ERROR(BlankStartDateErr);
        IF DT2DATE(PeriodEndDate) = 0D THEN
            ERROR(BlankEndDateErr);
        IF PeriodStartDate > PeriodEndDate THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;
}

