report 51513505 "Expected Certificates"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Expected Certificates.rdl';

    dataset
    {
        dataitem("Certificate Printing"; "Certificate Printing")
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                WHERE("Policy No" = FILTER(<> ''),
                                      "Certificate Status" = FILTER(Active));
            RequestFilterFields = "Shortcut Dimension 1 Code", "Policy Type";
            column(NetPremium_CertificatePrinting; "Certificate Printing"."Net Premium")
            {
            }
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
            column(RegistrationNo_CertificatePrinting; "Certificate Printing"."Registration No.")
            {
            }
            column(SeatingCapacity_CertificatePrinting; "Certificate Printing"."Seating Capacity")
            {
            }
            column(StartDate_CertificatePrinting; "Certificate Printing"."Start Date")
            {
            }
            column(EndDate_CertificatePrinting; "Certificate Printing"."End Date")
            {
            }
            column(PolicyNo_CertificatePrinting; "Certificate Printing"."Policy No")
            {
            }
            column(InsuredId_CertificatePrinting; "Certificate Printing"."Height Unit")
            {
            }
            column(BranchAgent; BranchAgent)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(ShortCode; ShortCode)
            {
            }
            column(Description_CertificatePrinting; "Certificate Printing".Description)
            {
            }
            column(ClientNo; ClientNo)
            {
            }
            column(CertificateType_CertificatePrinting; "Certificate Printing"."Certificate Type")
            {
            }
            column(CertificateNo_CertificatePrinting; "Certificate Printing"."Certificate No.")
            {
            }
            column(NetPremium; NetPremium)
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEndDate; PeriodEndDate)
            {
            }

            trigger OnAfterGetRecord();
            begin
                NetPremium := 0;
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                IF PolicyType.GET("Policy Type") THEN
                    ShortCode := PolicyType.Description;
                GenLedgSetup.GET;
                BranchCode := "Certificate Printing"."Shortcut Dimension 1 Code";
                IF DimValue.GET(GenLedgSetup."Global Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;
                //MESSAGE('%1', BranchCode);
                InsureHeader.SETRANGE(InsureHeader."Document Type", InsureHeader."Document Type"::Policy);
                InsureHeader.SETRANGE(InsureHeader."No.", "Certificate Printing"."Policy No");
                IF InsureHeader.FIND('-') THEN BEGIN
                    ClientNo := InsureHeader."Insured No.";
                    Product := InsureHeader."Policy Description";
                    InsureHeader.CALCFIELDS(InsureHeader."Total Net Premium");
                    NetPremium := InsureHeader."Total Net Premium";
                    AgentCode := InsureHeader."Agent/Broker";
                    IF AgentCode <> '' THEN
                        Cust.GET(AgentCode);
                    BranchAgent := Cust.Name;
                    AgentMobile := Cust."Phone No.";

                END;
            end;

            trigger OnPreDataItem();
            begin
                VerifyDates();
                "Certificate Printing".SETRANGE("Certificate Printing"."End Date", PeriodStartDate, PeriodEndDate);
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
            PeriodEndDate := WORKDATE;
            PeriodStartDate := WORKDATE;
        end;
    }

    labels
    {
        ReportTitle = 'EXPECTED CERTIFICATES';
    }

    var
        CompInfor: Record 79;
        Cust: Record Customer;
        CustomerName: Text;
        AgentMobile: Text;
        BranchAgent: Text;
        BranchName: Text;
        DimValue: Record "Dimension Value";
        Dimensions: Record 348;
        ClassName: Text;
        PolicyType: Record "Policy Type";
        Product: Text;
        InsuranceClass: Record "Insurance Class";
        GenLedgSetup: Record "General Ledger Setup";
        BranchCode: Code[30];
        InsureHeader: Record "Insure Header";
        AgentCode: Code[30];
        ClientNo: Code[30];
        ShortCode: Code[30];
        NetPremium: Decimal;
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Date value is a future date';

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

