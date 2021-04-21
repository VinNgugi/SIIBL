page 51513522 "Life_Accepted Quote List"
{
    // version AES-INS 1.0

    CardPageID = "Life Quote Individual Card";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST("Accepted Quote"));

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
                field("Policy Type"; "Policy Type")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field("Agent/Broker"; "Agent/Broker")
                {
                }
                field("Brokers Name"; "Brokers Name")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field("Policy No"; "Policy No")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
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
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No."),
                              "Description Type" = FILTER(<> "Schedule of Insured");
                RunPageView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.");
            }
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
                    /*Quotation.GetQuote(Rec);
                    Quotation.RUN;*/
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

                trigger OnAction();
                begin
                    InsuranceMgnt.InsertTaxesReinsurance(Rec);
                    InsuranceMgnt.ConvertQuote2Policy(Rec);
                    InsuranceMgnt.ConvertQuote2DebitNote(Rec);
                end;
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
                    // IF ApprovalsMngt.SendInsureApprovalRequest(Rec) THEN
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

    var
        InsuranceMgnt: Codeunit "Insurance management";
}

