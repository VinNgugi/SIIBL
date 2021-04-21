page 51511022 "Petty Cash Voucher"
{
    // version FINANCE

    PageType = Card;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST(PettyCash),
                            Posted = CONST(False));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = true;
                }
                field("Request Date"; "Request Date")
                {

                    trigger OnValidate()
                    begin
                        IF Status <> Status::Open THEN
                            ERROR('You cannot change this document at this stage');
                    end;
                }
                field("Bank Account"; "Bank Account")
                {
                    NotBlank = true;

                    trigger OnValidate()
                    begin
                        IF Status <> Status::Open THEN
                            ERROR('You cannot change this document at this stage');
                    end;
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Pay Mode"; "Pay Mode")
                {
                    NotBlank = true;
                }
                field(Posted; Posted)
                {
                    Editable = false;
                }
                field("Cheque No"; "Cheque No")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("No of Approvals"; "No of Approvals")
                {
                }
                field("Total Amount Requested"; "Total Amount Requested")
                {
                }
            }
            part("Petty Cash Lines"; "Petty Cash Lines")
            {
                SubPageLink = "Document No" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Payments)
            {
                Caption = 'Payments';
                action("Print Cheque")
                {
                    Caption = 'Print Cheque';
                    Visible = false;

                    trigger OnAction()
                    begin
                        TESTFIELD("Pay Mode");
                        //TESTFIELD("Paying Bank Account");
                        //TESTFIELD(Payee);

                        RESET;
                        SETFILTER("No.", "No.");
                        REPORT.RUN(51511019, TRUE, TRUE, Rec);
                        RESET;
                    end;
                }
                action("Include Taxation")
                {
                    Caption = 'Include Taxation';
                    Visible = false;

                    trigger OnAction()
                    begin
                        PVLines.RESET;
                        PVLines.SETRANGE(PVLines."PV No", "No.");
                        PVLines.SETRANGE(PVLines.Tax, TRUE);
                        PVLines.DELETEALL;

                        PVLines.RESET;
                        PVLines.SETRANGE(PVLines."PV No", "No.");
                        IF PVLines.FIND('+') THEN
                            LastPVLine := PVLines."Line No";


                        IF TarriffCodes.GET(PVLines."VAT Code") THEN BEGIN
                            PVLines.INIT;
                            PVLines."PV No" := "No.";
                            PVLines."Line No" := LastPVLine + 10000;
                            PVLines."Account Type" := PVLines."Account Type"::"G/L Account";
                            PVLines."Account No" := TarriffCodes."G/L Account";
                            PVLines.Description := TarriffCodes.Description;
                            PVLines.VALIDATE(PVLines."Account No");
                            PVLines.Tax := TRUE;

                            //PVLines.Amount:=-ROUND(("Base Amount"/((TarriffCodes.Percentage+100))*TarriffCodes.Percentage));
                            IF PVLines.Amount <> 0 THEN
                                PVLines.INSERT;

                        END;

                        PVLines.RESET;
                        PVLines.SETRANGE(PVLines."PV No", "No.");
                        IF PVLines.FIND('+') THEN
                            LastPVLine := PVLines."Line No";

                        IF TarriffCodes.GET(PVLines."W/Tax Code") THEN BEGIN
                            PVLines.INIT;
                            PVLines."PV No" := "No.";
                            PVLines."Line No" := LastPVLine + 10000;
                            PVLines."Account Type" := PVLines."Account Type"::"G/L Account";
                            PVLines."Account No" := TarriffCodes."G/L Account";
                            PVLines.Description := TarriffCodes.Description;
                            PVLines.VALIDATE(PVLines."Account No");
                            PVLines.Tax := TRUE;

                            //CALCFIELDS("Base Amount");
                            //PVLines.Amount:=-ROUND(("Base Amount"/((TarriffCodes.Percentage+100))*TarriffCodes.Percentage));
                            IF PVLines.Amount <> 0 THEN
                                PVLines.INSERT;


                        END;
                    end;
                }
                action("Remittance Advice")
                {
                    Caption = 'Remittance Advice';
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*
                        RESET;
                        SETFILTER(No,No);
                        REPORT.RUN(53097,TRUE,TRUE,Rec);
                        RESET;
                        */

                    end;
                }
                action("Claim Advise")
                {
                    Caption = 'Claim Advise';
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*
                       RESET;
                       SETFILTER(No,No);
                       REPORT.RUN(53029,TRUE,TRUE,Rec);
                       RESET;
                        */

                    end;
                }
                action("VAT Certificate")
                {
                    Caption = 'VAT Certificate';
                    Visible = false;

                    trigger OnAction()
                    begin
                        TESTFIELD("Pay Mode");
                        TESTFIELD("Account No.");



                        /*IF Status<>Status::Released THEN
                        ERROR('This document is not yet fully approved'); */
                        PVRec.RESET;
                        PVRec.SETRANGE(PVRec."No.", "No.");
                        REPORT.RUNMODAL(51511009, TRUE, TRUE, PVRec);

                    end;
                }
                action("Withholding Tax Certificate")
                {
                    Caption = 'Withholding Tax Certificate';
                    Visible = false;

                    trigger OnAction()
                    begin
                        TESTFIELD("Pay Mode");
                        TESTFIELD("Account No.");
                        //TESTFIELD(Payee);


                        PVRec.RESET;
                        PVRec.SETRANGE(PVRec."No.", "No.");
                        REPORT.RUNMODAL(51511010, TRUE, TRUE, PVRec);
                    end;
                }
                action("Generate KCB  EFT")
                {
                    Caption = 'Generate KCB  EFT';
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*
                        TESTFIELD("Pay Mode");
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD(Payee);
                        
                        
                        KCBEFT.GetPV(Rec);
                        KCBEFT.RUN;
                         */

                    end;
                }
                action("CBA EFT")
                {
                    Caption = 'CBA EFT';

                    trigger OnAction()
                    begin
                        //IF Status<>Status::Released THEN
                        //ERROR('An EFT cannot be generated before the PV is fully approved');

                        /*IF "Eft Generated"=TRUE THEN
                         ERROR('An EFT has already been generated for this PV!');
                        
                        TESTFIELD("Pay Mode");
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD(Payee);
                        
                        PVRec.RESET;
                        PVRec.SETRANGE(PVRec.No,No);
                        REPORT.RUN(51511362,TRUE,TRUE,PVRec);
                        
                        "Eft Generated":=TRUE;
                        MODIFY;*/

                    end;
                }
                action("Print Cheque - dot marix")
                {
                    Caption = 'Print Cheque - dot marix';
                    Visible = false;

                    trigger OnAction()
                    begin
                        TESTFIELD("Pay Mode");
                        TESTFIELD("Account No.");
                        //TESTFIELD(Payee);

                        RESET;
                        SETFILTER("No.", "No.");
                        REPORT.RUN(51511177, TRUE, TRUE, Rec);
                        RESET;
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        TESTFIELD("Pay Mode");
                        TESTFIELD("Account No.");
                        //TESTFIELD(Payee);
                        //IF ApprovalMgt.SendPettyCashApprovalRequest(Rec) THEN;
                    end;
                }
                action("Cancel Approval Request1")
                {
                    Caption = 'Cancel Approval Request';
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.CancelPettyCashApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                action("Suggest Board Member Payments")
                {
                    Caption = 'Suggest Board Member Payments';

                    trigger OnAction()
                    begin
                        //suggestcoompayment.GetPV(Rec);
                        //suggestcoompayment.RUN;
                    end;
                }
                action("Suggest Medical Claim Payments")
                {
                    Caption = 'Suggest Medical Claim Payments';

                    trigger OnAction()
                    begin
                        //GenerateClaimPayable.GetPV(Rec);
                        //GenerateClaimPayable.RUN;
                    end;
                }
                action("Suggest Commissioner Tax")
                {
                    Caption = 'Suggest Commissioner Tax';

                    trigger OnAction()
                    begin
                        // SuggestCoomTax.GetPV(Rec);
                        // SuggestCoomTax.RUN;
                    end;
                }
                action("Print Check")
                {
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*RESET;
                        PVRec.SETRANGE(PVRec.No,No);
                        REPORT.RUNMODAL(51511368,TRUE,TRUE,PVRec);*/

                    end;
                }
                action("Payment Remittance Advice")
                {

                    trigger OnAction()
                    begin
                        RESET;
                        PVRec.SETRANGE(PVRec."No.", "No.");
                        REPORT.RUNMODAL(51511373, TRUE, TRUE, PVRec);
                    end;
                }
                action("Send Remittance Advice")
                {
                    Caption = '   Send Remittance Advice';
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*CompanyInfo.GET();
                        SenderAddress := CompanyInfo."Administrator Email";
                        SenderName := COMPANYNAME;
                         Subject := STRSUBSTNO('Payment Remittance Advice');
                         Body := STRSUBSTNO('Please find attached your Payment Remittance Advice');
                        
                        Vendor.RESET;
                        IF Vendor.GET("Account No.") THEN
                         Recipients :=Vendor."E-Mail";
                        
                         SMTPSetup.CreateMessage(SenderName,SenderAddress,Recipients,Subject,Body,TRUE);
                        
                           FileName:=FileManagement.ServerTempFileName('.pdf');
                        
                         RESET;
                         PVRec.SETRANGE(PVRec."No.","No.");
                           REPORT.SAVEASPDF(51511373,FileName,PVRec);
                        
                         SMTPSetup.AddAttachment(FileName);
                         SMTPSetup.AddCC(CompanyInfo."Finance Email");
                         SMTPSetup.Send;
                        
                        MESSAGE('Payment Remittance Advice sent to %1',"Account Name");
                        */

                    end;
                }
            }
        }
        area(processing)
        {
            action("Send For Approval")
            {
                Caption = 'Send For Approval';
                Image = Approval;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    /*IF Status<>Status::Open THEN
                    ERROR('The document has already been processed.');
                    
                    IF Amount<0 THEN
                    ERROR('Amount cannot be less than zero.');
                    
                    IF Amount=0 THEN
                    ERROR('Please enter amount.');
                    
                    
                    IF "Pay Mode"='CHEQUE' THEN BEGIN
                    TESTFIELD("Paying Bank Account");
                    //TESTFIELD("Cheque No");
                    //TESTFIELD("Cheque Date");
                    //TESTFIELD("Cheque Type");
                    //TESTFIELD("Bank Code");
                    END;
                    TESTFIELD("Paying Bank Account");
                    TESTFIELD("Transaction Name");
                    TESTFIELD("Pay Mode");
                    TESTFIELD(Payee);
                    TESTFIELD(Amount);
                    TESTFIELD("VAT Code");
                    TESTFIELD("Withholding Tax Code");
                    TESTFIELD("Global Dimension 1 Code");
                    TESTFIELD("Account No.");
                    TESTFIELD("Branch Code");
                    TESTFIELD("Net Amount");
                    TESTFIELD("Paying Bank Account");
                    
                    IF CONFIRM('Are you sure you would like to approve the payment?',FALSE)=TRUE THEN BEGIN
                    Status:=Status::Released;
                    MODIFY;
                    MESSAGE('Document approved successfully.');
                    END;
                    */

                    //IF ApprovalMgt.SendPettyCashApprovalRequest(Rec) THEN;

                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    //IF ApprovalMgt.CancelPettyCashApprovalRequest(Rec,TRUE,TRUE) THEN;
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin
                    //PVPost.PostPettyCash(Rec);
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
                    SETFILTER("No.", "No.");
                    REPORT.RUN(51511012, TRUE, TRUE, Rec);
                    RESET;
                end;
            }
            action("DMS Link")
            {
                Caption = 'DMS Link';
                Enabled = true;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;

                trigger OnAction()
                begin
                    /*GLSetup.GET();
                      Link:=GLSetup."DMS PV Link"+"No.";
                     HYPERLINK(Link);*/

                end;
            }
            action("Import Payments")
            {
                Caption = 'Import Payments';

                trigger OnAction()
                begin
                    //PaymentImport.GetRec(Rec);
                    //PaymentImport.RUN;
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        IF Posted THEN
            ERROR('You cannot delete the details of the petty cash voucher at this stage');
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF Posted THEN
            ERROR('You cannot change the details of the petty cash voucher at this stage');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // CurrForm.EDITABLE:=TRUE;
        //"Payment Type":="Payment Type"::"Petty Cash";
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        CurrPage.EDITABLE := TRUE;
    end;

    trigger OnOpenPage()
    begin
        CurrPage.EDITABLE := TRUE;
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
        PVRec: Record "Request Header";
        RequestHeader: Record "Request Header";
        //RequestLines: Record 51511127;
        CommittmentEntries: Record "Commitment Entries";
        LastEntry: Integer;
        BankLedger: Record 271;
        //ClaimLines: Record 51511322;
        GlLineNo: Integer;
        GLSetup: Record "Cash Management Setup";
        Link: Text[250];
       // CBAEFT: Report 51511362;
        CompanyInfo: Record 79;
        SenderAddress: Text[80];
        SenderName: Text[80];
        Subject: Text[100];
        Body: Text[250];
        Recipients: Text[80];
        SMTPSetup: Codeunit 400;
        FileName: Text[250];
        Vendor: Record Vendor;
        FileManagement: Codeunit 419;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
}

