report 51513567 "Tax and Commission"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Tax and Commission.rdl';

    dataset
    {
        dataitem(Treaty; Treaty)
        {
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
            column(TreatyCode_Treaty; Treaty."Treaty Code")
            {
            }
            column(Treatydescription_Treaty; Treaty."Treaty description")
            {
            }
            column(AddendumCode_Treaty; Treaty."Addendum Code")
            {
            }
            column(Broker_Treaty; Treaty.Broker)
            {
            }
            column(BrokerName_Treaty; Treaty."Broker Name")
            {
            }
            column(BrokerCommision_Treaty; Treaty."Broker Commision")
            {
            }
            column(Cashcalllimit_Treaty; Treaty."Cash call limit")
            {
            }
            column(QuotashareRetention_Treaty; Treaty."Quota share Retention")
            {
            }
            column(SurplusRetention_Treaty; Treaty."Surplus Retention")
            {
            }
            column(Insurerquotapercentage_Treaty; Treaty."Insurer quota percentage")
            {
            }
            column(Premiunreservepercentage_Treaty; Treaty."Premiun reserve percentage")
            {
            }
            column(MinimumPremiumDepositMDP_Treaty; Treaty."Minimum Premium Deposit(MDP)")
            {
            }
            column(AutomaticCoverLimit_Treaty; Treaty."Automatic Cover Limit")
            {
            }
            column(PremiumRate_Treaty; Treaty."Premium Rate")
            {
            }
            column(QuotashareRetention1_Treaty; Treaty."Quota share Retention1")
            {
            }
            column(SurplusRetention1_Treaty; Treaty."Surplus Retention1")
            {
            }
            column(Cedantquotapercentage_Treaty; Treaty."Cedant quota percentage")
            {
            }
            column(RenewalBrokerCommision_Treaty; Treaty."Renewal Broker Commision")
            {
            }
            column(ActualPremium_Treaty; Treaty."Actual Premium")
            {
            }
            dataitem("Treaty Reinsurance Share"; "Treaty Reinsurance Share")
            {
                DataItemLink = "Treaty Code" = FIELD("Treaty Code"),
                               "Addendum Code" = FIELD("Addendum Code"),
                               "Excess of loss" = FIELD("Exess of loss");
                DataItemTableView = SORTING("Treaty Code", "Addendum Code", "Quota Share", Facultative, "Excess of loss", Surplus, "Re-insurer code")
                                    WHERE("Excess of loss" = CONST(True));
                column(TreatyCode_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Treaty Code")
                {
                }
                column(QuotaShare_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Quota Share")
                {
                }
                column(ReinsurerName_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Re-insurer Name")
                {
                }
                column(Percentage_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Percentage %")
                {
                }
                column(AddendumCode_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Addendum Code")
                {
                }
                column(QSAmount_TreatyReinsuranceShare; "Treaty Reinsurance Share"."QS Amount")
                {
                }
                column(SurplusAmount_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Surplus Amount")
                {
                }
                column(FacultativeAmount_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Facultative Amount")
                {
                }
                column(Amount_TreatyReinsuranceShare; "Treaty Reinsurance Share".Amount)
                {
                }
                column(PremiumLCY_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Premium (LCY)")
                {
                }
                column(DirectPremium_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Direct Premium")
                {
                }
                column(CommissionNetofTaxes_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Commission Net of Taxes")
                {
                }
                column(ReinsurancePremiumTax_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Reinsurance Premium Tax")
                {
                }
                column(ReinsuranceCeded_TreatyReinsuranceShare; "Treaty Reinsurance Share"."Reinsurance Ceded")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    "Treaty Reinsurance Share".CALCFIELDS("Treaty Reinsurance Share"."Reinsurance Premium Tax", "Treaty Reinsurance Share"."Commission Net of Taxes", "Treaty Reinsurance Share"."Direct Premium", "Reinsurance Ceded");
                end;

                trigger OnPreDataItem();
                begin
                    //"Treaty Reinsurance Share".CALCFIELDS(
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(Picture);
                Treaty.CALCFIELDS("Actual Premium");
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
        CompInfor: Record 79;
}

