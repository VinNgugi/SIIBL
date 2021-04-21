xmlport 50111 Custledger
{
    // version AES-INS 1.0

    DefaultFieldsValidation = false;
    FieldDelimiter = '|';
    FieldSeparator = '*';
    Format = VariableText;

    schema
    {
        textelement(Custledger)
        {
            tableelement("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                XmlName = 'Custledgers';
                fieldelement(EntryNo; "Cust. Ledger Entry"."Entry No.")
                {
                }
                fieldelement(GLAccNo; "Cust. Ledger Entry"."Customer No.")
                {
                }
                fieldelement(PostingDate; "Cust. Ledger Entry"."Posting Date")
                {
                }
                fieldelement(DocumentType; "Cust. Ledger Entry"."Document Type")
                {
                }
                fieldelement(DocumentNo; "Cust. Ledger Entry"."Document No.")
                {
                }
                fieldelement(Description; "Cust. Ledger Entry".Description)
                {
                }
                fieldelement(CurrencyCode; "Cust. Ledger Entry"."Currency Code")
                {
                }
                fieldelement(amt; "Cust. Ledger Entry".Amount)
                {
                }
                fieldelement(Remamt; "Cust. Ledger Entry"."Remaining Amount")
                {
                }
                fieldelement(OriginalAmtLCY; "Cust. Ledger Entry"."Original Amt. (LCY)")
                {
                }
                fieldelement(RemAmtLCY; "Cust. Ledger Entry"."Remaining Amt. (LCY)")
                {
                }
                fieldelement(AmtLCY; "Cust. Ledger Entry"."Amount (LCY)")
                {
                }
                fieldelement(SalesLCY; "Cust. Ledger Entry"."Sales (LCY)")
                {
                }
                fieldelement(ProfitLCY; "Cust. Ledger Entry"."Profit (LCY)")
                {
                }
                fieldelement(InvDiscLCY; "Cust. Ledger Entry"."Inv. Discount (LCY)")
                {
                }
                fieldelement(SelltoCustomer; "Cust. Ledger Entry"."Sell-to Customer No.")
                {
                }
                fieldelement(CustPG; "Cust. Ledger Entry"."Customer Posting Group")
                {
                }
                fieldelement(Dim1; "Cust. Ledger Entry"."Global Dimension 1 Code")
                {
                }
                fieldelement(Dim2; "Cust. Ledger Entry"."Global Dimension 2 Code")
                {
                }
                fieldelement(salespersoncode; "Cust. Ledger Entry"."Salesperson Code")
                {
                }
                fieldelement(userid; "Cust. Ledger Entry"."User ID")
                {
                }
                fieldelement(sourcecode; "Cust. Ledger Entry"."Source Code")
                {
                }
                fieldelement(onhold; "Cust. Ledger Entry"."On Hold")
                {
                }
                fieldelement(appliestodoctype; "Cust. Ledger Entry"."Applies-to Doc. Type")
                {
                }
                fieldelement(appliestodoc; "Cust. Ledger Entry"."Applies-to Doc. No.")
                {
                }
                fieldelement(open; "Cust. Ledger Entry".Open)
                {
                }
                fieldelement(duedate; "Cust. Ledger Entry"."Due Date")
                {
                }
                fieldelement(pmtdisc; "Cust. Ledger Entry"."Pmt. Discount Date")
                {
                }
                fieldelement(origpaydisc; "Cust. Ledger Entry"."Original Pmt. Disc. Possible")
                {
                }
                fieldelement(paydiscgiven; "Cust. Ledger Entry"."Pmt. Disc. Given (LCY)")
                {
                }
                fieldelement(positive; "Cust. Ledger Entry".Positive)
                {
                }
                fieldelement(closedbyentry; "Cust. Ledger Entry"."Closed by Entry No.")
                {
                }
                fieldelement(closedatdate; "Cust. Ledger Entry"."Closed at Date")
                {
                }
                fieldelement(closedbyamt; "Cust. Ledger Entry"."Closed by Amount")
                {
                }
                fieldelement(appliestoID; "Cust. Ledger Entry"."Applies-to ID")
                {
                }
                fieldelement(batch; "Cust. Ledger Entry"."Journal Batch Name")
                {
                }
                fieldelement(reasoncode; "Cust. Ledger Entry"."Reason Code")
                {
                }
                fieldelement(balacc; "Cust. Ledger Entry"."Bal. Account Type")
                {
                }
                fieldelement(BalAccType; "Cust. Ledger Entry"."Bal. Account No.")
                {
                }
                fieldelement(Transactionno; "Cust. Ledger Entry"."Transaction No.")
                {
                }
                fieldelement(closedbyamtLCY; "Cust. Ledger Entry"."Closed by Amount (LCY)")
                {
                }
                fieldelement(dr; "Cust. Ledger Entry"."Debit Amount")
                {
                }
                fieldelement(cr; "Cust. Ledger Entry"."Credit Amount")
                {
                }
                fieldelement(drLcy; "Cust. Ledger Entry"."Debit Amount (LCY)")
                {
                }
                fieldelement(CrLCY; "Cust. Ledger Entry"."Credit Amount (LCY)")
                {
                }
                fieldelement(DocDate; "Cust. Ledger Entry"."Document Date")
                {
                }
                fieldelement(ExternalDoc; "Cust. Ledger Entry"."External Document No.")
                {
                }
                fieldelement(CalcInterest; "Cust. Ledger Entry"."Calculate Interest")
                {
                }
                fieldelement(ClosingIntCalc; "Cust. Ledger Entry"."Closing Interest Calculated")
                {
                }
                fieldelement(Noseries; "Cust. Ledger Entry"."No. Series")
                {
                }
                fieldelement(closedbycurr; "Cust. Ledger Entry"."Closed by Currency Code")
                {
                }
                fieldelement(closedbycurramt; "Cust. Ledger Entry"."Closed by Currency Amount")
                {
                }
                fieldelement(adjucurrfactor; "Cust. Ledger Entry"."Adjusted Currency Factor")
                {
                }
                fieldelement(origcurrfactor; "Cust. Ledger Entry"."Original Currency Factor")
                {
                }
                fieldelement(origamt; "Cust. Ledger Entry"."Original Amount")
                {
                }
                fieldelement(datefilter; "Cust. Ledger Entry"."Date Filter")
                {
                }
                fieldelement(remainingpmtdisc; "Cust. Ledger Entry"."Remaining Pmt. Disc. Possible")
                {
                }
                fieldelement(pmtdiscdate; "Cust. Ledger Entry"."Pmt. Disc. Tolerance Date")
                {
                }
                fieldelement(maxpaytol; "Cust. Ledger Entry"."Max. Payment Tolerance")
                {
                }
                fieldelement(lastissuedRem; "Cust. Ledger Entry"."Last Issued Reminder Level")
                {
                }
                fieldelement(accpayTol; "Cust. Ledger Entry"."Accepted Payment Tolerance")
                {
                }
                fieldelement(accpaydiscTol; "Cust. Ledger Entry"."Accepted Pmt. Disc. Tolerance")
                {
                }
                fieldelement(pyttoleranceLCY; "Cust. Ledger Entry"."Pmt. Tolerance (LCY)")
                {
                }
                fieldelement(amt2apply; "Cust. Ledger Entry"."Amount to Apply")
                {
                }
                fieldelement(icpartner; "Cust. Ledger Entry"."IC Partner Code")
                {
                }
                fieldelement(applyentry; "Cust. Ledger Entry"."Applying Entry")
                {
                }
                fieldelement(reversed; "Cust. Ledger Entry".Reversed)
                {
                }
                fieldelement(reversedbyentryno; "Cust. Ledger Entry"."Reversed by Entry No.")
                {
                }
                fieldelement(ReversedEntry; "Cust. Ledger Entry"."Reversed Entry No.")
                {
                }
                fieldelement(prepayment; "Cust. Ledger Entry".Prepayment)
                {
                }
            }
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
}

