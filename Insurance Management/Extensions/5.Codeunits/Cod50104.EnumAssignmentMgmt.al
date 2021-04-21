codeunit 50104 "Enum Assignment Mgmt"
{
    trigger OnRun()
    begin
    end;

    var
        DocumentTypeEnumErr: Label '%1 Document Type %2 enum cannot be converted to %3 Document Type enum.';

    procedure GetCustomerApprovalDocumentType(CustomerDocumentType: Enum "Approval Document Type") ApprovalDocumentType: Enum "Approval Document Type"
    var
        IsHandled: Boolean;
    begin
        Error('Document type is %1', Format(CustomerDocumentType));
        case CustomerDocumentType of
            CustomerDocumentType::"Agent Reg":
                exit(ApprovalDocumentType::"Agent Reg");
            CustomerDocumentType::"Broker Reg":
                exit(ApprovalDocumentType::"Broker Reg");
            CustomerDocumentType::"Insured Reg(Individual)":
                exit(ApprovalDocumentType::"Insured Reg(Individual)");
            CustomerDocumentType::"Insured Reg(Corporate)":
                exit(ApprovalDocumentType::"Insured Reg(Corporate)");
            CustomerDocumentType::"Insurer Reg":
                exit(ApprovalDocumentType::"Insurer Reg");
            CustomerDocumentType::"Re-Insurer Reg":
                exit(ApprovalDocumentType::"Re-Insurer Reg");
            CustomerDocumentType::"Sacco Reg":
                exit(ApprovalDocumentType::"Sacco Reg");
            else begin
                    IsHandled := false;
                    OnGetCustomerApprovalDocumentType(CustomerDocumentType, ApprovalDocumentType, IsHandled);
                    if not IsHandled then
                        error(DocumentTypeEnumErr, 'Customer', CustomerDocumentType, 'Approval');
                end;
        end;
        Error('Document type is %1', Format(ApprovalDocumentType));
    end;

    procedure FnGetInsureHApprovalDocumentType(InsureHDocumentType: Enum "Approval Document Type") ApprovalDocumentType: Enum "Approval Document Type"
    var
        IsHandled: Boolean;
    begin
        case InsureHDocumentType of
            InsureHDocumentType::Quote:
                exit(ApprovalDocumentType::Quote);
            else begin
                    IsHandled := false;
                    OnGetInsureHApprovalDocumentType(InsureHDocumentType, ApprovalDocumentType, IsHandled);
                    if not IsHandled then
                        error(DocumentTypeEnumErr, 'Insure H', InsureHDocumentType, 'Approval');
                end;
        end

    end;

    procedure FnGetBusinessType(InsureHBusinessType: Enum "Business Type") BusinessType: Enum "Business Type"
    var
        IsHandled: Boolean;
    begin
        case InsureHBusinessType of
            InsureHBusinessType::Brokerage:
                exit(BusinessType::Brokerage);
            InsureHBusinessType::"Insurance Company":
                exit(BusinessType::"Insurance Company");
            else begin
                    IsHandled := false;
                    OnGetInsureHBusinessType(InsureHBusinessType, BusinessType, IsHandled);
                    if not IsHandled then
                        error(DocumentTypeEnumErr, 'Business', InsureHBusinessType, 'Business type');
                end;
        end
    end;

    procedure GetPaymentsApprovalDocumentType(PaymentsDocumentType: Enum "Approval Document Type") ApprovalDocumentType: Enum "Approval Document Type"
    var
        IsHandled: Boolean;
    begin
        case PaymentsDocumentType of
            PaymentsDocumentType::"Payment Voucher":
                exit(ApprovalDocumentType::"Payment Voucher");
            else begin
                    IsHandled := false;
                    OnGetPaymentsApprovalDocumentType(PaymentsDocumentType, ApprovalDocumentType, IsHandled);
                    if not IsHandled then
                        error(DocumentTypeEnumErr, 'Payments Header', PaymentsDocumentType, 'Approval');
                end;
        end;
        Error('Document type is %1', Format(ApprovalDocumentType));
    end;


    [IntegrationEvent(false, false)]
    local procedure OnGetCustomerApprovalDocumentType(CustomerDocumentType: Enum "Approval Document Type"; var ApprovalDocumentType: Enum "Approval Document Type"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetInsureHApprovalDocumentType(InsureHDocumentType: Enum "Approval Document Type"; var ApprovalDocumentType: Enum "Approval Document Type"; var IsHandled: Boolean)
    var
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetInsureHBusinessType(InsureHBusinessType: Enum "Business Type"; var BusinessType: Enum "Business Type"; var IsHandled: Boolean)
    var
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetPaymentsApprovalDocumentType(CustomerDocumentType: Enum "Approval Document Type"; var ApprovalDocumentType: Enum "Approval Document Type"; var IsHandled: Boolean)
    begin
    end;
}
