report 51513526 "Insurance Debtors"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Insurance Debtors.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "Global Dimension 1 Code";
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
            column(StartBalanceLCY; StartBalanceLCY)
            {
            }
            column(StartBalance; StartBalance)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(StartBalance2; StartBalance)
            {
                AutoFormatExpression = "Cust. Ledger Entry"."Currency Code";
                AutoFormatType = 1;
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                RequestFilterFields = "Global Dimension 1 Code";
                column(CustomerNo_CustLedgerEntry; "Cust. Ledger Entry"."Customer No.")
                {
                }
                column(PostingDate_CustLedgerEntry; "Cust. Ledger Entry"."Posting Date")
                {
                }
                column(Description_CustLedgerEntry; "Cust. Ledger Entry".Description)
                {
                }
                column(Amount_CustLedgerEntry; "Cust. Ledger Entry".Amount)
                {
                }
                column(DebitAmount_CustLedgerEntry; "Cust. Ledger Entry"."Debit Amount")
                {
                }
                column(CreditAmount_CustLedgerEntry; "Cust. Ledger Entry"."Credit Amount")
                {
                }
                column(DocumentDate_CustLedgerEntry; "Cust. Ledger Entry"."Document Date")
                {
                }
                column(DocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."Document No.")
                {
                }
                column(ChequeNo; ChequeNo)
                {
                }
                column(VendorPin; VendorPin)
                {
                }
                column(Payee; Payee)
                {
                }
                column(BranchName; BranchName)
                {
                }
                column(CustAccBalance; CustAccBalance)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    CompInfor.GET;
                    CompInfor.CALCFIELDS(CompInfor.Picture);
                    IF Vend.GET(Payments."Vendor No") THEN
                        VendorPin := Vend.PIN;

                    IF NOT PrintReversedEntries AND Reversed THEN
                        CurrReport.SKIP;
                    CustLedgEntryExists := TRUE;
                    CustAccBalance := CustAccBalance + Amount;
                    CustAccBalanceLCY := CustAccBalanceLCY + "Amount (LCY)";


                    GenLedgSetup.GET;
                    BranchCode := "Cust. Ledger Entry"."Global Dimension 1 Code";
                    IF Dimvalue.GET(GenLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                        BranchName := Dimvalue.Name;
                end;

                trigger OnPreDataItem();
                begin
                    CustLedgEntryExists := FALSE;
                    CurrReport.CREATETOTALS(Amount, "Amount (LCY)");
                end;
            }
            dataitem("<Integer>s"; 2000000026)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));

                trigger OnAfterGetRecord();
                begin
                    IF NOT CustLedgEntryExists AND ((StartBalance = 0) OR ExcludeBalanceOnly) THEN BEGIN
                        StartBalanceLCY := 0;
                        CurrReport.SKIP;
                    END;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                StartBalance := 0;
                IF DateFilter_BankAccount <> '' THEN
                    IF GETRANGEMIN("Date Filter") <> 0D THEN BEGIN
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        CALCFIELDS("Net Change", "Net Change (LCY)");
                        StartBalance := "Net Change";
                        StartBalanceLCY := "Net Change (LCY)";
                        SETFILTER("Date Filter", DateFilter_BankAccount);
                    END;
                CurrReport.PRINTONLYIFDETAIL := ExcludeBalanceOnly OR (StartBalance = 0);
                CustAccBalance := StartBalance;
                CustAccBalanceLCY := StartBalanceLCY;

                IF PrintOnlyOnePerPage THEN
                    PageGroupNo := PageGroupNo + 1;
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
        CompInfor: Record 79;
        Vend: Record Vendor;
        VendorPin: Code[30];
        Payments: Record Payments1;
        ChequeNo: Code[30];
        Payee: Text;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        BankAccFilter: Text;
        DateFilter_BankAccount: Text[30];
        CustAccBalance: Decimal;
        CustAccBalanceLCY: Decimal;
        StartBalance: Decimal;
        StartBalanceLCY: Decimal;
        CustLedgEntryExists: Boolean;
        PrintReversedEntries: Boolean;
        PageGroupNo: Integer;
        GenLedgSetup: Record "General Ledger Setup";
        Dimvalue: Record "Dimension Value";
        BranchName: Text;
        BranchCode: Code[10];
}

