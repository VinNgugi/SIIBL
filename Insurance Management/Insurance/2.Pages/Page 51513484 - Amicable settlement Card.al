page 51513484 "Amicable settlement Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Claim Letters";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("External Reference No."; "External Reference No.")
                {
                    Editable = false;
                }
                field("Claim No."; "Claim No.")
                {
                    Editable = false;
                }
                field("Claimant ID"; "Claimant ID")
                {
                    Editable = false;
                }
                field("Claimant Name"; "Claimant Name")
                {
                    Editable = false;
                }
                field("Received by"; "Received by")
                {
                    Editable = false;
                }
                field("Received Date"; "Received Date")
                {
                    Editable = false;
                }
                field("Received Time"; "Received Time")
                {
                }
                field("Negotiated Agreement Date"; "Negotiated Agreement Date")
                {
                    Editable = true;
                }
                field("Demand Amount"; "Demand Amount")
                {
                }
                field("TP Offer"; "TP Offer")
                {
                }
                field("Our Offer"; "Our Offer")
                {
                }
                field("Agreed Settlement Amount"; "Agreed Settlement Amount")
                {
                }
                field("No. of Instalments"; "No. of Instalments")
                {
                }
                field("Reserve Link"; "Reserve Link")
                {
                }
            }
            part("Amicable settlement instalment"; "Amicable settlement instalment")
            {
                SubPageLink = "Document No." = FIELD("No."),
                              "Document Type" = CONST("Amicable Settlements");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Discharge Voucher")
            {
                Image = Answers;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    ClaimLetter.RESET;
                    ClaimLetter.SETRANGE(ClaimLetter."No.", "No.");
                    IF ClaimLetter.FINDFIRST THEN
                        REPORT.RUN(51513571, TRUE, TRUE, ClaimLetter);
                end;
            }
            action("Adjust Reserves")
            {
                Image = Answers;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    InsMgnt.TransferAmicableSettlemnt2Reserve(Rec);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Letter Type" := "Letter Type"::"Demand Letter";
    end;

    var
        InsMgnt: Codeunit "Insurance management";
        DischargeVoucher: Report "Discharge Voucher";
        ClaimLetter: Record "Claim Letters";
}

