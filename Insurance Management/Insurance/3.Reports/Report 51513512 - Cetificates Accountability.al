report 51513512 "Cetificates Accountability"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Cetificates Accountability.rdl';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            column(Picture; CompInfor.Picture)
            {
            }
            column(CName; CompInfor.Name)
            {
            }
            column(CAddress; CompInfor.Address)
            {
            }
            column(CAdd2; CompInfor."Address 2")
            {
            }
            column(CCity; CompInfor.City)
            {
            }
            column(CPhoneNo; CompInfor."Phone No.")
            {
            }
            column(CEmail; CompInfor."E-Mail")
            {
            }
            column(CWeb; CompInfor."Home Page")
            {
            }
            column(CFaxno; CompInfor."Fax No.")
            {
            }
            column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
            {
            }
            column(PostingDate_ItemLedgerEntry; "Item Ledger Entry"."Posting Date")
            {
            }
            column(EntryType_ItemLedgerEntry; "Item Ledger Entry"."Entry Type")
            {
            }
            column(DocumentNo_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
            {
            }
            column(Description_ItemLedgerEntry; "Item Ledger Entry".Description)
            {
            }
            column(LocationCode_ItemLedgerEntry; "Item Ledger Entry"."Location Code")
            {
            }
            column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
            {
            }
            column(RemainingQuantity_ItemLedgerEntry; "Item Ledger Entry"."Remaining Quantity")
            {
            }
            column(InvoicedQuantity_ItemLedgerEntry; "Item Ledger Entry"."Invoiced Quantity")
            {
            }
            column(CountryRegionCode_ItemLedgerEntry; "Item Ledger Entry"."Country/Region Code")
            {
            }
            column(DocumentDate_ItemLedgerEntry; "Item Ledger Entry"."Document Date")
            {
            }
            column(DocumentType_ItemLedgerEntry; "Item Ledger Entry"."Document Type")
            {
            }
            column(SerialNo_ItemLedgerEntry; "Item Ledger Entry"."Serial No.")
            {
            }
            column(ReturnReasonCode_ItemLedgerEntry; "Item Ledger Entry"."Return Reason Code")
            {
            }
            column(Insured; Insured)
            {
            }
            column(FromDate; FromDate)
            {
            }
            column(ToDate; ToDate)
            {
            }
            column(RegNo; RegNo)
            {
            }
            column(CertificatesStatus; CertificatesStatus)
            {
            }
            column(BranchAgent; BranchAgent)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);

                //Insured
                InsureHeader.SETRANGE(InsureHeader."Policy No", "Item Ledger Entry".Description);
                IF InsureHeader.FIND('-') THEN
                    Insured := InsureHeader."Insured Name";
                FromDate := InsureHeader."From Date";
                BranchAgent := InsureHeader."Agent/Broker";
                ToDate := InsureHeader."To Date";

                InsureLine.SETRANGE(InsureLine."Document Type", InsureLine."Document Type"::Policy);
                InsureLine.SETRANGE(InsureLine."Document No.", "Item Ledger Entry".Description);
                IF InsureLine.FIND('-') THEN
                    RegNo := InsureLine."Registration No.";

                CertificatesPrinting.SETRANGE(CertificatesPrinting."Document No.", "Item Ledger Entry".Description);
                IF CertificatesPrinting.FIND('-') THEN
                    CertificatesStatus := CertificatesPrinting.Status;

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
        ReportTitle = 'CERTIFICATES ACCOUNTABILITY';
    }

    var
        CompInfor: Record 79;
        Insured: Text;
        InsureHeader: Record "Insure Header";
        FromDate: Date;
        ToDate: Date;
        SeatingCapacity: Integer;
        RegNo: Code[30];
        CertificatesPrinting: Record "Certificate Printing";
        InsureLine: Record "Insure Lines";
        BranchAgent: Code[10];
        CertificatesStatus: Option;
}

