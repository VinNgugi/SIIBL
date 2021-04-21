page 51513134 "Credit Note Card (Posted)"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = Card;
    SourceTable = "Insure Credit Note";

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
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field(Underwriter; Underwriter)
                {
                    Caption = 'Insurer';
                }
                field("Undewriter Name"; "Undewriter Name")
                {
                    Caption = 'Insurer Name';
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
                field("Commission Due"; "Commission Due")
                {
                    Caption = 'Commission %';
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
                field("From Time"; "From Time")
                {
                }
                field("To Time"; "To Time")
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
                field("Follow Up Person"; "Follow Up Person")
                {
                }
                field("Policy No"; "Policy No")
                {
                }
                field("Follow Up Date"; "Follow Up Date")
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
            part("Posted Credit Note Lines"; "Posted Credit Note Lines")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
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
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    SalesInvHeader.PrintRecords(TRUE);
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
        //Quotation: Report "Insurance Quote-Broker";
        SalesInvHeader: Record "Insure Credit Note";
}

