xmlport 50125 BankLedgerEntry
{
    // version AES-INS 1.0

    FieldDelimiter = '|';
    FieldSeparator = '*';
    Format = VariableText;

    schema
    {
        textelement(bankledger)
        {
            XmlName = 'BankLedger';
            tableelement("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                XmlName = 'BankLedgers';
                fieldelement(EntryNo; "Bank Account Ledger Entry"."Entry No.")
                {
                }
                fieldelement(BankAcc; "Bank Account Ledger Entry"."Bank Account No.")
                {
                }
                fieldelement(Pdate; "Bank Account Ledger Entry"."Posting Date")
                {
                }
                fieldelement(DocType; "Bank Account Ledger Entry"."Document Type")
                {
                }
                fieldelement(DocNo; "Bank Account Ledger Entry"."Document No.")
                {
                }
                fieldelement(Desc; "Bank Account Ledger Entry".Description)
                {
                }
                fieldelement(CurrCode; "Bank Account Ledger Entry"."Currency Code")
                {
                }
                fieldelement(Amount; "Bank Account Ledger Entry".Amount)
                {
                }
                fieldelement(RemainingAmt; "Bank Account Ledger Entry"."Remaining Amount")
                {
                }
                fieldelement(AmtLCY; "Bank Account Ledger Entry"."Amount (LCY)")
                {
                }
                fieldelement(BankPG; "Bank Account Ledger Entry"."Bank Acc. Posting Group")
                {
                }
                fieldelement(Dim1Code; "Bank Account Ledger Entry"."Global Dimension 1 Code")
                {
                }
                fieldelement(Dim2Code; "Bank Account Ledger Entry"."Global Dimension 2 Code")
                {
                }
                fieldelement(OurContact; "Bank Account Ledger Entry"."Our Contact Code")
                {
                }
                fieldelement(UserID; "Bank Account Ledger Entry"."User ID")
                {
                }
                fieldelement(SourceCode; "Bank Account Ledger Entry"."Source Code")
                {
                }
                fieldelement(Open; "Bank Account Ledger Entry".Open)
                {
                }
                fieldelement(Positive; "Bank Account Ledger Entry".Positive)
                {
                }
                fieldelement(ClosedByEntryNo; "Bank Account Ledger Entry"."Closed by Entry No.")
                {
                }
                fieldelement(ClosedDate; "Bank Account Ledger Entry"."Closed at Date")
                {
                }
                fieldelement(JnlBatchName; "Bank Account Ledger Entry"."Journal Batch Name")
                {
                }
                fieldelement(ReasonCode; "Bank Account Ledger Entry"."Reason Code")
                {
                }
                fieldelement(BalAccType; "Bank Account Ledger Entry"."Bal. Account Type")
                {
                }
                fieldelement(BalAccNo; "Bank Account Ledger Entry"."Bal. Account No.")
                {
                }
                fieldelement(TransNo; "Bank Account Ledger Entry"."Transaction No.")
                {
                }
                fieldelement(StatementStatus; "Bank Account Ledger Entry"."Statement Status")
                {
                }
                fieldelement(StatementNo; "Bank Account Ledger Entry"."Statement No.")
                {
                }
                fieldelement(StatementLineNo; "Bank Account Ledger Entry"."Statement Line No.")
                {
                }
                fieldelement(Dr; "Bank Account Ledger Entry"."Debit Amount")
                {
                }
                fieldelement(Cr; "Bank Account Ledger Entry"."Credit Amount")
                {
                }
                fieldelement(DrLCY; "Bank Account Ledger Entry"."Debit Amount (LCY)")
                {
                }
                fieldelement(CrLCY; "Bank Account Ledger Entry"."Credit Amount (LCY)")
                {
                }
                fieldelement(DocDate; "Bank Account Ledger Entry"."Document Date")
                {
                }
                fieldelement(ExtDocNo; "Bank Account Ledger Entry"."External Document No.")
                {
                }
                fieldelement(Reversed; "Bank Account Ledger Entry".Reversed)
                {
                }
                fieldelement(ReversedbyEntryNo; "Bank Account Ledger Entry"."Reversed by Entry No.")
                {
                }
                fieldelement(ReversedEntryNo; "Bank Account Ledger Entry"."Reversed Entry No.")
                {
                }
                fieldelement(Remarks; "Bank Account Ledger Entry".Remarks)
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

