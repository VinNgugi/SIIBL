tableextension 50107 "Gen. Journal LineExt" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Loan No"; Code[20])
        {
            //TableRelation = "Loan Application1";
        }
        field(50001; "Pay Mode"; Code[20])
        {
        }
        field(50002; "Cheque Date"; Date)
        {
        }
        field(50003; Remarks; Text[50])
        {
        }
        field(50004; "Asset No"; Code[20])
        {
            TableRelation = "Fixed Asset";
        }
        field(50005; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name";
        }
        field(50006; "Transaction Type"; Option)
        {
            OptionCaption = ',Registration Fee,Deposit Contribution,Share Contribution,Loan,Loan Repayment,Withdrawal,Interest Due,Interest Paid,Investment,Dividend Paid,Processing Fee,Withholding Tax,BBF Contribution,Admin Charges,Commission';
            OptionMembers = ,"Registration Fee","Deposit Contribution","Share Contribution",Loan,"Loan Repayment",Withdrawal,"Interest Due","Interest Paid",Investment,"Dividend Paid","Processing Fee","Withholding Tax","BBF Contribution","Admin Charges",Commission;
        }
        field(50007; "Receipt and Payment Type"; Code[20])
        {
            // TableRelation = "Receipts and Payment Types";
        }
        field(50008; "Employee Code"; Code[30])
        {
            TableRelation = Employee;
        }
        field(50009; "Policy No"; Code[30])
        {
        }
        field(50010; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(50011; "Insurance Trans Type"; Option)
        {
            OptionCaption = '" ,Premium,Commission,Tax,Wht,Excess,Claim Reserve,Claim Payment,Reinsurance Premium,Reinsurance Commission,Reinsurance Premium Taxes,Reinsurance Commission Taxes,Net Premium,Claim Recovery,Salvage,Reinsurance Claim Reserve,Reinsurance Recovery Payment ,Accrued Reinsurance Premium,Deposit Premium,XOL Adjustment Premium,UPR,IBNR,DAC,Re-UPR,Loan Deposit"';
            OptionMembers = " ",Premium,Commission,Tax,Wht,Excess,"Claim Reserve","Claim Payment","Reinsurance Premium","Reinsurance Commission","Reinsurance Premium Taxes","Reinsurance Commission Taxes","Net Premium","Claim Recovery",Salvage,"Reinsurance Claim Reserve","Reinsurance Recovery Payment ","Accrued Reinsurance Premium","Deposit Premium","XOL Adjustment Premium",UPR,IBNR,DAC,"Re-UPR","Loan Deposit";
        }
        field(50012; "Period Reference"; Date)
        {
        }
        field(50013; "Claim No."; Code[20])
        {
        }
        field(50014; "Investment Code"; Code[20])
        {
            TableRelation = "Fixed Asset";
        }
        field(50015; "No. Of Units"; Decimal)
        {

            trigger OnValidate();
            begin
                /* IF "Receipt Payment Type"="Receipt Payment Type"::"Unit Trust" THEN BEGIN
                 IF Brokers.GET("Unit Trust Member No") THEN BEGIN
                
                 Brokers.CALCFIELDS("No.Of Units","Acquisition Cost","Current Value",Revaluations);
                 IF "No. Of Units">Brokers."No.Of Units" THEN
                  ERROR('You cannot redeem more units than you have!!');
                
                
                   IF  Brokers."No.Of Units" >0 THEN
                // "Current unit price":=Brokers."Current Value"/Brokers."No.Of Units" ;
                 //"Price Per Share":="Current unit price";
                VALIDATE("Price Per Share");
                VALIDATE(Amount);
                  END;
                
                 END ELSE BEGIN
                  IF "No. Of Units"<0 THEN
                  ERROR('You Cannot Sale Negative No. of Shares!!');
                
                   VALIDATE(Amount);
                 END;*/

            end;
        }
        field(50016; "Investment Transcation Type"; Option)
        {
            OptionCaption = ',Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,Share-split,Premium,Discounts,Other Income,Expenses,Loan Repayment,Subsidy,Gain-Loss';
            OptionMembers = ,Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,"Share-split",Premium,Discounts,"Other Income",Expenses,"Loan Repayment",Subsidy,"Gain-Loss";
        }
        field(50017; "Claimant ID"; Integer)
        {
        }
        field(50018; "Effective Start Date"; Date)
        {
        }
        field(50019; "Effective End Date"; Date)
        {
        }
        field(50020; "Insured ID"; Code[20])
        {
            TableRelation = Customer;
        }
        field(50021; "Policy Type"; Code[20])
        {
            TableRelation = "Policy Type";
        }
        field(50022; "Endorsement No."; Code[30])
        {
        }
        field(50044; "Endorsement Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Endorsement Types";
        }
        field(50045; "Action Type"; Option)
        {
            Editable = false;
            OptionCaption = '" ,Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,Yellow Card,Additional Riders"';
            OptionMembers = " ",Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,"Yellow Card","Additional Riders";
        }
        field(50046; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(50047; "Treaty Code"; Code[30])
        {
        }
        field(50048; "Addendum Code"; Integer)
        {
        }
        field(50049; "Layer Code"; Code[10])
        {
        }
        field(50050; "Contract No."; Code[20])
        {
            // TableRelation = Contracts;
        }
        field(50051; "Contract Deliverable No."; Code[20])
        {
            //TableRelation = "Contract Deliverables"."Delivery No." WHERE("Contract No." = FIELD("Contract No."));
        }
        field(50052; "Contract Payment ID"; Integer)
        {
            ///TableRelation = "Contract Payment schedule"."Payment No." WHERE("Contract No." = FIELD("Contract No."));
        }
    }
}
