page 51513078 "Credit Note Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST("Credit Note"));

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
                field("Policy No"; "Policy No")
                {
                }
                field("Policy Type"; "Policy Type")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field("From Time"; "From Time")
                {
                }
                field("To Time"; "To Time")
                {
                }
                field("Short Term Cover"; "Short Term Cover")
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
                field("Total Premium Amount"; "Total Premium Amount")
                {
                }
                field("Total Tax"; "Total Tax")
                {
                }
                field("Total Net Premium"; "Total Net Premium")
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
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No."),
                              "Description Type" = FILTER(<> "Schedule of Insured");
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
            action(Post)
            {

                trigger OnAction();
                begin
                    //InsuranceMgnt.ConvertQuote2DebitNote(Rec);
                    InsuranceMgnt.PostInsureHeader(Rec);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Document Type" := "Document Type"::"Credit Note";
        "Quote Type" := "Quote Type"::New;
        "Cover Type" := "Cover Type"::Individual;
        //MESSAGE('%1',"Quote Type");
    end;

    var
        ChangeExchangeRate: Page 511;
        InsuranceMgnt: Codeunit "Insurance management";
        Quotation: Report "Insurance Quote1";
}

