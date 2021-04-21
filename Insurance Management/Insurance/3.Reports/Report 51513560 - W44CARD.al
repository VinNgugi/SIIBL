report 51513560 W44CARD
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/W44CARD.rdl';

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
            column(DateFilter_Customer; Customer."Date Filter")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                column(PostingDate_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Posting Date")
                {
                }
                column(Amount_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry".Amount)
                {
                }
                column(CustomerNo_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Customer No.")
                {
                }
                column(CommisionAmount; CommisionAmount)
                {
                }
                column(WhtAmount; WhtAmount)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Insurance Trans Type", "Detailed Cust. Ledg. Entry"."Insurance Trans Type"::Commission);
                    IF "Detailed Cust. Ledg. Entry".FIND THEN
                        CommisionAmount := "Detailed Cust. Ledg. Entry".Amount;

                    "Detailed Cust. Ledg. Entry".RESET;
                    "Detailed Cust. Ledg. Entry".SETRANGE("Detailed Cust. Ledg. Entry"."Insurance Trans Type", "Detailed Cust. Ledg. Entry"."Insurance Trans Type"::Wht);
                    IF "Detailed Cust. Ledg. Entry".FIND THEN
                        WhtAmount := "Detailed Cust. Ledg. Entry".Amount;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                //Customer.SETRANGE("Date Filter", PeriodStartDate, PeriodEndDate);
                CustAddress2 := 'P.O BOX' + ' ' + Customer."Address 2" + '-' + Customer."Post Code" + ', ' + Customer.City;
                BrokerAmountTax := 0.0;
                AgentAmountTax := 0.0;

                IF Customer."VAT Bus. Posting Group" = 'BROKER' THEN BEGIN
                    Customer.CALCFIELDS(Customer.Wht);
                    BrokerAmountTax := Customer.Wht;
                END;

                IF
                  Customer."VAT Bus. Posting Group" = 'AGENT' THEN BEGIN
                    Customer.CALCFIELDS(Customer.Wht);
                    AgentAmountTax := Customer.Wht;
                END;

                // MESSAGE('%1', CompInfor."Name 2");
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
        CustAddress2: Text;
        BrokerAmountTax: Decimal;
        AgentAmountTax: Decimal;
        CommisionAmount: Decimal;
        WhtAmount: Decimal;
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

