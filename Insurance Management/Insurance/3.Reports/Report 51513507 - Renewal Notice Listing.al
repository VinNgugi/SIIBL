report 51513507 "Renewal Notice Listing"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Renewal Notice Listing.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = FILTER(Policy),
                                      "Policy No" = FILTER(<> ''),
                                      "Insured No." = FILTER(<> ''),
                                      "Policy Status" = FILTER(<> Renewed),
                                      "Total Net Premium" = FILTER(<> 0));
            RequestFilterFields = "Agent/Broker", "Shortcut Dimension 1 Code", "Expected Renewal Date", "Insured Name";
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
            column(BrokersName_InsureHeader; "Insure Header"."Brokers Name")
            {
            }
            column(PhoneNo_InsureHeader; "Insure Header"."Phone No.")
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
            column(PolicyClass_InsureHeader; "Insure Header"."Policy Class")
            {
            }
            column(TotalSumInsured_InsureHeader; "Insure Header"."Total Sum Insured")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            column(Status_InsureHeader; "Insure Header".Status)
            {
            }
            column(TotalNetPremium_InsureHeader; "Insure Header"."Total Net Premium")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(AgentContact_Caption; AgentContact)
            {
            }
            column(BranchAgent; BranchAgent)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(FutureAnnualPremium; FutureAnnualPremium)
            {
            }
            column(ExpectedRenewalDate_InsureHeader; "Insure Header"."Expected Renewal Date")
            {
            }
            column(PolicyDescription_InsureHeader; "Insure Header"."Policy Description")
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

                trigger OnAfterGetRecord();
                begin
                    //The future annual Premium
                    PllAmount := 0;
                    FutureAnnualPremium := 0;
                    ComprehensivePremiumAmount := 0;
                    PremTableLines.RESET;
                    PremTableLines.SETRANGE(PremTableLines."Policy Type", "Policy Type");
                    PremTableLines.SETRANGE(PremTableLines."Seating Capacity", "Insure Lines"."Seating Capacity");
                    PremTableLines.FINDFIRST;
                    IF PremTableLines."PPL Cost Per PAX" <> 0 THEN BEGIN
                        PllAmount := PremTableLines."PPL Cost Per PAX" * PremTableLines."Seating Capacity";
                        ComprehensivePremiumAmount := "Insure Lines"."Rate %age" * "Insure Lines"."Sum Insured";
                        FutureAnnualPremium := PremTableLines."Premium Amount" + PllAmount + ComprehensivePremiumAmount;
                    END ELSE BEGIN
                        ComprehensivePremiumAmount := "Insure Lines"."Rate %age" * "Insure Lines"."Sum Insured";
                        FutureAnnualPremium := PremTableLines."Premium Amount" + ComprehensivePremiumAmount;
                    END;
                    //FutureAnnualPremium:= "Insure Header"."Total Net Premium"-40;

                end;
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(Picture);
                AgentContact := '';
                BranchAgent := '';
                "Insure Header".SETRANGE("Insure Header"."No.", "Insure Header"."No.");
                "Insure Header".SETRANGE("Insure Header"."Posting Date", "Insure Header"."Posting Date");
                "Insure Header".FINDLAST;
                "Insure Header".CALCFIELDS("Insure Header"."Total Sum Insured");
                "Insure Header".CALCFIELDS("Total Net Premium");

                GenLedgSetup.GET;
                BranchCode := "Insure Header"."Shortcut Dimension 1 Code";
                IF DimValue.GET(GenLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;
                "Insure Header".CALCFIELDS("Insure Header"."Total Sum Insured");

                //Agent Contact
                IF "Insure Header"."Agent/Broker" <> '' THEN
                    Cust.GET("Insure Header"."Agent/Broker");
                AgentContact := Cust."Phone No.";
                BranchAgent := Cust.Name;
                IF "Insure Header"."Total Net Premium" <> 0 THEN
                    "Insure Header".SETRANGE("Insure Header"."No.");
                "Insure Header".SETRANGE("Insure Header"."Posting Date");
            end;

            trigger OnPreDataItem();
            begin
                VerifyDates();
                "Insure Header".SETRANGE("Insure Header"."Expected Renewal Date", PeriodStartDate, PeriodEndDate);
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
    }

    var
        CompInfor: Record 79;
        AgentContact: Text;
        Cust: Record Customer;
        CustomerName: Text;
        BranchAgent: Text;
        BranchName: Text;
        DimValue: Record "Dimension Value";
        Dimensions: Record 348;
        ClassName: Text;
        GenLedgSetup: Record "General Ledger Setup";
        BranchCode: Code[10];
        FutureAnnualPremium: Decimal;
        ShortCode: Text;
        "Policy type": Record "Policy Type";
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Date value is a future date';
        PremTable: Record "Premium Table";
        PremTableLines: Record "Premium table Lines";
        PllAmount: Decimal;
        ComprehensivePremiumAmount: Decimal;

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

