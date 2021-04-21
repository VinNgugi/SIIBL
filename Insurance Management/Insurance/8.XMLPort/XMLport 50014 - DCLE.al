xmlport 50114 DCLE
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
            tableelement("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                XmlName = 'Custledgers';
                fieldelement(EntryNo; "Detailed Cust. Ledg. Entry"."Entry No.")
                {
                }
                fieldelement(GLAccNo; "Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.")
                {
                }
                fieldelement(PostingDate; "Detailed Cust. Ledg. Entry"."Entry Type")
                {
                }
                fieldelement(DocumentType; "Detailed Cust. Ledg. Entry"."Posting Date")
                {
                }
                fieldelement(DocumentNo; "Detailed Cust. Ledg. Entry"."Document Type")
                {
                }
                fieldelement(Description; "Detailed Cust. Ledg. Entry"."Document No.")
                {
                }
                fieldelement(CurrencyCode; "Detailed Cust. Ledg. Entry".Amount)
                {
                }
                fieldelement(amt; "Detailed Cust. Ledg. Entry"."Amount (LCY)")
                {
                }
                fieldelement(Remamt; "Detailed Cust. Ledg. Entry"."Customer No.")
                {
                }
                fieldelement(OriginalAmtLCY; "Detailed Cust. Ledg. Entry"."Currency Code")
                {
                }
                fieldelement(RemAmtLCY; "Detailed Cust. Ledg. Entry"."User ID")
                {
                }
                fieldelement(AmtLCY; "Detailed Cust. Ledg. Entry"."Source Code")
                {
                }
                fieldelement(SalesLCY; "Detailed Cust. Ledg. Entry"."Transaction No.")
                {
                }
                fieldelement(ProfitLCY; "Detailed Cust. Ledg. Entry"."Journal Batch Name")
                {
                }
                fieldelement(InvDiscLCY; "Detailed Cust. Ledg. Entry"."Reason Code")
                {
                }
                fieldelement(SelltoCustomer; "Detailed Cust. Ledg. Entry"."Debit Amount")
                {
                }
                fieldelement(CustPG; "Detailed Cust. Ledg. Entry"."Credit Amount")
                {
                }
                fieldelement(Dim1; "Detailed Cust. Ledg. Entry"."Debit Amount (LCY)")
                {
                }
                fieldelement(Dim2; "Detailed Cust. Ledg. Entry"."Credit Amount (LCY)")
                {
                }
                fieldelement(salespersoncode; "Detailed Cust. Ledg. Entry"."Initial Entry Due Date")
                {
                }
                fieldelement(userid; "Detailed Cust. Ledg. Entry"."Initial Entry Global Dim. 1")
                {
                }
                fieldelement(sourcecode; "Detailed Cust. Ledg. Entry"."Initial Entry Global Dim. 2")
                {
                }
                fieldelement(onhold; "Detailed Cust. Ledg. Entry"."Gen. Bus. Posting Group")
                {
                }
                fieldelement(appliestodoctype; "Detailed Cust. Ledg. Entry"."Gen. Prod. Posting Group")
                {
                }
                fieldelement(appliestodoc; "Detailed Cust. Ledg. Entry"."Use Tax")
                {
                }
                fieldelement(open; "Detailed Cust. Ledg. Entry"."VAT Bus. Posting Group")
                {
                }
                fieldelement(duedate; "Detailed Cust. Ledg. Entry"."VAT Prod. Posting Group")
                {
                }
                fieldelement(pmtdisc; "Detailed Cust. Ledg. Entry"."Initial Document Type")
                {
                }
                fieldelement(origpaydisc; "Detailed Cust. Ledg. Entry"."Applied Cust. Ledger Entry No.")
                {
                }
                fieldelement(paydiscgiven; "Detailed Cust. Ledg. Entry".Unapplied)
                {
                }
                fieldelement(positive; "Detailed Cust. Ledg. Entry"."Unapplied by Entry No.")
                {
                }
                fieldelement(closedbyentry; "Detailed Cust. Ledg. Entry"."Remaining Pmt. Disc. Possible")
                {
                }
                fieldelement(closedatdate; "Detailed Cust. Ledg. Entry"."Max. Payment Tolerance")
                {
                }
                fieldelement(closedbyamt; "Detailed Cust. Ledg. Entry"."Tax Jurisdiction Code")
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

