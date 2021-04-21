xmlport 51513000 PolicyType
{
    // version AES-INS 1.0

    Format = VariableText;

    schema
    {
        textelement(PolicyImportExport)
        {
            tableelement("Policy Type"; "Policy Type")
            {
                XmlName = 'PolicyType';
                fieldelement(Code; "Policy Type".Code)
                {
                }
                fieldelement(Desc; "Policy Type".Description)
                {
                }
                fieldelement(Quote_Rpt_ID; "Policy Type"."Quote Report ID")
                {
                }
                fieldelement(Policy_Rpt_Id; "Policy Type"."Policy Report ID")
                {
                }
                textelement(pclass)
                {
                    XmlName = 'Policy_Class';
                }
                fieldelement(DefaultINsType; "Policy Type"."Default Insurance Type")
                {
                }
                fieldelement(DefaultArea; "Policy Type"."Default Area Code")
                {
                }
                fieldelement(Default_PremiumPay; "Policy Type"."Default Premium Payment")
                {
                }
                fieldelement(Default_excess; "Policy Type"."Default Excess")
                {
                }
                fieldelement(CountryDet; "Policy Type"."Country Determines Area")
                {
                }
                fieldelement(form_Ind; "Policy Type"."Quote Form ID-Individual")
                {
                }
                fieldelement(form_comp; "Policy Type"."Quote Form ID-Company")
                {
                }
                fieldelement(firm_ind; "Policy Type"."Firm Order Form ID-Individual")
                {
                }
                fieldelement(firm_comp; "Policy Type"."Firm Order Form ID-Company")
                {
                }
                fieldelement(policy_ind; "Policy Type"."Policy Form ID-Individual")
                {
                }
                fieldelement(Policy_comp; "Policy Type"."Policy Form ID-Company")
                {
                }
                fieldelement(NoQuotes; "Policy Type"."No. of Quotes")
                {
                }
                fieldelement(NoFirm; "Policy Type"."No. of Firm Orders")
                {
                }
                fieldelement(NoPolicies; "Policy Type"."No. of Policies")
                {
                }
                fieldelement(NoClaimsPaid; "Policy Type"."No. of Claims Paid")
                {
                }
                fieldelement(NoClaimsRejected; "Policy Type"."No. of Claims Rejected")
                {
                }
                fieldelement(PremiumCalc; "Policy Type"."Premium Calculation")
                {
                }
                fieldelement(SchedSubform; "Policy Type"."Schedule Subform")
                {
                }
                fieldelement(actype; "Policy Type"."Account Type")
                {
                }
                fieldelement(accno; "Policy Type"."Account No")
                {
                }
                fieldelement(comm_Percent; "Policy Type"."Commision % age(SIIBL)")
                {
                }
                fieldelement(comm_amt; "Policy Type"."Commission Amount")
                {
                }
                fieldelement(non_renew; "Policy Type"."Non Renewable")
                {
                }
                fieldelement(period; "Policy Type".Period)
                {
                }
                fieldelement(startTime; "Policy Type"."Start Time")
                {
                }
                fieldelement(endtime; "Policy Type"."End Time")
                {
                }
                fieldelement(FirstLoss; "Policy Type"."First Loss %")
                {
                }
                fieldelement(opencover; "Policy Type"."Open Cover")
                {
                }
                fieldelement(Shortname; "Policy Type"."Short Name")
                {
                }
                fieldelement(type; "Policy Type".Type)
                {
                }
                fieldelement(rating; "Policy Type".Rating)
                {
                }
                fieldelement(conveyance; "Policy Type".Conveyance)
                {
                }
                fieldelement(shortCode; "Policy Type"."short code")
                {
                }
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
}

