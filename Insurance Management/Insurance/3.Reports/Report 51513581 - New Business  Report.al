report 51513581 "New Business  Report"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/New Business  Report.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = FILTER(Policy),
                                      "Action Type" = CONST(New),
                                      "Policy Status" = CONST(Live));
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
            column(DocumentDate_InsureHeader; "Insure Header"."Document Date")
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
            column(TotalNetPremium_InsureHeader; "Insure Header"."Total Net Premium")
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
            column(CoverPeriod_InsureHeader; "Insure Header"."Cover Period")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
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
            column(ActionType_InsureHeader; "Insure Header"."Action Type")
            {
            }
            column(CertificateNo; CertificateNo)
            {
            }
            column(CertStartDate; CertStartDate)
            {
            }
            column(CertEndDate; CertEndDate)
            {
            }
            column(CreatedBy_InsureHeader; "Insure Header"."Created By")
            {
            }
            column(PostedBy_InsureHeader; "Insure Header"."Posted By")
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEndDate; PeriodEndDate)
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
                column(NetPremium_InsureLines; "Insure Lines"."Net Premium")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    //Certificatesprinting.SETRANGE(Certificatesprinting."Certificate Status", Certificatesprinting."Certificate Status"::Suspended);
                    "Insure Lines".SETRANGE("Insure Lines"."Document Type", "Insure Lines"."Document Type");
                    "Insure Lines".SETRANGE("Insure Lines"."Document No.", "Insure Lines"."Document No.");
                    "Insure Lines".FINDLAST;
                    Certificatesprinting.SETRANGE(Certificatesprinting."Certificate No.", "Insure Lines"."Certificate No.");
                    IF Certificatesprinting.FINDFIRST THEN
                        CertStartDate := Certificatesprinting."Start Date";
                    CertEndDate := Certificatesprinting."End Date";
                    "Insure Lines".SETRANGE("Insure Lines"."Document Type");
                    "Insure Lines".SETRANGE("Insure Lines"."Document No.");
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                "Insure Header".SETRANGE("Insure Header"."Policy No", "Insure Header"."Policy No");
                "Insure Header".SETRANGE("Insure Header"."Posting Date", "Insure Header"."Posting Date");
                "Insure Header".FINDLAST;
                "Insure Header".CALCFIELDS("Insure Header"."Total Net Premium");
                GenLedgerSetup.GET;
                BranchCode := "Insure Header"."Shortcut Dimension 1 Code";
                IF DimValue.GET(GenLedgerSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;
                "Insure Header".SETRANGE("Insure Header"."Policy No");
                "Insure Header".SETRANGE("Insure Header"."Posting Date");
            end;

            trigger OnPreDataItem();
            begin
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
        ReportTitle = 'SUSPENSION REPORT';
    }

    var
        CompInfor: Record 79;
        InsureHeader: Record "Insure Header";
        GenLedgerSetup: Record "General Ledger Setup";
        BranchCode: Code[30];
        BranchName: Text;
        DimValue: Record "Dimension Value";
        Certificatesprinting: Record "Certificate Printing";
        CertStartDate: Date;
        CertEndDate: Date;
        CertificateNo: Code[10];
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

