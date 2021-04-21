page 51513525 "Life Policy List"
{
    // version AES-INS 1.0

    CardPageID = "Life Policy Card";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST(Policy));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
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
                field("Policy Type"; "Policy Type")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field("Quotation No."; "Quotation No.")
                {
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                }
                field("Policy No"; "Policy No")
                {
                    Caption = 'Original Policy No.';
                }
                field("Endorsement Type"; "Endorsement Type")
                {
                }
                field("Action Type"; "Action Type")
                {
                }
                field("Copied from No."; "Copied from No.")
                {
                }
                field("Policy Status"; "Policy Status")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Policy Endorsements")
            {
                Caption = 'Policy Endorsements';
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
            action("Nil Endorsement")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    InsuranceMgnt.NilPolicyCover(Rec);
                end;
            }
            action(Suspension)
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    InsuranceMgnt.SuspendPolicyCover(Rec);
                end;
            }
            action(Reinstatement)
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    InsuranceMgnt.ResumePolicyCover(Rec);
                end;
            }
            action(Substitution)
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    InsuranceMgnt.SubstitutePolicyCover(Rec);
                end;
            }
            action(Renew)
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    InsuranceMgnt.RenewPolicyCover(Rec);
                end;
            }
            action(Revision)
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    InsuranceMgnt.RevisePolicyCover(Rec);
                end;
            }
            action("DMS Link")
            {
                Caption = 'DMS Link';
                Image = Web;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    /* IF CashSetup.GET THEN BEGIN
                        Link := CashSetup."DMS Policy Details Link" + "No.";

                        HYPERLINK(Link);
                    END; */
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
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report 51513020;
                }
            }
            group("Policy Detaills")
            {
                Caption = 'Policy Detaills';
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = false;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDocDim;
                        CurrPage.SAVERECORD;
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
                action("Payment Schedule")
                {
                    RunObject = Page "Payment Schedule";
                    RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                }
                action("Documents Required")
                {
                    RunObject = Page "Insurance Documents";
                    RunPageLink = "Document Type" = FIELD("Document Type"), "Document No" = FIELD("No.");
                }
            }
        }
    }

    var
        InsuranceMgnt: Codeunit "Insurance management";
        CashSetup: Record "Cash Management Setup";
        Link: Text;
}

