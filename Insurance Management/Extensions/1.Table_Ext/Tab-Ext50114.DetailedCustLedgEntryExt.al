tableextension 50114 "Detailed Cust. Ledg. EntryExt" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        field(50010; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
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
        field(50018; "Endorsement No."; Code[30])
        {
        }
        field(50020; "Insured ID"; Code[20])
        {
            TableRelation = Customer;
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
        field(50046; "Global Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(50047; "Policy Type"; Code[20])
        {
            TableRelation = "Policy Type";
        }
        field(55000; "Submission Type"; Option)
        {
            OptionCaption = '" ,Premium,Claim,Refund,Alteration,Commission,Receipt,Payment,Refund Commission,Car Loan,Mortgage"';
            OptionMembers = " ",Premium,Claim,Refund,Alteration,Commission,Receipt,Payment,"Refund Commission","Car Loan",Mortgage;
        }
        field(55001; "Apportionment Type"; Option)
        {
            OptionCaption = '" ,Quota Share,Surplus,Fucultative,Excess Of Loss"';
            OptionMembers = " ","Quota Share",Surplus,Fucultative,"Excess Of Loss";
        }
        field(55002; "Cedant Code"; Code[30])
        {
            TableRelation = Customer."No." WHERE(Type = CONST(Cedant));
        }
        field(55003; "Treaty Code"; Code[30])
        {
            TableRelation = Treaty."Treaty Code";
        }
        field(55004; "Addendum Code"; Integer)
        {
            TableRelation = Treaty."Addendum Code";
        }
        field(55005; "Product Code"; Code[30])
        {
            TableRelation = "Product Types"."product code";
        }
        field(55006; "Period Ended"; Date)
        {
        }
        field(55007; "Member No"; Code[30])
        {
            //TableRelation = "LF Grp Scheme Members"."Member No";
        }
        field(55008; "Lot No"; Code[10])
        {
            TableRelation = "Group Scheme"."Lot No.";
        }
        field(55009; "Policy Code"; Code[30])
        {
            TableRelation = "Group Scheme"."Policy Code";
        }
        field(55010; "KRC Claim No."; Code[30])
        {
        }
        field(55011; "Inception date"; Date)
        {
        }
        field(55012; "Refund No."; Code[30])
        {
        }
        field(55013; Individual; Boolean)
        {
        }
        field(55014; "Policy Number"; Code[30])
        {
        }
        field(55015; Year; Integer)
        {
        }
        field(55016; Retro; Boolean)
        {
        }
        field(55017; "Reassurer Code"; Code[10])
        {
        }
        field(55018; Broker; Boolean)
        {
        }
        field(55019; "Cash Call"; Boolean)
        {
        }
        field(68000; "Transaction Type"; Option)
        {
            OptionCaption = '" ,Registration Fee,Deposit Contribution,Share Contribution,Loan,Loan Repayment,Withdrawal,Interest Due,Interest Paid,Investment,Dividend Paid,Processing Fee,Withholding Tax,BBF Contribution"';
            OptionMembers = " ","Registration Fee","Deposit Contribution","Share Contribution",Loan,"Loan Repayment",Withdrawal,"Interest Due","Interest Paid",Investment,"Dividend Paid","Processing Fee","Withholding Tax","BBF Contribution";
        }
        field(68001; "Loan No"; Code[20])
        {
        }
        field(68002; "Group Code"; Code[20])
        {
        }
        field(68003; Type; Option)
        {
            OptionCaption = '" ,Registration,PassBook,Loan Insurance,Loan Application Fee,Down Payment"';
            OptionMembers = " ",Registration,PassBook,"Loan Insurance","Loan Application Fee","Down Payment";
        }
        field(68004; "Member Name"; Text[30])
        {
        }
        field(68005; "Loan Product Type"; Code[20])
        {
        }
        field(68006; "Contract No."; Code[20])
        {
        }
        field(68007; "Contract Deliverable No."; Code[20])
        {
        }
        field(68008; "Contract Payment No."; Integer)
        {
        }
    }
}
