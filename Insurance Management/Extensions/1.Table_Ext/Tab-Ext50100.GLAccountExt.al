tableextension 50100 "G/L Account_Ext" extends "G/L Account"
{
    fields
    {
        field(50000; "Commitment Amount"; Decimal)
        {
            FieldClass = FlowField;
            //CalcFormula = Sum("Commitment Register"."Committed Amount" WHERE(Account = FIELD("No.")));

        }
        field(50001; "Procurement Plan Amount"; Decimal)
        {
            FieldClass = FlowField;
            /*CalcFormula = Sum("Procurement Plan1"."Estimated Cost" WHERE("Source of Funds" = FIELD("No."),
                                                                          "Plan Year" = FIELD("Budget Filter"),
                                                                          "Department Code" = FIELD("Global Dimension 1 Filter")));
*/
        }
        field(50002; "Requisition Amount"; Decimal)
        {
        }
        field(50003; "Show on Claim"; Boolean)
        {
        }
        field(50004; "Asset Code Mandatory"; Boolean)
        {
        }
        field(50005; "Asset Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Fixed Asset";
        }
        field(50006; "Imprest/Loan Code Mandatory"; Boolean)
        {
        }
        /*field(50007; "Income/Expense"; Option)
        {
            OptionCaption = 'Income,Expense';
            OptionMembers = Income,Expense;

            trigger OnValidate();
            begin
                /*IF (("Income/Expense" <> xRec."Income/Expense")) THEN BEGIN// (xRec."Income/Balance" <> '') AND

                    AccountEvent.SetMessage('Income/Expense Changed');
                    AccountEvent.RUNMODAL;
                    //  OK:= AccountEvent.ReturnResult;
                    // IF OK THEN BEGIN
                    AccountHistory.INIT;
                    IF NOT AccountHistory.FIND('-') THEN
                        AccountHistory."Line No." := 1
                    ELSE BEGIN
                        AccountHistory.FIND('+');
                        AccountHistory."Line No." := AccountHistory."Line No." + 1;
                    END;

                    AccountHistory."Account No." := "No.";
                    AccountHistory."Date Of Event" := TODAY;
                    AccountHistory."Description of  Event" := 'Income/Expense Changed';
                    AccountHistory."Account Name" := Name;
                    AccountHistory."Old Value" := FORMAT(xRec."Income/Expense", 0, 9);
                    AccountHistory."New Value" := FORMAT("Income/Expense", 0, 9);
                    AccountHistory.Reason := AccountEvent.ReturnReason;
                    AccountHistory.INSERT;
                END;
            end;
        }*/
        /*field(50008; Type; Option)
        {
            OptionCaption = '" ,Asset,Liability,Income,Expense,Equity"';
            OptionMembers = " ",Asset,Liability,Income,Expense,Equity;

            trigger OnValidate();
            begin
                /*IF ((Type <> xRec.Type)) THEN BEGIN// (xRec."Income/Balance" <> '') AND

                    AccountEvent.SetMessage('Account Type Changed');
                    AccountEvent.RUNMODAL;
                    //  OK:= AccountEvent.ReturnResult;
                    // IF OK THEN BEGIN
                    AccountHistory.INIT;
                    IF NOT AccountHistory.FIND('-') THEN
                        AccountHistory."Line No." := 1
                    ELSE BEGIN
                        AccountHistory.FIND('+');
                        AccountHistory."Line No." := AccountHistory."Line No." + 1;
                    END;

                    AccountHistory."Account No." := "No.";
                    AccountHistory."Date Of Event" := TODAY;
                    AccountHistory."Description of  Event" := 'Account Type Changed';
                    AccountHistory."Account Name" := Name;
                    AccountHistory."Old Value" := FORMAT(xRec.Type, 0, 9);
                    AccountHistory."New Value" := FORMAT(Type, 0, 9);
                    AccountHistory.Reason := AccountEvent.ReturnReason;
                    AccountHistory.INSERT;
                END;
            end;
        }*/
        field(50011; "Requested By"; Code[30])
        {
            TableRelation = "User Setup";
        }
        field(50012; "Effective Date"; Date)
        {
        }
    }
    var
    //AccountEvent: Page account eve
    //AccountHistory: Record 

}
