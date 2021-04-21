tableextension 50108 "Bank Account Ledger EntryExt" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50000; "Pay Mode"; Code[10])
        {
            TableRelation = "Bank Account Ledger Entry";
        }
        field(50001; "Cheque Date"; Date)
        {
        }
        field(50003; Remarks; Text[80])
        {
        }
        field(50004; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(50005; "Rec and Pay Type"; Code[20])
        {
            //TableRelation = "Receipts and Payment Types";
        }
        field(50006; "Claim No."; Code[30])
        {
        }
        field(50007; "Policy No."; Code[30])
        {
        }
        field(50008; "Investment Code"; Code[20])
        {
        }
        field(50009; "No. Of Units"; Decimal)
        {
        }
        field(50010; Payee; Text[80])
        {
        }
        field(50011; "Expected Receipt date"; Date)
        {
        }
        field(50012; "Claimant ID"; Integer)
        {
        }
        field(50013; "Endorsement No."; Code[30])
        {
        }
        field(50014; "Insurance Trans Type"; Option)
        {
            OptionCaption = '" ,Premium,Commission,Tax,Wht,Excess,Claim Reserve,Claim Payment,Reinsurance Premium,Reinsurance Commission,Reinsurance Premium Taxes,Reinsurance Commission Taxes,Net Premium,Claim Recovery,Salvage,Reinsurance Claim Reserve"';
            OptionMembers = " ",Premium,Commission,Tax,Wht,Excess,"Claim Reserve","Claim Payment","Reinsurance Premium","Reinsurance Commission","Reinsurance Premium Taxes","Reinsurance Commission Taxes","Net Premium","Claim Recovery",Salvage,"Reinsurance Claim Reserve";
        }
        field(50015; "Period Reference"; Date)
        {
        }
        field(50016; "Investment Transcation Type"; Option)
        {
            OptionCaption = ',Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,Share-split,Premium,Discounts,Other Income,Expenses,Loan Repayment,Subsidy,Gain-Loss';
            OptionMembers = ,Acquisition,Disposal,Interest,Dividend,Bonus,Revaluation,"Share-split",Premium,Discounts,"Other Income",Expenses,"Loan Repayment",Subsidy,"Gain-Loss";
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
