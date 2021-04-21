report 51511010 "Payment Remittance Advise"
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Payment Remittance Advise.rdl';

    dataset
    {
        dataitem("Payments"; "Payments1")
        {
            column(ChequeNo_Payments; Payments."Cheque No")
            {
            }
            column(TotalAmount_Payments; Payments."Total Amount")
            {
            }
            column(VATAmount_Payments; Payments."VAT Amount")
            {
            }
            column(BankName_Payments; Payments."Bank Name")
            {
            }
            column(Amount_Payments; Payments.Amount)
            {
            }
            column(Payee_Payments; Payments.Payee)
            {
            }
            column(CompName; CompName)
            {
            }
            column(CompAddress; CompAddress)
            {
            }
            column(CompPhone; CompPhone)
            {
            }
            column(Fax; Fax)
            {
            }
            column(Email; Email)
            {
            }
            column(Email2; Email2)
            {
            }
            column(Website; Website)
            {
            }
            column(Website2; Website2)
            {
            }
            column(VendorName; VendorName)
            {
            }
            column(VenAddress; VenAddress)
            {
            }
            column(VendCity; VendCity)
            {
            }
            column(BankCaption; BankCaption)
            {
            }
            column(CheckCaption; CheckCaption)
            {
            }
            column(ReportCaption; ReportCaption)
            {
            }
            column(VendorNo; VendorNo)
            {
            }
            column(DiscountCaption; DiscountCaption)
            {
            }
            column(NetAmountCaption; NetAmountCaption)
            {
            }
            column(RemitTo; RemitTo)
            {
            }
            column(GrossAmtCaption; GrossAmtCaption)
            {
            }
            column(TaxAmtCaption; TaxAmtCaption)
            {
            }
            column(CampanyCaption; Campany)
            {
            }
            dataitem("PV Lines"; "PV Lines1")
            {
                DataItemLink = "PV No" = FIELD(No);
                column(AppliestoDocNo_PVLines1; "PV Lines"."Applies to Doc. No")
                {
                }
                column(Description_PVLines1; "PV Lines".Description)
                {
                }
                column(KBABranchCode_PVLines1; "PV Lines"."KBA Branch Code")
                {
                }
                column(VATCode_PVLines1; "PV Lines"."VAT Code")
                {
                }
                column(VATAmount_PVLines1; "PV Lines"."VAT Amount")
                {
                }
                column(Amount_PVLines1; "PV Lines".Amount)
                {
                }
                column(NetAmount_PVLines1; "PV Lines"."Net Amount")
                {
                }
                column(InvoiceCaption; InvoiceCaption)
                {
                }
                column(Reference; Reference)
                {
                }
                column(Branch; Branch)
                {
                }
                column(TaxCode; TaxCode)
                {
                }
                column(TaxAmount; TaxAmount)
                {
                }
                column(Grossamount; Grossamount)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                PVLines.RESET;
                PVLines.SETRANGE("PV No", No);
                IF PVLines.FIND('-') THEN BEGIN
                    VendorNo := PVLines."Account No";
                    VendorName := PVLines."Account Name";
                    IF Vendor.GET(VendorNo) THEN BEGIN
                        VenAddress := Vendor.Address;
                        VendCity := Vendor.City;
                    END;
                END;
                CompanyInformation.GET;
                CompName := CompanyInformation.Name;
                Website2 := CompanyInformation."Home Page";
                Website := CompanyInformation."Home Page";
                Email := CompanyInformation."E-Mail";
                Email2 := CompanyInformation."E-Mail";
                Fax := CompanyInformation."Fax No.";
                CompPhone := CompanyInformation."Phone No.";
                CompAddress := CompanyInformation.Address;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Vendor: Record Vendor;
        VendorName: Text[100];
        VenAddress: Text[100];
        VendCity: Text[30];
        ReportCaption: Label 'PAYMENT REMITTANCE ADVISE';
        BankCaption: Label 'Bank';
        CheckCaption: Label 'Check';
        Campany: Label 'Company';
        DiscountCaption: Label 'Discount Amount';
        TaxAmtCaption: Label 'Tax Amount';
        NetAmountCaption: Label 'Net Amount';
        GrossAmtCaption: Label 'Gross Amount';
        RemitTo: Label 'Remit To:';
        PVLines: Record "PV Lines1";
        VendorNo: Code[20];
        InvoiceCaption: Label 'Invoice';
        Reference: Label 'Reference';
        Branch: Label 'Branch';
        TaxCode: Label 'Tax Code';
        TaxAmount: Label 'Tax Amount';
        Grossamount: Label 'Gross amount';
        CompanyInformation: Record "Company Information";
        CompName: Text;
        CompAddress: Text;
        CompPhone: Text;
        Fax: Text;
        Email: Text;
        Email2: Text;
        Website: Text;
        Website2: Text;
}

