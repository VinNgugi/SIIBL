xmlport 51511000 ExportKCBEFT
{
    // version FINANCE

    Direction = Export;
    Format = FixedText;

    schema
    {
        textelement(PVLINES)
        {
            tableelement("PV Lines"; "PV Lines1")
            {
                XmlName = 'pvlinesrec';
                fieldelement(accountname; "PV Lines"."Account Name")
                {
                    Width = 35;
                }
                /* SNN 03302021 fieldelement(pvno; "PV Lines".Transactionref)
                 {
                     Width = 35;
                 }*/
                fieldelement(bankaccountno; "PV Lines"."Bank Account No")
                {
                    Width = 16;

                    trigger OnAfterAssignField()
                    begin
                        //MESSAGE('we are here now!');
                    end;
                }
                /* SNN 03302021 fieldelement(branchname; "PV Lines"."Bank Name")
                 {
                     Width = 100;
                 }*/
                fieldelement(branchcode; "PV Lines"."KBA Branch Code")
                {
                    Width = 6;
                }
                fieldelement(NetAmount; "PV Lines"."Net Amount")
                {
                    Width = 10;
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

    var
        Reference: Text;
}

