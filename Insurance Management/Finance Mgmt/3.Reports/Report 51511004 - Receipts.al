report 51511004 Receipts
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Receipts.rdl';

    dataset
    {
        dataitem("Receipts Header"; "Receipts Header")
        {
            RequestFilterFields = "No.";
            column(Coname; COREC.Name)
            {
            }
            column(address; COREC.Address + ' ' + COREC.City)
            {
            }
            column(Logo; COREC.Picture)
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

