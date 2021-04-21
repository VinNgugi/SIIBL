report 51513515 "Cancelled Certificates"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Cancelled Certificates.rdl';

    dataset
    {
        dataitem("Certificate Printing"; "Certificate Printing")
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                WHERE("Certificate Status" = FILTER(Cancelled));
            RequestFilterFields = "Endorsement Date";
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
            column(Insured; Insured)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(DocNumber; DocNumber)
            {
            }
            column(ShortCode; ShortCode)
            {
            }
            column(BranchAgent; BranchAgent)
            {
            }
            column(DocumentType_CertificatePrinting; "Certificate Printing"."Document Type")
            {
            }
            column(DocumentNo_CertificatePrinting; "Certificate Printing"."Document No.")
            {
            }
            column(NetPremium_CertificatePrinting; "Certificate Printing"."Net Premium")
            {
            }
            column(Status_CertificatePrinting; "Certificate Printing".Status)
            {
            }
            column(CoverDescription_CertificatePrinting; "Certificate Printing"."Cover Description")
            {
            }
            column(RegistrationNo_CertificatePrinting; "Certificate Printing"."Registration No.")
            {
            }
            column(SeatingCapacity_CertificatePrinting; "Certificate Printing"."Seating Capacity")
            {
            }
            column(DescriptionType_CertificatePrinting; "Certificate Printing"."Description Type")
            {
            }
            column(StartDate_CertificatePrinting; "Certificate Printing"."Start Date")
            {
            }
            column(EndDate_CertificatePrinting; "Certificate Printing"."End Date")
            {
            }
            column(SerialNo_CertificatePrinting; "Certificate Printing"."Serial No")
            {
            }
            column(Amount_CertificatePrinting; "Certificate Printing".Amount)
            {
            }
            column(TPOPremium_CertificatePrinting; "Certificate Printing"."TPO Premium")
            {
            }
            column(CertificateStatus_CertificatePrinting; "Certificate Printing"."Certificate Status")
            {
            }
            column(ItemEntryNo_CertificatePrinting; "Certificate Printing"."Print Time")
            {
            }
            column(PolicyNo_CertificatePrinting; "Certificate Printing"."Policy No")
            {
            }
            column(CertificateNo_CertificatePrinting; "Certificate Printing"."Certificate No.")
            {
            }
            column(DeletionDate_CertificatePrinting; "Certificate Printing"."Deletion Date")
            {
            }
            column(EndorsementDate_CertificatePrinting; "Certificate Printing"."Endorsement Date")
            {
            }
            column(cancellationReasonDesc_CertificatePrinting; "Certificate Printing"."cancellation Reason Desc")
            {
            }
            column(CancellationDate_CertificatePrinting; "Certificate Printing"."Cancellation Date")
            {
            }
            column(DatePrinted_CertificatePrinting; "Certificate Printing"."Date Printed")
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
                IF PolicyType.GET("Policy Type") THEN
                    ShortCode := PolicyType.Description;
                //Receipt No
                BankAccLedgEntry.SETRANGE(BankAccLedgEntry."Policy No.", "Certificate Printing"."Policy No");
                IF BankAccLedgEntry.FIND('-') THEN
                    DocNumber := BankAccLedgEntry."Document No.";
                //Insured
                InsureHeader.SETRANGE(InsureHeader."Policy No", "Certificate Printing"."Policy No");
                IF InsureHeader.FIND('-') THEN
                    Insured := InsureHeader."Insured Name";
                //Branch
                GenLedgSetup.GET;
                BranchCode := "Certificate Printing"."Printed By";
                IF DimValue.GET(GenLedgSetup."Global Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;
            end;

            trigger OnPreDataItem();
            begin
                "Certificate Printing".SETRANGE("Certificate Printing"."Date Printed", PeriodStartDate, PeriodEndDate);
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
        ReportTitle = 'Cancelled Certificates';
    }

    trigger OnPreReport();
    begin
        CompInfor.GET;
        CompInfor.CALCFIELDS(CompInfor.Picture);
    end;

    var
        BankAccLedgEntry: Record 271;
        CompInfor: Record 79;
        Insured: Text;
        InsureHeader: Record "Insure Header";
        FromDate: Date;
        ToDate: Date;
        SeatingCapacity: Integer;
        RegNo: Code[30];
        CertificatesPrinting: Record "Certificate Printing";
        InsureLine: Record "Insure Lines";
        BranchAgent: Code[30];
        CertificatesStatus: Option;
        DocNumber: Text;
        BranchName: Text;
        GenLedgSetup: Record "General Ledger Setup";
        BranchCode: Code[30];
        DimValue: Record "Dimension Value";
        ShortCode: Code[30];
        PolicyType: Record "Policy Type";
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Date value is a future date';
        PeriodStartDate: Date;
        PeriodEndDate: Date;

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

