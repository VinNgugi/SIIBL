codeunit 51511002 "Receipts-Post"
{
    // version FINANCE


    trigger OnRun()
    begin
    end;

    var
        CMSetup: Record "Cash Management Setup";
        imprestrec: Record "Request Header";

    procedure PostReceipt(RptHeader: Record "Receipts Header")
    var
        GenJnLine: Record "Gen. Journal Line";
        RcptLine: Record "Receipt Lines";
        LineNo: Integer;
        Batch: Record "Gen. Journal Batch";
        GLEntry: Record "G/L Entry";
    begin

        IF CONFIRM('Are you sure you want to post the receipt no ' + RptHeader."No." + ' ?') = TRUE THEN BEGIN

            IF RptHeader.Posted THEN
                ERROR('The Receipt has been posted');
            // Check Amount
            RptHeader.CALCFIELDS(RptHeader."Total Amount");
            //  IF RptHeader.Amount<>RptHeader."Total Amount" THEN
            //     ERROR(' The Amount must be equal to the Total Amount on the Lines');

            RptHeader.TESTFIELD("Bank Code");
            RptHeader.TESTFIELD("Pay Mode");
            RptHeader.TESTFIELD("Received From");
            RptHeader.TESTFIELD(Date);

            IF RptHeader."Pay Mode" = 'CHEQUE' THEN BEGIN
                RptHeader.TESTFIELD("Cheque No");
                RptHeader.TESTFIELD("Cheque Date");
            END;

            CMSetup.GET();
            // Delete Lines Present on the General Journal Line
            GenJnLine.RESET;
            GenJnLine.SETRANGE(GenJnLine."Journal Template Name", CMSetup."Receipt Template");
            GenJnLine.SETRANGE(GenJnLine."Journal Batch Name", RptHeader."No.");
            GenJnLine.DELETEALL;

            Batch.INIT;
            IF CMSetup.GET() THEN
                Batch."Journal Template Name" := CMSetup."Receipt Template";
            Batch.Name := RptHeader."No.";
            IF NOT Batch.GET(Batch."Journal Template Name", Batch.Name) THEN
                Batch.INSERT;

            //Post Bank entries
            RptHeader.CALCFIELDS(RptHeader."Total Amount");
            LineNo := LineNo + 1000;
            GenJnLine.INIT;
            GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
            GenJnLine."Journal Batch Name" := RptHeader."No.";
            GenJnLine."Line No." := LineNo;
            GenJnLine."Account Type" := GenJnLine."Account Type"::"Bank Account";
            GenJnLine."Account No." := RptHeader."Bank Code";
            GenJnLine."Posting Date" := RptHeader.Date;
            GenJnLine."Document No." := RptHeader."No.";
            GenJnLine.Description := RptHeader."On Behalf Of";
            GenJnLine.Amount := RptHeader."Total Amount";
            GenJnLine.VALIDATE(GenJnLine.Amount);
            GenJnLine."Currency Code" := RptHeader."Currency Code";
            GenJnLine.VALIDATE(GenJnLine."Currency Code");
            GenJnLine."External Document No." := RptHeader."Cheque No";
            GenJnLine."Currency Code" := RptHeader."Currency Code";
            GenJnLine.VALIDATE(GenJnLine."Currency Code");
            GenJnLine."Pay Mode" := RptHeader."Pay Mode";
            IF RptHeader."Pay Mode" = 'CHEQUE' THEN
                GenJnLine."Cheque Date" := RptHeader."Cheque Date";
            GenJnLine."Shortcut Dimension 1 Code" := RptHeader."Global Dimension 1 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
            GenJnLine."Shortcut Dimension 2 Code" := RptHeader."Global Dimension 2 Code";
            GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");

            IF GenJnLine.Amount <> 0 THEN
                GenJnLine.INSERT;


            //Post the receipt lines
            RcptLine.SETRANGE(RcptLine."Receipt No.", RptHeader."No.");
            IF RcptLine.FINDFIRST THEN BEGIN
                REPEAT
                    RcptLine.VALIDATE(Amount);
                    LineNo := LineNo + 1000;
                    GenJnLine.INIT;
                    GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                    GenJnLine."Journal Batch Name" := RptHeader."No.";
                    GenJnLine."Line No." := LineNo;
                    GenJnLine."Account Type" := RcptLine."Account Type";
                    GenJnLine."Account No." := RcptLine."Account No.";
                    GenJnLine.VALIDATE(GenJnLine."Account No.");
                    GenJnLine."Posting Date" := RptHeader.Date;
                    GenJnLine."Document No." := RptHeader."No.";
                    GenJnLine.Description := RcptLine.Description;
                    GenJnLine.Amount := -RcptLine."Net Amount";
                    GenJnLine.VALIDATE(GenJnLine.Amount);
                    GenJnLine."External Document No." := RptHeader."Cheque No";
                    GenJnLine."Currency Code" := RptHeader."Currency Code";
                    GenJnLine.VALIDATE(GenJnLine."Currency Code");
                    GenJnLine."Shortcut Dimension 1 Code" := RcptLine."Global Dimension 1 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                    GenJnLine."Shortcut Dimension 2 Code" := RcptLine."Global Dimension 2 Code";
                    GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                    IF RcptLine."Applies to Doc. No" <> '' THEN BEGIN
                        GenJnLine."Applies-to Doc. Type" := RcptLine."Applies-to Doc. Type";
                        GenJnLine."Applies-to Doc. No." := RcptLine."Applies to Doc. No";
                        GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
                    END;
                    IF GenJnLine.Amount <> 0 THEN
                        GenJnLine.INSERT;
                UNTIL
                 RcptLine.NEXT = 0;
            END;

            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnLine);
            GLEntry.RESET;
            GLEntry.SETRANGE(GLEntry."Document No.", RptHeader."No.");
            GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
            IF GLEntry.FINDFIRST THEN BEGIN
                RptHeader.Posted := TRUE;
                RptHeader."Posted Date" := TODAY;
                RptHeader."Posted Time" := TIME;
                RptHeader."Posted By" := USERID;
                RptHeader.MODIFY;
                //==============================================
                RcptLine.RESET;
                RcptLine.SETFILTER(RcptLine."Receipt No.", RptHeader."No.");
                IF RcptLine.FINDFIRST THEN
                    REPEAT
                        imprestrec.RESET;
                        imprestrec.SETFILTER("Customer A/C", RcptLine."Account No.");
                        imprestrec.SETFILTER("Attached to PV No", RcptLine."Applies to Doc. No");
                        IF imprestrec.FINDSET THEN
                            REPEAT
                                imprestrec.Surrendered := TRUE;
                                imprestrec.MODIFY;
                            UNTIL imprestrec.NEXT = 0;
                    UNTIL RcptLine.NEXT = 0;
                //===============================================
            END;
        END;
    end;

    procedure PostReceiptSMS(RptHeader: Record "Receipts Header")
    var
        GenJnLine: Record "Gen. Journal Line";
        RcptLine: Record "Receipt Lines";
        LineNo: Integer;
        Batch: Record "Gen. Journal Batch";
        GLEntry: Record "G/L Entry";
    begin
        IF RptHeader.Posted THEN
            ERROR('The Receipt has been posted');
        // Check Amount
        RptHeader.CALCFIELDS(RptHeader."Total Amount");
        RptHeader.TESTFIELD("Bank Code");
        RptHeader.TESTFIELD("Pay Mode");
        RptHeader.TESTFIELD("Received From");
        RptHeader.TESTFIELD(Date);

        IF RptHeader."Pay Mode" = 'CHEQUE' THEN BEGIN
            RptHeader.TESTFIELD("Cheque No");
            RptHeader.TESTFIELD("Cheque Date");
        END;

        CMSetup.GET();
        // Delete Lines Present on the General Journal Line
        GenJnLine.RESET;
        GenJnLine.SETRANGE(GenJnLine."Journal Template Name", CMSetup."Receipt Template");
        GenJnLine.SETRANGE(GenJnLine."Journal Batch Name", RptHeader."No.");
        GenJnLine.DELETEALL;

        Batch.INIT;
        IF CMSetup.GET() THEN
            Batch."Journal Template Name" := CMSetup."Receipt Template";
        Batch.Name := RptHeader."No.";
        IF NOT Batch.GET(Batch."Journal Template Name", Batch.Name) THEN
            Batch.INSERT;

        //Post Bank entries
        RptHeader.CALCFIELDS(RptHeader."Total Amount");
        LineNo := LineNo + 1000;
        GenJnLine.INIT;
        GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
        GenJnLine."Journal Batch Name" := RptHeader."No.";
        GenJnLine."Line No." := LineNo;
        GenJnLine."Account Type" := GenJnLine."Account Type"::"Bank Account";
        GenJnLine."Account No." := RptHeader."Bank Code";
        GenJnLine."Posting Date" := RptHeader.Date;
        GenJnLine."Document No." := RptHeader."No.";
        GenJnLine.Description := RptHeader."Received From";
        GenJnLine.Amount := RptHeader."Total Amount";
        GenJnLine.VALIDATE(GenJnLine.Amount);
        GenJnLine."Currency Code" := RptHeader."Currency Code";
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        GenJnLine."External Document No." := RptHeader."Cheque No";
        GenJnLine."Currency Code" := RptHeader."Currency Code";
        GenJnLine.VALIDATE(GenJnLine."Currency Code");
        GenJnLine."Pay Mode" := RptHeader."Pay Mode";
        IF RptHeader."Pay Mode" = 'CHEQUE' THEN
            GenJnLine."Cheque Date" := RptHeader."Cheque Date";
        GenJnLine."Shortcut Dimension 1 Code" := RptHeader."Global Dimension 1 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code" := RptHeader."Global Dimension 2 Code";
        GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");

        IF GenJnLine.Amount <> 0 THEN
            GenJnLine.INSERT;


        //Post the receipt lines
        RcptLine.SETRANGE(RcptLine."Receipt No.", RptHeader."No.");
        IF RcptLine.FINDFIRST THEN BEGIN
            REPEAT
                RcptLine.VALIDATE(Amount);
                LineNo := LineNo + 1000;
                GenJnLine.INIT;
                GenJnLine."Journal Template Name" := CMSetup."Receipt Template";
                GenJnLine."Journal Batch Name" := RptHeader."No.";
                GenJnLine."Line No." := LineNo;
                GenJnLine."Account Type" := RcptLine."Account Type";
                GenJnLine."Account No." := RcptLine."Account No.";
                GenJnLine.VALIDATE(GenJnLine."Account No.");
                GenJnLine."Posting Date" := RptHeader.Date;
                GenJnLine."Document No." := RptHeader."No.";
                GenJnLine.Description := RcptLine.Description;
                GenJnLine.Amount := -RcptLine."Net Amount";
                GenJnLine.VALIDATE(GenJnLine.Amount);
                GenJnLine."External Document No." := RptHeader."Cheque No";
                GenJnLine."Currency Code" := RptHeader."Currency Code";
                GenJnLine.VALIDATE(GenJnLine."Currency Code");
                GenJnLine."Shortcut Dimension 1 Code" := RcptLine."Global Dimension 1 Code";
                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 1 Code");
                GenJnLine."Shortcut Dimension 2 Code" := RcptLine."Global Dimension 2 Code";
                GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                IF RcptLine."Applies to Doc. No" <> '' THEN BEGIN
                    GenJnLine."Applies-to Doc. Type" := RcptLine."Applies-to Doc. Type";
                    GenJnLine."Applies-to Doc. No." := RcptLine."Applies to Doc. No";
                    GenJnLine.VALIDATE(GenJnLine."Applies-to Doc. No.");
                END;
                IF GenJnLine.Amount <> 0 THEN
                    GenJnLine.INSERT;
            UNTIL
             RcptLine.NEXT = 0;
        END;

        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnLine);
        GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.", RptHeader."No.");
        GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
        IF GLEntry.FINDFIRST THEN BEGIN
            RptHeader.Posted := TRUE;
            RptHeader."Posted Date" := TODAY;
            RptHeader."Posted Time" := TIME;
            RptHeader."Posted By" := USERID;
            RptHeader.MODIFY;
        END;
    end;
}

