report 51513551 "IRA Premiums Report"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/IRA Premiums Report.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = CONST(Policy),
                                      "Action Type" = FILTER(New));
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
            column(InsuredNo_InsureHeader; "Insure Header"."Insured No.")
            {
            }
            column(FamilyName_InsureHeader; "Insure Header"."Family Name")
            {
            }
            column(FirstNamess_InsureHeader; "Insure Header"."First Names(s)")
            {
            }
            column(PolicyType_InsureHeader; "Insure Header"."Policy Type")
            {
            }
            column(PremiumAmount_InsureHeader; "Insure Header"."Premium Amount")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(TotalNetPremium_InsureHeader; "Insure Header"."Total Net Premium")
            {
            }
            column(PolicyDescription_InsureHeader; "Insure Header"."Policy Description")
            {
            }
            column(TotalSumInsured_InsureHeader; "Insure Header"."Total Sum Insured")
            {
            }
            column(NewGrossAmount; NewGrossAmount)
            {
            }
            column(NewSumInsured; NewSumInsured)
            {
            }
            column(RenewGrossAmount; RenewGrossAmount)
            {
            }
            column(RenewSumInsured; RenewSumInsured)
            {
            }
            column(ActionType_InsureHeader; "Insure Header"."Action Type")
            {
            }
            column(No_InsureHeader; "Insure Header"."No.")
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
                /*
                "Insure Header".SETRANGE("Insure Header"."No.", "Insure Header"."No.");
                "Insure Header".SETRANGE("Insure Header"."Posting Date", "Insure Header"."Posting Date");
                "Insure Header".FINDFIRST;
                */
                "Insure Header".CALCFIELDS("Insure Header"."Total Net Premium", "Total Sum Insured");
                /*
                IF "Insure Header"."Action Type"="Insure Header"."Action Type"::New THEN BEGIN
                  NewGrossAmount:="Insure Header"."Total Net Premium";
                  NewSumInsured:="Insure Header"."Total Sum Insured";
                  END;
                
                IF "Insure Header"."Action Type"="Insure Header"."Action Type"::Renewal THEN BEGIN
                  RenewGrossAmount:="Insure Header"."Total Premium Amount";
                  RenewSumInsured:="Insure Header"."Total Sum Insured";
                  END;
                  */

                /*
              "Insure Header".SETRANGE("Insure Header"."No.");
              "Insure Header".SETRANGE("Insure Header"."Posting Date");
              "Insure Header".FINDFIRST;
              */

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

    trigger OnPreReport();
    begin
        CompInfor.CALCFIELDS(Picture);
    end;

    var
        CompInfor: Record 79;
        NewGrossAmount: Decimal;
        RenewGrossAmount: Decimal;
        NewSumInsured: Decimal;
        RenewSumInsured: Decimal;
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

