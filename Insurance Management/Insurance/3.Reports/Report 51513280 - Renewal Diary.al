report 51513280 "Renewal Diary"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Renewal Diary.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST(Policy));
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
            column(FamilyName_InsureHeader; "Insure Header"."Family Name")
            {
            }
            column(FirstNamess_InsureHeader; "Insure Header"."First Names(s)")
            {
            }
            column(PremiumPaymentFrequency_InsureHeader; "Insure Header"."Premium Payment Frequency")
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
            column(ExcludefromRenewal_InsureHeader; "Insure Header"."Exclude from Renewal")
            {
            }
            column(BrokersName_InsureHeader; "Insure Header"."Brokers Name")
            {
            }
            column(UndewriterName_InsureHeader; "Insure Header"."Underwriter Name")
            {
            }
            column(InsuranceType_InsureHeader; "Insure Header"."Insurance Type")
            {
            }
            column(PremiumAmount_InsureHeader; "Insure Header"."Premium Amount")
            {
            }
            column(EffectiveStartdate_InsureHeader; "Insure Header"."Effective Start date")
            {
            }
            column(ExcessLevel_InsureHeader; "Insure Header"."Excess Level")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(QuoteType_InsureHeader; "Insure Header"."Quote Type")
            {
            }
            column(PaymentMethod_InsureHeader; "Insure Header"."Payment Method")
            {
            }
            column(CoverType_InsureHeader; "Insure Header"."Cover Type")
            {
            }
            column(TotalPremiumAmount_InsureHeader; "Insure Header"."Total Premium Amount")
            {
            }
            column(TotalDiscountAmount_InsureHeader; "Insure Header"."Total  Discount Amount")
            {
            }
            column(TotalCommissionDue_InsureHeader; "Insure Header"."Total Commission Due")
            {
            }
            column(TotalCommissionOwed_InsureHeader; "Insure Header"."Total Commission Owed")
            {
            }
            column(TotalTrainingLevy_InsureHeader; "Insure Header"."Total Training Levy")
            {
            }
            column(TotalStampDuty_InsureHeader; "Insure Header"."Total Stamp Duty")
            {
            }
            column(TotalTax_InsureHeader; "Insure Header"."Total Tax")
            {
            }
            column(FromDate_InsureHeader; "Insure Header"."From Date")
            {
            }
            column(ToDate_InsureHeader; "Insure Header"."To Date")
            {
            }
            column(FromTime_InsureHeader; "Insure Header"."From Time")
            {
            }
            column(ToTime_InsureHeader; "Insure Header"."To Time")
            {
            }
            column(PolicyStatus_InsureHeader; "Insure Header"."Policy Status")
            {
            }
            column(ExpectedRenewalDate_InsureHeader; "Insure Header"."Expected Renewal Date")
            {
            }
            column(ExpectedRenewalTime_InsureHeader; "Insure Header"."Expected Renewal Time")
            {
            }
            column(ModificationType_InsureHeader; "Insure Header"."Modification Type")
            {
            }
            column(PolicyClass_InsureHeader; "Insure Header"."Policy Class")
            {
            }
            column(CoverPeriod_InsureHeader; "Insure Header"."Cover Period")
            {
            }
            column(PaymentMode_InsureHeader; "Insure Header"."Payment Mode")
            {
            }
            column(TotalNetPremium_InsureHeader; "Insure Header"."Total Net Premium")
            {
            }
            column(CreatedBy_InsureHeader; "Insure Header"."Created By")
            {
            }
            column(FollowUpPerson_InsureHeader; "Insure Header"."Follow Up Person")
            {
            }
            column(FollowUpDate_InsureHeader; "Insure Header"."Follow Up Date")
            {
            }
            column(RenewalDate_InsureHeader; "Insure Header"."Renewal Date")
            {
            }
            column(VesselName_InsureHeader; "Insure Header"."Vessel Name")
            {
            }
            column(ModeofConveyance_InsureHeader; "Insure Header"."Mode of Conveyance")
            {
            }
            column(ResponsePeriod_InsureHeader; "Insure Header"."Response Period")
            {
            }
            column(PolicyDescription_InsureHeader; "Insure Header"."Policy Description")
            {
            }
            column(CoverTypeDescription_InsureHeader; "Insure Header"."Cover Type Description")
            {
            }
            column(TotalSumInsured_InsureHeader; "Insure Header"."Total Sum Insured")
            {
            }
            column(OrderHereon_InsureHeader; "Insure Header"."Order Hereon")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            column(IDPassportNo_InsureHeader; "Insure Header"."ID/Passport No.")
            {
            }
            column(PINNo_InsureHeader; "Insure Header"."PIN No.")
            {
            }
            column(PostingDate_InsureHeader; "Insure Header"."Posting Date")
            {
            }
            column(DocumentDate_InsureHeader; "Insure Header"."Document Date")
            {
            }
            column(NoOfInstalments_InsureHeader; "Insure Header"."No. Of Instalments")
            {
            }
            column(PremiumFinancier_InsureHeader; "Insure Header"."Premium Financier")
            {
            }
            column(PremiumFinancierName_InsureHeader; "Insure Header"."Premium Financier Name")
            {
            }
            column(InsuredAddress_InsureHeader; "Insure Header"."Insured Address")
            {
            }
            column(InsuredAddress2_InsureHeader; "Insure Header"."Insured Address 2")
            {
            }
            column(PostCode_InsureHeader; "Insure Header"."Post Code")
            {
            }
            column(QuotationNo_InsureHeader; "Insure Header"."Quotation No.")
            {
            }
            column(CoverStartDate_InsureHeader; "Insure Header"."Cover Start Date")
            {
            }
            column(CoverEndDate_InsureHeader; "Insure Header"."Cover End Date")
            {
            }
            column(Posted_InsureHeader; "Insure Header".Posted)
            {
            }
            column(PostedBy_InsureHeader; "Insure Header"."Posted By")
            {
            }
            column(PostedDateTime_InsureHeader; "Insure Header"."Posted DateTime")
            {
            }
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
}

