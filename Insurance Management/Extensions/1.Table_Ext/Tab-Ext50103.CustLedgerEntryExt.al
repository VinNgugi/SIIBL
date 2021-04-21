tableextension 50103 "Cust. Ledger EntryExt" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Asset No"; Code[20])
        {
        }
        field(50001; "ED Code"; Code[50])
        {
        }
        field(50002; "Commissioner Name"; Text[50])
        {
        }
        field(50003; "Meeting ID"; Code[20])
        {
        }
        field(50004; "Meeting Description"; Text[50])
        {
        }
        field(50005; "Starting Date"; Date)
        {
        }
        field(50006; "Ending Date"; Date)
        {
        }
        field(50007; "Receipt and Payment Type"; Code[20])
        {
            //TableRelation = "Receipts and Payment Types";
        }
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
            OptionCaption = '" ,Premium,Commission,Tax,Wht,Excess,Claim Reserve,Claim Payment,Reinsurance Premium,Reinsurance Commission,Reinsurance Premium Taxes,Reinsurance Commission Taxes,Net Premium,Claim Recovery,Salvage,Reinsurance Claim Reserve,Reinsurance Recovery Payment ,Accrued Reinsurance Premium,Deposit Premium,XOL Adjustment Premium,UPR,IBNR,Loan Deposit"';
            OptionMembers = " ",Premium,Commission,Tax,Wht,Excess,"Claim Reserve","Claim Payment","Reinsurance Premium","Reinsurance Commission","Reinsurance Premium Taxes","Reinsurance Commission Taxes","Net Premium","Claim Recovery",Salvage,"Reinsurance Claim Reserve","Reinsurance Recovery Payment ","Accrued Reinsurance Premium","Deposit Premium","XOL Adjustment Premium",UPR,IBNR,"Loan Deposit";
        }
        field(50014; "Licensee No."; Code[20])
        {
        }
        field(50015; "Payment Type"; Option)
        {
            OptionMembers = " ",Levy,Penalty,Registration;
        }
        field(50031; "Investment Code"; Code[20])
        {
            TableRelation = "Fixed Asset";
        }
        field(50032; "No. Of Units"; Decimal)
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
        field(50033; "Investment Transcation Type"; Enum InvestmentTranscationType)
        {

        }
        field(50036; "AC Type"; Option)
        {
            OptionMembers = "Income Statement","Balance Sheet";
        }
        field(50037; "Gl Type"; Option)
        {
            OptionCaption = '" ,Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,Share-split,Premium,Discounts,Other Income,Expenses,Loan Repayment"';
            OptionMembers = " ",Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,"Share-split",Premium,Discounts,"Other Income",Expenses,"Loan Repayment",Subsidy;
        }
        field(50038; "Employee No."; Code[30])
        {
        }
        field(50039; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(50040; "Original Currency Amount"; Decimal)
        {
        }
        field(50041; Payee; Text[30])
        {
        }
        field(50042; "Original Currency"; Code[20])
        {
            TableRelation = Currency;
        }
        field(50043; "Expected Receipt date"; Date)
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
            TableRelation = "LIFE Treaty"."Treaty Code";
        }
        field(55004; "Addendum Code"; Integer)
        {
            TableRelation = "LIFE Treaty"."Addendum Code";
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
        field(55020; "Claim No."; Code[20])
        {
        }
        field(55021; "Claimant ID"; Integer)
        {
        }
        field(55022; "Insured ID"; Code[20])
        {
            TableRelation = Customer;
        }
        field(55023; "Endorsement No."; Code[30])
        {
        }
    }
}
