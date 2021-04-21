codeunit 51513001 "Copy Document Mgt Insure"
{
    // version AES-INS 1.0


    trigger OnRun();
    begin
    end;

    var
        Text000: Label 'Please enter a Document No.';
        Text001: Label '%1 %2 cannot be copied onto itself.';
        Text002: Label 'The existing lines for %1 %2 will be deleted.\\';
        Text003: Label 'Do you want to continue?';
        Text004: Label 'The document line(s) with a G/L account where direct posting is not allowed have not been copied to the new document by the Copy Document batch job.';
        Text006: Label 'NOTE: A Payment Discount was Granted by %1 %2.';
        Text007: Label 'Quote,Blanket Order,Order,Invoice,Credit Memo,Posted Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt';
        Currency: Record Currency;
        Item: Record Item;
        AsmHeader: Record "Assembly Header";
        PostedAsmHeader: Record "Posted Assembly Header";
        TempAsmHeader: Record "Assembly Header" temporary;
        TempAsmLine: Record "Assembly Line" temporary;
        TempSalesInvLine: Record "Insure Debit Note Lines" temporary;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        TransferOldExtLines: Codeunit "Transfer Old Ext. Text Lines";
        Window: Dialog;
        WindowUpdateDateTime: DateTime;
        SalesDocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Shipment","Posted Invoice","Posted Return Receipt","Posted Credit Memo";
        PurchDocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Receipt","Posted Invoice","Posted Return Shipment","Posted Credit Memo";
        ServDocType: Option Quote,Contract;
        QtyToAsmToOrder: Decimal;
        QtyToAsmToOrderBase: Decimal;
        IncludeHeader: Boolean;
        RecalculateLines: Boolean;
        MoveNegLines: Boolean;
        Text008: Label 'There are no negative sales lines to move.';
        Text009: Label 'NOTE: A Payment Discount was Received by %1 %2.';
        Text010: Label 'There are no negative purchase lines to move.';
        CreateToHeader: Boolean;
        Text011: Label 'Please enter a Vendor No.';
        HideDialog: Boolean;
        Text012: Label 'There are no sales lines to copy.';
        Text013: Label 'Shipment No.,Invoice No.,Return Receipt No.,Credit Memo No.';
        Text014: Label 'Receipt No.,Invoice No.,Return Shipment No.,Credit Memo No.';
        Text015: Label '%1 %2:';
        Text016: Label '"Inv. No. ,Shpt. No. ,Cr. Memo No. ,Rtrn. Rcpt. No. "';
        Text017: Label '"Inv. No. ,Rcpt. No. ,Cr. Memo No. ,Rtrn. Shpt. No. "';
        Text018: Label '%1 - %2:';
        Text019: Label 'Exact Cost Reversing Link has not been created for all copied document lines.';
        Text020: Label '\';
        Text022: Label 'Copying document lines...\';
        Text023: Label 'Processing source lines      #1######\';
        Text024: Label 'Creating new lines           #2######';
        ExactCostRevMandatory: Boolean;
        ApplyFully: Boolean;
        AskApply: Boolean;
        ReappDone: Boolean;
        Text025: Label 'For one or more return document lines, you chose to return the original quantity, which is already fully applied. Therefore, when you post the return document, the program will reapply relevant entries. Beware that this may change the cost of existing entries. To avoid this, you must delete the affected return document lines before posting.';
        SkippedLine: Boolean;
        Text029: Label 'One or more return document lines were not inserted or they contain only the remaining quantity of the original document line. This is because quantities on the posted document line are already fully or partially applied. If you want to reverse the full quantity, you must select Return Original Quantity before getting the posted document lines.';
        Text030: Label 'One or more return document lines were not copied. This is because quantities on the posted document line are already fully or partially applied, so the Exact Cost Reversing link could not be created.';
        Text031: Label 'Return document line contains only the original document line quantity, that is not already manually applied.';
        SomeAreFixed: Boolean;
        AsmHdrExistsForFromDocLine: Boolean;
        Text032: Label 'The posted sales invoice %1 covers more than one shipment of linked assembly orders that potentially have different assembly components. Select Posted Shipment as document type, and then select a specific shipment of assembled items.';
        SkipCopyFromDescription: Boolean;
        SkipTestCreditLimit: Boolean;
        WarningDone: Boolean;
        LinesApplied: Boolean;

    procedure SetProperties(NewIncludeHeader: Boolean; NewRecalculateLines: Boolean; NewMoveNegLines: Boolean; NewCreateToHeader: Boolean; NewHideDialog: Boolean; NewExactCostRevMandatory: Boolean; NewApplyFully: Boolean);
    begin
        IncludeHeader := NewIncludeHeader;
        RecalculateLines := NewRecalculateLines;
        MoveNegLines := NewMoveNegLines;
        CreateToHeader := NewCreateToHeader;
        HideDialog := NewHideDialog;
        ExactCostRevMandatory := NewExactCostRevMandatory;
        ApplyFully := NewApplyFully;
        AskApply := FALSE;
        ReappDone := FALSE;
        SkippedLine := FALSE;
        SomeAreFixed := FALSE;
        SkipCopyFromDescription := FALSE;
        SkipTestCreditLimit := FALSE;
    end;

    procedure SetPropertiesForCreditMemoCorrection();
    begin
        SetProperties(TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE);
    end;

    procedure SetPropertiesForInvoiceCorrection();
    begin
        SetProperties(TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE);
        SkipCopyFromDescription := TRUE;
        SkipTestCreditLimit := TRUE;
    end;

    procedure SalesHeaderDocType(DocType: Option): Integer;
    var
        SalesHeader: Record "Insure Header";
    begin
        CASE DocType OF
            SalesDocType::Quote:
                EXIT(SalesHeader."Document Type"::Quote);
            SalesDocType::"Blanket Order":
                EXIT(SalesHeader."Document Type"::"Accepted Quote");
        //SalesDocType::Order:
        //EXIT(SalesHeader."Document Type"::Order);
        //SalesDocType::Invoice:
        //EXIT(SalesHeader."Document Type"::Invoice);
        //SalesDocType::"Return Order":
        //EXIT(SalesHeader."Document Type"::"Return Order");
        //SalesDocType::"Credit Memo":
        //EXIT(SalesHeader."Document Type"::"Credit Memo");
        END;
    end;

    procedure PurchHeaderDocType(DocType: Option): Integer;
    var
        FromPurchHeader: Record "Purchase Header";
    begin
        CASE DocType OF
            PurchDocType::Quote:
                EXIT(FromPurchHeader."Document Type"::Quote);
            PurchDocType::"Blanket Order":
                EXIT(FromPurchHeader."Document Type"::"Blanket Order");
            PurchDocType::Order:
                EXIT(FromPurchHeader."Document Type"::Order);
            PurchDocType::Invoice:
                EXIT(FromPurchHeader."Document Type"::Invoice);
            PurchDocType::"Return Order":
                EXIT(FromPurchHeader."Document Type"::"Return Order");
            PurchDocType::"Credit Memo":
                EXIT(FromPurchHeader."Document Type"::"Credit Memo");
        END;
    end;

    procedure CopySalesDocForInvoiceCancelling(FromDocNo: Code[20]; var ToSalesHeader: Record "Insure Header");
    begin
        CopySalesDoc(SalesDocType::"Posted Invoice", FromDocNo, ToSalesHeader);
    end;

    procedure CopySalesDoc(FromDocType: Option; FromDocNo: Code[20]; var ToSalesHeader: Record "Insure Header");
    var
        PaymentTerms: Record "Payment Terms";
        ToSalesLine: Record "Insure Lines";
        OldSalesHeader: Record "Insure Header";
        FromSalesHeader: Record "Insure Header";
        FromSalesLine: Record "Insure Lines";
        FromSalesShptHeader: Record "Sales Shipment Header";
        FromSalesShptLine: Record "Sales Shipment Line";
        FromSalesInvHeader: Record "Insure Debit Note";
        FromSalesInvLine: Record "Insure Debit Note Lines";
        FromReturnRcptHeader: Record "Return Receipt Header";
        FromReturnRcptLine: Record "Return Receipt Line";
        FromSalesCrMemoHeader: Record "Insure Credit Note";
        FromSalesCrMemoLine: Record "Insure Credit Note Lines";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLSetUp: Record "General Ledger Setup";
        Cust: Record Customer;
        NextLineNo: Integer;
        ItemChargeAssgntNextLineNo: Integer;
        LinesNotCopied: Integer;
        MissingExCostRevLink: Boolean;
        ReleaseSalesDocument: Codeunit 414;
        ReleaseDocument: Boolean;
    begin
        /*WITH ToSalesHeader DO BEGIN
          IF NOT CreateToHeader THEN BEGIN
            TESTFIELD(Status,Status::Open);
            IF FromDocNo = '' THEN
              ERROR(Text000);
            FIND;
          END;
          TransferOldExtLines.ClearLineNumbers;
          CASE FromDocType OF
            SalesDocType::Quote,
            SalesDocType::"Blanket Order",
            SalesDocType::Order,
            SalesDocType::Invoice,
            SalesDocType::"Return Order",
            SalesDocType::"Credit Memo":
              BEGIN
                FromSalesHeader.GET(SalesHeaderDocType(FromDocType),FromDocNo);
                IF MoveNegLines THEN
                  DeleteSalesLinesWithNegQty(FromSalesHeader,TRUE);
                IF (FromSalesHeader."Document Type" = "Document Type") AND
                   (FromSalesHeader."No." = "No.")
                THEN
                  ERROR(Text001,"Document Type","No.");
        
               { IF "Document Type" <= "Document Type"::Invoice THEN BEGIN
                  FromSalesHeader.CALCFIELDS("Amount Including VAT");
                  "Amount Including VAT" := FromSalesHeader."Amount Including VAT";
                  CheckCreditLimit(FromSalesHeader,ToSalesHeader);
                END;}
                CheckCopyFromSalesHeaderAvail(FromSalesHeader,ToSalesHeader);
        
                IF NOT IncludeHeader AND NOT RecalculateLines THEN
                  CheckFromSalesHeader(FromSalesHeader,ToSalesHeader);
              END;
            SalesDocType::"Posted Shipment":
              BEGIN
                FromSalesShptHeader.GET(FromDocNo);
                CheckCopyFromSalesShptAvail(FromSalesShptHeader,ToSalesHeader);
        
                IF NOT IncludeHeader AND NOT RecalculateLines THEN
                  CheckFromSalesShptHeader(FromSalesShptHeader,ToSalesHeader);
              END;
            SalesDocType::"Posted Invoice":
              BEGIN
                FromSalesInvHeader.GET(FromDocNo);
                FromSalesInvHeader.TESTFIELD("Prepayment Invoice",FALSE);
                WarnSalesInvoicePmtDisc(ToSalesHeader,FromSalesHeader,FromDocType,FromDocNo);
                IF "Document Type" <= "Document Type"::Invoice THEN BEGIN
                  FromSalesInvHeader.CALCFIELDS("Amount Including VAT");
                  "Amount Including VAT" := FromSalesInvHeader."Amount Including VAT";
                  IF IncludeHeader THEN
                    FromSalesHeader.TRANSFERFIELDS(FromSalesInvHeader);
                  CheckCreditLimit(FromSalesHeader,ToSalesHeader);
                END;
                CheckCopyFromSalesInvoiceAvail(FromSalesInvHeader,ToSalesHeader);
        
                IF NOT IncludeHeader AND NOT RecalculateLines THEN
                  CheckFromSalesInvHeader(FromSalesInvHeader,ToSalesHeader);
              END;
            SalesDocType::"Posted Return Receipt":
              BEGIN
                FromReturnRcptHeader.GET(FromDocNo);
                CheckCopyFromSalesRetRcptAvail(FromReturnRcptHeader,ToSalesHeader);
        
                IF NOT IncludeHeader AND NOT RecalculateLines THEN
                  CheckFromSalesReturnRcptHeader(FromReturnRcptHeader,ToSalesHeader);
              END;
            SalesDocType::"Posted Credit Memo":
              BEGIN
                FromSalesCrMemoHeader.GET(FromDocNo);
                WarnSalesInvoicePmtDisc(ToSalesHeader,FromSalesHeader,FromDocType,FromDocNo);
                IF "Document Type" <= "Document Type"::Invoice THEN BEGIN
                  FromSalesCrMemoHeader.CALCFIELDS("Amount Including VAT");
                  "Amount Including VAT" := FromSalesCrMemoHeader."Amount Including VAT";
                  IF IncludeHeader THEN
                    FromSalesHeader.TRANSFERFIELDS(FromSalesInvHeader);
                  CheckCreditLimit(FromSalesHeader,ToSalesHeader);
                END;
                CheckCopyFromSalesCrMemoAvail(FromSalesCrMemoHeader,ToSalesHeader);
        
                IF NOT IncludeHeader AND NOT RecalculateLines THEN
                  CheckFromSalesCrMemoHeader(FromSalesCrMemoHeader,ToSalesHeader);
              END;
          END;
          ToSalesLine.LOCKTABLE;
        
          IF CreateToHeader THEN BEGIN
            INSERT(TRUE);
            ToSalesLine.SETRANGE("Document Type","Document Type");
            ToSalesLine.SETRANGE("Document No.","No.");
          END ELSE BEGIN
            ToSalesLine.SETRANGE("Document Type","Document Type");
            ToSalesLine.SETRANGE("Document No.","No.");
            IF IncludeHeader THEN
              IF NOT ToSalesLine.ISEMPTY THEN BEGIN
                COMMIT;
                IF NOT
                   CONFIRM(
                     Text002 +
                     Text003,TRUE,
                     "Document Type","No.")
                THEN
                  EXIT;
                ToSalesLine.DELETEALL(TRUE);
              END;
          END;
        
          IF ToSalesLine.FINDLAST THEN
            NextLineNo := ToSalesLine."Line No."
          ELSE
            NextLineNo := 0;
        
          IF IncludeHeader THEN BEGIN
            IF Cust.GET(FromSalesHeader."Sell-to Customer No.") THEN
              Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,FALSE);
            IF Cust.GET(FromSalesHeader."Bill-to Customer No.") THEN
              Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,FALSE);
            OldSalesHeader := ToSalesHeader;
            CASE FromDocType OF
              SalesDocType::Quote,
              SalesDocType::"Blanket Order",
              SalesDocType::Order,
              SalesDocType::Invoice,
              SalesDocType::"Return Order",
              SalesDocType::"Credit Memo":
                BEGIN
                  TRANSFERFIELDS(FromSalesHeader,FALSE);
                  "Last Shipping No." := '';
                  Status := Status::Open;
                  IF "Document Type" <> "Document Type"::Order THEN
                    "Prepayment %" := 0;
                  IF FromDocType = SalesDocType::"Return Order" THEN
                    VALIDATE("Ship-to Code");
                  IF FromDocType IN [SalesDocType::Quote,SalesDocType::"Blanket Order"] THEN
                    IF OldSalesHeader."Posting Date" = 0D THEN
                      "Posting Date" := WORKDATE
                    ELSE
                      "Posting Date" := OldSalesHeader."Posting Date";
                END;
              SalesDocType::"Posted Shipment":
                BEGIN
                  VALIDATE("Sell-to Customer No.",FromSalesShptHeader."Sell-to Customer No.");
                  TRANSFERFIELDS(FromSalesShptHeader,FALSE);
                END;
              SalesDocType::"Posted Invoice":
                BEGIN
                  VALIDATE("Sell-to Customer No.",FromSalesInvHeader."Sell-to Customer No.");
                  TRANSFERFIELDS(FromSalesInvHeader,FALSE);
                END;
              SalesDocType::"Posted Return Receipt":
                BEGIN
                  VALIDATE("Sell-to Customer No.",FromReturnRcptHeader."Sell-to Customer No.");
                  TRANSFERFIELDS(FromReturnRcptHeader,FALSE);
                END;
              SalesDocType::"Posted Credit Memo":
                BEGIN
                  VALIDATE("Sell-to Customer No.",FromSalesCrMemoHeader."Sell-to Customer No.");
                  TRANSFERFIELDS(FromSalesCrMemoHeader,FALSE);
                END;
            END;
            Invoice := FALSE;
            Ship := FALSE;
            IF Status = Status::Released THEN BEGIN
              Status := Status::Open;
              ReleaseDocument := TRUE;
            END;
            IF MoveNegLines OR IncludeHeader THEN
              VALIDATE("Location Code");
        
            CopyFieldsFromOldSalesHeader(ToSalesHeader,OldSalesHeader);
            IF RecalculateLines THEN
              CreateDim(
                DATABASE::"Responsibility Center","Responsibility Center",
                DATABASE::Customer,"Bill-to Customer No.",
                DATABASE::"Salesperson/Purchaser","Salesperson Code",
                DATABASE::Campaign,"Campaign No.",
                DATABASE::"Customer Template","Bill-to Customer Template Code");
            "No. Printed" := 0;
            "Applies-to Doc. Type" := "Applies-to Doc. Type"::" ";
            "Applies-to Doc. No." := '';
            "Applies-to ID" := '';
            "Opportunity No." := '';
            "Quote No." := '';
            IF ((FromDocType = SalesDocType::"Posted Invoice") AND
                ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"])) OR
               ((FromDocType = SalesDocType::"Posted Credit Memo") AND
                NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]))
            THEN BEGIN
              CustLedgEntry.SETCURRENTKEY("Document No.");
              IF FromDocType = SalesDocType::"Posted Invoice" THEN
                CustLedgEntry.SETRANGE("Document Type",CustLedgEntry."Document Type"::Invoice)
              ELSE
                CustLedgEntry.SETRANGE("Document Type",CustLedgEntry."Document Type"::"Credit Memo");
              CustLedgEntry.SETRANGE("Document No.",FromDocNo);
              CustLedgEntry.SETRANGE("Customer No.","Bill-to Customer No.");
              CustLedgEntry.SETRANGE(Open,TRUE);
              IF CustLedgEntry.FINDFIRST THEN BEGIN
                IF FromDocType = SalesDocType::"Posted Invoice" THEN BEGIN
                  "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
                  "Applies-to Doc. No." := FromDocNo;
                END ELSE BEGIN
                  "Applies-to Doc. Type" := "Applies-to Doc. Type"::"Credit Memo";
                  "Applies-to Doc. No." := FromDocNo;
                END;
                CustLedgEntry.CALCFIELDS("Remaining Amount");
                CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
                CustLedgEntry."Accepted Payment Tolerance" := 0;
                CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
                CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
              END;
            END;
        
            IF "Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote] THEN
              "Posting Date" := 0D;
        
            Correction := FALSE;
            IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
              "Shipment Date" := 0D;
              GLSetUp.GET;
              Correction := GLSetUp."Mark Cr. Memos as Corrections";
              IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN
                PaymentTerms.GET("Payment Terms Code")
              ELSE
                CLEAR(PaymentTerms);
              IF NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                "Payment Terms Code" := '';
                "Payment Discount %" := 0;
                "Pmt. Discount Date" := 0D;
              END;
            END;
        
            IF CreateToHeader THEN BEGIN
              VALIDATE("Payment Terms Code");
              MODIFY(TRUE);
            END ELSE
              MODIFY;
          END;
        
          LinesNotCopied := 0;
          CASE FromDocType OF
            SalesDocType::Quote,
            SalesDocType::"Blanket Order",
            SalesDocType::Order,
            SalesDocType::Invoice,
            SalesDocType::"Return Order",
            SalesDocType::"Credit Memo":
              BEGIN
                ItemChargeAssgntNextLineNo := 0;
                FromSalesLine.RESET;
                FromSalesLine.SETRANGE("Document Type",FromSalesHeader."Document Type");
                FromSalesLine.SETRANGE("Document No.",FromSalesHeader."No.");
                IF MoveNegLines THEN
                  FromSalesLine.SETFILTER(Quantity,'<=0');
                IF FromSalesLine.FIND('-') THEN
                  REPEAT
                    InitAsmCopyHandling(TRUE);
                    ToSalesLine."Document Type" := "Document Type";
                    AsmHdrExistsForFromDocLine := FromSalesLine.AsmToOrderExists(AsmHeader);
                    IF AsmHdrExistsForFromDocLine THEN BEGIN
                      CASE ToSalesLine."Document Type" OF
                        ToSalesLine."Document Type"::Order:
                          BEGIN
                            QtyToAsmToOrder := FromSalesLine."Qty. to Assemble to Order";
                            QtyToAsmToOrderBase := FromSalesLine."Qty. to Asm. to Order (Base)";
                          END;
                        ToSalesLine."Document Type"::Quote,
                        ToSalesLine."Document Type"::"Blanket Order":
                          BEGIN
                            QtyToAsmToOrder := FromSalesLine.Quantity;
                            QtyToAsmToOrderBase := FromSalesLine."Quantity (Base)";
                          END;
                      END;
                      GenerateAsmDataFromNonPosted(AsmHeader);
                    END;
                    IF CopySalesLine(ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLine,NextLineNo,LinesNotCopied,FALSE) THEN BEGIN
                      IF FromSalesLine.Type = FromSalesLine.Type::"Charge (Item)" THEN
                        CopyFromSalesDocAssgntToLine(ToSalesLine,FromSalesLine,ItemChargeAssgntNextLineNo);
                    END;
                  UNTIL FromSalesLine.NEXT = 0;
              END;
            SalesDocType::"Posted Shipment":
              BEGIN
                FromSalesHeader.TRANSFERFIELDS(FromSalesShptHeader);
                FromSalesShptLine.RESET;
                FromSalesShptLine.SETRANGE("Document No.",FromSalesShptHeader."No.");
                IF MoveNegLines THEN
                  FromSalesShptLine.SETFILTER(Quantity,'<=0');
                CopySalesShptLinesToDoc(ToSalesHeader,FromSalesShptLine,LinesNotCopied,MissingExCostRevLink);
              END;
            SalesDocType::"Posted Invoice":
              BEGIN
                FromSalesHeader.TRANSFERFIELDS(FromSalesInvHeader);
                FromSalesInvLine.RESET;
                FromSalesInvLine.SETRANGE("Document No.",FromSalesInvHeader."No.");
                IF MoveNegLines THEN
                  FromSalesInvLine.SETFILTER(Quantity,'<=0');
                CopySalesInvLinesToDoc(ToSalesHeader,FromSalesInvLine,LinesNotCopied,MissingExCostRevLink);
              END;
            SalesDocType::"Posted Return Receipt":
              BEGIN
                FromSalesHeader.TRANSFERFIELDS(FromReturnRcptHeader);
                FromReturnRcptLine.RESET;
                FromReturnRcptLine.SETRANGE("Document No.",FromReturnRcptHeader."No.");
                IF MoveNegLines THEN
                  FromReturnRcptLine.SETFILTER(Quantity,'<=0');
                CopySalesReturnRcptLinesToDoc(ToSalesHeader,FromReturnRcptLine,LinesNotCopied,MissingExCostRevLink);
              END;
            SalesDocType::"Posted Credit Memo":
              BEGIN
                FromSalesHeader.TRANSFERFIELDS(FromSalesCrMemoHeader);
                FromSalesCrMemoLine.RESET;
                FromSalesCrMemoLine.SETRANGE("Document No.",FromSalesCrMemoHeader."No.");
                IF MoveNegLines THEN
                  FromSalesCrMemoLine.SETFILTER(Quantity,'<=0');
                CopySalesCrMemoLinesToDoc(ToSalesHeader,FromSalesCrMemoLine,LinesNotCopied,MissingExCostRevLink);
              END;
          END;
        END;
        
        IF MoveNegLines THEN BEGIN
          DeleteSalesLinesWithNegQty(FromSalesHeader,FALSE);
          LinkJobPlanningLine(ToSalesHeader);
        END;
        
        IF ReleaseDocument THEN BEGIN
          ToSalesHeader.Status := ToSalesHeader.Status::Released;
          ReleaseSalesDocument.Reopen(ToSalesHeader);
        END ELSE
          IF (FromDocType IN
              [SalesDocType::Quote,
               SalesDocType::"Blanket Order",
               SalesDocType::Order,
               SalesDocType::Invoice,
               SalesDocType::"Return Order",
               SalesDocType::"Credit Memo"])
             AND NOT IncludeHeader AND NOT RecalculateLines
          THEN
            IF FromSalesHeader.Status = FromSalesHeader.Status::Released THEN BEGIN
              ReleaseSalesDocument.RUN(ToSalesHeader);
              ReleaseSalesDocument.Reopen(ToSalesHeader);
            END;
        CASE TRUE OF
          MissingExCostRevLink AND (LinesNotCopied <> 0):
            MESSAGE(Text019 + Text020 + Text004);
          MissingExCostRevLink:
            MESSAGE(Text019);
          LinesNotCopied <> 0:
            MESSAGE(Text004);
    END;*/


    end;

    procedure CopyPurchaseDocForInvoiceCancelling(FromDocNo: Code[20]; var ToPurchaseHeader: Record "Purchase Header");
    begin
        CopyPurchDoc(PurchDocType::"Posted Invoice", FromDocNo, ToPurchaseHeader);
    end;

    procedure CopyPurchDoc(FromDocType: Option; FromDocNo: Code[20]; var ToPurchHeader: Record "Purchase Header");
    var
        PaymentTerms: Record "Payment Terms";
        ToPurchLine: Record "Purchase Line";
        OldPurchHeader: Record "Purchase Header";
        FromPurchHeader: Record "Purchase Header";
        FromPurchLine: Record "Purchase Line";
        FromPurchRcptHeader: Record "Purch. Rcpt. Header";
        FromPurchRcptLine: Record "Purch. Rcpt. Line";
        FromPurchInvHeader: Record "Purch. Inv. Header";
        FromPurchInvLine: Record "Purch. Inv. Line";
        FromReturnShptHeader: Record "Return Shipment Header";
        FromReturnShptLine: Record "Return Shipment Line";
        FromPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        FromPurchCrMemoLine: Record "Purch. Cr. Memo Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        Vend: Record Vendor;
        NextLineNo: Integer;
        ItemChargeAssgntNextLineNo: Integer;
        LinesNotCopied: Integer;
        MissingExCostRevLink: Boolean;
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        ReleaseDocument: Boolean;
    begin
        WITH ToPurchHeader DO BEGIN
            IF NOT CreateToHeader THEN BEGIN
                TESTFIELD(Status, Status::Open);
                IF FromDocNo = '' THEN
                    ERROR(Text000);
                FIND;
            END;
            TransferOldExtLines.ClearLineNumbers;
            CASE FromDocType OF
                PurchDocType::Quote,
                PurchDocType::"Blanket Order",
                PurchDocType::Order,
                PurchDocType::Invoice,
                PurchDocType::"Return Order",
                PurchDocType::"Credit Memo":
                    BEGIN
                        FromPurchHeader.GET(PurchHeaderDocType(FromDocType), FromDocNo);
                        IF MoveNegLines THEN
                            DeletePurchLinesWithNegQty(FromPurchHeader, TRUE);
                        IF (FromPurchHeader."Document Type" = "Document Type") AND
                           (FromPurchHeader."No." = "No.")
                        THEN
                            ERROR(Text001, "Document Type", "No.");
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN
                            CheckFromPurchaseHeader(FromPurchHeader, ToPurchHeader);
                    END;
                PurchDocType::"Posted Receipt":
                    BEGIN
                        FromPurchRcptHeader.GET(FromDocNo);
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN
                            CheckFromPurchaseRcptHeader(FromPurchRcptHeader, ToPurchHeader);
                    END;
                PurchDocType::"Posted Invoice":
                    BEGIN
                        FromPurchInvHeader.GET(FromDocNo);
                        FromPurchInvHeader.TESTFIELD("Prepayment Invoice", FALSE);
                        WarnPurchInvoicePmtDisc(ToPurchHeader, FromPurchHeader, FromDocType, FromDocNo);
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN
                            CheckFromPurchaseInvHeader(FromPurchInvHeader, ToPurchHeader);
                    END;
                PurchDocType::"Posted Return Shipment":
                    BEGIN
                        FromReturnShptHeader.GET(FromDocNo);
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN
                            CheckFromPurchaseReturnShptHeader(FromReturnShptHeader, ToPurchHeader);
                    END;
                PurchDocType::"Posted Credit Memo":
                    BEGIN
                        FromPurchCrMemoHeader.GET(FromDocNo);
                        WarnPurchInvoicePmtDisc(ToPurchHeader, FromPurchHeader, FromDocType, FromDocNo);
                        IF NOT IncludeHeader AND NOT RecalculateLines THEN
                            CheckFromPurchaseCrMemoHeader(FromPurchCrMemoHeader, ToPurchHeader);
                    END;
            END;

            ToPurchLine.LOCKTABLE;

            IF CreateToHeader THEN BEGIN
                INSERT(TRUE);
                ToPurchLine.SETRANGE("Document Type", "Document Type");
                ToPurchLine.SETRANGE("Document No.", "No.");
            END ELSE BEGIN
                ToPurchLine.SETRANGE("Document Type", "Document Type");
                ToPurchLine.SETRANGE("Document No.", "No.");
                IF IncludeHeader THEN
                    IF ToPurchLine.FINDFIRST THEN BEGIN
                        COMMIT;
                        IF NOT
                           CONFIRM(
                             Text002 +
                             Text003, TRUE,
                             "Document Type", "No.")
                        THEN
                            EXIT;
                        ToPurchLine.DELETEALL(TRUE);
                    END;
            END;

            IF ToPurchLine.FINDLAST THEN
                NextLineNo := ToPurchLine."Line No."
            ELSE
                NextLineNo := 0;

            IF IncludeHeader THEN BEGIN
                IF Vend.GET(FromPurchHeader."Buy-from Vendor No.") THEN
                    Vend.CheckBlockedVendOnDocs(Vend, FALSE);
                IF Vend.GET(FromPurchHeader."Pay-to Vendor No.") THEN
                    Vend.CheckBlockedVendOnDocs(Vend, FALSE);
                OldPurchHeader := ToPurchHeader;
                CASE FromDocType OF
                    PurchDocType::Quote,
                    PurchDocType::"Blanket Order",
                    PurchDocType::Order,
                    PurchDocType::Invoice,
                    PurchDocType::"Return Order",
                    PurchDocType::"Credit Memo":
                        BEGIN
                            TRANSFERFIELDS(FromPurchHeader, FALSE);
                            "Last Receiving No." := '';
                            Status := Status::Open;
                            IF "Document Type" <> "Document Type"::Order THEN
                                "Prepayment %" := 0;
                            IF FromDocType IN [PurchDocType::Quote, PurchDocType::"Blanket Order"] THEN
                                IF OldPurchHeader."Posting Date" = 0D THEN
                                    "Posting Date" := WORKDATE
                                ELSE
                                    "Posting Date" := OldPurchHeader."Posting Date";
                        END;
                    PurchDocType::"Posted Receipt":
                        BEGIN
                            VALIDATE("Buy-from Vendor No.", FromPurchRcptHeader."Buy-from Vendor No.");
                            TRANSFERFIELDS(FromPurchRcptHeader, FALSE);
                        END;
                    PurchDocType::"Posted Invoice":
                        BEGIN
                            VALIDATE("Buy-from Vendor No.", FromPurchInvHeader."Buy-from Vendor No.");
                            TRANSFERFIELDS(FromPurchInvHeader, FALSE);
                        END;
                    PurchDocType::"Posted Return Shipment":
                        BEGIN
                            VALIDATE("Buy-from Vendor No.", FromReturnShptHeader."Buy-from Vendor No.");
                            TRANSFERFIELDS(FromReturnShptHeader, FALSE);
                        END;
                    PurchDocType::"Posted Credit Memo":
                        BEGIN
                            VALIDATE("Buy-from Vendor No.", FromPurchCrMemoHeader."Buy-from Vendor No.");
                            TRANSFERFIELDS(FromPurchCrMemoHeader, FALSE);
                        END;
                END;
                Invoice := FALSE;
                Receive := FALSE;
                IF Status = Status::Released THEN BEGIN
                    Status := Status::Open;
                    ReleaseDocument := TRUE;
                END;
                IF MoveNegLines OR IncludeHeader THEN
                    VALIDATE("Location Code");
                IF MoveNegLines THEN
                    VALIDATE("Order Address Code");

                CopyFieldsFromOldPurchHeader(ToPurchHeader, OldPurchHeader);
                IF RecalculateLines THEN
                    CreateDim(
                      DATABASE::Vendor, "Pay-to Vendor No.",
                      DATABASE::"Salesperson/Purchaser", "Purchaser Code",
                      DATABASE::Campaign, "Campaign No.",
                      DATABASE::"Responsibility Center", "Responsibility Center");
                "No. Printed" := 0;
                "Applies-to Doc. Type" := "Applies-to Doc. Type"::" ";
                "Applies-to Doc. No." := '';
                "Applies-to ID" := '';
                "Quote No." := '';
                IF ((FromDocType = PurchDocType::"Posted Invoice") AND
                    ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"])) OR
                   ((FromDocType = PurchDocType::"Posted Credit Memo") AND
                    NOT ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]))
                THEN BEGIN
                    VendLedgEntry.SETCURRENTKEY("Document No.");
                    IF FromDocType = PurchDocType::"Posted Invoice" THEN
                        VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::Invoice)
                    ELSE
                        VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::"Credit Memo");
                    VendLedgEntry.SETRANGE("Document No.", FromDocNo);
                    VendLedgEntry.SETRANGE("Vendor No.", "Pay-to Vendor No.");
                    VendLedgEntry.SETRANGE(Open, TRUE);
                    IF VendLedgEntry.FINDFIRST THEN BEGIN
                        IF FromDocType = PurchDocType::"Posted Invoice" THEN BEGIN
                            "Applies-to Doc. Type" := "Applies-to Doc. Type"::Invoice;
                            "Applies-to Doc. No." := FromDocNo;
                        END ELSE BEGIN
                            "Applies-to Doc. Type" := "Applies-to Doc. Type"::"Credit Memo";
                            "Applies-to Doc. No." := FromDocNo;
                        END;
                        VendLedgEntry.CALCFIELDS("Remaining Amount");
                        VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                        VendLedgEntry."Accepted Payment Tolerance" := 0;
                        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
                        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                    END;
                END;

                IF "Document Type" IN ["Document Type"::"Blanket Order", "Document Type"::Quote] THEN
                    "Posting Date" := 0D;

                Correction := FALSE;
                IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN BEGIN
                    "Expected Receipt Date" := 0D;
                    GLSetup.GET;
                    Correction := GLSetup."Mark Cr. Memos as Corrections";
                    IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN
                        PaymentTerms.GET("Payment Terms Code")
                    ELSE
                        CLEAR(PaymentTerms);
                    IF NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                        "Payment Terms Code" := '';
                        "Payment Discount %" := 0;
                        "Pmt. Discount Date" := 0D;
                    END;
                END;

                IF CreateToHeader THEN BEGIN
                    VALIDATE("Payment Terms Code");
                    MODIFY(TRUE);
                END ELSE
                    MODIFY;
            END;

            LinesNotCopied := 0;
            CASE FromDocType OF
                PurchDocType::Quote,
                PurchDocType::"Blanket Order",
                PurchDocType::Order,
                PurchDocType::Invoice,
                PurchDocType::"Return Order",
                PurchDocType::"Credit Memo":
                    BEGIN
                        ItemChargeAssgntNextLineNo := 0;
                        FromPurchLine.RESET;
                        FromPurchLine.SETRANGE("Document Type", FromPurchHeader."Document Type");
                        FromPurchLine.SETRANGE("Document No.", FromPurchHeader."No.");
                        IF MoveNegLines THEN
                            FromPurchLine.SETFILTER(Quantity, '<=0');
                        IF FromPurchLine.FIND('-') THEN
                            REPEAT
                                IF CopyPurchLine(
                                     ToPurchHeader, ToPurchLine, FromPurchHeader, FromPurchLine,
                                     NextLineNo, LinesNotCopied, FALSE)
                                THEN BEGIN
                                    IF FromPurchLine.Type = FromPurchLine.Type::"Charge (Item)" THEN
                                        CopyFromPurchDocAssgntToLine(ToPurchLine, FromPurchLine, ItemChargeAssgntNextLineNo);
                                END;
                            UNTIL FromPurchLine.NEXT = 0;
                    END;
                PurchDocType::"Posted Receipt":
                    BEGIN
                        FromPurchHeader.TRANSFERFIELDS(FromPurchRcptHeader);
                        FromPurchRcptLine.RESET;
                        FromPurchRcptLine.SETRANGE("Document No.", FromPurchRcptHeader."No.");
                        IF MoveNegLines THEN
                            FromPurchRcptLine.SETFILTER(Quantity, '<=0');
                        CopyPurchRcptLinesToDoc(ToPurchHeader, FromPurchRcptLine, LinesNotCopied, MissingExCostRevLink);
                    END;
                PurchDocType::"Posted Invoice":
                    BEGIN
                        FromPurchHeader.TRANSFERFIELDS(FromPurchInvHeader);
                        FromPurchInvLine.RESET;
                        FromPurchInvLine.SETRANGE("Document No.", FromPurchInvHeader."No.");
                        IF MoveNegLines THEN
                            FromPurchInvLine.SETFILTER(Quantity, '<=0');
                        CopyPurchInvLinesToDoc(ToPurchHeader, FromPurchInvLine, LinesNotCopied, MissingExCostRevLink);
                    END;
                PurchDocType::"Posted Return Shipment":
                    BEGIN
                        FromPurchHeader.TRANSFERFIELDS(FromReturnShptHeader);
                        FromReturnShptLine.RESET;
                        FromReturnShptLine.SETRANGE("Document No.", FromReturnShptHeader."No.");
                        IF MoveNegLines THEN
                            FromReturnShptLine.SETFILTER(Quantity, '<=0');
                        CopyPurchReturnShptLinesToDoc(ToPurchHeader, FromReturnShptLine, LinesNotCopied, MissingExCostRevLink);
                    END;
                PurchDocType::"Posted Credit Memo":
                    BEGIN
                        FromPurchHeader.TRANSFERFIELDS(FromPurchCrMemoHeader);
                        FromPurchCrMemoLine.RESET;
                        FromPurchCrMemoLine.SETRANGE("Document No.", FromPurchCrMemoHeader."No.");
                        IF MoveNegLines THEN
                            FromPurchCrMemoLine.SETFILTER(Quantity, '<=0');
                        CopyPurchCrMemoLinesToDoc(ToPurchHeader, FromPurchCrMemoLine, LinesNotCopied, MissingExCostRevLink);
                    END;
            END;
        END;

        IF MoveNegLines THEN
            DeletePurchLinesWithNegQty(FromPurchHeader, FALSE);

        IF ReleaseDocument THEN BEGIN
            ToPurchHeader.Status := ToPurchHeader.Status::Released;
            ReleasePurchaseDocument.Reopen(ToPurchHeader);
        END ELSE
            IF (FromDocType IN
                [PurchDocType::Quote,
                 PurchDocType::"Blanket Order",
                 PurchDocType::Order,
                 PurchDocType::Invoice,
                 PurchDocType::"Return Order",
                 PurchDocType::"Credit Memo"])
               AND NOT IncludeHeader AND NOT RecalculateLines
            THEN
                IF FromPurchHeader.Status = FromPurchHeader.Status::Released THEN BEGIN
                    ReleasePurchaseDocument.RUN(ToPurchHeader);
                    ReleasePurchaseDocument.Reopen(ToPurchHeader);
                END;

        CASE TRUE OF
            MissingExCostRevLink AND (LinesNotCopied <> 0):
                MESSAGE(Text019 + Text020 + Text004);
            MissingExCostRevLink:
                MESSAGE(Text019);
            LinesNotCopied <> 0:
                MESSAGE(Text004);
        END;
    end;

    procedure ShowSalesDoc(ToSalesHeader: Record "Insure Header");
    begin
        /*WITH ToSalesHeader DO
          CASE "Document Type" OF
            "Document Type"::Order:
              PAGE.RUN(PAGE::"Sales Order",ToSalesHeader);
            "Document Type"::Invoice:
              PAGE.RUN(PAGE::"Sales Invoice",ToSalesHeader);
            "Document Type"::"Return Order":
              PAGE.RUN(PAGE::"Sales Return Order",ToSalesHeader);
            "Document Type"::"Credit Memo":
              PAGE.RUN(PAGE::"Sales Credit Memo",ToSalesHeader);
          END;
          */

    end;

    procedure ShowPurchDoc(ToPurchHeader: Record "Purchase Header");
    begin
        WITH ToPurchHeader DO
            CASE "Document Type" OF
                "Document Type"::Order:
                    PAGE.RUN(PAGE::"Purchase Order", ToPurchHeader);
                "Document Type"::Invoice:
                    PAGE.RUN(PAGE::"Purchase Invoice", ToPurchHeader);
                "Document Type"::"Return Order":
                    PAGE.RUN(PAGE::"Purchase Return Order", ToPurchHeader);
                "Document Type"::"Credit Memo":
                    PAGE.RUN(PAGE::"Purchase Credit Memo", ToPurchHeader);
            END;
    end;

    procedure CopyFromSalesToPurchDoc(VendorNo: Code[20]; FromSalesHeader: Record "Sales Header"; var ToPurchHeader: Record "Purchase Header");
    var
        FromSalesLine: Record "Sales Line";
        ToPurchLine: Record "Purchase Line";
        NextLineNo: Integer;
    begin
        IF VendorNo = '' THEN
            ERROR(Text011);

        WITH ToPurchLine DO BEGIN
            LOCKTABLE;
            ToPurchHeader.INSERT(TRUE);
            ToPurchHeader.VALIDATE("Buy-from Vendor No.", VendorNo);
            ToPurchHeader.MODIFY(TRUE);
            FromSalesLine.SETRANGE("Document Type", FromSalesHeader."Document Type");
            FromSalesLine.SETRANGE("Document No.", FromSalesHeader."No.");
            IF NOT FromSalesLine.FIND('-') THEN
                ERROR(Text012);
            REPEAT
                NextLineNo := NextLineNo + 10000;
                CLEAR(ToPurchLine);
                INIT;
                "Document Type" := ToPurchHeader."Document Type";
                "Document No." := ToPurchHeader."No.";
                "Line No." := NextLineNo;
                IF FromSalesLine.Type = FromSalesLine.Type::" " THEN
                    Description := FromSalesLine.Description
                ELSE BEGIN
                    TransfldsFromSalesToPurchLine(FromSalesLine, ToPurchLine);
                    IF (Type = Type::Item) AND (Quantity <> 0) THEN
                        CopyItemTrackingEntries(
                          FromSalesLine, ToPurchLine, FromSalesHeader."Prices Including VAT",
                          ToPurchHeader."Prices Including VAT");
                END;
                INSERT(TRUE);
            UNTIL FromSalesLine.NEXT = 0;
        END;
    end;

    procedure TransfldsFromSalesToPurchLine(var FromSalesLine: Record "Sales Line"; var ToPurchLine: Record "Purchase Line");
    begin
        WITH ToPurchLine DO BEGIN
            VALIDATE(Type, FromSalesLine.Type);
            VALIDATE("No.", FromSalesLine."No.");
            VALIDATE("Variant Code", FromSalesLine."Variant Code");
            VALIDATE("Location Code", FromSalesLine."Location Code");
            VALIDATE("Unit of Measure Code", FromSalesLine."Unit of Measure Code");
            IF (Type = Type::Item) AND ("No." <> '') THEN
                UpdateUOMQtyPerStockQty;
            "Expected Receipt Date" := FromSalesLine."Shipment Date";
            "Bin Code" := FromSalesLine."Bin Code";
            IF (FromSalesLine."Document Type" = FromSalesLine."Document Type"::"Return Order") AND
               ("Document Type" = "Document Type"::"Return Order")
            THEN
                VALIDATE(Quantity, FromSalesLine.Quantity)
            ELSE
                VALIDATE(Quantity, FromSalesLine."Outstanding Quantity");
            VALIDATE("Return Reason Code", FromSalesLine."Return Reason Code");
            VALIDATE("Direct Unit Cost");
            Description := FromSalesLine.Description;
            "Description 2" := FromSalesLine."Description 2";
        END;
    end;

    local procedure DeleteSalesLinesWithNegQty(FromSalesHeader: Record "Insure Header"; OnlyTest: Boolean);
    var
        FromSalesLine: Record "Insure Lines";
    begin
        /*WITH FromSalesLine DO BEGIN
          SETRANGE("Document Type",FromSalesHeader."Document Type");
          SETRANGE("Document No.",FromSalesHeader."No.");
          SETFILTER(Quantity,'<0');
          IF OnlyTest THEN BEGIN
            IF NOT FIND('-') THEN
              ERROR(Text008);
            REPEAT
              TESTFIELD("Shipment No.",'');
              TESTFIELD("Return Receipt No.",'');
              TESTFIELD("Quantity Shipped",0);
              TESTFIELD("Quantity Invoiced",0);
            UNTIL NEXT = 0;
          END ELSE
            DELETEALL(TRUE);
        END;
        */

    end;

    local procedure DeletePurchLinesWithNegQty(FromPurchHeader: Record "Purchase Header"; OnlyTest: Boolean);
    var
        FromPurchLine: Record "Purchase Line";
    begin
        WITH FromPurchLine DO BEGIN
            SETRANGE("Document Type", FromPurchHeader."Document Type");
            SETRANGE("Document No.", FromPurchHeader."No.");
            SETFILTER(Quantity, '<0');
            IF OnlyTest THEN BEGIN
                IF NOT FIND('-') THEN
                    ERROR(Text010);
                REPEAT
                    TESTFIELD("Receipt No.", '');
                    TESTFIELD("Return Shipment No.", '');
                    TESTFIELD("Quantity Received", 0);
                    TESTFIELD("Quantity Invoiced", 0);
                UNTIL NEXT = 0;
            END ELSE
                DELETEALL(TRUE);
        END;
    end;

    local procedure CopySalesLine(var ToSalesHeader: Record "Insure Header"; var ToSalesLine: Record "Insure Lines"; var FromSalesHeader: Record "Insure Header"; var FromSalesLine: Record "Insure Lines"; var NextLineNo: Integer; var LinesNotCopied: Integer; RecalculateAmount: Boolean): Boolean;
    var
        ToSalesLine2: Record "Insure Lines";
        Cust: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        CustPostingGroup: Record "Customer Posting Group";
        RoundingLineInserted: Boolean;
        CopyThisLine: Boolean;
        InvDiscountAmount: Decimal;
    begin
        /*CopyThisLine := TRUE;
        SalesSetup.GET;
        IF SalesSetup."Invoice Rounding" AND Cust.GET(FromSalesHeader."Bill-to Customer No.") THEN BEGIN
          CustPostingGroup.GET(Cust."Customer Posting Group");
          CustPostingGroup.TESTFIELD("Invoice Rounding Account");
          RoundingLineInserted := FromSalesLine."No." = CustPostingGroup."Invoice Rounding Account";
        END;
        IF ((ToSalesHeader."Language Code" <> FromSalesHeader."Language Code") OR RecalculateLines) AND
           (FromSalesLine."Attached to Line No." <> 0) OR
           FromSalesLine."Prepayment Line" OR RoundingLineInserted
        THEN
          EXIT(FALSE);
        ToSalesLine.SetSalesHeader(ToSalesHeader);
        IF RecalculateLines AND NOT FromSalesLine."System-Created Entry" THEN
          ToSalesLine.INIT
        ELSE
          ToSalesLine := FromSalesLine;
        NextLineNo := NextLineNo + 10000;
        ToSalesLine."Document Type" := ToSalesHeader."Document Type";
        ToSalesLine."Document No." := ToSalesHeader."No.";
        ToSalesLine."Line No." := NextLineNo;
        IF (ToSalesLine.Type <> ToSalesLine.Type::" ") AND
           (ToSalesLine."Document Type" IN [ToSalesLine."Document Type"::"Return Order",ToSalesLine."Document Type"::"Credit Memo"])
        THEN BEGIN
          InvDiscountAmount := ToSalesLine."Inv. Discount Amount";
          ToSalesLine."Job Contract Entry No." := 0;
          ToSalesLine.VALIDATE("Line Discount %");
          ToSalesLine.VALIDATE("Inv. Discount Amount",InvDiscountAmount);
        END;
        ToSalesLine.VALIDATE("Currency Code",FromSalesHeader."Currency Code");
        
        UpdateSalesLine(ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLine,CopyThisLine,RecalculateAmount);
        
        IF ExactCostRevMandatory AND
           (FromSalesLine.Type = FromSalesLine.Type::Item) AND
           (FromSalesLine."Appl.-from Item Entry" <> 0) AND
           NOT MoveNegLines
        THEN BEGIN
          IF RecalculateAmount THEN BEGIN
            ToSalesLine.VALIDATE("Unit Price",FromSalesLine."Unit Price");
            ToSalesLine.VALIDATE("Line Discount %",FromSalesLine."Line Discount %");
            ToSalesLine.VALIDATE(
              "Line Discount Amount",
              ROUND(FromSalesLine."Line Discount Amount",Currency."Amount Rounding Precision"));
            ToSalesLine.VALIDATE(
              "Inv. Discount Amount",
              ROUND(FromSalesLine."Inv. Discount Amount",Currency."Amount Rounding Precision"));
          END;
          ToSalesLine.VALIDATE("Appl.-from Item Entry",FromSalesLine."Appl.-from Item Entry");
          IF NOT CreateToHeader THEN
            IF ToSalesLine."Shipment Date" = 0D THEN BEGIN
              IF ToSalesHeader."Shipment Date" <> 0D THEN
                ToSalesLine."Shipment Date" := ToSalesHeader."Shipment Date"
              ELSE
                ToSalesLine."Shipment Date" := WORKDATE;
            END;
        END;
        
        IF MoveNegLines AND (ToSalesLine.Type <> ToSalesLine.Type::" ") THEN BEGIN
          ToSalesLine.VALIDATE(Quantity,-FromSalesLine.Quantity);
          ToSalesLine."Appl.-to Item Entry" := FromSalesLine."Appl.-to Item Entry";
          ToSalesLine."Appl.-from Item Entry" := FromSalesLine."Appl.-from Item Entry";
          ToSalesLine."Job No." := FromSalesLine."Job No.";
          ToSalesLine."Job Task No." := FromSalesLine."Job Task No.";
          ToSalesLine."Job Contract Entry No." := FromSalesLine."Job Contract Entry No.";
        END;
        
        IF (ToSalesHeader."Language Code" <> FromSalesHeader."Language Code") OR RecalculateLines THEN BEGIN
          IF TransferExtendedText.SalesCheckIfAnyExtText(ToSalesLine,FALSE) THEN BEGIN
            TransferExtendedText.InsertSalesExtText(ToSalesLine);
            ToSalesLine2.SETRANGE("Document Type",ToSalesLine."Document Type");
            ToSalesLine2.SETRANGE("Document No.",ToSalesLine."Document No.");
            ToSalesLine2.FINDLAST;
            NextLineNo := ToSalesLine2."Line No.";
          END;
        END ELSE
          ToSalesLine."Attached to Line No." :=
            TransferOldExtLines.TransferExtendedText(FromSalesLine."Line No.",NextLineNo,FromSalesLine."Attached to Line No.");
        
        ToSalesLine."Shortcut Dimension 1 Code" := FromSalesLine."Shortcut Dimension 1 Code";
        ToSalesLine."Shortcut Dimension 2 Code" := FromSalesLine."Shortcut Dimension 2 Code";
        ToSalesLine."Dimension Set ID" := FromSalesLine."Dimension Set ID";
        
        IF CopyThisLine THEN BEGIN
          ToSalesLine.INSERT;
          HandleAsmAttachedToSalesLine(ToSalesLine);
          IF ToSalesLine.Reserve = ToSalesLine.Reserve::Always THEN
            ToSalesLine.AutoReserve;
        END ELSE
          LinesNotCopied := LinesNotCopied + 1;
        EXIT(TRUE);
        */

    end;

    local procedure UpdateSalesLine(var ToSalesHeader: Record "Insure Header"; var ToSalesLine: Record "Insure Lines"; var FromSalesHeader: Record "Insure Header"; var FromSalesLine: Record "Insure Lines"; var CopyThisLine: Boolean; RecalculateAmount: Boolean);
    var
        GLAcc: Record "G/L Account";
    begin
        /*IF RecalculateLines AND NOT FromSalesLine."System-Created Entry" THEN BEGIN
          ToSalesLine.VALIDATE(Type,FromSalesLine.Type);
          ToSalesLine.VALIDATE(Description,FromSalesLine.Description);
          ToSalesLine.VALIDATE("Description 2",FromSalesLine."Description 2");
          IF (FromSalesLine.Type <> 0) AND (FromSalesLine."No." <> '') THEN BEGIN
            IF ToSalesLine.Type = ToSalesLine.Type::"G/L Account" THEN BEGIN
              ToSalesLine."No." := FromSalesLine."No.";
              IF GLAcc."No." <> FromSalesLine."No." THEN
                GLAcc.GET(FromSalesLine."No.");
              CopyThisLine := GLAcc."Direct Posting";
              IF CopyThisLine THEN
                ToSalesLine.VALIDATE("No.",FromSalesLine."No.");
            END ELSE
              ToSalesLine.VALIDATE("No.",FromSalesLine."No.");
            ToSalesLine.VALIDATE("Variant Code",FromSalesLine."Variant Code");
            ToSalesLine.VALIDATE("Location Code",FromSalesLine."Location Code");
            ToSalesLine.VALIDATE("Unit of Measure",FromSalesLine."Unit of Measure");
            ToSalesLine.VALIDATE("Unit of Measure Code",FromSalesLine."Unit of Measure Code");
            ToSalesLine.VALIDATE(Quantity,FromSalesLine.Quantity);
            IF NOT (FromSalesLine.Type IN [FromSalesLine.Type::Item,FromSalesLine.Type::Resource]) THEN BEGIN
              IF (FromSalesHeader."Currency Code" <> ToSalesHeader."Currency Code") OR
                 (FromSalesHeader."Prices Including VAT" <> ToSalesHeader."Prices Including VAT")
              THEN BEGIN
                ToSalesLine."Unit Price" := 0;
                ToSalesLine."Line Discount %" := 0;
              END ELSE BEGIN
                ToSalesLine.VALIDATE("Unit Price",FromSalesLine."Unit Price");
                ToSalesLine.VALIDATE("Line Discount %",FromSalesLine."Line Discount %");
              END;
              IF ToSalesLine.Quantity <> 0 THEN
                ToSalesLine.VALIDATE("Line Discount Amount",FromSalesLine."Line Discount Amount");
            END;
            ToSalesLine.VALIDATE("Work Type Code",FromSalesLine."Work Type Code");
            IF (ToSalesLine."Document Type" = ToSalesLine."Document Type"::Order) AND
               (FromSalesLine."Purchasing Code" <> '')
            THEN
              ToSalesLine.VALIDATE("Purchasing Code",FromSalesLine."Purchasing Code");
          END;
          IF (FromSalesLine.Type = FromSalesLine.Type::" ") AND (FromSalesLine."No." <> '') THEN
            ToSalesLine.VALIDATE("No.",FromSalesLine."No.");
        END ELSE BEGIN
          SetDefaultValuesToSalesLine(ToSalesLine,ToSalesHeader,FromSalesLine."VAT Difference");
          IF ToSalesLine."Document Type" <> ToSalesLine."Document Type"::Order THEN BEGIN
            ToSalesLine."Drop Shipment" := FALSE;
            ToSalesLine."Special Order" := FALSE;
          END;
          IF RecalculateAmount AND (FromSalesLine."Appl.-from Item Entry" = 0) THEN BEGIN
            IF (ToSalesLine.Type <> ToSalesLine.Type::" ") AND (ToSalesLine."No." <> '') THEN BEGIN
              ToSalesLine.VALIDATE("Line Discount %",FromSalesLine."Line Discount %");
              ToSalesLine.VALIDATE(
                "Inv. Discount Amount",ROUND(FromSalesLine."Inv. Discount Amount",Currency."Amount Rounding Precision"));
            END;
            ToSalesLine.VALIDATE("Unit Cost (LCY)",FromSalesLine."Unit Cost (LCY)");
          END;
        
          ToSalesLine.UpdateWithWarehouseShip;
          IF (ToSalesLine.Type = ToSalesLine.Type::Item) AND (ToSalesLine."No." <> '') THEN BEGIN
            GetItem(ToSalesLine."No.");
            IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT ToSalesLine.IsShipment THEN
              ToSalesLine.GetUnitCost;
        
            IF Item.Reserve = Item.Reserve::Optional THEN
              ToSalesLine.Reserve := ToSalesHeader.Reserve
            ELSE
              ToSalesLine.Reserve := Item.Reserve;
            IF ToSalesLine.Reserve = ToSalesLine.Reserve::Always THEN
              IF ToSalesHeader."Shipment Date" <> 0D THEN
                ToSalesLine."Shipment Date" := ToSalesHeader."Shipment Date"
              ELSE
                ToSalesLine."Shipment Date" := WORKDATE;
          END;
        END;
        */

    end;

    local procedure HandleAsmAttachedToSalesLine(var ToSalesLine: Record "Sales Line");
    var
        Item: Record Item;
    begin
        WITH ToSalesLine DO BEGIN
            IF Type <> Type::Item THEN
                EXIT;
            IF NOT ("Document Type" IN ["Document Type"::Quote, "Document Type"::Order, "Document Type"::"Blanket Order"]) THEN
                EXIT;
        END;
        IF AsmHdrExistsForFromDocLine THEN BEGIN
            ToSalesLine."Qty. to Assemble to Order" := QtyToAsmToOrder;
            ToSalesLine."Qty. to Asm. to Order (Base)" := QtyToAsmToOrderBase;
            ToSalesLine.MODIFY;
            CopyAsmOrderToAsmOrder(TempAsmHeader, TempAsmLine, ToSalesLine, GetAsmOrderType(ToSalesLine."Document Type"), '', TRUE);
        END ELSE BEGIN
            Item.GET(ToSalesLine."No.");
            IF (Item."Assembly Policy" = Item."Assembly Policy"::"Assemble-to-Order") AND
               (Item."Replenishment System" = Item."Replenishment System"::Assembly)
            THEN BEGIN
                ToSalesLine.VALIDATE("Qty. to Assemble to Order", ToSalesLine.Quantity);
                ToSalesLine.MODIFY;
            END;
        END;
    end;

    local procedure CopyPurchLine(var ToPurchHeader: Record "Purchase Header"; var ToPurchLine: Record "Purchase Line"; var FromPurchHeader: Record "Purchase Header"; var FromPurchLine: Record "Purchase Line"; var NextLineNo: Integer; var LinesNotCopied: Integer; RecalculateAmount: Boolean): Boolean;
    var
        ToPurchLine2: Record "Purchase Line";
        RoundingLineInserted: Boolean;
        CopyThisLine: Boolean;
        InvDiscountAmount: Decimal;
    begin
        CopyThisLine := TRUE;

        CheckRounding(FromPurchHeader, FromPurchLine, RoundingLineInserted);

        IF ((ToPurchHeader."Language Code" <> FromPurchHeader."Language Code") OR RecalculateLines) AND
           (FromPurchLine."Attached to Line No." <> 0) OR
           FromPurchLine."Prepayment Line" OR RoundingLineInserted
        THEN
            EXIT(FALSE);

        IF RecalculateLines AND NOT FromPurchLine."System-Created Entry" THEN
            ToPurchLine.INIT
        ELSE
            ToPurchLine := FromPurchLine;
        NextLineNo := NextLineNo + 10000;
        ToPurchLine."Document Type" := ToPurchHeader."Document Type";
        ToPurchLine."Document No." := ToPurchHeader."No.";
        ToPurchLine."Line No." := NextLineNo;
        ToPurchLine.VALIDATE("Currency Code", FromPurchHeader."Currency Code");
        IF ToPurchLine.Type <> ToPurchLine.Type::" " THEN BEGIN
            InvDiscountAmount := ToPurchLine."Inv. Discount Amount";
            ToPurchLine.VALIDATE("Line Discount %");
            ToPurchLine.VALIDATE("Inv. Discount Amount", InvDiscountAmount);
        END;

        UpdatePurchLine(ToPurchHeader, ToPurchLine, FromPurchHeader, FromPurchLine, CopyThisLine, RecalculateAmount);

        IF ExactCostRevMandatory AND
           (FromPurchLine.Type = FromPurchLine.Type::Item) AND
           (FromPurchLine."Appl.-to Item Entry" <> 0) AND
           NOT MoveNegLines
        THEN BEGIN
            IF RecalculateAmount THEN BEGIN
                ToPurchLine.VALIDATE("Direct Unit Cost", FromPurchLine."Direct Unit Cost");
                ToPurchLine.VALIDATE("Line Discount %", FromPurchLine."Line Discount %");
                ToPurchLine.VALIDATE(
                  "Line Discount Amount",
                  ROUND(FromPurchLine."Line Discount Amount", Currency."Amount Rounding Precision"));
                ToPurchLine.VALIDATE(
                  "Inv. Discount Amount",
                  ROUND(FromPurchLine."Inv. Discount Amount", Currency."Amount Rounding Precision"));
            END;
            ToPurchLine.VALIDATE("Appl.-to Item Entry", FromPurchLine."Appl.-to Item Entry");
            IF NOT CreateToHeader THEN
                IF ToPurchLine."Expected Receipt Date" = 0D THEN BEGIN
                    IF ToPurchHeader."Expected Receipt Date" <> 0D THEN
                        ToPurchLine."Expected Receipt Date" := ToPurchHeader."Expected Receipt Date"
                    ELSE
                        ToPurchLine."Expected Receipt Date" := WORKDATE;
                END;
        END;

        IF MoveNegLines AND (ToPurchLine.Type <> ToPurchLine.Type::" ") THEN BEGIN
            ToPurchLine.VALIDATE(Quantity, -FromPurchLine.Quantity);
            ToPurchLine."Appl.-to Item Entry" := FromPurchLine."Appl.-to Item Entry"
        END;

        IF (ToPurchHeader."Language Code" <> FromPurchHeader."Language Code") OR RecalculateLines THEN BEGIN
            IF TransferExtendedText.PurchCheckIfAnyExtText(ToPurchLine, FALSE) THEN BEGIN
                TransferExtendedText.InsertPurchExtText(ToPurchLine);
                ToPurchLine2.SETRANGE("Document Type", ToPurchLine."Document Type");
                ToPurchLine2.SETRANGE("Document No.", ToPurchLine."Document No.");
                ToPurchLine2.FINDLAST;
                NextLineNo := ToPurchLine2."Line No.";
            END;
        END ELSE
            ToPurchLine."Attached to Line No." :=
              TransferOldExtLines.TransferExtendedText(
                FromPurchLine."Line No.",
                NextLineNo,
                FromPurchLine."Attached to Line No.");

        ToPurchLine.VALIDATE("Job No.", FromPurchLine."Job No.");
        ToPurchLine.VALIDATE("Job Task No.", FromPurchLine."Job Task No.");
        ToPurchLine.VALIDATE("Job Line Type", FromPurchLine."Job Line Type");

        ToPurchLine."Shortcut Dimension 1 Code" := FromPurchLine."Shortcut Dimension 1 Code";
        ToPurchLine."Shortcut Dimension 2 Code" := FromPurchLine."Shortcut Dimension 2 Code";
        ToPurchLine."Dimension Set ID" := FromPurchLine."Dimension Set ID";

        IF CopyThisLine THEN
            ToPurchLine.INSERT
        ELSE
            LinesNotCopied := LinesNotCopied + 1;
        EXIT(TRUE);
    end;

    local procedure UpdatePurchLine(var ToPurchHeader: Record "Purchase Header"; var ToPurchLine: Record "Purchase Line"; var FromPurchHeader: Record "Purchase Header"; var FromPurchLine: Record "Purchase Line"; var CopyThisLine: Boolean; RecalculateAmount: Boolean);
    var
        GLAcc: Record "G/L Account";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        IF RecalculateLines AND NOT FromPurchLine."System-Created Entry" THEN BEGIN
            ToPurchLine.VALIDATE(Type, FromPurchLine.Type);
            ToPurchLine.VALIDATE(Description, FromPurchLine.Description);
            ToPurchLine.VALIDATE("Description 2", FromPurchLine."Description 2");
            IF (FromPurchLine.Type <> 0) AND (FromPurchLine."No." <> '') THEN BEGIN
                IF ToPurchLine.Type = ToPurchLine.Type::"G/L Account" THEN BEGIN
                    ToPurchLine."No." := FromPurchLine."No.";
                    IF GLAcc."No." <> FromPurchLine."No." THEN
                        GLAcc.GET(FromPurchLine."No.");
                    CopyThisLine := GLAcc."Direct Posting";
                    IF CopyThisLine THEN
                        ToPurchLine.VALIDATE("No.", FromPurchLine."No.");
                END ELSE
                    ToPurchLine.VALIDATE("No.", FromPurchLine."No.");
                ToPurchLine.VALIDATE("Variant Code", FromPurchLine."Variant Code");
                ToPurchLine.VALIDATE("Location Code", FromPurchLine."Location Code");
                ToPurchLine.VALIDATE("Unit of Measure", FromPurchLine."Unit of Measure");
                ToPurchLine.VALIDATE("Unit of Measure Code", FromPurchLine."Unit of Measure Code");
                ToPurchLine.VALIDATE(Quantity, FromPurchLine.Quantity);
                IF FromPurchLine.Type <> FromPurchLine.Type::Item THEN BEGIN
                    ToPurchHeader.TESTFIELD("Currency Code", FromPurchHeader."Currency Code");
                    ToPurchLine.VALIDATE("Direct Unit Cost", FromPurchLine."Direct Unit Cost");
                    ToPurchLine.VALIDATE("Line Discount %", FromPurchLine."Line Discount %");
                    IF ToPurchLine.Quantity <> 0 THEN
                        ToPurchLine.VALIDATE("Line Discount Amount", FromPurchLine."Line Discount Amount");
                END;
                IF (ToPurchLine."Document Type" = ToPurchLine."Document Type"::Order) AND
                   (FromPurchLine."Purchasing Code" <> '') AND NOT FromPurchLine."Drop Shipment" AND
                   NOT FromPurchLine."Special Order"
                THEN
                    ToPurchLine.VALIDATE("Purchasing Code", FromPurchLine."Purchasing Code");
            END;
            IF (FromPurchLine.Type = FromPurchLine.Type::" ") AND (FromPurchLine."No." <> '') THEN
                ToPurchLine.VALIDATE("No.", FromPurchLine."No.");
        END ELSE BEGIN
            SetDefaultValuesToPurchLine(ToPurchLine, ToPurchHeader, FromPurchLine."VAT Difference");
            IF FromPurchLine."Drop Shipment" OR FromPurchLine."Special Order" THEN
                ToPurchLine."Purchasing Code" := '';
            ToPurchLine."Drop Shipment" := FALSE;
            ToPurchLine."Special Order" := FALSE;
            IF VATPostingSetup.GET(ToPurchLine."VAT Bus. Posting Group", ToPurchLine."VAT Prod. Posting Group") THEN
                ToPurchLine."VAT Identifier" := VATPostingSetup."VAT Identifier";

            CopyDocLines(RecalculateAmount, ToPurchLine, FromPurchLine);

            ToPurchLine.UpdateWithWarehouseReceive;
            ToPurchLine."Pay-to Vendor No." := ToPurchHeader."Pay-to Vendor No.";
        END;
    end;

    procedure CheckRounding(FromPurchHeader: Record "Purchase Header"; FromPurchLine: Record "Purchase Line"; var RoundingLineInserted: Boolean);
    var
        PurchSetup: Record "Purchases & Payables Setup";
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        PurchSetup.GET;
        IF PurchSetup."Invoice Rounding" THEN BEGIN
            Vendor.GET(FromPurchHeader."Pay-to Vendor No.");
            VendorPostingGroup.GET(Vendor."Vendor Posting Group");
            VendorPostingGroup.TESTFIELD("Invoice Rounding Account");
            RoundingLineInserted := FromPurchLine."No." = VendorPostingGroup."Invoice Rounding Account";
        END;
    end;

    local procedure CopyFromSalesDocAssgntToLine(var ToSalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line"; var ItemChargeAssgntNextLineNo: Integer);
    var
        FromItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        ToItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
    begin
        WITH FromSalesLine DO BEGIN
            FromItemChargeAssgntSales.RESET;
            FromItemChargeAssgntSales.SETRANGE("Document Type", "Document Type");
            FromItemChargeAssgntSales.SETRANGE("Document No.", "Document No.");
            FromItemChargeAssgntSales.SETRANGE("Document Line No.", "Line No.");
            FromItemChargeAssgntSales.SETFILTER(
              "Applies-to Doc. Type", '<>%1', "Document Type");
            IF FromItemChargeAssgntSales.FIND('-') THEN
                REPEAT
                    ToItemChargeAssgntSales.COPY(FromItemChargeAssgntSales);
                    ToItemChargeAssgntSales."Document Type" := ToSalesLine."Document Type";
                    ToItemChargeAssgntSales."Document No." := ToSalesLine."Document No.";
                    ToItemChargeAssgntSales."Document Line No." := ToSalesLine."Line No.";
                    AssignItemChargeSales.InsertItemChargeAssgnt(
                      ToItemChargeAssgntSales, ToItemChargeAssgntSales."Applies-to Doc. Type",
                      ToItemChargeAssgntSales."Applies-to Doc. No.", ToItemChargeAssgntSales."Applies-to Doc. Line No.",
                      ToItemChargeAssgntSales."Item No.", ToItemChargeAssgntSales.Description, ItemChargeAssgntNextLineNo);
                UNTIL FromItemChargeAssgntSales.NEXT = 0;
        END;
    end;

    local procedure CopyFromPurchDocAssgntToLine(var ToPurchLine: Record "Purchase Line"; FromPurchLine: Record "Purchase Line"; var ItemChargeAssgntNextLineNo: Integer);
    var
        FromItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        ToItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
    begin
        WITH FromPurchLine DO BEGIN
            FromItemChargeAssgntPurch.RESET;
            FromItemChargeAssgntPurch.SETRANGE("Document Type", "Document Type");
            FromItemChargeAssgntPurch.SETRANGE("Document No.", "Document No.");
            FromItemChargeAssgntPurch.SETRANGE("Document Line No.", "Line No.");
            FromItemChargeAssgntPurch.SETFILTER(
              "Applies-to Doc. Type", '<>%1', "Document Type");
            IF FromItemChargeAssgntPurch.FIND('-') THEN
                REPEAT
                    ToItemChargeAssgntPurch.COPY(FromItemChargeAssgntPurch);
                    ToItemChargeAssgntPurch."Document Type" := ToPurchLine."Document Type";
                    ToItemChargeAssgntPurch."Document No." := ToPurchLine."Document No.";
                    ToItemChargeAssgntPurch."Document Line No." := ToPurchLine."Line No.";
                    AssignItemChargePurch.InsertItemChargeAssgnt(
                      ToItemChargeAssgntPurch, ToItemChargeAssgntPurch."Applies-to Doc. Type",
                      ToItemChargeAssgntPurch."Applies-to Doc. No.", ToItemChargeAssgntPurch."Applies-to Doc. Line No.",
                      ToItemChargeAssgntPurch."Item No.", ToItemChargeAssgntPurch.Description, ItemChargeAssgntNextLineNo);
                UNTIL FromItemChargeAssgntPurch.NEXT = 0;
        END;
    end;

    local procedure WarnSalesInvoicePmtDisc(var ToSalesHeader: Record "Sales Header"; var FromSalesHeader: Record "Sales Header"; FromDocType: Option; FromDocNo: Code[20]);
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        IF HideDialog THEN
            EXIT;

        IF IncludeHeader AND
           (ToSalesHeader."Document Type" IN
            [ToSalesHeader."Document Type"::"Return Order", ToSalesHeader."Document Type"::"Credit Memo"])
        THEN BEGIN
            CustLedgEntry.SETCURRENTKEY("Document No.");
            CustLedgEntry.SETRANGE("Document Type", FromSalesHeader."Document Type"::Invoice);
            CustLedgEntry.SETRANGE("Document No.", FromDocNo);
            IF CustLedgEntry.FINDFIRST THEN BEGIN
                IF (CustLedgEntry."Pmt. Disc. Given (LCY)" <> 0) AND
                   (CustLedgEntry."Journal Batch Name" = '')
                THEN
                    MESSAGE(Text006, SELECTSTR(FromDocType, Text007), FromDocNo);
            END;
        END;

        IF IncludeHeader AND
           (ToSalesHeader."Document Type" IN
            [ToSalesHeader."Document Type"::Invoice, ToSalesHeader."Document Type"::Order,
             ToSalesHeader."Document Type"::Quote, ToSalesHeader."Document Type"::"Blanket Order"]) //AND (FromDocType = FromDocType::"9") SNN
        THEN BEGIN
            CustLedgEntry.SETCURRENTKEY("Document No.");
            CustLedgEntry.SETRANGE("Document Type", FromSalesHeader."Document Type"::"Credit Memo");
            CustLedgEntry.SETRANGE("Document No.", FromDocNo);
            IF CustLedgEntry.FINDFIRST THEN BEGIN
                IF (CustLedgEntry."Pmt. Disc. Given (LCY)" <> 0) AND
                   (CustLedgEntry."Journal Batch Name" = '')
                THEN
                    MESSAGE(Text006, SELECTSTR(FromDocType - 1, Text007), FromDocNo);
            END;
        END;
    end;

    local procedure WarnPurchInvoicePmtDisc(var ToPurchHeader: Record "Purchase Header"; var FromPurchHeader: Record "Purchase Header"; FromDocType: Option; FromDocNo: Code[20]);
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        IF HideDialog THEN
            EXIT;

        IF IncludeHeader AND
           (ToPurchHeader."Document Type" IN
            [ToPurchHeader."Document Type"::"Return Order", ToPurchHeader."Document Type"::"Credit Memo"])
        THEN BEGIN
            VendLedgEntry.SETCURRENTKEY("Document No.");
            VendLedgEntry.SETRANGE("Document Type", FromPurchHeader."Document Type"::Invoice);
            VendLedgEntry.SETRANGE("Document No.", FromDocNo);
            IF VendLedgEntry.FINDFIRST THEN BEGIN
                IF (VendLedgEntry."Pmt. Disc. Rcd.(LCY)" <> 0) AND
                   (VendLedgEntry."Journal Batch Name" = '')
                THEN
                    MESSAGE(Text009, SELECTSTR(FromDocType, Text007), FromDocNo);
            END;
        END;

        IF IncludeHeader AND
           (ToPurchHeader."Document Type" IN
            [ToPurchHeader."Document Type"::Invoice, ToPurchHeader."Document Type"::Order,
             ToPurchHeader."Document Type"::Quote, ToPurchHeader."Document Type"::"Blanket Order"]) //AND (FromDocType = FromDocType::"9") SNN
        THEN BEGIN
            VendLedgEntry.SETCURRENTKEY("Document No.");
            VendLedgEntry.SETRANGE("Document Type", FromPurchHeader."Document Type"::"Credit Memo");
            VendLedgEntry.SETRANGE("Document No.", FromDocNo);
            IF VendLedgEntry.FINDFIRST THEN BEGIN
                IF (VendLedgEntry."Pmt. Disc. Rcd.(LCY)" <> 0) AND
                   (VendLedgEntry."Journal Batch Name" = '')
                THEN
                    MESSAGE(Text006, SELECTSTR(FromDocType - 1, Text007), FromDocNo);
            END;
        END;
    end;

    local procedure CheckCopyFromSalesHeaderAvail(FromSalesHeader: Record "Insure Debit Note"; ToSalesHeader: Record "Insure Header");
    var
        FromSalesLine: Record "Insure Lines";
        ToSalesLine: Record "Insure Lines";
    begin
        /*WITH ToSalesHeader DO
          IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
            FromSalesLine.SETRANGE("Document Type",FromSalesHeader."Document Type");
            FromSalesLine.SETRANGE("Document No.",FromSalesHeader."No.");
            FromSalesLine.SETRANGE(Type,FromSalesLine.Type::Item);
            FromSalesLine.SETFILTER("No.",'<>%1','');
            IF FromSalesLine.FIND('-') THEN
              REPEAT
                IF FromSalesLine.Quantity > 0 THEN BEGIN
                  ToSalesLine."No." := FromSalesLine."No.";
                  ToSalesLine."Variant Code" := FromSalesLine."Variant Code";
                  ToSalesLine."Location Code" := FromSalesLine."Location Code";
                  ToSalesLine."Bin Code" := FromSalesLine."Bin Code";
                  ToSalesLine."Unit of Measure Code" := FromSalesLine."Unit of Measure Code";
                  ToSalesLine."Qty. per Unit of Measure" := FromSalesLine."Qty. per Unit of Measure";
                  ToSalesLine."Outstanding Quantity" := FromSalesLine.Quantity;
                  IF "Document Type" = "Document Type"::Order THEN
                    ToSalesLine."Outstanding Quantity" := FromSalesLine.Quantity - FromSalesLine."Qty. to Assemble to Order";
                  ToSalesLine."Qty. to Assemble to Order" := 0;
                  ToSalesLine."Drop Shipment" := FromSalesLine."Drop Shipment";
                  CheckItemAvailable(ToSalesHeader,ToSalesLine);
        
                  IF "Document Type" = "Document Type"::Order THEN BEGIN
                    ToSalesLine."Outstanding Quantity" := FromSalesLine.Quantity;
                    ToSalesLine."Qty. to Assemble to Order" := FromSalesLine."Qty. to Assemble to Order";
                    CheckATOItemAvailable(FromSalesLine,ToSalesLine);
                  END;
                END;
              UNTIL FromSalesLine.NEXT = 0;
          END;
        */

    end;

    local procedure CheckCopyFromSalesShptAvail(FromSalesShptHeader: Record "Sales Shipment Header"; ToSalesHeader: Record "Sales Header");
    var
        FromSalesShptLine: Record "Sales Shipment Line";
        ToSalesLine: Record "Sales Line";
        FromPostedAsmHeader: Record "Posted Assembly Header";
    begin
        IF NOT (ToSalesHeader."Document Type" IN [ToSalesHeader."Document Type"::Order, ToSalesHeader."Document Type"::Invoice]) THEN
            EXIT;

        WITH ToSalesLine DO BEGIN
            FromSalesShptLine.SETRANGE("Document No.", FromSalesShptHeader."No.");
            FromSalesShptLine.SETRANGE(Type, FromSalesShptLine.Type::Item);
            FromSalesShptLine.SETFILTER("No.", '<>%1', '');
            IF FromSalesShptLine.FIND('-') THEN
                REPEAT
                    IF FromSalesShptLine.Quantity > 0 THEN BEGIN
                        "No." := FromSalesShptLine."No.";
                        "Variant Code" := FromSalesShptLine."Variant Code";
                        "Location Code" := FromSalesShptLine."Location Code";
                        "Bin Code" := FromSalesShptLine."Bin Code";
                        "Unit of Measure Code" := FromSalesShptLine."Unit of Measure Code";
                        "Qty. per Unit of Measure" := FromSalesShptLine."Qty. per Unit of Measure";
                        "Outstanding Quantity" := FromSalesShptLine.Quantity;

                        IF "Document Type" = "Document Type"::Order THEN
                            IF FromSalesShptLine.AsmToShipmentExists(FromPostedAsmHeader) THEN
                                "Outstanding Quantity" := FromSalesShptLine.Quantity - FromPostedAsmHeader.Quantity;
                        "Qty. to Assemble to Order" := 0;
                        "Drop Shipment" := FromSalesShptLine."Drop Shipment";
                        //CheckItemAvailable(ToSalesHeader, ToSalesLine); SNN

                        IF "Document Type" = "Document Type"::Order THEN
                            IF FromSalesShptLine.AsmToShipmentExists(FromPostedAsmHeader) THEN BEGIN
                                "Qty. to Assemble to Order" := FromPostedAsmHeader.Quantity;
                                CheckPostedATOItemAvailable(FromSalesShptLine, ToSalesLine);
                            END;
                    END;
                UNTIL FromSalesShptLine.NEXT = 0;
        END;
    end;

    local procedure CheckCopyFromSalesInvoiceAvail(FromSalesInvHeader: Record "Sales Invoice Header"; ToSalesHeader: Record "Sales Header");
    var
        FromSalesInvLine: Record "Sales Invoice Line";
        ToSalesLine: Record "Sales Line";
    begin
        IF NOT (ToSalesHeader."Document Type" IN [ToSalesHeader."Document Type"::Order, ToSalesHeader."Document Type"::Invoice]) THEN
            EXIT;

        WITH ToSalesLine DO BEGIN
            FromSalesInvLine.SETRANGE("Document No.", FromSalesInvHeader."No.");
            FromSalesInvLine.SETRANGE(Type, FromSalesInvLine.Type::Item);
            FromSalesInvLine.SETFILTER("No.", '<>%1', '');
            FromSalesInvLine.SETRANGE("Prepayment Line", FALSE);
            IF FromSalesInvLine.FIND('-') THEN
                REPEAT
                    IF FromSalesInvLine.Quantity > 0 THEN BEGIN
                        "No." := FromSalesInvLine."No.";
                        "Variant Code" := FromSalesInvLine."Variant Code";
                        "Location Code" := FromSalesInvLine."Location Code";
                        "Bin Code" := FromSalesInvLine."Bin Code";
                        "Unit of Measure Code" := FromSalesInvLine."Unit of Measure Code";
                        "Qty. per Unit of Measure" := FromSalesInvLine."Qty. per Unit of Measure";
                        "Outstanding Quantity" := FromSalesInvLine.Quantity;
                        "Drop Shipment" := FromSalesInvLine."Drop Shipment";
                        //CheckItemAvailable(ToSalesHeader, ToSalesLine); SNN
                    END;
                UNTIL FromSalesInvLine.NEXT = 0;
        END;
    end;

    local procedure CheckCopyFromSalesRetRcptAvail(FromReturnRcptHeader: Record "Return Receipt Header"; ToSalesHeader: Record "Sales Header");
    var
        FromReturnRcptLine: Record "Return Receipt Line";
        ToSalesLine: Record "Sales Line";
    begin
        IF NOT (ToSalesHeader."Document Type" IN [ToSalesHeader."Document Type"::Order, ToSalesHeader."Document Type"::Invoice]) THEN
            EXIT;

        WITH ToSalesLine DO BEGIN
            FromReturnRcptLine.SETRANGE("Document No.", FromReturnRcptHeader."No.");
            FromReturnRcptLine.SETRANGE(Type, FromReturnRcptLine.Type::Item);
            FromReturnRcptLine.SETFILTER("No.", '<>%1', '');
            IF FromReturnRcptLine.FIND('-') THEN
                REPEAT
                    IF FromReturnRcptLine.Quantity > 0 THEN BEGIN
                        "No." := FromReturnRcptLine."No.";
                        "Variant Code" := FromReturnRcptLine."Variant Code";
                        "Location Code" := FromReturnRcptLine."Location Code";
                        "Bin Code" := FromReturnRcptLine."Bin Code";
                        "Unit of Measure Code" := FromReturnRcptLine."Unit of Measure Code";
                        "Qty. per Unit of Measure" := FromReturnRcptLine."Qty. per Unit of Measure";
                        "Outstanding Quantity" := FromReturnRcptLine.Quantity;
                        "Drop Shipment" := FALSE;
                       // CheckItemAvailable(ToSalesHeader, ToSalesLine); SNN
                    END;
                UNTIL FromReturnRcptLine.NEXT = 0;
        END;
    end;

    local procedure CheckCopyFromSalesCrMemoAvail(FromSalesCrMemoHeader: Record "Insure Credit Note"; ToSalesHeader: Record "Insure Header");
    var
        FromSalesCrMemoLine: Record "Sales Cr.Memo Line";
        ToSalesLine: Record "Sales Line";
    begin
        /*IF NOT (ToSalesHeader."Document Type" IN [ToSalesHeader."Document Type"::Order,ToSalesHeader."Document Type"::Invoice]) THEN
          EXIT;
        
        WITH ToSalesLine DO BEGIN
          FromSalesCrMemoLine.SETRANGE("Document No.",FromSalesCrMemoHeader."No.");
          FromSalesCrMemoLine.SETRANGE(Type,FromSalesCrMemoLine.Type::Item);
          FromSalesCrMemoLine.SETFILTER("No.",'<>%1','');
          FromSalesCrMemoLine.SETRANGE("Prepayment Line",FALSE);
          IF FromSalesCrMemoLine.FIND('-') THEN
            REPEAT
              IF FromSalesCrMemoLine.Quantity > 0 THEN BEGIN
                "No." := FromSalesCrMemoLine."No.";
                "Variant Code" := FromSalesCrMemoLine."Variant Code";
                "Location Code" := FromSalesCrMemoLine."Location Code";
                "Bin Code" := FromSalesCrMemoLine."Bin Code";
                "Unit of Measure Code" := FromSalesCrMemoLine."Unit of Measure Code";
                "Qty. per Unit of Measure" := FromSalesCrMemoLine."Qty. per Unit of Measure";
                "Outstanding Quantity" := FromSalesCrMemoLine.Quantity;
                "Drop Shipment" := FALSE;
                CheckItemAvailable(ToSalesHeader,ToSalesLine);
              END;
            UNTIL FromSalesCrMemoLine.NEXT = 0;
        END;
        */

    end;

    local procedure CheckItemAvailable(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line");
    begin
        /*IF HideDialog THEN
          EXIT;
        
        ToSalesLine."Document Type" := ToSalesHeader."Document Type";
        ToSalesLine."Document No." := ToSalesHeader."No.";
        ToSalesLine.Type := ToSalesLine.Type::Item;
        ToSalesLine."Purchase Order No." := '';
        ToSalesLine."Purch. Order Line No." := 0;
        ToSalesLine."Drop Shipment" :=
          NOT RecalculateLines AND ToSalesLine."Drop Shipment" AND
          (ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::Order);
        
        IF ToSalesLine."Shipment Date" = 0D THEN BEGIN
          IF ToSalesHeader."Shipment Date" <> 0D THEN
            ToSalesLine.VALIDATE("Shipment Date",ToSalesHeader."Shipment Date")
          ELSE
            ToSalesLine.VALIDATE("Shipment Date",WORKDATE);
        END;
        
        IF ItemCheckAvail.SalesLineCheck(ToSalesLine) THEN
          ItemCheckAvail.RaiseUpdateInterruptedError;
          */

    end;

    local procedure CheckATOItemAvailable(var FromSalesLine: Record "Sales Line"; ToSalesLine: Record "Sales Line");
    var
        ATOLink: Record "Assemble-to-Order Link";
        AsmHeader: Record "Assembly Header";
        TempAsmHeader: Record "Assembly Header" temporary;
        TempAsmLine: Record "Assembly Line" temporary;
    begin
        IF HideDialog THEN
            EXIT;

        IF ATOLink.ATOCopyCheckAvailShowWarning(
             AsmHeader, ToSalesLine, TempAsmHeader, TempAsmLine,
             NOT FromSalesLine.AsmToOrderExists(AsmHeader))
        THEN
            IF ItemCheckAvail.ShowAsmWarningYesNo(TempAsmHeader, TempAsmLine) THEN
                ItemCheckAvail.RaiseUpdateInterruptedError;
    end;

    local procedure CheckPostedATOItemAvailable(var FromSalesShptLine: Record "Sales Shipment Line"; ToSalesLine: Record "Sales Line");
    var
        ATOLink: Record "Assemble-to-Order Link";
        PostedAsmHeader: Record "Posted Assembly Header";
        TempAsmHeader: Record "Assembly Header" temporary;
        TempAsmLine: Record "Assembly Line" temporary;
    begin
        IF HideDialog THEN
            EXIT;

        IF ATOLink.PstdATOCopyCheckAvailShowWarn(
             PostedAsmHeader, ToSalesLine, TempAsmHeader, TempAsmLine,
             NOT FromSalesShptLine.AsmToShipmentExists(PostedAsmHeader))
        THEN
            IF ItemCheckAvail.ShowAsmWarningYesNo(TempAsmHeader, TempAsmLine) THEN
                ItemCheckAvail.RaiseUpdateInterruptedError;
    end;

    procedure CopyServContractLines(ToServContractHeader: Record "Service Contract Header"; FromDocType: Option; FromDocNo: Code[20]; var FromServContractLine: Record "Service Contract Line") AllLinesCopied: Boolean;
    var
        ExistingServContractLine: Record "Service Contract Line";
        LineNo: Integer;
    begin
        IF FromDocNo = '' THEN
            ERROR(Text000);

        ExistingServContractLine.LOCKTABLE;
        ExistingServContractLine.RESET;
        ExistingServContractLine.SETRANGE("Contract Type", ToServContractHeader."Contract Type");
        ExistingServContractLine.SETRANGE("Contract No.", ToServContractHeader."Contract No.");
        IF ExistingServContractLine.FINDLAST THEN
            LineNo := ExistingServContractLine."Line No." + 10000
        ELSE
            LineNo := 10000;

        AllLinesCopied := TRUE;
        FromServContractLine.RESET;
        FromServContractLine.SETRANGE("Contract Type", FromDocType);
        FromServContractLine.SETRANGE("Contract No.", FromDocNo);
        IF FromServContractLine.FIND('-') THEN
            REPEAT
                IF NOT ProcessServContractLine(
                     ToServContractHeader,
                     FromServContractLine,
                     LineNo)
                THEN BEGIN
                    AllLinesCopied := FALSE;
                    FromServContractLine.MARK(TRUE)
                END ELSE
                    LineNo := LineNo + 10000
            UNTIL FromServContractLine.NEXT = 0;
    end;

    procedure ServContractHeaderDocType(DocType: Option): Integer;
    var
        ServContractHeader: Record "Service Contract Header";
    begin
        CASE DocType OF
            ServDocType::Quote:
                EXIT(ServContractHeader."Contract Type"::Quote);
            ServDocType::Contract:
                EXIT(ServContractHeader."Contract Type"::Contract);
        END;
    end;

    procedure ProcessServContractLine(ToServContractHeader: Record "Service Contract Header"; var FromServContractLine: Record "Service Contract Line"; LineNo: Integer): Boolean;
    var
        ToServContractLine: Record "Service Contract Line";
        ExistingServContractLine: Record "Service Contract Line";
        ServItem: Record "Service Item";
    begin
        IF FromServContractLine."Service Item No." <> '' THEN BEGIN
            ServItem.GET(FromServContractLine."Service Item No.");
            IF ServItem."Customer No." <> ToServContractHeader."Customer No." THEN
                EXIT(FALSE);

            ExistingServContractLine.RESET;
            ExistingServContractLine.SETCURRENTKEY("Service Item No.", "Contract Status");
            ExistingServContractLine.SETRANGE("Service Item No.", FromServContractLine."Service Item No.");
            ExistingServContractLine.SETRANGE("Contract Type", ToServContractHeader."Contract Type");
            ExistingServContractLine.SETRANGE("Contract No.", ToServContractHeader."Contract No.");
            IF ExistingServContractLine.FINDFIRST THEN
                EXIT(FALSE);
        END;

        ToServContractLine := FromServContractLine;
        ToServContractLine."Last Planned Service Date" := 0D;
        ToServContractLine."Last Service Date" := 0D;
        ToServContractLine."Last Preventive Maint. Date" := 0D;
        ToServContractLine."Invoiced to Date" := 0D;
        ToServContractLine."Contract Type" := ToServContractHeader."Contract Type";
        ToServContractLine."Contract No." := ToServContractHeader."Contract No.";
        ToServContractLine."Line No." := LineNo;
        ToServContractLine."New Line" := TRUE;
        ToServContractLine.Credited := FALSE;
        ToServContractLine.SetupNewLine;
        ToServContractLine.INSERT(TRUE);
        EXIT(TRUE);
    end;

    procedure CopySalesShptLinesToDoc(ToSalesHeader: Record "Sales Header"; var FromSalesShptLine: Record "Sales Shipment Line"; var LinesNotCopied: Integer; var MissingExCostRevLink: Boolean);
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromSalesHeader: Record "Sales Header";
        FromSalesLine: Record "Sales Line";
        ToSalesLine: Record "Sales Line";
        FromSalesLineBuf: Record "Sales Line" temporary;
        FromSalesShptHeader: Record "Sales Shipment Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
        CopyLine: Boolean;
        InsertDocNoLine: Boolean;
    begin
        /*MissingExCostRevLink := FALSE;
        InitCurrency(ToSalesHeader."Currency Code");
        OpenWindow;
        
        WITH FromSalesShptLine DO
          IF FINDSET THEN
            REPEAT
              FromLineCounter := FromLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(1,FromLineCounter);
              IF FromSalesShptHeader."No." <> "Document No." THEN BEGIN
                FromSalesShptHeader.GET("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              END;
              FromSalesHeader.TRANSFERFIELDS(FromSalesShptHeader);
              FillExactCostRevLink :=
                IsSalesFillExactCostRevLink(ToSalesHeader,0,FromSalesHeader."Currency Code");
              FromSalesLine.TRANSFERFIELDS(FromSalesShptLine);
              FromSalesLine."Appl.-from Item Entry" := 0;
        
              IF "Document No." <> OldDocNo THEN BEGIN
                OldDocNo := "Document No.";
                InsertDocNoLine := TRUE;
              END;
        
              SplitLine := TRUE;
              FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
              IF NOT SplitPstdSalesLinesPerILE(
                   ToSalesHeader,FromSalesHeader,ItemLedgEntry,FromSalesLineBuf,
                   FromSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,TRUE)
              THEN
                IF CopyItemTrkg THEN
                  SplitLine :=
                    SplitSalesDocLinesPerItemTrkg(
                      ItemLedgEntry,TempItemTrkgEntry,FromSalesLineBuf,
                      FromSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,TRUE)
                ELSE
                  SplitLine := FALSE;
        
              IF NOT SplitLine THEN BEGIN
                FromSalesLineBuf := FromSalesLine;
                CopyLine := TRUE;
              END ELSE
                CopyLine := FromSalesLineBuf.FINDSET AND FillExactCostRevLink;
        
              Window.UPDATE(1,FromLineCounter);
              IF CopyLine THEN BEGIN
                NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
                AsmHdrExistsForFromDocLine := AsmToShipmentExists(PostedAsmHeader);
                InitAsmCopyHandling(TRUE);
                IF AsmHdrExistsForFromDocLine THEN BEGIN
                  QtyToAsmToOrder := Quantity;
                  QtyToAsmToOrderBase := "Quantity (Base)";
                  GenerateAsmDataFromPosted(PostedAsmHeader,ToSalesHeader."Document Type");
                END;
                IF InsertDocNoLine THEN BEGIN
                  InsertOldSalesDocNoLine(ToSalesHeader,"Document No.",1,NextLineNo);
                  InsertDocNoLine := FALSE;
                END;
                IF (FromSalesLineBuf.Type <> FromSalesLineBuf.Type::" ") OR
                   (FromSalesLineBuf."Attached to Line No." = 0)
                THEN
                  REPEAT
                    ToLineCounter := ToLineCounter + 1;
                    IF IsTimeForUpdate THEN
                      Window.UPDATE(2,ToLineCounter);
                    IF CopySalesLine(
                         ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLineBuf,NextLineNo,LinesNotCopied,FALSE)
                    THEN BEGIN
                      IF CopyItemTrkg THEN BEGIN
                        IF SplitLine THEN BEGIN
                          TempItemTrkgEntry.RESET;
                          TempItemTrkgEntry.SETCURRENTKEY("Source ID","Source Ref. No.");
                          TempItemTrkgEntry.SETRANGE("Source ID",FromSalesLineBuf."Document No.");
                          TempItemTrkgEntry.SETRANGE("Source Ref. No.",FromSalesLineBuf."Line No.");
                          CollectItemTrkgPerPstDocLine(TempItemTrkgEntry,TempTrkgItemLedgEntry,FALSE);
                        END ELSE
                          ItemTrackingMgt.CollectItemTrkgPerPstdDocLine(TempTrkgItemLedgEntry,ItemLedgEntry);
        
                        ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
                          TempTrkgItemLedgEntry,ToSalesLine,
                          FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                          FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",TRUE);
                      END;
        
                      CopySalesShptExtTextToDoc(
                        ToSalesHeader,ToSalesLine,FromSalesShptLine,FromSalesHeader."Language Code",
                        NextLineNo,FromSalesLineBuf."Appl.-from Item Entry" <> 0);
                    END;
                  UNTIL FromSalesLineBuf.NEXT = 0;
              END;
            UNTIL NEXT = 0;
        
        Window.CLOSE;
        */

    end;

    local procedure CopySalesShptExtTextToDoc(ToSalesHeader: Record "Sales Header"; ToSalesLine: Record "Sales Line"; FromSalesShptLine: Record "Sales Shipment Line"; FromLanguageCode: Code[10]; var NextLineNo: Integer; ExactCostReverse: Boolean);
    var
        ToSalesLine2: Record "Sales Line";
    begin
        ToSalesLine2.SETRANGE("Document No.", ToSalesLine."Document No.");
        ToSalesLine2.SETRANGE("Attached to Line No.", ToSalesLine."Line No.");
        IF ToSalesLine2.ISEMPTY THEN
            WITH FromSalesShptLine DO BEGIN
                SETRANGE("Document No.", "Document No.");
                SETRANGE("Attached to Line No.", "Line No.");
                IF FINDSET THEN
                    REPEAT
                        IF (ToSalesHeader."Language Code" <> FromLanguageCode) OR
                           (RecalculateLines AND NOT ExactCostReverse)
                        THEN BEGIN
                            IF TransferExtendedText.SalesCheckIfAnyExtText(ToSalesLine, FALSE) THEN BEGIN
                                TransferExtendedText.InsertSalesExtText(ToSalesLine);
                                NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
                            END;
                        END ELSE BEGIN
                            CopySalesExtTextLines(
                              ToSalesLine2, ToSalesLine, Description, "Description 2", NextLineNo);
                            ToSalesLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            ToSalesLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                            ToSalesLine2."Dimension Set ID" := "Dimension Set ID";
                        END;
                    UNTIL NEXT = 0;
            END;
    end;

    procedure CopySalesInvLinesToDoc(ToSalesHeader: Record "Insure Header"; var FromSalesInvLine: Record "Insure Debit Note Lines"; var LinesNotCopied: Integer; var MissingExCostRevLink: Boolean);
    var
        ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromSalesHeader: Record "Insure Header";
        FromSalesLine: Record "Insure Lines";
        FromSalesLine2: Record "Insure Lines";
        ToSalesLine: Record "Insure Lines";
        FromSalesLineBuf: Record "Insure Lines" temporary;
        FromSalesInvHeader: Record "Insure Debit Note";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldInvDocNo: Code[20];
        OldShptDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
        SalesInvLineCount: Integer;
        SalesLineCount: Integer;
        BufferCount: Integer;
    begin
        /*MissingExCostRevLink := FALSE;
        InitCurrency(ToSalesHeader."Currency Code");
        FromSalesLineBuf.RESET;
        FromSalesLineBuf.DELETEALL;
        TempItemTrkgEntry.RESET;
        TempItemTrkgEntry.DELETEALL;
        OpenWindow;
        InitAsmCopyHandling(TRUE);
        TempSalesInvLine.DELETEALL;
        
        // Fill sales line buffer
        SalesInvLineCount := 0;
        WITH FromSalesInvLine DO
          IF FINDSET THEN
            REPEAT
              FromLineCounter := FromLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(1,FromLineCounter);
              IF Type = Type::Item THEN BEGIN
                SalesInvLineCount += 1;
                TempSalesInvLine := FromSalesInvLine;
                TempSalesInvLine.INSERT;
              END;
        
              IF FromSalesInvHeader."No." <> "Document No." THEN BEGIN
                FromSalesInvHeader.GET("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              END;
              FromSalesInvHeader.TESTFIELD("Prices Including VAT",ToSalesHeader."Prices Including VAT");
              FromSalesHeader.TRANSFERFIELDS(FromSalesInvHeader);
              FillExactCostRevLink :=
                IsSalesFillExactCostRevLink(ToSalesHeader,1,FromSalesHeader."Currency Code");
              FromSalesLine.TRANSFERFIELDS(FromSalesInvLine);
              FromSalesLine."Appl.-from Item Entry" := 0;
              // Reuse fields to buffer invoice line information
              FromSalesLine."Shipment No." := "Document No.";
              FromSalesLine."Shipment Line No." := 0;
              FromSalesLine."Return Receipt No." := '';
              FromSalesLine."Return Receipt Line No." := "Line No.";
        
              SplitLine := TRUE;
              GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
              IF NOT SplitPstdSalesLinesPerILE(
                   ToSalesHeader,FromSalesHeader,ItemLedgEntryBuf,FromSalesLineBuf,
                   FromSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,FALSE)
              THEN
                IF CopyItemTrkg THEN
                  SplitLine :=
                    SplitSalesDocLinesPerItemTrkg(
                      ItemLedgEntryBuf,TempItemTrkgEntry,FromSalesLineBuf,
                      FromSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,FALSE)
                ELSE
                  SplitLine := FALSE;
        
              IF NOT SplitLine THEN BEGIN
                FromSalesLine2 := FromSalesLineBuf;
                FromSalesLineBuf := FromSalesLine;
                FromSalesLineBuf."Document No." := FromSalesLine2."Document No.";
                FromSalesLineBuf."Shipment Line No." := FromSalesLine2."Shipment Line No.";
                FromSalesLineBuf."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                IF NOT IsRecalculateAmount(
                     FromSalesHeader."Currency Code",ToSalesHeader."Currency Code",
                     FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT")
                THEN
                  FromSalesLineBuf."Return Receipt No." := "Document No.";
                ReCalcSalesLine(FromSalesHeader,ToSalesHeader,FromSalesLineBuf);
                FromSalesLineBuf.INSERT;
              END;
            UNTIL NEXT = 0;
        
        // Create sales line from buffer
        Window.UPDATE(1,FromLineCounter);
        
        BufferCount := 0;
        WITH FromSalesLineBuf DO BEGIN
          // Sorting according to Sales Line Document No.,Line No.
          SETCURRENTKEY("Document Type","Document No.","Line No.");
          SalesLineCount := 0;
          IF FINDSET THEN
            REPEAT
              IF Type = Type::Item THEN
                SalesLineCount += 1;
            UNTIL NEXT = 0;
          IF FINDSET THEN BEGIN
            NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
            REPEAT
              ToLineCounter := ToLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(2,ToLineCounter);
              IF "Shipment No." <> OldInvDocNo THEN BEGIN
                OldInvDocNo := "Shipment No.";
                OldShptDocNo := '';
                InsertOldSalesDocNoLine(ToSalesHeader,OldInvDocNo,2,NextLineNo);
              END;
              IF ("Document No." <> OldShptDocNo) AND ("Shipment Line No." > 0) THEN BEGIN
                OldShptDocNo := "Document No.";
                InsertOldSalesCombDocNoLine(ToSalesHeader,OldInvDocNo,OldShptDocNo,NextLineNo,TRUE);
              END;
        
              IF (Type <> Type::" ") OR ("Attached to Line No." = 0) THEN BEGIN
                // Empty buffer fields
                FromSalesLine2 := FromSalesLineBuf;
                FromSalesLine2."Shipment No." := '';
                FromSalesLine2."Shipment Line No." := 0;
                FromSalesLine2."Return Receipt No." := '';
                FromSalesLine2."Return Receipt Line No." := 0;
                AsmHdrExistsForFromDocLine := FALSE;
                IF Type = Type::Item THEN BEGIN
                  BufferCount += 1;
                  AsmHdrExistsForFromDocLine := RetrieveSalesInvLine(FromSalesLine2,BufferCount,SalesLineCount = SalesInvLineCount);
                  InitAsmCopyHandling(TRUE);
                  IF AsmHdrExistsForFromDocLine THEN BEGIN
                    AsmHdrExistsForFromDocLine := GetAsmDataFromSalesInvLine(ToSalesHeader."Document Type");
                    IF AsmHdrExistsForFromDocLine THEN BEGIN
                      QtyToAsmToOrder := TempSalesInvLine.Quantity;
                      QtyToAsmToOrderBase := TempSalesInvLine.Quantity * TempSalesInvLine."Qty. per Unit of Measure";
                    END;
                  END;
                END;
                IF CopySalesLine(
                     ToSalesHeader,ToSalesLine,FromSalesHeader,
                     FromSalesLine2,NextLineNo,LinesNotCopied,"Return Receipt No." = '')
                THEN BEGIN
                  FromSalesInvLine.GET("Shipment No.","Return Receipt Line No.");
        
                  // copy item tracking
                  IF (Type = Type::Item) AND (Quantity <> 0) THEN BEGIN
                    FromSalesInvLine."Document No." := OldInvDocNo;
                    FromSalesInvLine."Line No." := "Return Receipt Line No.";
                    FromSalesInvLine.GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
                    IF IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) THEN BEGIN
                      IF MoveNegLines OR NOT ExactCostRevMandatory THEN
                        ItemTrackingMgt.CollectItemTrkgPerPstdDocLine(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                      ELSE BEGIN
                        TempItemTrkgEntry.RESET;
                        TempItemTrkgEntry.SETCURRENTKEY("Source ID","Source Ref. No.");
                        TempItemTrkgEntry.SETRANGE("Source ID","Document No.");
                        TempItemTrkgEntry.SETRANGE("Source Ref. No.","Line No.");
                        CollectItemTrkgPerPstDocLine(TempItemTrkgEntry,TempTrkgItemLedgEntry,FALSE);
                      END;
        
                      ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
                        TempTrkgItemLedgEntry,ToSalesLine,
                        FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                        FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",FALSE);
                    END;
                  END;
        
                  CopySalesInvExtTextToDoc(
                    ToSalesHeader,ToSalesLine,FromSalesHeader."Language Code","Shipment No.",
                    "Return Receipt Line No.",NextLineNo,"Appl.-from Item Entry" <> 0);
                END;
              END;
            UNTIL NEXT = 0;
          END;
        END;
        
        Window.CLOSE;
        */

    end;

    local procedure CopySalesInvExtTextToDoc(ToSalesHeader: Record "Insure Header"; ToSalesLine: Record "Insure Lines"; FromLanguageCode: Code[10]; FromInvDocNo: Code[20]; FromInvDocLineNo: Integer; var NextLineNo: Integer; ExactCostReverse: Boolean);
    var
        ToSalesLine2: Record "Insure Lines";
        FromSalesInvLine: Record "Insure Debit Note Lines";
    begin
        /*ToSalesLine2.SETRANGE("Document No.",ToSalesLine."Document No.");
        ToSalesLine2.SETRANGE("Attached to Line No.",ToSalesLine."Line No.");
        IF ToSalesLine2.ISEMPTY THEN
          WITH FromSalesInvLine DO BEGIN
            SETRANGE("Document No.",FromInvDocNo);
            SETRANGE("Attached to Line No.",FromInvDocLineNo);
            IF FINDSET THEN
              REPEAT
                IF (ToSalesHeader."Language Code" <> FromLanguageCode) OR
                   (RecalculateLines AND NOT ExactCostReverse)
                THEN BEGIN
                  IF TransferExtendedText.SalesCheckIfAnyExtText(ToSalesLine,FALSE) THEN BEGIN
                    TransferExtendedText.InsertSalesExtText(ToSalesLine);
                    NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
                  END;
                END ELSE BEGIN
                  CopySalesExtTextLines(
                    ToSalesLine2,ToSalesLine,Description,"Description 2",NextLineNo);
                  ToSalesLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                  ToSalesLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                  ToSalesLine2."Dimension Set ID" := "Dimension Set ID";
                END;
              UNTIL NEXT = 0;
          END;
          */

    end;

    procedure CopySalesCrMemoLinesToDoc(ToSalesHeader: Record "Sales Header"; var FromSalesCrMemoLine: Record "Sales Cr.Memo Line"; var LinesNotCopied: Integer; var MissingExCostRevLink: Boolean);
    var
        ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromSalesHeader: Record "Sales Header";
        FromSalesLine: Record "Sales Line";
        FromSalesLine2: Record "Sales Line";
        ToSalesLine: Record "Sales Line";
        FromSalesLineBuf: Record "Sales Line" temporary;
        FromSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldCrMemoDocNo: Code[20];
        OldReturnRcptDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
    begin
        /*MissingExCostRevLink := FALSE;
        InitCurrency(ToSalesHeader."Currency Code");
        FromSalesLineBuf.RESET;
        FromSalesLineBuf.DELETEALL;
        TempItemTrkgEntry.RESET;
        TempItemTrkgEntry.DELETEALL;
        OpenWindow;
        
        // Fill sales line buffer
        WITH FromSalesCrMemoLine DO
          IF FINDSET THEN
            REPEAT
              FromLineCounter := FromLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(1,FromLineCounter);
              IF FromSalesCrMemoHeader."No." <> "Document No." THEN BEGIN
                FromSalesCrMemoHeader.GET("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              END;
              FromSalesHeader.TRANSFERFIELDS(FromSalesCrMemoHeader);
              FillExactCostRevLink :=
                IsSalesFillExactCostRevLink(ToSalesHeader,3,FromSalesHeader."Currency Code");
              FromSalesLine.TRANSFERFIELDS(FromSalesCrMemoLine);
              FromSalesLine."Appl.-from Item Entry" := 0;
              // Reuse fields to buffer credit memo line information
              FromSalesLine."Shipment No." := "Document No.";
              FromSalesLine."Shipment Line No." := 0;
              FromSalesLine."Return Receipt No." := '';
              FromSalesLine."Return Receipt Line No." := "Line No.";
        
              SplitLine := TRUE;
              GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
              IF NOT SplitPstdSalesLinesPerILE(
                   ToSalesHeader,FromSalesHeader,ItemLedgEntryBuf,FromSalesLineBuf,
                   FromSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,FALSE)
              THEN
                IF CopyItemTrkg THEN
                  SplitLine :=
                    SplitSalesDocLinesPerItemTrkg(
                      ItemLedgEntryBuf,TempItemTrkgEntry,FromSalesLineBuf,
                      FromSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,FALSE)
                ELSE
                  SplitLine := FALSE;
        
              IF NOT SplitLine THEN BEGIN
                FromSalesLine2 := FromSalesLineBuf;
                FromSalesLineBuf := FromSalesLine;
                FromSalesLineBuf."Document No." := FromSalesLine2."Document No.";
                FromSalesLineBuf."Shipment Line No." := FromSalesLine2."Shipment Line No.";
                FromSalesLineBuf."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                IF NOT IsRecalculateAmount(
                     FromSalesHeader."Currency Code",ToSalesHeader."Currency Code",
                     FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT")
                THEN
                  FromSalesLineBuf."Return Receipt No." := "Document No.";
                ReCalcSalesLine(FromSalesHeader,ToSalesHeader,FromSalesLineBuf);
                FromSalesLineBuf.INSERT;
              END;
        
            UNTIL NEXT = 0;
        
        // Create sales line from buffer
        Window.UPDATE(1,FromLineCounter);
        WITH FromSalesLineBuf DO BEGIN
          // Sorting according to Sales Line Document No.,Line No.
          SETCURRENTKEY("Document Type","Document No.","Line No.");
          IF FINDSET THEN BEGIN
            NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
            REPEAT
              ToLineCounter := ToLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(2,ToLineCounter);
              IF "Shipment No." <> OldCrMemoDocNo THEN BEGIN
                OldCrMemoDocNo := "Shipment No.";
                OldReturnRcptDocNo := '';
                InsertOldSalesDocNoLine(ToSalesHeader,OldCrMemoDocNo,4,NextLineNo);
              END;
              IF ("Document No." <> OldReturnRcptDocNo) AND ("Shipment Line No." > 0) THEN BEGIN
                OldReturnRcptDocNo := "Document No.";
                InsertOldSalesCombDocNoLine(ToSalesHeader,OldCrMemoDocNo,OldReturnRcptDocNo,NextLineNo,FALSE);
              END;
        
              IF (Type <> Type::" ") OR ("Attached to Line No." = 0) THEN BEGIN
                // Empty buffer fields
                FromSalesLine2 := FromSalesLineBuf;
                FromSalesLine2."Shipment No." := '';
                FromSalesLine2."Shipment Line No." := 0;
                FromSalesLine2."Return Receipt No." := '';
                FromSalesLine2."Return Receipt Line No." := 0;
        
                IF CopySalesLine(
                     ToSalesHeader,ToSalesLine,FromSalesHeader,
                     FromSalesLine2,NextLineNo,LinesNotCopied,"Return Receipt No." = '')
                THEN BEGIN
                  FromSalesCrMemoLine.GET("Shipment No.","Return Receipt Line No.");
        
                  // copy item tracking
                  IF (Type = Type::Item) AND (Quantity <> 0) THEN BEGIN
                    FromSalesCrMemoLine."Document No." := OldCrMemoDocNo;
                    FromSalesCrMemoLine."Line No." := "Return Receipt Line No.";
                    FromSalesCrMemoLine.GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
                    IF IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) THEN BEGIN
                      IF MoveNegLines OR NOT ExactCostRevMandatory THEN
                        ItemTrackingMgt.CollectItemTrkgPerPstdDocLine(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                      ELSE BEGIN
                        TempItemTrkgEntry.RESET;
                        TempItemTrkgEntry.SETCURRENTKEY("Source ID","Source Ref. No.");
                        TempItemTrkgEntry.SETRANGE("Source ID","Document No.");
                        TempItemTrkgEntry.SETRANGE("Source Ref. No.","Line No.");
                        CollectItemTrkgPerPstDocLine(TempItemTrkgEntry,TempTrkgItemLedgEntry,FALSE);
                      END;
        
                      ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
                        TempTrkgItemLedgEntry,ToSalesLine,
                        FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                        FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",FALSE);
                    END;
                  END;
                  CopySalesCrMemoExtTextToDoc(
                    ToSalesHeader,ToSalesLine,FromSalesHeader."Language Code","Shipment No.",
                    "Return Receipt Line No.",NextLineNo,"Appl.-from Item Entry" <> 0);
                END;
              END;
            UNTIL NEXT = 0;
          END;
        END;
        
        Window.CLOSE;
        */

    end;

    local procedure CopySalesCrMemoExtTextToDoc(ToSalesHeader: Record "Sales Header"; ToSalesLine: Record "Sales Line"; FromLanguageCode: Code[10]; FromCrMemoDocNo: Code[20]; FromCrMemoDocLineNo: Integer; var NextLineNo: Integer; ExactCostReverse: Boolean);
    var
        ToSalesLine2: Record "Sales Line";
        FromSalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        ToSalesLine2.SETRANGE("Document No.", ToSalesLine."Document No.");
        ToSalesLine2.SETRANGE("Attached to Line No.", ToSalesLine."Line No.");
        IF ToSalesLine2.ISEMPTY THEN
            WITH FromSalesCrMemoLine DO BEGIN
                SETRANGE("Document No.", FromCrMemoDocNo);
                SETRANGE("Attached to Line No.", FromCrMemoDocLineNo);
                IF FINDSET THEN
                    REPEAT
                        IF (ToSalesHeader."Language Code" <> FromLanguageCode) OR
                           (RecalculateLines AND NOT ExactCostReverse)
                        THEN BEGIN
                            IF TransferExtendedText.SalesCheckIfAnyExtText(ToSalesLine, FALSE) THEN BEGIN
                                TransferExtendedText.InsertSalesExtText(ToSalesLine);
                                NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
                            END;
                        END ELSE BEGIN
                            CopySalesExtTextLines(
                              ToSalesLine2, ToSalesLine, Description, "Description 2", NextLineNo);
                            ToSalesLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            ToSalesLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                            ToSalesLine2."Dimension Set ID" := "Dimension Set ID";
                        END;
                    UNTIL NEXT = 0;
            END;
    end;

    procedure CopySalesReturnRcptLinesToDoc(ToSalesHeader: Record "Sales Header"; var FromReturnRcptLine: Record "Return Receipt Line"; var LinesNotCopied: Integer; var MissingExCostRevLink: Boolean);
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromSalesHeader: Record "Sales Header";
        FromSalesLine: Record "Sales Line";
        ToSalesLine: Record "Sales Line";
        FromSalesLineBuf: Record "Sales Line" temporary;
        FromReturnRcptHeader: Record "Return Receipt Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
        CopyLine: Boolean;
        InsertDocNoLine: Boolean;
    begin
        /*MissingExCostRevLink := FALSE;
        InitCurrency(ToSalesHeader."Currency Code");
        OpenWindow;
        
        WITH FromReturnRcptLine DO
          IF FINDSET THEN
            REPEAT
              FromLineCounter := FromLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(1,FromLineCounter);
              IF FromReturnRcptHeader."No." <> "Document No." THEN BEGIN
                FromReturnRcptHeader.GET("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              END;
              FromSalesHeader.TRANSFERFIELDS(FromReturnRcptHeader);
              FillExactCostRevLink :=
                IsSalesFillExactCostRevLink(ToSalesHeader,2,FromSalesHeader."Currency Code");
              FromSalesLine.TRANSFERFIELDS(FromReturnRcptLine);
              FromSalesLine."Appl.-from Item Entry" := 0;
        
              IF "Document No." <> OldDocNo THEN BEGIN
                OldDocNo := "Document No.";
                InsertDocNoLine := TRUE;
              END;
        
              SplitLine := TRUE;
              FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
              IF NOT SplitPstdSalesLinesPerILE(
                   ToSalesHeader,FromSalesHeader,ItemLedgEntry,FromSalesLineBuf,
                   FromSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,TRUE)
              THEN
                IF CopyItemTrkg THEN
                  SplitLine :=
                    SplitSalesDocLinesPerItemTrkg(
                      ItemLedgEntry,TempItemTrkgEntry,FromSalesLineBuf,
                      FromSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,TRUE)
                ELSE
                  SplitLine := FALSE;
        
              IF NOT SplitLine THEN BEGIN
                FromSalesLineBuf := FromSalesLine;
                CopyLine := TRUE;
              END ELSE
                CopyLine := FromSalesLineBuf.FINDSET AND FillExactCostRevLink;
        
              Window.UPDATE(1,FromLineCounter);
              IF CopyLine THEN BEGIN
                NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
                IF InsertDocNoLine THEN BEGIN
                  InsertOldSalesDocNoLine(ToSalesHeader,"Document No.",3,NextLineNo);
                  InsertDocNoLine := FALSE;
                END;
                IF (FromSalesLineBuf.Type <> FromSalesLineBuf.Type::" ") OR
                   (FromSalesLineBuf."Attached to Line No." = 0)
                THEN
                  REPEAT
                    ToLineCounter := ToLineCounter + 1;
                    IF IsTimeForUpdate THEN
                      Window.UPDATE(2,ToLineCounter);
                    IF CopySalesLine(
                         ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLineBuf,NextLineNo,LinesNotCopied,FALSE)
                    THEN BEGIN
                      IF CopyItemTrkg THEN BEGIN
                        IF SplitLine THEN BEGIN
                          TempItemTrkgEntry.RESET;
                          TempItemTrkgEntry.SETCURRENTKEY("Source ID","Source Ref. No.");
                          TempItemTrkgEntry.SETRANGE("Source ID",FromSalesLineBuf."Document No.");
                          TempItemTrkgEntry.SETRANGE("Source Ref. No.",FromSalesLineBuf."Line No.");
                          CollectItemTrkgPerPstDocLine(TempItemTrkgEntry,TempTrkgItemLedgEntry,FALSE);
                        END ELSE
                          ItemTrackingMgt.CollectItemTrkgPerPstdDocLine(TempTrkgItemLedgEntry,ItemLedgEntry);
        
                        ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
                          TempTrkgItemLedgEntry,ToSalesLine,
                          FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                          FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",TRUE);
                      END;
        
                      CopyReturnRcptExtTextToDoc(
                        ToSalesHeader,ToSalesLine,FromReturnRcptLine,FromSalesHeader."Language Code",
                        NextLineNo,FromSalesLineBuf."Appl.-from Item Entry" <> 0);
                    END;
                  UNTIL FromSalesLineBuf.NEXT = 0
              END;
            UNTIL NEXT = 0;
        
        Window.CLOSE;
        */

    end;

    local procedure CopyReturnRcptExtTextToDoc(ToSalesHeader: Record "Sales Header"; ToSalesLine: Record "Sales Line"; FromReturnRcptLine: Record "Return Receipt Line"; FromLanguageCode: Code[10]; var NextLineNo: Integer; ExactCostReverse: Boolean);
    var
        ToSalesLine2: Record "Sales Line";
    begin
        ToSalesLine2.SETRANGE("Document No.", ToSalesLine."Document No.");
        ToSalesLine2.SETRANGE("Attached to Line No.", ToSalesLine."Line No.");
        IF ToSalesLine2.ISEMPTY THEN
            WITH FromReturnRcptLine DO BEGIN
                SETRANGE("Document No.", "Document No.");
                SETRANGE("Attached to Line No.", "Line No.");
                IF FINDSET THEN
                    REPEAT
                        IF (ToSalesHeader."Language Code" <> FromLanguageCode) OR
                           (RecalculateLines AND NOT ExactCostReverse)
                        THEN BEGIN
                            IF TransferExtendedText.SalesCheckIfAnyExtText(ToSalesLine, FALSE) THEN BEGIN
                                TransferExtendedText.InsertSalesExtText(ToSalesLine);
                                NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
                            END;
                        END ELSE BEGIN
                            CopySalesExtTextLines(
                              ToSalesLine2, ToSalesLine, Description, "Description 2", NextLineNo);
                            ToSalesLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            ToSalesLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                            ToSalesLine2."Dimension Set ID" := "Dimension Set ID";
                        END;
                    UNTIL NEXT = 0;
            END;
    end;

    local procedure SplitPstdSalesLinesPerILE(ToSalesHeader: Record "Sales Header"; FromSalesHeader: Record "Sales Header"; var ItemLedgEntry: Record "Item Ledger Entry"; var FromSalesLineBuf: Record "Sales Line"; FromSalesLine: Record "Sales Line"; var NextLineNo: Integer; var CopyItemTrkg: Boolean; var MissingExCostRevLink: Boolean; FillExactCostRevLink: Boolean; FromShptOrRcpt: Boolean): Boolean;
    var
        OrgQtyBase: Decimal;
    begin
        IF FromShptOrRcpt THEN BEGIN
            FromSalesLineBuf.RESET;
            FromSalesLineBuf.DELETEALL;
        END ELSE
            FromSalesLineBuf.INIT;

        CopyItemTrkg := FALSE;

        IF (FromSalesLine.Type <> FromSalesLine.Type::Item) OR (FromSalesLine.Quantity = 0) THEN
            EXIT(FALSE);
        IF IsCopyItemTrkg(ItemLedgEntry, CopyItemTrkg, FillExactCostRevLink) OR
           NOT FillExactCostRevLink OR MoveNegLines OR
           NOT ExactCostRevMandatory
        THEN
            EXIT(FALSE);

        WITH ItemLedgEntry DO BEGIN
            FINDSET;
            IF Quantity >= 0 THEN BEGIN
                FromSalesLineBuf."Document No." := "Document No.";
                IF GetSalesDocType(ItemLedgEntry) IN
                   [FromSalesLineBuf."Document Type"::Order, FromSalesLineBuf."Document Type"::"Return Order"]
                THEN
                    FromSalesLineBuf."Shipment Line No." := 1;
                EXIT(FALSE);
            END;
            OrgQtyBase := FromSalesLine."Quantity (Base)";
            REPEAT
                IF "Shipped Qty. Not Returned" = 0 THEN
                    LinesApplied := TRUE;

                IF "Shipped Qty. Not Returned" < 0 THEN BEGIN
                    FromSalesLineBuf := FromSalesLine;

                    IF -"Shipped Qty. Not Returned" < ABS(FromSalesLine."Quantity (Base)") THEN BEGIN
                        IF FromSalesLine."Quantity (Base)" > 0 THEN
                            FromSalesLineBuf."Quantity (Base)" := -"Shipped Qty. Not Returned"
                        ELSE
                            FromSalesLineBuf."Quantity (Base)" := "Shipped Qty. Not Returned";
                        IF FromSalesLineBuf."Qty. per Unit of Measure" = 0 THEN
                            FromSalesLineBuf.Quantity := FromSalesLineBuf."Quantity (Base)"
                        ELSE
                            FromSalesLineBuf.Quantity :=
                              ROUND(FromSalesLineBuf."Quantity (Base)" / FromSalesLineBuf."Qty. per Unit of Measure", 0.00001);
                    END;
                    FromSalesLine."Quantity (Base)" := FromSalesLine."Quantity (Base)" - FromSalesLineBuf."Quantity (Base)";
                    FromSalesLine.Quantity := FromSalesLine.Quantity - FromSalesLineBuf.Quantity;
                    FromSalesLineBuf."Appl.-from Item Entry" := "Entry No.";
                    FromSalesLineBuf."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    FromSalesLineBuf."Document No." := "Document No.";
                    IF GetSalesDocType(ItemLedgEntry) IN
                       [FromSalesLineBuf."Document Type"::Order, FromSalesLineBuf."Document Type"::"Return Order"]
                    THEN
                        FromSalesLineBuf."Shipment Line No." := 1;

                    IF NOT FromShptOrRcpt THEN
                        UpdateRevSalesLineAmount(
                          FromSalesLineBuf, OrgQtyBase,
                          FromSalesHeader."Prices Including VAT", ToSalesHeader."Prices Including VAT");

                    FromSalesLineBuf.INSERT;
                END;
            UNTIL (NEXT = 0) OR (FromSalesLine."Quantity (Base)" = 0);

            IF (FromSalesLine."Quantity (Base)" <> 0) AND FillExactCostRevLink THEN
                MissingExCostRevLink := TRUE;
            CheckUnappliedLines(LinesApplied, MissingExCostRevLink);
        END;
        EXIT(TRUE);
    end;

    local procedure SplitSalesDocLinesPerItemTrkg(var ItemLedgEntry: Record "Item Ledger Entry"; var TempItemTrkgEntry: Record "Reservation Entry" temporary; var FromSalesLineBuf: Record "Sales Line"; FromSalesLine: Record "Sales Line"; var NextLineNo: Integer; var NextItemTrkgEntryNo: Integer; var MissingExCostRevLink: Boolean; FromShptOrRcpt: Boolean): Boolean;
    var
        SalesLineBuf: array[2] of Record "Sales Line" temporary;
        ReversibleQtyBase: Decimal;
        SignFactor: Integer;
        i: Integer;
    begin
        IF FromShptOrRcpt THEN BEGIN
            FromSalesLineBuf.RESET;
            FromSalesLineBuf.DELETEALL;
            TempItemTrkgEntry.RESET;
            TempItemTrkgEntry.DELETEALL;
        END ELSE
            FromSalesLineBuf.INIT;

        IF MoveNegLines OR NOT ExactCostRevMandatory THEN
            EXIT(FALSE);

        IF FromSalesLine."Quantity (Base)" < 0 THEN
            SignFactor := -1
        ELSE
            SignFactor := 1;

        WITH ItemLedgEntry DO BEGIN
            SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
            FINDSET;
            REPEAT
                SalesLineBuf[1] := FromSalesLine;
                SalesLineBuf[1]."Line No." := NextLineNo;
                SalesLineBuf[1]."Quantity (Base)" := 0;
                SalesLineBuf[1].Quantity := 0;
                SalesLineBuf[1]."Document No." := "Document No.";
                IF GetSalesDocType(ItemLedgEntry) IN
                   [SalesLineBuf[1]."Document Type"::Order, SalesLineBuf[1]."Document Type"::"Return Order"]
                THEN
                    SalesLineBuf[1]."Shipment Line No." := 1;
                SalesLineBuf[2] := SalesLineBuf[1];
                SalesLineBuf[2]."Line No." := SalesLineBuf[2]."Line No." + 1;

                IF NOT FromShptOrRcpt THEN BEGIN
                    SETRANGE("Document No.", "Document No.");
                    SETRANGE("Document Type", "Document Type");
                    SETRANGE("Document Line No.", "Document Line No.");
                END;
                REPEAT
                    i := 1;
                    IF NOT Positive THEN
                        "Shipped Qty. Not Returned" :=
                          "Shipped Qty. Not Returned" -
                          CalcDistributedQty(TempItemTrkgEntry, ItemLedgEntry, SalesLineBuf[2]."Line No." + 1);

                    IF "Document Type" IN ["Document Type"::"Sales Return Receipt", "Document Type"::"Sales Credit Memo"] THEN
                        IF "Remaining Quantity" < FromSalesLine."Quantity (Base)" * SignFactor THEN
                            ReversibleQtyBase := "Remaining Quantity" * SignFactor
                        ELSE
                            ReversibleQtyBase := FromSalesLine."Quantity (Base)"
                    ELSE
                        IF -"Shipped Qty. Not Returned" < FromSalesLine."Quantity (Base)" * SignFactor THEN
                            ReversibleQtyBase := -"Shipped Qty. Not Returned" * SignFactor
                        ELSE
                            ReversibleQtyBase := FromSalesLine."Quantity (Base)";

                    IF ReversibleQtyBase <> 0 THEN BEGIN
                        IF NOT Positive THEN
                            IF IsSplitItemLedgEntry(ItemLedgEntry) THEN
                                i := 2;

                        SalesLineBuf[i]."Quantity (Base)" := SalesLineBuf[i]."Quantity (Base)" + ReversibleQtyBase;
                        IF SalesLineBuf[i]."Qty. per Unit of Measure" = 0 THEN
                            SalesLineBuf[i].Quantity := SalesLineBuf[i]."Quantity (Base)"
                        ELSE
                            SalesLineBuf[i].Quantity :=
                              ROUND(SalesLineBuf[i]."Quantity (Base)" / SalesLineBuf[i]."Qty. per Unit of Measure", 0.00001);
                        FromSalesLine."Quantity (Base)" := FromSalesLine."Quantity (Base)" - ReversibleQtyBase;
                        // Fill buffer with exact cost reversing link
                        InsertTempItemTrkgEntry(
                          ItemLedgEntry, TempItemTrkgEntry, -ABS(ReversibleQtyBase),
                          SalesLineBuf[i]."Line No.", NextItemTrkgEntryNo, TRUE);
                    END;
                UNTIL (NEXT = 0) OR (FromSalesLine."Quantity (Base)" = 0);

                FOR i := 1 TO 2 DO
                    IF SalesLineBuf[i]."Quantity (Base)" <> 0 THEN BEGIN
                        FromSalesLineBuf := SalesLineBuf[i];
                        FromSalesLineBuf.INSERT;
                        NextLineNo := SalesLineBuf[i]."Line No." + 1;
                    END;

                IF NOT FromShptOrRcpt THEN BEGIN
                    SETRANGE("Document No.");
                    SETRANGE("Document Type");
                    SETRANGE("Document Line No.");
                END;
            UNTIL (NEXT = 0) OR FromShptOrRcpt;

            IF (FromSalesLine."Quantity (Base)" <> 0) AND NOT Positive AND TempItemTrkgEntry.ISEMPTY THEN
                MissingExCostRevLink := TRUE;
        END;

        EXIT(TRUE);
    end;

    procedure CopyPurchRcptLinesToDoc(ToPurchHeader: Record "Purchase Header"; var FromPurchRcptLine: Record "Purch. Rcpt. Line"; var LinesNotCopied: Integer; var MissingExCostRevLink: Boolean);
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromPurchHeader: Record "Purchase Header";
        FromPurchLine: Record "Purchase Line";
        ToPurchLine: Record "Purchase Line";
        FromPurchLineBuf: Record "Purchase Line" temporary;
        FromPurchRcptHeader: Record "Purch. Rcpt. Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        FillExactCostRevLink: Boolean;
        SplitLine: Boolean;
        CopyLine: Boolean;
        InsertDocNoLine: Boolean;
    begin
        /*MissingExCostRevLink := FALSE;
        InitCurrency(ToPurchHeader."Currency Code");
        OpenWindow;
        
        WITH FromPurchRcptLine DO
          IF FINDSET THEN
            REPEAT
              FromLineCounter := FromLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(1,FromLineCounter);
              IF FromPurchRcptHeader."No." <> "Document No." THEN BEGIN
                FromPurchRcptHeader.GET("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              END;
              FromPurchHeader.TRANSFERFIELDS(FromPurchRcptHeader);
              FillExactCostRevLink :=
                IsPurchFillExactCostRevLink(ToPurchHeader,0,FromPurchHeader."Currency Code");
              FromPurchLine.TRANSFERFIELDS(FromPurchRcptLine);
              FromPurchLine."Appl.-to Item Entry" := 0;
        
              IF "Document No." <> OldDocNo THEN BEGIN
                OldDocNo := "Document No.";
                InsertDocNoLine := TRUE;
              END;
        
              SplitLine := TRUE;
              FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
              IF NOT SplitPstdPurchLinesPerILE(
                   ToPurchHeader,FromPurchHeader,ItemLedgEntry,FromPurchLineBuf,
                   FromPurchLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,TRUE)
              THEN
                IF CopyItemTrkg THEN
                  SplitLine :=
                    SplitPurchDocLinesPerItemTrkg(
                      ItemLedgEntry,TempItemTrkgEntry,FromPurchLineBuf,
                      FromPurchLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,TRUE)
                ELSE
                  SplitLine := FALSE;
        
              IF NOT SplitLine THEN BEGIN
                FromPurchLineBuf := FromPurchLine;
                CopyLine := TRUE;
              END ELSE
                CopyLine := FromPurchLineBuf.FINDSET AND FillExactCostRevLink;
        
              Window.UPDATE(1,FromLineCounter);
              IF CopyLine THEN BEGIN
                NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
                IF InsertDocNoLine THEN BEGIN
                  InsertOldPurchDocNoLine(ToPurchHeader,"Document No.",1,NextLineNo);
                  InsertDocNoLine := FALSE;
                END;
                IF (FromPurchLineBuf.Type <> FromPurchLineBuf.Type::" ") OR
                   (FromPurchLineBuf."Attached to Line No." = 0)
                THEN
                  REPEAT
                    ToLineCounter := ToLineCounter + 1;
                    IF IsTimeForUpdate THEN
                      Window.UPDATE(2,ToLineCounter);
                    IF FromPurchLine."Prod. Order No." <> '' THEN
                      FromPurchLine."Quantity (Base)" := 0;
                    IF CopyPurchLine(
                         ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLineBuf,NextLineNo,LinesNotCopied,FALSE)
                    THEN BEGIN
                      IF CopyItemTrkg THEN BEGIN
                        IF SplitLine THEN BEGIN
                          TempItemTrkgEntry.RESET;
                          TempItemTrkgEntry.SETCURRENTKEY("Source ID","Source Ref. No.");
                          TempItemTrkgEntry.SETRANGE("Source ID",FromPurchLineBuf."Document No.");
                          TempItemTrkgEntry.SETRANGE("Source Ref. No.",FromPurchLineBuf."Line No.");
                          CollectItemTrkgPerPstDocLine(TempItemTrkgEntry,TempTrkgItemLedgEntry,TRUE);
                        END ELSE
                          ItemTrackingMgt.CollectItemTrkgPerPstdDocLine(TempTrkgItemLedgEntry,ItemLedgEntry);
        
                        ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
                          TempTrkgItemLedgEntry,ToPurchLine,
                          FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                          FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",TRUE);
                      END;
        
                      CopyPurchRcptExtTextToDoc(
                        ToPurchHeader,ToPurchLine,FromPurchRcptLine,FromPurchHeader."Language Code",
                        NextLineNo,FromPurchLineBuf."Appl.-to Item Entry" <> 0);
                    END;
                  UNTIL FromPurchLineBuf.NEXT = 0
              END;
            UNTIL NEXT = 0;
        
        Window.CLOSE;
        */

    end;

    local procedure CopyPurchRcptExtTextToDoc(ToPurchHeader: Record "Purchase Header"; ToPurchLine: Record "Purchase Line"; FromPurchRcptLine: Record "Purch. Rcpt. Line"; FromLanguageCode: Code[10]; var NextLineNo: Integer; ExactCostReverse: Boolean);
    var
        ToPurchLine2: Record "Purchase Line";
    begin
        ToPurchLine2.SETRANGE("Document No.", ToPurchLine."Document No.");
        ToPurchLine2.SETRANGE("Attached to Line No.", ToPurchLine."Line No.");
        IF ToPurchLine2.ISEMPTY THEN
            WITH FromPurchRcptLine DO BEGIN
                SETRANGE("Document No.", "Document No.");
                SETRANGE("Attached to Line No.", "Line No.");
                IF FINDSET THEN
                    REPEAT
                        IF (ToPurchHeader."Language Code" <> FromLanguageCode) OR
                           (RecalculateLines AND NOT ExactCostReverse)
                        THEN BEGIN
                            IF TransferExtendedText.PurchCheckIfAnyExtText(ToPurchLine, FALSE) THEN BEGIN
                                TransferExtendedText.InsertPurchExtText(ToPurchLine);
                                NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
                            END;
                        END ELSE BEGIN
                            CopyPurchExtTextLines(
                              ToPurchLine2, ToPurchLine, Description, "Description 2", NextLineNo);
                            ToPurchLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            ToPurchLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                            ToPurchLine2."Dimension Set ID" := "Dimension Set ID";
                        END;
                    UNTIL NEXT = 0;
            END;
    end;

    procedure CopyPurchInvLinesToDoc(ToPurchHeader: Record "Purchase Header"; var FromPurchInvLine: Record "Purch. Inv. Line"; var LinesNotCopied: Integer; var MissingExCostRevLink: Boolean);
    var
        ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromPurchHeader: Record "Purchase Header";
        FromPurchLine: Record "Purchase Line";
        FromPurchLine2: Record "Purchase Line";
        ToPurchLine: Record "Purchase Line";
        FromPurchLineBuf: Record "Purchase Line" temporary;
        FromPurchInvHeader: Record "Purch. Inv. Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldInvDocNo: Code[20];
        OldRcptDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
    begin
        /*MissingExCostRevLink := FALSE;
        InitCurrency(ToPurchHeader."Currency Code");
        FromPurchLineBuf.RESET;
        FromPurchLineBuf.DELETEALL;
        TempItemTrkgEntry.RESET;
        TempItemTrkgEntry.DELETEALL;
        OpenWindow;
        
        // Fill purchase line buffer
        WITH FromPurchInvLine DO
          IF FINDSET THEN
            REPEAT
              FromLineCounter := FromLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(1,FromLineCounter);
              IF FromPurchInvHeader."No." <> "Document No." THEN BEGIN
                FromPurchInvHeader.GET("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              END;
              FromPurchInvHeader.TESTFIELD("Prices Including VAT",ToPurchHeader."Prices Including VAT");
              FromPurchHeader.TRANSFERFIELDS(FromPurchInvHeader);
              FillExactCostRevLink :=
                IsPurchFillExactCostRevLink(ToPurchHeader,1,FromPurchHeader."Currency Code");
              FromPurchLine.TRANSFERFIELDS(FromPurchInvLine);
              FromPurchLine."Appl.-to Item Entry" := 0;
              // Reuse fields to buffer invoice line information
              FromPurchLine."Receipt No." := "Document No.";
              FromPurchLine."Receipt Line No." := 0;
              FromPurchLine."Return Shipment No." := '';
              FromPurchLine."Return Shipment Line No." := "Line No.";
        
              SplitLine := TRUE;
              GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
              IF NOT SplitPstdPurchLinesPerILE(
                   ToPurchHeader,FromPurchHeader,ItemLedgEntryBuf,FromPurchLineBuf,
                   FromPurchLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,FALSE)
              THEN
                IF CopyItemTrkg THEN
                  SplitLine :=
                    SplitPurchDocLinesPerItemTrkg(
                      ItemLedgEntryBuf,TempItemTrkgEntry,FromPurchLineBuf,
                      FromPurchLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,FALSE)
                ELSE
                  SplitLine := FALSE;
        
              IF NOT SplitLine THEN BEGIN
                FromPurchLine2 := FromPurchLineBuf;
                FromPurchLineBuf := FromPurchLine;
                FromPurchLineBuf."Document No." := FromPurchLine2."Document No.";
                FromPurchLineBuf."Receipt Line No." := FromPurchLine2."Receipt Line No.";
                FromPurchLineBuf."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                IF NOT IsRecalculateAmount(
                     FromPurchHeader."Currency Code",ToPurchHeader."Currency Code",
                     FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT")
                THEN
                  FromPurchLineBuf."Return Shipment No." := "Document No.";
                ReCalcPurchLine(FromPurchHeader,ToPurchHeader,FromPurchLineBuf);
                FromPurchLineBuf.INSERT;
              END;
            UNTIL NEXT = 0;
        
        // Create purchase line from buffer
        Window.UPDATE(1,FromLineCounter);
        WITH FromPurchLineBuf DO BEGIN
          // Sorting according to Purchase Line Document No.,Line No.
          SETCURRENTKEY("Document Type","Document No.","Line No.");
          IF FINDSET THEN BEGIN
            NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
            REPEAT
              ToLineCounter := ToLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(2,ToLineCounter);
              IF "Receipt No." <> OldInvDocNo THEN BEGIN
                OldInvDocNo := "Receipt No.";
                OldRcptDocNo := '';
                InsertOldPurchDocNoLine(ToPurchHeader,OldInvDocNo,2,NextLineNo);
              END;
              IF "Document No." <> OldRcptDocNo THEN BEGIN
                OldRcptDocNo := "Document No.";
                InsertOldPurchCombDocNoLine(ToPurchHeader,OldInvDocNo,OldRcptDocNo,NextLineNo,TRUE);
              END;
        
              IF (Type <> Type::" ") OR ("Attached to Line No." = 0) THEN BEGIN
                // Empty buffer fields
                FromPurchLine2 := FromPurchLineBuf;
                FromPurchLine2."Receipt No." := '';
                FromPurchLine2."Receipt Line No." := 0;
                FromPurchLine2."Return Shipment No." := '';
                FromPurchLine2."Return Shipment Line No." := 0;
        
                IF CopyPurchLine(
                     ToPurchHeader,ToPurchLine,FromPurchHeader,
                     FromPurchLine2,NextLineNo,LinesNotCopied,"Return Shipment No." = '')
                THEN BEGIN
                  FromPurchInvLine.GET("Receipt No.","Return Shipment Line No.");
        
                  // copy item tracking
                  IF (Type = Type::Item) AND (Quantity <> 0) AND ("Prod. Order No." = '') THEN BEGIN
                    FromPurchInvLine."Document No." := OldInvDocNo;
                    FromPurchInvLine."Line No." := "Return Shipment Line No.";
                    FromPurchInvLine.GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
                    IF IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) THEN BEGIN
                      IF "Job No." <> '' THEN
                        ItemLedgEntryBuf.SETFILTER("Entry Type",'<> %1',ItemLedgEntryBuf."Entry Type"::"Negative Adjmt.");
                      IF MoveNegLines OR NOT ExactCostRevMandatory THEN
                        ItemTrackingMgt.CollectItemTrkgPerPstdDocLine(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                      ELSE BEGIN
                        TempItemTrkgEntry.RESET;
                        TempItemTrkgEntry.SETCURRENTKEY("Source ID","Source Ref. No.");
                        TempItemTrkgEntry.SETRANGE("Source ID","Document No.");
                        TempItemTrkgEntry.SETRANGE("Source Ref. No.","Line No.");
                        CollectItemTrkgPerPstDocLine(TempItemTrkgEntry,TempTrkgItemLedgEntry,TRUE);
                      END;
        
                      ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
                        TempTrkgItemLedgEntry,ToPurchLine,
                        FillExactCostRevLink AND ExactCostRevMandatory,
                        MissingExCostRevLink,FromPurchHeader."Prices Including VAT",
                        ToPurchHeader."Prices Including VAT",FALSE);
                    END;
                  END;
        
                  CopyPurchInvExtTextToDoc(
                    ToPurchHeader,ToPurchLine,FromPurchHeader."Language Code","Receipt No.",
                    "Return Shipment Line No.",NextLineNo,"Appl.-to Item Entry" <> 0);
                END;
              END;
            UNTIL NEXT = 0;
          END;
        END;
        
        Window.CLOSE;
        */

    end;

    local procedure CopyPurchInvExtTextToDoc(ToPurchHeader: Record "Purchase Header"; ToPurchLine: Record "Purchase Line"; FromLanguageCode: Code[10]; FromInvDocNo: Code[20]; FromInvDocLineNo: Integer; var NextLineNo: Integer; ExactCostReverse: Boolean);
    var
        ToPurchLine2: Record "Purchase Line";
        FromPurchInvLine: Record "Purch. Inv. Line";
    begin
        ToPurchLine2.SETRANGE("Document No.", ToPurchLine."Document No.");
        ToPurchLine2.SETRANGE("Attached to Line No.", ToPurchLine."Line No.");
        IF ToPurchLine2.ISEMPTY THEN
            WITH FromPurchInvLine DO BEGIN
                SETRANGE("Document No.", FromInvDocNo);
                SETRANGE("Attached to Line No.", FromInvDocLineNo);
                IF FINDSET THEN
                    REPEAT
                        IF (ToPurchHeader."Language Code" <> FromLanguageCode) OR
                           (RecalculateLines AND NOT ExactCostReverse)
                        THEN BEGIN
                            IF TransferExtendedText.PurchCheckIfAnyExtText(ToPurchLine, FALSE) THEN BEGIN
                                TransferExtendedText.InsertPurchExtText(ToPurchLine);
                                NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
                            END;
                        END ELSE BEGIN
                            CopyPurchExtTextLines(ToPurchLine2, ToPurchLine, Description, "Description 2", NextLineNo);
                            ToPurchLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            ToPurchLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                            ToPurchLine2."Dimension Set ID" := "Dimension Set ID";
                        END;
                    UNTIL NEXT = 0;
            END;
    end;

    procedure CopyPurchCrMemoLinesToDoc(ToPurchHeader: Record "Purchase Header"; var FromPurchCrMemoLine: Record "Purch. Cr. Memo Line"; var LinesNotCopied: Integer; var MissingExCostRevLink: Boolean);
    var
        ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromPurchHeader: Record "Purchase Header";
        FromPurchLine: Record "Purchase Line";
        FromPurchLine2: Record "Purchase Line";
        ToPurchLine: Record "Purchase Line";
        FromPurchLineBuf: Record "Purchase Line" temporary;
        FromPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldCrMemoDocNo: Code[20];
        OldReturnShptDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
    begin
        /*MissingExCostRevLink := FALSE;
        InitCurrency(ToPurchHeader."Currency Code");
        FromPurchLineBuf.RESET;
        FromPurchLineBuf.DELETEALL;
        TempItemTrkgEntry.RESET;
        TempItemTrkgEntry.DELETEALL;
        OpenWindow;
        
        // Fill purchase line buffer
        WITH FromPurchCrMemoLine DO
          IF FINDSET THEN
            REPEAT
              FromLineCounter := FromLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(1,FromLineCounter);
              IF FromPurchCrMemoHeader."No." <> "Document No." THEN BEGIN
                FromPurchCrMemoHeader.GET("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              END;
              FromPurchHeader.TRANSFERFIELDS(FromPurchCrMemoHeader);
              FillExactCostRevLink :=
                IsPurchFillExactCostRevLink(ToPurchHeader,3,FromPurchHeader."Currency Code");
              FromPurchLine.TRANSFERFIELDS(FromPurchCrMemoLine);
              FromPurchLine."Appl.-to Item Entry" := 0;
              // Reuse fields to buffer credit memo line information
              FromPurchLine."Receipt No." := "Document No.";
              FromPurchLine."Receipt Line No." := 0;
              FromPurchLine."Return Shipment No." := '';
              FromPurchLine."Return Shipment Line No." := "Line No.";
        
              SplitLine := TRUE;
              GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
              IF NOT SplitPstdPurchLinesPerILE(
                   ToPurchHeader,FromPurchHeader,ItemLedgEntryBuf,FromPurchLineBuf,
                   FromPurchLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,FALSE)
              THEN
                IF CopyItemTrkg THEN
                  SplitLine :=
                    SplitPurchDocLinesPerItemTrkg(
                      ItemLedgEntryBuf,TempItemTrkgEntry,FromPurchLineBuf,
                      FromPurchLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,FALSE)
                ELSE
                  SplitLine := FALSE;
        
              IF NOT SplitLine THEN BEGIN
                FromPurchLine2 := FromPurchLineBuf;
                FromPurchLineBuf := FromPurchLine;
                FromPurchLineBuf."Document No." := FromPurchLine2."Document No.";
                FromPurchLineBuf."Receipt Line No." := FromPurchLine2."Receipt Line No.";
                FromPurchLineBuf."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                IF NOT IsRecalculateAmount(
                     FromPurchHeader."Currency Code",ToPurchHeader."Currency Code",
                     FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT")
                THEN
                  FromPurchLineBuf."Return Shipment No." := "Document No.";
                ReCalcPurchLine(FromPurchHeader,ToPurchHeader,FromPurchLineBuf);
                FromPurchLineBuf.INSERT;
              END;
        
            UNTIL NEXT = 0;
        
        // Create purchase line from buffer
        Window.UPDATE(1,FromLineCounter);
        WITH FromPurchLineBuf DO BEGIN
          // Sorting according to Purchase Line Document No.,Line No.
          SETCURRENTKEY("Document Type","Document No.","Line No.");
          IF FINDSET THEN BEGIN
            NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
            REPEAT
              ToLineCounter := ToLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(2,ToLineCounter);
              IF "Receipt No." <> OldCrMemoDocNo THEN BEGIN
                OldCrMemoDocNo := "Receipt No.";
                OldReturnShptDocNo := '';
                InsertOldPurchDocNoLine(ToPurchHeader,OldCrMemoDocNo,4,NextLineNo);
              END;
              IF "Document No." <> OldReturnShptDocNo THEN BEGIN
                OldReturnShptDocNo := "Document No.";
                InsertOldPurchCombDocNoLine(ToPurchHeader,OldCrMemoDocNo,OldReturnShptDocNo,NextLineNo,FALSE);
              END;
        
              IF (Type <> Type::" ") OR ("Attached to Line No." = 0) THEN BEGIN
                // Empty buffer fields
                FromPurchLine2 := FromPurchLineBuf;
                FromPurchLine2."Receipt No." := '';
                FromPurchLine2."Receipt Line No." := 0;
                FromPurchLine2."Return Shipment No." := '';
                FromPurchLine2."Return Shipment Line No." := 0;
        
                IF CopyPurchLine(
                     ToPurchHeader,ToPurchLine,FromPurchHeader,
                     FromPurchLine2,NextLineNo,LinesNotCopied,"Return Shipment No." = '')
                THEN BEGIN
                  FromPurchCrMemoLine.GET("Receipt No.","Return Shipment Line No.");
        
                  // copy item tracking
                  IF (Type = Type::Item) AND (Quantity <> 0) AND ("Prod. Order No." = '') THEN BEGIN
                    FromPurchCrMemoLine."Document No." := OldCrMemoDocNo;
                    FromPurchCrMemoLine."Line No." := "Return Shipment Line No.";
                    FromPurchCrMemoLine.GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
                    IF IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) THEN BEGIN
                      IF "Job No." <> '' THEN
                        ItemLedgEntryBuf.SETFILTER("Entry Type",'<> %1',ItemLedgEntryBuf."Entry Type"::"Negative Adjmt.");
                      IF MoveNegLines OR NOT ExactCostRevMandatory THEN
                        ItemTrackingMgt.CollectItemTrkgPerPstdDocLine(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                      ELSE BEGIN
                        TempItemTrkgEntry.RESET;
                        TempItemTrkgEntry.SETCURRENTKEY("Source ID","Source Ref. No.");
                        TempItemTrkgEntry.SETRANGE("Source ID","Document No.");
                        TempItemTrkgEntry.SETRANGE("Source Ref. No.","Line No.");
                        CollectItemTrkgPerPstDocLine(TempItemTrkgEntry,TempTrkgItemLedgEntry,TRUE);
                      END;
        
                      ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
                        TempTrkgItemLedgEntry,ToPurchLine,
                        FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                        FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",FALSE);
                    END;
                  END;
        
                  CopyPurchInvExtTextToDoc(
                    ToPurchHeader,ToPurchLine,FromPurchHeader."Language Code","Receipt No.",
                    "Return Shipment Line No.",NextLineNo,"Appl.-to Item Entry" <> 0);
                END;
              END;
            UNTIL NEXT = 0;
          END;
        END;
        
        Window.CLOSE;
        */

    end;

    procedure CopyPurchReturnShptLinesToDoc(ToPurchHeader: Record "Purchase Header"; var FromReturnShptLine: Record "Return Shipment Line"; var LinesNotCopied: Integer; var MissingExCostRevLink: Boolean);
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromPurchHeader: Record "Purchase Header";
        FromPurchLine: Record "Purchase Line";
        ToPurchLine: Record "Purchase Line";
        FromPurchLineBuf: Record "Purchase Line" temporary;
        FromReturnShptHeader: Record "Return Shipment Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
        CopyLine: Boolean;
        InsertDocNoLine: Boolean;
    begin
        /*MissingExCostRevLink := FALSE;
        InitCurrency(ToPurchHeader."Currency Code");
        OpenWindow;
        
        WITH FromReturnShptLine DO
          IF FINDSET THEN
            REPEAT
              FromLineCounter := FromLineCounter + 1;
              IF IsTimeForUpdate THEN
                Window.UPDATE(1,FromLineCounter);
              IF FromReturnShptHeader."No." <> "Document No." THEN BEGIN
                FromReturnShptHeader.GET("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              END;
              FromPurchHeader.TRANSFERFIELDS(FromReturnShptHeader);
              FillExactCostRevLink :=
                IsPurchFillExactCostRevLink(ToPurchHeader,2,FromPurchHeader."Currency Code");
              FromPurchLine.TRANSFERFIELDS(FromReturnShptLine);
              FromPurchLine."Appl.-to Item Entry" := 0;
        
              IF "Document No." <> OldDocNo THEN BEGIN
                OldDocNo := "Document No.";
                InsertDocNoLine := TRUE;
              END;
        
              SplitLine := TRUE;
              FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
              IF NOT SplitPstdPurchLinesPerILE(
                   ToPurchHeader,FromPurchHeader,ItemLedgEntry,FromPurchLineBuf,
                   FromPurchLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,TRUE)
              THEN
                IF CopyItemTrkg THEN
                  SplitLine :=
                    SplitPurchDocLinesPerItemTrkg(
                      ItemLedgEntry,TempItemTrkgEntry,FromPurchLineBuf,
                      FromPurchLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,TRUE)
                ELSE
                  SplitLine := FALSE;
        
              IF NOT SplitLine THEN BEGIN
                FromPurchLineBuf := FromPurchLine;
                CopyLine := TRUE;
              END ELSE
                CopyLine := FromPurchLineBuf.FINDSET AND FillExactCostRevLink;
        
              Window.UPDATE(1,FromLineCounter);
              IF CopyLine THEN BEGIN
                NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
                IF InsertDocNoLine THEN BEGIN
                  InsertOldPurchDocNoLine(ToPurchHeader,"Document No.",3,NextLineNo);
                  InsertDocNoLine := FALSE;
                END;
                IF (FromPurchLineBuf.Type <> FromPurchLineBuf.Type::" ") OR
                   (FromPurchLineBuf."Attached to Line No." = 0)
                THEN
                  REPEAT
                    ToLineCounter := ToLineCounter + 1;
                    IF IsTimeForUpdate THEN
                      Window.UPDATE(2,ToLineCounter);
                    IF CopyPurchLine(
                         ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLineBuf,NextLineNo,LinesNotCopied,FALSE)
                    THEN BEGIN
                      IF CopyItemTrkg THEN BEGIN
                        IF SplitLine THEN BEGIN
                          TempItemTrkgEntry.RESET;
                          TempItemTrkgEntry.SETCURRENTKEY("Source ID","Source Ref. No.");
                          TempItemTrkgEntry.SETRANGE("Source ID",FromPurchLineBuf."Document No.");
                          TempItemTrkgEntry.SETRANGE("Source Ref. No.",FromPurchLineBuf."Line No.");
                          CollectItemTrkgPerPstDocLine(TempItemTrkgEntry,TempTrkgItemLedgEntry,TRUE);
                        END ELSE
                          ItemTrackingMgt.CollectItemTrkgPerPstdDocLine(TempTrkgItemLedgEntry,ItemLedgEntry);
        
                        ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
                          TempTrkgItemLedgEntry,ToPurchLine,
                          FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                          FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",TRUE);
                      END;
        
                      CopyPurchReturnShptExtTxtToDoc(
                        ToPurchHeader,ToPurchLine,FromReturnShptLine,FromPurchHeader."Language Code",
                        NextLineNo,FromPurchLineBuf."Appl.-to Item Entry" <> 0);
                    END;
                  UNTIL FromPurchLineBuf.NEXT = 0
              END;
            UNTIL NEXT = 0;
        
        Window.CLOSE;
        */

    end;

    local procedure CopyPurchReturnShptExtTxtToDoc(ToPurchHeader: Record "Purchase Header"; ToPurchLine: Record "Purchase Line"; FromReturnShptLine: Record "Return Shipment Line"; FromLanguageCode: Code[10]; var NextLineNo: Integer; ExactCostReverse: Boolean);
    var
        ToPurchLine2: Record "Purchase Line";
    begin
        ToPurchLine2.SETRANGE("Document No.", ToPurchLine."Document No.");
        ToPurchLine2.SETRANGE("Attached to Line No.", ToPurchLine."Line No.");
        IF ToPurchLine2.ISEMPTY THEN
            WITH FromReturnShptLine DO BEGIN
                SETRANGE("Document No.", "Document No.");
                SETRANGE("Attached to Line No.", "Line No.");
                IF FINDSET THEN
                    REPEAT
                        IF (ToPurchHeader."Language Code" <> FromLanguageCode) OR
                           (RecalculateLines AND NOT ExactCostReverse)
                        THEN BEGIN
                            IF TransferExtendedText.PurchCheckIfAnyExtText(ToPurchLine, FALSE) THEN BEGIN
                                TransferExtendedText.InsertPurchExtText(ToPurchLine);
                                NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
                            END;
                        END ELSE BEGIN
                            CopyPurchExtTextLines(
                              ToPurchLine2, ToPurchLine, Description, "Description 2", NextLineNo);
                            ToPurchLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            ToPurchLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                            ToPurchLine2."Dimension Set ID" := "Dimension Set ID";
                        END;
                    UNTIL NEXT = 0;
            END;
    end;

    local procedure SplitPstdPurchLinesPerILE(ToPurchHeader: Record "Purchase Header"; FromPurchHeader: Record "Purchase Header"; var ItemLedgEntry: Record "Item Ledger Entry"; var FromPurchLineBuf: Record "Purchase Line"; FromPurchLine: Record "Purchase Line"; var NextLineNo: Integer; var CopyItemTrkg: Boolean; var MissingExCostRevLink: Boolean; FillExactCostRevLink: Boolean; FromShptOrRcpt: Boolean): Boolean;
    var
        Item: Record Item;
        OrgQtyBase: Decimal;
        ApplyRec: Record "Item Application Entry";
    begin
        IF FromShptOrRcpt THEN BEGIN
            FromPurchLineBuf.RESET;
            FromPurchLineBuf.DELETEALL;
        END ELSE
            FromPurchLineBuf.INIT;

        CopyItemTrkg := FALSE;

        IF (FromPurchLine.Type <> FromPurchLine.Type::Item) OR (FromPurchLine.Quantity = 0) OR (FromPurchLine."Prod. Order No." <> '')
        THEN
            EXIT(FALSE);

        Item.GET(FromPurchLine."No.");
        IF Item.Type = Item.Type::Service THEN
            EXIT(FALSE);

        IF IsCopyItemTrkg(ItemLedgEntry, CopyItemTrkg, FillExactCostRevLink) OR
           NOT FillExactCostRevLink OR MoveNegLines OR
           NOT ExactCostRevMandatory
        THEN
            EXIT(FALSE);

        IF FromPurchLine."Job No." <> '' THEN
            EXIT(FALSE);

        WITH ItemLedgEntry DO BEGIN
            FINDSET;
            IF Quantity <= 0 THEN BEGIN
                FromPurchLineBuf."Document No." := "Document No.";
                IF GetPurchDocType(ItemLedgEntry) IN
                   [FromPurchLineBuf."Document Type"::Order, FromPurchLineBuf."Document Type"::"Return Order"]
                THEN
                    FromPurchLineBuf."Receipt Line No." := 1;
                EXIT(FALSE);
            END;
            OrgQtyBase := FromPurchLine."Quantity (Base)";
            REPEAT
                IF NOT ApplyFully THEN BEGIN
                    ApplyRec.AppliedOutbndEntryExists("Entry No.", FALSE, FALSE);
                    IF ApplyRec.FIND('-') THEN
                        SkippedLine := SkippedLine OR ApplyRec.FIND('-');
                END;
                IF ApplyFully THEN BEGIN
                    ApplyRec.AppliedOutbndEntryExists("Entry No.", FALSE, FALSE);
                    IF ApplyRec.FIND('-') THEN
                        REPEAT
                            SomeAreFixed := SomeAreFixed OR ApplyRec.Fixed;
                        UNTIL ApplyRec.NEXT = 0;
                END;

                IF AskApply AND ("Item Tracking" = "Item Tracking"::None) THEN
                    IF NOT ("Remaining Quantity" > 0) OR ("Item Tracking" <> "Item Tracking"::None) THEN
                        ConfirmApply;
                IF AskApply THEN
                    IF "Remaining Quantity" < ABS(FromPurchLine."Quantity (Base)") THEN
                        ConfirmApply;
                IF ("Remaining Quantity" > 0) OR ApplyFully THEN BEGIN
                    FromPurchLineBuf := FromPurchLine;
                    IF "Remaining Quantity" < ABS(FromPurchLine."Quantity (Base)") THEN BEGIN
                        IF NOT ApplyFully THEN BEGIN
                            IF FromPurchLine."Quantity (Base)" > 0 THEN
                                FromPurchLineBuf."Quantity (Base)" := "Remaining Quantity"
                            ELSE
                                FromPurchLineBuf."Quantity (Base)" := -"Remaining Quantity";
                            ConvertFromBase(
                              FromPurchLineBuf.Quantity, FromPurchLineBuf."Quantity (Base)", FromPurchLineBuf."Qty. per Unit of Measure");
                        END
                        ELSE BEGIN
                            ReappDone := TRUE;
                            FromPurchLineBuf."Quantity (Base)" := FromPurchLine."Quantity (Base)" - ApplyRec.Returned("Entry No.");
                            FromPurchLineBuf."Quantity (Base)" :=
                              Sign(Quantity) * Quantity - ApplyRec.Returned("Entry No.");
                            ConvertFromBase(
                              FromPurchLineBuf.Quantity, FromPurchLineBuf."Quantity (Base)", FromPurchLineBuf."Qty. per Unit of Measure");
                        END;
                    END;
                    FromPurchLine."Quantity (Base)" := FromPurchLine."Quantity (Base)" - FromPurchLineBuf."Quantity (Base)";
                    FromPurchLine.Quantity := FromPurchLine.Quantity - FromPurchLineBuf.Quantity;
                    FromPurchLineBuf."Appl.-to Item Entry" := "Entry No.";
                    FromPurchLineBuf."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    FromPurchLineBuf."Document No." := "Document No.";
                    IF GetPurchDocType(ItemLedgEntry) IN
                       [FromPurchLineBuf."Document Type"::Order, FromPurchLineBuf."Document Type"::"Return Order"]
                    THEN
                        FromPurchLineBuf."Receipt Line No." := 1;

                    IF NOT FromShptOrRcpt THEN
                        UpdateRevPurchLineAmount(
                          FromPurchLineBuf, OrgQtyBase,
                          FromPurchHeader."Prices Including VAT", ToPurchHeader."Prices Including VAT");
                    IF FromPurchLineBuf.Quantity <> 0 THEN
                        FromPurchLineBuf.INSERT
                    ELSE
                        SkippedLine := TRUE;
                END
                ELSE
                    IF "Remaining Quantity" = 0 THEN
                        SkippedLine := TRUE;
            UNTIL (NEXT = 0) OR (FromPurchLine."Quantity (Base)" = 0);

            IF (FromPurchLine."Quantity (Base)" <> 0) AND FillExactCostRevLink THEN
                MissingExCostRevLink := TRUE;
        END;
        CheckUnappliedLines(SkippedLine, MissingExCostRevLink);

        EXIT(TRUE);
    end;

    local procedure SplitPurchDocLinesPerItemTrkg(var ItemLedgEntry: Record "Item Ledger Entry"; var TempItemTrkgEntry: Record "Reservation Entry" temporary; var FromPurchLineBuf: Record "Purchase Line"; FromPurchLine: Record "Purchase Line"; var NextLineNo: Integer; var NextItemTrkgEntryNo: Integer; var MissingExCostRevLink: Boolean; FromShptOrRcpt: Boolean): Boolean;
    var
        PurchLineBuf: array[2] of Record "Purchase Line" temporary;
        RemainingQtyBase: Decimal;
        SignFactor: Integer;
        i: Integer;
        ApplyRec: Record "Item Application Entry";
    begin
        IF FromShptOrRcpt THEN BEGIN
            FromPurchLineBuf.RESET;
            FromPurchLineBuf.DELETEALL;
            TempItemTrkgEntry.RESET;
            TempItemTrkgEntry.DELETEALL;
        END ELSE
            FromPurchLineBuf.INIT;

        IF MoveNegLines OR NOT ExactCostRevMandatory THEN
            EXIT(FALSE);

        IF FromPurchLine."Quantity (Base)" < 0 THEN
            SignFactor := -1
        ELSE
            SignFactor := 1;

        WITH ItemLedgEntry DO BEGIN
            SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
            FINDSET;
            REPEAT
                PurchLineBuf[1] := FromPurchLine;
                PurchLineBuf[1]."Line No." := NextLineNo;
                PurchLineBuf[1]."Quantity (Base)" := 0;
                PurchLineBuf[1].Quantity := 0;
                PurchLineBuf[1]."Document No." := "Document No.";
                IF GetPurchDocType(ItemLedgEntry) IN
                   [PurchLineBuf[1]."Document Type"::Order, PurchLineBuf[1]."Document Type"::"Return Order"]
                THEN
                    PurchLineBuf[1]."Receipt Line No." := 1;
                PurchLineBuf[2] := PurchLineBuf[1];
                PurchLineBuf[2]."Line No." := PurchLineBuf[2]."Line No." + 1;

                IF NOT FromShptOrRcpt THEN BEGIN
                    SETRANGE("Document No.", "Document No.");
                    SETRANGE("Document Type", "Document Type");
                    SETRANGE("Document Line No.", "Document Line No.");
                END;
                REPEAT
                    i := 1;
                    IF Positive THEN
                        "Remaining Quantity" :=
                          "Remaining Quantity" -
                          CalcDistributedQty(TempItemTrkgEntry, ItemLedgEntry, PurchLineBuf[2]."Line No." + 1);

                    IF "Document Type" IN ["Document Type"::"Purchase Return Shipment", "Document Type"::"Purchase Credit Memo"] THEN
                        IF -"Shipped Qty. Not Returned" < FromPurchLine."Quantity (Base)" * SignFactor THEN
                            RemainingQtyBase := -"Shipped Qty. Not Returned" * SignFactor
                        ELSE
                            RemainingQtyBase := FromPurchLine."Quantity (Base)"
                    ELSE
                        IF "Remaining Quantity" < FromPurchLine."Quantity (Base)" * SignFactor THEN BEGIN
                            IF ("Item Tracking" = "Item Tracking"::None) AND AskApply THEN
                                ConfirmApply;
                            IF (NOT ApplyFully) OR ("Item Tracking" <> "Item Tracking"::None) THEN
                                RemainingQtyBase := GetQtyOfPurchILENotShipped("Entry No.") * SignFactor
                            ELSE
                                RemainingQtyBase := FromPurchLine."Quantity (Base)" - ApplyRec.Returned("Entry No.");
                        END ELSE
                            RemainingQtyBase := FromPurchLine."Quantity (Base)";

                    IF RemainingQtyBase <> 0 THEN BEGIN
                        IF Positive THEN
                            IF IsSplitItemLedgEntry(ItemLedgEntry) THEN
                                i := 2;

                        PurchLineBuf[i]."Quantity (Base)" := PurchLineBuf[i]."Quantity (Base)" + RemainingQtyBase;
                        IF PurchLineBuf[i]."Qty. per Unit of Measure" = 0 THEN
                            PurchLineBuf[i].Quantity := PurchLineBuf[i]."Quantity (Base)"
                        ELSE
                            PurchLineBuf[i].Quantity :=
                              ROUND(PurchLineBuf[i]."Quantity (Base)" / PurchLineBuf[i]."Qty. per Unit of Measure", 0.00001);
                        FromPurchLine."Quantity (Base)" := FromPurchLine."Quantity (Base)" - RemainingQtyBase;
                        // Fill buffer with exact cost reversing link for remaining quantity
                        IF "Document Type" IN ["Document Type"::"Purchase Return Shipment", "Document Type"::"Purchase Credit Memo"] THEN
                            InsertTempItemTrkgEntry(
                              ItemLedgEntry, TempItemTrkgEntry, -ABS(RemainingQtyBase),
                              PurchLineBuf[i]."Line No.", NextItemTrkgEntryNo, TRUE)
                        ELSE
                            InsertTempItemTrkgEntry(
                              ItemLedgEntry, TempItemTrkgEntry, ABS(RemainingQtyBase),
                              PurchLineBuf[i]."Line No.", NextItemTrkgEntryNo, TRUE);
                    END;
                UNTIL (NEXT = 0) OR (FromPurchLine."Quantity (Base)" = 0);

                FOR i := 1 TO 2 DO
                    IF PurchLineBuf[i]."Quantity (Base)" <> 0 THEN BEGIN
                        FromPurchLineBuf := PurchLineBuf[i];
                        FromPurchLineBuf.INSERT;
                        NextLineNo := PurchLineBuf[i]."Line No." + 1;
                    END;

                IF NOT FromShptOrRcpt THEN BEGIN
                    SETRANGE("Document No.");
                    SETRANGE("Document Type");
                    SETRANGE("Document Line No.");
                END;
            UNTIL (NEXT = 0) OR FromShptOrRcpt;
            IF (FromPurchLine."Quantity (Base)" <> 0) AND Positive AND TempItemTrkgEntry.ISEMPTY THEN
                MissingExCostRevLink := TRUE;
        END;

        EXIT(TRUE);
    end;

    local procedure CalcDistributedQty(var TempItemTrkgEntry: Record "Reservation Entry" temporary; ItemLedgEntry: Record "Item Ledger Entry"; NextLineNo: Integer): Decimal;
    begin
        WITH ItemLedgEntry DO BEGIN
            TempItemTrkgEntry.RESET;
            TempItemTrkgEntry.SETCURRENTKEY("Source ID", "Source Ref. No.");
            TempItemTrkgEntry.SETRANGE("Source ID", "Document No.");
            TempItemTrkgEntry.SETFILTER("Source Ref. No.", '<%1', NextLineNo);
            TempItemTrkgEntry.SETRANGE("Item Ledger Entry No.", "Entry No.");
            TempItemTrkgEntry.CALCSUMS("Quantity (Base)");
            TempItemTrkgEntry.RESET;
            EXIT(TempItemTrkgEntry."Quantity (Base)");
        END;
    end;

    local procedure IsSplitItemLedgEntry(OrgItemLedgEntry: Record "Item Ledger Entry"): Boolean;
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        WITH OrgItemLedgEntry DO BEGIN
            ItemLedgEntry.SETCURRENTKEY("Document No.");
            ItemLedgEntry.SETRANGE("Document No.", "Document No.");
            ItemLedgEntry.SETRANGE("Document Type", "Document Type");
            ItemLedgEntry.SETRANGE("Document Line No.", "Document Line No.");
            ItemLedgEntry.SETRANGE("Lot No.", "Lot No.");
            ItemLedgEntry.SETRANGE("Serial No.", "Serial No.");
            ItemLedgEntry.SETFILTER("Entry No.", '<%1', "Entry No.");
            EXIT(NOT ItemLedgEntry.ISEMPTY);
        END;
    end;

    local procedure IsCopyItemTrkg(var ItemLedgEntry: Record "Item Ledger Entry"; var CopyItemTrkg: Boolean; FillExactCostRevLink: Boolean): Boolean;
    begin
        WITH ItemLedgEntry DO BEGIN
            IF ISEMPTY THEN
                EXIT(TRUE);
            SETFILTER("Lot No.", '<>''''');
            IF NOT ISEMPTY THEN BEGIN
                IF FillExactCostRevLink THEN
                    CopyItemTrkg := TRUE;
                EXIT(TRUE);
            END;
            SETRANGE("Lot No.");
            SETFILTER("Serial No.", '<>''''');
            IF NOT ISEMPTY THEN BEGIN
                IF FillExactCostRevLink THEN
                    CopyItemTrkg := TRUE;
                EXIT(TRUE);
            END;
            SETRANGE("Serial No.");
        END;
        EXIT(FALSE);
    end;

    procedure InsertTempItemTrkgEntry(ItemLedgEntry: Record "Item Ledger Entry"; var TempItemTrkgEntry: Record "Reservation Entry"; QtyBase: Decimal; DocLineNo: Integer; var NextEntryNo: Integer; FillExactCostRevLink: Boolean);
    begin
        IF QtyBase = 0 THEN
            EXIT;

        WITH ItemLedgEntry DO BEGIN
            TempItemTrkgEntry.INIT;
            TempItemTrkgEntry."Entry No." := NextEntryNo;
            NextEntryNo := NextEntryNo + 1;
            IF NOT FillExactCostRevLink THEN
                TempItemTrkgEntry."Reservation Status" := TempItemTrkgEntry."Reservation Status"::Prospect;
            TempItemTrkgEntry."Source ID" := "Document No.";
            TempItemTrkgEntry."Source Ref. No." := DocLineNo;
            TempItemTrkgEntry."Item Ledger Entry No." := "Entry No.";
            TempItemTrkgEntry."Quantity (Base)" := QtyBase;
            TempItemTrkgEntry.INSERT;
        END;
    end;

    procedure CollectItemTrkgPerPstDocLine(var TempItemTrkgEntry: Record "Reservation Entry" temporary; var TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary; FromPurchase: Boolean);
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        TempTrkgItemLedgEntry.RESET;
        TempTrkgItemLedgEntry.DELETEALL;

        WITH TempItemTrkgEntry DO
            IF FINDSET THEN
                REPEAT
                    ItemLedgEntry.GET("Item Ledger Entry No.");
                    TempTrkgItemLedgEntry := ItemLedgEntry;
                    IF "Reservation Status" = "Reservation Status"::Prospect THEN
                        TempTrkgItemLedgEntry."Entry No." := -TempTrkgItemLedgEntry."Entry No.";
                    IF FromPurchase THEN
                        TempTrkgItemLedgEntry."Remaining Quantity" := "Quantity (Base)"
                    ELSE
                        TempTrkgItemLedgEntry."Shipped Qty. Not Returned" := "Quantity (Base)";
                    TempTrkgItemLedgEntry."Document No." := "Source ID";
                    TempTrkgItemLedgEntry."Document Line No." := "Source Ref. No.";
                    TempTrkgItemLedgEntry.INSERT;
                UNTIL NEXT = 0;
    end;

    local procedure GetLastToSalesLineNo(ToSalesHeader: Record "Sales Header"): Decimal;
    var
        ToSalesLine: Record "Sales Line";
    begin
        ToSalesLine.LOCKTABLE;
        ToSalesLine.SETRANGE("Document Type", ToSalesHeader."Document Type");
        ToSalesLine.SETRANGE("Document No.", ToSalesHeader."No.");
        IF ToSalesLine.FINDLAST THEN
            EXIT(ToSalesLine."Line No.");
        EXIT(0);
    end;

    local procedure GetLastToPurchLineNo(ToPurchHeader: Record "Purchase Header"): Decimal;
    var
        ToPurchLine: Record "Purchase Line";
    begin
        ToPurchLine.LOCKTABLE;
        ToPurchLine.SETRANGE("Document Type", ToPurchHeader."Document Type");
        ToPurchLine.SETRANGE("Document No.", ToPurchHeader."No.");
        IF ToPurchLine.FINDLAST THEN
            EXIT(ToPurchLine."Line No.");
        EXIT(0);
    end;

    local procedure CopySalesExtTextLines(var ToSalesLine2: Record "Sales Line"; ToSalesLine: Record "Sales Line"; Description: Text[50]; Description2: Text[50]; var NextLineNo: Integer);
    begin
        NextLineNo := NextLineNo + 10000;
        ToSalesLine2.INIT;
        ToSalesLine2."Line No." := NextLineNo;
        ToSalesLine2."Document Type" := ToSalesLine."Document Type";
        ToSalesLine2."Document No." := ToSalesLine."Document No.";
        ToSalesLine2.Description := Description;
        ToSalesLine2."Description 2" := Description2;
        ToSalesLine2."Attached to Line No." := ToSalesLine."Line No.";
        ToSalesLine2.INSERT;
    end;

    local procedure CopyPurchExtTextLines(var ToPurchLine2: Record "Purchase Line"; ToPurchLine: Record "Purchase Line"; Description: Text[50]; Description2: Text[50]; var NextLineNo: Integer);
    begin
        NextLineNo := NextLineNo + 10000;
        ToPurchLine2.INIT;
        ToPurchLine2."Line No." := NextLineNo;
        ToPurchLine2."Document Type" := ToPurchLine."Document Type";
        ToPurchLine2."Document No." := ToPurchLine."Document No.";
        ToPurchLine2.Description := Description;
        ToPurchLine2."Description 2" := Description2;
        ToPurchLine2."Attached to Line No." := ToPurchLine."Line No.";
        ToPurchLine2.INSERT;
    end;

    local procedure InsertOldSalesDocNoLine(ToSalesHeader: Record "Sales Header"; OldDocNo: Code[20]; OldDocType: Integer; var NextLineNo: Integer);
    var
        ToSalesLine2: Record "Sales Line";
    begin
        IF SkipCopyFromDescription THEN
            EXIT;

        NextLineNo := NextLineNo + 10000;
        ToSalesLine2.INIT;
        ToSalesLine2."Line No." := NextLineNo;
        ToSalesLine2."Document Type" := ToSalesHeader."Document Type";
        ToSalesLine2."Document No." := ToSalesHeader."No.";
        ToSalesLine2.Description := STRSUBSTNO(Text015, SELECTSTR(OldDocType, Text013), OldDocNo);
        ToSalesLine2.INSERT;
    end;

    local procedure InsertOldSalesCombDocNoLine(ToSalesHeader: Record "Sales Header"; OldDocNo: Code[20]; OldDocNo2: Code[20]; var NextLineNo: Integer; CopyFromInvoice: Boolean);
    var
        ToSalesLine2: Record "Sales Line";
    begin
        NextLineNo := NextLineNo + 10000;
        ToSalesLine2.INIT;
        ToSalesLine2."Line No." := NextLineNo;
        ToSalesLine2."Document Type" := ToSalesHeader."Document Type";
        ToSalesLine2."Document No." := ToSalesHeader."No.";
        IF CopyFromInvoice THEN
            ToSalesLine2.Description :=
              STRSUBSTNO(
                Text018,
                COPYSTR(SELECTSTR(1, Text016) + OldDocNo, 1, 23),
                COPYSTR(SELECTSTR(2, Text016) + OldDocNo2, 1, 23))
        ELSE
            ToSalesLine2.Description :=
              STRSUBSTNO(
                Text018,
                COPYSTR(SELECTSTR(3, Text016) + OldDocNo, 1, 23),
                COPYSTR(SELECTSTR(4, Text016) + OldDocNo2, 1, 23));
        ToSalesLine2.INSERT;
    end;

    local procedure InsertOldPurchDocNoLine(ToPurchHeader: Record "Purchase Header"; OldDocNo: Code[20]; OldDocType: Integer; var NextLineNo: Integer);
    var
        ToPurchLine2: Record "Purchase Line";
    begin
        IF SkipCopyFromDescription THEN
            EXIT;

        NextLineNo := NextLineNo + 10000;
        ToPurchLine2.INIT;
        ToPurchLine2."Line No." := NextLineNo;
        ToPurchLine2."Document Type" := ToPurchHeader."Document Type";
        ToPurchLine2."Document No." := ToPurchHeader."No.";
        ToPurchLine2.Description := STRSUBSTNO(Text015, SELECTSTR(OldDocType, Text014), OldDocNo);
        ToPurchLine2.INSERT;
    end;

    local procedure InsertOldPurchCombDocNoLine(ToPurchHeader: Record "Purchase Header"; OldDocNo: Code[20]; OldDocNo2: Code[20]; var NextLineNo: Integer; CopyFromInvoice: Boolean);
    var
        ToPurchLine2: Record "Purchase Line";
    begin
        NextLineNo := NextLineNo + 10000;
        ToPurchLine2.INIT;
        ToPurchLine2."Line No." := NextLineNo;
        ToPurchLine2."Document Type" := ToPurchHeader."Document Type";
        ToPurchLine2."Document No." := ToPurchHeader."No.";
        IF CopyFromInvoice THEN
            ToPurchLine2.Description :=
              STRSUBSTNO(
                Text018,
                COPYSTR(SELECTSTR(1, Text017) + OldDocNo, 1, 23),
                COPYSTR(SELECTSTR(2, Text017) + OldDocNo2, 1, 23))
        ELSE
            ToPurchLine2.Description :=
              STRSUBSTNO(
                Text018,
                COPYSTR(SELECTSTR(3, Text017) + OldDocNo, 1, 23),
                COPYSTR(SELECTSTR(4, Text017) + OldDocNo2, 1, 23));
        ToPurchLine2.INSERT;
    end;

    procedure IsSalesFillExactCostRevLink(ToSalesHeader: Record "Sales Header"; FromDocType: Option "Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo"; CurrencyCode: Code[10]): Boolean;
    begin
        WITH ToSalesHeader DO
            CASE FromDocType OF
                FromDocType::"Sales Shipment":
                    EXIT("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]);
                FromDocType::"Sales Invoice":
                    EXIT(
                      ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) AND
                      ("Currency Code" = CurrencyCode));
                FromDocType::"Sales Return Receipt":
                    EXIT("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]);
                FromDocType::"Sales Credit Memo":
                    EXIT(
                      ("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]) AND
                      ("Currency Code" = CurrencyCode));
            END;
        EXIT(FALSE);
    end;

    procedure IsPurchFillExactCostRevLink(ToPurchHeader: Record "Purchase Header"; FromDocType: Option "Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo"; CurrencyCode: Code[10]): Boolean;
    begin
        WITH ToPurchHeader DO
            CASE FromDocType OF
                FromDocType::"Purchase Receipt":
                    EXIT("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]);
                FromDocType::"Purchase Invoice":
                    EXIT(
                      ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) AND
                      ("Currency Code" = CurrencyCode));
                FromDocType::"Purchase Return Shipment":
                    EXIT("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]);
                FromDocType::"Purchase Credit Memo":
                    EXIT(
                      ("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]) AND
                      ("Currency Code" = CurrencyCode));
            END;
        EXIT(FALSE);
    end;

    local procedure GetSalesDocType(ItemLedgEntry: Record "Item Ledger Entry"): Integer;
    var
        SalesLine: Record "Sales Line";
    begin
        WITH ItemLedgEntry DO
            CASE "Document Type" OF
                "Document Type"::"Sales Shipment":
                    EXIT(SalesLine."Document Type"::Order);
                "Document Type"::"Sales Invoice":
                    EXIT(SalesLine."Document Type"::Invoice);
                "Document Type"::"Sales Credit Memo":
                    EXIT(SalesLine."Document Type"::"Credit Memo");
                "Document Type"::"Sales Return Receipt":
                    EXIT(SalesLine."Document Type"::"Return Order");
            END;
    end;

    local procedure GetPurchDocType(ItemLedgEntry: Record "Item Ledger Entry"): Integer;
    var
        PurchLine: Record "Purchase Line";
    begin
        WITH ItemLedgEntry DO
            CASE "Document Type" OF
                "Document Type"::"Purchase Receipt":
                    EXIT(PurchLine."Document Type"::Order);
                "Document Type"::"Purchase Invoice":
                    EXIT(PurchLine."Document Type"::Invoice);
                "Document Type"::"Purchase Credit Memo":
                    EXIT(PurchLine."Document Type"::"Credit Memo");
                "Document Type"::"Purchase Return Shipment":
                    EXIT(PurchLine."Document Type"::"Return Order");
            END;
    end;

    local procedure GetItem(ItemNo: Code[20]);
    begin
        IF ItemNo <> Item."No." THEN
            IF NOT Item.GET(ItemNo) THEN
                Item.INIT;
    end;

    procedure CalcVAT(var Value: Decimal; VATPercentage: Decimal; FromPricesInclVAT: Boolean; ToPricesInclVAT: Boolean; RndgPrecision: Decimal);
    begin
        IF (ToPricesInclVAT = FromPricesInclVAT) OR (Value = 0) THEN
            EXIT;

        IF ToPricesInclVAT THEN
            Value := ROUND(Value * (100 + VATPercentage) / 100, RndgPrecision)
        ELSE
            Value := ROUND(Value * 100 / (100 + VATPercentage), RndgPrecision);
    end;

    local procedure ReCalcSalesLine(FromSalesHeader: Record "Sales Header"; ToSalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line");
    var
        CurrExchRate: Record "Currency Exchange Rate";
        SalesLineAmount: Decimal;
    begin
        WITH ToSalesHeader DO BEGIN
            IF NOT IsRecalculateAmount(
                 FromSalesHeader."Currency Code", "Currency Code",
                 FromSalesHeader."Prices Including VAT", "Prices Including VAT")
            THEN
                EXIT;

            IF FromSalesHeader."Currency Code" <> "Currency Code" THEN BEGIN
                IF SalesLine.Quantity <> 0 THEN
                    SalesLineAmount := SalesLine."Unit Price" * SalesLine.Quantity
                ELSE
                    SalesLineAmount := SalesLine."Unit Price";
                IF FromSalesHeader."Currency Code" <> '' THEN BEGIN
                    SalesLineAmount :=
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        FromSalesHeader."Posting Date", FromSalesHeader."Currency Code",
                        SalesLineAmount, FromSalesHeader."Currency Factor");
                    SalesLine."Line Discount Amount" :=
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        FromSalesHeader."Posting Date", FromSalesHeader."Currency Code",
                        SalesLine."Line Discount Amount", FromSalesHeader."Currency Factor");
                    SalesLine."Inv. Discount Amount" :=
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        FromSalesHeader."Posting Date", FromSalesHeader."Currency Code",
                        SalesLine."Inv. Discount Amount", FromSalesHeader."Currency Factor");
                END;

                IF "Currency Code" <> '' THEN BEGIN
                    SalesLineAmount :=
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Posting Date", "Currency Code", SalesLineAmount, "Currency Factor");
                    SalesLine."Line Discount Amount" :=
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Posting Date", "Currency Code", SalesLine."Line Discount Amount", "Currency Factor");
                    SalesLine."Inv. Discount Amount" :=
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Posting Date", "Currency Code", SalesLine."Inv. Discount Amount", "Currency Factor");
                END;
            END;

            SalesLine."Currency Code" := "Currency Code";
            IF SalesLine.Quantity <> 0 THEN BEGIN
                SalesLineAmount := ROUND(SalesLineAmount, Currency."Amount Rounding Precision");
                SalesLine."Unit Price" := ROUND(SalesLineAmount / SalesLine.Quantity, Currency."Unit-Amount Rounding Precision");
            END ELSE
                SalesLine."Unit Price" := ROUND(SalesLineAmount, Currency."Unit-Amount Rounding Precision");
            SalesLine."Line Discount Amount" := ROUND(SalesLine."Line Discount Amount", Currency."Amount Rounding Precision");
            SalesLine."Inv. Discount Amount" := ROUND(SalesLine."Inv. Discount Amount", Currency."Amount Rounding Precision");

            CalcVAT(
              SalesLine."Unit Price", SalesLine."VAT %", FromSalesHeader."Prices Including VAT",
              "Prices Including VAT", Currency."Unit-Amount Rounding Precision");
            CalcVAT(
              SalesLine."Line Discount Amount", SalesLine."VAT %", FromSalesHeader."Prices Including VAT",
              "Prices Including VAT", Currency."Amount Rounding Precision");
            CalcVAT(
              SalesLine."Inv. Discount Amount", SalesLine."VAT %", FromSalesHeader."Prices Including VAT",
              "Prices Including VAT", Currency."Amount Rounding Precision");
        END;
    end;

    local procedure ReCalcPurchLine(FromPurchHeader: Record "Purchase Header"; ToPurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line");
    var
        CurrExchRate: Record "Currency Exchange Rate";
        PurchLineAmount: Decimal;
    begin
        WITH ToPurchHeader DO BEGIN
            IF NOT IsRecalculateAmount(
                 FromPurchHeader."Currency Code", "Currency Code",
                 FromPurchHeader."Prices Including VAT", "Prices Including VAT")
            THEN
                EXIT;

            IF FromPurchHeader."Currency Code" <> "Currency Code" THEN BEGIN
                IF PurchLine.Quantity <> 0 THEN
                    PurchLineAmount := PurchLine."Direct Unit Cost" * PurchLine.Quantity
                ELSE
                    PurchLineAmount := PurchLine."Direct Unit Cost";
                IF FromPurchHeader."Currency Code" <> '' THEN BEGIN
                    PurchLineAmount :=
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        FromPurchHeader."Posting Date", FromPurchHeader."Currency Code",
                        PurchLineAmount, FromPurchHeader."Currency Factor");
                    PurchLine."Line Discount Amount" :=
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        FromPurchHeader."Posting Date", FromPurchHeader."Currency Code",
                        PurchLine."Line Discount Amount", FromPurchHeader."Currency Factor");
                    PurchLine."Inv. Discount Amount" :=
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        FromPurchHeader."Posting Date", FromPurchHeader."Currency Code",
                        PurchLine."Inv. Discount Amount", FromPurchHeader."Currency Factor");
                END;

                IF "Currency Code" <> '' THEN BEGIN
                    PurchLineAmount :=
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Posting Date", "Currency Code", PurchLineAmount, "Currency Factor");
                    PurchLine."Line Discount Amount" :=
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Posting Date", "Currency Code", PurchLine."Line Discount Amount", "Currency Factor");
                    PurchLine."Inv. Discount Amount" :=
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        "Posting Date", "Currency Code", PurchLine."Inv. Discount Amount", "Currency Factor");
                END;
            END;

            PurchLine."Currency Code" := "Currency Code";
            IF PurchLine.Quantity <> 0 THEN BEGIN
                PurchLineAmount := ROUND(PurchLineAmount, Currency."Amount Rounding Precision");
                PurchLine."Direct Unit Cost" := ROUND(PurchLineAmount / PurchLine.Quantity, Currency."Unit-Amount Rounding Precision");
            END ELSE
                PurchLine."Direct Unit Cost" := ROUND(PurchLineAmount, Currency."Unit-Amount Rounding Precision");
            PurchLine."Line Discount Amount" := ROUND(PurchLine."Line Discount Amount", Currency."Amount Rounding Precision");
            PurchLine."Inv. Discount Amount" := ROUND(PurchLine."Inv. Discount Amount", Currency."Amount Rounding Precision");

            CalcVAT(
              PurchLine."Direct Unit Cost", PurchLine."VAT %", FromPurchHeader."Prices Including VAT",
              "Prices Including VAT", Currency."Unit-Amount Rounding Precision");
            CalcVAT(
              PurchLine."Line Discount Amount", PurchLine."VAT %", FromPurchHeader."Prices Including VAT",
              "Prices Including VAT", Currency."Amount Rounding Precision");
            CalcVAT(
              PurchLine."Inv. Discount Amount", PurchLine."VAT %", FromPurchHeader."Prices Including VAT",
              "Prices Including VAT", Currency."Amount Rounding Precision");
        END;
    end;

    local procedure IsRecalculateAmount(FromCurrencyCode: Code[10]; ToCurrencyCode: Code[10]; FromPricesInclVAT: Boolean; ToPricesInclVAT: Boolean): Boolean;
    begin
        EXIT(
          (FromCurrencyCode <> ToCurrencyCode) OR
          (FromPricesInclVAT <> ToPricesInclVAT));
    end;

    procedure UpdateRevSalesLineAmount(var SalesLine: Record "Sales Line"; OrgQtyBase: Decimal; FromPricesInclVAT: Boolean; ToPricesInclVAT: Boolean);
    var
        Amount: Decimal;
    begin
        IF (OrgQtyBase = 0) OR (SalesLine.Quantity = 0) THEN
            EXIT;

        Amount := SalesLine.Quantity * SalesLine."Unit Price";
        CalcVAT(
          Amount, SalesLine."VAT %", FromPricesInclVAT, ToPricesInclVAT, Currency."Amount Rounding Precision");
        SalesLine."Unit Price" := Amount / SalesLine.Quantity;
        SalesLine."Line Discount Amount" :=
          ROUND(
            ROUND(SalesLine.Quantity * SalesLine."Unit Price", Currency."Amount Rounding Precision") *
            SalesLine."Line Discount %" / 100,
            Currency."Amount Rounding Precision");
        Amount :=
          ROUND(SalesLine."Inv. Discount Amount" / OrgQtyBase * SalesLine."Quantity (Base)", Currency."Amount Rounding Precision");
        CalcVAT(
          Amount, SalesLine."VAT %", FromPricesInclVAT, ToPricesInclVAT, Currency."Amount Rounding Precision");
        SalesLine."Inv. Discount Amount" := Amount;
    end;

    procedure CalculateRevSalesLineAmount(var SalesLine: Record "Sales Line"; OrgQtyBase: Decimal; FromPricesInclVAT: Boolean; ToPricesInclVAT: Boolean);
    var
        UnitPrice: Decimal;
        LineDiscAmt: Decimal;
        InvDiscAmt: Decimal;
    begin
        UpdateRevSalesLineAmount(SalesLine, OrgQtyBase, FromPricesInclVAT, ToPricesInclVAT);

        UnitPrice := SalesLine."Unit Price";
        LineDiscAmt := SalesLine."Line Discount Amount";
        InvDiscAmt := SalesLine."Inv. Discount Amount";

        SalesLine.VALIDATE("Unit Price", UnitPrice);
        SalesLine.VALIDATE("Line Discount Amount", LineDiscAmt);
        SalesLine.VALIDATE("Inv. Discount Amount", InvDiscAmt);
    end;

    procedure UpdateRevPurchLineAmount(var PurchLine: Record "Purchase Line"; OrgQtyBase: Decimal; FromPricesInclVAT: Boolean; ToPricesInclVAT: Boolean);
    var
        Amount: Decimal;
    begin
        IF (OrgQtyBase = 0) OR (PurchLine.Quantity = 0) THEN
            EXIT;

        Amount := PurchLine.Quantity * PurchLine."Direct Unit Cost";
        CalcVAT(
          Amount, PurchLine."VAT %", FromPricesInclVAT, ToPricesInclVAT, Currency."Amount Rounding Precision");
        PurchLine."Direct Unit Cost" := Amount / PurchLine.Quantity;
        PurchLine."Line Discount Amount" :=
          ROUND(
            ROUND(PurchLine.Quantity * PurchLine."Direct Unit Cost", Currency."Amount Rounding Precision") *
            PurchLine."Line Discount %" / 100,
            Currency."Amount Rounding Precision");
        Amount :=
          ROUND(PurchLine."Inv. Discount Amount" / OrgQtyBase * PurchLine."Quantity (Base)", Currency."Amount Rounding Precision");
        CalcVAT(
          Amount, PurchLine."VAT %", FromPricesInclVAT, ToPricesInclVAT, Currency."Amount Rounding Precision");
        PurchLine."Inv. Discount Amount" := Amount;
    end;

    procedure CalculateRevPurchLineAmount(var PurchLine: Record "Purchase Line"; OrgQtyBase: Decimal; FromPricesInclVAT: Boolean; ToPricesInclVAT: Boolean);
    var
        DirectUnitCost: Decimal;
        LineDiscAmt: Decimal;
        InvDiscAmt: Decimal;
    begin
        UpdateRevPurchLineAmount(PurchLine, OrgQtyBase, FromPricesInclVAT, ToPricesInclVAT);

        DirectUnitCost := PurchLine."Direct Unit Cost";
        LineDiscAmt := PurchLine."Line Discount Amount";
        InvDiscAmt := PurchLine."Inv. Discount Amount";

        PurchLine.VALIDATE("Direct Unit Cost", DirectUnitCost);
        PurchLine.VALIDATE("Line Discount Amount", LineDiscAmt);
        PurchLine.VALIDATE("Inv. Discount Amount", InvDiscAmt);
    end;

    local procedure InitCurrency(CurrencyCode: Code[10]);
    begin
        IF CurrencyCode <> '' THEN
            Currency.GET(CurrencyCode)
        ELSE
            Currency.InitRoundingPrecision;

        Currency.TESTFIELD("Unit-Amount Rounding Precision");
        Currency.TESTFIELD("Amount Rounding Precision");
    end;

    local procedure OpenWindow();
    begin
        Window.OPEN(
          Text022 +
          Text023 +
          Text024);
        WindowUpdateDateTime := CURRENTDATETIME;
    end;

    local procedure IsTimeForUpdate(): Boolean;
    begin
        IF CURRENTDATETIME - WindowUpdateDateTime >= 1000 THEN BEGIN
            WindowUpdateDateTime := CURRENTDATETIME;
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;

    procedure ConfirmApply();
    begin
        AskApply := FALSE;
        ApplyFully := FALSE;
    end;

    procedure ConvertFromBase(var Quantity: Decimal; "Quantity (Base)": Decimal; "Qty. per Unit of Measure": Decimal);
    begin
        IF "Qty. per Unit of Measure" = 0 THEN
            Quantity := "Quantity (Base)"
        ELSE
            Quantity :=
              ROUND("Quantity (Base)" / "Qty. per Unit of Measure", 0.00001);
    end;

    procedure Sign(Quantity: Decimal): Decimal;
    begin
        IF Quantity < 0 THEN
            EXIT(-1);
        EXIT(1);
    end;

    procedure ShowMessageReapply(OriginalQuantity: Boolean);
    var
        Text: Text[1024];
    begin
        Text := '';
        IF SkippedLine THEN
            Text := Text029;
        IF OriginalQuantity AND ReappDone THEN
            IF Text = '' THEN
                Text := Text025;
        IF SomeAreFixed THEN
            MESSAGE(Text031);
        IF Text <> '' THEN
            MESSAGE(Text);
    end;

    local procedure LinkJobPlanningLine(SalesHeader: Record "Sales Header");
    var
        SalesLine: Record "Sales Line";
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
    begin
        JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        REPEAT
            JobPlanningLine.SETRANGE("Job Contract Entry No.", SalesLine."Job Contract Entry No.");
            IF JobPlanningLine.FINDFIRST THEN BEGIN
                JobPlanningLineInvoice."Job No." := JobPlanningLine."Job No.";
                JobPlanningLineInvoice."Job Task No." := JobPlanningLine."Job Task No.";
                JobPlanningLineInvoice."Job Planning Line No." := JobPlanningLine."Line No.";
                CASE SalesHeader."Document Type" OF
                    SalesHeader."Document Type"::Invoice:
                        BEGIN
                            JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."Document Type"::Invoice;
                            JobPlanningLineInvoice."Quantity Transferred" := SalesLine.Quantity;
                        END;
                    SalesHeader."Document Type"::"Credit Memo":
                        BEGIN
                            JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."Document Type"::"Credit Memo";
                            JobPlanningLineInvoice."Quantity Transferred" := -SalesLine.Quantity;
                        END;
                    ELSE
                        EXIT;
                END;
                JobPlanningLineInvoice."Document No." := SalesHeader."No.";
                JobPlanningLineInvoice."Line No." := SalesLine."Line No.";
                JobPlanningLineInvoice."Transferred Date" := SalesHeader."Posting Date";
                JobPlanningLineInvoice.INSERT;

                JobPlanningLine.UpdateQtyToTransfer;
                JobPlanningLine.MODIFY;
            END;
        UNTIL SalesLine.NEXT = 0;
    end;

    local procedure GetQtyOfPurchILENotShipped(ItemLedgerEntryNo: Integer): Decimal;
    var
        ItemApplicationEntry: Record "Item Application Entry";
        ItemLedgerEntryLocal: Record "Item Ledger Entry";
        QtyNotShipped: Decimal;
    begin
        QtyNotShipped := 0;
        WITH ItemApplicationEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Inbound Item Entry No.", "Outbound Item Entry No.");
            SETRANGE("Inbound Item Entry No.", ItemLedgerEntryNo);
            SETRANGE("Outbound Item Entry No.", 0);
            IF NOT FINDFIRST THEN
                EXIT(QtyNotShipped);
            QtyNotShipped := Quantity;
            SETFILTER("Outbound Item Entry No.", '<>0');
            IF NOT FINDSET(FALSE, FALSE) THEN
                EXIT(QtyNotShipped);
            REPEAT
                ItemLedgerEntryLocal.GET("Outbound Item Entry No.");
                IF (ItemLedgerEntryLocal."Entry Type" IN
                    [ItemLedgerEntryLocal."Entry Type"::Sale,
                     ItemLedgerEntryLocal."Entry Type"::Purchase]) OR
                   ((ItemLedgerEntryLocal."Entry Type" IN
                     [ItemLedgerEntryLocal."Entry Type"::"Positive Adjmt.", ItemLedgerEntryLocal."Entry Type"::"Negative Adjmt."]) AND
                    (ItemLedgerEntryLocal."Job No." = ''))
                THEN
                    QtyNotShipped += Quantity;
            UNTIL NEXT = 0;
        END;
        EXIT(QtyNotShipped);
    end;

    local procedure CopyAsmOrderToAsmOrder(var TempFromAsmHeader: Record "Assembly Header" temporary; var TempFromAsmLine: Record "Assembly Line" temporary; ToSalesLine: Record "Sales Line"; ToAsmHeaderDocType: Integer; ToAsmHeaderDocNo: Code[20]; InclAsmHeader: Boolean);
    var
        FromAsmHeader: Record "Assembly Header";
        ToAsmHeader: Record "Assembly Header";
        TempToAsmHeader: Record "Assembly Header" temporary;
        AssembleToOrderLink: Record "Assemble-to-Order Link";
        ToAsmLine: Record "Assembly Line";
        BasicAsmOrderCopy: Boolean;
    begin
        IF ToAsmHeaderDocType = -1 THEN
            EXIT;
        BasicAsmOrderCopy := ToAsmHeaderDocNo <> '';
        IF BasicAsmOrderCopy THEN
            ToAsmHeader.GET(ToAsmHeaderDocType, ToAsmHeaderDocNo)
        ELSE BEGIN
            IF ToSalesLine.AsmToOrderExists(FromAsmHeader) THEN
                EXIT;
            CLEAR(ToAsmHeader);
            AssembleToOrderLink.InsertAsmHeader(ToAsmHeader, ToAsmHeaderDocType, '');
            InclAsmHeader := TRUE;
        END;

        IF InclAsmHeader THEN BEGIN
            IF BasicAsmOrderCopy THEN BEGIN
                TempToAsmHeader := ToAsmHeader;
                TempToAsmHeader.INSERT;
                ProcessToAsmHeader(TempToAsmHeader, TempFromAsmHeader, ToSalesLine, TRUE, TRUE); // Basic, Availabilitycheck
                CheckAsmOrderAvailability(TempToAsmHeader, TempFromAsmLine, ToSalesLine);
            END;
            ProcessToAsmHeader(ToAsmHeader, TempFromAsmHeader, ToSalesLine, BasicAsmOrderCopy, FALSE);
        END ELSE
            IF BasicAsmOrderCopy THEN
                CheckAsmOrderAvailability(ToAsmHeader, TempFromAsmLine, ToSalesLine);
        CreateToAsmLines(ToAsmHeader, TempFromAsmLine, ToAsmLine, ToSalesLine, BasicAsmOrderCopy, FALSE);
        IF NOT BasicAsmOrderCopy THEN
            WITH AssembleToOrderLink DO BEGIN
                "Assembly Document Type" := ToAsmHeader."Document Type";
                "Assembly Document No." := ToAsmHeader."No.";
                Type := Type::Sale;
                "Document Type" := ToSalesLine."Document Type";
                "Document No." := ToSalesLine."Document No.";
                "Document Line No." := ToSalesLine."Line No.";
                INSERT;
                IF ToSalesLine."Document Type" = ToSalesLine."Document Type"::Order THEN BEGIN
                    IF ToSalesLine."Shipment Date" = 0D THEN BEGIN
                        ToSalesLine."Shipment Date" := ToAsmHeader."Due Date";
                        ToSalesLine.MODIFY;
                    END;
                    ReserveAsmToSale(ToSalesLine, ToSalesLine.Quantity, ToSalesLine."Quantity (Base)");
                END;
            END;

        ToAsmHeader.ShowDueDateBeforeWorkDateMsg;
    end;

    procedure CopyAsmHeaderToAsmHeader(FromAsmHeader: Record "Assembly Header"; ToAsmHeader: Record "Assembly Header"; IncludeHeader: Boolean);
    var
        EmptyToSalesLine: Record "Sales Line";
    begin
        InitialToAsmHeaderCheck(ToAsmHeader, IncludeHeader);
        GenerateAsmDataFromNonPosted(FromAsmHeader);
        CLEAR(EmptyToSalesLine);
        EmptyToSalesLine.INIT;
        CopyAsmOrderToAsmOrder(TempAsmHeader, TempAsmLine, EmptyToSalesLine, ToAsmHeader."Document Type", ToAsmHeader."No.", IncludeHeader);
    end;

    procedure CopyPostedAsmHeaderToAsmHeader(PostedAsmHeader: Record "Posted Assembly Header"; ToAsmHeader: Record "Assembly Header"; IncludeHeader: Boolean);
    var
        EmptyToSalesLine: Record "Sales Line";
    begin
        InitialToAsmHeaderCheck(ToAsmHeader, IncludeHeader);
        GenerateAsmDataFromPosted(PostedAsmHeader, 0);
        CLEAR(EmptyToSalesLine);
        EmptyToSalesLine.INIT;
        CopyAsmOrderToAsmOrder(TempAsmHeader, TempAsmLine, EmptyToSalesLine, ToAsmHeader."Document Type", ToAsmHeader."No.", IncludeHeader);
    end;

    local procedure GenerateAsmDataFromNonPosted(AsmHeader: Record "Assembly Header");
    var
        AsmLine: Record "Assembly Line";
    begin
        InitAsmCopyHandling(FALSE);
        TempAsmHeader := AsmHeader;
        TempAsmHeader.INSERT;
        AsmLine.SETRANGE("Document Type", AsmHeader."Document Type");
        AsmLine.SETRANGE("Document No.", AsmHeader."No.");
        IF AsmLine.FINDSET THEN
            REPEAT
                TempAsmLine := AsmLine;
                TempAsmLine.INSERT;
            UNTIL AsmLine.NEXT = 0;
    end;

    local procedure GenerateAsmDataFromPosted(PostedAsmHeader: Record "Posted Assembly Header"; DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order");
    var
        PostedAsmLine: Record "Posted Assembly Line";
    begin
        InitAsmCopyHandling(FALSE);
        TempAsmHeader.TRANSFERFIELDS(PostedAsmHeader);
        CASE DocType OF
            DocType::Quote:
                TempAsmHeader."Document Type" := TempAsmHeader."Document Type"::Quote;
            DocType::Order:
                TempAsmHeader."Document Type" := TempAsmHeader."Document Type"::Order;
            DocType::"Blanket Order":
                TempAsmHeader."Document Type" := TempAsmHeader."Document Type"::"Blanket Order";
            ELSE
                EXIT;
        END;
        TempAsmHeader.INSERT;
        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
        IF PostedAsmLine.FINDSET THEN
            REPEAT
                TempAsmLine.TRANSFERFIELDS(PostedAsmLine);
                TempAsmLine."Document No." := TempAsmHeader."No.";
                TempAsmLine."Cost Amount" := PostedAsmLine.Quantity * PostedAsmLine."Unit Cost";
                TempAsmLine.INSERT;
            UNTIL PostedAsmLine.NEXT = 0;
    end;

    procedure GetAsmDataFromSalesInvLine(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"): Boolean;
    var
        ValueEntry: Record "Value Entry";
        ValueEntry2: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        /*CLEAR(PostedAsmHeader);
        IF TempSalesInvLine.Type <> TempSalesInvLine.Type::Item THEN
          EXIT(FALSE);
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.",TempSalesInvLine."Document No.");
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SETRANGE("Document Line No.",TempSalesInvLine."Line No.");
        IF NOT ValueEntry.FINDFIRST THEN
          EXIT(FALSE);
        IF NOT ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN
          EXIT(FALSE);
        IF ItemLedgerEntry."Document Type" <> ItemLedgerEntry."Document Type"::"Sales Shipment" THEN
          EXIT(FALSE);
        SalesShipmentLine.GET(ItemLedgerEntry."Document No.",ItemLedgerEntry."Document Line No.");
        IF NOT SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) THEN
          EXIT(FALSE);
        IF ValueEntry.COUNT > 1 THEN BEGIN
          ValueEntry2.COPY(ValueEntry);
          ValueEntry2.SETFILTER("Item Ledger Entry No.",'<>%1',ValueEntry."Item Ledger Entry No.");
          IF NOT ValueEntry2.ISEMPTY THEN
            ERROR(Text032,TempSalesInvLine."Document No.");
        END;
        GenerateAsmDataFromPosted(PostedAsmHeader,DocType);
        EXIT(TRUE);
        */

    end;

    procedure InitAsmCopyHandling(ResetQuantities: Boolean);
    begin
        IF ResetQuantities THEN BEGIN
            QtyToAsmToOrder := 0;
            QtyToAsmToOrderBase := 0;
        END;
        TempAsmHeader.DELETEALL;
        TempAsmLine.DELETEALL;
    end;

    procedure RetrieveSalesInvLine(SalesLine: Record "Sales Line"; PosNo: Integer; LineCountsEqual: Boolean): Boolean;
    begin
        /*IF NOT LineCountsEqual THEN
          EXIT(FALSE);
        TempSalesInvLine.FINDSET;
        IF PosNo > 1 THEN
          TempSalesInvLine.NEXT(PosNo - 1);
        EXIT((SalesLine.Type = TempSalesInvLine.Type) AND (SalesLine."No." = TempSalesInvLine."No."));
        */

    end;

    procedure InitialToAsmHeaderCheck(ToAsmHeader: Record "Assembly Header"; IncludeHeader: Boolean);
    begin
        ToAsmHeader.TESTFIELD("No.");
        IF IncludeHeader THEN BEGIN
            ToAsmHeader.TESTFIELD("Item No.", '');
            ToAsmHeader.TESTFIELD(Quantity, 0);
        END ELSE BEGIN
            ToAsmHeader.TESTFIELD("Item No.");
            ToAsmHeader.TESTFIELD(Quantity);
        END;
    end;

    local procedure GetAsmOrderType(SalesLineDocType: Option Quote,"Order",,,"Blanket Order"): Integer;
    begin
        IF SalesLineDocType IN [SalesLineDocType::Quote, SalesLineDocType::Order, SalesLineDocType::"Blanket Order"] THEN
            EXIT(SalesLineDocType);
        EXIT(-1);
    end;

    local procedure ProcessToAsmHeader(var ToAsmHeader: Record "Assembly Header"; TempFromAsmHeader: Record "Assembly Header" temporary; ToSalesLine: Record "Sales Line"; BasicAsmOrderCopy: Boolean; AvailabilityCheck: Boolean);
    begin
        WITH ToAsmHeader DO BEGIN
            IF AvailabilityCheck THEN BEGIN
                "Item No." := TempFromAsmHeader."Item No.";
                "Location Code" := TempFromAsmHeader."Location Code";
                "Variant Code" := TempFromAsmHeader."Variant Code";
                "Unit of Measure Code" := TempFromAsmHeader."Unit of Measure Code";
            END ELSE BEGIN
                VALIDATE("Item No.", TempFromAsmHeader."Item No.");
                VALIDATE("Location Code", TempFromAsmHeader."Location Code");
                VALIDATE("Variant Code", TempFromAsmHeader."Variant Code");
                VALIDATE("Unit of Measure Code", TempFromAsmHeader."Unit of Measure Code");
            END;
            IF BasicAsmOrderCopy THEN BEGIN
                VALIDATE("Due Date", TempFromAsmHeader."Due Date");
                Quantity := TempFromAsmHeader.Quantity;
                "Quantity (Base)" := TempFromAsmHeader."Quantity (Base)";
            END ELSE BEGIN
                IF ToSalesLine."Shipment Date" <> 0D THEN
                    VALIDATE("Due Date", ToSalesLine."Shipment Date");
                Quantity := QtyToAsmToOrder;
                "Quantity (Base)" := QtyToAsmToOrderBase;
            END;
            "Unit Cost" := TempFromAsmHeader."Unit Cost";
            RoundQty(Quantity);
            RoundQty("Quantity (Base)");
            "Cost Amount" := ROUND(Quantity * "Unit Cost");
            InitRemainingQty;
            InitQtyToAssemble;
            IF NOT AvailabilityCheck THEN BEGIN
                VALIDATE("Quantity to Assemble");
                VALIDATE("Planning Flexibility", TempFromAsmHeader."Planning Flexibility");
            END;
            MODIFY;
        END;
    end;

    local procedure CreateToAsmLines(ToAsmHeader: Record "Assembly Header"; var FromAsmLine: Record "Assembly Line"; var ToAssemblyLine: Record "Assembly Line"; ToSalesLine: Record "Sales Line"; BasicAsmOrderCopy: Boolean; AvailabilityCheck: Boolean);
    var
        TempToAsmHeader: Record "Assembly Header" temporary;
        AssemblyLineMgt: Codeunit "Assembly Line Management";
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        IF AvailabilityCheck THEN BEGIN
            TempToAsmHeader := ToAsmHeader;
            TempToAsmHeader.INSERT;
        END;
        IF FromAsmLine.FINDSET THEN
            REPEAT
                ToAssemblyLine.INIT;
                ToAssemblyLine."Document Type" := ToAsmHeader."Document Type";
                ToAssemblyLine."Document No." := ToAsmHeader."No.";
                ToAssemblyLine."Line No." := AssemblyLineMgt.GetNextAsmLineNo(ToAssemblyLine, AvailabilityCheck);
                ToAssemblyLine.INSERT(NOT AvailabilityCheck);
                IF AvailabilityCheck THEN BEGIN
                    ToAssemblyLine.Type := FromAsmLine.Type;
                    ToAssemblyLine."No." := FromAsmLine."No.";
                    ToAssemblyLine."Resource Usage Type" := FromAsmLine."Resource Usage Type";
                    ToAssemblyLine."Unit of Measure Code" := FromAsmLine."Unit of Measure Code";
                    ToAssemblyLine."Quantity per" := FromAsmLine."Quantity per";
                    ToAssemblyLine.Quantity := GetAppliedQuantityForAsmLine(BasicAsmOrderCopy, ToAsmHeader, FromAsmLine, ToSalesLine);
                END ELSE BEGIN
                    ToAssemblyLine.VALIDATE(Type, FromAsmLine.Type);
                    ToAssemblyLine.VALIDATE("No.", FromAsmLine."No.");
                    ToAssemblyLine.VALIDATE("Resource Usage Type", FromAsmLine."Resource Usage Type");
                    ToAssemblyLine.VALIDATE("Unit of Measure Code", FromAsmLine."Unit of Measure Code");
                    IF ToAssemblyLine.Type <> ToAssemblyLine.Type::" " THEN
                        ToAssemblyLine.VALIDATE("Quantity per", FromAsmLine."Quantity per");
                    ToAssemblyLine.VALIDATE(Quantity, GetAppliedQuantityForAsmLine(BasicAsmOrderCopy, ToAsmHeader, FromAsmLine, ToSalesLine));
                END;
                ToAssemblyLine.ValidateDueDate(ToAsmHeader, ToAsmHeader."Starting Date", FALSE);
                ToAssemblyLine.ValidateLeadTimeOffset(ToAsmHeader, FromAsmLine."Lead-Time Offset", FALSE);
                ToAssemblyLine.Description := FromAsmLine.Description;
                ToAssemblyLine."Description 2" := FromAsmLine."Description 2";
                ToAssemblyLine.Position := FromAsmLine.Position;
                ToAssemblyLine."Position 2" := FromAsmLine."Position 2";
                ToAssemblyLine."Position 3" := FromAsmLine."Position 3";
                IF ToAssemblyLine.Type <> ToAssemblyLine.Type::" " THEN BEGIN
                    ToAssemblyLine.VALIDATE("Unit Cost", FromAsmLine."Unit Cost");
                    IF AvailabilityCheck THEN BEGIN
                        WITH ToAssemblyLine DO BEGIN
                            "Quantity (Base)" := UOMMgt.CalcBaseQty(Quantity, "Qty. per Unit of Measure");
                            "Remaining Quantity" := "Quantity (Base)";
                            "Quantity to Consume" := ToAsmHeader."Quantity to Assemble" * FromAsmLine."Quantity per";
                            "Quantity to Consume (Base)" := UOMMgt.CalcBaseQty("Quantity to Consume", "Qty. per Unit of Measure");
                        END;
                    END ELSE
                        ToAssemblyLine.VALIDATE("Quantity to Consume", ToAsmHeader."Quantity to Assemble" * FromAsmLine."Quantity per");
                END;
                IF ToAssemblyLine.Type = ToAssemblyLine.Type::Item THEN BEGIN
                    IF AvailabilityCheck THEN BEGIN
                        ToAssemblyLine."Location Code" := FromAsmLine."Location Code";
                        ToAssemblyLine."Variant Code" := FromAsmLine."Variant Code";
                    END ELSE BEGIN
                        ToAssemblyLine.VALIDATE("Location Code", FromAsmLine."Location Code");
                        ToAssemblyLine.VALIDATE("Variant Code", FromAsmLine."Variant Code");
                    END;
                END;
                ToAssemblyLine.MODIFY(NOT AvailabilityCheck);
            UNTIL FromAsmLine.NEXT = 0;
    end;

    local procedure CheckAsmOrderAvailability(ToAsmHeader: Record "Assembly Header"; var FromAsmLine: Record "Assembly Line"; ToSalesLine: Record "Sales Line");
    var
        TempToAsmHeader: Record "Assembly Header" temporary;
        TempToAsmLine: Record "Assembly Line" temporary;
        AsmLineOnDestinationOrder: Record "Assembly Line";
        AssemblyLineMgt: Codeunit "Assembly Line Management";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        LineNo: Integer;
    begin
        TempToAsmHeader := ToAsmHeader;
        TempToAsmHeader.INSERT;
        CreateToAsmLines(TempToAsmHeader, FromAsmLine, TempToAsmLine, ToSalesLine, TRUE, TRUE);
        IF TempToAsmLine.FINDLAST THEN
            LineNo := TempToAsmLine."Line No.";
        CLEAR(TempToAsmLine);
        WITH AsmLineOnDestinationOrder DO BEGIN
            SETRANGE("Document Type", ToAsmHeader."Document Type");
            SETRANGE("Document No.", ToAsmHeader."No.");
            SETRANGE(Type, Type::Item);
        END;
        IF AsmLineOnDestinationOrder.FINDSET THEN
            REPEAT
                TempToAsmLine := AsmLineOnDestinationOrder;
                LineNo += 10000;
                TempToAsmLine."Line No." := LineNo;
                TempToAsmLine.INSERT;
            UNTIL AsmLineOnDestinationOrder.NEXT = 0;
        IF AssemblyLineMgt.ShowAvailability(FALSE, TempToAsmHeader, TempToAsmLine) THEN
            ItemCheckAvail.RaiseUpdateInterruptedError;
        TempToAsmLine.DELETEALL;
    end;

    local procedure GetAppliedQuantityForAsmLine(BasicAsmOrderCopy: Boolean; ToAsmHeader: Record "Assembly Header"; TempFromAsmLine: Record "Assembly Line" temporary; ToSalesLine: Record "Sales Line"): Decimal;
    begin
        IF BasicAsmOrderCopy THEN
            EXIT(ToAsmHeader.Quantity * TempFromAsmLine."Quantity per");
        CASE ToSalesLine."Document Type" OF
            ToSalesLine."Document Type"::Order:
                EXIT(ToSalesLine."Qty. to Assemble to Order" * TempFromAsmLine."Quantity per");
            ToSalesLine."Document Type"::Quote,
          ToSalesLine."Document Type"::"Blanket Order":
                EXIT(ToSalesLine.Quantity * TempFromAsmLine."Quantity per");
        END;
    end;

    procedure CopyDocLines(RecalculateAmount: Boolean; ToPurchLine: Record "Purchase Line"; var FromPurchLine: Record "Purchase Line");
    begin
        IF NOT RecalculateAmount THEN
            EXIT;
        IF (ToPurchLine.Type <> ToPurchLine.Type::" ") AND (ToPurchLine."No." <> '') THEN BEGIN
            ToPurchLine.VALIDATE("Line Discount %", FromPurchLine."Line Discount %");
            ToPurchLine.VALIDATE(
              "Inv. Discount Amount",
              ROUND(FromPurchLine."Inv. Discount Amount", Currency."Amount Rounding Precision"));
        END;
    end;

    local procedure CheckCreditLimit(FromSalesHeader: Record "Sales Header"; ToSalesHeader: Record "Sales Header");
    begin
        IF SkipTestCreditLimit THEN
            EXIT;

        IF IncludeHeader THEN
            CustCheckCreditLimit.SalesHeaderCheck(FromSalesHeader)
        ELSE
            CustCheckCreditLimit.SalesHeaderCheck(ToSalesHeader);
    end;

    local procedure CheckUnappliedLines(SkippedLine: Boolean; var MissingExCostRevLink: Boolean);
    begin
        IF SkippedLine AND MissingExCostRevLink THEN BEGIN
            IF NOT WarningDone THEN
                MESSAGE(Text030);
            MissingExCostRevLink := FALSE;
            WarningDone := TRUE;
        END;
    end;

    local procedure SetDefaultValuesToSalesLine(var ToSalesLine: Record "Sales Line"; ToSalesHeader: Record "Sales Header"; VATDifference: Decimal);
    begin
        IF ToSalesLine."Document Type" <> ToSalesLine."Document Type"::Order THEN BEGIN
            ToSalesLine."Prepayment %" := 0;
            ToSalesLine."Prepayment VAT %" := 0;
            ToSalesLine."Prepmt. VAT Calc. Type" := 0;
            ToSalesLine."Prepayment VAT Identifier" := '';
            ToSalesLine."Prepayment VAT %" := 0;
            ToSalesLine."Prepayment Tax Group Code" := '';
            ToSalesLine."Prepmt. Line Amount" := 0;
            ToSalesLine."Prepmt. Amt. Incl. VAT" := 0;
        END;
        ToSalesLine."Prepmt. Amt. Inv." := 0;
        ToSalesLine."Prepmt. Amount Inv. (LCY)" := 0;
        ToSalesLine."Prepayment Amount" := 0;
        ToSalesLine."Prepmt. VAT Base Amt." := 0;
        ToSalesLine."Prepmt Amt to Deduct" := 0;
        ToSalesLine."Prepmt Amt Deducted" := 0;
        ToSalesLine."Prepmt. Amount Inv. Incl. VAT" := 0;
        ToSalesLine."Prepayment VAT Difference" := 0;
        ToSalesLine."Prepmt VAT Diff. to Deduct" := 0;
        ToSalesLine."Prepmt VAT Diff. Deducted" := 0;
        ToSalesLine."Quantity Shipped" := 0;
        ToSalesLine."Qty. Shipped (Base)" := 0;
        ToSalesLine."Return Qty. Received" := 0;
        ToSalesLine."Return Qty. Received (Base)" := 0;
        ToSalesLine."Quantity Invoiced" := 0;
        ToSalesLine."Qty. Invoiced (Base)" := 0;
        ToSalesLine."Reserved Quantity" := 0;
        ToSalesLine."Reserved Qty. (Base)" := 0;
        ToSalesLine."Qty. to Ship" := 0;
        ToSalesLine."Qty. to Ship (Base)" := 0;
        ToSalesLine."Return Qty. to Receive" := 0;
        ToSalesLine."Return Qty. to Receive (Base)" := 0;
        ToSalesLine."Qty. to Invoice" := 0;
        ToSalesLine."Qty. to Invoice (Base)" := 0;
        ToSalesLine."Qty. Shipped Not Invoiced" := 0;
        ToSalesLine."Return Qty. Rcd. Not Invd." := 0;
        ToSalesLine."Shipped Not Invoiced" := 0;
        ToSalesLine."Return Rcd. Not Invd." := 0;
        ToSalesLine."Qty. Shipped Not Invd. (Base)" := 0;
        ToSalesLine."Ret. Qty. Rcd. Not Invd.(Base)" := 0;
        ToSalesLine."Shipped Not Invoiced (LCY)" := 0;
        ToSalesLine."Return Rcd. Not Invd. (LCY)" := 0;
        ToSalesLine."Job No." := '';
        ToSalesLine."Job Task No." := '';
        ToSalesLine."Job Contract Entry No." := 0;
        IF ToSalesLine."Document Type" = ToSalesLine."Document Type"::"Blanket Order" THEN BEGIN
            ToSalesLine."Blanket Order No." := '';
            ToSalesLine."Blanket Order Line No." := 0;
        END;
        ToSalesLine.InitOutstanding;
        IF ToSalesLine."Document Type" IN
           [ToSalesLine."Document Type"::"Return Order", ToSalesLine."Document Type"::"Credit Memo"]
        THEN
            ToSalesLine.InitQtyToReceive
        ELSE
            ToSalesLine.InitQtyToShip;
        ToSalesLine."VAT Difference" := VATDifference;
        IF NOT CreateToHeader AND RecalculateLines THEN
            ToSalesLine."Shipment Date" := ToSalesHeader."Shipment Date";
        ToSalesLine."Appl.-from Item Entry" := 0;
        ToSalesLine."Appl.-to Item Entry" := 0;

        ToSalesLine."Purchase Order No." := '';
        ToSalesLine."Purch. Order Line No." := 0;
        ToSalesLine."Special Order Purchase No." := '';
        ToSalesLine."Special Order Purch. Line No." := 0;
    end;

    local procedure SetDefaultValuesToPurchLine(var ToPurchLine: Record "Purchase Line"; ToPurchHeader: Record "Purchase Header"; VATDifference: Decimal);
    begin
        IF ToPurchLine."Document Type" <> ToPurchLine."Document Type"::Order THEN BEGIN
            ToPurchLine."Prepayment %" := 0;
            ToPurchLine."Prepayment VAT %" := 0;
            ToPurchLine."Prepmt. VAT Calc. Type" := 0;
            ToPurchLine."Prepayment VAT Identifier" := '';
            ToPurchLine."Prepayment VAT %" := 0;
            ToPurchLine."Prepayment Tax Group Code" := '';
            ToPurchLine."Prepmt. Line Amount" := 0;
            ToPurchLine."Prepmt. Amt. Incl. VAT" := 0;
        END;
        ToPurchLine."Prepmt. Amt. Inv." := 0;
        ToPurchLine."Prepmt. Amount Inv. (LCY)" := 0;
        ToPurchLine."Prepayment Amount" := 0;
        ToPurchLine."Prepmt. VAT Base Amt." := 0;
        ToPurchLine."Prepmt Amt to Deduct" := 0;
        ToPurchLine."Prepmt Amt Deducted" := 0;
        ToPurchLine."Prepmt. Amount Inv. Incl. VAT" := 0;
        ToPurchLine."Prepayment VAT Difference" := 0;
        ToPurchLine."Prepmt VAT Diff. to Deduct" := 0;
        ToPurchLine."Prepmt VAT Diff. Deducted" := 0;
        ToPurchLine."Quantity Received" := 0;
        ToPurchLine."Qty. Received (Base)" := 0;
        ToPurchLine."Return Qty. Shipped" := 0;
        ToPurchLine."Return Qty. Shipped (Base)" := 0;
        ToPurchLine."Quantity Invoiced" := 0;
        ToPurchLine."Qty. Invoiced (Base)" := 0;
        ToPurchLine."Reserved Quantity" := 0;
        ToPurchLine."Reserved Qty. (Base)" := 0;
        ToPurchLine."Qty. Rcd. Not Invoiced" := 0;
        ToPurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
        ToPurchLine."Return Qty. Shipped Not Invd." := 0;
        ToPurchLine."Ret. Qty. Shpd Not Invd.(Base)" := 0;
        ToPurchLine."Qty. to Receive" := 0;
        ToPurchLine."Qty. to Receive (Base)" := 0;
        ToPurchLine."Return Qty. to Ship" := 0;
        ToPurchLine."Return Qty. to Ship (Base)" := 0;
        ToPurchLine."Qty. to Invoice" := 0;
        ToPurchLine."Qty. to Invoice (Base)" := 0;
        ToPurchLine."Amt. Rcd. Not Invoiced" := 0;
        ToPurchLine."Amt. Rcd. Not Invoiced (LCY)" := 0;
        ToPurchLine."Return Shpd. Not Invd." := 0;
        ToPurchLine."Return Shpd. Not Invd. (LCY)" := 0;
        IF ToPurchLine."Document Type" = ToPurchLine."Document Type"::"Blanket Order" THEN BEGIN
            ToPurchLine."Blanket Order No." := '';
            ToPurchLine."Blanket Order Line No." := 0;
        END;

        ToPurchLine.InitOutstanding;
        IF ToPurchLine."Document Type" IN
           [ToPurchLine."Document Type"::"Return Order", ToPurchLine."Document Type"::"Credit Memo"]
        THEN
            ToPurchLine.InitQtyToShip
        ELSE
            ToPurchLine.InitQtyToReceive;
        ToPurchLine."VAT Difference" := VATDifference;
        ToPurchLine."Receipt No." := '';
        ToPurchLine."Receipt Line No." := 0;
        IF NOT CreateToHeader THEN
            ToPurchLine."Expected Receipt Date" := ToPurchHeader."Expected Receipt Date";
        ToPurchLine."Appl.-to Item Entry" := 0;

        ToPurchLine."Sales Order No." := '';
        ToPurchLine."Sales Order Line No." := 0;
        ToPurchLine."Special Order Sales No." := '';
        ToPurchLine."Special Order Sales Line No." := 0;
    end;

    local procedure CopyItemTrackingEntries(SalesLine: Record "Sales Line"; var PurchLine: Record "Purchase Line"; SalesPricesIncludingVAT: Boolean; PurchPricesIncludingVAT: Boolean);
    var
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        MissingExCostRevLink: Boolean;
    begin
        FindTrackingEntries(
          TempItemLedgerEntry, DATABASE::"Sales Line", TrackingSpecification."Source Subtype"::"5",
          SalesLine."Document No.", '', 0, SalesLine."Line No.", SalesLine."No.");
        ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
          TempItemLedgerEntry, PurchLine, FALSE, MissingExCostRevLink,
          SalesPricesIncludingVAT, PurchPricesIncludingVAT, TRUE);
    end;

    local procedure FindTrackingEntries(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary; Type: Integer; Subtype: Integer; ID: Code[20]; BatchName: Code[10]; ProdOrderLine: Integer; RefNo: Integer; ItemNo: Code[20]);
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        WITH TrackingSpecification DO BEGIN
            SETCURRENTKEY("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
              "Source Prod. Order Line", "Source Ref. No.");
            SETRANGE("Source ID", ID);
            SETRANGE("Source Ref. No.", RefNo);
            SETRANGE("Source Type", Type);
            SETRANGE("Source Subtype", Subtype);
            SETRANGE("Source Batch Name", BatchName);
            SETRANGE("Source Prod. Order Line", ProdOrderLine);
            SETRANGE("Item No.", ItemNo);
            IF FINDSET THEN
                REPEAT
                    AddItemLedgerEntry(TempItemLedgerEntry, "Lot No.", "Serial No.", "Entry No.");
                UNTIL NEXT = 0;
        END;
    end;

    local procedure AddItemLedgerEntry(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary; LotNo: Code[20]; SerialNo: Code[20]; EntryNo: Integer);
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        IF (LotNo = '') AND (SerialNo = '') THEN
            EXIT;

        IF NOT ItemLedgerEntry.GET(EntryNo) THEN
            EXIT;

        TempItemLedgerEntry := ItemLedgerEntry;
        IF TempItemLedgerEntry.INSERT THEN;
    end;

    local procedure CopyFieldsFromOldSalesHeader(var ToSalesHeader: Record "Sales Header"; OldSalesHeader: Record "Sales Header");
    begin
        WITH ToSalesHeader DO BEGIN
            "No. Series" := OldSalesHeader."No. Series";
            "Posting Description" := OldSalesHeader."Posting Description";
            "Posting No." := OldSalesHeader."Posting No.";
            "Posting No. Series" := OldSalesHeader."Posting No. Series";
            "Shipping No." := OldSalesHeader."Shipping No.";
            "Shipping No. Series" := OldSalesHeader."Shipping No. Series";
            "Return Receipt No." := OldSalesHeader."Return Receipt No.";
            "Return Receipt No. Series" := OldSalesHeader."Return Receipt No. Series";
            "Prepayment No. Series" := OldSalesHeader."Prepayment No. Series";
            "Prepayment No." := OldSalesHeader."Prepayment No.";
            "Prepmt. Posting Description" := OldSalesHeader."Prepmt. Posting Description";
            "Prepmt. Cr. Memo No. Series" := OldSalesHeader."Prepmt. Cr. Memo No. Series";
            "Prepmt. Cr. Memo No." := OldSalesHeader."Prepmt. Cr. Memo No.";
            "Prepmt. Posting Description" := OldSalesHeader."Prepmt. Posting Description";
        END
    end;

    local procedure CopyFieldsFromOldPurchHeader(var ToPurchHeader: Record "Purchase Header"; OldPurchHeader: Record "Purchase Header");
    begin
        WITH ToPurchHeader DO BEGIN
            "No. Series" := OldPurchHeader."No. Series";
            "Posting Description" := OldPurchHeader."Posting Description";
            "Posting No." := OldPurchHeader."Posting No.";
            "Posting No. Series" := OldPurchHeader."Posting No. Series";
            "Receiving No." := OldPurchHeader."Receiving No.";
            "Receiving No. Series" := OldPurchHeader."Receiving No. Series";
            "Return Shipment No." := OldPurchHeader."Return Shipment No.";
            "Return Shipment No. Series" := OldPurchHeader."Return Shipment No. Series";
            "Prepayment No. Series" := OldPurchHeader."Prepayment No. Series";
            "Prepayment No." := OldPurchHeader."Prepayment No.";
            "Prepmt. Posting Description" := OldPurchHeader."Prepmt. Posting Description";
            "Prepmt. Cr. Memo No. Series" := OldPurchHeader."Prepmt. Cr. Memo No. Series";
            "Prepmt. Cr. Memo No." := OldPurchHeader."Prepmt. Cr. Memo No.";
            "Prepmt. Posting Description" := OldPurchHeader."Prepmt. Posting Description";
        END;
    end;

    local procedure CheckFromSalesHeader(SalesHeaderFrom: Record "Sales Header"; SalesHeaderTo: Record "Sales Header");
    begin
        WITH SalesHeaderTo DO BEGIN
            SalesHeaderFrom.TESTFIELD("Sell-to Customer No.", "Sell-to Customer No.");
            SalesHeaderFrom.TESTFIELD("Bill-to Customer No.", "Bill-to Customer No.");
            SalesHeaderFrom.TESTFIELD("Customer Posting Group", "Customer Posting Group");
            SalesHeaderFrom.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            SalesHeaderFrom.TESTFIELD("Currency Code", "Currency Code");
            SalesHeaderFrom.TESTFIELD("Prices Including VAT", "Prices Including VAT");
        END;
    end;

    local procedure CheckFromSalesShptHeader(SalesShipmentHeaderFrom: Record "Sales Shipment Header"; SalesHeaderTo: Record "Sales Header");
    begin
        WITH SalesHeaderTo DO BEGIN
            SalesShipmentHeaderFrom.TESTFIELD("Sell-to Customer No.", "Sell-to Customer No.");
            SalesShipmentHeaderFrom.TESTFIELD("Bill-to Customer No.", "Bill-to Customer No.");
            SalesShipmentHeaderFrom.TESTFIELD("Customer Posting Group", "Customer Posting Group");
            SalesShipmentHeaderFrom.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            SalesShipmentHeaderFrom.TESTFIELD("Currency Code", "Currency Code");
            SalesShipmentHeaderFrom.TESTFIELD("Prices Including VAT", "Prices Including VAT");
        END;
    end;

    local procedure CheckFromSalesInvHeader(SalesInvoiceHeaderFrom: Record "Sales Invoice Header"; SalesHeaderTo: Record "Sales Header");
    begin
        WITH SalesHeaderTo DO BEGIN
            SalesInvoiceHeaderFrom.TESTFIELD("Sell-to Customer No.", "Sell-to Customer No.");
            SalesInvoiceHeaderFrom.TESTFIELD("Bill-to Customer No.", "Bill-to Customer No.");
            SalesInvoiceHeaderFrom.TESTFIELD("Customer Posting Group", "Customer Posting Group");
            SalesInvoiceHeaderFrom.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            SalesInvoiceHeaderFrom.TESTFIELD("Currency Code", "Currency Code");
            SalesInvoiceHeaderFrom.TESTFIELD("Prices Including VAT", "Prices Including VAT");
        END;
    end;

    local procedure CheckFromSalesReturnRcptHeader(ReturnReceiptHeaderFrom: Record "Return Receipt Header"; SalesHeaderTo: Record "Sales Header");
    begin
        WITH SalesHeaderTo DO BEGIN
            ReturnReceiptHeaderFrom.TESTFIELD("Sell-to Customer No.", "Sell-to Customer No.");
            ReturnReceiptHeaderFrom.TESTFIELD("Bill-to Customer No.", "Bill-to Customer No.");
            ReturnReceiptHeaderFrom.TESTFIELD("Customer Posting Group", "Customer Posting Group");
            ReturnReceiptHeaderFrom.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            ReturnReceiptHeaderFrom.TESTFIELD("Currency Code", "Currency Code");
            ReturnReceiptHeaderFrom.TESTFIELD("Prices Including VAT", "Prices Including VAT");
        END;
    end;

    local procedure CheckFromSalesCrMemoHeader(SalesCrMemoHeaderFrom: Record "Sales Cr.Memo Header"; SalesHeaderTo: Record "Sales Header");
    begin
        WITH SalesHeaderTo DO BEGIN
            SalesCrMemoHeaderFrom.TESTFIELD("Sell-to Customer No.", "Sell-to Customer No.");
            SalesCrMemoHeaderFrom.TESTFIELD("Bill-to Customer No.", "Bill-to Customer No.");
            SalesCrMemoHeaderFrom.TESTFIELD("Customer Posting Group", "Customer Posting Group");
            SalesCrMemoHeaderFrom.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            SalesCrMemoHeaderFrom.TESTFIELD("Currency Code", "Currency Code");
            SalesCrMemoHeaderFrom.TESTFIELD("Prices Including VAT", "Prices Including VAT");
        END;
    end;

    local procedure CheckFromPurchaseHeader(PurchaseHeaderFrom: Record "Purchase Header"; PurchaseHeaderTo: Record "Purchase Header");
    begin
        WITH PurchaseHeaderTo DO BEGIN
            PurchaseHeaderFrom.TESTFIELD("Buy-from Vendor No.", "Buy-from Vendor No.");
            PurchaseHeaderFrom.TESTFIELD("Pay-to Vendor No.", "Pay-to Vendor No.");
            PurchaseHeaderFrom.TESTFIELD("Vendor Posting Group", "Vendor Posting Group");
            PurchaseHeaderFrom.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            PurchaseHeaderFrom.TESTFIELD("Currency Code", "Currency Code");
        END;
    end;

    local procedure CheckFromPurchaseRcptHeader(PurchRcptHeaderFrom: Record "Purch. Rcpt. Header"; PurchaseHeaderTo: Record "Purchase Header");
    begin
        WITH PurchaseHeaderTo DO BEGIN
            PurchRcptHeaderFrom.TESTFIELD("Buy-from Vendor No.", "Buy-from Vendor No.");
            PurchRcptHeaderFrom.TESTFIELD("Pay-to Vendor No.", "Pay-to Vendor No.");
            PurchRcptHeaderFrom.TESTFIELD("Vendor Posting Group", "Vendor Posting Group");
            PurchRcptHeaderFrom.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            PurchRcptHeaderFrom.TESTFIELD("Currency Code", "Currency Code");
        END;
    end;

    local procedure CheckFromPurchaseInvHeader(PurchInvHeaderFrom: Record "Purch. Inv. Header"; PurchaseHeaderTo: Record "Purchase Header");
    begin
        WITH PurchaseHeaderTo DO BEGIN
            PurchInvHeaderFrom.TESTFIELD("Buy-from Vendor No.", "Buy-from Vendor No.");
            PurchInvHeaderFrom.TESTFIELD("Pay-to Vendor No.", "Pay-to Vendor No.");
            PurchInvHeaderFrom.TESTFIELD("Vendor Posting Group", "Vendor Posting Group");
            PurchInvHeaderFrom.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            PurchInvHeaderFrom.TESTFIELD("Currency Code", "Currency Code");
        END;
    end;

    local procedure CheckFromPurchaseReturnShptHeader(ReturnShipmentHeaderFrom: Record "Return Shipment Header"; PurchaseHeaderTo: Record "Purchase Header");
    begin
        WITH PurchaseHeaderTo DO BEGIN
            ReturnShipmentHeaderFrom.TESTFIELD("Buy-from Vendor No.", "Buy-from Vendor No.");
            ReturnShipmentHeaderFrom.TESTFIELD("Pay-to Vendor No.", "Pay-to Vendor No.");
            ReturnShipmentHeaderFrom.TESTFIELD("Vendor Posting Group", "Vendor Posting Group");
            ReturnShipmentHeaderFrom.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            ReturnShipmentHeaderFrom.TESTFIELD("Currency Code", "Currency Code");
        END;
    end;

    local procedure CheckFromPurchaseCrMemoHeader(PurchCrMemoHdrFrom: Record "Purch. Cr. Memo Hdr."; PurchaseHeaderTo: Record "Purchase Header");
    begin
        WITH PurchaseHeaderTo DO BEGIN
            PurchCrMemoHdrFrom.TESTFIELD("Buy-from Vendor No.", "Buy-from Vendor No.");
            PurchCrMemoHdrFrom.TESTFIELD("Pay-to Vendor No.", "Pay-to Vendor No.");
            PurchCrMemoHdrFrom.TESTFIELD("Vendor Posting Group", "Vendor Posting Group");
            PurchCrMemoHdrFrom.TESTFIELD("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            PurchCrMemoHdrFrom.TESTFIELD("Currency Code", "Currency Code");
        END;
    end;
}

