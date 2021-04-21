codeunit 51403017 "Release PV Document"
{
    TableNo = 51511000;

    trigger OnRun();
    var
        SalesLine: Record 37;
        TempVATAmountLine0: Record 290 temporary;
        TempVATAmountLine1: Record 290 temporary;
        PrepaymentMgt: Codeunit 441;
        NotOnlyDropShipment: Boolean;
        PostingDate: Date;
        PrintPostedDocuments: Boolean;
    begin
        IF Status = Status::Released THEN
            EXIT;

        OnBeforeReleasePVDoc(Rec);
        //OnCheckClaimReleaseRestrictions(Rec);

        /*IF "Document Type" = "Document Type"::Quote THEN
          IF CheckCustomerCreated(TRUE) THEN
            GET("Document Type"::Quote,"No.")
          ELSE
            EXIT;*/

        /*TESTFIELD("Claimd No.");
        
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.SETFILTER(Type,'>0');
        SalesLine.SETFILTER(Quantity,'<>0');
        IF NOT SalesLine.FIND('-') THEN
          ERROR(Text001,"Document Type","No.");
        InvtSetup.GET;
        IF InvtSetup."Location Mandatory" THEN BEGIN
          SalesLine.SETRANGE(Type,SalesLine.Type::Item);
          IF SalesLine.FINDSET THEN
            REPEAT
              IF NOT SalesLine.IsServiceItem THEN
                SalesLine.TESTFIELD("Location Code");
            UNTIL SalesLine.NEXT = 0;
          SalesLine.SETFILTER(Type,'>0');
        END;
        SalesLine.SETRANGE("Drop Shipment",FALSE);
        NotOnlyDropShipment := SalesLine.FINDFIRST;
        SalesLine.RESET;
        
        SalesSetup.GET;
        IF SalesSetup."Calc. Inv. Discount" THEN BEGIN
          PostingDate := "Posting Date";
          //PrintPostedDocuments := "Print Posted Documents";
          //CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",SalesLine);
          GET("Document Type","No.");
          //"Print Posted Documents" := PrintPostedDocuments;
          IF PostingDate <> "Posting Date" THEN
            VALIDATE("Posting Date",PostingDate);
        END;
        
        {IF PrepaymentMgt.TestSalesPrepayment(Rec) AND ("Document Type" = "Document Type"::Order) THEN BEGIN
          Status := Status::"Pending Prepayment";
          MODIFY(TRUE);
          EXIT;
        END}
          ;
        Status := Status::Released;
        
        {SalesLine.SetSalesHeader(Rec);
        SalesLine.CalcVATAmountLines(0,Rec,SalesLine,TempVATAmountLine0);
        SalesLine.CalcVATAmountLines(1,Rec,SalesLine,TempVATAmountLine1);
        SalesLine.UpdateVATOnLines(0,Rec,SalesLine,TempVATAmountLine0);
        SalesLine.UpdateVATOnLines(1,Rec,SalesLine,TempVATAmountLine1);
        
        ReleaseATOs(Rec);}
        
        MODIFY(TRUE);
        
        {IF NotOnlyDropShipment THEN
          IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
            WhseSalesRelease.Release(Rec);}*/

        OnAfterReleasePVDoc(Rec);

    end;

    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2.';
        SalesSetup: Record 311;
        InvtSetup: Record 313;
        WhseSalesRelease: Codeunit 5771;
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        Text004: Label 'There are unposted prepayment amounts on the document of type %1 with the number %2.';
        Text005: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        ChequeRegister: Record 51513455;
        ReversalEntry: Record 179;
        GLRegister: Record 45;

    procedure Reopen(var PV: Record Payments1);
    begin
        OnBeforeReopenPVDoc(PV);

        WITH PV DO BEGIN
            IF Status = Status::Open THEN
                EXIT;
            Status := Status::Open;

            /*IF "Document Type" <> "Document Type"::"Accepted Quote" THEN
              ReopenATOs(ClaimHeader);*/

            MODIFY(TRUE);
            /*IF "Document Type" IN ["Document Type"::Accepted Quote,"Document Type"::"Return Order"] THEN
              WhseSalesRelease.Reopen(SalesHeader);*/
        END;

        OnAfterReopenPVDoc(PV);

    end;

    procedure PerformManualRelease(var PV: Record Payments1);
    var
        PrepaymentMgt: Codeunit 441;
        ApprovalsMgmt: Codeunit 1535;
    begin
        WITH PV DO BEGIN
            /*IF PrepaymentMgt.TestSalesPrepayment(ClaimHeader) THEN
              ERROR(STRSUBSTNO(Text004,"Document Type","No."));
            IF ("Document Type" = "Document Type"::"Accepted Quote") AND PrepaymentMgt.TestSalesPayment(SalesHeader) THEN BEGIN
              IF Status <> Status::"Pending Prepayment" THEN BEGIN
                Status := Status::"Pending Prepayment";
                MODIFY;
                COMMIT;
              END;
              ERROR(STRSUBSTNO(Text005,"Document Type","No."));
            END;*/
        END;

        //IF ApprovalsMgmt.IsPVApprovalsWorkflowEnabled(PV) AND (PV.Status = PV.Status::Open) THEN
          //  ERROR(Text002);

        CODEUNIT.RUN(CODEUNIT::"Release PV Document", PV);

    end;

    procedure PerformManualReopen(var PV: Record Payments1);
    begin
        IF PV.Status = PV.Status::"Pending Approval" THEN
            ERROR(Text003);

        Reopen(PV);
    end;

    local procedure ReleaseATOs(PV: Record Payments1);
    var
        SalesLine: Record 37;
        AsmHeader: Record 900;
    begin
        /*SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.",SalesHeader."No.");
        IF SalesLine.FINDSET THEN
          REPEAT
            IF SalesLine.AsmToOrderExists(AsmHeader) THEN
              CODEUNIT.RUN(CODEUNIT::"Release Assembly Document",AsmHeader);
          UNTIL SalesLine.NEXT = 0;*/

    end;

    local procedure ReopenATOs(PV: Record Payments1);
    var
        SalesLine: Record 37;
        AsmHeader: Record 900;
        ReleaseAssemblyDocument: Codeunit 903;
    begin
        /*SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.",SalesHeader."No.");
        IF SalesLine.FINDSET THEN
          REPEAT
            IF SalesLine.AsmToOrderExists(AsmHeader) THEN
              ReleaseAssemblyDocument.Reopen(AsmHeader);
          UNTIL SalesLine.NEXT = 0;*/

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReleasePVDoc(var PV: Record Payments1);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleasePVDoc(var PV: Record Payments1);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenPVDoc(var PV: Record Payments1);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenPVDoc(var PV: Record Payments1);
    begin
    end;

    procedure CancelPV(var PV: Record Payments1);
    begin

        IF PV."Cancellation Reason" = '' THEN
            ERROR('You must enter a cancellatio  reason before cancelling a payment voucher');


        ChequeRegister.RESET;
        ChequeRegister.SETRANGE(ChequeRegister.PVNo, PV.No);
        IF ChequeRegister.FINDFIRST THEN BEGIN
            ChequeRegister.Status := ChequeRegister.Status::Cancelled;
            ChequeRegister.MODIFY;
            MESSAGE('Cheque No. %1 is cancelled', ChequeRegister."Cheque No.");
        END;

        GLRegister.RESET;
        GLRegister.SETRANGE(GLRegister."Journal Batch Name", PV.No);
        IF GLRegister.FINDFIRST THEN
            ReversalEntry.ReverseRegister(GLRegister."No.");

        PV.Status := PV.Status::Cancelled;
        PV.MODIFY;
        MESSAGE('Payment Voucher %1 has been Cancelled', PV.No);
    end;
}

