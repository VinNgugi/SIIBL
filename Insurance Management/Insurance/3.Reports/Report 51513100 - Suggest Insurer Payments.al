report 51513100 "Suggest Insurer Payments"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Suggest Insurer Payments.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                /*LineNo:=10000;
                ReceiptLines.RESET;
                ReceiptLines.SETRANGE(ReceiptLines.Insurer,Vendor."No.");
                ReceiptLines.SETRANGE(ReceiptLines.Paid,FALSE);
                IF ReceiptLines.FIND('-') THEN BEGIN
                 REPEAT
                 IF Vendor."Hold Commission" THEN BEGIN
                   DetVenLegEntry.RESET;
                   DetVenLegEntry.SETRANGE("Vendor No.","No.");
                   DetVenLegEntry.SETRANGE("Document No.",ReceiptLines."Applies to Doc. No");
                   IF DetVenLegEntry.FIND('-') THEN BEGIN
                      DetVenLegEntry.CALCFIELDS(Amount);
                      AmountPayable:=DetVenLegEntry.Amount;
                      END;
                 END ELSE BEGIN
                  DetCustLedEntry.RESET;
                  DetCustLedEntry.SETRANGE("Document No.",ReceiptLines."Applies to Doc. No");
                  IF DetCustLedEntry.FIND('-') THEN  BEGIN
                     DetCustLedEntry.CALCFIELDS(Amount);
                     AmountPayable:=DetCustLedEntry.Amount-DetCustLedEntry."Policy Charge";
                  END;
                
                 END;
                  PVLines.INIT;
                  PVLines."PV No":=PVNo;
                  PVLines."Line No":=LineNo;
                  PVLines."Account Type":=PVLines."Account Type"::Vendor;
                  PVLines."Account No":=Vendor."No.";
                  PVLines.VALIDATE("Account No");
                  PVLines.Description:=ReceiptLines.Description;
                  PVLines."Client Name":=ReceiptLines."Account Name";
                  PVLines."Original Amount":=AmountPayable;
                
                    RcptLines.RESET;
                    RcptLines.SETCURRENTKEY("Applies to Doc. No",Paid);
                    RcptLines.SETRANGE("Applies to Doc. No",ReceiptLines."Applies to Doc. No");
                    RcptLines.SETRANGE(Paid,TRUE);
                    RcptLines.CALCSUMS(Amount);
                    TotalPayments:=RcptLines.Amount;
                
                    IF TotalPayments<AmountPayable THEN
                     RemainingAmt:=AmountPayable-TotalPayments;
                     IF RemainingAmt>=ReceiptLines.Amount THEN BEGIN
                       PVLines.Amount:=ReceiptLines.Amount;
                       PVLines."Remaining Amount":=RemainingAmt-ReceiptLines.Amount;
                      END ELSE
                      PVLines.Amount:=RemainingAmt;
                  PVLines.VALIDATE(Amount);
                  PVLines."Applies to Doc. No":=ReceiptLines."Applies to Doc. No";
                  PVLines."Applies-to Doc. Type":=PVLines."Applies-to Doc. Type"::Invoice;
                  PVLines."Policy Type":=ReceiptLines."In Payment For";
                
                  PVLines.INSERT;
                  LineNo:=LineNo+10000;
                  ReceiptLines.Paid:=TRUE;
                  ReceiptLines.MODIFY;
                  UNTIL ReceiptLines.NEXT=0;
                
                END;*/

            end;
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

    labels
    {
    }

    var
        ReceiptLines: Record "Receipt Lines";
        LineNo: Integer;
        //PVLines: Record 51513101;
        //PV: Record 51513103;
        PVNo: Code[20];
        PremiumAmt: Decimal;
        SalesHeader: Record 51513030;
        WhtAmount: Decimal;
        Commission: Decimal;
        GLEntry: Record "G/L Entry";
        AmountPayable: Decimal;
        DetVenLegEntry: Record "Vendor Ledger Entry";
        DetCustLedEntry: Record "Cust. Ledger Entry";
        TotalPayments: Decimal;
        RcptLines: Record "Receipt Lines";
        RemainingAmt: Decimal;

    procedure GetNo(Payments: Record Payments1);
    begin
        PVNo := Payments.No;
    end;
}

