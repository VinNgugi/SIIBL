report 51513503 "Expired Policies"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Expired Policies.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = FILTER(Policy),
                                      "Policy No" = FILTER(<> ''),
                                      "Total Net Premium" = FILTER(<> 0));
            RequestFilterFields = "Shortcut Dimension 1 Code", "To Date", "Agent/Broker", "Policy Type";
            column(CompInfor_PictureCaption; CompInfor.Picture)
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
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(CustomerName_Caption; CustomerName)
            {
            }
            column(ExpectedRenewalDate_InsureHeader; "Insure Header"."Expected Renewal Date")
            {
            }
            column(RenewalDate_InsureHeader; "Insure Header"."Renewal Date")
            {
            }
            column(TotalSumInsured_InsureHeader; "Insure Header"."Total Sum Insured")
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
            column(DocumentDate_InsureHeader; "Insure Header"."Document Date")
            {
            }
            column(PolicyClass_InsureHeader; "Insure Header"."Policy Class")
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(ClassName; ClassName)
            {
            }
            column(ShortCode; ShortCode)
            {
            }
            column(AgentMobile; AgentMobile)
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
                                    WHERE("Description Type" = CONST("Schedule of Insured"),
                                          "Registration No." = FILTER(<> ''),
                                          "Document Type" = FILTER(Policy));
                column(DocumentType_InsureLines; "Insure Lines"."Document Type")
                {
                }
                column(DocumentNo_InsureLines; "Insure Lines"."Document No.")
                {
                }
                column(PolicyType_InsureLines; "Insure Lines"."Policy Type")
                {
                }
                column(PremiumAmount_InsureLiness; "Insure Lines"."Premium Amount")
                {
                }
                column(PolicyNo_InsureLines; "Insure Lines"."Policy No")
                {
                }
                column(PremiumPayment_InsureLines; "Insure Lines"."Premium Payment")
                {
                }
                column(SumInsured_InsureLines; "Insure Lines"."Sum Insured")
                {
                }
                column(NetPremium_InsureLines; "Insure Lines"."Net Premium")
                {
                }
                column(RegistrationNo_InsureLines; "Insure Lines"."Registration No.")
                {
                }
                column(SeatingCapacity_InsureLines; "Insure Lines"."Seating Capacity")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                "Insure Header".SETRANGE("Insure Header"."No.", "Insure Header"."No.");
                "Insure Header".SETRANGE("Insure Header"."Posting Date", "Insure Header"."Posting Date");
                "Insure Header".FINDLAST;
                "Insure Header".CALCFIELDS("Insure Header"."Total Net Premium");
                "Insure Header".CALCFIELDS("Insure Header"."Total Sum Insured");
                CompInfor.GET;

                CompInfor.CALCFIELDS(CompInfor.Picture);
                IF PolicyType.GET("Policy Type") THEN
                    ShortCode := PolicyType.Description;
                //Branch
                GenLedgSetup.GET;
                BranchCode := "Insure Header"."Shortcut Dimension 1 Code";
                IF DimValue.GET(GenLedgSetup."Global Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;

                Cust.SETRANGE(Cust."No.", "Insure Header"."Insured No.");
                IF Cust.FINDLAST THEN
                    CustomerName := Cust.Name;

                Cust.RESET;
                Cust.SETRANGE(Cust."No.", "Insure Header"."Agent/Broker");
                IF Cust.FIND('-') THEN BEGIN
                    AgentMobile := Cust."Phone No.";
                    BranchAgent := Cust.Name;
                END;
                "Insure Header".CALCFIELDS("Insure Header"."Total Sum Insured");
                "Insure Header".SETRANGE("Insure Header"."No.");
                "Insure Header".SETRANGE("Insure Header"."Posting Date");
            end;

            trigger OnPreDataItem();
            begin
                "Insure Header".SETRANGE("Insure Header"."To Date", PeriodStartDate, PeriodEndDate);
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
        GenLedgSetup: Record "General Ledger Setup";
        BranchCode: Code[30];
        PolicyType: Record "Policy Type";
        ShortCode: Code[30];
        Yesterday: Date;
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

