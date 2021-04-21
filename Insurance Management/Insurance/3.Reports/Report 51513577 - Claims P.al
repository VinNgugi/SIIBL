report 51513577 "Claims P"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Claims P.rdl';

    dataset
    {
        dataitem(Payments; Payments1)
        {
            DataItemTableView = WHERE(Posted = CONST(True));
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
            column(PolicyNo; PolicyNo)
            {
            }
            column(Description; Description)
            {
            }
            column(TotalCheqPayments; TotalCheqPayments)
            {
            }
            column(CauseDescription; CauseDescription)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(ClassName; ClassName)
            {
            }
            column(Payee; Payee)
            {
            }
            column(ClaimNo; ClaimNo)
            {
            }
            column(ChequeNo; ChequeNo)
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEndDate; PeriodEndDate)
            {
            }
            column(DateofLoss; DateofLoss)
            {
            }
            column(NameofInsured; NameofInsured)
            {
            }
            column(No_Payments; Payments.No)
            {
            }
            column(Date_Payments; Payments.Date)
            {
            }
            column(PayMode_Payments; Payments."Pay Mode")
            {
            }
            column(DatePosted_Payments; Payments."Date Posted")
            {
            }
            column(Payee_Payments; Payments.Payee)
            {
            }
            column(TotalAmount_Payments; Payments."Total Amount")
            {
            }
            column(ChequeNo_Payments; Payments."Cheque No")
            {
            }
            dataitem("PV Lines"; "PV Lines1")
            {
                DataItemLink = "PV No" = FIELD(No);
                column(PVNo_PVLines1; "PV Lines"."PV No")
                {
                }
                column(ClaimNo_PVLines1; "PV Lines"."Claim No")
                {
                }
                column(ClaimantID_PVLines1; "PV Lines"."Claimant ID")
                {
                }
                column(PolicyNo_PVLines1; "PV Lines"."Policy No")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    NameofInsured := '';
                    DateofLoss := 0D;
                    Description := '';
                    CauseDescription := '';
                    ClassName := '';
                    PolicyNo := '';
                    ChequeNo := '';
                    Payee := '';
                    ClaimNo := '';
                    DateofLoss := 0D;
                    Claim.RESET;
                    Claim.SETRANGE(Claim."Claim No", "PV Lines"."Claim No");
                    IF Claim.FINDFIRST THEN BEGIN
                        NameofInsured := Claim."Name of Insured";
                        DateofLoss := Claim."Date of Occurence";
                        Description := Claim."Loss Type Description";
                        TotalCheqPayments := Claim."Amount Settled";
                        ClaimNo := Claim."Claim No";
                        CauseDescription := Claim."Cause Description";
                        ClassName := Claim."Class Description";
                        //  MESSAGE('%1',Claim."Class Description");
                        PolicyNo := Claim."Policy No";
                    END;

                    GenLedgSetup.GET;
                    BranchCode := Payments."Global Dimension 1 Code";
                    IF DimValue.GET(GenLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                        BranchName := DimValue.Name;
                end;
            }

            trigger OnPreDataItem();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(Picture);
                Payments.SETRANGE("Date Posted", PeriodStartDate, PeriodEndDate);
                RecPay.RESET;
                RecPay.SETRANGE(RecPay.Code, Payments.Type);
                IF RecPay.FINDFIRST THEN BEGIN
                    IF RecPay."Insurance Trans Type" <> RecPay."Insurance Trans Type"::"Claim Payment" THEN
                        CurrReport.SKIP;
                END;
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
        MonthlyClaimsLbl = 'MONTHLY CLAIMS REGISTER'; ReportTitleLbl = 'CLAIMS PAID';
    }

    var
        AgentContact: Text;
        Cust: Record Customer;
        ClaimNo: Text;
        PolicyNo: Text;
        DateofLoss: Date;
        Description: Text;
        Claim: Record Claim;
        NameofInsured: Text;
        TotalCheqPayments: Decimal;
        CauseDescription: Text;
        BranchName: Text;
        DimValue: Record "Dimension Value";
        Dimensions: Record 348;
        ClassName: Text;
        GenLedgSetup: Record "General Ledger Setup";
        PolicyType: Integer;
        BranchCode: Code[10];
        ChequeNo: Code[10];
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        Insured: Text;
        RecPay: Record 51511002;
        RecDescription: Code[30];
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Date value is a future date';
        CompInfor: Record 79;

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

