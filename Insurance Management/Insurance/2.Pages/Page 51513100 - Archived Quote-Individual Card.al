page 51513100 "Archived Quote-Individual Card"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = Card;
    SourceTable = "Insure Header Archive";

    layout
    {
        area(content)
        {
            group(Insured)
            {
                field("No."; "No.")
                {
                }
                field("Policy Type"; "Policy Type")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field(Underwriter; Underwriter)
                {
                    Caption = 'Insurer';
                }
                field("Undewriter Name"; "Undewriter Name")
                {
                    Caption = 'Insurer Name';
                }
                field("Insured No."; "Insured No.")
                {
                }
                field("Insured Name"; "Insured Name")
                {
                }
                field("Insured Address"; "Insured Address")
                {
                }
                field("Insured Address 2"; "Insured Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field("Country of Residence"; "Country of Residence")
                {
                    Caption = 'Country/State';
                }
                field("Phone No."; "Phone No.")
                {
                    Caption = 'Business Telephone';
                }
                field("E-mail"; "E-mail")
                {
                }
                field("Fax No"; "Fax No")
                {
                }
                field("Commission Due"; "Commission Due")
                {
                    Caption = 'Commission %';
                }
                field("Document Date"; "Document Date")
                {
                    Caption = 'Quotation Date';
                }
                field("Currency Code"; "Currency Code")
                {

                    trigger OnAssistEdit();
                    begin
                        CLEAR(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WORKDATE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("From Date"; "From Date")
                {
                    Caption = 'Policy Start Date';
                }
                field("To Date"; "To Date")
                {
                    Caption = 'Policy End Date';
                }
                field("From Time"; "From Time")
                {
                }
                field("To Time"; "To Time")
                {
                }
                field("Payment Mode"; "Payment Mode")
                {
                    Caption = 'Premium Payment Type';
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                    Caption = 'Payment Frequency';
                }
                field("Follow Up Person"; "Follow Up Person")
                {
                }
                field("Follow Up Date"; "Follow Up Date")
                {
                }
                field("Total Premium Amount"; "Total Premium Amount")
                {
                }
                field("Total Tax"; "Total Tax")
                {
                }
                field("Total Sum Insured"; "Total Sum Insured")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Policy Wordings")
            {
                Image = ViewDescription;
                RunObject = Page "Policy Wordings";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No."),
                              "Description Type" = FILTER(<> "Schedule of Insured");
                RunPageView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.");
            }
            action("Loadings and Discounts")
            {
                RunObject = Page "Loadings and Discounts";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "No." = FIELD("No.");
            }
            action("Co-insurance")
            {
                RunObject = Page "Co-insurance";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "No." = FIELD("No.");
            }
            action("Re-insurance")
            {
                RunObject = Page Reinsurance;
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "No." = FIELD("No.");
            }
            action("View calculations")
            {
                RunObject = Page "Financial Lines";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action(Quote)
            {

                trigger OnAction();
                begin
                    //Quotation.GetQuote(Rec);
                    // Quotation.RUN;
                end;
            }
            action("Payment Schedule")
            {
                RunObject = Page "Payment Schedule";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action("Generate Policy ")
            {

                trigger OnAction();
                begin
                    //InsuranceMgnt.ConvertQuote2Policy(Rec);
                    //InsuranceMgnt.ConvertQuote2DebitNote(Rec);
                end;
            }
            action("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Insured List CRM";
                // RunPageLink = "No." = FIELD("Document Type"), Name = FIELD("No."), City = CONST(0);
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Document Type" := "Document Type"::Quote;
        "Quote Type" := "Quote Type"::New;
        "Cover Type" := "Cover Type"::Individual;
    end;

    var
        ChangeExchangeRate: Page 511;
        InsuranceMgnt: Codeunit "Insurance management";
        //Quotation: Report "Insurance Quote-Broker";
        ApprovalsMngt: Codeunit "Approvals Mgmt.";
}

