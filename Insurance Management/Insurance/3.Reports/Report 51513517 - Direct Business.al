report 51513517 "Direct Business"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Direct Business.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Policy No" = FILTER(<> ' '),
                                      "Brokers Name" = FILTER('DIRECT CLIENTS'),
                                      "Document Type" = FILTER(Policy));
            RequestFilterFields = "Document Date", "Shortcut Dimension 1 Code";
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
            column(BranchName; BranchName)
            {
            }
            column(TelephoneContact; TelephoneContact)
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
            column(AgentBroker_InsureHeader; "Insure Header"."Agent/Broker")
            {
            }
            column(BrokersName_InsureHeader; "Insure Header"."Brokers Name")
            {
            }
            column(UndewriterName_InsureHeader; "Insure Header"."Underwriter Name")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(TotalNetPremium_InsureHeader; "Insure Header"."Total Net Premium")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            column(DocumentDate_InsureHeader; "Insure Header"."Document Date")
            {
            }
            column(EndorsementPolicyNo_InsureHeader; "Insure Header"."Endorsement Policy No.")
            {
            }
            column(FromDate_InsureHeader; "Insure Header"."From Date")
            {
            }
            column(ToDate_InsureHeader; "Insure Header"."To Date")
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
                                    WHERE("Description Type" = FILTER("Schedule of Insured"));
                column(DocumentType_InsureLines; "Insure Lines"."Document Type")
                {
                }
                column(DocumentNo_InsureLines; "Insure Lines"."Document No.")
                {
                }
                column(RegistrationNo_InsureLines; "Insure Lines"."Registration No.")
                {
                }
                column(SeatingCapacity_InsureLines; "Insure Lines"."Seating Capacity")
                {
                }
                column(CertificateNo_InsureLines; "Insure Lines"."Certificate No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                InsureHeader.SETRANGE(InsureHeader."No.", "Insure Header"."No.");
                InsureHeader.SETRANGE(InsureHeader."Posting Date", "Insure Header"."Posting Date");

                BranchCode := "Insure Header"."Shortcut Dimension 1 Code";
                GenLedgSetup.GET;
                IF DimValue.GET(GenLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;
                IF Cust.GET("Insure Header"."Insured No.") THEN
                    TelephoneContact := Cust."Phone No.";
                InsureHeader.SETRANGE(InsureHeader."No.");
                InsureHeader.SETRANGE(InsureHeader."Posting Date");
            end;

            trigger OnPreDataItem();
            begin
                "Insure Header".SETRANGE("Insure Header"."Posting Date", PeriodStartDate, PeriodEndDate);
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
                        Caption = '" Start Date"';
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
        BranchName: Text;
        GenLedgSetup: Record "General Ledger Setup";
        BranchCode: Code[30];
        DimValue: Record "Dimension Value";
        TelephoneContact: Code[30];
        Cust: Record Customer;
        InsureHeader: Record "Insure Header";
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

