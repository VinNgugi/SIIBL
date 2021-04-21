page 51513115 "Policy Card CRM"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = Card;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST(Policy));

    layout
    {
        area(content)
        {
            group(Insured)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Document Date"; "Document Date")
                {
                    Editable = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    Editable = false;

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
                    Editable = false;
                }
                field("Insured Name"; "Insured Name")
                {
                    Editable = false;
                }
                field("Agent/Broker"; "Agent/Broker")
                {
                    Editable = false;
                }
                field("Brokers Name"; "Brokers Name")
                {
                    Editable = false;
                }
                field("Policy Status"; "Policy Status")
                {
                }
            }
            group(Cover)
            {
                field("Policy Type"; "Policy Type")
                {
                    Editable = false;
                }
                field("Policy Description"; "Policy Description")
                {
                    Editable = false;
                }
                field("From Date"; "From Date")
                {
                    Caption = 'Policy Start date';
                    Editable = false;
                }
                field("To Date"; "To Date")
                {
                    Caption = 'Policy End Date';
                    Editable = false;
                }
                field("From Time"; "From Time")
                {
                    Editable = false;
                }
                field("To Time"; "To Time")
                {
                    Editable = false;
                }
                field("Cover Start Date"; "Cover Start Date")
                {
                    Editable = false;
                }
                field("Cover End Date"; "Cover End Date")
                {
                    Editable = false;
                }
                field("Payment Mode"; "Payment Mode")
                {
                    Editable = false;
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                    Editable = false;
                }
                field("Premium Financier"; "Premium Financier")
                {
                    Editable = false;
                }
                field("Premium Financier Name"; "Premium Financier Name")
                {
                    Editable = false;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Total Sum Insured"; "Total Sum Insured")
                {
                    Editable = false;
                }
            }
            part("Schedule of Insured List Non E"; "Schedule of Insured List Non E")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
        }
        area(factboxes)
        {
            //Caption = 'Policy Risks';
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
            action("Payment Schedule")
            {
                RunObject = Page "Payment Schedule";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //"Document Type":="Document Type"::Quote;
        "Document Type" := "Document Type"::Policy;
        "Quote Type" := "Quote Type"::New;
        "Cover Type" := "Cover Type"::Individual;
        //MESSAGE('%1',"Quote Type");
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        InsuranceMgnt: Codeunit "Insurance management";
        Quotation: Report "Insurance Quote1";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
}

