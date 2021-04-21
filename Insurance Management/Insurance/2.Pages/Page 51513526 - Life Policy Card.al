page 51513526 "Life Policy Card"
{
    // version AES-INS 1.0

    Editable = true;
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
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
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
            action("SendApprovalRequest ")
            {

                trigger OnAction();
                begin
                    //IF ApprovalsMgmt.CheckInsureApprovalsWorkflowEnabled(Rec) THEN
                    //    ApprovalsMgmt.OnSendInsureDocForApproval(Rec);
                end;
            }
            action("CancelApprovalRequest ")
            {

                trigger OnAction();
                begin
                    //ApprovalsMgmt.OnCancelInsureApprovalRequest(Rec);
                end;
            }
            action("Policy Wordings")
            {
                RunObject = Page "Policy Wordings";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Description Type" = FILTER(<> "Schedule of Insured");
                RunPageView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.");
            }
            action("Loadings and Discounts")
            {
                RunObject = Page "Loadings and Discounts";
                RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
            }
            action("Co-insurance")
            {
                RunObject = Page "Co-insurance";
                RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
            }
            action("Re-insurance")
            {
                RunObject = Page Reinsurance;
                RunPageLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
            }
            action("View calculations")
            {
                RunObject = Page "Financial Lines";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
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
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
            action("DMS Link")
            {
                Caption = 'DMS Link';
                Image = Web;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    /*  IF CashSetup.GET THEN BEGIN
                         Link := CashSetup."DMS Policy Details Link" + "No.";

                         HYPERLINK(Link);
                     END; */
                end;
            }
            group(Endorsements)
            {
                Caption = 'Endorsements';
            }
            action("Select All Risks")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    InsuranceMgnt.SelectAllRisks(Rec);
                end;
            }
            action("Un-Select All Risks")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    InsuranceMgnt.UnSelectAllRisks(Rec);
                end;
            }
            action(Extensions)
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    // InsuranceMgnt.Endorsement(Rec);
                    InsuranceMgnt.ExtendPolicyCover(Rec)
                end;
            }
            action("Cancel Policy")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    InsuranceMgnt.CancelPolicyCover(Rec);
                end;
            }
            action("Lapse Policy")
            {
                Promoted = true;
                PromotedCategory = Process;
            }
            action(Addition)
            {
            }
            action("Nil Endorsement")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.NilPolicyCover(Rec);
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

                trigger OnAction();
                begin
                    InsuranceMgnt.SuspendPolicyCover(Rec);
                end;
            }
            action(Reinstatement)
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.ResumePolicyCover(Rec);
                end;
            }
            action(Substitution)
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.SubstitutePolicyCover(Rec);
                end;
            }
            action(Renew)
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.RenewPolicyCover(Rec);
                end;
            }
            action(Revision)
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.RevisePolicyCover(Rec);
                end;
            }
            group("Risk Endorsements")
            {
                Caption = 'Risk Endorsements';
                action("Extend Risk")
                {
                    Caption = 'Extend Risk';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 51513011;
                }
                action("Cancel Risk")
                {
                    Caption = 'Cancel Risk';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 51513012;
                }
                action("Suspend Risk")
                {
                    Caption = 'Suspend Risk';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 51513013;
                }
                action("Reinstate Risk")
                {
                    Caption = 'Reinstate Risk';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 51513014;
                }
                action("Substitute Risk")
                {
                    Caption = 'Substitute Risk';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 51513015;
                }
                action("Revise Risk")
                {
                    Caption = 'Revise Risk';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 51513016;
                }
                action("Nil Endorsement Risk")
                {
                    Caption = 'Nil Endorsement Risk';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 51513017;
                }
                action("Renew Risk")
                {
                    Caption = 'Renew Risk';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 51513018;
                }
                action("Add COMESA Yellow Card")
                {
                    Caption = 'Add COMESA Yellow Card';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 51513019;
                }
                action("Add Extra Covers/Riders")
                {
                    Caption = 'Add Extra Covers/Riders';
                    RunObject = Report 51513020;
                }
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
        CashSetup: Record "Cash Management Setup";
        Link: Text;
}

