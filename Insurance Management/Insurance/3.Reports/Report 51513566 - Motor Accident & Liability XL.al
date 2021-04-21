report 51513566 "Motor Accident & Liability XL"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Motor Accident & Liability XL.rdl';

    dataset
    {
        dataitem(Treaty; Treaty)
        {
            DataItemTableView = SORTING("Treaty Code", "Addendum Code");
            RequestFilterFields = "Treaty Code", "Addendum Code";
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
            column(PolicyDescription; PolicyDescription)
            {
            }
            column(GrossNetPremium; GrossNetPremium)
            {
            }
            dataitem("XOL Layers"; "XOL Layers")
            {
                DataItemLink = "Treaty Code" = FIELD("Treaty Code"),
                               "Addendum Code" = FIELD("Addendum Code");
                column(Layer_XOLLayers; "XOL Layers".Layer)
                {
                }
                column(Cover_XOLLayers; "XOL Layers".Cover)
                {
                }
                column(Deductible_XOLLayers; "XOL Layers".Deductible)
                {
                }
                column(TreatyCode_XOLLayers; "XOL Layers"."Treaty Code")
                {
                }
                column(Reinstatement_XOLLayers; "XOL Layers".Reinstatement)
                {
                }
                column(MinRate_XOLLayers; "XOL Layers"."Min. Rate")
                {
                }
                column(MaxRate_XOLLayers; "XOL Layers"."Max. Rate")
                {
                }
                column(MinimumDepositPremium_XOLLayers; "XOL Layers"."Minimum Deposit Premium")
                {
                }
                column(Earnings_XOLLayers; "XOL Layers".Earnings)
                {
                }
                column(ROL_XOLLayerss; "XOL Layers".ROL)
                {
                }
                column(GNPI_XOLLayers; "XOL Layers".GNPI)
                {
                }
                column(ClaimChargeable_XOLLayers; "XOL Layers"."Claim Chargeable")
                {
                }
                column(ReinstatementPremium_XOLLayers; "XOL Layers"."Reinstatement Premium")
                {
                }
                column(DepositPremiumPaid_XOLLayers; "XOL Layers"."Deposit Premium Paid")
                {
                }
                column(AccruedMonthlyPremium_XOLLayers; "XOL Layers"."Accrued Monthly Premium")
                {
                }
                column(TotalGrossPremiumIncome_XOLLayers; "XOL Layers"."Total Gross Premium Income")
                {
                }
                column(PremiumCededProportional_XOLLayers; "XOL Layers"."Premium Ceded Proportional")
                {
                }
                column(AppliedAdjustmentMethod_XOLLayers; "XOL Layers"."Applied Adjustment Method")
                {
                }
                column(AppliedAdjustmentRate_XOLLayers; "XOL Layers"."Applied Adjustment Rate")
                {
                }
                column(ActualAnnualPremium_XOLLayers; "XOL Layers"."Actual Annual Premium")
                {
                }
                column(PremiumCalculationMethod_XOLLayers; "XOL Layers"."Premium Calculation Method")
                {
                }
                column(ReinstatementPremiumMethod_XOLLayers; "XOL Layers"."Reinstatement Premium Method")
                {
                }
                column(XLPaidLosses_XOLLayers; "XOL Layers"."XL Paid Losses")
                {
                }
                column(XLOutstandingClaims_XOLLayers; "XOL Layers"."XL Outstanding Claims")
                {
                }
                column(CededPremium_XOLLayers; "XOL Layers"."Ceded Premium")
                {
                }
                column(CoverLayerDescription; CoverLayerDescription)
                {
                }
                column(MonthlyDepPremiumXol; MonthlyDepPremiumXol)
                {
                }
                column(GrossNetPremiumIncome; GrossNetPremiumIncome)
                {
                }
                column(AdjustmentPremiumDuePerMonth; AdjustmentPremiumDuePerMonth)
                {
                }
                column(TotalGross; TotalGross)
                {
                }
                column(ActualAnnualPremium; ActualAnnualPremium)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF CoverLayer.GET(Layer) THEN
                        "XOL Layers".SETRANGE("XOL Layers"."Date Filter", PeriodStartDate, PeriodEndDate);
                    "XOL Layers".CALCFIELDS("XOL Layers".GNPI, "XOL Layers"."Deposit Premium Paid", "XOL Layers"."Total Gross Premium Income", "XOL Layers"."Ceded Premium",
                    "XOL Layers"."XL Paid Losses", "XOL Layers"."XL Outstanding Claims");
                    CoverLayerDescription := CoverLayer.Description;
                    //MESSAGE('%1',"XOL Layers"."Deposit Premium Paid");
                    //"XOL Layers".CALCFIELDS("XOL Layers"."Minimum Deposit Premium");
                    MonthlyDepPremiumXol := 0.0;
                    GrossNetPremiumIncome := 0.0;
                    AdjustmentPremiumDuePerMonth := 0.0;
                    MonthlyDepPremiumXol := "XOL Layers"."Minimum Deposit Premium" * 1 / 12;
                    GrossNetPremiumIncome := "XOL Layers"."Total Gross Premium Income" - "XOL Layers"."Premium Ceded Proportional";

                    AdjustmentPremiumDuePerMonth := "XOL Layers"."Actual Annual Premium" - MonthlyDepPremiumXol;
                    DimValue.RESET;
                    DimValue.SETRANGE(DimValue."Global Dimension No.", 3);
                    DimValue.SETRANGE(DimValue."Date Filter", PeriodStartDate, PeriodEndDate);
                    ActualAnnualPremium := 0;
                    TotalActualAnnualPremium := 0;
                    TotalGross := 0;
                    IF DimValue.FINDFIRST THEN
                        REPEAT
                            DimValue.CALCFIELDS("Net Premium");
                            IF DimValue."Net Premium" <> 0 THEN BEGIN
                                TotalGross := TotalGross + DimValue."Net Premium";
                                ActualAnnualPremium := TotalGross * "XOL Layers"."Applied Adjustment Rate" / 100;
                                TotalActualAnnualPremium := TotalActualAnnualPremium + ActualAnnualPremium;
                            END
                        UNTIL DimValue.NEXT = 0;
                    //MESSAGE('%1%2',TotalGross,ActualAnnualPremium)
                    AdjustmentPremiumDuePerMonth := ActualAnnualPremium - MonthlyDepPremiumXol;
                end;

                trigger OnPreDataItem();
                begin
                    "XOL Layers".SETRANGE("XOL Layers"."Period Filter", PeriodStartDate, PeriodEndDate);
                end;
            }
            dataitem("Dimension Value"; "Dimension Value")
            {
                DataItemTableView = WHERE("Dimension Code" = CONST('CLASS'));
                column(Name_DimensionValue; "Dimension Value".Name)
                {
                }
                column(GrossPremium_DimensionValue; "Dimension Value"."Gross Premium")
                {
                }
                column(NetPremium_DimensionValue; "Dimension Value"."Net Premium")
                {
                }
                column(XlossAdjustmentPremium; XlossAdjustmentPremium)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    "Dimension Value".SETRANGE("Dimension Value"."Date Filter", PeriodStartDate, PeriodEndDate);
                    "Dimension Value".CALCFIELDS("Dimension Value"."Gross Premium", "Dimension Value"."Net Premium");
                    /*
                    "Dimension Value".SETRANGE("Dimension Value"."Global Dimension No.",3);
                    IF "Dimension Value".FINDFIRST THEN
                      BEGIN
                        IF "Dimension Value"."Net Premium"<>0 THEN
                          XlossAdjustmentPremium:="Dimension Value"."Net Premium"/TotalGross*TotalActualAnnualPremium;
                        END;
                    */
                    DimValue.RESET;
                    DimValue.SETRANGE(DimValue."Global Dimension No.", 3);
                    DimValue.SETRANGE(DimValue."Date Filter", PeriodStartDate, PeriodEndDate);
                    ActualAnnualPremium := 0;
                    TotalActualAnnualPremium := 0;
                    TotalGross := 0;
                    IF DimValue.FINDFIRST THEN
                        REPEAT
                            DimValue.CALCFIELDS("Net Premium");
                            IF DimValue."Net Premium" <> 0 THEN BEGIN
                                TotalGross := TotalGross + DimValue."Net Premium";
                                ActualAnnualPremium := TotalGross * "XOL Layers"."Applied Adjustment Rate" / 100;
                                TotalActualAnnualPremium := TotalActualAnnualPremium + ActualAnnualPremium;
                            END
                        UNTIL DimValue.NEXT = 0;
                    //MESSAGE('%1',"Dimension Value"."Net Premium");
                    XlossAdjustmentPremium := "Dimension Value"."Net Premium" / TotalGross * TotalActualAnnualPremium;

                end;

                trigger OnPreDataItem();
                begin
                    //
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(Picture);
                /*
                IF PolicyType.GET(Treaty."Class of Insurance") THEN
                  PolicyDescription:=PolicyType.Description;
                
                DimValue.RESET;
                DimValue.SETRANGE(DimValue."Date Filter", PeriodStartDate, PeriodEndDate);
                DimValue.SETRANGE(DimValue."Dimension Code", 'CLASS');
                IF DimValue.FINDFIRST THEN
                  REPEAT
                   PolicyDescription:='';
                   GrossNetPremium:=0;
                    DimValue.CALCFIELDS(DimValue."Net Premium");
                  IF DimValue."Net Premium"<>0 THEN BEGIN
                    PolicyDescription:=DimValue.Name;
                    GrossNetPremium:=DimValue."Net Premium";
                    //MESSAGE('%1%2',PolicyDescription, DimValue."Net Premium");
                
                    END;
                      UNTIL DimValue.NEXT=0;
                */

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
                        Caption = 'Date';
                    }
                    field("Ending Date"; PeriodEndDate)
                    {
                        Caption = 'End Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            PeriodStartDate := WORKDATE;
            PeriodEndDate := WORKDATE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        /*
        BeginDate:="XOL Layers".GETRANGEMIN("XOL Layers"."Period Filter");
        EndDate:=CALCDATE('1M',BeginDate)-1;
        */

    end;

    var
        CompInfor: Record 79;
        CoverLayer: Record 51513439;
        CoverLayerDescription: Text;
        PolicyType: Record "Policy Type";
        PolicyDescription: Text;
        BeginDate: Date;
        EndDate: Date;
        MonthlyDepPremiumXol: Decimal;
        GrossNetPremiumIncome: Decimal;
        AdjustmentPremiumDuePerMonth: Decimal;
        DimValue: Record "Dimension Value";
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Date value is a future date';
        GrossNetPremium: Decimal;
        ActualAnnualPremium: Decimal;
        TotalGross: Decimal;
        XlossAdjustmentPremium: Decimal;
        TotalActualAnnualPremium: Decimal;

    procedure InitializeRequest(StartDate: Date; EndDate: Date);
    begin
        PeriodStartDate := StartDate;
        PeriodEndDate := EndDate;
    end;

    local procedure VerifyDates();
    begin
        IF PeriodStartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF PeriodStartDate > WORKDATE THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;
}

