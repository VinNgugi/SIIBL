tableextension 50105 "Purchase HeaderExt" extends "Purchase Header"
{
    fields
    {
        field(50000; "Claim No."; Code[30])
        {
            TableRelation = Claim;
        }
        field(50001; "No. Of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments";
        }
        field(50002; "Contract No."; Code[20])
        {
            //TableRelation = Contracts WHERE ("No."=FIELD("Buy-from Vendor No."));
        }
        field(50003; "Deliverable No."; Code[20])
        {
            //TableRelation = "Contract Deliverables"."Delivery No." WHERE ("Contract No."=FIELD("Contract No."));
        }
        field(50004; "Payment No."; Integer)
        {
            //TableRelation = "Contract Payment schedule"."Payment No." WHERE ("Contract No."=FIELD("Contract No."));
        }
    }
}
