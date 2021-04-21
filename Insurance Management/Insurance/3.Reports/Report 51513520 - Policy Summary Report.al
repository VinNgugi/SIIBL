report 51513520 "Policy Summary Report"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Policy Summary Report.rdl';

    dataset
    {
        dataitem("Certificate Printing"; "Certificate Printing")
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                WHERE(Printed = FILTER(True));
            RequestFilterFields = "Printed By";
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
            column(Insured; Insured)
            {
            }
            column(DocNumber; DocNumber)
            {
            }
            column(BranchAgent; BranchAgent)
            {
            }
            column(DocumentType_CertificatePrinting; "Certificate Printing"."Document Type")
            {
            }
            column(CertificateNo_CertificatePrinting; "Certificate Printing"."Certificate No.")
            {
            }
            column(DocumentNo_CertificatePrinting; "Certificate Printing"."Document No.")
            {
            }
            column(NetPremium_CertificatePrinting; "Certificate Printing"."Net Premium")
            {
            }
            column(Status_CertificatePrintings; "Certificate Printing".Status)
            {
            }
            column(CoverDescription_CertificatePrinting; "Certificate Printing"."Cover Description")
            {
            }
            column(RegistrationNo_CertificatePrinting; "Certificate Printing"."Registration No.")
            {
            }
            column(SeatingCapacity_CertificatePrinting; "Certificate Printing"."Seating Capacity")
            {
            }
            column(DescriptionType_CertificatePrinting; "Certificate Printing"."Description Type")
            {
            }
            column(StartDate_CertificatePrinting; "Certificate Printing"."Start Date")
            {
            }
            column(EndDate_CertificatePrinting; "Certificate Printing"."End Date")
            {
            }
            column(SerialNo_CertificatePrinting; "Certificate Printing"."Serial No")
            {
            }
            column(Amount_CertificatePrinting; "Certificate Printing".Amount)
            {
            }
            column(TPOPremium_CertificatePrinting; "Certificate Printing"."TPO Premium")
            {
            }
            column(CertificateStatus_CertificatePrinting; "Certificate Printing"."Certificate Status")
            {
            }
            column(DatePrinted_CertificatePrinting; "Certificate Printing"."Insured No.")
            {
            }
            column(ItemEntryNo_CertificatePrinting; "Certificate Printing"."Print Time")
            {
            }
            column(PolicyNo_CertificatePrinting; "Certificate Printing"."Policy No")
            {
            }
            column(ReceiptNo; ReceiptNo)
            {
            }
            column(ShortCode; ShortCode)
            {
            }
            column(ReceiptAmount; ReceiptAmount)
            {
            }
            column(EndorsementNo; EndorsementNo)
            {
            }
            column(BranchName; BranchName)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                "Certificate Printing".SETRANGE("Certificate Printing"."Document No.", "Certificate Printing"."Document No.");
                //"Certificate Printing".SETRANGE("Certificate Printing"."Policy No", "Certificate Printing"."Policy No");
                "Certificate Printing".FINDLAST;
                IF PolicyType.GET("Policy Type") THEN
                    ShortCode := PolicyType."short code";
                GenLedgSetup.GET;
                BranchCode := "Certificate Printing"."Shortcut Dimension 1 Code";
                IF DimValue.GET(GenLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;


                //Insured
                InsureHeader.SETRANGE(InsureHeader."Policy No", "Certificate Printing"."Policy No");
                IF InsureHeader.FIND('-') THEN
                    Insured := InsureHeader."Insured Name";
                EndorsementNo := InsureHeader."Endorsement Policy No.";

                ReceiptLines1x.SETRANGE(ReceiptLines1x."Applies to Doc. No", "Certificate Printing"."Document No.");
                IF ReceiptLines1x.FIND('-') THEN
                    ReceiptNo := ReceiptLines1x."Receipt No.";
                //ReceiptLines1x.CALCFIELDS(ReceiptLines1x."Net Amount");
                ReceiptAmount := ReceiptLines1x."Net Amount";



                "Certificate Printing".SETRANGE("Certificate Printing"."Document No.");
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
        ReportTitle = 'POLICY SUMMARY REPORT';
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
        BankAccLedgEntry: Record 271;
        DocNumber: Text;
        ReceiptLines1x: Record "Receipt Lines";
        ReceiptNo: Code[30];
        ReceiptAmount: Decimal;
        ShortCode: Code[30];
        PolicyType: Record "Policy Type";
        EndorsementNo: Code[30];
        GenLedgSetup: Record "General Ledger Setup";
        BranchName: Text;
        BranchCode: Code[30];
        DimValue: Record "Dimension Value";
}

