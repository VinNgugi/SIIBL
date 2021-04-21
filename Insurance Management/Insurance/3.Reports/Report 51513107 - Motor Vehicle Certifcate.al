report 51513107 "Motor Vehicle Certifcate"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Motor Vehicle Certifcate.rdl';

    dataset
    {
        dataitem("Certificate Printing"; "Certificate Printing")
        {
            RequestFilterFields = "Registration No.";
            column(PolicyNo_SalesInsuranceHeader; "Certificate Printing"."Policy No")
            {
            }
            column(FromTime_SalesInsuranceHeader; FromTime)
            {
            }
            column(ToTime_SalesInsuranceHeader; ToTime)
            {
            }
            column(FromDate_SalesInsuranceHeader; "Certificate Printing"."Start Date")
            {
            }
            column(ToDate_SalesInsuranceHeader; "Certificate Printing"."End Date")
            {
            }
            column(Name; InsuredName)
            {
            }
            column(SelltoCustomerNo_SalesInsuranceHeader; InsuredName)
            {
            }
            column(No_SalesInsuranceHeader; "Certificate Printing"."Document No.")
            {
            }
            column(UndewriterName_SalesInsuranceHeader; CompanyInfo.Name)
            {
            }
            column(RegistrationNo; "Certificate Printing"."Registration No.")
            {
            }
            column(ShortCode; ShortCode)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(ToDate; ToDate)
            {
            }
            column(SeatingCapacity_CertificatePrinting; "Certificate Printing"."Seating Capacity")
            {
            }
            column(CarryingCapacity_CertificatePrinting; "Certificate Printing"."Carrying Capacity")
            {
            }
            column(SerialNo_CertificatePrinting; "Certificate Printing"."Serial No")
            {
            }
            column(RegTpo; RegTpo)
            {
            }
            column(SeatingCapacity; SeatingCapacity)
            {
            }
            column(CertificateNo_CertificatePrinting; "Certificate Printing"."Certificate No.")
            {
            }
            column(PrintTime_CertificatePrinting; "Certificate Printing"."Print Time")
            {
            }
            column(CertPrintingTime; CertPrintingTime)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF PolicyType.GET("Policy Type") THEN
                    ShortCode := PolicyType."short code";
                PolicyDescription := PolicyType.Description;
                CertPrintingTime := FORMAT("Certificate Printing"."Print Time");
                FromDate := "Certificate Printing"."Start Date";
                IF FromDate <> WORKDATE THEN
                    CertPrintingTime := FORMAT("Certificate Printing"."Print Time", 10, Text01);

                ToDate := "Certificate Printing"."End Date";
                RegTpo := "Certificate Printing"."Registration No." + '   ' + ShortCode;
                SeatingCapacity := '***' + FORMAT("Certificate Printing"."Seating Capacity") + '' + 'Pass***';
                IF PolicyDescription = 'TAXI TPO' THEN
                    SeatingCapacity := '***' + FORMAT("Certificate Printing"."Seating Capacity") + '' + 'PLL***';
                IF PolicyDescription = 'TPO HIRE' THEN
                    SeatingCapacity := '***' + FORMAT("Certificate Printing"."Seating Capacity") + '' + 'PLL***';
                IF PolicyDescription = 'COMPREHENSIVE TAXI' THEN
                    SeatingCapacity := '***' + FORMAT("Certificate Printing"."Seating Capacity") + '' + 'PLL***';
                IF PolicyDescription = 'COMPREHENSIVE HIRE' THEN
                    SeatingCapacity := '***' + FORMAT("Certificate Printing"."Seating Capacity") + '' + 'PLL***';

                //MEIF PolicyDescription='TPO HIRE' THEN
                // SeatingCapacity:='***'+FORMAT("Certificate Printing"."Seating Capacity")+''+'PLL***';
                //SSAGE('%1', RegTpo);

                PolicyRec.RESET;
                PolicyRec.SETRANGE(PolicyRec."Document Type", PolicyRec."Document Type"::Policy);
                PolicyRec.SETRANGE(PolicyRec."No.", "Certificate Printing"."Policy No");
                IF PolicyRec.FINDFIRST THEN
                    InsuredName := PolicyRec."Insured Name";
                CompanyInfo.GET;
                IF NOT CurrReport.PREVIEW THEN BEGIN

                    "Certificate Printing"."Date Printed" := TODAY;
                    "Certificate Printing"."Print Time" := TIME;
                    "Certificate Printing".Printed := TRUE;
                    "Certificate Printing"."Printed By" := USERID;
                    "Certificate Printing".MODIFY;
                END;
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
        InsuranceLines: Record "Insure Lines";
        RegistrationNo: Code[30];
        ShortCode: Code[30];
        PolicyType: Record "Policy Type";
        FromDate: Date;
        ToDate: Date;
        Installments: Record "No. of Instalments";
        Insurer: Record Vendor;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Certificates: Record 51513035;
        FromTime: Text;
        ToTime: Text;
        CompanyInfo: Record 79;
        InsuredName: Text;
        PolicyRec: Record "Insure Header";
        RegTpo: Text;
        SeatingCapacity: Text;
        PolicyDescription: Text;
        CertPrintingTime: Text;
        Text01: Label '00:00 hr';
}

