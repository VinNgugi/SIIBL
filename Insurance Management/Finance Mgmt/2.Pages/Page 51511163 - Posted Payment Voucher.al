page 51511163 "Posted Payment Voucher"
{
    // version CSHBK

    Editable = true;
    PageType = Card;
    SourceTable = Payments1;
    SourceTableView = WHERE("Payment Type" = CONST(Normal), Posted = CONST(true));

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
                }
                field(Type; Type)
                {
                    Editable = false;
                }
                field("Paying Bank Account"; "Paying Bank Account")
                {
                    Editable = false;
                }
                field("Bank Name"; "Bank Name")
                {
                    Editable = false;
                }
                field(Payee; Payee)
                {
                    Editable = false;
                }
                field("Pay Mode"; "Pay Mode")
                {
                    Editable = false;
                }
                field("Cheque No"; "Cheque No")
                {
                    Editable = false;
                }
                field("Cancellation Reason"; "Cancellation Reason")
                {
                    Editable = NoValue;
                }
                field("Exchange Rate"; "Exchange Rate")
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
                field(Cashier; Cashier)
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Withholding Tax Code"; "Withholding Tax Code")
                {
                    Editable = false;
                }
                field(Currency; Currency)
                {
                    Editable = false;
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field(Collected; Collected)
                {
                    Editable = false;
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
                action("Suggest Claims to be Paid")
                {
                    Caption = 'Suggest Claims to be Paid';

                    trigger OnAction();
                    begin
                        // Suggestpay.GetPaymentRec(Rec);
                        // Suggestpay.RUN;
                    end;
                }
                action("Remittance Advice")
                {
                    Caption = 'Remittance Advice';

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
                action("Claim Advice")
                {
                    Caption = 'Claim Advice';

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
            }
            action("Cancel PV")
            {
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction();
                begin
                    PayRelease.CancelPV(Rec);
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
                begin
                    LineNo := 0;
                    CALCFIELDS("Total Amount");
                    IF Posted THEN
                        ERROR('The transaction has already been posted.');


                    IF "Pay Mode" = 'CHEQUE' THEN BEGIN
                        TESTFIELD("Paying Bank Account");
                        TESTFIELD("Cheque No");
                        //TESTFIELD("Cheque Date");
                        //TESTFIELD("Cheque Type");
                        //TESTFIELD("Bank Code");
                    END;
                    //TESTFIELD(Remarks);
                    TESTFIELD("Pay Mode");
                    TESTFIELD(Payee);
                    TESTFIELD("Total Amount");
                    //TESTFIELD("VAT Code");
                    //TESTFIELD("Withholding Tax Code");
                    //TESTFIELD("Global Dimension 1 Code");
                    //TESTFIELD("Global Dimension 2 Code");

                    /*CashierLinks.RESET;
                    CashierLinks.SETRANGE(CashierLinks.UserID,USERID);
                    IF CashierLinks.FIND('-') THEN BEGIN
                    END
                    ELSE BEGIN
                    ERROR('Please link the user/cashier to a collection account before proceeding.');
                    END;*/


                    // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", 'PAYMENTS');
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", No);
                    GenJnlLine.DELETEALL;

                    IF DefaultBatch.GET('PAYMENTS', No) THEN
                        DefaultBatch.DELETE;

                    DefaultBatch.RESET;
                    DefaultBatch."Journal Template Name" := 'PAYMENTS';
                    DefaultBatch.Name := No;
                    DefaultBatch.INSERT;







                    TarriffCodes.RESET;
                    TarriffCodes.SETRANGE(TarriffCodes.Code, "VAT Code");
                    IF TarriffCodes.FIND('-') THEN BEGIN
                        TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
                        LineNo := LineNo + 1000;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := 'PAYMENTS';
                        GenJnlLine."Journal Batch Name" := No;
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine."Account No." := TarriffCodes."G/L Account";
                        GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Posting Date" := Date;
                        GenJnlLine."Document No." := No;
                        GenJnlLine.Amount := -"VAT Amount";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Description := 'VAT';
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                        GenJnlLine."Currency Code" := Currency;
                        GenJnlLine.VALIDATE("Currency Code");
                        //GenJnlLine."Investment Code":=Currency;
                        //GenJnlLine."Type of Investment":="Exchange Rate";
                        //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                        GenJnlLine."Applies-to Doc. No." := "Apply to";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");

                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                    END;

                    //  MESSAGE('%1',"Withholding Tax Code");
                    TarriffCodes.RESET;
                    TarriffCodes.SETRANGE(TarriffCodes.Code, "Withholding Tax Code");
                    IF TarriffCodes.FIND('-') THEN BEGIN
                        TarriffCodes.TESTFIELD(TarriffCodes."G/L Account");
                        LineNo := LineNo + 1000;

                        //Add PV-Lines
                        PVLines.RESET;
                        PVLines.SETRANGE(PVLines."PV No", No);
                        IF FIND('+') THEN
                            LastPVLine := PVLines."Line No";
                        CALCFIELDS("Total Amount");

                        PVLines.INIT;
                        PVLines."PV No" := No;
                        PVLines."Line No" := LastPVLine + 80000;
                        PVLines."Account Type" := PVLines."Account Type"::"G/L Account";
                        PVLines."Account No" := TarriffCodes."G/L Account";
                        PVLines.VALIDATE(PVLines."Account No");
                        PVLines.Amount := -(TarriffCodes.Percentage / 100) * "Total Amount";
                        PVLines.Description := 'Withholding Tax';
                        PVLines.INSERT;
                        //MESSAGE('Adding Withholding Tax');
                        //End

                        /*GenJnlLine.INIT;
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
                        GenJnlLine.INSERT;*/
                    END;

                    LineNo := LineNo + 1000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := 'PAYMENTS';
                    GenJnlLine."Journal Batch Name" := No;
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Account Type" := "Account Type";
                    GenJnlLine."Account No." := "Account No.";
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" THEN BEGIN
                        GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost";
                        FaDepreciation.RESET;
                        FaDepreciation.SETRANGE(FaDepreciation."FA No.", GenJnlLine."Account No.");
                        IF FaDepreciation.FIND('-') THEN
                            GenJnlLine."Depreciation Book Code" := FaDepreciation."Depreciation Book Code";
                        GenJnlLine.VALIDATE("Depreciation Book Code");
                        GenJnlLine."FA Posting Date" := GenJnlLine."Posting Date";
                    END;
                    //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date" := Date;
                    GenJnlLine."Document No." := No;
                    GenJnlLine."External Document No." := "Cheque No";
                    GenJnlLine.Amount := Amount;
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '';
                    GenJnlLine.Description := Remarks;
                    GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                    GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                    GenJnlLine."Currency Code" := Currency;
                    GenJnlLine.VALIDATE("Currency Code");
                    //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    //GenJnlLine."Investment Code":=Currency;
                    //GenJnlLine."Type of Investment":="Exchange Rate";
                    //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                    GenJnlLine."Applies-to Doc. No." := "Apply to";
                    GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");

                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;


                    PVLines.RESET;
                    PVLines.SETRANGE(PVLines."PV No", No);
                    IF PVLines.FIND('-') THEN
                        REPEAT
                        /*
                        LineNo:=LineNo+1000;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name":='PAYMENTS';
                        GenJnlLine."Journal Batch Name":=No;
                        GenJnlLine."Line No.":=LineNo;
                        GenJnlLine."Account Type":=PVLines."Account Type";
                        GenJnlLine."Account No.":=PVLines."Account No.";
                        //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Posting Date":=Date;
                        GenJnlLine."Document No.":=No;
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

                        //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        //GenJnlLine."Investment Code":=Currency;
                        //GenJnlLine."Type of Investment":="Exchange Rate";
                        //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Applies-to Doc. No.":="Apply to";
                        GenJnlLine."Commissioner Name":=PVLines."Policy No";
                        GenJnlLine."Claim No":=PVLines."Claim No";
                        GenJnlLine."Benefit ID":=PVLines."Benefit ID";
                        GenJnlLine."Claimant ID":=PVLines."Claimant ID";
                        GenJnlLine."Claim Line No":=PVLines."Line No";
                        GenJnlLine."Amt Premium Currency":=PVLines."Amt Premium Currency";
                        GenJnlLine."Amt Reporting Currency":=PVLines."Amt Reporting Currency";
                        GenJnlLine."Applies-to Doc. No.":=PVLines."Applies-to Doc. No.";
                        IF GenJnlLine.Amount<>0 THEN

                        //IF ClaimRec.GET(PVLines."Claim No") THEN;


                        GenJnlLine.INSERT;


                        //Commission Splits

                             IF PolicyRec.GET(PVLines."Applies-to Doc. No.") THEN
                             BEGIN

                             PremiumControlAmt:=0;
                             TotalPercent:=100;

                             ProductPlanTax.RESET;
                             ProductPlanTax.SETRANGE(ProductPlanTax."Policy Type",PolicyRec."Policy Type");
                             IF ProductPlanTax.FIND('-') THEN
                             REPEAT
                              TotalPercent:=TotalPercent+ProductPlanTax."Loading %";
                              TotalTaxPercent:=TotalTaxPercent+ProductPlanTax."Loading %";
                             UNTIL ProductPlanTax.NEXT=0;

                             BasePremium:=(100/TotalPercent)*PVLines.Amount;

                             CommissionTab.RESET;
                             CommissionTab.SETRANGE(CommissionTab."Receipt No",PVLines."PV No");

                             //CommissionTab.SETRANGE(CommissionTab."Policy Type",PolicyRec."Policy Type");
                             //IF PolicyRec."Quote Type"<>PolicyRec."Quote Type"::Renewal THEN
                             //CommissionTab.SETRANGE(CommissionTab."Applicable to",CommissionTab."Applicable to"::New)
                             //ELSE
                             //CommissionTab.SETRANGE(CommissionTab."Applicable to",CommissionTab."Applicable to"::Renewals);
                             IF CommissionTab.FIND('-') THEN
                             REPEAT




                             GenJnlLine.INIT;
                             GenJnlLine."Journal Template Name":='PAYMENTS';
                             GenJnlLine."Journal Batch Name":=No;
                             GenJnlLine."Line No.":=GenJnlLine."Line No."+10000;
                             GenJnlLine."Account Type":=GenJnlLine."Account Type"::Vendor;
                             GenJnlLine."Account No.":=CommissionTab."UnderWriter/Broker";
                             GenJnlLine."Posting Date":=Date;
                             GenJnlLine."Document Date":=Date;
                             GenJnlLine."Document No.":=No;
                             GenJnlLine.Description:=PolicyRec."Sell-to Customer Name"+ ' '+ 'Premium Split';
                             GenJnlLine."Currency Code":=Currency;
                             GenJnlLine."Currency Factor":="Exchange Factor";
                             GenJnlLine.Amount:=ROUND(BasePremium*(CommissionTab."% age"/100));
                             PremiumControlAmt:=PremiumControlAmt+GenJnlLine.Amount;
                             //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                             GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                             //IF ProductPlan.GET(PolicyRec."Policy Type",PolicyRec.Underwriter) THEN
                             //GenJnlLine."Bal. Account No.":=ProductPlan."Premium Account";
                             GenJnlLine."Loan No":=Amount;
                             GenJnlLine."ED Code":=PVLines."Policy Type";
                             GenJnlLine."Commissioner Code":=TRUE;
                             GenJnlLine."Meeting ID":=PolicyRec."Sell-to Customer No.";
                             GenJnlLine."Commissioner Name":=PolicyRec."Policy No";
                             GenJnlLine."Commission Percentage":=CommissionTab."% age";
                             GenJnlLine."Meeting ID":=PolicyRec."Sell-to Customer No.";
                             IF PolicyRec."Quote Type"=PolicyRec."Quote Type"::"1" THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"1";
                             IF PolicyRec."Quote Type"=PolicyRec."Quote Type"::"3" THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"2";
                             IF PolicyRec."Quote Type"=PolicyRec."Quote Type"::"2" THEN
                             BEGIN
                             IF PolicyRec."Modification Type"=PolicyRec."Modification Type"::"1"  THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"3";
                             IF PolicyRec."Modification Type"=PolicyRec."Modification Type"::"2" THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"4";
                             END;
                             GenJnlLine."Transaction Type":=GenJnlLine."Transaction Type"::"2";
                             GenJnlLine.VALIDATE(GenJnlLine.Amount);
                             IF GenJnlLine.Amount<>0 THEN
                             GenJnlLine.INSERT;
                             // MESSAGE('Gets here %1 %2',CommissionTab."UnderWriter/Broker",GenJnlLine.Amount);
                             UNTIL CommissionTab.NEXT=0;
                             END;

                             GenJnlLine.INIT;
                             GenJnlLine."Journal Template Name":='PAYMENTS';
                             GenJnlLine."Journal Batch Name":=No;
                             GenJnlLine."Line No.":=GenJnlLine."Line No."+10000;
                             GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                             IF ProductPlan.GET(PolicyRec."Policy Type",PolicyRec.Underwriter) THEN
                             GenJnlLine."Account No.":=ProductPlan."Premium Account";
                             GenJnlLine."Posting Date":=Date;
                             GenJnlLine."Document Date":=Date;
                             GenJnlLine."Document No.":=No;
                             GenJnlLine.Description:=PolicyRec."Sell-to Customer Name"+ ' '+ 'Premium Split';
                             GenJnlLine."Currency Code":=Currency;
                            GenJnlLine."Currency Factor":="Exchange Factor";
                             GenJnlLine.Amount:=-ROUND(PremiumControlAmt);
                             PremiumControlAmt:=PremiumControlAmt+GenJnlLine.Amount;
                             //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                             GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                             IF ProductPlan.GET(PVLines."Policy Type",PVLines.Underwriter) THEN
                             //GenJnlLine."Bal. Account No.":=ProductPlan."Premium Account";
                             GenJnlLine."Loan No":=Amount;
                             GenJnlLine."ED Code":=PVLines."Policy Type";
                             GenJnlLine."Commissioner Code":=TRUE;
                             GenJnlLine."Meeting ID":=PolicyRec."Sell-to Customer No.";
                             GenJnlLine."Commissioner Name":=PolicyRec."Policy No";
                             GenJnlLine."Commission Percentage":=CommissionTab."% age";
                             GenJnlLine."Meeting ID":=PolicyRec."Sell-to Customer No.";
                             IF PolicyRec."Quote Type"=PolicyRec."Quote Type"::"1" THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"1";
                             IF PolicyRec."Quote Type"=PolicyRec."Quote Type"::"3" THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"2";
                             IF PolicyRec."Quote Type"=PolicyRec."Quote Type"::"2" THEN
                             BEGIN
                             IF PolicyRec."Modification Type"=PolicyRec."Modification Type"::"1"  THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"3";
                             IF PolicyRec."Modification Type"=PolicyRec."Modification Type"::"2" THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"4";
                             END;
                             GenJnlLine."Transaction Type":=GenJnlLine."Transaction Type"::"2";
                             GenJnlLine.VALIDATE(GenJnlLine.Amount);
                             IF GenJnlLine.Amount<>0 THEN
                             GenJnlLine.INSERT;


                             ProductPlanTax.RESET;

                             ProductPlanTax.SETRANGE(ProductPlanTax."Policy Type",PolicyRec."Policy Type");
                             IF ProductPlanTax.FIND('-') THEN
                             REPEAT
                             GenJnlLine.INIT;
                             GenJnlLine."Journal Template Name":='PAYMENTS';
                             GenJnlLine."Journal Batch Name":=No;
                             GenJnlLine."Line No.":=GenJnlLine."Line No."+10000;
                             GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                             IF ProductPlan.GET(PolicyRec."Policy Type",PolicyRec.Underwriter) THEN
                             GenJnlLine."Account No.":=ProductPlan."Premium Account";
                             GenJnlLine."Posting Date":=Date;
                             GenJnlLine."Document Date":=Date;
                             GenJnlLine."Document No.":=No;
                             GenJnlLine.Description:=COPYSTR(PolicyRec."Sell-to Customer Name"+ ' '+ ProductPlanTax.Description,1,50);
                             GenJnlLine."Currency Code":=Currency;
                            GenJnlLine."Currency Factor":="Exchange Factor";
                             GenJnlLine.Amount:=-ROUND(BasePremium*(ProductPlanTax."Loading %"/100));
                             PremiumControlAmt:=PremiumControlAmt+GenJnlLine.Amount;
                             //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Payment;
                             GenJnlLine."Bal. Account Type":=GenJnlLine."Bal. Account Type"::"G/L Account";
                             GenJnlLine."Bal. Account No.":=ProductPlanTax."Account No";
                             GenJnlLine."Loan No":=Amount;
                             GenJnlLine."ED Code":=PVLines."Policy Type";
                             GenJnlLine."Commissioner Code":=TRUE;
                             GenJnlLine."Meeting ID":=PolicyRec."Sell-to Customer No.";
                             GenJnlLine."Commissioner Name":=PolicyRec."Policy No";
                             GenJnlLine."Commission Percentage":=CommissionTab."% age";
                             GenJnlLine."Meeting ID":=PolicyRec."Sell-to Customer No.";
                             IF PolicyRec."Quote Type"=PolicyRec."Quote Type"::"1" THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"1";
                             IF PolicyRec."Quote Type"=PolicyRec."Quote Type"::"3" THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"2";
                             IF PolicyRec."Quote Type"=PolicyRec."Quote Type"::"2" THEN
                             BEGIN
                             IF PolicyRec."Modification Type"=PolicyRec."Modification Type"::"1"  THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"3";
                             IF PolicyRec."Modification Type"=PolicyRec."Modification Type"::"2" THEN
                             GenJnlLine."Meeting Description":=GenJnlLine."Meeting Description"::"4";
                             END;
                             GenJnlLine."Transaction Type":=GenJnlLine."Transaction Type"::"2";
                             GenJnlLine.VALIDATE(GenJnlLine.Amount);
                             IF GenJnlLine.Amount<>0 THEN
                             GenJnlLine.INSERT;



                             UNTIL ProductPlanTax.NEXT=0;

                        */


                        UNTIL PVLines.NEXT = 0;


                    CALCFIELDS("Total Amount");

                    //BANK
                    IF "Pay Mode" = 'CASH' THEN BEGIN
                        //CASH
                        LineNo := LineNo + 1000;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := 'PAYMENTS';
                        GenJnlLine."Journal Batch Name" := No;
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                        GenJnlLine."Account No." := "Paying Bank Account";
                        //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Posting Date" := Date;
                        GenJnlLine."Document No." := No;
                        GenJnlLine."External Document No." := "Cheque No";
                        GenJnlLine.Amount := -"Total Amount";

                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Description := Payee;
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                        GenJnlLine."Currency Code" := Currency;
                        GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                        GenJnlLine."Currency Factor" := "Exchange Factor";
                        //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        //GenJnlLine."Investment Code":=Currency;
                        //GenJnlLine."Type of Investment":="Exchange Rate";
                        //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Applies-to Doc. No." := "Apply to";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");
                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                    END
                    ELSE BEGIN
                        //CHEQUE
                        LineNo := LineNo + 1000;
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := 'PAYMENTS';
                        GenJnlLine."Journal Batch Name" := No;
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                        GenJnlLine."Account No." := "Paying Bank Account";
                        //GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                        GenJnlLine."Posting Date" := Date;
                        GenJnlLine."Document No." := No;
                        GenJnlLine."External Document No." := "Cheque No";
                        GenJnlLine.Amount := -"Total Amount";
                        GenJnlLine.VALIDATE(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := '';
                        GenJnlLine.Description := Payee;
                        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                        GenJnlLine."Currency Code" := Currency;
                        GenJnlLine.VALIDATE("Currency Code");
                        GenJnlLine."Currency Factor" := "Exchange Factor";
                        //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                        //GenJnlLine."Investment Code":=Currency;
                        //GenJnlLine."Type of Investment":="Exchange Rate";
                        //GenJnlLine."No. Of Units":="Global Dimension 2 Code";
                        GenJnlLine."Applies-to Doc. No." := "Apply to";
                        GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");


                        IF GenJnlLine.Amount <> 0 THEN
                            GenJnlLine.INSERT;
                    END;




                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", 'PAYMENTS');
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", No);
                    IF GenJnlLine.FIND('-') THEN
                        REPEAT
                            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");
                            GenJnlLine."Currency Factor" := "Exchange Factor";
                            GenJnlLine.VALIDATE(GenJnlLine."Currency Code");
                            IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                                GenJnlLine."Allow Application" := TRUE;
                                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::"Credit Memo";
                            END;
                            GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. Type");
                            GenJnlLine.VALIDATE(GenJnlLine."Applies-to Doc. No.");

                            GenJnlLine.MODIFY;
                        UNTIL GenJnlLine.NEXT = 0;








                    AdjustConversion.RUN(GenJnlLine);



                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", 'PAYMENTS');
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", No);
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);
                    /*
                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name",'PAYMENTS');
                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name",No);
                    IF GenJnlLine.FIND('-') THEN
                    EXIT;
                    PVLines.RESET;
                    PVLines.SETRANGE(PVLines."PV No",No);
                    IF PVLines.FIND('-') THEN
                    REPEAT
                     ClaimLine.RESET;
                     ClaimLine.SETRANGE(ClaimLine."Claim No.",PVLines."Claim No");
                     ClaimLine.SETRANGE(ClaimLine."Line No.",PVLines."Claim Line Line No");
                     IF ClaimLine.FIND('-') THEN
                     BEGIN
                     ClaimLine.Paid:=TRUE;
                     ClaimLine.MODIFY;
                     //MESSAGE('Doing it');
                     END;
                    UNTIL PVLines.NEXT=0;
                    
                     */



                    Posted := TRUE;
                    "Date Posted" := TODAY;
                    "Time Posted" := TIME;
                    "Posted By" := USERID;
                    MODIFY;
                    IF BankAcc.GET("Paying Bank Account") THEN BEGIN
                        BankAcc."Last Check No." := INCSTR(BankAcc."Last Check No.");
                        BankAcc.MODIFY;
                    END;

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
            action("Print Cheque KES")
            {
                Caption = 'Print Cheque KES';
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
            action("Print Cheque USD")
            {
                Caption = 'Print Cheque USD';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    /*
                    RESET;
                    SETFILTER(No,No);
                    REPORT.RUN(50019,TRUE,TRUE,Rec);
                    RESET;
                     */

                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        IF "Cancellation Reason" = '' THEN
            NoValue := TRUE
        ELSE
            NoValue := FALSE;
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
        PayRelease: Codeunit 51403017;
        NoValue: Boolean;
}

