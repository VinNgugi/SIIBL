page 51511001 "Payment Voucher"
{
    // version CSHBK

    // 

    PageType = Card;
    SourceTable = 51511000;
    SourceTableView = WHERE("Payment Type" = CONST(Normal), Posted = CONST(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; No)
                {
                    Editable = true;
                }
                field(Date; Date)
                {

                    trigger OnValidate();
                    begin
                        /*IF Status<>Status::Open THEN
                        ERROR('You cannot change this document at this stage');*/

                    end;
                }
                field(Type; Type)
                {
                }
                field("Paying Bank Account"; "Paying Bank Account")
                {
                    NotBlank = true;

                    trigger OnValidate();
                    begin
                        IF Status <> Status::Open THEN
                            ERROR('You cannot change this document at this stage');
                    end;
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Account Name"; "Account Name")
                {
                }
                field(Payee; Payee)
                {
                    NotBlank = true;

                    trigger OnValidate();
                    begin
                        IF Status <> Status::Open THEN
                            ERROR('You cannot change this document at this stage');
                    end;
                }
                field("Reason Code"; "Reason Code")
                {
                }
                field(Priority; Priority)
                {
                }
                field(Currency; Currency)
                {
                }
                field("Exchange Rate"; "Exchange Rate")
                {
                }
                field("Deal Number"; "Deal Number")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Pay Mode"; "Pay Mode")
                {
                    NotBlank = true;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Global Dimension 3 Code"; "Global Dimension 3 Code")
                {
                }
                field("Global Dimension 4 Code"; "Global Dimension 4 Code")
                {
                }
                field("KBA Branch Code"; "KBA Branch Code")
                {
                    Caption = 'Payee Bank Code';
                }
                field("Bank Name and Branch"; "Bank Name and Branch")
                {
                }
                field("Bank Account No"; "Bank Account No")
                {
                    Caption = 'Payee Bank account No';
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
                field("Eft Generated"; "Eft Generated")
                {
                    Editable = false;
                }
                field("Charge By"; "Charge By")
                {
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
                field("Total Amount"; "Total Amount")
                {
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                }
                field("Cancellation Reason"; "Cancellation Reason")
                {
                }
            }
            part("PV Lines"; "PV Lines")
            {
                SubPageLink = "PV No" = FIELD(No);
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
                    Visible = true;

                    trigger OnAction();
                    begin
                        TESTFIELD("Pay Mode");
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD(Payee);

                        RESET;
                        SETFILTER(No, No);
                        REPORT.RUN(51511019, TRUE, TRUE, Rec);
                        RESET;
                    end;
                }
                action("Include Taxation")
                {
                    Caption = 'Include Taxation';
                    Visible = false;

                    trigger OnAction();
                    begin
                        PVLines.RESET;
                        PVLines.SETRANGE(PVLines."PV No", No);
                        PVLines.SETRANGE(PVLines.Tax, TRUE);
                        PVLines.DELETEALL;

                        PVLines.RESET;
                        PVLines.SETRANGE(PVLines."PV No", No);
                        IF PVLines.FIND('+') THEN
                            LastPVLine := PVLines."Line No";


                        IF TarriffCodes.GET("VAT Code") THEN BEGIN
                            PVLines.INIT;
                            PVLines."PV No" := No;
                            PVLines."Line No" := LastPVLine + 10000;
                            PVLines."Account Type" := PVLines."Account Type"::"G/L Account";
                            PVLines."Account No" := TarriffCodes."G/L Account";
                            PVLines.Description := TarriffCodes.Description;
                            PVLines.VALIDATE(PVLines."Account No");
                            PVLines.Tax := TRUE;
                            CALCFIELDS("Base Amount");
                            PVLines.Amount := -ROUND(("Base Amount" / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage));
                            IF PVLines.Amount <> 0 THEN
                                PVLines.INSERT;

                        END;

                        PVLines.RESET;
                        PVLines.SETRANGE(PVLines."PV No", No);
                        IF PVLines.FIND('+') THEN
                            LastPVLine := PVLines."Line No";

                        IF TarriffCodes.GET("Withholding Tax Code") THEN BEGIN
                            PVLines.INIT;
                            PVLines."PV No" := No;
                            PVLines."Line No" := LastPVLine + 10000;
                            PVLines."Account Type" := PVLines."Account Type"::"G/L Account";
                            PVLines."Account No" := TarriffCodes."G/L Account";
                            PVLines.Description := TarriffCodes.Description;
                            PVLines.VALIDATE(PVLines."Account No");
                            PVLines.Tax := TRUE;

                            CALCFIELDS("Base Amount");
                            PVLines.Amount := -ROUND(("Base Amount" / ((TarriffCodes.Percentage + 100)) * TarriffCodes.Percentage));
                            IF PVLines.Amount <> 0 THEN
                                PVLines.INSERT;


                        END;
                    end;
                }
                action("Remittance Advice")
                {
                    Caption = 'Remittance Advice';
                    Visible = false;

                    trigger OnAction();
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

                    trigger OnAction();
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
                    Visible = true;

                    trigger OnAction();
                    begin
                        TESTFIELD("Pay Mode");
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD(Payee);


                        /*IF Status<>Status::Released THEN
                        ERROR('This document is not yet fully approved'); */
                        PVRec.RESET;
                        PVRec.SETRANGE(PVRec.No, No);
                        REPORT.RUNMODAL(51511009, TRUE, TRUE, PVRec);

                    end;
                }
                action("Withholding Tax Certificate")
                {
                    Caption = 'Withholding Tax Certificate';
                    Visible = true;

                    trigger OnAction();
                    begin
                        TESTFIELD("Pay Mode");
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD(Payee);


                        PVRec.RESET;
                        PVRec.SETRANGE(PVRec.No, No);
                        REPORT.RUNMODAL(51511010, TRUE, TRUE, PVRec);
                    end;
                }
                action("Generate KCB  EFT")
                {
                    Caption = 'Generate KCB  EFT';
                    Visible = false;

                    trigger OnAction();
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

                    trigger OnAction();
                    begin
                        //IF Status<>Status::Released THEN
                        //ERROR('An EFT cannot be generated before the PV is fully approved');

                        IF "Eft Generated" = TRUE THEN
                            ERROR('An EFT has already been generated for this PV!');

                        TESTFIELD("Pay Mode");
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD(Payee);

                        PVRec.RESET;
                        PVRec.SETRANGE(PVRec.No, No);
                        REPORT.RUN(51511362, TRUE, TRUE, PVRec);

                        "Eft Generated" := TRUE;
                        MODIFY;
                    end;
                }
                action("CIC EFT")
                {
                    Caption = 'CIC EFT';

                    trigger OnAction();
                    begin
                        IF CashMgtSetup.GET THEN
                            IF Status <> Status::Released THEN
                                ERROR('An EFT cannot be generated before the PV is fully approved');

                        /*IF "Eft Generated"=TRUE THEN
                         ERROR('An EFT has already been generated for this PV!');*/

                        TESTFIELD("Pay Mode");
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD(Payee);
                        //CICEFT.RUN;
                        //CICEFT.SAVEASEXCEL(;
                        /*PVRec.RESET;
                        PVRec.SETRANGE(PVRec.No,No);
                        REPORT.RUN(51511362,TRUE,TRUE,PVRec);*/
                        PVLines.RESET;
                        PVLines.SETRANGE(PVLines."PV No", No);
                        REPORT.RUN(51513111, TRUE, TRUE, PVLines);
                        //MESSAGE('%1',CashMgtSetup."EFT File Path"+'\'+FORMAT(CICEFT));
                        //REPORT.SAVEASEXCEL(51513111,CashMgtSetup."EFT File Path"+'\'+FORMAT(CICEFT),PVLines);
                        "Eft Generated" := TRUE;
                        MODIFY;

                    end;
                }
                action("Print Cheque - dot marix")
                {
                    Caption = 'Print Cheque - dot marix';
                    Visible = true;

                    trigger OnAction();
                    begin
                        TESTFIELD("Pay Mode");
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD(Payee);

                        RESET;
                        SETFILTER(No, No);
                        REPORT.RUN(51511177, TRUE, TRUE, Rec);
                        RESET;
                    end;
                }
                action("Posted Cheques")
                {
                    Caption = 'Posted Cheques';
                    RunObject = Page 51513054;
                    RunPageLink = "Document Type" = CONST("Post dated Cheque"),
                                  "Document No." = FIELD(No);

                    trigger OnAction();
                    begin


                        //InsMngt.DrawPostedDatedChequesPV(Rec);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action("View Approvals")
                {
                    Caption = 'View Approvals';
                    RunObject = Page 662;
                    RunPageLink = "Document No." = FIELD(No);

                    trigger OnAction();
                    begin
                        /*TESTFIELD("Pay Mode");
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD(Payee);
                        //IF ApprovalMgt.SendPaymentsApprovalRequest(Rec) THEN;
                        Status:=Status::Released;
                        MODIFY;*/

                    end;
                }
                action("Suggest Board Member Payments")
                {
                    Caption = 'Suggest Board Member Payments';

                    trigger OnAction();
                    begin
                        // suggestcoompayment.GetPV(Rec);
                        // suggestcoompayment.RUN;
                    end;
                }
                action("Suggest Medical Claim Payments")
                {
                    Caption = 'Suggest Medical Claim Payments';

                    trigger OnAction();
                    begin
                        //GenerateClaimPayable.GetPV(Rec);
                        // GenerateClaimPayable.RUN;
                    end;
                }
                action("Suggest Commissioner Tax")
                {
                    Caption = 'Suggest Commissioner Tax';

                    trigger OnAction();
                    begin
                        //SuggestCoomTax.GetPV(Rec);
                        //  SuggestCoomTax.RUN;
                    end;
                }
                action("Print Check")
                {
                    Visible = false;

                    trigger OnAction();
                    begin
                        RESET;
                        PVRec.SETRANGE(PVRec.No, No);
                        REPORT.RUNMODAL(51511368, TRUE, TRUE, PVRec);
                    end;
                }
                action("Payment Remittance Advice")
                {

                    trigger OnAction();
                    begin
                        RESET;
                        PVRec.SETRANGE(PVRec.No, No);
                        REPORT.RUNMODAL(51511373, TRUE, TRUE, PVRec);
                    end;
                }
                action("Send Remittance Advice")
                {
                    Caption = '"   Send Remittance Advice"';
                    Visible = false;

                    trigger OnAction();
                    begin
                        CompanyInfo.GET();
                        //SenderAddress := CompanyInfo."Administrator Email";
                        SenderName := COMPANYNAME;
                        Subject := STRSUBSTNO('Payment Remittance Advice');
                        Body := STRSUBSTNO('Please find attached your Payment Remittance Advice');

                        Vendor.RESET;
                        IF Vendor.GET("Account No.") THEN
                            Recipients := Vendor."E-Mail";

                        SMTPSetup.CreateMessage(SenderName, SenderAddress, Recipients, Subject, Body, TRUE);

                        FileName := FileManagement.ServerTempFileName('.pdf');

                        RESET;
                        PVRec.SETRANGE(PVRec.No, No);
                        REPORT.SAVEASPDF(51511373, FileName, PVRec);

                        //SMTPSetup.AddAttachment(FileName);
                        // SMTPSetup.AddCC(CompanyInfo."Finance Support Email");
                        SMTPSetup.Send;

                        MESSAGE('Payment Remittance Advice sent to %1', "Account Name");
                    end;
                }
                action("Generate Reinsurance Entries")
                {

                    trigger OnAction();
                    begin
                        InsMngt.CreatePVReinsEntries(Rec);
                    end;
                }
            }
            action("View Reinsurance")
            {
                RunObject = Page 51513043;
                RunPageLink = "No." = FIELD(No);
            }
            action("Cancel PV")
            {
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction();
                begin
                    PaymentRelease.CancelPV(Rec);
                end;
            }
        }
        area(processing)
        {
            action("Send For Approval")
            {
                Caption = 'Send For Approval';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction();
                begin
                    IF Status <> Status::Open THEN
                        ERROR('The document has already been processed.');

                    IF Amount < 0 THEN
                        ERROR('Amount cannot be less than zero.');

                    IF Amount = 0 THEN
                        ERROR('Please enter amount.');


                    IF "Pay Mode" = 'CHEQUE' THEN BEGIN
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

                    IF CONFIRM('Are you sure you would like to approve the payment?', FALSE) = TRUE THEN BEGIN
                        Status := Status::Released;
                        MODIFY;
                        MESSAGE('Document approved successfully.');
                    END;
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

                trigger OnAction();
                var
                    PVPost: Codeunit 51511014;
                begin
                    PVPosting.PostBatch(Rec);

                    /*Reinslines.RESET;
                    Reinslines.SETRANGE(Reinslines."No.",No);
                    IF Reinslines.FINDFIRST THEN
                      REPEAT
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name":='GENERAL';
                    GenJnlLine."Journal Batch Name":='REINS';
                    GenJnlLine."Line No.":=GenJnlLine."Line No."+10000;
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::Customer;
                    GenJnlLine."Account No.":=Reinslines."Partner No.";
                    GenJnlLine."Document No.":=No;
                    GenJnlLine."Posting Date":=Rec.Date;
                    GenJnlLine.Amount:=Reinslines.Amount;
                    GenJnlLine.Description:='XOL Treaty';
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No.":='040-001';
                    GenJnlLine.INSERT;
                    UNTIL Reinslines.NEXT=0;
                    
                    //PVPost.PostPayment(Rec);
                    {
                    LineNo:=0;
                    CALCFIELDS("Total Amount");
                    IF Posted THEN
                    ERROR('The transaction has already been posted.');
                    
                    IF Status<>Status::Released THEN
                    ERROR('The document cannot be posted before it is fully approved');
                    
                    
                    IF "Pay Mode"='CHEQUE' THEN BEGIN
                    TESTFIELD("Paying Bank Account");
                    TESTFIELD("Cheque No");
                    //TESTFIELD("Cheque Date");
                    //TESTFIELD("Cheque Type");
                    //TESTFIELD("Bank Code");
                    END;
                    //TESTFIELD(Remarks);
                    TESTFIELD("Paying Bank Account");
                    TESTFIELD("Pay Mode");
                    TESTFIELD(Payee);
                    TESTFIELD("Total Amount");
                    //TESTFIELD("VAT Code");
                    //TESTFIELD("Withholding Tax Code");
                    //TESTFIELD("Global Dimension 1 Code");
                    //TESTFIELD("Global Dimension 2 Code");
                    
                    {CashierLinks.RESET;
                    CashierLinks.SETRANGE(CashierLinks.UserID,USERID);
                    IF CashierLinks.FIND('-') THEN BEGIN
                    END
                    ELSE BEGIN
                    ERROR('Please link the user/cashier to a collection account before proceeding.');
                    END;}
                    
                    
                      // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                      GenJnlLine.RESET;
                      GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",'PAYMENTS');
                      GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",No);
                      GenJnlLine.DELETEALL;
                    
                      IF DefaultBatch.GET('PAYMENTS',No) THEN
                       DefaultBatch.DELETE;
                    
                      DefaultBatch.RESET;
                      DefaultBatch."Journal Template Name":='PAYMENTS';
                      DefaultBatch.Name:=No;
                      DefaultBatch.INSERT;
                    
                    
                    
                    
                    
                    {
                    
                    TarriffCodes.RESET;
                    TarriffCodes.SETRANGE(TarriffCodes.Code,"VAT Code");
                    IF TarriffCodes.FIND('-') THEN BEGIN
                    TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
                    LineNo:=LineNo+1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name":='PAYMENTS';
                    GenJnlLine."Journal Batch Name":=No;
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No.":=TarriffCodes."G/L Account";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date":=Date;
                    GenJnlLine."Document No.":=No;
                    GenJnlLine.Amount:=-"VAT Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No.":='';
                    GenJnlLine.Description:='VAT';
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code":="Global Dimension 2 Code";
                    GenJnlLine."Currency Code":=Currency;
                    GenJnlLine.VALIDATE("Currency Code");
                    //GenJnlLine."Investment Code":=Currency;
                    //GenJnlLine."Type of Investment":="Exchange Rate";
                    //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                    GenJnlLine."Applies-to Doc. No.":="Apply to";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                    
                    IF GenJnlLine.Amount<>0 THEN
                    GenJnlLine.INSERT;
                    END; }
                    
                    {//  MESSAGE('%1',"Withholding Tax Code");
                    TarriffCodes.RESET;
                    TarriffCodes.SETRANGE(TarriffCodes.Code,"Withholding Tax Code");
                    IF TarriffCodes.FIND('-') THEN BEGIN
                    TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
                    LineNo:=LineNo+1000;
                    
                    //Add PV-Lines
                       PVLines.RESET;
                       PVLines.SETRANGE(PVLines."PV No",No);
                       IF FIND('+') THEN
                       LastPVLine:=PVLines."Line No";
                      CALCFIELDS("Total Amount");
                    
                      PVLines.INIT;
                      PVLines."PV No":=No;
                      PVLines."Line No":=LastPVLine+80000;
                      PVLines."Account Type":=PVLines."Account Type"::"G/L Account";
                      PVLines."Account No.":=TarriffCodes."G/L Account";
                      PVLines.VALIDATE(PVLines."Account No.");
                      PVLines.Amount:=-(TarriffCodes.Percentage/100)*"Total Amount";
                      PVLines.Description:='Withholding Tax';
                      PVLines.INSERT;
                      //MESSAGE('Adding Withholding Tax');
                    //End
                    }
                    
                    {
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name":='PAYMENTS';
                    GenJnlLine."Journal Batch Name":=No;
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No.":=TarriffCodes."G/L Account";
                    //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date":=Date;
                    GenJnlLine."Document No.":=No;
                    GenJnlLine.Amount:=-"Withholding Tax Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No.":='';
                    GenJnlLine.Description:=Remarks;
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code":="Global Dimension 2 Code";
                    //GenJnlLine."Investment Code":=Currency;
                    //GenJnlLine."Type of Investment":="Exchange Rate";
                    //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                    GenJnlLine."Currency Code":=Currency;
                    GenJnlLine.VALIDATE("Currency Code");
                    GenJnlLine."Applies-to Doc. No.":="Apply to";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                    
                    IF GenJnlLine.Amount<>0 THEN
                    GenJnlLine.INSERT;
                    END;
                     }
                    {
                    LineNo:=LineNo+1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name":='PAYMENTS';
                    GenJnlLine."Journal Batch Name":=No;
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":="Account Type";
                    GenJnlLine."Account No.":="Account No.";
                    IF GenJnlLine."Account Type"=GenJnlLine."Account Type"::"Fixed Asset" THEN
                    BEGIN
                    GenJnlLine."FA Posting Type":=GenJnlLine."FA Posting Type"::"Acquisition Cost";
                    FaDepreciation.RESET;
                    FaDepreciation.SETRANGE(FaDepreciation."FA No.",GenJnlLine."Account No.");
                    IF FaDepreciation.FIND('-') THEN
                    
                    GenJnlLine."Depreciation Book Code":=FaDepreciation."Depreciation Book Code";
                    GenJnlLine.VALIDATE("Depreciation Book Code");
                    GenJnlLine."FA Posting Date":=GenJnlLine."Posting Date";
                    END;
                    //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date":=Date;
                    GenJnlLine."Document No.":=No;
                    GenJnlLine."External Document No.":="Cheque No";
                    GenJnlLine.Amount:=Amount;
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No.":='';
                    GenJnlLine.Description:=Remarks;
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code":="Global Dimension 2 Code";
                    GenJnlLine."Currency Code":=Currency;
                    GenJnlLine.VALIDATE("Currency Code");
                    //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    //GenJnlLine."Investment Code":=Currency;
                    //GenJnlLine."Type of Investment":="Exchange Rate";
                    //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                    GenJnlLine."Applies-to Doc. No.":="Apply to";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                    
                    IF GenJnlLine.Amount<>0 THEN
                    GenJnlLine.INSERT;
                     }
                    
                    PVLines.RESET;
                    PVLines.SETRANGE(PVLines."PV No",No);
                    IF PVLines.FIND('-') THEN
                    REPEAT
                    LineNo:=LineNo+1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name":='PAYMENTS';
                    GenJnlLine."Journal Batch Name":=No;
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":=PVLines."Account Type";
                    GenJnlLine."Account No.":=PVLines."Account No";
                    //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date":=Date;
                    GenJnlLine."Document No.":=No;
                    // added by debbie
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                    GenJnlLine."External Document No.":="Cheque No";
                    GenJnlLine.Amount:=PVLines.Amount;
                    
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No.":='';
                    GenJnlLine.Description:=PVLines.Description;
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
                    GenJnlLine."Currency Code":=Currency;
                    
                    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                    GenJnlLine."Currency Factor":="Exchange Factor";
                    GenJnlLine."Loan No":=PVLines."Loan No";
                    
                    //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    //GenJnlLine."Investment Code":=Currency;
                    //GenJnlLine."Type of Investment":="Exchange Rate";
                    //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Applies-to Doc. No.":="Apply to";
                    //GenJnlLine."Policy No":=PVLines."Policy No";
                    //GenJnlLine."Claim No":=PVLines."Claim No";
                    //GenJnlLine."Benefit ID":=PVLines."Benefit ID";
                    //GenJnlLine."Claimant ID":=PVLines."Claimant ID";
                    //GenJnlLine."Claim Line No":=PVLines."Claim Line Line No";
                    //GenJnlLine."Amt Premium Currency":=PVLines."Amt Premium Currency";
                    //GenJnlLine."Amt Reporting Currency":=PVLines."Amt Reporting Currency";
                    GenJnlLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
                    //MESSAGE('here');
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                    IF GenJnlLine.Amount<>0 THEN
                    
                    {IF ClaimRec.GET(PVLines."Claim No") THEN
                    BEGIN
                    END;}
                    
                    
                    GenJnlLine.INSERT;
                    
                    
                    
                    UNTIL PVLines.NEXT=0;
                    
                    
                    CALCFIELDS("Total Amount");
                    
                    //BANK
                    IF "Pay Mode"='CASH' THEN BEGIN
                    //CASH
                    LineNo:=LineNo+1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name":='PAYMENTS';
                    GenJnlLine."Journal Batch Name":=No;
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
                    GenJnlLine."Account No.":="Paying Bank Account";
                    //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date":=Date;
                    GenJnlLine."Document No.":=No;
                    //GenJnlLine.Name:=Payee;
                    GenJnlLine."External Document No.":="Cheque No";
                    GenJnlLine.Amount:=-"Total Amount";
                    
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No.":='';
                    GenJnlLine.Description:=Payee;
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code":="Global Dimension 2 Code";
                    GenJnlLine."Currency Code":=Currency;
                    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                    GenJnlLine."Currency Factor":="Exchange Factor";
                    //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    //GenJnlLine."Investment Code":=Currency;
                    //GenJnlLine."Type of Investment":="Exchange Rate";
                    //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Applies-to Doc. No.":="Apply to";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                    IF GenJnlLine.Amount<>0 THEN
                    
                    GenJnlLine.INSERT;
                    END
                    ELSE BEGIN
                    //CHEQUE
                    LineNo:=LineNo+1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name":='PAYMENTS';
                    GenJnlLine."Journal Batch Name":=No;
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::"Bank Account";
                    GenJnlLine."Account No.":="Paying Bank Account";
                    //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    //GenJnlLine.Name:=Payee;
                    GenJnlLine."Posting Date":=Date;
                    GenJnlLine."Document No.":=No;
                    GenJnlLine."External Document No.":="Cheque No";
                    GenJnlLine.Amount:=-"Total Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No.":='';
                    GenJnlLine.Description:=Payee;
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code":="Global Dimension 2 Code";
                    GenJnlLine."Currency Code":=Currency;
                    GenJnlLine.VALIDATE("Currency Code");
                    GenJnlLine."Currency Factor":="Exchange Factor";
                    //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    //GenJnlLine."Investment Code":=Currency;
                    //GenJnlLine."Type of Investment":="Exchange Rate";
                    //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                    GenJnlLine."Applies-to Doc. No.":="Apply to";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                    
                    
                    IF GenJnlLine.Amount<>0 THEN
                    GenJnlLine.INSERT;
                    END;
                    
                         //Added by Kimutai
                     //POSTING TAX WITHHELD TO GENERAL JOURNAL
                    
                       PVLines.RESET;
                       PVLines.SETRANGE(PVLines."PV No",No);
                     IF PVLines.FIND('-') THEN
                    
                     REPEAT
                    IF PVLines."W/Tax Amount"<>0 THEN BEGIN
                    LineNo:=LineNo+1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name":='PAYMENTS';
                    GenJnlLine."Journal Batch Name":=No;
                    GenJnlLine."Line No.":=LineNo;
                    GenJnlLine."Account Type":=GenJnlLine."Account Type"::Vendor;
                    GenJnlLine."Account No.":=PVLines."Account No";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date":=Date;
                    GenJnlLine."Document No.":=No;
                    // added by debbie
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                    GenJnlLine.Amount:=PVLines."W/Tax Amount";
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                    TarriffCodes.RESET;
                    IF TarriffCodes.FIND('-') THEN
                    GenJnlLine."Bal. Account No.":=TarriffCodes."G/L Account";
                    GenJnlLine.Description:='Tax Withheld-'+PVLines."Account Name";
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code":="Global Dimension 2 Code";
                    //GenJnlLine."Investment Code":=Currency;
                    //GenJnlLine."Type of Investment":="Exchange Rate";
                    //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                    GenJnlLine."Currency Code":=Currency;
                    GenJnlLine.VALIDATE("Currency Code");
                    GenJnlLine."Applies-to Doc. No.":="Apply to";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                    
                    IF GenJnlLine.Amount<>0 THEN
                    GenJnlLine.INSERT;
                    END;
                    UNTIL PVLines.NEXT=0;
                    
                    
                    
                    //end of Kimutai
                    
                    
                    
                    
                    
                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",'PAYMENTS');
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",No);
                    IF GenJnlLine.FIND('-') THEN
                    REPEAT
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                    GenJnlLine."Currency Factor":="Exchange Factor";
                    GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                    IF GenJnlLine."Applies-to Doc. No."<> ''THEN
                    BEGIN
                    GenJnlLine."Allow Application":=TRUE;
                    GenJnlLine."Applies-to Doc. Type":=GenJnlLine."Applies-to Doc. Type"::Invoice;
                    END;
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. Type");
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                    
                    GenJnlLine.MODIFY;
                    UNTIL GenJnlLine.NEXT=0;
                    
                    
                    
                    
                    
                    
                    
                    
                    AdjustConversion.RUN(GenJnlLine);
                    
                    
                    
                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",'PAYMENTS');
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",No);
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnlLine);
                    
                    
                    
                    
                    BankLedger.RESET;
                    BankLedger.SETCURRENTKEY(BankLedger."Document No.",BankLedger."Posting Date");
                    BankLedger.SETRANGE(BankLedger."Document No.",No);
                    
                    IF BankLedger.FIND('-') THEN
                    BEGIN
                    
                    Posted:=TRUE;
                    "Date Posted":=TODAY;
                    "Time Posted":=TIME;
                    "Posted By":=USERID;
                    MODIFY;
                    
                    IF BankAcc.GET("Paying Bank Account") THEN
                    BEGIN
                    BankAcc."Last Check No.":=INCSTR(BankAcc."Last Check No.");
                    BankAcc.MODIFY;
                    END;
                    
                    PVLines.RESET;
                    PVLines.SETRANGE(PVLines."PV No",No);
                    IF PVLines.FIND('-') THEN
                    REPEAT
                     IF ClaimLines.GET(PVLines."Claim No",PVLines."Claim Line Line No") THEN;
                    
                    
                    UNTIL PVLines.NEXT=0;
                    
                    
                    //Committment Posting
                    
                    RequestLines.SETRANGE(RequestLines."Document No","Imprest No");
                    IF RequestLines.FINDFIRST THEN BEGIN
                      IF CommittmentEntries.FINDLAST THEN
                      LastEntry:=CommittmentEntries."Entry No";
                     REPEAT
                       LastEntry:=LastEntry+1;
                       CommittmentEntries.INIT;
                       CommittmentEntries."Entry No":=LastEntry;
                       CommittmentEntries."Commitment Date":=Date;
                       CommittmentEntries."Document No.":="Imprest No";
                       CommittmentEntries.Amount:=RequestLines."Requested Amount";
                       CommittmentEntries."Global Dimension 1 Code":="Global Dimension 1 Code";
                       CommittmentEntries."Commitment Type":=CommittmentEntries."Commitment Type"::IMPREST;
                       CommittmentEntries."Budget Line":=RequestLines."Account No";
                       CommittmentEntries."Global Dimension 2 Code":="Global Dimension 2 Code";
                       CommittmentEntries."User ID":=USERID;
                       CommittmentEntries."Time Stamp":=TIME;
                       CommittmentEntries.Description:=RequestLines.Description;
                       CommittmentEntries.INSERT;
                     UNTIL RequestLines.NEXT=0;
                    END;
                    END;
                    //End of Commit;
                    }*/

                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    RESET;
                    SETFILTER(No, No);
                    REPORT.RUN(51511013, TRUE, TRUE, Rec);
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

                trigger OnAction();
                begin
                    GLSetup.GET();
                    Link := GLSetup."DMS PV Link" + No;

                    HYPERLINK(Link);
                end;
            }
            action("Import Payments")
            {
                Caption = 'Import Payments';

                trigger OnAction();
                begin
                    //PaymentImport.GetRec(Rec);
                    //PaymentImport.RUN;
                end;
            }
            action(ApprovalEntries)
            {
                Caption = 'Approvals';
                Image = Approvals;

                trigger OnAction();
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                end;
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin

                        PVPosting.PrecheckPV(Rec);

                        IF ApprovalMgtExt.CheckPaymentsHeaderApprovalWFEnabled(Rec) THEN
                            ApprovalMgtExt.OnSendPaymentsHeaderApprovalRequest(Rec);


                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        IF ApprovalMgtExt.CheckPaymentsHeaderApprovalWFEnabled(Rec) THEN
                            ApprovalMgtExt.OnCancelPaymentsHeaderApprovalRequest(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        SetControlAppearance;
    end;

    trigger OnDeleteRecord(): Boolean;
    begin
        IF Posted THEN
            ERROR('You cannot delete the details of the payment voucher at this stage');
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        /*IF Posted THEN
        ERROR('You cannot change the details of the payment voucher at this stage');*/
        /*IF Posted=TRUE THEN
        ERROR('The transaction has already been posted and therefore cannot be modified.');
        IF Status<>Status::Open THEN
        BEGIN
        ERROR('You cannot modify this voucher');
        END;*/

    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        // CurrForm.EDITABLE:=TRUE;
        "Payment Type" := "Payment Type"::Normal;
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        CurrPage.EDITABLE := TRUE;
    end;

    trigger OnOpenPage();
    begin
        CurrPage.EDITABLE := TRUE;
    end;

    var
        RecPayTypes: Record 51511002;
        TarriffCodes: Record 51511008;
        GenJnlLine: Record 81;
        DefaultBatch: Record 232;
        LineNo: Integer;
        CustLedger: Record 25;
        CustLedger1: Record 25;
        Amt: Decimal;
        FaDepreciation: Record 5612;
        BankAcc: Record 270;
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
        ApprovalMgt: Codeunit 1535;
        ApprovalMgtExt: Codeunit "Approvals Mgmt. Ext";
        VATCert: Report 51511009;
        PVRec: Record 51511000;
        //suggestcoompayment : Report 51511017;
        //RequestHeader : Record 51511126;
        //RequestLines : Record 51511127;
        //CommittmentEntries : Record 51511117;
        LastEntry: Integer;
        //GenerateClaimPayable : Report 51511018;
        BankLedger: Record 271;
        //ClaimLines : Record 51511184;
        //SuggestCoomTax : Report 51511016;
        GlLineNo: Integer;
        GLSetup: Record "Cash Management setup";
        Link: Text[250];
        PaymentImport: XMLport 51511000;
        //CBAEFT : Report 51511362;
        CompanyInfo: Record 79;
        SenderAddress: Text[80];
        SenderName: Text[80];
        Subject: Text[100];
        Body: Text[250];
        Recipients: Text[80];
        SMTPSetup: Codeunit 400;
        FileName: Text[250];
        Vendor: Record 23;
        FileManagement: Codeunit 419;
        PVPosting: Codeunit 51511014;
        Reinslines: Record 51513070;
        InsMngt: Codeunit 51513000;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CICEFT: Report 51513111;
        CashMgtSetup: Record "Cash Management Setup";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        ApprovalsMgmt: Codeunit 1535;
        PaymentRelease: Codeunit 51403017;

    local procedure SetControlAppearance();
    var
        ApprovalsMgmt: Codeunit 1535;
    begin
        //JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        //HasIncomingDocument := "Incoming Document Entry No." <> 0;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        //MESSAGE('OpenApprovalEntriesExistForCurrUser for current user=%1',OpenApprovalEntriesExistForCurrUser);
        //MESSAGE('OpenApprovalEntriesExist',OpenApprovalEntriesExist);
    end;
}

