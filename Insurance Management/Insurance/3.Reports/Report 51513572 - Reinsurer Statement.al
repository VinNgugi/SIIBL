report 51513572 "Reinsurer Statement"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Reinsurer Statement.rdl';

    dataset
    {
        dataitem(Treaty; Treaty)
        {
            DataItemTableView = SORTING("Treaty Code", "Addendum Code");
            RequestFilterFields = Broker, "Treaty Code";
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
            column(TreatyCode_Treaty; Treaty."Treaty Code")
            {
            }
            column(AddendumCode_Treaty; Treaty."Addendum Code")
            {
            }
            column(Treatydescription_Treaty; Treaty."Treaty description")
            {
            }
            column(Broker_Treaty; Treaty.Broker)
            {
            }
            column(BrokerName_Treaty; Treaty."Broker Name")
            {
            }
            column(BrokerCommision_Treaty; Treaty."Broker Commision")
            {
            }
            column(QuotashareRetention_Treaty; Treaty."Quota share Retention")
            {
            }
            column(SurplusRetention_Treaty; Treaty."Surplus Retention")
            {
            }
            column(Insurerquotapercentage_Treaty; Treaty."Insurer quota percentage")
            {
            }
            column(MinimumPremiumDepositMDP_Treaty; Treaty."Minimum Premium Deposit(MDP)")
            {
            }
            column(PremiumRate_Treaty; Treaty."Premium Rate")
            {
            }
            column(TreatyType_Treaty; Treaty."Treaty Type")
            {
            }
            column(ActualPremium_Treatys; Treaty."Actual Premium")
            {
            }
            column(ClassofInsurance_Treaty; Treaty."Class of Insurance")
            {
            }
            column(ApportionmentType_Treaty; Treaty."Apportionment Type")
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(PolicyDescription; PolicyDescription)
            {
            }
            column(MdpremiumDue; MdpremiumDue)
            {
            }
            column(MdpPremium; MdpPremium)
            {
            }
            column(InstallmentDueDate; InstallmentDueDate)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(Picture);

                IF PolicyType.GET(Treaty."Class of Insurance") THEN
                    PolicyDescription := PolicyType.Description;
                MdpSchedule.RESET;
                MdpSchedule.SETRANGE("Treaty Code", Treaty."Treaty Code");
                MdpSchedule.SETRANGE("Treaty Addendum", Treaty."Addendum Code");
                IF MdpSchedule.FINDFIRST THEN BEGIN
                    REPEAT
                        IF DATE2DMY(MdpSchedule."Instalment Due Date", 3) = DATE2DMY(WORKDATE, 3) THEN BEGIN
                            //MESSAGE('%1',MdpSchedule."Premium Amount");
                            IF MdpSchedule.Paid THEN BEGIN
                                MdpremiumDue := MdpremiumDue + MdpSchedule."Premium Amount";
                                MESSAGE('%1', MdpremiumDue);
                            END
                            ELSE
                                IF MdpSchedule.Paid = FALSE
                           THEN BEGIN
                                    MdpPremium := MdpPremium + MdpSchedule."Premium Amount";
                                    InstallmentDueDate := MdpSchedule."Instalment Due Date";

                                END;
                        END;
                    UNTIL MdpSchedule.NEXT = 0;
                END;

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
                    field(StartDate; StartDate)
                    {
                        Caption = 'Starting Date';
                        NotBlank = true;
                    }
                    field(EbdDate; EndDate)
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
            StartDate := WORKDATE;
            EndDate := WORKDATE;
        end;
    }

    labels
    {
    }

    var
        CompInfor: Record 79;
        CoverLayer: Record 51513439;
        CoverLayerDescription: Text;
        PolicyType: Record "Policy Type";
        PolicyDescription: Text;
        StartDate: Date;
        EndDate: Date;
        BlankMaxDateErr: Label 'Ending Date must have a value.';
        BlankStartDateErr: Label 'Start Date must have a value.';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';
        MdpSchedule: Record "MDP Schedule";
        MdpPremium: Decimal;
        MdpremiumDue: Decimal;
        InstallmentDueDate: Date;
        Period: Integer;

    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date);
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        //PeriodLength := NewPeriodLength;
    end;

    local procedure VerifyDates();
    begin
        IF StartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF EndDate = 0D THEN
            ERROR(BlankEndDateErr);
        IF StartDate > EndDate THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;
}

