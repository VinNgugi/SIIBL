codeunit 51511014 "Payment- Post"
{

    trigger OnRun();
    begin
    end;

    var
        Batch : Record 232;
        CMSetup : Record "Cash management setup";
              Text000 : Label 'You cannot refund an amount that is greater than the what has been overpaid.\';
        Text001 : Label 'The refund should be %1 and not %2 as the overpayment is %3';
        Text002 : Label '%1 of %2 does''''nt exist on the Levy Types';
        ReinsureLines : Record 51513070;
        IntegrationSetup : Record 51513033;
        InsMgt : Codeunit 51513000;
        MDPSchedule : Record 51513462;
        payMode : Record 51511006;

    procedure PostPayment(PV : Record 51511000);
    var
        Batch : Record 232;
        PVLines : Record 51511001;
        GenJnLine : Record 81;
        LineNo : Integer;
        TarriffCodes : Record 51511008;
        VATSetup : Record 325;
        GLAccount : Record 15;
        Customer : Record 18;
        Vendor : Record 23;
        GLEntry : Record 17;
       // LevyRec : Record 51511317;
        //LastLevy : Record 51511317;
        EntryNo : Integer;
        //LevyTypeRec : Record "51511327";
        //LoanRec : Record "51507241";
        //LoanProduct : Record "51507240";
    begin
        
        
        IF CONFIRM('Are u sure u want to post the Payment Voucher No. '+PV.No+' ?')=TRUE THEN BEGIN
        
        IF PV.Status<>PV.Status::Released THEN
         ERROR('The Payment Voucher No %1 cannot be posted before it is fully approved',PV.No);
        IF payMode.GET(PV."Pay Mode") THEN
          BEGIN
          //IF payMode.Type=payMode.Type::Cheque THEN
          //IF PV."Cheque Printed"=FALSE THEN
          //ERROR('You must print a cheque for Payment Voucher %1 before posting',PV.No);
        
          IF payMode.Type=payMode.Type::EFT THEN
          IF PV."Eft Generated"=FALSE THEN
          ERROR('You must Generate EFT for Payment Voucher %1 before posting',PV.No);
          IF payMode.Type=payMode.Type::RTGS THEN
          IF PV."Eft Generated"=FALSE THEN
          ERROR('You must Generate RTGS for Payment Voucher %1 before posting',PV.No);
          END;
        
        IF PV.Posted THEN
         ERROR('Payment Voucher %1 has been posted',PV.No);
        
        InsMgt.CreatePVReinsEntries(PV);
        
        PV.TESTFIELD(Date);
        PV.TESTFIELD("Paying Bank Account");
        PV.TESTFIELD(PV.Payee);
        PV.TESTFIELD(PV."Pay Mode");
        
        IF PV."Pay Mode"='CHEQUE' THEN BEGIN
        
        PV.TESTFIELD(PV."Cheque No");
        //PV.TESTFIELD(PV."Cheque Date");
        END;
        
        //Check Lines
          PV.CALCFIELDS("Total Amount");
          IF PV."Total Amount"=0 THEN
          ERROR('Amount is cannot be zero');
          /*IF PV."Total Amount"<>PV.Amount THEN
          ERROR('Amount must be equal to Total amount on the Lines');*/
        
          PVLines.RESET;
          PVLines.SETRANGE(PVLines."PV No",PV.No);
          PVLines.SETFILTER(PVLines.Amount,'<>%1',0);
          IF NOT PVLines.FINDLAST THEN
          ERROR('Payment voucher Lines cannot be empty');
        
          CMSetup.GET();
          // Delete Lines Present on the General Journal Line
          GenJnLine.RESET;
          GenJnLine.SETRANGE(GenJnLine."Journal Template Name",CMSetup."Payment Voucher Template");
          GenJnLine.SETRANGE(GenJnLine."Journal Batch Name",PV.No);
          GenJnLine.DELETEALL;
        
          Batch.INIT;
          IF CMSetup.GET() THEN
          Batch."Journal Template Name":=CMSetup."Payment Voucher Template";
          Batch.Name:=PV.No;
          IF NOT Batch.GET(Batch."Journal Template Name",Batch.Name) THEN
          Batch.INSERT;
        
        //Bank Entries
        LineNo:=LineNo+10000;
        PV.CALCFIELDS(PV."Total Amount");
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        
        GenJnLine."Account Type":=GenJnLine."Account Type"::"Bank Account";
        GenJnLine."Account No.":=PV."Paying Bank Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PV.Payee;
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        IF PV."Exchange Rate"<>0 THEN
        GenJnLine."Currency Factor":=1/PV."Exchange Rate";
        
        GenJnLine.Amount:=-PV."Total Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PV."Global Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PV."Global Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        //GenJnLine."Dimension Set ID":=PVLines."Dimension Set ID";
        GenJnLine."Posting Date":=PV.Date;
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        //PV Lines Entries
        PVLines.RESET;
        PVLines.SETRANGE(PVLines."PV No",PV.No);
        IF PVLines.FINDFIRST THEN BEGIN
        REPEAT
        PVLines.VALIDATE(PVLines.Amount);
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        
        GenJnLine."Account Type":=PVLines."Account Type";
        GenJnLine."Account No.":=PVLines."Account No";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        
        GenJnLine.VALIDATE(GenJnLine."Posting Date");
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description;
        //GenJnLine."Description 2":=PVLines.Description;
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        IF PV."Exchange Rate"<>0 THEN
        GenJnLine."Currency Factor":=1/PV."Exchange Rate";
        
        GenJnLine.Amount:=PVLines."Net Amount";
        GenJnLine.VALIDATE(Amount);
        
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Dimension Set ID":=PVLines."Dimension Set ID";
        IF PVLines."Applies to Doc. No"<>'' THEN BEGIN
        GenJnLine."Applies-to Doc. Type":=PVLines."Applies-to Doc. Type";
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        END;
        //Bkk
        GenJnLine."Transaction Type":=PVLines."Transaction Type";
        GenJnLine."Loan No":=PVLines."Loan No";
        GenJnLine."Policy No":=PVLines."Policy No";
        GenJnLine."Insurance Trans Type":=PVLines."Insurance Trans Type";
        GenJnLine."Claim No.":=PVLines."Claim No";
        GenJnLine."Claimant ID":=PVLines."Claimant ID";
        GenJnLine."Policy Type":=PVLines."Policy Type";
        //MESSAGE('Claim No. =%1',PVLines."Claim No");
        //Bkk
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        //
        //MESSAGE('Posting date lines=%1',GenJnLine."Posting Date");
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
      //IF LoanRec.GET(PVLines."Loan No") THEN
        //BEGIN
          //LoanRec.CALCFIELDS(LoanRec."Total Posted Charges",LoanRec."Total Posted Commission",LoanRec."Total Loan Charges");
          //IF ABS(LoanRec."Total Loan Charges")-ABS(LoanRec."Total Posted Charges")>0 THEN
         // BEGIN
            /*LineNo:=LineNo+10000;
            GenJnLine.INIT;
            IF CMSetup.GET THEN
            GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
            GenJnLine."Journal Batch Name":=PV.No;
            GenJnLine."Line No.":=LineNo;
             IF PV.Date=0D THEN
              ERROR('You must specify the PV date');
            GenJnLine."Posting Date":=PV.Date;
        
            GenJnLine."Account Type":=PVLines."Account Type";
            GenJnLine."Account No.":=PVLines."Account No";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
        
            GenJnLine.VALIDATE(GenJnLine."Posting Date");
            GenJnLine."Document No.":=PV.No;
            GenJnLine."External Document No.":=PV."Cheque No";
            GenJnLine.Description:=PVLines.Description;
            //GenJnLine."Description 2":=PVLines.Description;
            GenJnLine."Currency Code":=PV.Currency;
            GenJnLine.VALIDATE(GenJnLine."Currency Code");
            IF PV."Exchange Rate"<>0 THEN
            GenJnLine."Currency Factor":=1/PV."Exchange Rate";
        
            GenJnLine.Amount:=LoanRec."Total Loan Charges"-LoanRec."Total Posted Charges";
            GenJnLine.VALIDATE(Amount);
        
            IF PV."Pay Mode"='CHEQUE' THEN
            GenJnLine."Pay Mode":=PV."Pay Mode";
        
            GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
            //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
            //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
            GenJnLine."Dimension Set ID":=PVLines."Dimension Set ID";
            IF PVLines."Applies to Doc. No"<>'' THEN BEGIN
            GenJnLine."Applies-to Doc. Type":=PVLines."Applies-to Doc. Type";
            GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
            GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
            END;
            //Bkk
            GenJnLine."Transaction Type":=PVLines."Transaction Type"::"Admin Charges";
            GenJnLine."Loan No":=PVLines."Loan No";
        
            //Bkk
            //Set these fields to blanks
            GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
            GenJnLine.VALIDATE("Gen. Posting Type");
            GenJnLine."Gen. Bus. Posting Group":='';
            GenJnLine.VALIDATE("Gen. Bus. Posting Group");
            GenJnLine."Gen. Prod. Posting Group":='';
            GenJnLine.VALIDATE("Gen. Prod. Posting Group");
            GenJnLine."VAT Bus. Posting Group":='';
            GenJnLine.VALIDATE("VAT Bus. Posting Group");
            GenJnLine."VAT Prod. Posting Group":='';
            GenJnLine.VALIDATE("VAT Prod. Posting Group");
            GenJnLine."Bal. Account Type":=GenJnLine."Bal. Account Type"::"G/L Account";
            //IF LoanProduct.GET(LoanRec."Loan Product Type") THEN
            //GenJnLine."Bal. Account No.":=LoanProduct."Admin Fee Account";
        
            //
            //MESSAGE('Posting date lines=%1',GenJnLine."Posting Date");
            IF GenJnLine.Amount<>0 THEN
             GenJnLine.INSERT;
            END;
          /*IF ABS(LoanRec."Agent Commission Amount")-ABS(LoanRec."Total Posted Commission")>0 THEN
          BEGIN
            LineNo:=LineNo+10000;
            GenJnLine.INIT;
            IF CMSetup.GET THEN
            GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
            GenJnLine."Journal Batch Name":=PV.No;
            GenJnLine."Line No.":=LineNo;
             IF PV.Date=0D THEN
              ERROR('You must specify the PV date');
            GenJnLine."Posting Date":=PV.Date;
        
            GenJnLine."Account Type":=GenJnLine."Account Type"::Vendor;
            GenJnLine."Account No.":=LoanRec."Agent Code";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
        
            GenJnLine.VALIDATE(GenJnLine."Posting Date");
            GenJnLine."Document No.":=PV.No;
            GenJnLine."External Document No.":=PV."Cheque No";
            GenJnLine.Description:=PVLines.Description;
            //GenJnLine."Description 2":=PVLines.Description;
            GenJnLine."Currency Code":=PV.Currency;
            GenJnLine.VALIDATE(GenJnLine."Currency Code");
            IF PV."Exchange Rate"<>0 THEN
            GenJnLine."Currency Factor":=1/PV."Exchange Rate";
        
            GenJnLine.Amount:=-(ABS(LoanRec."Agent Commission Amount")-ABS(LoanRec."Total Posted Commission"));
            GenJnLine.VALIDATE(Amount);
        
            IF PV."Pay Mode"='CHEQUE' THEN
            GenJnLine."Pay Mode":=PV."Pay Mode";
        
            GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
            //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
            //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
            GenJnLine."Dimension Set ID":=PVLines."Dimension Set ID";
            IF PVLines."Applies to Doc. No"<>'' THEN BEGIN
            GenJnLine."Applies-to Doc. Type":=PVLines."Applies-to Doc. Type";
            GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
            GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
            END;
            //Bkk
            GenJnLine."Transaction Type":=PVLines."Transaction Type"::Commission;
            GenJnLine."Loan No":=PVLines."Loan No";
        
            //Bkk
            //Set these fields to blanks
            GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
            GenJnLine.VALIDATE("Gen. Posting Type");
            GenJnLine."Gen. Bus. Posting Group":='';
            GenJnLine.VALIDATE("Gen. Bus. Posting Group");
            GenJnLine."Gen. Prod. Posting Group":='';
            GenJnLine.VALIDATE("Gen. Prod. Posting Group");
            GenJnLine."VAT Bus. Posting Group":='';
            GenJnLine.VALIDATE("VAT Bus. Posting Group");
            GenJnLine."VAT Prod. Posting Group":='';
            GenJnLine.VALIDATE("VAT Prod. Posting Group");
            GenJnLine."Bal. Account Type":=GenJnLine."Bal. Account Type"::"G/L Account";
            //IF LoanProduct.GET(LoanRec."Loan Product Type") THEN
            //GenJnLine."Bal. Account No.":=LoanProduct."Agency Commission Account";
        
            //
            //MESSAGE('Posting date lines=%1',GenJnLine."Posting Date");
            IF GenJnLine.Amount<>0 THEN
             GenJnLine.INSERT;
        
        
        
        
        
          END;
        ///LoanRec.Posted:=TRUE;
         //LoanRec."Issued Date":=WORKDATE;
         //LoanRec."Time Posted":=TIME;
         //LoanRec.MODIFY;
        
        
        //END;
        
        
        
        
        /*
        //Post Retention
        IF PVLines."Retention Code"<>'' THEN BEGIN
        PVLines.VALIDATE(PVLines.Amount);
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=PVLines."Account Type";
        GenJnLine."Account No.":=PVLines."Account No";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description+'-Retention';
        GenJnLine.Amount:=PVLines."Retention Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        //
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        //GenJnLine."Dimension Set ID":=PVLines."Dimension Set ID";
        {
        GenJnLine."Applies-to Doc. Type":=GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        }
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
        CASE PVLines."Account Type" OF
        PVLines."Account Type"::"G/L Account":
        BEGIN
        GLAccount.GET(PVLines."Account No");
        GLAccount.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(GLAccount."VAT Bus. Posting Group",PVLines."Retention Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        PVLines."Account Type"::Vendor:
        BEGIN
        Vendor.GET(PVLines."Account No");
        Vendor.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(Vendor."VAT Bus. Posting Group",PVLines."Retention Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        PVLines."Account Type"::Customer:
        BEGIN
        Customer.GET(PVLines."Account No");
        Customer.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(Customer."VAT Bus. Posting Group",PVLines."Retention Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        END;
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine.VALIDATE(GenJnLine."Posting Date");
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description+'-Retention';
        GenJnLine.Amount:=-PVLines."Retention Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        //
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Dimension Set ID":=PVLines."Dimension Set ID";
        {
        GenJnLine."Applies-to Doc. Type" := GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        }
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        END;
        //End of Posting Retention
        
        
        //Post VAT
        IF CMSetup."Post VAT" THEN BEGIN
        IF PV."VAT Code"<>'' THEN BEGIN
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=PVLines."Account Type";
        GenJnLine."Account No.":=PVLines."Account No";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description+'-VAT';
        GenJnLine.Amount:=PVLines."VAT Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        //
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Dimension Set ID":=PVLines."Dimension Set ID";
        {
        GenJnLine."Applies-to Doc. Type":=GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        }
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
        CASE PVLines."Account Type" OF
        PVLines."Account Type"::"G/L Account":
        BEGIN
        GLAccount.GET(PVLines."Line No");
        GLAccount.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(GLAccount."VAT Bus. Posting Group",PV."VAT Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        PVLines."Account Type"::Vendor:
        BEGIN
        Vendor.GET(PVLines."Account No");
        Vendor.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(Vendor."VAT Bus. Posting Group",PV."VAT Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        PVLines."Account Type"::Customer:
        BEGIN
        Customer.GET(PVLines."Account No");
        Customer.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(Customer."VAT Bus. Posting Group",PV."VAT Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        END;
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description+'-VAT';
        GenJnLine.Amount:=-PVLines."VAT Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        //
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Dimension Set ID":=PVLines."Dimension Set ID";
        {
        GenJnLine."Applies-to Doc. Type" := GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        }
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        END;
        //End of Posting VAT
        END;
        //Post Withholding Tax
        IF PVLines."W/Tax Code"<>'' THEN BEGIN
        PVLines.VALIDATE(PVLines.Amount);
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=PVLines."Account Type";
        GenJnLine."Account No.":=PVLines."Account No";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description+'-WHT';
        GenJnLine.Amount:=PVLines."W/Tax Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        //
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Dimension Set ID":=PVLines."Dimension Set ID";
        {
        GenJnLine."Applies-to Doc. Type":=GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        }
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
        CASE PVLines."Account Type" OF
        PVLines."Account Type"::"G/L Account":
        BEGIN
        GLAccount.GET(PVLines."Account No");
        GLAccount.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(GLAccount."VAT Bus. Posting Group",PVLines."W/Tax Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        PVLines."Account Type"::Vendor:
        BEGIN
        Vendor.GET(PVLines."Account No");
        Vendor.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(Vendor."VAT Bus. Posting Group",PVLines."W/Tax Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        PVLines."Account Type"::Customer:
        BEGIN
        Customer.GET(PVLines."Account No");
        Customer.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(Customer."VAT Bus. Posting Group",PVLines."W/Tax Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        END;
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description+'-WHT';
        GenJnLine.Amount:=-PVLines."W/Tax Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        //
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        //GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Dimension Set ID":=PVLines."Dimension Set ID";
        {
        GenJnLine."Applies-to Doc. Type" := GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        }
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        END;*/
        //End of Posting Withholding Tax
        
        UNTIL PVLines.NEXT=0;
        END;
        end;
    
        
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnLine);
        GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.",PV.No);
        GLEntry.SETRANGE(GLEntry.Reversed,FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN
        PV.Posted:=TRUE;
        PV."Posted By":=USERID;
        PV."Date Posted":=TODAY;
        PV."Time Posted":=TIME;
        PV.MODIFY;
        END;
        
        END;

    

    //procedure PostLevies(LevyReceipt : Record 51511319);
    /*var
        LevyReceiptLines : Record 51511320;
        LineNo : Integer;
        GenJnLine : Record 81;
        GLEntry : Record 17;
    begin
        /*
        IF CONFIRM('Are u sure u want to post the Levy Receipt No. '+LevyReceipt.No+' ?')=TRUE THEN BEGIN
        IF LevyReceipt.Posted THEN
         ERROR('Levy Receipt %1 has been posted',LevyReceipt.No);
        LevyReceipt.TESTFIELD("Receipt Date");
        LevyReceipt.TESTFIELD("Bank Code");
        LevyReceipt.TESTFIELD("Payment Mode");
        IF LevyReceipt."Payment Mode"='CHEQUE' THEN BEGIN
        LevyReceipt.TESTFIELD("Cheque No.");
        LevyReceipt.TESTFIELD("Cheque Date");
        END;
        
        //Check Lines
          LevyReceipt.CALCFIELDS(Amount);
          IF LevyReceipt.Amount=0 THEN
          ERROR('Amount cannot be zero');
          LevyReceiptLines.RESET;
          LevyReceiptLines.SETRANGE("Registration No.",LevyReceipt.No);
          IF NOT LevyReceiptLines.FINDLAST THEN
          ERROR('Levy Receipt Lines cannot be empty');
        
          CMSetup.GET();
          CMSetup.TESTFIELD("Receipt Template");
          // Delete Lines Present on the General Journal Line
          GenJnLine.RESET;
          GenJnLine.SETRANGE(GenJnLine."Journal Template Name",CMSetup."Receipt Template");
          GenJnLine.SETRANGE(GenJnLine."Journal Batch Name",LevyReceipt.No);
          GenJnLine.DELETEALL;
        
          Batch.INIT;
          IF CMSetup.GET() THEN
          Batch."Journal Template Name":=CMSetup."Receipt Template";
          Batch.Name:=LevyReceipt.No;
          IF NOT Batch.GET(Batch."Journal Template Name",Batch.Name) THEN
          Batch.INSERT;
        
        //Bank Entries
        LineNo:=LineNo+10000;
        LevyReceipt.CALCFIELDS(Amount);
        LevyReceiptLines.RESET;
        LevyReceiptLines.SETRANGE("Registration No.",LevyReceipt.No);
        LevyReceiptLines.VALIDATE(Amount);
        LevyReceiptLines.CALCSUMS(Amount);
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Receipt Template";
        GenJnLine."Journal Batch Name":=LevyReceipt.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=GenJnLine."Account Type"::"Bank Account";
        GenJnLine."Account No.":=LevyReceipt."Bank Code";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
         IF LevyReceipt."Receipt Date"=0D THEN
          ERROR('You must specify the Receipt date');
        GenJnLine."Posting Date":=LevyReceipt."Receipt Date";
        GenJnLine."Document No.":=LevyReceipt.No;
        GenJnLine."External Document No.":=LevyReceipt."Cheque No.";
        GenJnLine.Description:=LevyReceipt."Paid in By";
        GenJnLine.Amount:=LevyReceipt.Amount;
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=LevyReceipt."Currency Code";
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        GenJnLine."Pay Mode":=LevyReceipt."Payment Mode";
        IF LevyReceipt."Payment Mode"='CHEQUE' THEN
        GenJnLine."Cheque Date":=LevyReceipt."Cheque Date";
        GenJnLine."Shortcut Dimension 1 Code":=LevyReceipt."Global Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=LevyReceipt."Global Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        //Levy Receipt Lines Entries
        LevyReceiptLines.RESET;
        LevyReceiptLines.SETRANGE("Registration No.",LevyReceipt.No);
        IF GenJnLine.FIND('-') THEN BEGIN
        REPEAT
        LevyReceiptLines.VALIDATE(Amount);
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=LevyReceipt.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=GenJnLine."Account Type"::Customer;
        GenJnLine."Account No.":=LevyReceiptLines."Customer No.";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
         IF LevyReceipt."Receipt Date"=0D THEN
          ERROR('You must specify the Receipt date');
        GenJnLine."Posting Date":=LevyReceipt."Receipt Date";
        GenJnLine."Document No.":=LevyReceipt.No;
        GenJnLine."External Document No.":=LevyReceipt."Cheque No.";
        GenJnLine.Description:=LevyReceiptLines."In Payment For";
        GenJnLine.Amount:=-LevyReceiptLines.Amount;
        GenJnLine.VALIDATE(Amount);
        IF LevyReceipt."Payment Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=LevyReceipt."Payment Mode";
        GenJnLine."Currency Code":=LevyReceipt."Currency Code";
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        GenJnLine."Shortcut Dimension 1 Code":=LevyReceiptLines."Global Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=LevyReceiptLines."Global Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        IF LevyReceiptLines."Applies to Doc. No"<>'' THEN BEGIN
        GenJnLine."Applies-to Doc. Type" := GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=LevyReceiptLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        END;
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        UNTIL LevyReceiptLines.NEXT=0;
        END;
        
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnLine);
        GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.",LevyReceipt.No);
        GLEntry.SETRANGE(GLEntry.Reversed,FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN
        LevyReceipt.Posted:=TRUE;
        LevyReceipt."Posted By":=USERID;
        LevyReceipt."Posted Date":=TODAY;
        LevyReceipt."Posted Time":=TIME;
        LevyReceipt.MODIFY;
        END;
        
        END;
         */

   // end;

    procedure PostBatch(PV : Record 51511000);
    var
        Batch : Record 232;
        PVLines : Record 51511001;
        GenJnLine : Record 81;
        LineNo : Integer;
        TarriffCodes : Record 51511008;
        VATSetup : Record 325;
        GLAccount : Record 15;
        Customer : Record 18;
        Vendor : Record 23;
        GLEntry : Record 17;
        //LevyRec : Record 51511317;
        //LastLevy : Record 51511317;
        EntryNo : Integer;
        //LevyTypeRec : Record "51511327";
        ClaimantsRec : Record 51513094;
    begin
        InsMgt.CreatePVReinsEntries(PV);
        
        PV.Date:=WORKDATE;
        //BKK 3rd April 2021-to be removed once approval workflow has been done
       // IF PV.Status<>PV.Status::Released THEN
        // ERROR('The Payment Voucher No %1 cannot be posted before it is fully approved',PV.No);
         //End
        
        IF PV.Posted THEN
         ERROR('Payment Voucher %1 has been posted',PV.No);
        
        PV.TESTFIELD(PV.Date);
        PV.TESTFIELD(PV."Paying Bank Account");
        PV.TESTFIELD(PV.Payee);
        PV.TESTFIELD(PV."Pay Mode");
        
        IF PV."Pay Mode"='CHEQUE' THEN BEGIN
        
        PV.TESTFIELD(PV."Cheque No");
        //PV.TESTFIELD(PV."Cheque Date");
        END;
        
        //Check Lines
          PV.CALCFIELDS(PV."Total Amount");
          IF PV."Total Amount"=0 THEN
          ERROR('Amount is cannot be zero');
          PVLines.RESET;
          PVLines.SETRANGE(PVLines."PV No",PV.No);
          IF NOT PVLines.FINDLAST THEN
          ERROR('Payment voucher Lines cannot be empty');
        
          CMSetup.GET();
          // Delete Lines Present on the General Journal Line
          GenJnLine.RESET;
          GenJnLine.SETRANGE(GenJnLine."Journal Template Name",CMSetup."Payment Voucher Template");
          GenJnLine.SETRANGE(GenJnLine."Journal Batch Name",PV.No);
          GenJnLine.DELETEALL;
        
          Batch.INIT;
          IF CMSetup.GET() THEN
          Batch."Journal Template Name":=CMSetup."Payment Voucher Template";
          Batch.Name:=PV.No;
          IF NOT Batch.GET(Batch."Journal Template Name",Batch.Name) THEN
          Batch.INSERT;
        
        //Bank Entries
        LineNo:=LineNo+10000;
        PV.CALCFIELDS(PV."Total Amount");
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        //GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
        GenJnLine."Account Type":=GenJnLine."Account Type"::"Bank Account";
        GenJnLine."Account No.":=PV."Paying Bank Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PV.Payee;
        GenJnLine.Amount:=-PV."Total Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PV."Global Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PV."Global Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Shortcut Dimension 3 Code":=PV."Global Dimension 3 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
        GenJnLine."Shortcut Dimension 4 Code":=PV."Global Dimension 4 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
        //GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
        GenJnLine."Receipt and Payment Type":=PV.Type;
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        //PV Lines Entries
        PVLines.RESET;
        PVLines.SETRANGE(PVLines."PV No",PV.No);
        IF PVLines.FINDFIRST THEN BEGIN
        REPEAT
        PVLines.VALIDATE(PVLines.Amount);
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=PVLines."Account Type";
        GenJnLine."Account No.":=PVLines."Account No";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description;
        //GenJnLine."Description 2":=PVLines.Description;
        GenJnLine.Amount:=PVLines."Net Amount";
        GenJnLine.VALIDATE(Genjnline.Amount);
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
        GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
        //GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
        GenJnLine."Investment Code":=PVLines."Investment Asset No.";
        GenJnLine."Investment Transcation Type":=PVLines."Investment Transaction Type";
        IF PVLines."Applies to Doc. No"<>'' THEN BEGIN
        GenJnLine."Applies-to Doc. Type":=PVLines."Applies-to Doc. Type";
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        END;
        
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE(GenJnline."Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE(GenJnline."Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE(GenJnline."Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE(GenJnline."VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE(GenJnline."VAT Prod. Posting Group");
        //
        //Bkk
        GenJnLine."Transaction Type":=PVLines."Transaction Type";
        GenJnLine."Loan No":=PVLines."Loan No";
        GenJnLine."Policy No":=PVLines."Policy No";
        GenJnLine."Insurance Trans Type":=PVLines."Insurance Trans Type";
        GenJnLine."No. Of Units":=PVLines."No. of Units";
        GenJnLine."Investment Transcation Type":=PVLines."Investment Transaction Type";
        GenJnLine."Investment Code":=PVLines."Investment Asset No.";
        
        IF GenJnLine."Insurance Trans Type"=GenJnLine."Insurance Trans Type"::"Claim Payment" THEN
          BEGIN
            IF GenJnLine."Account Type"=GenJnLine."Account Type"::Vendor THEN
              BEGIN
                IntegrationSetup.RESET;
                IntegrationSetup.SETRANGE(IntegrationSetup."Class Code",PVLines."Policy Type");
                IF IntegrationSetup.FINDFIRST THEN
                   GenJnLine."Posting Group":=IntegrationSetup."Claims Out. Posting Group";
                   GenJnLine.VALIDATE(GenJnLine."Posting Group");
              END;
          END;
        GenJnLine."Claim No.":=PVLines."Claim No";
        GenJnLine."Claimant ID":=PVLines."Claimant ID";
        GenJnLine."Policy Type":=PVLines."Policy Type";
        GenJnLine."Treaty Code":=PVLines."Treaty Code";
        GenJnLine."Addendum Code":=PVLines."Treaty Addendum";
        GenJnLine."Layer Code":=PVLines."XOL Layer";
        GenJnLine."Period Reference":=PVLines."Premium Due Date";
        IF MDPSchedule.GET(PVLines."Treaty Code",PVLines."Treaty Addendum",PVLines."XOL Layer",PVLines."Instalment Plan No.") THEN
          BEGIN
          MDPSchedule.Paid:=TRUE;
          MDPSchedule.MODIFY;
         END;
        //Bkk
        
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        //Post VAT
        IF CMSetup."Post VAT" THEN BEGIN
        IF PVLines."VAT Code"<>'' THEN BEGIN
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=PVLines."Account Type";
        GenJnLine."Account No.":=PVLines."Account No";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description+'-VAT';
        GenJnLine.Amount:=PVLines."VAT Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        //
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
        GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
        //GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
        
        
        GenJnLine."Transaction Type":=PVLines."Transaction Type";
        GenJnLine."Loan No":=PVLines."Loan No";
        GenJnLine."Policy No":=PVLines."Policy No";
        GenJnLine."Insurance Trans Type":=PVLines."Insurance Trans Type";
        GenJnLine."No. Of Units":=PVLines."No. of Units";
        GenJnLine."Investment Transcation Type":=PVLines."Investment Transaction Type";
        GenJnLine."Investment Code":=PVLines."Investment Asset No.";
        IF GenJnLine."Insurance Trans Type"=GenJnLine."Insurance Trans Type"::"Claim Payment" THEN
          BEGIN
            IF GenJnLine."Account Type"=GenJnLine."Account Type"::Vendor THEN
              BEGIN
                IntegrationSetup.RESET;
                IntegrationSetup.SETRANGE(IntegrationSetup."Class Code",PVLines."Policy Type");
                IF IntegrationSetup.FINDFIRST THEN
                   GenJnLine."Posting Group":=IntegrationSetup."Claims Out. Posting Group";
                   GenJnLine.VALIDATE(GenJnLine."Posting Group");
              END;
          END;
        GenJnLine."Claim No.":=PVLines."Claim No";
        GenJnLine."Claimant ID":=PVLines."Claimant ID";
        GenJnLine."Treaty Code":=PVLines."Treaty Code";
        GenJnLine."Addendum Code":=PVLines."Treaty Addendum";
        GenJnLine."Layer Code":=PVLines."XOL Layer";
        GenJnLine."Period Reference":=PVLines."Premium Due Date";
        //Bkk
        /*
        GenJnLine."Applies-to Doc. Type":=GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        */
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
        CASE PVLines."Account Type" OF
        PVLines."Account Type"::"G/L Account":
        BEGIN
        GLAccount.GET(PVLines."Line No");
        GLAccount.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(GLAccount."VAT Bus. Posting Group",PVLines."VAT Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        PVLines."Account Type"::Vendor:
        BEGIN
        Vendor.GET(PVLines."Account No");
        Vendor.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(Vendor."VAT Bus. Posting Group",PVLines."VAT Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        PVLines."Account Type"::Customer:
        BEGIN
        Customer.GET(PVLines."Account No");
        Customer.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(Customer."VAT Bus. Posting Group",PVLines."VAT Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        END;
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description+'-VAT';
        GenJnLine.Amount:=-PVLines."VAT Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        GenJnLine."Transaction Type":=PVLines."Transaction Type";
        GenJnLine."Loan No":=PVLines."Loan No";
        GenJnLine."Policy No":=PVLines."Policy No";
        GenJnLine."Insurance Trans Type":=PVLines."Insurance Trans Type";
        GenJnLine."Claim No.":=PVLines."Claim No";
        GenJnLine."Claimant ID":=PVLines."Claimant ID";
        GenJnLine."Treaty Code":=PVLines."Treaty Code";
        GenJnLine."Addendum Code":=PVLines."Treaty Addendum";
        GenJnLine."Layer Code":=PVLines."XOL Layer";
        GenJnLine."Period Reference":=PVLines."Premium Due Date";
        //Bkk
        //
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
        GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
        //GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
        
        
        /*
        GenJnLine."Applies-to Doc. Type" := GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        */
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        END;
        //End of Posting VAT
        END;
        //Post Withholding Tax
        IF PVLines."W/Tax Code"<>'' THEN BEGIN
        PVLines.VALIDATE(PVLines.Amount);
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=PVLines."Account Type";
        GenJnLine."Account No.":=PVLines."Account No";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description+'-WHT';
        GenJnLine.Amount:=PVLines."W/Tax Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        GenJnLine."Transaction Type":=PVLines."Transaction Type";
        GenJnLine."Loan No":=PVLines."Loan No";
        GenJnLine."Policy No":=PVLines."Policy No";
        GenJnLine."Insurance Trans Type":=PVLines."Insurance Trans Type";
        GenJnLine."No. Of Units":=PVLines."No. of Units";
        GenJnLine."Investment Transcation Type":=PVLines."Investment Transaction Type";
        GenJnLine."Investment Code":=PVLines."Investment Asset No.";
        IF GenJnLine."Insurance Trans Type"=GenJnLine."Insurance Trans Type"::"Claim Payment" THEN
          BEGIN
            IF GenJnLine."Account Type"=GenJnLine."Account Type"::Vendor THEN
              BEGIN
                IntegrationSetup.RESET;
                IntegrationSetup.SETRANGE(IntegrationSetup."Class Code",PVLines."Policy Type");
                IF IntegrationSetup.FINDFIRST THEN
                   GenJnLine."Posting Group":=IntegrationSetup."Claims Out. Posting Group";
                   GenJnLine.VALIDATE(GenJnLine."Posting Group");
              END;
          END;
        GenJnLine."Claim No.":=PVLines."Claim No";
        GenJnLine."Claimant ID":=PVLines."Claimant ID";
        GenJnLine."Policy Type":=PVLines."Policy Type";
        GenJnLine."Treaty Code":=PVLines."Treaty Code";
        GenJnLine."Addendum Code":=PVLines."Treaty Addendum";
        GenJnLine."Layer Code":=PVLines."XOL Layer";
        GenJnLine."Period Reference":=PVLines."Premium Due Date";
        GenJnLine."No. Of Units":=PVLines."No. of Units";
        GenJnLine."Investment Transcation Type":=PVLines."Investment Transaction Type";
        GenJnLine."Investment Code":=PVLines."Investment Asset No.";
        //Bkk
        
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        //
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
        GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
        //GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
        
        /*
        GenJnLine."Applies-to Doc. Type":=GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        */
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        
        LineNo:=LineNo+10000;
        GenJnLine.INIT;
        IF CMSetup.GET THEN
        GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
        GenJnLine."Journal Batch Name":=PV.No;
        GenJnLine."Line No.":=LineNo;
        GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
        CASE PVLines."Account Type" OF
        PVLines."Account Type"::"G/L Account":
        BEGIN
        GLAccount.GET(PVLines."Account No");
        GLAccount.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(GLAccount."VAT Bus. Posting Group",PVLines."W/Tax Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        PVLines."Account Type"::Vendor:
        BEGIN
        Vendor.GET(PVLines."Account No");
        Vendor.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(Vendor."VAT Bus. Posting Group",PVLines."W/Tax Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        PVLines."Account Type"::Customer:
        BEGIN
        Customer.GET(PVLines."Account No");
        Customer.TESTFIELD("VAT Bus. Posting Group");
        IF VATSetup.GET(Customer."VAT Bus. Posting Group",PVLines."W/Tax Code") THEN
        GenJnLine."Account No.":=VATSetup."Purchase VAT Account";
        GenJnLine.VALIDATE(GenJnLine."Account No.");
        END;
        END;
         IF PV.Date=0D THEN
          ERROR('You must specify the PV date');
        GenJnLine."Posting Date":=PV.Date;
        GenJnLine."Document No.":=PV.No;
        GenJnLine."External Document No.":=PV."Cheque No";
        GenJnLine.Description:=PVLines.Description+'-WHT';
        GenJnLine.Amount:=-PVLines."W/Tax Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code":=PV.Currency;
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        //Set these fields to blanks
        GenJnLine."Gen. Posting Type":=GenJnLine."Gen. Posting Type"::" ";
        GenJnLine.VALIDATE("Gen. Posting Type");
        GenJnLine."Gen. Bus. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Bus. Posting Group");
        GenJnLine."Gen. Prod. Posting Group":='';
        GenJnLine.VALIDATE("Gen. Prod. Posting Group");
        GenJnLine."VAT Bus. Posting Group":='';
        GenJnLine.VALIDATE("VAT Bus. Posting Group");
        GenJnLine."VAT Prod. Posting Group":='';
        GenJnLine.VALIDATE("VAT Prod. Posting Group");
        GenJnLine."Transaction Type":=PVLines."Transaction Type";
        GenJnLine."Loan No":=PVLines."Loan No";
        GenJnLine."Policy No":=PVLines."Policy No";
        GenJnLine."Insurance Trans Type":=PVLines."Insurance Trans Type";
        GenJnLine."Claim No.":=PVLines."Claim No";
        GenJnLine."Claimant ID":=PVLines."Claimant ID";
        GenJnLine."Policy Type":=PVLines."Policy Type";
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
        GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
        //GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
        
        //Bkk
        //
        IF PV."Pay Mode"='CHEQUE' THEN
        GenJnLine."Pay Mode":=PV."Pay Mode";
        GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
        GenJnLine."No. Of Units":=PVLines."No. of Units";
        GenJnLine."Investment Transcation Type":=PVLines."Investment Transaction Type";
        GenJnLine."Investment Code":=PVLines."Investment Asset No.";
        /*
        GenJnLine."Applies-to Doc. Type" := GenJnLine."Applies-to Doc. Type"::Invoice;
        GenJnLine."Applies-to Doc. No.":=PVLines."Applies to Doc. No";
        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
        */
        IF GenJnLine.Amount<>0 THEN
         GenJnLine.INSERT;
        END;
        //End of Posting Withholding Tax
        IntegrationSetup.RESET;
        IntegrationSetup.SETRANGE(IntegrationSetup."Class Code",PVLines."Policy Type");
        IF IntegrationSetup.FINDFIRST THEN
        BEGIN
        
        //***Reverse Claim Reserves
        
            LineNo:=LineNo+10000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
            GenJnLine."Journal Batch Name":=PV.No;
            GenJnLine."Line No.":=LineNo;
            GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
            GenJnLine."Account No.":=IntegrationSetup."Claim Reserve";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
            GenJnLine."Posting Date":=TODAY;
            GenJnLine."Document No.":=PV.No;
            GenJnLine.Description:='Reversal of '+FORMAT(PVLines."Claim No");
            GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Claim Reserve";
            //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
            //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
            GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
            GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
            GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
            //GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
        
            GenJnLine.Amount:=-PVLines.Amount;
            GenJnLine.VALIDATE(GenJnLine.Amount);
            GenJnLine."Claim No.":=PVLines."Claim No";
            GenJnLine."Claimant ID":=PVLines."Claimant ID";
            GenJnLine."External Document No.":=PVLines."Claim No";
            IF GenJnLine.Amount<>0 THEN
            GenJnLine.INSERT;
        
            LineNo:=LineNo+10000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
            GenJnLine."Journal Batch Name":=PV.No;
            GenJnLine."Line No.":=LineNo;
            IF PVLines."Insurance Trans Type"=PVLines."Insurance Trans Type"::"Claim Payment" THEN
            BEGIN
            IF PVLines."Account Type"=PVLines."Account Type"::"G/L Account" THEN
            BEGIN
            GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
            GenJnLine."Account No.":=IntegrationSetup."Claims Reserves OS";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
            END;
        
        
            IF PVLines."Account Type"=PVLines."Account Type"::Vendor THEN
            BEGIN
            GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
            GenJnLine."Account No.":=IntegrationSetup."Claims Paid Account";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
        
            END;
            END;
            GenJnLine."Posting Date":=TODAY;
            GenJnLine."Document No.":=PV.No;
            GenJnLine.Description:='Reversal of '+FORMAT(PVLines."Claim No");
            GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
            GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
            GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
            //GenJnLine."Document Type":=GenJnLine."Document Type"::Payment;
        
            //GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Claim Reserve";
            //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
            //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
            GenJnLine.Amount:=PVLines.Amount;
            GenJnLine.VALIDATE(GenJnLine.Amount);
            GenJnLine."Claim No.":=PVLines."Claim No";
            GenJnLine."Claimant ID":=PVLines."Claimant ID";
            GenJnLine."External Document No.":=PVLines."Claim No";
            IF GenJnLine.Amount<>0 THEN
            GenJnLine.INSERT;
        
        
        
        
        
        
         //Reinsurance portion
        
        
         //Cancel Previous Reinsurance
         /*
         IF ClaimantsRec.GET(PVLines."Claim No",PVLines."Claimant ID") THEN
        
            ClaimantsRec.CALCFIELDS(ClaimantsRec."Treaty Recoverable");
        
            LineNo:=LineNo+10000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
            GenJnLine."Journal Batch Name":=PV.No;
            GenJnLine."Line No.":=LineNo;
            GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
            GenJnLine."Account No.":=IntegrationSetup."Reinsurer Share of Reserves-A";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
            GenJnLine."Posting Date":=TODAY;
            GenJnLine."Document No.":=PV.No;
            GenJnLine.Description:='Reinsurance Recovearble Reversal '+FORMAT(PVLines."Claim No");
            GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Reinsurance Claim Reserve";
            //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
            //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
            GenJnLine.Amount:=-ClaimantsRec."Treaty Recoverable";
            GenJnLine.VALIDATE(GenJnLine.Amount);
            GenJnLine."External Document No.":=PVLines."Claim No";
            GenJnLine."Claim No.":=PVLines."Claim No";
            GenJnLine."Claimant ID":=PVLines."Claimant ID";
            IF GenJnLine.Amount<>0 THEN
            GenJnLine.INSERT;
        
            LineNo:=LineNo+10000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
            GenJnLine."Journal Batch Name":=PV.No;
            GenJnLine."Line No.":=LineNo;
            //  MESSAGE('Reinsurer=%1 amount=%2 Template %3 and batch=%4',ReinsureLines."Partner No.",ReinsureLines."Claims Payment Amount",
            // GenJnLine."Journal Template Name", GenJnLine."Journal Batch Name");
            GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
            GenJnLine."Account No.":=IntegrationSetup."Reinsurer Share of Reserves-L";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
            GenJnLine."Posting Date":=PV.Date;
            GenJnLine."Document No.":=PV.No;
            GenJnLine.Description:='Claims Recoverable Reversal'+FORMAT(PVLines."Claim No");
            //GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Claim Reserve";
            //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
            //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
            GenJnLine.Amount:=ClaimantsRec."Treaty Recoverable";
            GenJnLine.VALIDATE(GenJnLine.Amount);
            GenJnLine."External Document No.":=PVLines."Claim No";
            GenJnLine."Claim No.":=PVLines."Claim No";
            GenJnLine."Claimant ID":=PVLines."Claimant ID";
            IF GenJnLine.Amount<>0 THEN
            GenJnLine.INSERT;
        
        
        
        
        
        //End cancellation of Previous */
            ReinsureLines.RESET;
            ReinsureLines.SETRANGE(ReinsureLines."No.",PV.No);
            ReinsureLines.SETFILTER(ReinsureLines."Claim No.",'<>%1','');
            IF ReinsureLines.FINDFIRST THEN
            BEGIN
               REPEAT
        
            LineNo:=LineNo+10000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
            GenJnLine."Journal Batch Name":=PV.No;
            //MESSAGE('Reinsurer=%1 amount=%2 Template %3 and batch=%4',ReinsureLines."Partner No.",ReinsureLines."Claims Payment Amount",
            //GenJnLine."Journal Template Name", GenJnLine."Journal Batch Name");
            GenJnLine."Line No.":=LineNo;
            GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
            GenJnLine."Account No.":=IntegrationSetup."Reinsurer Share of Reserves-A";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
            GenJnLine."Posting Date":=TODAY;
            GenJnLine."Document No.":=PV.No;
            GenJnLine.Description:='Reinsurance Recovearble '+FORMAT(PVLines."Claim No");
            GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Reinsurance Claim Reserve";
            //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
            //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
            GenJnLine.Amount:=-ReinsureLines."Claims Payment Amount";
            GenJnLine.VALIDATE(GenJnLine.Amount);
        
            GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
            GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
            GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
            GenJnLine."Treaty Code":=ReinsureLines."Treaty Code";
            GenJnLine."Addendum Code":=ReinsureLines."Addendum Code";
            GenJnLine."Layer Code":=ReinsureLines.TreatyLineID;
        
            GenJnLine."Claim No.":=PVLines."Claim No";
            GenJnLine."Claimant ID":=PVLines."Claimant ID";
            IF GenJnLine.Amount<>0 THEN
            GenJnLine.INSERT;
        
            LineNo:=LineNo+10000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
            GenJnLine."Journal Batch Name":=PV.No;
            GenJnLine."Line No.":=LineNo;
            //  MESSAGE('Reinsurer=%1 amount=%2 Template %3 and batch=%4',ReinsureLines."Partner No.",ReinsureLines."Claims Payment Amount",
            // GenJnLine."Journal Template Name", GenJnLine."Journal Batch Name");
            GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
            GenJnLine."Account No.":=IntegrationSetup."Reinsurer Share of Reserves-L";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
            GenJnLine."Posting Date":=PV.Date;
            GenJnLine."Document No.":=PV.No;
            GenJnLine.Description:='Claims for '+FORMAT(PVLines."Claim No");
            //GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Claim Reserve";
            //GenJnLine."Bal. Account No.":=IntegrationSetup."Claims Payable";
            //GenJnLine.VALIDATE(GenJnLine."Bal. Account No.");
            GenJnLine.Amount:=ReinsureLines."Claims Payment Amount";
            GenJnLine.VALIDATE(GenJnLine.Amount);
        
            GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
            GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
            GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
            GenJnLine."Treaty Code":=ReinsureLines."Treaty Code";
            GenJnLine."Addendum Code":=ReinsureLines."Addendum Code";
            GenJnLine."Layer Code":=ReinsureLines.TreatyLineID;
        
            GenJnLine."External Document No.":=PVLines."Claim No";
            GenJnLine."Claim No.":=PVLines."Claim No";
            GenJnLine."Claimant ID":=PVLines."Claimant ID";
            IF GenJnLine.Amount<>0 THEN
            GenJnLine.INSERT;
        
        
        //Post figures to individual reinsurers or Broker
        
            LineNo:=LineNo+10000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
            GenJnLine."Journal Batch Name":=PV.No;
            GenJnLine."Line No.":=LineNo;
            GenJnLine."Account Type":=GenJnLine."Account Type"::Customer;
            GenJnLine."Account No.":=ReinsureLines."Account No.";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
            GenJnLine."Posting Date":=TODAY;
            GenJnLine."Document No.":=PV.No;
            GenJnLine.Description:='Reinsurance Recoverable '+FORMAT(PVLines."Claim No");
            GenJnLine."Insurance Trans Type":=GenJnLine."Insurance Trans Type"::"Claim Recovery";
            GenJnLine."Insured ID":=ReinsureLines."Partner No.";
            GenJnLine.Amount:=ReinsureLines."Claims Payment Amount";
            GenJnLine.VALIDATE(GenJnLine.Amount);
            GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
            GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
            GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
        
            GenJnLine."Treaty Code":=ReinsureLines."Treaty Code";
            GenJnLine."Addendum Code":=ReinsureLines."Addendum Code";
            GenJnLine."Layer Code":=ReinsureLines.TreatyLineID;
        
        
            GenJnLine."External Document No.":=PVLines."Claim No";
            GenJnLine."Claim No.":=PVLines."Claim No";
            GenJnLine."Claimant ID":=PVLines."Claimant ID";
        
            IF GenJnLine.Amount<>0 THEN
            GenJnLine.INSERT;
        
            LineNo:=LineNo+10000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name":=CMSetup."Payment Voucher Template";
            GenJnLine."Journal Batch Name":=PV.No;
            GenJnLine."Line No.":=LineNo;
            GenJnLine."Account Type":=GenJnLine."Account Type"::"G/L Account";
            GenJnLine."Account No.":=IntegrationSetup."Reinsurance Recovery";
            GenJnLine.VALIDATE(GenJnLine."Account No.");
            GenJnLine."Posting Date":=PV.Date;
            GenJnLine."Document No.":=PV.No;
            GenJnLine.Description:='Claims recovery '+FORMAT(PVLines."Claim No");
            GenJnLine."Insured ID":=ReinsureLines."Partner No.";
            GenJnLine.Amount:=-ReinsureLines."Claims Payment Amount";
            GenJnLine.VALIDATE(GenJnLine.Amount);
        
            GenJnLine."Shortcut Dimension 1 Code":=PVLines."Shortcut Dimension 1 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code":=PVLines."Shortcut Dimension 2 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
            GenJnLine."Shortcut Dimension 3 Code":=PVLines."Shortcut Dimension 3 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 3 Code");
            GenJnLine."Shortcut Dimension 4 Code":=PVLines."Shortcut Dimension 4 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 4 Code");
        
            GenJnLine."Treaty Code":=ReinsureLines."Treaty Code";
            GenJnLine."Addendum Code":=ReinsureLines."Addendum Code";
            GenJnLine."Layer Code":=ReinsureLines.TreatyLineID;
        
            GenJnLine."External Document No.":=PVLines."Claim No";
            GenJnLine."Claim No.":=PVLines."Claim No";
            GenJnLine."Claimant ID":=PVLines."Claimant ID";
            IF GenJnLine.Amount<>0 THEN
            GenJnLine.INSERT;
                ReinsureLines.Posted:=TRUE;
                ReinsureLines.MODIFY;
               UNTIL ReinsureLines.NEXT=0;
        
        
        //End
        
            END;
        
        END;
        UNTIL PVLines.NEXT=0;
        END;
        
        
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJnLine);
        GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.",PV.No);
        GLEntry.SETRANGE(GLEntry.Reversed,FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN
        PV.Posted:=TRUE;
        PV."Posted By":=USERID;
        PV."Date Posted":=TODAY;
        PV."Time Posted":=TIME;
        PV.MODIFY;
        END;

    end;

    procedure PaymentsRelease(var PV : Record 51511000);
    begin
         IF PV.Status=PV.Status::Released THEN
         EXIT;
          PV.CreateTaxes(PV);
          PV.Status:=PV.Status::Released;
          PV.MODIFY(TRUE);
    end;

    procedure PrecheckPV(PV : Record 51511000);
    var
        Pvlines : Record 51511001;
        PayRecTypes : Record 51511002;
    begin
        PV.TESTFIELD(PV."Global Dimension 1 Code");
        PV.TESTFIELD(PV."Paying Bank Account");
        PV.TESTFIELD(PV."Pay Mode");
        PV.TESTFIELD(PV.Payee);
        PV.TESTFIELD(PV."Global Dimension 2 Code");
        PV.CALCFIELDS(PV."Total Amount");
        IF PV."Total Amount"=0 THEN
          ERROR('This PV has no amount please check before sending it for approval');

        IF PayRecTypes.GET(PV.Type,PayRecTypes.Type::Payment) THEN
           BEGIN
             Pvlines.RESET;
             Pvlines.SETRANGE(Pvlines."PV No",PV.No);
             IF Pvlines.FINDFIRST THEN
               REPEAT

              IF Pvlines.Amount<>0 THEN
                  BEGIN

                  IF PayRecTypes."Policy No. Mandatory" THEN
                   IF Pvlines."Policy No"='' THEN
                      ERROR('Policy No. must be selected for %1 Payment type',PV.Type);

                   IF PayRecTypes."Claim No. Mandatory" THEN
                   IF Pvlines."Claim No"='' THEN
                      ERROR('Claim No. must be selected for %1 Payment',PV.Type);

                   IF PayRecTypes."Claimant ID. Mandatory" THEN
                   IF Pvlines."Claimant ID"=0 THEN
                      ERROR('Claimant ID must be selected for %1 Payment type',PV.Type);
                    IF PayRecTypes."Loan No. Mandatory" THEN
                    IF Pvlines."Loan No"='' THEN
                      ERROR('Loan No must be selected for %1 Payment type',PV.Type);

                    IF PayRecTypes."Debit Note Mandatory" THEN
                    IF Pvlines."Applies to Doc. No"='' THEN
                      ERROR('Applies to Doc. No Must have a value for %1 Payment type',PV.Type);

                    IF PayRecTypes."Investment Code Mandatory" THEN
                    IF Pvlines."Investment Asset No."='' THEN
                      ERROR('Investment Assent No. Must have a value for %1 Payment type',PV.Type);

                    IF PayRecTypes."No. Of Units Mandatory" THEN
                    IF Pvlines."No. of Units"=0 THEN
                      ERROR('No. of Units Must have a value for %1 Payment type',PV.Type);


                    IF PayRecTypes."Treaty Code Mandatory" THEN
                    IF Pvlines."Treaty Code"='' THEN
                      ERROR('Treaty Code Must have a value for %1 Payment type',PV.Type);

                    IF PayRecTypes."Treaty Addendum Code Mandatory" THEN
                    IF Pvlines."Treaty Addendum"=0 THEN
                      ERROR('Treaty Addendum Code Must have a value for %1 Payment type',PV.Type);

                     IF PayRecTypes."Treaty Layer Mandatory" THEN
                        IF Pvlines."XOL Layer"='' THEN
                        ERROR('Treaty Layer Code Must have a value for %1 Payment type',PV.Type);
                      IF Pvlines."Shortcut Dimension 1 Code"='' THEN
                        ERROR('Please select a branch for Line %1',Pvlines."Line No");
                      IF Pvlines."Shortcut Dimension 2 Code"='' THEN
                        ERROR('Please select a Department for Line %1',Pvlines."Line No");
                 END;



               UNTIL Pvlines.NEXT=0;

           END;
    end;
}

