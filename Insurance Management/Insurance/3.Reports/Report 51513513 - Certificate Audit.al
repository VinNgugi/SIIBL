report 51513513 "Certificate Audit"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Certificate Audit.rdl';

    dataset
    {
        dataitem("Certificate Printing"; "Certificate Printing")
        {
            DataItemTableView = SORTING("Document Type", "No. of Employees")
                                WHERE("Policy No" = FILTER(<> ''),
                                      Printed = FILTER(True),
                                      "Certificate No." = FILTER(<> ''));
            RequestFilterFields = "Shortcut Dimension 1 Code", "Certificate Type", "Policy No", "Endorsement Type";
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
            column(DocumentNo_CertificatePrinting; "Certificate Printing"."Document No.")
            {
            }
            column(GrossPremium_CertificatePrinting; "Certificate Printing"."Gross Premium")
            {
            }
            column(PolicyType_CertificatePrinting; "Certificate Printing"."Policy Type")
            {
            }
            column(PremiumAmount_CertificatePrinting; "Certificate Printing"."Premium Amount")
            {
            }
            column(PolicyNo_CertificatePrinting; "Certificate Printing"."Policy No")
            {
            }
            column(EndorsementDate_CertificatePrinting; "Certificate Printing"."Endorsement Date")
            {
            }
            column(SumInsured_CertificatePrinting; "Certificate Printing"."Sum Insured")
            {
            }
            column(NetPremium_CertificatePrinting; "Certificate Printing"."Net Premium")
            {
            }
            column(RegistrationNo_CertificatePrinting; "Certificate Printing"."Registration No.")
            {
            }
            column(Make_CertificatePrinting; "Certificate Printing".Make)
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
            column(ActionType_CertificatePrinting; "Certificate Printing"."Action Type")
            {
            }
            column(InsuredNo_CertificatePrinting; "Certificate Printing"."Insured No.")
            {
            }
            column(CertificateNo_CertificatePrinting; "Certificate Printing"."Certificate No.")
            {
            }
            column(CertificateType_CertificatePrinting; "Certificate Printing"."Certificate Type")
            {
            }
            column(DatePrinted_CertificatePrinting; "Certificate Printing"."Date Printed")
            {
            }
            column(PrintedBy_CertificatePrintings; "Certificate Printing"."Printed By")
            {
            }
            column(CertificateStatus_CertificatePrinting; "Certificate Printing"."Certificate Status")
            {
            }
            column(CustName; CustName)
            {
            }
            column(ShortCode; ShortCode)
            {
            }
            column(Premium; Premium)
            {
            }
            column(EndorsementName; EndorsementName)
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
                EndorsementName := '';
                IF PolicyType.GET("Policy Type") THEN
                    ShortCode := PolicyType.Description;
                BranchCode := "Certificate Printing"."Shortcut Dimension 1 Code";
                IF DimValue.GET(GenLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;


                Insuredebitnotes.SETRANGE(Insuredebitnotes."No.", "Certificate Printing"."Document No.");
                IF Insuredebitnotes.FIND('-') THEN BEGIN
                    CustName := Insuredebitnotes."Insured Name";
                    Insuredebitnotes.CALCFIELDS(Insuredebitnotes."Total Premium Amount");
                    Premium := Insuredebitnotes."Total Premium Amount";
                    IF EndorsementType.GET(Insuredebitnotes."Endorsement Type") THEN
                        EndorsementName := EndorsementType.Description
                END;
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
        ReportTitle = 'CERTIFICATE AUDIT REPORT';
    }

    trigger OnPreReport();
    begin
        CompInfor.GET;
        CompInfor.CALCFIELDS(CompInfor.Picture);
    end;

    var
        CompInfor: Record 79;
        Insured: Text;
        InsureHeader: Record "Insure Header";
        FromDate: Date;
        ToDate: Date;
        SeatingCapacity: Integer;
        RegNo: Code[30];
        InsureLine: Record "Insure Lines";
        BranchAgent: Code[10];
        BankAccLedgEntry: Record 271;
        DocNumber: Text;
        ReceiptLines1x: Record "Receipt Lines";
        ReceiptNo: Code[30];
        ReceiptAmount: Decimal;
        ShortCode: Code[30];
        PolicyType: Record "Policy Type";
        CertificatePrinting: Record "Certificate Printing";
        CertStatus: Option;
        DebitNoteNo: Code[30];
        CertDateIssued: Date;
        BranchCode: Code[30];
        BranchName: Text;
        DimValue: Record "Dimension Value";
        GenLedgSetup: Record "General Ledger Setup";
        Cust: Record Customer;
        CustName: Text;
        Insuredebitnotes: Record "Insure Debit Note";
        Premium: Decimal;
        EndorsementName: Text;
        EndorsementType: Record "Endorsement Types";
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

