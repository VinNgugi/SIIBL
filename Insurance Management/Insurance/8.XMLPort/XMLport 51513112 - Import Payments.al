xmlport 51513112 "Import Payments"
{
    // version AES-INS 1.0

    Format = VariableText;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(ReceiptLines)
        {
            tableelement("Receipt Lines1x"; "Receipt Lines1x")
            {
                XmlName = 'ReceiptLine';
                fieldelement(Desc; "Receipt Lines1x".Description)
                {
                }
                fieldelement(Amt; "Receipt Lines1x".Amount)
                {
                }
                fieldelement(Policy; "Receipt Lines1x"."Policy No.")
                {
                }

                trigger OnBeforeInsertRecord();
                begin

                    "Receipt Lines1x"."Receipt No." := RecptHeader."No.";
                    ReceiptLine.RESET;
                    ReceiptLine.SETRANGE(ReceiptLine."Receipt No.", RecptHeader."No.");
                    IF ReceiptLine.FINDLAST THEN
                        "Receipt Lines1x"."Line No" := ReceiptLine."Line No" + 10000;
                    "Receipt Lines1x".VALIDATE("Receipt Lines1x"."Policy No.");
                end;
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
        RecptHeader: Record "Receipts Header";
        ReceiptLine: Record "Receipt Lines1x";

    procedure GetReceipt(var Rcpt: Record "Receipts Headerx");
    begin
        RecptHeader.COPY(Rcpt);
    end;
}

