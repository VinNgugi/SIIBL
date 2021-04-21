report 51513531 "Commission Summary-Agents"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Commission Summary-Agents.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Customer Type" = FILTER("Agent/Broker"),
                                      "Customer Posting Group" = FILTER(<> 'DIRECT'),
                                      Name = FILTER(<> ''));
            RequestFilterFields = "Global Dimension 1 Code";
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
            column(NetCommission_Customer; Customer."Net Commission")
            {
            }
            column(No_Customer; Customer."No.")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            column(MaxDate; MaxDate)
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                /*
                IF MaxDate = 0D THEN
                  ERROR(BlankEndDateErr);
                SETRANGE("Date Filter",0D,MaxDate);
                */
                Customer.SETRANGE(Customer."Date Filter", PeriodStartDate, MaxDate);
                Wht := 0;
                "Gross Premium" := 0.0;
                "Net Commission" := 0.0;
                Commission := 0.0;
                Receipts := 0.0;
                Customer.CALCFIELDS(Wht, "Gross Premium", "Net Commission", Commission, Receipts);

            end;

            trigger OnPreDataItem();
            begin
                VerifyDates;
                //SETRANGE(Customer."No.",Customer."No.");
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
                    field(StartingDate; PeriodStartDate)
                    {
                        Caption = 'Starting Date';
                    }
                    field("Ending Date"; MaxDate)
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
            PeriodStartDate := WORKDATE;
            MaxDate := WORKDATE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        /*
        CustFilter := Customer.GETFILTERS;
        CustDateFilter := Customer.GETFILTER("Date Filter");
        FOR i := 2 TO 4 DO
          PeriodStartDate[i + 1] := CALCDATE(PeriodLength,PeriodStartDate[i]);
        PeriodStartDate[6] := 31129999D;
        */

    end;

    var
        CompInfor: Record 79;
        CustFilter: Text;
        CustDateFilter: Text[30];
        MaxDate: Date;
        PeriodLength: DateFormula;
        PeriodStartDatei: array[6] of Date;
        i: Integer;
        BlankStartDateErr: Label 'Start Date must have a value.';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';
        PeriodStartDate: Date;

    procedure InitializeRequest(NewEndingDate: Date);
    begin
        MaxDate := NewEndingDate;
    end;

    local procedure VerifyDates();
    begin
        IF PeriodStartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF MaxDate = 0D THEN
            ERROR(BlankEndDateErr);
        IF PeriodStartDate > MaxDate THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;
}

