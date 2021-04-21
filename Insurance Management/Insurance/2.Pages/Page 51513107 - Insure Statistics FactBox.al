page 51513107 "Insure Statistics FactBox"
{
    // version AES-INS 1.0

    Caption = 'Customer Statistics';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
                Caption = 'Customer No.';

                trigger OnDrillDown();
                begin
                    ShowDetails;
                end;
            }
            field("Balance (LCY)"; "Balance (LCY)")
            {

                trigger OnDrillDown();
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    DtldCustLedgEntry.SETRANGE("Customer No.", "No.");
                    COPYFILTER("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                    COPYFILTER("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                    COPYFILTER("Currency Filter", DtldCustLedgEntry."Currency Code");
                    CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                end;
            }
            field("Total (LCY)"; GetTotalAmountLCY)
            {
                AccessByPermission = TableData 37 = R;
                AutoFormatType = 1;
                Caption = 'Total (LCY)';
                Importance = Promoted;
                Style = Strong;
                StyleExpr = TRUE;
            }
            field("Credit Limit (LCY)"; "Credit Limit (LCY)")
            {
            }
            field("Balance Due (LCY)"; CalcOverdueBalance)
            {
                CaptionClass = FORMAT(STRSUBSTNO(Text000, FORMAT(WORKDATE)));

                trigger OnDrillDown();
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    DtldCustLedgEntry.SETFILTER("Customer No.", "No.");
                    COPYFILTER("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                    COPYFILTER("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                    COPYFILTER("Currency Filter", DtldCustLedgEntry."Currency Code");
                    CustLedgEntry.DrillDownOnOverdueEntries(DtldCustLedgEntry);
                end;
            }
            field("Sales (LCY)"; GetSalesLCY)
            {
                Caption = 'Total Sales (LCY)';

                trigger OnDrillDown();
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                    AccountingPeriod: Record "Accounting Period";
                begin
                    CustLedgEntry.RESET;
                    CustLedgEntry.SETRANGE("Customer No.", "No.");
                    CustLedgEntry.SETRANGE(
                      "Posting Date", AccountingPeriod.GetFiscalYearStartDate(WORKDATE), AccountingPeriod.GetFiscalYearEndDate(WORKDATE));
                    PAGE.RUNMODAL(PAGE::"Customer Ledger Entries", CustLedgEntry);
                end;
            }
        }
    }

    actions
    {
    }

    var
        Text000: Label 'Overdue Amounts (LCY) as of %1';

    local procedure ShowDetails();
    begin
        PAGE.RUN(PAGE::"Customer Card", Rec);
    end;
}

