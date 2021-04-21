codeunit 51511004 Committments
{
    // version FINANCE


    trigger OnRun()
    begin
    end;

    var
        PartialImprest: Record "Partial Imprest Issue";
        CashMngt: Record "Cash Management Setup";
        //WorkPlanActvity: Record 51511205;
        //PEActvity: Record 51511390;
        UncommittmentDate: Date;
        //ProcPlan: Record 51511391;
        //workplanrec: Record 51511205;
        //adminrec: Record 51511390;
        //Procrec: Record 51511391;
        GLSETUP88: Record "General Ledger Setup";
        GLsetup: Record "General Ledger Setup";
        dialogw: Dialog;
        conf: Boolean;
        I: Integer;
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Empl: Record Employee;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;

    [Scope('Internal')]
    procedure FnCommitAmountPR(RequisitionHeader: Record 51511398)
    var
        RequisitionLines: Record 51511399;
        CommitmentEntries: Record "Commitment Entries";
        LastEntryNo: Integer;
    begin
        RequisitionLines.RESET;
        RequisitionLines.SETRANGE(RequisitionLines."Requisition No", RequisitionHeader."No.");
        RequisitionLines.SETFILTER(RequisitionLines.Committed, '%1', FALSE);
        IF RequisitionLines.FIND('-') THEN BEGIN
            REPEAT
                IF CommitmentEntries.FINDLAST THEN BEGIN
                    LastEntryNo := CommitmentEntries."Entry No";
                END;
                CommitmentEntries.INIT;
                CommitmentEntries."Entry No" := LastEntryNo + CommitmentEntries.COUNT;
                CommitmentEntries."Account No." := RequisitionLines.No;
                CommitmentEntries.Amount := RequisitionLines.Amount;
                CommitmentEntries."Commitment Date" := TODAY;
                CommitmentEntries."Time Stamp" := TIME;
                CommitmentEntries."Budget Line" := RequisitionLines."Budget Line";
                CommitmentEntries."Budget Year" := RequisitionLines."Current Budget";
                CommitmentEntries.Type := CommitmentEntries.Type::Reservation;
                CommitmentEntries."User ID" := USERID;
                CommitmentEntries.INSERT(TRUE);
                RequisitionLines.Committed := TRUE;
                RequisitionLines.MODIFY;
            UNTIL RequisitionLines.NEXT = 0;
            MESSAGE('Reservation completed successfully!!');
        END;
    end;

    [Scope('Internal')]
    procedure FnReleaseCommitAmountPR(RequisitionHeader: Record 51511398)
    var
        RequisitionLines: Record 51511399;
        CommitmentEntries: Record "Commitment Entries";
        LastEntryNo: Integer;
    begin
        RequisitionLines.RESET;
        RequisitionLines.SETRANGE(RequisitionLines."Requisition No", RequisitionHeader."No.");
        //RequisitionLines.SETFILTER(RequisitionLines."Line No",'%1',RequisitionLines."Line No");
        IF RequisitionLines.FIND('-') THEN BEGIN
            REPEAT
                IF CommitmentEntries.FINDLAST THEN BEGIN
                    LastEntryNo := CommitmentEntries."Entry No";
                END;
                CommitmentEntries.INIT;
                CommitmentEntries."Entry No" := LastEntryNo + CommitmentEntries.COUNT;
                CommitmentEntries."Account No." := RequisitionLines.No;
                CommitmentEntries.Amount := -RequisitionLines.Amount;
                CommitmentEntries."Commitment Date" := TODAY;
                CommitmentEntries."Time Stamp" := TIME;
                CommitmentEntries."Budget Line" := RequisitionLines."Budget Line";
                CommitmentEntries."Budget Year" := RequisitionLines."Current Budget";
                CommitmentEntries.Type := CommitmentEntries.Type::Reversal;
                CommitmentEntries.INSERT(TRUE);
            UNTIL RequisitionLines.NEXT = 0;
            MESSAGE('Reservation Reversal completed successfully. Thank you');
        END;
    end;

    procedure FnCommitLPO(PurchaseHeader: Record 38)
    var
        CommitmentEntries: Record "Commitment Entries";
        LastEntryNo: Integer;
    begin
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
        PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        IF PurchaseLine.FINDSET THEN BEGIN
            REPEAT
                IF CommitmentEntries.FINDLAST THEN
                    LastEntryNo := CommitmentEntries."Entry No";
                CommitmentEntries.INIT;
                CommitmentEntries."Entry No" := LastEntryNo + CommitmentEntries.COUNT;
                CommitmentEntries."Account No." := PurchaseLine."Document No.";
                CommitmentEntries.Amount := PurchaseLine.Amount;
                CommitmentEntries."Commitment Date" := TODAY;
                CommitmentEntries."Time Stamp" := TIME;
                //CommitmentEntries."Budget Line" := PurchaseLine."Current Budget";
                //CommitmentEntries."Budget Year" := PurchaseLine."Current Budget";
                CommitmentEntries.Type := CommitmentEntries.Type::Committed;
                CommitmentEntries.INSERT(TRUE);
                MESSAGE('Commitment completed successfully. Thank you');
            UNTIL PurchaseLine.NEXT = 0;
        END;
    end;

    procedure FnReleaseCommitLPO(PurchaseHeader: Record 38)
    var
        CommitmentEntries: Record "Commitment Entries";
        LastEntryNo: Integer;
    begin
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
        PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        IF PurchaseLine.FINDSET THEN BEGIN
            REPEAT
                IF CommitmentEntries.FINDLAST THEN
                    LastEntryNo := CommitmentEntries."Entry No";
                CommitmentEntries.INIT;
                CommitmentEntries."Entry No" := LastEntryNo + CommitmentEntries.COUNT;
                CommitmentEntries."Account No." := PurchaseLine."Document No.";
                CommitmentEntries.Amount := -PurchaseLine.Amount;
                CommitmentEntries."Commitment Date" := TODAY;
                CommitmentEntries."Time Stamp" := TIME;
                //CommitmentEntries."Budget Line" := PurchaseLine."Current Budget";
                //CommitmentEntries."Budget Year" := PurchaseLine."Current Budget";
                CommitmentEntries.Type := CommitmentEntries.Type::Reversal;
                CommitmentEntries.INSERT(TRUE);
                MESSAGE('Committed Reversal completed successfully. Thank you');
            UNTIL PurchaseLine.NEXT = 0;
        END;
    end;
}

