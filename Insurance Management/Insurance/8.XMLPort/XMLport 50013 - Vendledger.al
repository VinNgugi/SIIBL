xmlport 50113 Vendledger
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
            tableelement("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                XmlName = 'Custledgers';
                fieldelement(EntryNo; "Vendor Ledger Entry"."Entry No.")
                {
                }
                fieldelement(GLAccNo; "Vendor Ledger Entry"."Vendor No.")
                {
                }
                fieldelement(PostingDate; "Vendor Ledger Entry"."Posting Date")
                {
                }
                fieldelement(DocumentType; "Vendor Ledger Entry"."Document Type")
                {
                }
                fieldelement(DocumentNo; "Vendor Ledger Entry"."Document No.")
                {
                }
                fieldelement(Description; "Vendor Ledger Entry".Description)
                {
                }
                fieldelement(CurrencyCode; "Vendor Ledger Entry"."Currency Code")
                {
                }
                fieldelement(amt; "Vendor Ledger Entry".Amount)
                {
                }
                fieldelement(Remamt; "Vendor Ledger Entry"."Remaining Amount")
                {
                }
                fieldelement(OriginalAmtLCY; "Vendor Ledger Entry"."Original Amt. (LCY)")
                {
                }
                fieldelement(RemAmtLCY; "Vendor Ledger Entry"."Remaining Amt. (LCY)")
                {
                }
                fieldelement(AmtLCY; "Vendor Ledger Entry"."Amount (LCY)")
                {
                }
                fieldelement(SalesLCY; "Vendor Ledger Entry"."Purchase (LCY)")
                {
                }
                fieldelement(ProfitLCY; "Vendor Ledger Entry"."Inv. Discount (LCY)")
                {
                }
                fieldelement(InvDiscLCY; "Vendor Ledger Entry"."Buy-from Vendor No.")
                {
                }
                fieldelement(SelltoCustomer; "Vendor Ledger Entry"."Vendor Posting Group")
                {
                }
                fieldelement(CustPG; "Vendor Ledger Entry"."Global Dimension 1 Code")
                {
                }
                fieldelement(Dim1; "Vendor Ledger Entry"."Global Dimension 2 Code")
                {
                }
                fieldelement(Dim2; "Vendor Ledger Entry"."Purchaser Code")
                {
                }
                fieldelement(salespersoncode; "Vendor Ledger Entry"."User ID")
                {
                }
                fieldelement(userid; "Vendor Ledger Entry"."Source Code")
                {
                }
                fieldelement(sourcecode; "Vendor Ledger Entry"."On Hold")
                {
                }
                fieldelement(onhold; "Vendor Ledger Entry"."Applies-to Doc. Type")
                {
                }
                fieldelement(appliestodoctype; "Vendor Ledger Entry"."Applies-to Doc. No.")
                {
                }
                fieldelement(appliestodoc; "Vendor Ledger Entry".Open)
                {
                }
                fieldelement(open; "Vendor Ledger Entry"."Due Date")
                {
                }
                fieldelement(duedate; "Vendor Ledger Entry"."Pmt. Discount Date")
                {
                }
                fieldelement(pmtdisc; "Vendor Ledger Entry"."Original Pmt. Disc. Possible")
                {
                }
                fieldelement(origpaydisc; "Vendor Ledger Entry"."Pmt. Disc. Rcd.(LCY)")
                {
                }
                fieldelement(paydiscgiven; "Vendor Ledger Entry".Positive)
                {
                }
                fieldelement(positive; "Vendor Ledger Entry"."Closed by Entry No.")
                {
                }
                fieldelement(closedbyentry; "Vendor Ledger Entry"."Closed at Date")
                {
                }
                fieldelement(closedatdate; "Vendor Ledger Entry"."Closed by Amount")
                {
                }
                fieldelement(closedbyamt; "Vendor Ledger Entry"."Applies-to ID")
                {
                }
                fieldelement(appliestoID; "Vendor Ledger Entry"."Journal Batch Name")
                {
                }
                fieldelement(batch; "Vendor Ledger Entry"."Reason Code")
                {
                }
                fieldelement(reasoncode; "Vendor Ledger Entry"."Bal. Account Type")
                {
                }
                fieldelement(balacc; "Vendor Ledger Entry"."Bal. Account No.")
                {
                }
                fieldelement(BalAccType; "Vendor Ledger Entry"."Transaction No.")
                {
                }
                fieldelement(Transactionno; "Vendor Ledger Entry"."Closed by Amount (LCY)")
                {
                }
                fieldelement(closedbyamtLCY; "Vendor Ledger Entry"."Debit Amount")
                {
                }
                fieldelement(dr; "Vendor Ledger Entry"."Credit Amount")
                {
                }
                fieldelement(cr; "Vendor Ledger Entry"."Debit Amount (LCY)")
                {
                }
                fieldelement(drLcy; "Vendor Ledger Entry"."Credit Amount (LCY)")
                {
                }
                fieldelement(CrLCY; "Vendor Ledger Entry"."Document Date")
                {
                }
                fieldelement(DocDate; "Vendor Ledger Entry"."External Document No.")
                {
                }
                fieldelement(ExternalDoc; "Vendor Ledger Entry"."No. Series")
                {
                }
                fieldelement(CalcInterest; "Vendor Ledger Entry"."Closed by Currency Code")
                {
                }
                fieldelement(ClosingIntCalc; "Vendor Ledger Entry"."Closed by Currency Amount")
                {
                }
                fieldelement(Noseries; "Vendor Ledger Entry"."Adjusted Currency Factor")
                {
                }
                fieldelement(closedbycurr; "Vendor Ledger Entry"."Original Currency Factor")
                {
                }
                fieldelement(closedbycurramt; "Vendor Ledger Entry"."Original Amount")
                {
                }
                fieldelement(adjucurrfactor; "Vendor Ledger Entry"."Date Filter")
                {
                }
                fieldelement(origcurrfactor; "Vendor Ledger Entry"."Remaining Pmt. Disc. Possible")
                {
                }
                fieldelement(origamt; "Vendor Ledger Entry"."Pmt. Disc. Tolerance Date")
                {
                }
                fieldelement(datefilter; "Vendor Ledger Entry"."Max. Payment Tolerance")
                {
                }
                fieldelement(remainingpmtdisc; "Vendor Ledger Entry"."Accepted Payment Tolerance")
                {
                }
                fieldelement(pmtdiscdate; "Vendor Ledger Entry"."Accepted Pmt. Disc. Tolerance")
                {
                }
                fieldelement(maxpaytol; "Vendor Ledger Entry"."Pmt. Tolerance (LCY)")
                {
                }
                fieldelement(lastissuedRem; "Vendor Ledger Entry"."Amount to Apply")
                {
                }
                fieldelement(accpayTol; "Vendor Ledger Entry"."IC Partner Code")
                {
                }
                fieldelement(accpaydiscTol; "Vendor Ledger Entry"."Applying Entry")
                {
                }
                fieldelement(pyttoleranceLCY; "Vendor Ledger Entry".Reversed)
                {
                }
                fieldelement(amt2apply; "Vendor Ledger Entry"."Reversed by Entry No.")
                {
                }
                fieldelement(icpartner; "Vendor Ledger Entry"."Reversed Entry No.")
                {
                }
                fieldelement(applyentry; "Vendor Ledger Entry".Prepayment)
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

