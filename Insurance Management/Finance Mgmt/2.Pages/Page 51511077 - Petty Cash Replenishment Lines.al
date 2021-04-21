page 51511077 "Petty Cash Replenishment Lines"
{
    // version FINANCE

    AutoSplitKey = true;
    Caption = 'Petty Cash Replenishment Lines';
    PageType = ListPart;
    SourceTable = "PV Lines1";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("Account Type"; "Account Type")
                {
                }
                field("Account No"; "Account No")
                {
                    Caption = 'Cash Book No.';

                    trigger OnValidate()
                    begin
                        BAnkRec.RESET;
                        IF BAnkRec.GET("Account No") THEN BEGIN
                            "Account Name" := BAnkRec.Name;
                            "Account No" := BAnkRec."No.";
                            "Bank Account No" := BAnkRec."Bank Account No.";
                            //"Bank Account" := BAnkRec."Bank Account No.";
                            //"Bank Name" := BAnkRec.Name;
                        END;

                        PaymentsRec.RESET;
                        IF PaymentsRec.GET("PV No") THEN BEGIN
                            "Shortcut Dimension 1 Code" := PaymentsRec."Global Dimension 1 Code";
                            "Shortcut Dimension 2 Code" := PaymentsRec."Global Dimension 2 Code";
                        END;
                    end;
                }
                field("Account Name"; "Account Name")
                {
                    Caption = 'Cash Book Name';
                    Editable = false;
                }
                field(Description; Description)
                {
                }
                //field(Transactionref; Transactionref)
                //{
                 //   Caption = 'Transaction Ref';
                  //  Editable = false;
                   // Visible = false;
                //}
                field("Bank Account No"; "Bank Account No")
                {
                }
                field("KBA Branch Code"; "KBA Branch Code")
                {
                }
                //field("Bank Name"; "Bank Name")
                // {
                //}
                field(Amount; Amount)
                {
                    Caption = 'Gross Amount';

                    trigger OnValidate()
                    begin
                        IF "Account Type" = "Account Type"::"G/L Account" THEN BEGIN
                            "Net Amount" := Amount;
                            CurrPage.ACTIVATE;
                        END;
                        IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                            "Net Amount" := Amount;
                            CurrPage.ACTIVATE;
                        END;
                    end;
                }
                field("Net Amount"; "Net Amount")
                {
                    Editable = false;
                }
                field("Amount(LCY)"; "Amount(LCY)")
                {
                }
                field("Global Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Global Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Posted Purchase Invoice")
            {
                Image = PostedMemo;
                Promoted = true;
                RunObject = Page 138;
                RunPageLink = "No." = FIELD("Applies to Doc. No");
                Visible = false;
            }
            action("&Good Received Note")
            {
                Caption = '&Good Received Note';
                Ellipsis = true;
                Image = Note;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    PurchInvHeader.RESET;
                    PurchInvHeader.SETRANGE("No.", "Applies to Doc. No");
                    IF PurchInvHeader.FIND('-') THEN BEGIN
                        PurchRecHeader.RESET;
                        PurchRecHeader.SETRANGE(PurchRecHeader."Order No.", PurchInvHeader."Order No.");
                        IF PurchRecHeader.FIND('-') THEN BEGIN
                            //RESET;
                            //SETFILTER("No.","No.");
                            REPORT.RUN(51511265, TRUE, TRUE, PurchRecHeader);
                            //RESET;
                        END;
                    END;
                end;
            }
            action(Requisition)
            {
                Caption = 'Open Requisition';
                Image = RefreshPlanningLine;
                Promoted = true;
                Visible = false;

                trigger OnAction()
                begin
                    /*
                    PostedPurchInv.RESET;
                    PostedPurchInv.SETRANGE("No.","Applies to Doc. No");
                    IF PostedPurchInv.FIND ('-') THEN BEGIN
                      //Message(PostedPurchInv."Requisition No");
                      reqHeader.RESET;
                      reqHeader.SETFILTER(reqHeader."No.",PostedPurchInv."Requisition No");
                      IF reqHeader.FINDSET THEN BEGIN
                         PAGE.RUN(51511171,reqHeader);
                      END;
                    END;
                    */

                end;
            }
            group("Suggest Payments")
            {
                Caption = 'Suggest Payments';
                action("Suggest Imprest/Claim Payments")
                {
                    Image = SuggestCustomerPayments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PaymentsRec.RESET;
                        PaymentsRec.SETFILTER(No, "PV No");
                        IF PaymentsRec.FINDSET THEN BEGIN
                            //SuggestPVlines.GetPV(PaymentsRec);
                            SuggestPVlines.RUN;
                        END;

                        CurrPage.UPDATE;
                    end;
                }
                action("Suggest Salary Deductions")
                {
                    Image = SalesTax;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        /*PaymentsRec.RESET;
                        PaymentsRec.SETFILTER(No,"PV No");
                        IF PaymentsRec.FINDSET THEN BEGIN
                           SuggestDeductions.GetPV(PaymentsRec);
                           SuggestDeductions.RUN;
                        END;
                        
                        CurrPage.UPDATE;
                        */

                    end;
                }
                action("Suggest Commissioner Payments")
                {
                    Image = Employee;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        /*PaymentsRec.RESET;
                        PaymentsRec.SETFILTER(No,"PV No");
                        IF PaymentsRec.FINDSET THEN BEGIN
                           SuggestCommissioner.GetPV(PaymentsRec);
                           SuggestCommissioner.RUN;
                        END;
                        
                        CurrPage.UPDATE;
                        */

                    end;
                }
                action("Suggest Investment Purchases")
                {

                    trigger OnAction()
                    begin
                        /*PaymentsRec.RESET;
                        PaymentsRec.SETFILTER(No,"PV No");
                        IF PaymentsRec.FINDSET THEN BEGIN
                          GenerateInvestment.GetPV(PaymentsRec);
                          GenerateInvestment.RUN;
                        
                        END;
                        
                        CurrPage.UPDATE;
                        */

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Account Type" := "Account Type"::"Bank Account";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Account Type" := "Account Type"::"Bank Account";
    end;

    var
        GenJnlLine: Record 81;
        DefaultBatch: Record 232;
        RecPayTypes: Record "Receipts and Payment Types";
        CurrExchRate: Record 330;
        Amt: Decimal;
        CustLedger: Record "Cust. Ledger Entry";
        CustLedger1: Record "Cust. Ledger Entry";
        VendLedger: Record 25;
        VendLedger1: Record 25;
        PolicyRec: Record 112;
        PremiumControlAmt: Decimal;
        BasePremium: Decimal;
        TotalTax: Decimal;
        TotalTaxPercent: Decimal;
        TotalPercent: Decimal;
        SalesInvoiceHeadr: Record 114;
        PaymentsRec: Record Payments1;
        ShortcutDimCode: array[8] of Code[20];
        PurchRecHeader: Record 120;
        PurchInvHeader: Record 122;
        //reqHeader: Record 51511110;
        PostedPurchInv: Record 122;
        PVLines1: Record 51511001;
        SuggestPVlines: Report 51511000;
        BAnkRec: Record "Bank Account";
}

