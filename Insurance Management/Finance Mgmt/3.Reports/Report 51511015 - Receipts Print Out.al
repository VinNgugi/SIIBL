report 51511015 "Receipts Print Out"
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Receipts Print Out.rdl';

    dataset
    {
        dataitem("Receipts Header"; "Receipts Header")
        {
            RequestFilterFields = "No.";
            column(CorecPIC; COREC.Picture)
            {
            }
            column(Coname; COREC.Name)
            {
            }
            column(address; COREC.Address + ' ' + COREC.City)
            {
            }
            column(No_ReceiptsHeader1; "Receipts Header"."No.")
            {
            }
            column(Date_ReceiptsHeader1; "Receipts Header".Date)
            {
            }
            column(bankname; Bankrec.Name)
            {
            }
            column(ChequeDate_ReceiptsHeader1; "Receipts Header"."Cheque Date")
            {
            }
            column(txtamount1; txtamount[1])
            {
            }
            column(txtamount2; txtamount[2])
            {
            }
            column(receiptamount; receiptamount)
            {
            }
            column(Cashier_ReceiptsHeader1; "Receipts Header".Cashier)
            {
            }
            /*column(signature; usersetup.Picture)
            {
            }*/
            column(ReceivedFrom_ReceiptsHeader1; "Receipts Header"."Received From")
            {
            }
            column(PayMode_ReceiptsHeader1; "Receipts Header"."Pay Mode")
            {
            }
            column(OnBehalfOf_ReceiptsHeader1; "Receipts Header"."On Behalf Of")
            {
            }
            dataitem("Receipt Lines"; "Receipt Lines")
            {
                DataItemLink = "Receipt No." = FIELD("No.");
                column(LineNo_ReceiptLines; "Receipt Lines"."Line No")
                {
                }
                column(ReceiptNo_ReceiptLines; "Receipt Lines"."Receipt No.")
                {
                }
                column(AccountType_ReceiptLines; "Receipt Lines"."Account Type")
                {
                }
                column(AccountNo_ReceiptLines; "Receipt Lines"."Account No.")
                {
                }
                column(AccountName_ReceiptLines; "Receipt Lines"."Account Name")
                {
                }
                column(Description_ReceiptLines; "Receipt Lines".Description)
                {
                }
                column(VATCode_ReceiptLines; "Receipt Lines"."VAT Code")
                {
                }
                column(WTaxCode_ReceiptLines; "Receipt Lines"."W/Tax Code")
                {
                }
                column(VATAmount_ReceiptLines; "Receipt Lines"."VAT Amount")
                {
                }
                column(WTaxAmount_ReceiptLines; "Receipt Lines"."W/Tax Amount")
                {
                }
                column(Amount_ReceiptLines; "Receipt Lines".Amount)
                {
                }
                column(NetAmount_ReceiptLines; "Receipt Lines"."Net Amount")
                {
                }
                column(GlobalDimension1Code_ReceiptLines; "Receipt Lines"."Global Dimension 1 Code")
                {
                }
                column(GlobalDimension2Code_ReceiptLines; "Receipt Lines"."Global Dimension 2 Code")
                {
                }
                column(AppliestoDocNo_ReceiptLines; "Receipt Lines"."Applies to Doc. No")
                {
                }
                column(AppliestoDocType_ReceiptLines; "Receipt Lines"."Applies-to Doc. Type")
                {
                }
                column(ProcurementMethod_ReceiptLines; "Receipt Lines"."Procurement Method")
                {
                }
                column(ProcurementRequest_ReceiptLines; "Receipt Lines"."Procurement Request")
                {
                }
                column(GlobalDimension3Code_ReceiptLines; "Receipt Lines"."Global Dimension 3 Code")
                {
                }
                column(DocumentType_ReceiptLines; "Receipt Lines"."Document Type")
                {
                }
                column(ReceiptTransactionType_ReceiptLines; "Receipt Lines"."Receipt Transaction Type")
                {
                }
                column(CustomerTransactiontype_ReceiptLines; "Receipt Lines"."Customer Transaction type")
                {
                }
                column(FinancialYear_ReceiptLines; "Receipt Lines"."Financial Year")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                COREC.RESET;
                COREC.GET;
                COREC.CALCFIELDS(Picture);

                Bankrec.RESET;
                Bankrec.GET("Receipts Header"."Bank Code");

                receiptamount := 0;
                receiptlines.RESET;
                receiptlines.SETFILTER("Receipt No.", "Receipts Header"."No.");
                IF receiptlines.FINDSET THEN
                    REPEAT
                        receiptamount += receiptlines.Amount;
                    UNTIL receiptlines.NEXT = 0;

                Checkreport.InitTextVariable;
                Checkreport.FormatNoText(txtamount, receiptamount, 'KES');
                //MESSAGE('%1..%2\%3',txtamount[1],txtamount[2],receiptamount);

                usersetup.RESET;
                usersetup.GET("Receipts Header".Cashier);
                //usersetup.CALCFIELDS(Picture);
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
        COREC: Record "Company Information";
        usersetup: Record "User Setup";
        Bankrec: Record "Bank Account";
        receiptlines: Record 51511028;
        receiptamount: Decimal;
        Checkreport: Report 1401;
        txtamount: array[2] of Text[80];
}

