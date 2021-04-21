xmlport 50115 DVLE
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
            tableelement("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
            {
                XmlName = 'Custledgers';
                fieldelement(EntryNo; "Detailed Vendor Ledg. Entry"."Entry No.")
                {
                }
                fieldelement(GLAccNo; "Detailed Vendor Ledg. Entry"."Vendor Ledger Entry No.")
                {
                }
                fieldelement(PostingDate; "Detailed Vendor Ledg. Entry"."Entry Type")
                {
                }
                fieldelement(DocumentType; "Detailed Vendor Ledg. Entry"."Posting Date")
                {
                }
                fieldelement(DocumentNo; "Detailed Vendor Ledg. Entry"."Document Type")
                {
                }
                fieldelement(Description; "Detailed Vendor Ledg. Entry"."Document No.")
                {
                }
                fieldelement(CurrencyCode; "Detailed Vendor Ledg. Entry".Amount)
                {
                }
                fieldelement(amt; "Detailed Vendor Ledg. Entry"."Amount (LCY)")
                {
                }
                fieldelement(Remamt; "Detailed Vendor Ledg. Entry"."Vendor No.")
                {
                }
                fieldelement(OriginalAmtLCY; "Detailed Vendor Ledg. Entry"."Currency Code")
                {
                }
                fieldelement(RemAmtLCY; "Detailed Vendor Ledg. Entry"."User ID")
                {
                }
                fieldelement(AmtLCY; "Detailed Vendor Ledg. Entry"."Source Code")
                {
                }
                fieldelement(SalesLCY; "Detailed Vendor Ledg. Entry"."Transaction No.")
                {
                }
                fieldelement(ProfitLCY; "Detailed Vendor Ledg. Entry"."Journal Batch Name")
                {
                }
                fieldelement(InvDiscLCY; "Detailed Vendor Ledg. Entry"."Reason Code")
                {
                }
                fieldelement(SelltoCustomer; "Detailed Vendor Ledg. Entry"."Debit Amount")
                {
                }
                fieldelement(CustPG; "Detailed Vendor Ledg. Entry"."Credit Amount")
                {
                }
                fieldelement(Dim1; "Detailed Vendor Ledg. Entry"."Debit Amount (LCY)")
                {
                }
                fieldelement(Dim2; "Detailed Vendor Ledg. Entry"."Credit Amount (LCY)")
                {
                }
                fieldelement(salespersoncode; "Detailed Vendor Ledg. Entry"."Initial Entry Due Date")
                {
                }
                fieldelement(userid; "Detailed Vendor Ledg. Entry"."Initial Entry Global Dim. 1")
                {
                }
                fieldelement(sourcecode; "Detailed Vendor Ledg. Entry"."Initial Entry Global Dim. 2")
                {
                }
                fieldelement(onhold; "Detailed Vendor Ledg. Entry"."Gen. Bus. Posting Group")
                {
                }
                fieldelement(appliestodoctype; "Detailed Vendor Ledg. Entry"."Gen. Prod. Posting Group")
                {
                }
                fieldelement(appliestodoc; "Detailed Vendor Ledg. Entry"."Use Tax")
                {
                }
                fieldelement(open; "Detailed Vendor Ledg. Entry"."VAT Bus. Posting Group")
                {
                }
                fieldelement(duedate; "Detailed Vendor Ledg. Entry"."VAT Prod. Posting Group")
                {
                }
                fieldelement(pmtdisc; "Detailed Vendor Ledg. Entry"."Initial Document Type")
                {
                }
                fieldelement(origpaydisc; "Detailed Vendor Ledg. Entry"."Applied Vend. Ledger Entry No.")
                {
                }
                fieldelement(paydiscgiven; "Detailed Vendor Ledg. Entry".Unapplied)
                {
                }
                fieldelement(positive; "Detailed Vendor Ledg. Entry"."Unapplied by Entry No.")
                {
                }
                fieldelement(closedbyentry; "Detailed Vendor Ledg. Entry"."Remaining Pmt. Disc. Possible")
                {
                }
                fieldelement(closedatdate; "Detailed Vendor Ledg. Entry"."Max. Payment Tolerance")
                {
                }
                fieldelement(closedbyamt; "Detailed Vendor Ledg. Entry"."Tax Jurisdiction Code")
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

