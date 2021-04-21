tableextension 50112 "Purchases & Payables SetupExt" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Purch Req Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50001; "Store Requisition Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
    }
}
