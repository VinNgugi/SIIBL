codeunit 51511015 Factory
{
    // version FINANCE


    trigger OnRun()
    begin
    end;

    var
        Text00001: Label 'You cannot accept this trip since you have the following imprest documents unsurrendered and are overdue, %1.';
        OnesText: array[20] of Text[90];
        TensText: array[20] of Text[90];
        ThousText: array[20] of Text[90];
        AmountInWords: Text[300];
        WholeInWords: Text[300];
        DecimalInWords: Text[300];
        WholePart: Integer;
        DecimalPart: Integer;
        Text00002: Label 'You cannot prepare a Payment doc for  trip number %1 before it is fully reviewed';
        Text00003: Label 'Trip %1 is already posted.';
        Text00004: Label 'Are you sure you want to post trip no %1 using posting date %2 ?';
        GLSetup: Record "Cash Management Setup";
        ReceiptsHeader: Record "Receipts Header";
        NoSerieSMgt: Codeunit NoSeriesManagement;
        Csetup: Record "Sales & Receivables Setup";
        CommitmentEntries: Record "Commitment Entries";
        GenPostingSetup: Record 252;
        GenProdGroup: Record 251;
        Text00005: Label 'This reconciliation is already complete.';
        Text00006: Label 'Reconciliation Process completed Successfully and closed.';
        Text00007: Label 'Your Reconciliation is incomplete. Some entries failed to reconcile.';
        Text00008: Label 'There are no lines to Reconcile';
        Factory: Codeunit 51511015;
        SalesSetup: Record "Sales & Receivables Setup";

    procedure FnCreateGnlJournalLine(TemplateName: Text; BatchName: Text; DocumentNo: Code[30]; LineNo: Integer; TransactionType: Option ,"Registration Fee","Deposit Contribution","Share Contribution",Loan,"Loan Repayment",Withdrawal,"Interest Due","Interest Paid",Investment,"Dividend Paid","Processing Fee","Withholding Tax","BBF Contribution","Admin Charges",Commission; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[50]; TransactionDate: Date; TransactionAmount: Decimal; Dimension1: Code[40]; Dimension2: Code[40]; ExternalDocumentNo: Code[50]; TransactionDescription: Text; LoanNumber: Code[50]; Currency: Code[10]; AppliesToDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; AppliesToDocNo: Code[50]; CurrencyFactor: Decimal)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := TemplateName;
        GenJournalLine."Journal Batch Name" := BatchName;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := AccountType;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine."Transaction Type" := TransactionType;
        GenJournalLine."Loan No" := LoanNumber;
        GenJournalLine."Posting Date" := TransactionDate;
        GenJournalLine."Currency Code" := Currency;
        IF GenJournalLine."Currency Code" <> '' THEN
            GenJournalLine.VALIDATE("Currency Code");
        GenJournalLine.Description := TransactionDescription;
        GenJournalLine.Amount := TransactionAmount;
        GenJournalLine."External Document No." := ExternalDocumentNo;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := Dimension1;
        GenJournalLine."Shortcut Dimension 2 Code" := Dimension2;
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
        GenJournalLine."Applies-to Doc. Type" := AppliesToDocType;
        GenJournalLine."Applies-to Doc. No." := AppliesToDocNo;
        GenJournalLine."Currency Factor" := CurrencyFactor;
        GenJournalLine.VALIDATE(Amount);
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
    end;

    procedure FnCreateGnlJournalLineBalanced(TemplateName: Text; BatchName: Text; DocumentNo: Code[30]; LineNo: Integer; TransactionType: Option ,"Registration Fee","Deposit Contribution","Share Contribution",Loan,"Loan Repayment",Withdrawal,"Interest Due","Interest Paid",Investment,"Dividend Paid","Processing Fee","Withholding Tax","BBF Contribution","Admin Charges",Commission; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[50]; TransactionDate: Date; TransactionDescription: Text; BalancingAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Member,Investor; BalancingAccountNo: Code[50]; TransactionAmount: Decimal; Dimension1: Code[40]; Dimension2: Code[40]; ExtDocNo: Code[20]; AppliesToDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; AppliesToDocNo: Code[50]; CurrencyFactor: Decimal)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := TemplateName;
        GenJournalLine."Journal Batch Name" := BatchName;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Transaction Type" := TransactionType;
        GenJournalLine."Account Type" := AccountType;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine."Posting Date" := TransactionDate;
        GenJournalLine.Description := TransactionDescription;
        IF CurrencyFactor = 0 THEN
            GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
        GenJournalLine.Amount := TransactionAmount;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine."Bal. Account Type" := BalancingAccountType;
        GenJournalLine."Bal. Account No." := BalancingAccountNo;
        GenJournalLine."External Document No." := ExtDocNo;
        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
        GenJournalLine."Shortcut Dimension 1 Code" := Dimension1;
        GenJournalLine."Shortcut Dimension 2 Code" := Dimension2;
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
        GenJournalLine."Applies-to Doc. Type" := AppliesToDocType;
        GenJournalLine."Applies-to Doc. No." := AppliesToDocNo;
        GenJournalLine."Currency Factor" := CurrencyFactor;
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
    end;

    procedure CheckForUnsurrenderedImprest(StaffNo: Code[20])
    var
        RequestHeader: Record "Request Header";
        ImpDocs: Text;
    begin
        /*TripSetup.GET();
        RequestHeader.RESET;
        RequestHeader.SETRANGE(RequestHeader."Employee No",StaffNo);
        RequestHeader.SETFILTER(Type,'=%1',RequestHeader.Type::"9");
        RequestHeader.SETRANGE(RequestHeader.Posted,TRUE);
        RequestHeader.SETRANGE(RequestHeader.Surrendered,FALSE);
        IF RequestHeader.FINDSET THEN
          BEGIN
            ImpDocs:='';
            REPEAT
              IF CALCDATE(TripSetup."Unsurrendered Period",RequestHeader."Deadline for Imprest Return")<=TODAY THEN
                BEGIN
                  ImpDocs:=ImpDocs+', '+RequestHeader.Code+' '+RequestHeader.Remarks;
                  END;
              UNTIL RequestHeader.NEXT=0;
        
              IF ImpDocs<>'' THEN
                ERROR(Text00001,ImpDocs);
            END;
            */

    end;

    procedure CheckForOverLappingDays(StaffNo: Code[20]; Startdate: Date; EndDate: Date)
    var
        RequestHeader: Record "Request Header";
        ImpDocs: Text;
    begin
        /*TripSetup.GET();
        RequestHeader.RESET;
        RequestHeader.SETRANGE(RequestHeader."Employee No",StaffNo);
        RequestHeader.SETFILTER(Type,'=%1',RequestHeader.Type::"9");
        RequestHeader.SETRANGE(RequestHeader.Posted,TRUE);
        RequestHeader.SETRANGE(RequestHeader.Surrendered,FALSE);
        IF RequestHeader.FINDSET THEN
          BEGIN
            ImpDocs:='';
            REPEAT
              IF ((Startdate>=RequestHeader."Trip Start Date") AND (Startdate<=RequestHeader."Trip Expected End Date"))
                OR ((EndDate>=RequestHeader."Trip Start Date") AND (EndDate<=RequestHeader."Trip Expected End Date")) THEN
                BEGIN
                ERROR('Trip days selected are overlapping');
                END;
              UNTIL RequestHeader.NEXT=0;
            END;
            */

    end;

    procedure EmailNotificationsToStaff(EmpNo: Text[50]; SenderNameName: Text[100]; SenderEmailAdd: Text[50]; ReceiverEmailAdd: Text[50]; NotifyMessage: Text[1000]; NotifyAction: Code[50])
    var
        SMTPMail: Codeunit 400;
        SMTPSetup: Record 409;
        HREmp: Record Employee;
    //BOD: Record 51511336;
    begin
        SMTPSetup.GET();
        IF SenderNameName = '' THEN
            //SenderNameName := SMTPSetup."Firm Name";

        IF SenderEmailAdd = '' THEN
                SenderEmailAdd := SMTPSetup."User ID";

        IF HREmp.GET(EmpNo) THEN BEGIN
            SMTPMail.CreateMessage(SenderNameName, SenderEmailAdd, ReceiverEmailAdd, NotifyAction, '', TRUE);
            SMTPMail.AppendBody(STRSUBSTNO(NotifyMessage, HREmp."First Name", NotifyAction, SenderNameName/*, SMTPSetup."Firm Name"*/));
            SMTPMail.AppendBody(SenderEmailAdd);
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.Send;
        END;
    end;

    local procedure ClearPreselectedBoolean(CategoryCode: Code[10])
    begin
    end;

    procedure NumberInWords(number: Decimal; CurrencyName: Text[30]; DenomName: Text[30]): Text[300]
    begin
        WholePart := ROUND(ABS(number), 1, '<');
        DecimalPart := ABS((ABS(number) - WholePart) * 100);

        WholeInWords := NumberToWords(WholePart, CurrencyName);

        IF DecimalPart <> 0 THEN BEGIN
            DecimalInWords := NumberToWords(DecimalPart, DenomName);
            WholeInWords := WholeInWords + ' and ' + DecimalInWords;
        END;

        AmountInWords := WholeInWords + ' Only';
        EXIT(AmountInWords);
    end;

    procedure NumberToWords(Number: Integer; appendScale: Text): Text[200]
    var
        numString: Text;
        pow: Integer;
        powStr: Text;
        log: Integer;
    begin
        InitTextVariables();

        numString := '';
        IF Number < 100 THEN
            IF Number < 20 THEN BEGIN
                IF Number <> 0 THEN numString := OnesText[Number];
            END ELSE BEGIN
                numString := TensText[Number DIV 10];
                IF (Number MOD 10) > 0 THEN
                    numString := numString + ' ' + OnesText[Number MOD 10];
            END
        ELSE BEGIN
            pow := 0;
            powStr := '';
            IF Number < 1000 THEN BEGIN // number is between 100 and 1000
                pow := 100;
                powStr := ThousText[1];
            END ELSE BEGIN
                log := ROUND(STRLEN(FORMAT(Number DIV 1000)) / 3, 1, '>');
                pow := POWER(1000, log);
                powStr := ThousText[log + 1];
            END;

            numString := NumberToWords(Number DIV pow, powStr) + ' ' + NumberToWords(Number MOD pow, '');
        END;

        EXIT(numString + ' ' + appendScale);
    end;

    procedure InitTextVariables()
    begin
        OnesText[1] := 'one';
        OnesText[2] := 'two';
        OnesText[3] := 'three';
        OnesText[4] := 'four';
        OnesText[5] := 'five';
        OnesText[6] := 'six';
        OnesText[7] := 'seven';
        OnesText[8] := 'eight';
        OnesText[9] := 'nine';
        OnesText[10] := 'ten';
        OnesText[11] := 'eleven';
        OnesText[12] := 'twelve';
        OnesText[13] := 'thirteen';
        OnesText[14] := 'fourteen';
        OnesText[15] := 'fifteen';
        OnesText[16] := 'sixteen';
        OnesText[17] := 'seventeen';
        OnesText[18] := 'eighteen';
        OnesText[19] := 'nineteen';

        TensText[1] := '';
        TensText[2] := 'twenty';
        TensText[3] := 'thirty';
        TensText[4] := 'forty';
        TensText[5] := 'fivty';
        TensText[6] := 'sixty';
        TensText[7] := 'seventy';
        TensText[8] := 'eighty';
        TensText[9] := 'ninty';

        ThousText[1] := 'hundred';
        ThousText[2] := 'thousand';
        ThousText[3] := 'million';
        ThousText[4] := 'billion';
        ThousText[5] := 'trillion';
    end;

    procedure FnGetBudgetedAmount(GLAccount: Code[20]; BudgetYear: Code[20]; Station: Code[20]; Department: Code[20]) Amount: Decimal
    var
        BudgetEntryLine: Record "G/L Budget Entry";
    begin
        Amount := 0;
        GLSetup.GET;

        IF (Station = '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Name", BudgetYear);
            //BudgetEntryLine.SETRANGE(Date,GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + ABS(BudgetEntryLine.Amount);
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station = '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Name", BudgetYear);
            //BudgetEntryLine.SETRANGE(Date,GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            //BudgetEntryLine.SETRANGE("Global Dimension 1 Code",Department);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + ABS(BudgetEntryLine.Amount);
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station <> '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Name", BudgetYear);
            //BudgetEntryLine.SETRANGE(Date,GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            // BudgetEntryLine.SETRANGE("Global Dimension 2 Code",Station);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + ABS(BudgetEntryLine.Amount);
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station <> '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Name", BudgetYear);
            //BudgetEntryLine.SETRANGE(Date,GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            //BudgetEntryLine.SETRANGE("Global Dimension 1 Code",Department);
            // BudgetEntryLine.SETRANGE("Global Dimension 2 Code",Station);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + ABS(BudgetEntryLine.Amount);
                UNTIL BudgetEntryLine.NEXT = 0;
        END;


        EXIT(Amount);
    end;

    procedure FnGetCommittedAmount(GLAccount: Code[20]; BudgetYear: Code[20]; Station: Code[20]; Department: Code[20]) Amount: Decimal
    var
        BudgetEntryLine: Record "Commitment Entries";
    begin
        Amount := 0;
        GLSetup.GET;
        IF (Station = '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE(BudgetEntryLine."Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Year", BudgetYear);
            //BudgetEntryLine.SETRANGE("Commitment Date",GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE(Type, BudgetEntryLine.Type::Committed);

            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station = '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE(BudgetEntryLine."Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Year", BudgetYear);
            //BudgetEntryLine.SETRANGE("Commitment Date",GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 1 Code", Department);
            BudgetEntryLine.SETRANGE(Type, BudgetEntryLine.Type::Committed);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station <> '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE(BudgetEntryLine."Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Year", BudgetYear);
            //BudgetEntryLine.SETRANGE("Commitment Date",GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 2 Code", Station);
            BudgetEntryLine.SETRANGE(Type, BudgetEntryLine.Type::Committed);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station <> '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE(BudgetEntryLine."Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Year", BudgetYear);
            //BudgetEntryLine.SETRANGE("Commitment Date",GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 1 Code", Department);
            BudgetEntryLine.SETRANGE("Global Dimension 2 Code", Station);
            BudgetEntryLine.SETRANGE(Type, BudgetEntryLine.Type::Committed);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;


        EXIT(Amount);
    end;

    procedure FnGetTotalExpenditure(GLAccount: Code[20]; BudgetYear: Code[20]; Station: Code[20]; Department: Code[20]) Amount: Decimal
    var
        BudgetEntryLine: Record "G/L Entry";
    begin
        GLSetup.GET;
        Amount := 0;

        IF (Station = '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            //BudgetEntryLine.SETRANGE("Budget Line", BudgetYear);
            BudgetEntryLine.SETRANGE("Posting Date", GLSetup."Current Budget Start Date", GLSetup."Current Budget End Date");
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station = '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            //BudgetEntryLine.SETRANGE("Budget Line", BudgetYear);
            BudgetEntryLine.SETRANGE("Posting Date", GLSetup."Current Budget Start Date", GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 1 Code", Department);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station <> '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            //BudgetEntryLine.SETRANGE("Budget Line", BudgetYear);
            BudgetEntryLine.SETRANGE("Posting Date", GLSetup."Current Budget Start Date", GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 2 Code", Station);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station <> '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            //BudgetEntryLine.SETRANGE("Budget Line", BudgetYear);
            BudgetEntryLine.SETRANGE("Posting Date", GLSetup."Current Budget Start Date", GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 1 Code", Department);
            BudgetEntryLine.SETRANGE("Global Dimension 2 Code", Station);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;


        EXIT(Amount);
    end;

    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    procedure FnChangeStatusCommonActivities(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        RequestHeader: Record "Request Header";
        Customer: Record Customer;
        RequestLines: Record "Request Lines";
        RequestHeaderCopy: Record "Request Header";
        RequestLinesCopy: Record "Request Lines";
        RequestHeaderCopy2: Record "Request Header";
        NextNo: Code[20];
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        //Modify claim
        RequestHeader.RESET;
        RequestHeader.SETRANGE("No.", GLEntry."Document No.");
        RequestHeader.SETRANGE(RequestHeader.Type, RequestHeader.Type::"Claim-Accounting");
        IF RequestHeader.FINDFIRST THEN BEGIN
            RequestHeader.Posted := TRUE;
            RequestHeader."Posted Date" := TODAY;
            RequestHeader."Posted By" := USERID;
            RequestHeader."Posted Time" := TIME;
            RequestHeader.MODIFY;
            //modify used receipt
            RequestLines.RESET;
            RequestLines.SETRANGE("Document No", RequestHeader."No.");
            IF RequestLines.FINDSET THEN BEGIN
                REPEAT
                    IF RequestLines.ReceiptNo <> '' THEN BEGIN
                        ReceiptsHeader.GET(RequestLines.ReceiptNo);
                        //ReceiptsHeader."Used On Surrender":=TRUE;
                        ReceiptsHeader.MODIFY;
                    END;
                UNTIL RequestLines.NEXT = 0;
            END;

            //Modify imprest no as surrendered
            IF RequestHeaderCopy.GET(RequestHeader."Imprest/Advance No") THEN BEGIN
                RequestHeaderCopy.Surrendered := TRUE;
                RequestHeaderCopy.MODIFY;
            END;

        END;

        //modify board allowance
        RequestHeader.RESET;
        //RequestHeader.SETRANGE(RequestHeader.Type, RequestHeader.Type::"31");
        RequestHeader.SETRANGE("No.", GLEntry."Document No.");
        IF RequestHeader.FIND('-') THEN BEGIN
            RequestHeader.Posted := TRUE;
            RequestHeader."Posted Date" := TODAY;
            RequestHeader."Posted By" := USERID;
            RequestHeader."Posted Time" := TIME;
            RequestHeader.MODIFY;
        END;

        //modify imprest
        RequestHeader.RESET;
        RequestHeader.SETRANGE("No.", GLEntry."Document No.");
        RequestHeader.SETRANGE(RequestHeader.Type, RequestHeader.Type::Imprest);
        IF RequestHeader.FINDFIRST THEN BEGIN
            RequestHeader.Posted := TRUE;
            RequestHeader."Posted Date" := TODAY;
            RequestHeader."Posted By" := USERID;
            RequestHeader."Posted Time" := TIME;
            RequestHeader.MODIFY;
        END;


        //modify claim refund
        RequestHeader.RESET;
        RequestHeader.SETRANGE(RequestHeader.Type, RequestHeader.Type::"Claim/Refund");
        RequestHeader.SETRANGE("No.", GLEntry."Document No.");
        IF RequestHeader.FIND('-') THEN BEGIN
            RequestHeader.Posted := TRUE;
            RequestHeader."Posted Date" := TODAY;
            RequestHeader."Posted By" := USERID;
            RequestHeader."Posted Time" := TIME;
            RequestHeader.MODIFY;
        END;


        //modify claim refund
        RequestHeader.RESET;
        //RequestHeader.SETRANGE(RequestHeader.Type, RequestHeader.Type::32);
        RequestHeader.SETRANGE("No.", GLEntry."Document No.");
        IF RequestHeader.FIND('-') THEN BEGIN
            RequestHeader.Posted := TRUE;
            RequestHeader."Posted Date" := TODAY;
            RequestHeader."Posted By" := USERID;
            RequestHeader."Posted Time" := TIME;
            SalesReceivablesSetup.GET;
            //RequestHeader."Expected Date of Surrender":=CALCDATE(SalesReceivablesSetup."Other Advance Due Period",TODAY);
            RequestHeader.MODIFY;
        END;
    end;

    procedure FnGetAccountToCommit(Type: Option " ","G/L Account",Item,,"Fixed Asset","Charge (Item)","Non Stock Item",Category; TypeNo: Code[50]) AccountNo: Code[50]
    var
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
        FASubclass: Record 5608;
        FAPostingGroup: Record "FA Posting Group";
        InventoryPostingSetup: Record 5813;
        InventoryPostingGroup: Record 94;
    begin
        IF Type = Type::"Fixed Asset" THEN BEGIN
            IF FixedAsset.GET(TypeNo) THEN BEGIN
                IF FASubclass.GET(FixedAsset."FA Subclass Code") THEN BEGIN
                    IF FAPostingGroup.GET(FASubclass."Default FA Posting Group") THEN BEGIN
                        AccountNo := FAPostingGroup."Acquisition Cost Account";
                    END;
                END;
            END;
        END;

        IF Type = Type::Item THEN BEGIN
            IF Item.GET(TypeNo) THEN BEGIN
                IF InventoryPostingGroup.GET(Item."Inventory Posting Group") THEN BEGIN
                    InventoryPostingSetup.RESET;
                    InventoryPostingSetup.SETRANGE("Invt. Posting Group Code", InventoryPostingGroup.Code);
                    IF InventoryPostingSetup.FINDFIRST THEN
                        AccountNo := InventoryPostingSetup."Inventory Account";
                END;
            END;
        END;

        IF Type = Type::"Non Stock Item" THEN BEGIN
            IF Item.GET(TypeNo) THEN BEGIN
                IF GenProdGroup.GET(Item."Gen. Prod. Posting Group") THEN BEGIN
                    GenPostingSetup.RESET;
                    GenPostingSetup.SETRANGE("Gen. Prod. Posting Group", GenProdGroup.Code);
                    IF GenPostingSetup.FINDFIRST THEN
                        AccountNo := GenPostingSetup."Direct Cost Applied Account";
                END;
            END;
        END;
        IF Type = Type::"G/L Account" THEN BEGIN
            IF GLAccount.GET(TypeNo) THEN BEGIN
                AccountNo := GLAccount."No.";
                //MESSAGE(AccountNo);
            END;
        END;

        EXIT(AccountNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure FnUpdateStoreRequisitionAfterPosting(var ItemJournalLine: Record 83)
    var
        RequisitionHeader: Record 51511398;
    begin
        IF RequisitionHeader.GET(ItemJournalLine."Document No.") THEN BEGIN
            RequisitionHeader.Posted := TRUE;
            RequisitionHeader."Posted By" := USERID;
            RequisitionHeader."Date Posted" := TODAY;
            RequisitionHeader.Issued := TRUE;
            RequisitionHeader."Issued By" := USERID;
            RequisitionHeader."Date Issued" := CURRENTDATETIME;
            RequisitionHeader.MODIFY;
        END;
    end;

    local procedure "******************Commitment*****************"()
    begin
    end;

    procedure FnCommitAmount(Amount: Decimal; AccountNo: Code[50]; Budget: Code[50]; DocNo: Code[50]; SourceType: Option " ",LPO,LSO,IMPREST,INVOICE,PV; DepartmentCode: Code[30]; StationCode: Code[30]; DocDate: Date; Type: Option " ",Reservation,Commitment,Reversal; Activity: Code[30])
    var
        CommitmentEntries1: Record "Commitment Entries";
        LastEnrtyNo: Integer;
    begin
        IF CommitmentEntries1.FINDLAST THEN
            LastEnrtyNo := CommitmentEntries1."Entry No";
        CommitmentEntries1.INIT;
        CommitmentEntries1."Entry No" := LastEnrtyNo + CommitmentEntries1.COUNT;
        CommitmentEntries1."Account No." := AccountNo;
        CommitmentEntries1.VALIDATE("Account No.");
        CommitmentEntries1."Budget Year" := Budget;
        CommitmentEntries1."Document No." := DocNo;
        CommitmentEntries1.Amount := Amount;
        CommitmentEntries1."Global Dimension 1 Code" := DepartmentCode;
        CommitmentEntries1."Global Dimension 2 Code" := StationCode;
        CommitmentEntries1."Global Dimension 3 Code" := Activity;
        CommitmentEntries1."Commitment Type" := SourceType;
        CommitmentEntries1."Commitment Date" := DocDate;
        CommitmentEntries1.Type := Type;
        CommitmentEntries1."Account No." := AccountNo;
        CommitmentEntries1."Time Stamp" := TIME;
        CommitmentEntries1."Commitment Date" := TODAY;
        CommitmentEntries1."User ID" := USERID;
        IF Amount <> 0 THEN
            CommitmentEntries1.INSERT;
    end;

    procedure FnUnCommitAmount(Amount: Decimal; AccountNo: Code[50]; Budget: Code[50]; DocNo: Code[50]; SourceType: Option " ",LPO,LSO,IMPREST,INVOICE,PV,PR; DepartmentCode: Code[30]; StationCode: Code[30]; DocDate: Date; Type: Option " ",Reservation,Reversal,Commitment)
    var
        CommitmentEntries1: Record "Commitment Entries";
        LastEnrtyNo: Integer;
    begin
        IF CommitmentEntries1.FINDLAST THEN
            LastEnrtyNo := CommitmentEntries1."Entry No";
        CommitmentEntries1.INIT;
        CommitmentEntries1."Entry No" := LastEnrtyNo + CommitmentEntries1.COUNT;
        CommitmentEntries1."Account No." := AccountNo;
        CommitmentEntries1.VALIDATE("Account No.");
        CommitmentEntries1."Budget Year" := Budget;
        CommitmentEntries1."Document No." := DocNo;
        CommitmentEntries1.Amount := -Amount;
        CommitmentEntries1."Global Dimension 1 Code" := DepartmentCode;
        CommitmentEntries1."Global Dimension 2 Code" := StationCode;
        CommitmentEntries1.Type := CommitmentEntries1.Type::Reversal;
        CommitmentEntries1."Uncommittment Date" := TODAY;
        CommitmentEntries1."User ID" := USERID;
        CommitmentEntries1."Commitment Type" := SourceType;
        IF (Amount <> 0) AND (FnCheckIfCorrespondingCommitmentExist(DocNo, AccountNo)) THEN
            CommitmentEntries1.INSERT;
    end;

    procedure FnDeleteCommitmentsOnCancelApprovalRequest(DocNo: Code[20]; AccountNo: Code[20]): Boolean
    var
        CommitmentEntries: Record "Commitment Entries";
    begin
        CommitmentEntries.SETRANGE("Document No.", DocNo);
        CommitmentEntries.SETRANGE("Account No.", AccountNo);
        CommitmentEntries.SETRANGE(Type, CommitmentEntries.Type::" ");
        IF CommitmentEntries.FINDFIRST THEN
            CommitmentEntries.DELETE;
    end;

    local procedure FnCheckIfCorrespondingCommitmentExist(DocNo: Code[20]; AccountNo: Code[20]): Boolean
    var
        CommitmentEntries: Record "Commitment Entries";
    begin
        CommitmentEntries.SETRANGE("Document No.", DocNo);
        CommitmentEntries.SETRANGE("Account No.", AccountNo);
        CommitmentEntries.SETRANGE(Type, CommitmentEntries.Type::Reservation, CommitmentEntries.Type::Committed);
        EXIT(CommitmentEntries.FINDFIRST)
    end;

    local procedure "***************EndCommitment*************"()
    begin
    end;

    procedure FnCreatePurchaseQuoteHeader(DocNo: Code[20]; VendorNo: Code[30]; RequisitionNo: Code[50]; PQTNo: Code[50]; Category: Code[50]; TendorNo: Code[50]; RFQNo: Code[50]; ReasonForAmmendment: Text[250])
    var
        PurchaseHeader: Record 38;
        Nomgt: Codeunit NoSeriesManagement;
        Psetup: Record 312;
        RequisitionHeader: Record 38;
    begin

        WITH PurchaseHeader DO BEGIN
            Psetup.GET;
            INIT;
            "No." := DocNo;
            VALIDATE("No.");
            //"Original LPO No" := PQTNo;
            //"Reason For Ammendment" := ReasonForAmmendment;
            "Document Type" := "Document Type"::Order;
            "Buy-from Vendor No." := VendorNo;
            VALIDATE("Buy-from Vendor No.");
            "Document Date" := TODAY;
            //"Requisition No" := RequisitionNo;
            //"Supplier Type" := Category;
            "Order Date" := TODAY;
            "Receiving No. Series" := Psetup."Posted Receipt Nos.";
            VALIDATE("Receiving No. Series");
            "Posting No. Series" := Psetup."Posted Invoice Nos.";
            VALIDATE("Posting No. Series");
            INSERT;
        END;
    end;

    procedure FnCreatePurchaseQuoteLines(DocNo: Code[20]; AccType: Option " ","G/L Account",Item,,"Fixed Asset","Charge (Item)"; AccNo: Code[30]; LQuantity: Decimal; GlobalDim1: Code[20]; GlobalDim2: Code[20]; UnitOfMeasure: Code[20]; UnitCost: Decimal)
    var
        PurchaseLine: Record 39;
        "LineNo.": Integer;
    begin
        WITH PurchaseLine DO BEGIN
            INIT;
            "Document No." := DocNo;
            "Document Type" := "Document Type"::Order;
            Type := AccType;
            "No." := AccNo;
            VALIDATE("No.");
            Quantity := LQuantity;
            VALIDATE(Quantity);
            "Unit Cost" := UnitCost;
            "Direct Unit Cost" := "Unit Cost";
            VALIDATE("Direct Unit Cost");
            "Unit of Measure" := UnitOfMeasure;
            "Shortcut Dimension 1 Code" := GlobalDim1;
            "Shortcut Dimension 2 Code" := GlobalDim2;
            VALIDATE("Shortcut Dimension 1 Code");
            VALIDATE("Shortcut Dimension 2 Code");
            "Line No." := COUNT + 1;
            INSERT;
        END;
    end;

    procedure FnGetCorrespondingTotalsOfPreceedingLines(AccountNo: Code[20]; DocumentNo: Code[20]) Amount: Decimal
    var
        RequestLines: Record "Request Lines";
    begin
        RequestLines.RESET;
        RequestLines.SETRANGE("Document No", DocumentNo);
        RequestLines.SETRANGE("Account No", AccountNo);
        //RequestLines.SETRANGE("Balance Calculated",TRUE);
        IF RequestLines.FINDSET THEN BEGIN
            REPEAT
                Amount := Amount + ABS(RequestLines.Amount);
            UNTIL RequestLines.NEXT = 0;
        END;

        EXIT(Amount);
    end;

    [Scope('Personalization')]
    procedure FnCheckRecordHasUsageRestrictions(RecVar: Variant): Boolean
    var
        RestrictedRecord: Record 1550;
        RecRef: RecordRef;
        ErrorMessage: Text;
    begin
        RecRef.GETTABLE(RecVar);
        IF RecRef.ISTEMPORARY THEN
            EXIT;

        RestrictedRecord.SETRANGE("Record ID", RecRef.RECORDID);
        EXIT(RestrictedRecord.FINDFIRST);
    end;

    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure FnUpdateBenefitsRequestAfterPosting(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
    //BenefitsRequest: Record 51511381;
    begin
        /* IF BenefitsRequest.GET(GenJournalLine."Document No.") THEN BEGIN
            /// BenefitsRequest.Posted:=TRUE;
            //BenefitsRequest."Posted By":=USERID;
            //BenefitsRequest."Time Posted":=TIME;
            //BenefitsRequest."Date Posted":=TODAY;
            //BenefitsRequest.MODIFY(TRUE);
        END; */
    end;

    procedure FnGetAccountToCommitInvLines(Type: Option " ","G/L Account",Item,,"Fixed Asset","Charge (Item)"; TypeNo: Code[50]) AccountNo: Code[50]
    var
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
        FASubclass: Record 5608;
        FAPostingGroup: Record "FA Posting Group";
        InventoryPostingSetup: Record 5813;
        InventoryPostingGroup: Record 94;
    begin
        IF Type = Type::"Fixed Asset" THEN BEGIN
            IF FixedAsset.GET(TypeNo) THEN BEGIN
                IF FASubclass.GET(FixedAsset."FA Subclass Code") THEN BEGIN
                    IF FAPostingGroup.GET(FASubclass."Default FA Posting Group") THEN BEGIN
                        AccountNo := FAPostingGroup."Acquisition Cost Account";
                    END;
                END;
            END;
        END;

        IF (Type = Type::Item) THEN BEGIN
            IF Item.GET(TypeNo) THEN BEGIN
                IF InventoryPostingGroup.GET(Item."Inventory Posting Group") THEN BEGIN
                    InventoryPostingSetup.RESET;
                    InventoryPostingSetup.SETRANGE("Invt. Posting Group Code", InventoryPostingGroup.Code);
                    IF InventoryPostingSetup.FINDFIRST THEN
                        AccountNo := InventoryPostingSetup."Inventory Account";
                END;
            END;
        END;

        IF Type = Type::"G/L Account" THEN BEGIN
            IF GLAccount.GET(TypeNo) THEN BEGIN
                AccountNo := GLAccount."No.";
            END;
        END;

        EXIT(AccountNo);
    end;

    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure FnUpdateReceiptsAfterPosting(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        ReceiptsHeader: Record "Receipts Header";
        RequestHeader: Record "Request Header";
    begin
        IF ReceiptsHeader.GET(GenJournalLine."Document No.") THEN BEGIN
            ReceiptsHeader.Posted := TRUE;
            ReceiptsHeader."Posted By" := USERID;
            ReceiptsHeader."Posted Time" := TIME;
            ReceiptsHeader."Posted Date" := TODAY;
            ReceiptsHeader.MODIFY(TRUE);

            // IF ReceiptsHeader."Receipt Type" IN [ReceiptsHeader."Receipt Type"::"2"] THEN
            BEGIN
                //IF RequestHeader.GET(ReceiptsHeader."Imprest/Advance No.") THEN
                BEGIN
                    RequestHeader.CALCFIELDS("Imprest Amount");
                    ReceiptsHeader.CALCFIELDS("Total Amount");
                    IF RequestHeader."Imprest Amount" = ReceiptsHeader."Total Amount" THEN BEGIN
                        RequestHeader.Surrendered := TRUE;
                        //RequestHeader."Surrender Doc No":=ReceiptsHeader."No.";
                        RequestHeader.MODIFY(TRUE);
                    END;
                END;
            END;
        END;
    end;

    procedure FnCheckifEFT(PayMode: Code[20])
    begin
        IF PayMode = 'EFT' THEN
            ERROR('You can not post a single document whose Paymode is EFT');
    end;

    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
    local procedure FnCommitPurchaseInvoiceOnSendingForApproval(var ApprovalEntry: Record "Approval Entry")
    var
        PurchaseLine: Record 39;
        PurchaseHeader: Record 38;
        RequisitionHeader: Record 51511398;
        RequisitionLines: Record 51511399;
    begin
        GLSetup.GET;
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order] THEN BEGIN
            PurchaseLine.RESET;
            PurchaseLine.SETRANGE("Document No.", ApprovalEntry."Document No.");
            IF PurchaseLine.FINDSET THEN BEGIN
                RequisitionLines.RESET;
                //RequisitionLines.SETRANGE(RequisitionLines."Requisition No", PurchaseHeader."Requisition No");
                IF RequisitionLines.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                    /*FnCommitAmount(-RequisitionLines.Amount, FnGetAccountToCommit(RequisitionLines.Type, RequisitionLines.No), PurchaseLine."Current Budget", PurchaseHeader."Requisition No",
                                    CommitmentEntries."Commitment Type"::PR, RequisitionLines."Global Dimension 1 Code", RequisitionLines."Global Dimension 2 Code",
                                    TODAY, CommitmentEntries.Type::Reversal, RequisitionLines."ShortCut Dimension 3 Code");*/
                    UNTIL RequisitionLines.NEXT = 0;
                END;
            END;
        END;

        //IF (PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order]) THEN
        //BEGIN
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document No.", ApprovalEntry."Document No.");
        IF PurchaseLine.FINDSET THEN BEGIN
            REPEAT
            /*FnCommitAmount(PurchaseLine.Amount, FnGetAccountToCommit(PurchaseLine.Type, PurchaseLine."No."), PurchaseLine."Current Budget", PurchaseLine."Document No.",
                            CommitmentEntries."Commitment Type"::LPO, PurchaseLine."Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 2 Code",
                            TODAY, CommitmentEntries.Type::Committed, PurchaseLine."Shortcut Dimension 2 Code");*/
            UNTIL PurchaseLine.NEXT = 0;
        END;

        //END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure FnUnCommitPurchaseInvoice(var PurchaseHeader: Record 38)
    var
        PurchaseLine: Record 39;
    begin
        GLSetup.GET;
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF PurchaseLine.FINDSET THEN BEGIN
            REPEAT
                FnUnCommitAmount(PurchaseLine.Amount, FnGetAccountToCommit(PurchaseLine.Type, PurchaseLine."No."),
                GLSetup."Current Budget", PurchaseHeader."No.", CommitmentEntries."Commitment Type"::LPO, PurchaseLine."Shortcut Dimension 1 Code",
                PurchaseLine."Shortcut Dimension 2 Code", TODAY, CommitmentEntries.Type::Reversal);
            UNTIL PurchaseLine.NEXT = 0;
        END;
    end;

    procedure FnCreateGnlJournalLinePVRCPT(TemplateName: Text; BatchName: Text; DocumentNo: Code[30]; LineNo: Integer; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[50]; TransactionDescription: Text; TransactionAmount: Decimal; Dimension1: Code[40]; Dimension2: Code[40]; Applies2doctype: Option ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; Applies2DocNo: Code[20]; TransactionDate: Date; "Currency Code": Code[10]; CurrencyFactor: Decimal; GenPostingType: Option " ",Purchase,Sale,Settlement)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := TemplateName;
        GenJournalLine."Journal Batch Name" := BatchName;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := AccountType;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine."Gen. Posting Type" := GenPostingType;
        GenJournalLine."Posting Date" := TransactionDate;
        GenJournalLine.Description := TransactionDescription;
        GenJournalLine."Currency Code" := "Currency Code";
        GenJournalLine."Currency Factor" := CurrencyFactor;
        GenJournalLine.VALIDATE(GenJournalLine."Currency Code");
        GenJournalLine."Applies-to Doc. Type" := Applies2doctype;
        GenJournalLine."Applies-to Doc. No." := Applies2DocNo;
        GenJournalLine.VALIDATE("Applies-to Doc. No.");
        GenJournalLine.Amount := TransactionAmount;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
        GenJournalLine."Shortcut Dimension 1 Code" := Dimension1;
        GenJournalLine."Shortcut Dimension 2 Code" := Dimension2;
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
    end;

    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure FnUpdateInterBankAfterPosting(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        RequisitionHeader: Record Payments1;
    begin
        IF RequisitionHeader.GET(GenJournalLine."Document No.") THEN BEGIN
            RequisitionHeader.Posted := TRUE;
            RequisitionHeader."Posted By" := USERID;
            RequisitionHeader."Date Posted" := TODAY;
            RequisitionHeader."Time Posted" := TIME;
            RequisitionHeader.MODIFY;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure FnUpdatePVAfterPosting(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        RequisitionHeader: Record Payments1;
    begin
        IF RequisitionHeader.GET(GenJournalLine."Document No.") THEN BEGIN
            IF NOT GLEntry.Reversed THEN BEGIN
                RequisitionHeader.Posted := TRUE;
                //RequisitionHeader."System Modification":=TRUE;
                RequisitionHeader."Posted By" := USERID;
                RequisitionHeader."Date Posted" := TODAY;
                RequisitionHeader."Time Posted" := TIME;
                RequisitionHeader.MODIFY;
            END ELSE BEGIN
                RequisitionHeader.Posted := FALSE;
                RequisitionHeader.MODIFY(TRUE);
            END;
        END;
    end;

    /*[EventSubscriber(ObjectType::Codeunit, 415, 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure FnUnCommitAmountPR(var PurchaseHeader: Record 38; PreviewMode: Boolean; Amount: Decimal; AccountNo: Code[50]; Budget: Code[50]; DocNo: Code[50]; SourceType: Option " ",LPO,LSO,IMPREST,INVOICE,PV; DepartmentCode: Code[30]; StationCode: Code[30])
    var
        CommitmentEntries1: Record "Commitment Entries";
    begin
        CommitmentEntries1.INIT;
        CommitmentEntries1."Entry No" := CommitmentEntries1.COUNT + 1;
        CommitmentEntries1."Account No." := AccountNo;
        CommitmentEntries1."Budget Year" := Budget;
        CommitmentEntries1."Document No." := DocNo;
        CommitmentEntries1.Amount := -Amount;
        CommitmentEntries1."Global Dimension 1 Code" := DepartmentCode;
        CommitmentEntries1."Global Dimension 2 Code" := StationCode;
        CommitmentEntries1.Type := CommitmentEntries1.Type::Committed;
        CommitmentEntries1."Uncommittment Date" := TODAY;
        CommitmentEntries1."User ID" := USERID;
        CommitmentEntries1."Commitment Type" := SourceType;
        IF (Amount <> 0) AND (FnCheckIfCorrespondingCommitmentExist(DocNo, AccountNo)) THEN
            CommitmentEntries1.INSERT;
    end;*/

    /*[EventSubscriber(ObjectType::Codeunit, 17, 'OnAfterReverse', '', false, false)]
    local procedure FnChangeReversalOfEFT(var ReversalEntry: Record 179)
    var
        Payments: Record Payments;
        RequestHeader: Record "Request Header";
        BenefitsRequest: Record 51511381;
    begin
        IF Payments.GET(ReversalEntry."Document No.") THEN BEGIN
            // Payments."EFT Booked":=FALSE;
            Payments."Eft Generated" := FALSE;
            //Payments."EFT No.":='';
            Payments.Posted := FALSE;
            Payments.MODIFY(TRUE);
        END;


        IF RequestHeader.GET(ReversalEntry."Document No.") THEN BEGIN
            //RequestHeader."Batch Booked":=FALSE;
            //RequestHeader."Batch No":='';
            RequestHeader.Posted := FALSE;
            RequestHeader.MODIFY(TRUE);
        END;

        IF BenefitsRequest.GET(ReversalEntry."Document No.") THEN BEGIN
            //BenefitsRequest."EFT Booked":=FALSE;
            //BenefitsRequest."EFT No":='';
            //BenefitsRequest.Posted:=FALSE;
            BenefitsRequest.MODIFY(TRUE);
        END;
    end;*/

    procedure FnCheckPostingRights(CurrUserID: Code[70])
    var
        UserSetup: Record "User Setup";
    begin
        IF UserSetup.GET(CurrUserID) THEN BEGIN
            IF (UserSetup."Allow Posting From" = 0D) OR (UserSetup."Allow Posting To" = 0D) THEN
                ERROR('Contact your system administrator to set your postng date range');
        END ELSE
            ERROR('Contact your system administrator to set you up in user setup');
    end;

    procedure FnCheckIfCashierCashLimitIsExceeded(Amount: Decimal; PayMode: Text)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.GET;
        IF PayMode = 'CASH' THEN BEGIN
            /* GeneralLedgerSetup.TESTFIELD("Cashier Cash Limit");
            IF Amount > GeneralLedgerSetup."Cashier Cash Limit" THEN
                ERROR('Amount is higher than %1', GeneralLedgerSetup."Cashier Cash Limit"); */
        END;
    end;

    procedure FnSendEmail(SenderEmailAddress: Text; SenderName: Text; RecepientsMail: Text; Subject: Text; Body: Text)
    var
        SMTPMail: Codeunit 400;
    begin
        IF (SenderEmailAddress <> '') AND (RecepientsMail <> '') AND (Subject <> '') THEN BEGIN
            SMTPMail.CreateMessage(SenderName, SenderEmailAddress, RecepientsMail, Subject, Body, TRUE);
            SMTPMail.Send();
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
    procedure FnUncommitRequisitionOnSendingOrderForApproval(var ApprovalEntry: Record "Approval Entry")
    var
        PurchaseLine: Record 39;
        RequisitionLine: Record 51511399;
    begin
        //IF (PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order]) AND (PurchaseHeader."Requisition No"<>'') THEN
        //BEGIN
        RequisitionLine.RESET;
        RequisitionLine.SETRANGE("Requisition No", ApprovalEntry."Document No.");
        IF RequisitionLine.FIND('-') THEN BEGIN
            REPEAT
                FnCommitAmount((RequisitionLine.Amount) * -1, FnGetAccountToCommit(RequisitionLine.Type, RequisitionLine.No), RequisitionLine."Current Budget", RequisitionLine."Requisition No", CommitmentEntries."Commitment Type"::PR,
                                   RequisitionLine."Global Dimension 1 Code", RequisitionLine."Global Dimension 2 Code", TODAY, CommitmentEntries.Type::Reversal, RequisitionLine."ShortCut Dimension 3 Code");
            UNTIL RequisitionLine.NEXT = 0;
        END;
        //END;
    end;

    procedure FnCalculateCommitedAmountForRequisition(DocNo: Code[40]) Amount: Decimal
    var
        CommitmentEntries: Record "Commitment Entries";
    begin
        CommitmentEntries.RESET;
        CommitmentEntries.SETRANGE("Document No.", DocNo);
        CommitmentEntries.SETRANGE(Type, CommitmentEntries.Type::" ");
        IF CommitmentEntries.FINDSET THEN BEGIN
            REPEAT
                Amount := Amount + ABS(CommitmentEntries.Amount);
            UNTIL CommitmentEntries.NEXT = 0;
        END;

        EXIT(Amount);
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]
    procedure FnFaDepreciationStartDate(var PurchaseHeader: Record 38)
    var
        PurchaseLine: Record 39;
        FADepreciationBook: Record "FA Depreciation Book";
    begin
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::"Fixed Asset");
        IF PurchaseLine.FINDSET THEN BEGIN
            REPEAT
                FADepreciationBook.RESET;
                FADepreciationBook.SETRANGE("FA No.", PurchaseLine."No.");
                IF FADepreciationBook.FINDSET THEN BEGIN

                    FADepreciationBook."Depreciation Starting Date" := PurchaseHeader."Posting Date";
                    FADepreciationBook.VALIDATE("No. of Depreciation Years");
                    FADepreciationBook.MODIFY;


                END;
            UNTIL PurchaseLine.NEXT = 0;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]
    procedure FnOnAfterPostLPO(var Sender: Codeunit 90; var PurchaseHeader: Record 38; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        PurchaseLine: Record 39;
    begin
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order] THEN BEGIN
            PurchaseLine.RESET;
            PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
            IF PurchaseLine.FINDSET THEN BEGIN
                REPEAT
                /* FnCommitAmount(-PurchaseLine.Amount, FnGetAccountToCommit(PurchaseLine.Type, PurchaseLine."No."), PurchaseLine."Current Budget", PurchaseLine."Document No.",
                                CommitmentEntries."Commitment Type"::LPO, PurchaseLine."Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 2 Code",
                                PurchaseHeader."Document Date", CommitmentEntries.Type::Reversal, PurchaseLine."Shortcut Dimension 3 Code"); */
                UNTIL PurchaseLine.NEXT = 0;
            END;
        END;


    end;

    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
    procedure FnAfterAPproveTenderDocument(var ApprovalEntry: Record "Approval Entry")
    var
    //TenderOpeningHeader: Record 51511440;
    begin
        IF (ApprovalEntry."Table ID" = 51511393) AND (ApprovalEntry."Approval Code" = 'TENDERS') THEN BEGIN

        END;
    end;

    local procedure FnGetDepreciationBookCode(FixedAsset: Record "Fixed Asset")
    begin
    end;

    procedure FnGetReservedAmount(GLAccount: Code[20]; BudgetYear: Code[20]; Station: Code[20]; Department: Code[20]) Amount: Decimal
    var
        BudgetEntryLine: Record "Commitment Entries";
    begin
        Amount := 0;
        GLSetup.GET;
        IF (Station = '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE(BudgetEntryLine."Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Year", BudgetYear);
            //BudgetEntryLine.SETRANGE("Commitment Date",GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE(BudgetEntryLine.Type, BudgetEntryLine.Type::Reservation);

            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station = '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE(BudgetEntryLine."Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Year", BudgetYear);
            //BudgetEntryLine.SETRANGE("Commitment Date",GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 1 Code", Department);
            BudgetEntryLine.SETRANGE(BudgetEntryLine.Type, BudgetEntryLine.Type::Reservation);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station <> '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE(BudgetEntryLine."Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Year", BudgetYear);
            //BudgetEntryLine.SETRANGE("Commitment Date",GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 2 Code", Station);
            BudgetEntryLine.SETRANGE(BudgetEntryLine.Type, BudgetEntryLine.Type::Reservation);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station <> '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE(BudgetEntryLine."Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Year", BudgetYear);
            //BudgetEntryLine.SETRANGE("Commitment Date",GLSetup."Current Budget Start Date",GLSetup."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 1 Code", Department);
            BudgetEntryLine.SETRANGE("Global Dimension 2 Code", Station);
            BudgetEntryLine.SETRANGE(BudgetEntryLine.Type, BudgetEntryLine.Type::Reservation);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;


        EXIT(Amount);
    end;

    /* procedure FnCheckCommitteeChairSelected(CommiteeMembers: Record 51511406; TenderCommiteeAppointment: Record 51511408)
    var
        CommiteeMembersC: Record 51511406;
    begin
        CommiteeMembers.RESET;
        CommiteeMembers.SETCURRENTKEY(CommiteeMembers."Committee ID");
        CommiteeMembers.SETFILTER("Appointment No", TenderCommiteeAppointment."Appointment No");
        IF CommiteeMembers.FIND('-') THEN BEGIN
            REPEAT
                CommiteeMembersC.RESET;
                CommiteeMembersC.SETFILTER("Appointment No", TenderCommiteeAppointment."Appointment No");
                CommiteeMembersC.SETFILTER("Committee ID", CommiteeMembers."Committee ID");
                CommiteeMembersC.SETFILTER(Chair, '%1', TRUE);
                IF NOT CommiteeMembersC.FINDSET THEN
                    ERROR('You have not selected a chair for the committee type %1', CommiteeMembers."Committee ID");
            UNTIL CommiteeMembers.NEXT = 0;
        END;
    end; */

    /* procedure FnCheckCommitteeSecSelected(CommiteeMembers: Record 51511406; TenderCommiteeAppointment: Record 51511408)
    var
        CommiteeMembersC: Record 51511406;
    begin
        CommiteeMembers.RESET;
        CommiteeMembers.SETCURRENTKEY(CommiteeMembers."Committee ID");
        CommiteeMembers.SETFILTER("Appointment No", TenderCommiteeAppointment."Appointment No");
        IF CommiteeMembers.FIND('-') THEN BEGIN
            REPEAT
                CommiteeMembersC.RESET;
                CommiteeMembersC.SETFILTER("Appointment No", TenderCommiteeAppointment."Appointment No");
                CommiteeMembersC.SETFILTER("Committee ID", CommiteeMembers."Committee ID");
                CommiteeMembersC.SETFILTER(Secretary, '%1', TRUE);
                IF NOT CommiteeMembersC.FINDSET THEN
                    ERROR('You have not selected a secretary for the committee type %1', CommiteeMembers."Committee ID");
            UNTIL CommiteeMembers.NEXT = 0;
        END;
    end; */

    procedure FnCreateGnlJournalLineFA(TemplateName: Text; BatchName: Text; DocumentNo: Code[30]; LineNo: Integer; TransactionType: Option ,"Registration Fee","Deposit Contribution","Share Contribution",Loan,"Loan Repayment",Withdrawal,"Interest Due","Interest Paid",Investment,"Dividend Paid","Processing Fee","Withholding Tax","BBF Contribution","Admin Charges",Commission; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[50]; TransactionDate: Date; TransactionAmount: Decimal; Dimension1: Code[40]; Dimension2: Code[40]; ExternalDocumentNo: Code[50]; TransactionDescription: Text; LoanNumber: Code[50]; Currency: Code[10]; AppliesToDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; AppliesToDocNo: Code[50]; CurrencyFactor: Decimal; FAPostingType: Option " ","Acquisition Cost",Depreciation,"Write-Down",Appreciation,"Custom 1","Custom 2",Disposal,Maintenance)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := TemplateName;
        GenJournalLine."Journal Batch Name" := BatchName;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := AccountType;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine."Transaction Type" := TransactionType;
        GenJournalLine."Loan No" := LoanNumber;
        GenJournalLine."Posting Date" := TransactionDate;
        GenJournalLine."Currency Code" := Currency;
        IF GenJournalLine."Currency Code" <> '' THEN
            GenJournalLine.VALIDATE("Currency Code");
        GenJournalLine.Description := TransactionDescription;
        GenJournalLine.Amount := TransactionAmount;
        GenJournalLine."External Document No." := ExternalDocumentNo;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := Dimension1;
        GenJournalLine."Shortcut Dimension 2 Code" := Dimension2;
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
        GenJournalLine."Applies-to Doc. Type" := AppliesToDocType;
        GenJournalLine."Applies-to Doc. No." := AppliesToDocNo;
        GenJournalLine."Currency Factor" := CurrencyFactor;
        GenJournalLine."FA Posting Type" := FAPostingType;
        GenJournalLine."FA Posting Date" := TODAY;
        GenJournalLine.VALIDATE(Amount);
        // IF GenJournalLine.Amount<>0 THEN BEGIN
        IF NOT GenJournalLine.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", GenJournalLine."Line No.") THEN
            GenJournalLine.INSERT;
        //END;
    end;

    /* procedure FnCreateDisposalInvoice(Disposal: Record 51511393)
    var
        Sales: Record 36;
        SalesLine: Record 37;
        //DisposalLines: Record 51511400;
        //FilteredList: Record 51511400;
        LineNo: Integer;
    begin
        IF Disposal.No <> '' THEN BEGIN
            DisposalLines.RESET;
            DisposalLines.SETRANGE("Requisition No", Disposal.No);
            DisposalLines.SETFILTER(Buyer, '<>%1', '');
            IF DisposalLines.FIND('-') THEN BEGIN
                REPEAT
                    IF DisposalLines."Invoice No" = '' THEN BEGIN
                        SalesSetup.GET;
                        Sales.RESET;
                        Sales.INIT;
                        Sales."Document Type" := Sales."Document Type"::Invoice;
                        Sales."No." := NoSerieSMgt.GetNextNo(SalesSetup."Invoice Nos.", TODAY, TRUE);
                        Sales."Sell-to Customer No." := DisposalLines.Buyer;
                        Sales.VALIDATE("Sell-to Customer No.");
                        Sales."Posting Description" := 'Asset Disposal';
                        IF Sales.INSERT THEN BEGIN
                            LineNo := 10000;
                            FilteredList.RESET;
                            FilteredList.SETRANGE("Requisition No", DisposalLines."Requisition No");
                            FilteredList.SETRANGE(Buyer, DisposalLines.Buyer);
                            IF FilteredList.FIND('-') THEN BEGIN
                                REPEAT
                                    SalesLine.RESET;
                                    SalesLine.INIT;
                                    SalesLine."Document No." := Sales."No.";
                                    SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                                    SalesLine.Type := SalesLine.Type::"Fixed Asset";
                                    SalesLine.VALIDATE(Type);
                                    SalesLine."Line No." := LineNo;
                                    SalesLine."No." := FilteredList.No;
                                    SalesLine.VALIDATE("No.");
                                    SalesLine.Quantity := 1;
                                    SalesLine.VALIDATE(Quantity);
                                    SalesLine."Unit Price" := FilteredList."Selling Price";
                                    SalesLine.VALIDATE("Unit Price");
                                    IF SalesLine.INSERT THEN BEGIN
                                        FilteredList."Invoice No" := Sales."No.";
                                        FilteredList.MODIFY;
                                        LineNo := LineNo + 1000;
                                    END;
                                UNTIL FilteredList.NEXT = 0;
                            END;
                        END;
                    END;
                UNTIL DisposalLines.NEXT = 0;
            END;
        END;
    end; */

    /* [EventSubscriber(ObjectType::Codeunit, 51511003, 'OnAfterReleaseTenderCommHeader', '', false, false)]
    procedure FnSendEmailToCommitteeMembersOnApproval(TCommAppoint: Record 51511408)
    var
        PRequest: Record 51511393;
        CMembers: Record 51511406;
        RFXAppointLetter: Report 51511660;
        setuprec: Record 312;
        RFXAppointmentName: Text[250];
        RecipientsMails: Text[250];
        UserSetup: Record "User Setup";
    begin
        PRequest.RESET;
        PRequest.SETRANGE(No, TCommAppoint."Tender/Quotation No");
        IF PRequest.FINDSET(TRUE) THEN BEGIN
            CMembers.RESET;
            CMembers.SETRANGE("Appointment No", TCommAppoint."Appointment No");
            IF CMembers.FINDSET(TRUE) THEN
                REPEAT
                    RFXAppointmentName := TCommAppoint."Tender/Quotation No";
                    RFXAppointmentName := CONVERTSTR(RFXAppointmentName, '/', '_');
                    RFXAppointmentName := CONVERTSTR(RFXAppointmentName, '\', '_');
                    CLEAR(RFXAppointLetter);
                    RFXAppointLetter.SETTABLEVIEW(PRequest);
                    IF UserSetup.GET(CMembers."Employee No") THEN
                        RecipientsMails := UserSetup."E-Mail";
                    setuprec.GET;
                    RFXAppointLetter.SAVEASPDF(setuprec."RFQ Documents Path" + (FORMAT(RFXAppointmentName) + '_' + CMembers.Name + '.pdf'));
                    FnSendEmailWithAttachment(setuprec."Procurement Email", 'PROCUREMENT TEAM', RecipientsMails, 'COMMITEE APPOINTMENT', 'Please find attached',
                    setuprec."RFQ Documents Path" + (FORMAT(RFXAppointmentName) + '_' + CMembers.Name + '.pdf'));
                UNTIL CMembers.NEXT = 0
        END;
    end; */

    /* procedure FnSendEmailAttachment(CommiteeMembers: Record 51511406; TenderCommiteeAppointment: Record 51511408; ProcurementRequest: Record 51511393)
    begin
    end; */

    procedure FnSendEmailWithAttachment(SenderEmailAddress: Text; SenderName: Text; RecepientsMail: Text; Subject: Text; Body: Text; AttachmentFile: Text[250])
    var
        SMTPMail: Codeunit 400;
    begin
        IF (SenderEmailAddress <> '') AND (RecepientsMail <> '') AND (Subject <> '') THEN BEGIN
            SMTPMail.CreateMessage(SenderName, SenderEmailAddress, RecepientsMail, Subject, Body, TRUE);
            SMTPMail.AddAttachment(AttachmentFile, AttachmentFile);
            SMTPMail.Send();
        END;
    end;

    procedure FnUploadToSharePoint()
    begin
        HYPERLINK('http://app-svr-dev:82/Human%20Resource/Forms/AllItems.aspx?RootFolder=%2FHuman%20Resource%2FProcurement&FolderCTID=0x0120002438E10E7E7E174C99AFC9A3B7DC0E8B&View=%7B36093C86%2D6448%2D4254%2D84E9%2D4E0F83F99E82%7D');
    end;

    /* procedure FnCreatePayrollApproval(DocNo: Code[10]; PayPeriod: Date)
    var
        Earn: Record 51511108;
        Ded: Record 51511109;
        AssignMatrix: Record 51511111;
        PayTrans: Record 51511781;
        GlEntry: Record "G/L Entry";
        BudEntry: Record "G/L Budget Entry";
        CashSetup: Record "Cash Management Setup";
    begin
        PayTrans.RESET;
        PayTrans.SETRANGE(Code, DocNo);
        IF PayTrans.FIND('-') THEN BEGIN
            PayTrans.DELETEALL;
        END;

        Earn.RESET;
        Earn.SETFILTER(Code, '<>%1', '');
        Earn.SETRANGE("Pay Period Filter", PayPeriod);
        IF Earn.FIND('-') THEN BEGIN
            REPEAT
                Earn.CALCFIELDS("Total Amount");
                IF Earn."Total Amount" <> 0 THEN BEGIN
                    PayTrans.INIT;
                    PayTrans.Code := DocNo;
                    PayTrans.Type := PayTrans.Type::Earning;
                    PayTrans."ED Code" := Earn.Code;
                    PayTrans.Description := Earn.Description;
                    PayTrans.Amount := Earn."Total Amount";
                    IF Earn."Non-Cash Benefit" = TRUE THEN
                        PayTrans."Non Cash" := TRUE;
                    //Check budget
                    CashSetup.GET;
                    BudEntry.RESET;
                    BudEntry.SETRANGE("Budget Name", CashSetup."Current Budget");
                    BudEntry.SETRANGE("G/L Account No.", Earn."G/L Account");
                    IF BudEntry.FIND('-') THEN BEGIN
                        BudEntry.CALCSUMS(Amount);
                        GlEntry.RESET;
                        GlEntry.SETRANGE("G/L Account No.", Earn."G/L Account");
                        GlEntry.SETRANGE("Posting Date", CashSetup."Budget Start Date", TODAY);
                        IF GlEntry.FIND('-') THEN BEGIN
                            PayTrans."Available Budget" := BudEntry.Amount - ABS(GlEntry.Amount);
                        END;
                    END;
                    IF PayTrans."Available Budget" < 0 THEN
                        PayTrans."Available Budget" := 0;
                    PayTrans.INSERT;
                END;
            UNTIL Earn.NEXT = 0;
        END;

        Ded.RESET;
        Ded.SETFILTER(Code, '<>%1', '');
        Ded.SETRANGE("Pay Period Filter", PayPeriod);
        IF Ded.FIND('-') THEN BEGIN
            REPEAT
                Ded.CALCFIELDS("Total Amount", "Total Amount Employer");
                IF ((Ded."Total Amount" <> 0) OR (Ded."Total Amount Employer" <> 0)) THEN BEGIN
                    PayTrans.INIT;
                    PayTrans.Code := DocNo;
                    PayTrans.Type := PayTrans.Type::Deduction;
                    PayTrans."ED Code" := Ded.Code;
                    PayTrans.Description := Ded.Description;
                    PayTrans.Amount := Ded."Total Amount";
                    IF Ded."Total Amount Employer" <> 0 THEN BEGIN
                        PayTrans."Employer Amount" := Ded."Total Amount Employer";
                        //Check budget
                        CashSetup.GET;
                        BudEntry.RESET;
                        BudEntry.SETRANGE("Budget Name", CashSetup."Current Budget");
                        BudEntry.SETRANGE("G/L Account No.", Ded."G/L Account Employer");
                        IF BudEntry.FIND('-') THEN BEGIN
                            BudEntry.CALCSUMS(Amount);
                            GlEntry.RESET;
                            GlEntry.SETRANGE("G/L Account No.", Ded."G/L Account Employer");
                            GlEntry.SETRANGE("Posting Date", CashSetup."Budget Start Date", TODAY);
                            IF GlEntry.FIND('-') THEN BEGIN
                                PayTrans."Available Budget" := BudEntry.Amount - ABS(GlEntry.Amount);
                            END;
                        END;
                        IF PayTrans."Available Budget" < 0 THEN
                            PayTrans."Available Budget" := 0;
                    END;
                    PayTrans.INSERT;
                END;
            UNTIL Ded.NEXT = 0;
        END;
    end; */
}

