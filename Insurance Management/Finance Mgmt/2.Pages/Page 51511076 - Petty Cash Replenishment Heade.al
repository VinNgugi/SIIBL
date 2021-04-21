page 51511076 "Petty Cash Replenishment Heade"
{
    // version FINANCE

    Caption = 'Petty Cash Replenishment Header';
    CardPageID = "Petty Cash Replenishment Heade";
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = true;
    PageType = Card;
    SourceTable = Payments1;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; No)
                {
                    Editable = false;
                }
                field(Date; Date)
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        /*IF Status<>Status::Open THEN
                        ERROR('You cannot change this document at this stage');
                        */

                    end;
                }
                field(Currency; Currency)
                {

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Currency, "Exchange Factor", TODAY);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                            "Exchange Factor" := ChangeExchangeRate.GetParameter;
                        //VALIDATE(Currency);
                        //MESSAGE(FORMAT("Exchange Factor"));
                        MODIFY;
                        CLEAR(ChangeExchangeRate);

                        VALIDATE("Exchange Factor");
                    end;
                }
                field("Account Type"; "Account Type")
                {
                    Editable = false;
                }
                field("Paying Bank Account"; "Paying Bank Account")
                {
                    NotBlank = true;

                    trigger OnValidate()
                    begin
                        /*IF Status<>Status::Open THEN
                        ERROR('You cannot change this document at this stage'); */
                        IF "Paying Bank Account" <> '' THEN
                            IF BankAcc.GET("Paying Bank Account") THEN BEGIN
                                Payee := UPPERCASE(BankAcc.Name);
                            END;

                    end;
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field(Payee; Payee)
                {
                    NotBlank = true;

                    trigger OnValidate()
                    begin
                        /*IF Status<>Status::Open THEN
                        ERROR('You cannot change this document at this stage');
                         */

                    end;
                }
                field("Pay Mode"; "Pay Mode")
                {
                    NotBlank = true;
                }
                field("KBA Bank Code"; "KBA Bank Code")
                {
                    Visible = false;
                }
                field("Bank Account No"; "Bank Account No")
                {
                    Visible = false;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    Visible = false;
                }
                field("No of Approvals"; "No of Approvals")
                {
                    Editable = false;
                }
                field(Posted; Posted)
                {
                    Editable = false;
                }
                field("Date Posted"; "Date Posted")
                {
                    Editable = false;
                }
                field("Time Posted"; "Time Posted")
                {
                    Editable = false;
                }
                field("Posted By"; "Posted By")
                {
                    Editable = false;
                }
                field("Cheque No"; "Cheque No")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                }
                field(Status; Status)
                {
                    Enabled = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Global Dimension 3 Code"; "Global Dimension 3 Code")
                {
                    Caption = 'Sub Item Code';
                }
                group("Pay Details")
                {
                    Visible = VisibleReleased;
                }
                field("Total Amount"; "Total Amount")
                {
                }
                /* SNN 03302021 field(Balance; Balance)
                 {
                     Editable = false;
                 }
                 field("Approval Status"; "Approval Status")
                 {
                     Editable = false;
                 }*/
            }
            part("Petty Cash Replenishment Lin"; 51511077)
            {
                Caption = 'Petty Cash Replenishment Lin';
                //SubPageLink = "PV No" = FIELD(No);
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //TESTFIELD(Status,Status::Released);
                    TESTFIELD(Posted, FALSE);
                    TESTFIELD("Cheque No");
                    TESTFIELD("Cheque Date");
                    //TESTFIELD("Posting Date");
                    TESTFIELD("Paying Bank Account");
                    IF NOT CONFIRM('Are you sure you want to post the transfer?') THEN
                        EXIT;

                    /* IF UserBatchSetup.GET(USERID) THEN BEGIN
                        //UserBatchSetup.TESTFIELD("payment Batch");
                       // UserBatchSetup.TESTFIELD("Payment Template");
                        //JTemplate := UserBatchSetup."Payment Template";
                        //JBatch := UserBatchSetup."payment Batch";
                    END ELSE BEGIN
                        MESSAGE('Please contact your system administrator to create a batch for you');
                        EXIT;
                    END; */

                    //PostEFTBatch.FnDeleteJournalLines(JTemplate, JBatch);

                    CMSetup.GET;
                    Rec.CALCFIELDS("Total Amount");
                    PVLines.RESET;
                    PVLines.SETRANGE("PV No", No);
                    IF PVLines.FINDSET THEN BEGIN
                        REPEAT
                            PVLines.TESTFIELD(Amount);
                            LineNo := LineNo + 10;
                        //Factory.FnCreateGnlJournalLine(JTemplate, JBatch, No, LineNo, GenJnlLine."Transaction Type"::Normal, GenJnlLine."Account Type"::"Bank Account",
                        //    CMSetup."Default Cash Account", Date, PVLines.Amount, PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code", "Cheque No",
                        //  'Petty cash replenishment From:-' + "Paying Bank Account" + 'Doc No.' + No, '', Currency, PVLines."Applies-to Doc. Type"::" ", '', "Exchange Factor");
                        UNTIL PVLines.NEXT = 0;
                    END;

                    CALCFIELDS("Total Amount");
                    LineNo := LineNo + 10;
                    /* Factory.FnCreateGnlJournalLine(JTemplate, JBatch, No, LineNo, GenJnlLine."Transaction Type"::Normal, GenJnlLine."Account Type"::"Bank Account",
                                                    "Paying Bank Account", Date, -"Total Amount", "Global Dimension 1 Code", "Global Dimension 2 Code", "Cheque No",
                                                    'Petty cash top up to :-' + No, '', Currency, PVLines."Applies-to Doc. Type"::" ", '', "Exchange Factor"); */

                    //PostEFTBatch.FnPostJournalLines(JTemplate, JBatch);
                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    RESET;
                    SETFILTER(No, No);
                    REPORT.RUN(51511236, TRUE, TRUE, Rec);
                    RESET;
                end;
            }
            group(Approvals)
            {
                Caption = 'Approval';
                action("Send Approval Request.")
                {
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        TESTFIELD("Global Dimension 1 Code");
                        TESTFIELD("Global Dimension 2 Code");
                        //TESTFIELD("Posting Date");
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD("Pay Mode");
                        IF "Pay Mode" = 'CHEQUE' THEN BEGIN
                            TESTFIELD("Cheque Date");
                            TESTFIELD("Cheque No");
                        END;
                        PVLines.RESET;
                        PVLines.SETRANGE("PV No", Rec.No);
                        IF PVLines.FINDSET THEN
                            REPEAT
                                PVLines.TESTFIELD(Description);
                                PVLines.VALIDATE(Amount);
                            UNTIL PVLines.NEXT = 0;
                        IF NOT CONFIRM('Are you sure you want to send the document for approval?') THEN
                            EXIT;



                        /* IF ApprovalsMgmt.CheckPVApprovalPossible(Rec) THEN
                            ApprovalsMgmt.OnSendPVDocForApproval(Rec); */


                    end;
                }
                action("Cancel Approval Request.")
                {
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        TESTFIELD(Status, Status::"Pending Approval");

                        IF NOT CONFIRM('Are you sure you want to send the document for approval?') THEN
                            EXIT;

                        //ApprovalsMgmt.OnCancelPVApprovalRequest(Rec);
                    end;
                }
                action("Approval Entries")
                {
                    Image = Approvals;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page 658;
                    RunPageMode = View;
                }
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        IF NOT CONFIRM('Are you sure you want to Approve the document ?') THEN
                            EXIT;

                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                        CurrPage.CLOSE;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        IF NOT CONFIRM('Are you sure you want to Reject the document ?') THEN
                            EXIT;

                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                        CurrPage.CLOSE;
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        IF NOT CONFIRM('Are you sure you want to Delegate the document ?') THEN
                            EXIT;

                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                        CurrPage.CLOSE;
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        VisibleReleased := FALSE;
        IF Status = Status::Released THEN
            VisibleReleased := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        VisibleReleased := FALSE;
        IF Status = Status::Released THEN
            VisibleReleased := TRUE;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        IF Posted THEN
            ERROR('You cannot delete the details of the payment voucher at this stage');
    end;

    trigger OnModifyRecord(): Boolean
    begin
        /*IF Posted THEN
        ERROR('You cannot change the details of the payment voucher at this stage');*/

        //CurrPage.UPDATE();

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //CurrForm.EDITABLE:=TRUE;
        "Payment Type" := "Payment Type"::Normal;
       // SNN 03302021 "Transaction Type" := "Transaction Type"::InterBank;
        "Account Type" := "Account Type"::"Bank Account";
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        CurrPage.EDITABLE := TRUE;
    end;

    trigger OnOpenPage()
    begin
        "Payment Type" := "Payment Type"::Normal;
       // SNN 03302021 "Transaction Type" := "Transaction Type"::InterBank;
        "Account Type" := "Account Type"::"Bank Account";

        approvalentry.RESET;
        approvalentry.SETFILTER(approvalentry.Status, '%1', approvalentry.Status::Open);
        //approvalentry.SETFILTER(approvalentry."Document Type",'%1',approvalentry."Document Type"::);
        approvalentry.SETFILTER(approvalentry."Approver ID", '%1', USERID);
        approvalentry.SETFILTER(approvalentry."Document No.", No);
        IF approvalentry.FINDSET THEN BEGIN
            OpenApprovalEntriesExistForCurrUser := TRUE;
            //MESSAGE('Approver...');
        END;
        IF NOT approvalentry.FINDSET THEN BEGIN
            OpenApprovalEntriesExistForCurrUser2 := TRUE;
            //MESSAGE('Not an Approver...');
        END;
        IF OpenApprovalEntriesExistForCurrUser = TRUE THEN BEGIN
            OpenApprovalEntriesExistForCurrUser2 := FALSE;
        END;
        //OpenApprovalEntriesExistForCurrUser:=TRUE;
        IF Status = Status::Released THEN BEGIN
            Seepost := TRUE;
            OpenApprovalEntriesExistForCurrUser := FALSE;
            OpenApprovalEntriesExistForCurrUser2 := FALSE;
        END;
        VisibleReleased := FALSE;
        IF Status = Status::Released THEN
            VisibleReleased := TRUE;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //  TESTFIELD("Paying Bank Account");
    end;

    var
        RecPayTypes: Record "Receipts and Payment Types";
        TarriffCodes: Record "Tarriff Codes";
        GenJnlLine: Record 81;
        DefaultBatch: Record 232;
        LineNo: Integer;
        CustLedger: Record 25;
        CustLedger1: Record 25;
        Amt: Decimal;
        FaDepreciation: Record 5612;
        BankAcc: Record "Bank Account";
        PVLines: Record 51511001;
        LastPVLine: Integer;
        PolicyRec: Record 114;
        PremiumControlAmt: Decimal;
        BasePremium: Decimal;
        TotalTax: Decimal;
        TotalTaxPercent: Decimal;
        TotalPercent: Decimal;
        SalesInvoiceHeadr: Record 114;
        AdjustConversion: Codeunit 407;
        ApprovalMgt: Codeunit 40;
        PVRec: Record Payments1;
        RequestHeader: Record "Request Header";
        CommittmentEntries: Record "Commitment Entries";
        LastEntry: Integer;
        BankLedger: Record 271;
        GlLineNo: Integer;
        GLSetup: Record "General Ledger Setup";
        Link: Text[250];
        CompanyInfo: Record "Company Information";
        SenderAddress: Text[80];
        SenderName: Text[80];
        Subject: Text[100];
        Body: Text[250];
        Recipients: Text[80];
        SMTPSetup: Codeunit 400;
        FileName: Text[250];
        Vendor: Record Vendor;
        FileManagement: Codeunit 419;
        ShortcutDimCode: array[8] of Code[20];
        OpenApprovalEntriesExistForCurrUser: Boolean;
        approvalentry: Record "Approval Entry";
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        i: Integer;
        approvalentries: Record "Approval Entry";
        Seepost: Boolean;
        VendLedgEntry: Record 25;
        Vend: Record Vendor;
        EmployeeBankAccountX1: Record 51511010;
        RequestHeader1: Record "Request Header";
        PVPost: Codeunit 51511014;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        //Factory: Codeunit 51511015;
        JTemplate: Code[40];
        JBatch: Code[40];
        //UserBatchSetup: Record 51511144;
        GenJournalLine: Record 81;
        //PostEFTBatch: Codeunit 51511016;
        ChangeExchangeRate: Page 511;
        VisibleReleased: Boolean;
        CMSetup: Record "Cash Management Setup";
}

