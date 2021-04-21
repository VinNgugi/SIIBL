page 51513161 "Policy Card-Archive Individual"
{
    // version AES-INS 1.0

    Editable = true;
    PageType = Card;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST(Policy), "Cover Type" = CONST(Individual), "Policy Status" = FILTER(<> Live));

    layout
    {
        area(content)
        {
            group(Insured)
            {
                field("No."; "No.")
                {
                }
                field("Document Date"; "Document Date")
                {
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
                field("Insured No."; "Insured No.")
                {
                }
                field("Insured Name"; "Insured Name")
                {
                }
                field("Agent/Broker"; "Agent/Broker")
                {
                }
                field("Brokers Name"; "Brokers Name")
                {
                }
                field("Commission Payable 1"; "Commission Payable 1")
                {
                }
            }
            group(Cover)
            {
                field("Policy Status"; "Policy Status")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field("From Date"; "From Date")
                {
                    Caption = 'Policy Start date';
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
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
                {
                }
                field("Payment Mode"; "Payment Mode")
                {
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                }
                field("Premium Financier"; "Premium Financier")
                {
                }
                field("Premium Financier Name"; "Premium Financier Name")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
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
                RunObject = Page "Policy Wordings";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Description Type" = FILTER(<> "Schedule of Insured");
                RunPageView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.");
            }
            action("Add Vehicles")
            {
                RunObject = Page "Schedule of Insured List";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action("Loadings and Discounts")
            {
                RunObject = Page "Loadings and Discounts";
                RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
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
            action("Calculate Premium")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.InsertTaxesReinsurance(Rec);
                end;
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
                    Quotation.GetQuote(Rec);
                    Quotation.RUN;
                end;
            }
            action("Payment Schedule")
            {
                RunObject = Page "Payment Schedule";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            group(Endorsements)
            {
                Caption = 'Endorsements';
            }
            action("Issue Cover")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.GenerateFirstCover(Rec);
                end;
            }
            action("Cover List")
            {
            }
            action("Additions/Extensions")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.Endorsement(Rec);
                end;
            }
            action("Cancel Policy")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.CancelPolicy(Rec);
                end;
            }
            action("Lapse Policy")
            {
            }
            action(Addition)
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.Endorsement(Rec);
                end;
            }
            action("Nil Endorsement")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.Endorsement(Rec);
                end;
            }
            action(Deletion)
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.PolicyDeletion(Rec);
                end;
            }
            action(Suspension)
            {
            }
            action(Substitution)
            {
            }
            action(Renew)
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.RenewPolicy(Rec);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Document Type" := "Document Type"::Quote;
        "Quote Type" := "Quote Type"::New;
        "Cover Type" := "Cover Type"::Individual;
        //MESSAGE('%1',"Quote Type");
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        InsuranceMgnt: Codeunit "Insurance management";
        Quotation: Report "Insurance Quote1";
}

