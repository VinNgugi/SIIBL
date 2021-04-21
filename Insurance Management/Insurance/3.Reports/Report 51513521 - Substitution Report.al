report 51513521 "Substitution Report"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Substitution Report.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Action Type" = FILTER(Substitution),
                                      "Document Type" = CONST(Policy));
            RequestFilterFields = "Shortcut Dimension 1 Code";
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
            column(Underwriter_InsureHeader; "Insure Header".Underwriter)
            {
            }
            column(BrokersName_InsureHeader; "Insure Header"."Brokers Name")
            {
            }
            column(UnderwriterName_InsureHeader; "Insure Header"."Underwriter Name")
            {
            }
            column(PremiumAmount_InsureHeader; "Insure Header"."Premium Amount")
            {
            }
            column(FromDate_InsureHeader; "Insure Header"."From Date")
            {
            }
            column(ToDate_InsureHeader; "Insure Header"."To Date")
            {
            }
            column(PolicyStatus_InsureHeader; "Insure Header"."Policy Status")
            {
            }
            column(CoverPeriod_InsureHeaders; "Insure Header"."Cover Period")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(DocumentDate_InsureHeader; "Insure Header"."Document Date")
            {
            }
            column(ShortcutDimension1Code_InsureHeader; "Insure Header"."Shortcut Dimension 1 Code")
            {
            }
            column(NoOfDays_InsureHeader; "Insure Header"."No. Of Days")
            {
            }
            column(EndorsementType_InsureHeader; "Insure Header"."Endorsement Type")
            {
            }
            column(EndorsementPolicyNo_InsureHeader; "Insure Header"."Endorsement Policy No.")
            {
            }
            column(CertStartDate; CertStartDate)
            {
            }
            column(CertEndDate; CertEndDate)
            {
            }
            column(DebitNoteNo; DebitNoteNo)
            {
            }
            column(ReinstatedAmount; ReinstatedAmount)
            {
            }
            column(TaxCharge; TaxCharge)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEndDate; PeriodStartDate)
            {
            }
            dataitem("Insure Lines"; "Insure Lines")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Document Type" = FILTER(Policy),
                                          "Description Type" = FILTER("Schedule of Insured"));
                column(DocumentType_InsureLines; "Insure Lines"."Document Type")
                {
                }
                column(DocumentNo_InsureLines; "Insure Lines"."Document No.")
                {
                }
                column(RiskID_InsureLines; "Insure Lines"."Risk ID")
                {
                }
                column(EndorsementDate_InsureLines; "Insure Lines"."Endorsement Date")
                {
                }
                column(RegistrationNo_InsureLines; "Insure Lines"."Registration No.")
                {
                }
                column(SeatingCapacity_InsureLines; "Insure Lines"."Seating Capacity")
                {
                }
                column(EndorsementType_InsureLines; "Insure Lines"."Endorsement Type")
                {
                }
                column(CertificateNo_InsureLines; "Insure Lines"."Certificate No.")
                {
                }
                column(SubstitutedVehicleRegNo_InsureLines; "Insure Lines"."Substituted Vehicle Reg. No")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    //Certificatesprinting.SETRANGE(Certificatesprinting."Certificate Status", Certificatesprinting."Certificate Status"::Suspended);

                    "Insure Lines".SETRANGE("Insure Lines"."Document Type", "Insure Lines"."Document Type");
                    "Insure Lines".SETRANGE("Insure Lines"."Document No.", "Insure Lines"."Document No.");
                    "Insure Lines".FINDLAST;
                    CertificatesPrinting.SETRANGE(CertificatesPrinting."Certificate No.", "Insure Lines"."Certificate No.");
                    IF CertificatesPrinting.FIND('-') THEN
                        CertStartDate := CertificatesPrinting."Start Date";
                    CertEndDate := CertificatesPrinting."End Date";

                    "Insure Lines".SETRANGE("Insure Lines"."Document Type");
                    "Insure Lines".SETRANGE("Insure Lines"."Document No.");
                end;
            }

            trigger OnAfterGetRecord();
            begin
                TaxCharge := 0.0;
                DebitNoteNo := '';
                ReinstatedAmount := 0.0;
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                "Insure Header".SETRANGE("Insure Header"."Policy No", "Insure Header"."Policy No");
                "Insure Header".SETRANGE("Insure Header"."Posting Date", "Insure Header"."Posting Date");
                "Insure Header".FINDLAST;

                GenLedgSetup.GET;
                BranchCode := "Insure Header"."Shortcut Dimension 1 Code";
                IF DimValue.GET(GenLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;
                "Insure Header".SETRANGE("Insure Header"."Policy No");
                "Insure Header".SETRANGE("Insure Header"."Posting Date");
                InsureDebitNote.SETRANGE(InsureDebitNote."Action Type", InsureDebitNote."Action Type"::Substitution);
                InsureDebitNote.SETRANGE(InsureDebitNote."Endorsement Policy No.", "Insure Header"."No.");
                IF InsureDebitNote.FINDFIRST THEN BEGIN
                    DebitNoteNo := InsureDebitNote."No.";
                    InsureDebitNote.CALCFIELDS(InsureDebitNote."Total Net Premium");
                    ReinstatedAmount := InsureDebitNote."Total Net Premium";
                END;

                InsureDebitNoteLines.SETRANGE(InsureDebitNoteLines."Document No.", DebitNoteNo);
                IF InsureDebitNoteLines.FINDFIRST THEN BEGIN
                    InsureDebitNoteLines.SETRANGE(InsureDebitNoteLines."Description Type", InsureDebitNoteLines."Description Type"::Tax);
                    InsureDebitNoteLines.SETRANGE(InsureDebitNoteLines.Description, 'Certificate Charge');
                    TaxCharge := InsureDebitNoteLines.Amount;
                END;

            end;

            trigger OnPreDataItem();
            begin
                VerifyDates();
                "Insure Header".SETRANGE("Document Date", PeriodStartDate, PeriodEndDate);
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
        ReportTitle = 'SUBSTITUTION REPORT';
    }

    var
        CompInfor: Record 79;
        Insured: Text;
        InsureHeader: Record "Insure Header";
        FromDate: Date;
        ToDate: Date;
        SeatingCapacity: Integer;
        RegNo: Code[30];
        CertificatesPrinting: Record "Certificate Printing";
        InsureLine: Record "Insure Lines";
        BranchAgent: Code[10];
        CertificatesStatus: Option;
        BankAccLedgEntry: Record 271;
        DocNumber: Text;
        ReceiptLines1x: Record "Receipt Lines";
        ReceiptNo: Code[30];
        ReceiptAmount: Decimal;
        ShortCode: Code[30];
        PolicyType: Record "Policy Type";
        EndorsementNo: Code[30];
        GenLedgSetup: Record "General Ledger Setup";
        BranchName: Text;
        BranchCode: Code[30];
        DimValue: Record "Dimension Value";
        NoofDays: Integer;
        NewRegNo: Code[30];
        CertStartDate: Date;
        CertEndDate: Date;
        InsureDebitNote: Record "Insure Debit Note";
        DebitNoteNo: Code[30];
        ReinstatedAmount: Decimal;
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Date value is a future date';
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        TaxCharge: Decimal;
        TaxDescription: Text;
        InsureDebitNoteLines: Record "Insure Debit Note Lines";

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

