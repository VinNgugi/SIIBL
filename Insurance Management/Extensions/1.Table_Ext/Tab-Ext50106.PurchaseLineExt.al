tableextension 50106 "Purchase LineExt" extends "Purchase Line"
{
    fields
    {
        field(50000;"Contract No.";Code[20])
        {
            //TableRelation = Contracts;
        }
        field(50001;"Deliverable No.";Code[20])
        {
            //TableRelation = "Contract Deliverables"."Delivery No." WHERE ("Contract No."=FIELD("Contract No."));
        }
        field(50002;"Payment No.";Integer)
        {
            //TableRelation = "Contract Payment schedule"."Payment No." WHERE ("Contract No."=FIELD("Contract No."));

            trigger OnValidate();
            begin
                /*IF ContractPayline.GET("Contract No.","Payment No.") THEN
                  BEGIN
                    Quantity:=1;
                    "Direct Unit Cost":=ContractPayline.Amount;
                  END;*/
            end;
        }
        field(50003;"Budget Line";Code[20])
        {
        }
        field(50004;Budget;Decimal)
        {
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE ("G/L Account No."=FIELD("Budget Line")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005;Commitment;Decimal)
        {
            FieldClass = FlowField;
            //CalcFormula = Sum("Commitment Register"."Committed Amount" WHERE ("Account No."=FIELD("Budget Line")));
            Editable = false;
            
        }
        field(50006;Actual;Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE ("G/L Account No."=FIELD("Budget Line")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007;"Budget Filter";Code[20])
        {
            TableRelation = "G/L Budget Name";
        }
        field(50008;"Available Budget";Decimal)
        {
            Editable = false;
        }
    }
}
