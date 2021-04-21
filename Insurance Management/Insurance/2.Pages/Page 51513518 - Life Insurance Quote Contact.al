page 51513518 "Life Insurance Quote Contact"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST(Quote), "Quote Type" = CONST(New));

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
                field("Contact No."; "Contact No.")
                {
                }
                field("Contact Name"; "Contact Name")
                {
                }
                field("Campaign No."; "Campaign No.")
                {
                }
                field("Opportunity No."; "Opportunity No.")
                {
                }
                field("Agent/Broker"; "Agent/Broker")
                {
                }
                field("Brokers Name"; "Brokers Name")
                {
                }
                field("Source of Business"; "Source of Business")
                {
                }
                field("Source of Business Type"; "Source of Business Type")
                {
                }
                field("Source of Business No."; "Source of Business No.")
                {
                }
                field("Business Source Name"; "Business Source Name")
                {
                }
            }
            group(Cover)
            {
                field("Policy Type"; "Policy Type")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field(Term; Term)
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
                field("Payment Mode"; "Payment Mode")
                {
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                }
                field("No. Of Cover Periods"; "No. Of Cover Periods")
                {
                }
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
                {
                }
                field("Premium Financier"; "Premium Financier")
                {
                }
                field("Premium Financier Name"; "Premium Financier Name")
                {
                }
                field("Premium Finance %"; "Premium Finance %")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field("Short Term Cover"; "Short Term Cover")
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
                field(Status; Status)
                {
                }
            }
            part("Schedule of Insured List Edit"; "Schedule of Insured List Edit")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Quote")
            {
                Caption = '&Quote';
                Image = Quote;
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction();
                    begin
                        /*CalcInvDiscForHeader;*/
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Sales Statistics", Rec);

                    end;
                }
                action("Customer Card")
                {
                    Caption = 'Customer Card';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Insured No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("C&ontact Card")
                {
                    Caption = 'C&ontact Card';
                    Image = Card;
                    RunObject = Page "Contact Card";
                    RunPageLink = "No." = FIELD("Contact No.");
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }

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
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction();
                    var
                        ApprovalEntries: Page 658;
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Insure Header", "Document Type", "No.");
                        ApprovalEntries.RUN;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    //DocPrint.PrintInsureHeader(Rec);
                end;
            }
            action(Email)
            {
                Caption = 'Email';
                Image = Email;

                trigger OnAction();
                begin
                    //DocPrint.EmailInsureHeader(Rec);
                end;
            }
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction();
                    var
                        ReleaseSalesDoc: Codeunit 414;
                    begin
                        //ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction();
                    var
                        ReleaseSalesDoc: Codeunit 414;
                    begin
                        //ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group(Create)
            {
                Caption = 'Create';
                action("C&reate Customer")
                {
                    Caption = 'C&reate Customer';
                    Image = NewCustomer;

                    trigger OnAction();
                    begin
                        IF CheckCustomerCreated(FALSE) THEN
                            CurrPage.UPDATE(TRUE);
                    end;
                }
                action("Create &To-do")
                {
                    AccessByPermission = TableData 5050 = R;
                    Caption = 'Create &To-do';
                    Image = NewToDo;

                    trigger OnAction();
                    begin
                        CreateTodo;
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = Approval;
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;

                    trigger OnAction();
                    var

                    begin
                        //IF ApprovalsMgmt.CheckInsureApprovalsWorkflowEnabled(Rec) THEN
                        //    ApprovalsMgmt.OnSendInsureDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;

                    trigger OnAction();
                    var

                    begin
                        //ApprovalsMgmt.OnCancelInsureApprovalRequest(Rec);
                    end;
                }
            }


            action("Add Vehicles")
            {
                RunObject = Page "Schedule of Insured List";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action("Policy Wordings")
            {
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "Policy Wordings";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No."),
                              "Description Type" = FILTER(<> "Schedule of Insured");
                RunPageView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.");
            }
            action("Additional/Extra Covers")
            {
                RunObject = Page "Additional Benefits";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action("Import Vehicles")
            {

                trigger OnAction();
                begin
                    ImportMV.GetRec(Rec);
                    ImportMV.RUN;
                end;
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
                Image = Calculate;
                Promoted = true;

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
                    RESET;
                    SETRANGE("Document Type", "Document Type");
                    SETFILTER("No.", "No.");
                    REPORT.RUN(51513514, TRUE, TRUE, Rec);
                    RESET;
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
                Visible = false;

                trigger OnAction();
                begin
                    InsuranceMgnt.InsertTaxesReinsurance(Rec);

                    InsuranceMgnt.ConvertQuote2Policy(Rec);
                    InsuranceMgnt.ConvertQuote2DebitNote(Rec);
                end;
            }
            action("Accept Quote")
            {
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;

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
            action("Documents Required")
            {
                RunObject = Page "Insurance Documents";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No" = FIELD("No.");
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
        Quotation: Report Quote;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        DocPrint: Codeunit 229;
        OpenApprovalEntriesExist: Boolean;
        ImportMV: XMLport "Import Motor vehicles";
}

