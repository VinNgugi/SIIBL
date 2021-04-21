codeunit 51403015 "Release Claim Document"
{
    // version AES-INS 1.0

    TableNo = Claim;

    trigger OnRun();
    var
        SalesLine: Record "Sales Line";
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        NotOnlyDropShipment: Boolean;
        PostingDate: Date;
        PrintPostedDocuments: Boolean;
    begin
        IF Status = Status::Released THEN
            EXIT;

        OnBeforeReleaseClaimDoc(Rec);
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

        OnAfterReleaseClaimDoc(Rec);

    end;

    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2.';
        SalesSetup: Record "Sales & Receivables Setup";
        InvtSetup: Record "Inventory Setup";
        WhseSalesRelease: Codeunit "Whse.-Sales Release";
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        Text004: Label 'There are unposted prepayment amounts on the document of type %1 with the number %2.';
        Text005: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';

    procedure Reopen(var Claim: Record Claim);
    begin
        OnBeforeReopenClaimDoc(Claim);

        WITH Claim DO BEGIN
            IF Status = Status::Open THEN
                EXIT;
            Status := Status::Open;

            /*IF "Document Type" <> "Document Type"::"Accepted Quote" THEN
              ReopenATOs(ClaimHeader);*/

            MODIFY(TRUE);
            /*IF "Document Type" IN ["Document Type"::Accepted Quote,"Document Type"::"Return Order"] THEN
              WhseSalesRelease.Reopen(SalesHeader);*/
        END;

        OnAfterReopenClaimDoc(Claim);

    end;

    procedure PerformManualRelease(var Claim: Record Claim);
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        WITH Claim DO BEGIN
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

        //IF ApprovalsMgmt.IsClaimApprovalsWorkflowEnabled(Claim) AND (Claim.Status = Claim.Status::Open) THEN
            ERROR(Text002);

        CODEUNIT.RUN(CODEUNIT::"Release Claim Document", Claim);

    end;

    procedure PerformManualReopen(var Claim: Record Claim);
    begin
        IF Claim.Status = Claim.Status::"Pending Approval" THEN
            ERROR(Text003);

        Reopen(Claim);
    end;

    local procedure ReleaseATOs(Claim: Record Claim);
    var
        SalesLine: Record "Sales Line";
        AsmHeader: Record "Assembly Header";
    begin
        /*SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.",SalesHeader."No.");
        IF SalesLine.FINDSET THEN
          REPEAT
            IF SalesLine.AsmToOrderExists(AsmHeader) THEN
              CODEUNIT.RUN(CODEUNIT::"Release Assembly Document",AsmHeader);
          UNTIL SalesLine.NEXT = 0;*/

    end;

    local procedure ReopenATOs(Claim: Record Claim);
    var
        SalesLine: Record "Sales Line";
        AsmHeader: Record "Assembly Header";
        ReleaseAssemblyDocument: Codeunit "Release Assembly Document";
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
    local procedure OnBeforeReleaseClaimDoc(var Claim: Record Claim);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseClaimDoc(var Claim: Record Claim);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenClaimDoc(var Claim: Record Claim);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenClaimDoc(var Claim: Record Claim);
    begin
    end;
}

