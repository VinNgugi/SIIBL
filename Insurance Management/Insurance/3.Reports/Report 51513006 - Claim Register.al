report 51513006 "Claim Register"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Claim Register.rdl';

    dataset
    {
        dataitem("Claim"; "Claim")
        {
            DataItemTableView = SORTING("Claim No");
            RequestFilterFields = "Date of Occurence", "Date Reported", "When Reported";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Claim__Name_of_Insured_; Claim."Name of Insured")
            {
            }
            column(Class_Claim; Claim.Class)
            {
            }
            column(ShortCode; ShortCode)
            {
            }
            column(Claim__Date_of_Occurence_; "Date of Occurence")
            {
            }
            column(Claim__Claim_Amount_; "Claim Amount")
            {
            }
            column(Claim__Amount_Settled_; "Amount Settled")
            {
            }
            column(Claim_Claim_Particulars; Claim.Particulars)
            {
            }
            column(Claim_Excess; Excess)
            {
            }
            column(Claim__Claim_No_; "Claim No")
            {
            }
            column(TAT_Claim; Claim."Est. Cost of Repairs")
            {
            }
            column(CLAIM_REGISTERCaption; CLAIM_REGISTERCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(InsuredCaption; InsuredCaptionLbl)
            {
            }
            column(Policy_ClassCaption; Policy_ClassCaptionLbl)
            {
            }
            column(Claim__Date_of_Occurence_Caption; FIELDCAPTION("Date of Occurence"))
            {
            }
            column(Claim__Claim_Amount_Caption; FIELDCAPTION("Claim Amount"))
            {
            }
            column(Claim__Amount_Settled_Caption; FIELDCAPTION("Amount Settled"))
            {
            }
            column(Particulars_of_ClaimCaption; Particulars_of_ClaimCaptionLbl)
            {
            }
            column(Claim_ExcessCaption; FIELDCAPTION(Excess))
            {
            }
            column(Claim__Claim_No_Caption; FIELDCAPTION("Claim No"))
            {
            }
            column(WhenReported_Claim; Claim."When Reported")
            {
            }
            column(DateofLoss_Claim; Claim."Date of Occurence")
            {
            }
            column(DateReported_Claim; Claim."Date Reported")
            {
            }
            column(DateSettled_Claim; Claim."Date Reported")
            {
            }
            column(DateReportedtoUs_Claim; Claim."Date of Notification")
            {
            }
            column(DateReportedtoInsurer_Claim; Claim."Date of Notification")
            {
            }
            column(ClaimStatus_Claim; Claim."Claim Status")
            {
            }
            column(Comments_Claim; Claim."Memorandum Address")
            {
            }
            column(Status_Claim; Claim."Claim Status")
            {
            }
            column(InsuranceClaimStatus_Claim; Claim."Payment Status")
            {
            }

            trigger OnAfterGetRecord();
            begin
                ShortCode := '';
                IF PolicyRec.GET(Claim.Class) THEN
                    ShortCode := PolicyRec."short code";

                /*IF Claim."Date Reported to Us"<>0D THEN
                IF Claim."Date Settled"<>0D THEN
                TAT:="Date Settled"-"Date Reported to Us"
                ELSE
                TAT:=0;*/

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

    var
        ShortCode: Text[30];
        PolicyRec: Record "Policy Type";
        CLAIM_REGISTERCaptionLbl: Label 'CLAIM REGISTER';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        InsuredCaptionLbl: Label 'Insured';
        Policy_ClassCaptionLbl: Label 'Policy Class';
        Particulars_of_ClaimCaptionLbl: Label 'Particulars of Claim';
}

