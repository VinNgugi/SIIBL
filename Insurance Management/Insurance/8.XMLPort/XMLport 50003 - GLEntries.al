xmlport 50103 GLEntries
{
    // version AES-INS 1.0

    DefaultFieldsValidation = false;
    FieldDelimiter = '|';
    FieldSeparator = '*';
    Format = VariableText;

    schema
    {
        textelement(GLentry)
        {
            tableelement("G/L Entry"; "G/L Entry")
            {
                XmlName = 'Glentries';
                fieldelement(EntryNo; "G/L Entry"."Entry No.")
                {
                }
                fieldelement(GLAccNo; "G/L Entry"."G/L Account No.")
                {
                }
                fieldelement(PostingDate; "G/L Entry"."Posting Date")
                {
                }
                fieldelement(DocumentType; "G/L Entry"."Document Type")
                {
                }
                fieldelement(DocumentNo; "G/L Entry"."Document No.")
                {
                }
                fieldelement(Description; "G/L Entry".Description)
                {
                }
                fieldelement(BalAccNo; "G/L Entry"."Bal. Account No.")
                {
                }
                fieldelement(amt; "G/L Entry".Amount)
                {
                }
                fieldelement(Dim1Code; "G/L Entry"."Global Dimension 1 Code")
                {
                }
                fieldelement(Dim2Code; "G/L Entry"."Global Dimension 2 Code")
                {
                }
                fieldelement(UserId; "G/L Entry"."User ID")
                {
                }
                fieldelement(SourceCode; "G/L Entry"."Source Code")
                {
                }
                fieldelement(syscreated; "G/L Entry"."System-Created Entry")
                {
                }
                fieldelement(PriorYear; "G/L Entry"."Prior-Year Entry")
                {
                }
                fieldelement(JobNo; "G/L Entry"."Job No.")
                {
                }
                fieldelement(Qty; "G/L Entry".Quantity)
                {
                }
                fieldelement(VATamt; "G/L Entry"."VAT Amount")
                {
                }
                fieldelement(BusUnitCode; "G/L Entry"."Business Unit Code")
                {
                }
                fieldelement(JnlBatchName; "G/L Entry"."Journal Batch Name")
                {
                }
                fieldelement(ReasonCode; "G/L Entry"."Reason Code")
                {
                }
                fieldelement(GenPostingType; "G/L Entry"."Gen. Posting Type")
                {
                }
                fieldelement(GenBusPG; "G/L Entry"."Gen. Bus. Posting Group")
                {
                }
                fieldelement(GenProd; "G/L Entry"."Gen. Prod. Posting Group")
                {
                }
                fieldelement(BalAccType; "G/L Entry"."Bal. Account Type")
                {
                }
                fieldelement(TransactionNo; "G/L Entry"."Transaction No.")
                {
                }
                fieldelement(dr; "G/L Entry"."Debit Amount")
                {
                }
                fieldelement(cr; "G/L Entry"."Credit Amount")
                {
                }
                fieldelement(docdate; "G/L Entry"."Document Date")
                {
                }
                fieldelement(externaldoc; "G/L Entry"."External Document No.")
                {
                }
                fieldelement(sourcetype; "G/L Entry"."Source Type")
                {
                }
                fieldelement(sourceno; "G/L Entry"."Source No.")
                {
                }
                fieldelement(noseries; "G/L Entry"."No. Series")
                {
                }
                fieldelement(taxareacode; "G/L Entry"."Tax Area Code")
                {
                }
                fieldelement(TaxLiable; "G/L Entry"."Tax Liable")
                {
                }
                fieldelement(TaxGrpCode; "G/L Entry"."Tax Group Code")
                {
                }
                fieldelement(UseTax; "G/L Entry"."Use Tax")
                {
                }
                fieldelement(VATBus; "G/L Entry"."VAT Bus. Posting Group")
                {
                }
                fieldelement(VATProd; "G/L Entry"."VAT Prod. Posting Group")
                {
                }
                fieldelement(AddCurrencyAmt; "G/L Entry"."Additional-Currency Amount")
                {
                }
                fieldelement(AddCurrDr; "G/L Entry"."Add.-Currency Debit Amount")
                {
                }
                fieldelement(AddCurrCr; "G/L Entry"."Add.-Currency Credit Amount")
                {
                }
                fieldelement(CloseIncomestDim; "G/L Entry"."Close Income Statement Dim. ID")
                {
                }
                fieldelement(ICPartner; "G/L Entry"."IC Partner Code")
                {
                }
                fieldelement(Reversed; "G/L Entry".Reversed)
                {
                }
                fieldelement(ReversedByEntryNo; "G/L Entry"."Reversed by Entry No.")
                {
                }
                fieldelement(ReversedEntryNo; "G/L Entry"."Reversed Entry No.")
                {
                }
                fieldelement(ProdOrderNo; "G/L Entry"."Prod. Order No.")
                {
                }
                fieldelement(FAEntryType; "G/L Entry"."FA Entry Type")
                {
                }
                fieldelement(FAEntryNo; "G/L Entry"."FA Entry No.")
                {
                }
                fieldelement(ClientId; "G/L Entry"."Original Currency Amount")
                {
                }
                fieldelement(ClientName; "G/L Entry".Payee)
                {
                }
                fieldelement(ClssofIns; "G/L Entry"."Original Currency")
                {
                }
                fieldelement(CommissionPercent; "G/L Entry"."Expected Receipt date")
                {
                }
                fieldelement(ClassID; "G/L Entry"."Endorsement Type")
                {
                }
                fieldelement(Types; "G/L Entry"."Action Type")
                {
                }
                /*fieldelement(TaxAmt; "G/L Entry"."Global Dimension 4 Code")
                {
                }*/
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

