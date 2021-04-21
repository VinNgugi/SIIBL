report 51513332 "Claim Ratio Per Policy"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Claim Ratio Per Policy.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST(Policy));
            RequestFilterFields = "Renewal Date";
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
            column(PremiumPaymentFrequency_InsureHeader; "Insure Header"."Premium Payment Frequency")
            {
            }
            column(PremiumAmount_InsureHeader; "Insure Header"."Premium Amount")
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
            column(FamilyName_InsureHeader; "Insure Header"."Family Name")
            {
            }
            column(FirstNamess_InsureHeader; "Insure Header"."First Names(s)")
            {
            }
            column(Title_InsureHeader; "Insure Header".Title)
            {
            }
            column(MaritalStatus_InsureHeader; "Insure Header"."Marital Status")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(Sex_InsureHeader; "Insure Header".Sex)
            {
            }
            column(PolicyType_InsureHeader; "Insure Header"."Policy Type")
            {
            }
            column(CoverType_InsureHeader; "Insure Header"."Cover Type")
            {
            }
            column(CoverPeriod_InsureHeader; "Insure Header"."Cover Period")
            {
            }
            column(CoverTypeDescription_InsureHeader; "Insure Header"."Cover Type Description")
            {
            }
            column(CoverEndDate_InsureHeader; "Insure Header"."Cover End Date")
            {
            }
            column(UndewriterName_InsureHeader; "Insure Header"."Underwriter Name")
            {
            }
            column(Underwriter_InsureHeader; "Insure Header".Underwriter)
            {
            }
            column(ExpectedRenewalDate_InsureHeader; "Insure Header"."Expected Renewal Date")
            {
            }
            column(RenewalDate_InsureHeader; "Insure Header"."Renewal Date")
            {
            }
            column(PolicyDescription_InsureHeader; "Insure Header"."Policy Description")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            column(BrokersName_InsureHeader; "Insure Header"."Brokers Name")
            {
            }
            column(ClaimRatio; ClaimRatio)
            {
            }

            trigger OnAfterGetRecord();
            begin

                IF "Insure Header"."Cover Type" = "Insure Header"."Cover Type"::Individual THEN
                    Insured := "Insure Header"."First Names(s)" + ' ' + "Insure Header"."Family Name"
                ELSE
                    Insured := "Insure Header"."Insured Name";
                "Insure Header".CALCFIELDS("Insure Header"."Total Premium Amount");//,"Insure Header"."Claim Amount");
                IF PercentageofPremium <> 0 THEN
                    "Total Premium Amount" := (PercentageofPremium * "Total Premium Amount") / 100;
                IF "Insure Header"."Total Premium Amount" <> 0 THEN
                    // ClaimRatio:=("Insure Header"."Claim Amount"/"Insure Header"."Total Premium Amount")*100;
                    IF "Insure Header"."Agent/Broker" = "Insure Header"."Agent/Broker" THEN
                        "agent Name" := "Insure Header"."Brokers Name";
            end;

            trigger OnPreDataItem();
            begin
                LastFieldNo := FIELDNO("Document Type");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompInfor.GET;
        CompInfor.CALCFIELDS(Picture);
    end;

    var
        CompInfor: Record 79;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Insured: Text[130];
        ClaimRatio: Decimal;
        PercentageofPremium: Decimal;
        "agent Name": Text[280];
        TotalFor: Label '"Total for "';
}

