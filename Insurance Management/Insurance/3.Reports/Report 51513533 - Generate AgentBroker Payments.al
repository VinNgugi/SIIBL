report 51513533 "Generate Agent/Broker Payments"
{
    // version AES-INS 1.0

    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = WHERE("Customer Type" = CONST("Agent/Broker"));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                TotalCommission2Pay := 0;
                Customer.CALCFIELDS(Customer."Net Commission");
                CustLedger1.RESET;
                CustLedger1.SETRANGE(CustLedger1."Customer No.", Customer."No.");
                //CustLedger.SETFILTER(CustLedger."Insurance Trans Type",'%1|%2',CustLedger."Insurance Trans Type"::Commission,CustLedger."Insurance Trans Type"::Wht);
                CustLedger1.SETRANGE(CustLedger1."Insurance Trans Type", CustLedger1."Insurance Trans Type"::"Net Premium");
                IF CustLedger1.FINDFIRST THEN
                    REPEAT

                        CustLedger1.CALCFIELDS(CustLedger1."Remaining Amount");
                        IF CustLedger1."Remaining Amount" = 0 THEN BEGIN

                            CustLedgerCopy1.RESET;
                            CustLedgerCopy1.SETRANGE(CustLedgerCopy1."Posting Date", CustLedger1."Posting Date");
                            CustLedgerCopy1.SETRANGE(CustLedgerCopy1."Document No.", CustLedger1."Document No.");
                            CustLedgerCopy1.SETFILTER(CustLedgerCopy1."Insurance Trans Type", '%1|%2', CustLedgerCopy1."Insurance Trans Type"::Commission, CustLedgerCopy1."Insurance Trans Type"::Wht);
                            IF CustLedgerCopy1.FINDFIRST THEN BEGIN

                                REPEAT

                                    CustLedgerCopy1.CALCFIELDS(CustLedgerCopy1."Remaining Amount");
                                    TotalCommission2Pay := TotalCommission2Pay + CustLedgerCopy1."Remaining Amount";

                                UNTIL CustLedgerCopy1.NEXT = 0;
                            END;
                        END;
                    UNTIL CustLedger1.NEXT = 0;
                //End




                IF TotalCommission2Pay <> 0 THEN BEGIN

                    PV.INIT;
                    PV.No := '';
                    RecPayRec.RESET;
                    RecPayRec.SETRANGE(RecPayRec.Type, RecPayRec.Type::Payment);
                    RecPayRec.SETRANGE(RecPayRec."Insurance Trans Type", RecPayRec."Insurance Trans Type"::Commission);
                    IF RecPayRec.FINDFIRST THEN
                        PV.Type := RecPayRec.Code
                    ELSE
                        ERROR('Please setup a commission payment type on Receipts and Payment type');
                    PV.VALIDATE(PV.Type);
                    PV.Date := TODAY;
                    PV."Account No." := Customer."No.";
                    PV.VALIDATE(PV."Account No.");
                    PV."Pay Mode" := 'EFT';
                    PV.INSERT(TRUE);




                    CustLedger.RESET;
                    CustLedger.SETRANGE(CustLedger."Customer No.", Customer."No.");
                    //CustLedger.SETFILTER(CustLedger."Insurance Trans Type",'%1|%2',CustLedger."Insurance Trans Type"::Commission,CustLedger."Insurance Trans Type"::Wht);
                    CustLedger.SETRANGE(CustLedger."Insurance Trans Type", CustLedger."Insurance Trans Type"::"Net Premium");
                    IF CustLedger.FINDFIRST THEN
                        REPEAT
                            Paycommission := FALSE;
                            TotalPerDebitNote := 0;
                            CustLedger.CALCFIELDS(CustLedger."Remaining Amount");
                            IF CustLedger."Remaining Amount" = 0 THEN BEGIN
                                Paycommission := TRUE;
                                CustLedgerCopy.RESET;
                                CustLedgerCopy.SETRANGE(CustLedgerCopy."Posting Date", CustLedger."Posting Date");
                                CustLedgerCopy.SETRANGE(CustLedgerCopy."Document No.", CustLedger."Document No.");
                                CustLedgerCopy.SETFILTER(CustLedgerCopy."Insurance Trans Type", '%1|%2', CustLedgerCopy."Insurance Trans Type"::Commission, CustLedgerCopy."Insurance Trans Type"::Wht);
                                IF CustLedgerCopy.FINDFIRST THEN BEGIN

                                    REPEAT

                                        Pvlines.INIT;
                                        Pvlines."PV No" := PV.No;
                                        Pvlines."Line No" := Pvlines."Line No" + 10000;
                                        Pvlines."Account Type" := Pvlines."Account Type"::Customer;
                                        Pvlines."Account No" := CustLedgerCopy."Customer No.";
                                        Pvlines.VALIDATE(Pvlines."Account No");
                                        Pvlines."Applies to Doc. No" := CustLedgerCopy."Document No.";
                                        Pvlines.VALIDATE(Pvlines."Applies to Doc. No");
                                        CustLedgerCopy.CALCFIELDS(CustLedgerCopy."Remaining Amount");
                                        Pvlines.Amount := -CustLedgerCopy."Remaining Amount";
                                        TotalPerDebitNote := TotalPerDebitNote + CustLedgerCopy."Remaining Amount";
                                        Pvlines.VALIDATE(Pvlines.Amount);
                                        Pvlines.Description := STRSUBSTNO('Commission Payment %1', WORKDATE);
                                        Pvlines."Insurance Trans Type" := CustLedgerCopy."Insurance Trans Type";
                                        Pvlines."Shortcut Dimension 1 Code" := CustLedgerCopy."Global Dimension 1 Code";
                                        Pvlines."Shortcut Dimension 2 Code" := CustLedgerCopy."Global Dimension 2 Code";
                                        //Pvlines."Shortcut Dimension 3 Code" := CustLedgerCopy."Global Dimension 3 Code";
                                        Pvlines."Shortcut Dimension 4 Code" := CustLedgerCopy."Global Dimension 4 Code";

                                        IF Pvlines.Amount <> 0 THEN
                                            Pvlines.INSERT;
                                    UNTIL CustLedgerCopy.NEXT = 0;
                                END;
                            END;
                        UNTIL CustLedger.NEXT = 0;
                END;
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
        CustLedger: Record "Cust. Ledger Entry";
        PV: Record Payments1;
        Pvlines: Record 51511001;
        CustLedgerCopy: Record "Cust. Ledger Entry";
        RecPayRec: Record 51511002;
        Paycommission: Boolean;
        TotalPerDebitNote: Decimal;
        CustLedger1: Record "Cust. Ledger Entry";
        Custledger1Copy: Record "Cust. Ledger Entry";
        TotalCommission2Pay: Decimal;
        CustLedgerCopy1: Record "Cust. Ledger Entry";
}

