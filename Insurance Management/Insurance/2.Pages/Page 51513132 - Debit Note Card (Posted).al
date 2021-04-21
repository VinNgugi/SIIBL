page 51513132 "Debit Note Card (Posted)"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = Card;
    SourceTable = "Insure Debit Note";

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
                    Editable = false;
                }
                field("Policy Description"; "Policy Description")
                {
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
                field("Endorsement Policy No."; "Endorsement Policy No.")
                {
                }
                field("Endorsement Type"; "Endorsement Type")
                {
                }
                field("Action Type"; "Action Type")
                {
                    Caption = 'Endorsement Type';
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
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
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
                field("Policy No"; "Policy No")
                {
                }
                field("Quotation No."; "Quotation No.")
                {
                }
                field("Copied from No."; "Copied from No.")
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
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                }
                field("Applied Amount"; "Applied Amount")
                {
                }
            }
            part("Posted Debit Note Lines"; "Posted Debit Note Lines")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("View vehicles")
            {
                Caption = 'Schedule of Insured Risks';
                RunObject = Page "Schedule of Insured List";
                RunPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
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
            action("Cancel Debit Note")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.ConvertDebitNote2CreditNote(Rec);
                end;
            }
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Invoice Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Invoice"), "No." = FIELD("No."), "Document Line No." = CONST(0);
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        //ShowDimensions;
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction();
                    var
                        PostedApprovalEntries: Page "Posted Approval Entries";
                    begin
                        //PostedApprovalEntries.Setfilters(DATABASE::"Sales Invoice Header","No.");
                        //PostedApprovalEntries.RUN;
                    end;
                }

                action("Credit Cards Transaction Lo&g Entries")
                {
                    Caption = 'Credit Cards Transaction Lo&g Entries';
                    Image = CreditCardLog;
                    //RunObject = Page 829;
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
                    // CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    // SalesInvHeader.PrintRecords(TRUE);
                    Report.run(51513304, true, true, Rec);
                end;
            }
            action("&Email")
            {
                Caption = '&Email';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    SalesInvHeader.EmailRecords(FALSE);
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    Navigate;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Document Type" := "Document Type"::"Accepted Quote";
        //"Quote Type":="Quote Type"::New;
        "Cover Type" := "Cover Type"::Individual;
    end;

    var
        ChangeExchangeRate: Page 511;
        InsuranceMgnt: Codeunit "Insurance management";
        // Quotation: Report "Insurance Quote-Broker";
        SalesInvHeader: Record "Insure Debit Note";
}

