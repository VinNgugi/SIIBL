report 51513554 "IRA Gross premium"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/IRA Gross premium.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                ORDER(Ascending)
                                WHERE("Document Type" = CONST(Policy),
                                      "Policy Status" = CONST(Live));
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
            column(CWebs; CompInfor."Home Page")
            {
            }
            column(CFaxno; CompInfor."Fax No.")
            {
            }
            column(DocumentType_InsureHeader; "Insure Header"."Document Type")
            {
            }
            column(No_InsureHeader; "Insure Header"."No.")
            {
            }
            column(InsuredNo_InsureHeader; "Insure Header"."Insured No.")
            {
            }
            column(PolicyType_InsureHeader; "Insure Header"."Policy Type")
            {
            }
            column(AgentBroker_InsureHeader; "Insure Header"."Agent/Broker")
            {
            }
            column(TotalNetPremium_InsureHeader; "Insure Header"."Total Net Premium")
            {
            }
            column(PolicyDescription_InsureHeader; "Insure Header"."Policy Description")
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEndDate; PeriodEndDate)
            {
            }
            column(GrossPremiumAgents; GrossPremiumAgents)
            {
            }
            column(GrossPremiumsBrokers; GrossPremiumsBrokers)
            {
            }
            column(GrossPremiumDirectClients; GrossPremiumDirectClients)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.CALCFIELDS(Picture);
                "Insure Header".SETRANGE("Insure Header"."No.", "Insure Header"."No.");
                "Insure Header".SETRANGE("Insure Header"."Posting Date", "Insure Header"."Posting Date");
                "Insure Header".FINDLAST;
                "Insure Header".CALCFIELDS("Total Net Premium");
                GrossPremiumsBrokers := 0.0;
                GrossPremiumAgents := 0.0;
                GrossPremiumDirectClients := 0.0;
                IF cust.GET("Insure Header"."Agent/Broker") THEN BEGIN
                    IF cust."Customer Posting Group" = 'AGENTS' THEN
                        GrossPremiumAgents := "Insure Header"."Total Net Premium"
                    ELSE
                        IF
                    cust."Customer Posting Group" = 'BROKERS' THEN
                            GrossPremiumsBrokers := "Insure Header"."Total Net Premium"
                        ELSE
                            IF
                      cust."Customer Posting Group" = 'DIRECT' THEN
                                GrossPremiumDirectClients := "Insure Header"."Total Net Premium";
                END;
                "Insure Header".SETRANGE("Insure Header"."No.");
                "Insure Header".SETRANGE("Insure Header"."Posting Date");
            end;

            trigger OnPreDataItem();
            begin
                VerifyDates();
                "Insure Header".SETRANGE("Insure Header"."Posting Date", PeriodStartDate, PeriodEndDate);
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
                        Caption = 'Start Date';
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

    var
        CompInfor: Record 79;
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        EndDateFutureDate: Label 'End Date value is a future date';
        GrossPremiumDirectClients: Decimal;
        GrossPremiumAgents: Decimal;
        GrossPremiumsBrokers: Decimal;
        cust: Record Customer;
        StartDateGreatorThanEndDate: Label 'Start Date Can''t be greator than End Date';

    procedure InitializeRequest(StartDate: Date; EndDate: Date);
    begin
        PeriodStartDate := StartDate;
        PeriodEndDate := EndDate;
    end;

    local procedure VerifyDates();
    begin
        IF PeriodStartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF PeriodStartDate > PeriodEndDate THEN
            ERROR(StartDateGreatorThanEndDate);
        IF PeriodEndDate > WORKDATE THEN
            ERROR(EndDateFutureDate);
    end;
}

