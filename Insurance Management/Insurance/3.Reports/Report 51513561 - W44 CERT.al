report 51513561 "W44 CERT"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/W44 CERT.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Customer Type" = FILTER("Agent/Broker"),
                                      "Customer Posting Group" = FILTER(<> 'DIRECT'),
                                      Name = FILTER(<> ''));
            RequestFilterFields = "Global Dimension 1 Code", "No.";
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
            column(GrossPremium_Customer; Customer."Gross Premium")
            {
            }
            column(Receipts_Customer; Customer.Receipts)
            {
            }
            column(Commission_Customer; Customer.Commission)
            {
            }
            column(Wht_Customer; Customer.Wht)
            {
            }
            column(NetCommission_Customers; Customer."Net Commission")
            {
            }
            column(No_Customer; Customer."No.")
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEndDate; PeriodEndDate)
            {
            }
            column(CustAddress2; CustAddress2)
            {
            }
            column(AgentAmountTax; AgentAmountTax)
            {
            }
            column(BrokerAmountTax; BrokerAmountTax)
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                //Customer.SETRANGE("Date Filter", PeriodStartDate, PeriodEndDate);
                CustAddress2 := 'P.O BOX' + ' ' + Customer."Address 2" + '-' + Customer."Post Code" + ', ' + Customer.City;

                BrokerAmountTax := 0.0;
                AgentAmountTax := 0.0;

                IF Customer."Insured Type" = Customer."Insured Type"::Broker THEN BEGIN
                    Customer.CALCFIELDS(Customer.Wht);
                    BrokerAmountTax := Customer.Wht;
                END;

                IF Customer."Insured Type" = Customer."Insured Type"::Agent THEN BEGIN
                    Customer.CALCFIELDS(Customer.Wht);
                    AgentAmountTax := Customer.Wht;
                END;
            end;

            trigger OnPreDataItem();
            begin
                VerifyDates();
                Customer.SETRANGE(Customer."Date Filter", PeriodStartDate, PeriodEndDate);
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
            PeriodEndDate := WORKDATE;
            PeriodStartDate := WORKDATE;
        end;
    }

    labels
    {
    }

    var
        CompInfor: Record "Company Information";
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        CustAddress2: Text;
        BrokerAmountTax: Decimal;
        AgentAmountTax: Decimal;
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        EndDateFutureDate: Label 'End Date value is a future date';
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

