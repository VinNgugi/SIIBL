codeunit 51403013 "Release Insure Document"
{
    // version AES-INS 1.0

    TableNo = 51513016;

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

        OnBeforeReleaseInsureDoc(Rec);
        OnCheckInsureReleaseRestrictions;

        IF "Document Type" = "Document Type"::Quote THEN
            IF CheckCustomerCreated(TRUE) THEN
                GET("Document Type"::Quote, "No.")
            ELSE
                EXIT;

        TESTFIELD("Insured No.");


        Status := Status::Released;
        MODIFY(TRUE);


        OnAfterReleaseInsureDoc(Rec);
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

    procedure Reopen(var InsureHeader: Record "Insure Header");
    begin
        OnBeforeReopenInureDoc(InsureHeader);

        WITH InsureHeader DO BEGIN
            IF Status = Status::Open THEN
                EXIT;
            Status := Status::Open;

            IF "Document Type" <> "Document Type"::"Accepted Quote" THEN
                ReopenATOs(InsureHeader);

            MODIFY(TRUE);
            /*IF "Document Type" IN ["Document Type"::Accepted Quote,"Document Type"::"Return Order"] THEN
              WhseSalesRelease.Reopen(SalesHeader);*/
        END;

        OnAfterReopenInsureDoc(InsureHeader);

    end;

    procedure PerformManualRelease(var InsureHeader: Record "Insure Header");
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        WITH InsureHeader DO BEGIN

        END;

        //IF ApprovalsMgmt.IsInsureApprovalsWorkflowEnabled(InsureHeader) AND (InsureHeader.Status = InsureHeader.Status::Open) THEN
        //    ERROR(Text002);

        CODEUNIT.RUN(CODEUNIT::"Release Insure Document", InsureHeader);
    end;

    procedure PerformManualReopen(var InsureHeader: Record "Insure Header");
    begin
        IF InsureHeader.Status = InsureHeader.Status::"Pending Approval" THEN
            ERROR(Text003);

        Reopen(InsureHeader);
    end;

    local procedure ReleaseATOs(InsureHeader: Record "Insure Header");
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

    local procedure ReopenATOs(InsureHeader: Record "Insure Header");
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
    local procedure OnBeforeReleaseInsureDoc(var InsureHeader: Record "Insure Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseInsureDoc(var InsureHeader: Record "Insure Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenInureDoc(var InsureHeader: Record "Insure Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenInsureDoc(var InsureHeader: Record "Insure Header");
    begin
    end;
}

