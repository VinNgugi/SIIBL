xmlport 51511001 ExportNBKEFT
{
    // version FINANCE

    Direction = Export;
    Format = VariableText;

    schema
    {
        textelement(PVLINES)
        {
            tableelement("PV Lines"; "PV Lines1")
            {
                XmlName = 'pvlinesrec';
                fieldelement(REFNUMBER; "PV Lines"."Line No")
                {
                }
                fieldelement(EMPLOYEENAME; "PV Lines"."Account Name")
                {
                    Width = 35;
                }
                textelement(BANKNAME)
                {
                }
                /* SNN 03302021 fieldelement(BANKBRANCH; "PV Lines"."Branch Name")
                {
                    Width = 21;
                }*/
                fieldelement(BANKCODE; "PV Lines"."KBA Branch Code")
                {
                    Width = 16;
                }
                fieldelement(ACNUMBER; "PV Lines"."Bal. Account No.")
                {
                    Width = 35;
                }
                fieldelement(AMOUNT; "PV Lines"."Net Amount")
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
}

