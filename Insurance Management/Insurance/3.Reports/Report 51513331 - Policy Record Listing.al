report 51513331 "Policy Record Listing"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Policy Record Listing.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST("Debit Note"));
            RequestFilterFields = "Posting Date", "Agent/Broker";
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
            column(CustAddress; CustAddress)
            {
            }
            column(CustAddress2; CustAddress2)
            {
            }
            column(CustAddress3; CustAddress3)
            {
            }
            column(DocumentDate; "Insure Header"."Document Date")
            {
            }
            column(PolicyType; "Insure Header"."Policy Type")
            {
            }
            column(PolicyNo; "Insure Header"."Policy No")
            {
            }
            column(InsuredName; "Insure Header"."Insured Name")
            {
            }
            column(QuoteType; "Insure Header"."Quote Type")
            {
            }
            column(PremiumAmount; "Insure Header"."Premium Amount")
            {
            }
            column(PremiumPaymentFrequency; "Insure Header"."Premium Payment Frequency")
            {
            }
            column(PaymentMethod; "Insure Header"."Payment Method")
            {
            }
            column(Underwriter; "Insure Header".Underwriter)
            {
            }
            column(BrokersName; "Insure Header"."Brokers Name")
            {
            }
            column(AgentBroker; "Insure Header"."Agent/Broker")
            {
            }
            column(PolicyDescription; "Insure Header"."Policy Description")
            {
            }
            column(TotalPremiumAmount; "Insure Header"."Total Premium Amount")
            {
            }
            column(CountryofResidence_InsureHeader; "Insure Header"."Country of Residence")
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Cust.GET("Insure Header"."Insured No.") THEN
                    CustAddress := Cust.Address;
                CustAddress2 := Cust."Address 2";
                CustAddress3 := Cust.City;


                Policies.RESET;

                Policies.SETRANGE(Policies."Document Type", Policies."Document Type"::Policy);
                Policies.SETRANGE(Policies."Policy Status", Policies."Policy Status"::Live);
                //Policies.SETRANGE(Policies."Policy No",New."Policy No");
                IF NOT Policies.FIND('+') THEN
                    CurrReport.SKIP;
                //NewTotals:=;
            end;

            trigger OnPreDataItem();
            begin
                //"Insure Header".SETRANGE("Insure Header"."Insured No.",Cust."No.");



                "Insure Header".SETRANGE("Insure Header"."Posting Date", MinDate, MaxDate);
                //"Insure Header".SETFILTER(Renewal."Agent/Broker",New.GETFILTER("Agent/Broker"));
                // Counter:=Renewal.COUNT;
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

    trigger OnPreReport();
    begin
        CompInfor.GET;
        CompInfor.CALCFIELDS(Picture);


        MinDate := "Insure Header".GETRANGEMIN("Insure Header"."Posting Date");
        MaxDate := "Insure Header".GETRANGEMAX("Insure Header"."Posting Date");
        MinDate2 := "Insure Header".GETRANGEMIN("Insure Header"."Posting Date");
        MaxDate1 := "Insure Header".GETRANGEMAX("Insure Header"."Posting Date");
    end;

    var
        CompInfor: Record 79;
        Cust: Record Customer;
        CustAddress: Text;
        CustAddress2: Text;
        CustAddress3: Text;
        Counter: Integer;
        MinDate: Date;
        MaxDate: Date;
        Policies: Record "Insure Header";
        TOTALS: Decimal;
        NewTotals: Decimal;
        RenTotals: Decimal;
        AddTotals: Decimal;
        DelTotals: Decimal;
        CreditMemos: Record "Insure Header";
        SalesInvoiceHeader: Record "Insure Header";
        PolicyRec: Record "Insure Header";
        //"Payment schedule": Record 51513103;
        MinDate2: Date;
        MaxDate1: Date;
        FNEW: Decimal;
        Rnew: Decimal;
        ADnew: Decimal;
        Dnew: Decimal;
        Totals2: Decimal;
}

