page 51513164 "Quote-Group Renewal Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST(Quote),
                            "Quote Type" = CONST(Renewal),
                            "Cover Type" = CONST(Group));

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
                    Caption = 'Inception Date';
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
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Fax No"; "Fax No")
                {
                }
                field("E-mail"; "E-mail")
                {
                }
            }
            group(Cover)
            {
                field(Underwriter; Underwriter)
                {
                }
                field("Underwriter Name"; "Underwriter Name")
                {
                }
                field("Commission Due"; "Commission Due")
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
                field("Follow Up Person"; "Follow Up Person")
                {
                }
                field("Follow Up Date"; "Follow Up Date")
                {
                }
                field("Payment Mode"; "Payment Mode")
                {
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                }
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
                {
                }
                field("Total Sum Insured"; "Total Sum Insured")
                {
                }
                field("Total Premium Amount"; "Total Premium Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Add Vehicles")
            {
                Caption = 'Schedule of Insured Risks';
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
                    //Quotation.GetQuote(Rec);
                    //Quotation.RUN;
                end;
            }
            action("Payment Schedule")
            {
                RunObject = Page "Payment Schedule";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action("Accept Quote")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.AcceptQuote(Rec);
                end;
            }
            action("Send Approval Request")
            {

                trigger OnAction();
                begin
                    //IF ApprovalsMngt.SendInsureApprovalRequest(Rec) THEN
                end;
            }
            action("Cancel Approval Request")
            {

                trigger OnAction();
                begin
                    //IF ApprovalsMngt.CancelInsureApprovalRequest(Rec,TRUE,TRUE) THEN
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Document Type" := "Document Type"::Quote;
        "Quote Type" := "Quote Type"::New;
        "Cover Type" := "Cover Type"::Group;
    end;

    var
        ChangeExchangeRate: page "Change Exchange Rate";
        InsuranceMgnt: Codeunit "Insurance management";
        // Quotation : Report "Insurance Quote-Broker";
        ApprovalsMngt: Codeunit 439;
}

