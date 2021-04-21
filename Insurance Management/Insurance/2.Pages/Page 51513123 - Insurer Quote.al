page 51513123 "Insurer Quote"
{
    // version AES-INS 1.0

    PageType = Card;
    //InsertAllowed = false;
    //Editable = false;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST("Insurer Quotes"), "Quote Type" = CONST(New));

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
                field("Insured No."; "Insured No.")
                {

                }
                field("Insured Name"; "Insured Name")
                {

                }
                field("Insurance Class"; "Policy Class")
                {
                }
                field("Campaign No."; "Campaign No.")
                {
                }
                field("Opportunity No."; "Opportunity No.")
                {
                }
                field("Sales Agent"; "Sales Agent")
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
                field(Underwriter; Underwriter)
                {

                }
                field("Underwriter Name"; "Underwriter Name")
                {

                }

                field("Policy Type"; "Policy Type")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field("Insurer Policy No"; "Insurer Policy No")
                {

                }
                field("From Date"; "From Date")
                {
                    Caption = 'Policy Start Date';
                }

                field(Term; Term)
                {
                    Caption = 'Policy Term';
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
                field("Commission Due"; "Commission Due")
                {
                    Caption = 'Commission % from Insurer';
                }

                field("Commission Payable 1"; "Commission Payable 1")
                {
                    Caption = 'Commission % to Agent ';
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
                field("Sum Assured"; "Sum Assured")
                {

                }
                field("Pay-out Frequency"; "Pay-out Frequency")
                {

                }
                field("Deffered Period"; "Deffered Period")
                {

                }
                field("Pay-out Commencement Date"; "Pay-out Commencement Date")
                {

                }
                field(Annuity; Annuity)
                {

                }
                /* }
                 part("Schedule of Insured List Edit"; "Schedule of Insured List Edit")
                 {
                     SubPageLink = "Document Type" = FIELD("Document Type"),
                                   "Document No." = FIELD("No.");
               */
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
                action(Dimensions1)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDocDim;
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction();
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Insure Header", "Document Type", "No.");
                        ApprovalEntries.RUN;
                    end;
                }
            }
        }
        area(processing)
        {
            action("Product Selection")
            {
                Caption = 'Product Selection';
                Image = "OpportunitiesList";
                Promoted = true;
                PromotedCategory = Process;


                RunObject = Page "Product Selection";
                RunPageLink = "Document No." = FIELD("Parent Quote No");


            }
            action("Email Insurers")
            {
                Caption = 'Email Insurers';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction();
                begin
                    InsureDataShare.SendRiskData(Rec);

                end;



            }



            /*  action("Create Quotes")
             {
                 Caption = 'Create Quotes';
                 Image = "";
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;
                 trigger OnAction();
                 begin
                     BrokerManagement.FnCreateInsurerQuote(Rec);
                 end; 
            } */
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
                        IF ApprovalMgmtExt.CheckInsureHeaderApprovalWFEnabled(Rec) THEN
                            ApprovalMgmtExt.OnSendInsureHeaderApprovalRequest(Rec);
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
                        IF ApprovalMgmtExt.CheckInsureHeaderApprovalWFEnabled(Rec) THEN
                            ApprovalMgmtExt.OnCancelInsureHeaderApprovalRequest(Rec);
                    end;
                }
                action("Approval Entries")
                {
                    Caption = 'Approval Entries';
                    //Enabled = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var

                    begin
                        WorkflowsEntriesBuffer.RunWorkflowEntriesPageNew(RECORDID, DATABASE::"Insure Header", "Approval Document Type", "No.");

                    end;
                }
            }
            group(" ")
            {
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
            action("Add Vehicles")
            {
                RunObject = Page "Schedule of Insured List";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }

            action("Add/Edit Risk")
            {
                Promoted = true;
                RunObject = Page "Risk Listing";
                RunPagelink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");


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
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
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
                    InsuranceMgnt.InsertTaxesReinsuranceB(Rec);
                end;
            }
            action("Generate Policy")
            {
                Image = Calculate;
                Promoted = true;
                trigger OnAction()
                begin
                    IF Status <> status::Released THEN
                        ERROR('Please ensure this Quote is approved before generating a Policy');
                    If "Insurer Policy No" = '' then
                        Error('Please key in the Policy Number from the Insurer');

                    InsuranceMgnt.InsertTaxesReinsuranceB(Rec);
                    InsuranceMgnt.ConvertQuote2PolicyB(Rec);
                    InsuranceMgnt.ConvertQuote2DebitNoteB(Rec);
                end;
            }
            action("View calculations")
            {
                RunObject = Page "Financial Lines";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action("Print Quote")
            {

                trigger OnAction();
                begin
                    //Quotation.GetQuote(Rec);
                    //Quotation.RUN;
                    RESET;
                    SETRANGE("Document Type", "Document Type");
                    SETFILTER("No.", "No.");
                    REPORT.RUN(51515000, TRUE, TRUE, Rec);
                    RESET;
                end;
            }
            action("Premium Payment Schedule")
            {
                Caption = 'Premium Payment Schedule';
                RunObject = Page "Payment Schedule";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action("Maturity Payment Schedule")
            {
                Caption = 'Maturity Payment Schedule';
                RunObject = Page "Maturity Payment Schedule";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            action("Generate Policy ")
            {
                Visible = false;

                trigger OnAction();
                begin

                    If Status <> Status::Released then
                        error('Please send quote for approval first');

                    InsuranceMgnt.InsertTaxesReinsuranceB(Rec);

                    InsuranceMgnt.ConvertQuote2PolicyB(Rec);
                    InsuranceMgnt.ConvertQuote2DebitNoteB(Rec);
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
        "Document Type" := "Document Type"::"Insurer Quotes";
        "Quote Type" := "Quote Type"::New;
        "Cover Type" := "Cover Type"::Individual;
        //MESSAGE('%1',"Quote Type");
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        InsuranceMgnt: Codeunit "Insurance management";
        Quotation: Report 51513514;
        ApprovalMgmt: Codeunit "Approvals Mgmt.";

        ApprovalMgmtExt: Codeunit "Approvals Mgmt. Ext";
        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
        DocPrint: Codeunit "Document-Print";
        OpenApprovalEntriesExist: Boolean;
        ImportMV: XMLport "Import Motor vehicles";

        InsureDataShare: Codeunit "Insure Data Share";
        BrokerManagement: Codeunit "Broker Management";

    // QuoteSlip:Report "Quote slip";
}

