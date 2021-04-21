page 51511002 "PV Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = 51511001;

    layout
    {
        area(content)
        {
            repeater(Listing)
            {
                field("Account Type";"Account Type")
                {
                }
                field("Account No";"Account No")
                {
                }
                field("Account Name";"Account Name")
                {
                }
                field(Description;Description)
                {
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                }
                field("Applies to Doc. No";"Applies to Doc. No")
                {

                    trigger OnLookup(Var Text : Text) : Boolean;
                    begin
                        VALIDATE(Description);
                        "Applies to Doc. No":='';
                        //"Apply to ID":='';

                          Amt:=0;
                          "VAT Amount":=0;
                          "W/Tax Amount":=0;
                          "Net Amount":=0;

                        IF "Account Type"="Account Type"::Customer THEN
                        BEGIN

                         CustLedger.RESET;
                         CustLedger.SETCURRENTKEY(CustLedger."Customer No.",Open,"Document No.");
                         CustLedger.SETRANGE(CustLedger."Customer No.","Account No");
                         CustLedger.SETRANGE(Open,TRUE);
                         //CustLedger.SETRANGE(CustLedger."Transaction Type",CustLedger."Transaction Type"::"Down Payment");
                         CustLedger.CALCFIELDS(CustLedger.Amount);
                        IF PAGE.RUNMODAL(25,CustLedger) = ACTION::LookupOK THEN BEGIN

                        IF CustLedger."Applies-to ID"<>'' THEN BEGIN
                         CustLedger1.RESET;
                         CustLedger1.SETCURRENTKEY(CustLedger1."Customer No.",Open,"Applies-to ID");
                         CustLedger1.SETRANGE(CustLedger1."Customer No.","Account No");
                         CustLedger1.SETRANGE(Open,TRUE);
                         //CustLedger1.SETRANGE("Transaction Type",CustLedger1."Transaction Type"::"Down Payment");
                         CustLedger1.SETRANGE("Applies-to ID",CustLedger."Applies-to ID");
                         IF CustLedger1.FIND('-') THEN BEGIN
                           REPEAT
                             CustLedger1.CALCFIELDS(CustLedger1.Amount);
                             Amt:=Amt+ABS(CustLedger1.Amount);
                           UNTIL CustLedger1.NEXT=0;
                          END;

                        IF Amt<>Amt THEN
                         //ERROR('Amount is not equal to the amount applied on the application form');
                         IF Amount=0 THEN
                         Amount:=Amt;
                         "Net Amount":=Amount;
                         VALIDATE(Amount);
                           "Applies to Doc. No":=CustLedger."Document No.";
                        //"Apply to ID":=CustLedger."Applies-to ID";
                        END ELSE BEGIN
                        IF Amount<>ABS(CustLedger.Amount) THEN
                        CustLedger.CALCFIELDS(CustLedger."Remaining Amount");
                         IF Amount=0 THEN
                        Amount:=ABS(CustLedger."Remaining Amount");
                         VALIDATE(Amount);
                         //ERROR('Amount is not equal to the amount applied on the application form');

                           "Applies to Doc. No":=CustLedger."Document No.";
                         // "Apply to ID":=CustLedger."Applies-to ID";

                        END;
                        END;

                        //IF "Apply to ID" <> '' THEN
                        //"Apply to":='';

                        VALIDATE(Amount);
                        END;

                        IF "Account Type"="Account Type"::Vendor THEN
                        BEGIN

                         VendLedger.RESET;
                         VendLedger.SETCURRENTKEY(VendLedger."Vendor No.",Open,"Document No.");
                         VendLedger.SETRANGE(VendLedger."Vendor No.","Account No");
                         VendLedger.SETRANGE(Open,TRUE);
                         //CustLedger.SETRANGE(CustLedger."Transaction Type",CustLedger."Transaction Type"::"Down Payment");
                         VendLedger.CALCFIELDS(VendLedger.Amount);
                        IF PAGE.RUNMODAL(29,VendLedger) = ACTION::LookupOK THEN BEGIN

                        IF VendLedger."Applies-to ID"<>'' THEN BEGIN
                         VendLedger1.RESET;
                         VendLedger1.SETCURRENTKEY(VendLedger1."Vendor No.",Open,"Applies-to ID");
                         VendLedger1.SETRANGE(VendLedger1."Vendor No.","Account No");
                         VendLedger1.SETRANGE(Open,TRUE);
                         //CustLedger1.SETRANGE("Transaction Type",CustLedger1."Transaction Type"::"Down Payment");
                         VendLedger1.SETRANGE(VendLedger1."Applies-to ID",VendLedger."Applies-to ID");
                         IF VendLedger1.FIND('-') THEN BEGIN
                           REPEAT
                             VendLedger1.CALCFIELDS(VendLedger1.Amount);

                             Amt:=Amt+ABS(VendLedger1.Amount);

                           UNTIL VendLedger1.NEXT=0;
                          END;

                        IF Amt<>Amt THEN
                         //ERROR('Amount is not equal to the amount applied on the application form');
                          IF Amount=0 THEN
                         Amount:=Amt;

                         VALIDATE(Amount);
                           "Applies to Doc. No":=VendLedger."Document No.";
                        //"Apply to ID":=CustLedger."Applies-to ID";
                        END ELSE BEGIN
                        IF Amount<>ABS(VendLedger.Amount) THEN
                        VendLedger.CALCFIELDS(VendLedger."Remaining Amount");
                         IF Amount=0 THEN
                        Amount:=ABS(VendLedger."Remaining Amount");
                         VALIDATE(Amount);
                         //ERROR('Amount is not equal to the amount applied on the application form');

                           "Applies to Doc. No":=VendLedger."Document No.";
                         // "Apply to ID":=CustLedger."Applies-to ID";

                        END;
                        END;
                        "Net Amount":=ABS(VendLedger.Amount);
                        //IF "Apply to ID" <> '' THEN
                        //"Apply to":='';

                        VALIDATE(Amount);
                        END;
                    end;
                }
                field("Retention Code";"Retention Code")
                {
                }
                field("VAT Code";"VAT Code")
                {
                }
                field("Loan No";"Loan No")
                {
                    Visible = true;
                }
                field("Insurance Trans Type";"Insurance Trans Type")
                {
                }
                field("Transaction Type";"Transaction Type")
                {
                }
                field("Investment Transaction Type";"Investment Transaction Type")
                {
                }
                field("No. of Units";"No. of Units")
                {
                }
                field("Unit Price";"Unit Price")
                {
                }
                field("W/Tax Code";"W/Tax Code")
                {
                }
                field(Amount;Amount)
                {
                }
                field("Retention Amount";"Retention Amount")
                {
                }
                field("W/Tax Amount";"W/Tax Amount")
                {
                    Visible = false;
                }
                field("Net Amount";"Net Amount")
                {
                }
                field("VAT Amount";"VAT Amount")
                {
                    Visible = false;
                }
                field("Policy No";"Policy No")
                {
                }
                field("Claim No";"Claim No")
                {
                }
                field("Claimant ID";"Claimant ID")
                {
                }
                field("Instalment Plan No.";"Instalment Plan No.")
                {
                }
                field("Investment Asset No.";"Investment Asset No.")
                {
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                }
                field("Cash Flow Code";"Shortcut Dimension 4 Code")
                {
                    Caption = 'Cash Flow Code';
                }
                field("Amount(LCY)";"Amount(LCY)")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnModifyRecord() : Boolean;
    begin
        /*
        PaymentsRec.RESET;
        PaymentsRec.SETRANGE(No,"PV no");
        PaymentsRec.SETFILTER(Status,'<>%1',PaymentsRec.Status::Open);
        if PaymentsRec.FIND('-') THEN
           ERROR('You only modify an open record');
                */

    end;

    var
        GenJnlLine : Record 81;
        DefaultBatch : Record 232;
        RecPayTypes : Record 51511002;
        CurrExchRate : Record 330;
        Amt : Decimal;
        CustLedger : Record 21;
        CustLedger1 : Record 21;
        VendLedger : Record 25;
        VendLedger1 : Record 25;
        PolicyRec : Record 112;
        PremiumControlAmt : Decimal;
        BasePremium : Decimal;
        TotalTax : Decimal;
        TotalTaxPercent : Decimal;
        TotalPercent : Decimal;
        SalesInvoiceHeadr : Record 114;
        PaymentsRec : Record 51511000;
        ShortcutDimCode : array [8] of Code[20];
}

