report 51513571 "Discharge Voucher"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Discharge Voucher.rdl';

    dataset
    {
        dataitem("Claim Letters"; "Claim Letters")
        {
            column(ClaimantName_ClaimLetters; "Claim Letters"."Claimant Name")
            {
            }
            column(No_ClaimLetters; "Claim Letters"."No.")
            {
            }
            column(ExternalReferenceNo_ClaimLetters; "Claim Letters"."External Reference No.")
            {
            }
            column(NegotiatedAgreementDate_ClaimLetters; "Claim Letters"."Negotiated Agreement Date")
            {
            }
            column(TPOffer_ClaimLetters; "Claim Letters"."TP Offer")
            {
            }
            column(OurOffer_ClaimLetters; "Claim Letters"."Our Offer")
            {
            }
            column(AgreedSettlementAmount_ClaimLetters; "Claim Letters"."Agreed Settlement Amount")
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
}

